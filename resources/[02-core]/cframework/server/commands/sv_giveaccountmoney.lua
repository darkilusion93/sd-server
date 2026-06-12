


TriggerEvent('es:addGroupCommand', 'giveaccountmoney', 'admin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(args[1])
    local inventory = xPlayer.getInvContainer()
	local account = args[2]
	local amount  = tonumber(args[3])

	if amount ~= nil then
		if account == "black_money" then
			inventory.addItem("black_money", amount)
			--ESX.logAdminItems(source, "GIVE MONEY", source, account, account, amount)
		else
			TriggerClientEvent('esx:showNotification', _source, _U('invalid_account'))
		end
	else
		TriggerClientEvent('esx:showNotification', _source, T("GENERIC_INVALID_AMOUNT"))
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveaccountmoney'), params = {{name = "id", help = _U('id_param')}, {name = "account", help = _U('account')}, {name = "amount", help = _U('money_amount')}}})
