local AccountsIndex, Accounts, SharedAccounts = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account')

    if result == nil then return end

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			--for j=1, #result2, 1 do
			--	local addonAccount = CreateAddonAccount(name, result2[j].owner, result2[j].money)
			--	Accounts[name][result2[j].owner] = addonAccount
			--end
		end
	end
end)

function RegisterSharedAccount(name)
    if SharedAccounts[name] ~= nil then
        return
    end

    local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
        ['@account_name'] = name
    })

    if result == nil then return end

    local money = nil

    if #result == 0 then
        MySQL.Sync.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
            ['@account_name'] = name,
            ['@money']        = 0
        })

        money = 0
    else
        money = result[1].money
    end

    local addonAccount   = CreateAddonAccount(name, nil, money)
    SharedAccounts[name] = addonAccount
end

function GetAccount(name, owner)
    if Accounts[name][owner] == nil then
        local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE owner = @owner', {
			['@owner'] = owner
		})

		for j=1, #result2, 1 do
			if result2 ~= nil and Accounts[result2[j].account_name][result2[j].owner] == nil then
				local addonAccount = CreateAddonAccount(result2[j].account_name, result2[j].owner, result2[j].money)
				Accounts[result2[j].account_name][result2[j].owner] = addonAccount
			end
		end
    end

	return Accounts[name][owner]
end

function GetSharedAccount(name)
	return SharedAccounts[name]
end

AddEventHandler('esx_addonaccount:getAccount', function(name, owner, cb)
	cb(GetAccount(name, owner))
end)

AddEventHandler('esx_addonaccount:getSharedAccount', function(name, cb)
	cb(GetSharedAccount(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local addonAccounts = {}
	local doQuery = false

	for i=1, #AccountsIndex, 1 do
		local name    = AccountsIndex[i]
		local account = Accounts[name][xPlayer.identifier]

		if account == nil then
			doQuery = true
		end
	end

	if doQuery then
		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier
		})

		for j=1, #result2, 1 do
			if result2 ~= nil and Accounts[result2[j].account_name][result2[j].owner] == nil then
				local addonAccount = CreateAddonAccount(result2[j].account_name, result2[j].owner, result2[j].money)
				Accounts[result2[j].account_name][result2[j].owner] = addonAccount
			end
		end
	end

	for i=1, #AccountsIndex, 1 do
		local name    = AccountsIndex[i]
		local account = Accounts[name][xPlayer.identifier]

		if account == nil then
			MySQL.Async.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
				['@account_name'] = name,
				['@money']        = 0,
				['@owner']        = xPlayer.identifier
			})

			account = CreateAddonAccount(name, xPlayer.identifier, 0)
			Accounts[name][xPlayer.identifier] = account
		end

		table.insert(addonAccounts, account)
	end

	xPlayer.set('addonAccounts', addonAccounts)
end)