

local function removeSocietyMoney(society, amount)
	if tonumber(amount) < 0 then
		return false
	end

	local account = GetSharedAccount('society_' .. society)

	if account.money < tonumber(amount) then
		return false
	end

	account.removeMoney(amount)

	return true
end

RegisterServerEvent('cframework:buyItemSociety', function(itemName, amount)
	local source <const> = source
	local job <const>, price = ESX.getJob(source), 0
    local inventory <const> = ESX.getInvContainer(source)

	if amount <= 0 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_QUANTITY_NOT_VALID"), 'error')
		return
	end

	for i=1, #Config.Stations[job.name].BuyMenu, 1 do if Config.Stations[job.name].BuyMenu[i].name == itemName.name then 
		price = Config.Stations[job.name].BuyMenu[i].price * amount
		break end
	end

	if price <= 0 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_ERROR_CALCULATING_PRICE"), 'error')
		return
	end

	if not inventory.canAddItem(itemName.name, amount) then
		TriggerClientEvent('esx:showNotification', source, T("INVENTORY_FULL"), 'error')
		return
	end

	if not removeSocietyMoney(job.name, price) then TriggerClientEvent('esx:showNotification', source, T("GENERIC_NOT_ENOUGH_MONEY"), 'error')
		return
	end

    inventory.addItem(itemName.name, amount)

	--ESX.logOrgData(source, "COMPRAR", itemName.name, amount, job.name, job.label, itemName.label)
end)