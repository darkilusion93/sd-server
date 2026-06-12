

local function addArmoryWeapon(society, weapon, ammo)
	local inventory <const> = GetSharedInventory('society_' .. society)

    inventory.addItem(weapon, 1, nil, {ammo = ammo})
end

local function addArmoryItem(society, item, count)
	local inventory <const> = GetSharedInventory('society_' .. society)

    inventory.addItem(item, count)
end

RegisterServerEvent("cframework:buyPoliceShop", function(amount, selectedOption, items)
    local source <const> = source
    local job = ESX.getJob(source)
    local validItems, totalPrice = {}, 0

    amount = tonumber(amount)

    if amount == nil or amount <= 0 then
        amount = 1
    end

    if amount >= 25 then
        amount = 25
    end

    if job.name ~= "police" then
		return
	end

    for _, v in ipairs(items) do
        for _, v2 in ipairs(Config.Stations["police"].BuyMenu) do
            if v == v2.name then
                table.insert(validItems, v2.name)
                totalPrice += v2.price
            end
        end
    end

    if totalPrice == 0 then return end

	local vault = 'police'
	local account = GetSharedAccount('society_police')

	if selectedOption == "oficiais" then
		vault = 'sheriff'
	end

    if selectedOption == "sargentos" then
		vault = 'swat'
	end

    if selectedOption == "pracas" then
		vault = 'police'
	end

	if selectedOption == "swat" then
		vault = 'swat_chefe'
	end

	if account.money >= totalPrice * amount then
		account.removeMoney(totalPrice * amount)

        for _, item in ipairs(validItems) do
            if ESX.GetWeaponLabel(item) ~= nil then
                for _=1, amount, 1 do
                    addArmoryWeapon(vault, item, 0)
                end
            else
                addArmoryItem(vault, item, amount)
            end
        end

        TriggerClientEvent("cframework:boughtPoliceShop", source)
    else
        TriggerClientEvent("cframework:notEnoughMoneyOnPoliceVault", source)
	end
end)

RPC.register('cframework:buyPatrolKit', function(data)
	local source <const> = source
	local job <const> = ESX.getJob(source)
	local vault = 'police'

	if job.name ~= 'police' then --Cheater?
		return false
	end

	local account = GetSharedAccount('society_police')

	if data == "oficiais" then
		vault = 'sheriff'
	end

    if data == "sargentos" then
		vault = 'swat'
	end

    if data == "pracas" then
		vault = 'police'
	end

	if data == "swat" then
		vault = 'swat_chefe'
	end

	if account.money >= tonumber(5000) then
		account.removeMoney(5000)
		addArmoryWeapon(vault, 'WEAPON_COMBATPISTOL', 0)
		addArmoryWeapon(vault, 'WEAPON_STUNGUN', 0)
		addArmoryWeapon(vault, 'WEAPON_NIGHTSTICK', 0)
		addArmoryWeapon(vault, 'WEAPON_FLASHLIGHT', 0)

		return true
	end

	return false
end)
