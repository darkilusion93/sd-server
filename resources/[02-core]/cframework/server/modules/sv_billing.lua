

local billExpirationTime <const> = 1000 * 60 * 60 * 24 * 7 -- 7 days


local function payBill(source, id)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = ESX.getIdentifier(source)
	local bills, bill, billKey = cachedBilling[identifier], nil, 0

	for k,v in pairs(bills) do if v.id == id then bill = v billKey = k break end end

	if bill == nil then return false end

	local amount <const> = bill.amount

	local xTarget = ESX.GetPlayerFromIdentifier(bill.sender)
	local account = GetSharedAccount(bill.target)
	local governo = GetSharedAccount('society_governo')

    if account == nil then return false end

	if xPlayer.getBank() >= amount then
		xPlayer.removeAccountMoney('bank', amount)
		account.addMoney(ESX.Math.Round(amount/(1.0 + Config.IVA)))
		governo.addMoney(ESX.Math.Round(amount*Config.IVA))

		TriggerClientEvent('esx:showNotification', xPlayer.source, string.format(T("ACTIONS_PAID_INVOICE"), ESX.Math.GroupDigits(amount)), 'success')
		if xTarget ~= nil then
			TriggerClientEvent('esx:showNotification', xTarget.source, string.format(T("ACTIONS_RECEIVED_PAYMENT"), ESX.Math.GroupDigits(amount)), 'inform')
		end

		table.remove(cachedBilling[identifier], billKey)

		MySQL.Async.execute('DELETE from billing WHERE id = @id', { ['@id'] = id })

        ESX.addTransaction(identifier, math.random(1000, 100000), "personal", -amount, "bill", bill.label, T("ACTIONS_INVOICE_PAYMENT"))
        TriggerClientEvent("gbank:UpdateTransactions", source, ESX.getTransactions(identifier))


        if ESX.isTaxEvading(source) then
            local allBills <const> = cachedBilling[identifier] or {}
            local isEvading = false

            for _, b in pairs(allBills) do
                if os.time()*1000 - b.time > billExpirationTime then
                    isEvading = true
                    break
                end
            end

            if not isEvading then
                ESX.setTaxEvading(source, false)
            end
        end

		return true
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, T("ACTIONS_NO_MONEY"), 'error')

		return false
	end
end


local function checkExpiredBillings(source)
    local bills <const> = cachedBilling[ESX.getIdentifier(source)] or {}
    local billsToPay = {}
    local payedAllBills = true

    for _, bill in pairs(bills) do
    if bill.time and (os.time() * 1000 - bill.time > billExpirationTime) then
        table.insert(billsToPay, bill.id)
    end
end

    for _, id in ipairs(billsToPay) do
        local payed = payBill(source, id)

        if not payed then
            payedAllBills = false
        end
    end

    if not payedAllBills then
        ESX.setTaxEvading(source, true)
    end
end

AddEventHandler('esx:playerLoaded', function(source)
    checkExpiredBillings(source)
end)

RegisterServerEvent('cframework:sendBill', function(playerId, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)
	local sender = ""

	if xPlayer == nil then
		sender = "Server"
	else
		sender = xPlayer.identifier
	end

	local account = GetSharedAccount(sharedAccountName)

	if amount < 0 then
		--print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
	elseif account ~= nil and xTarget ~= nil then
		MySQL.Async.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
		{
			['@identifier']  = xTarget.identifier,
			['@sender']      = sender,
			['@target_type'] = 'society',
			['@target']      = sharedAccountName,
			['@label']       = label,
			['@amount']      = ESX.Math.Round(amount*1.15)
		}, function(insertId)
			if cachedBilling[xTarget.identifier] == nil then cachedBilling[xTarget.identifier] = {} end

			table.insert(cachedBilling[xTarget.identifier], {
				id          = insertId,
				identifier  = xTarget.identifier,
				sender      = sender,
				target_type = 'society',
				target      = sharedAccountName,
				label       = label,
				amount      = ESX.Math.Round(amount*1.15),
                time        = os.time()*1000
			})

			TriggerClientEvent('cframework:receiveBillPhoneNotify', xTarget.source, label)
			TriggerClientEvent('phoneRefreshBills', xTarget.source)
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	cb(cachedBilling[ESX.getIdentifier(source)])
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	cb(cachedBilling[ESX.getIdentifier(target)])
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
    cb(payBill(source, id))
end)