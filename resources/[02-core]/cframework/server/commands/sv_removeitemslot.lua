


TriggerEvent('es:addGroupCommand', 'removeitemslot', 'superadmin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(args[1])
	local item    = args[2]
	local count   = (args[3] == nil and 1 or tonumber(args[3]))
    local slot    = (args[4] == nil and 1 or tonumber(args[4]))

	if count ~= nil then
		xPlayer.inventory.removeItem(item, count, slot)
		--ESX.logAdminItems(_source, "ITEM", tonumber(args[1]), item, ESX.GetItemLabel(item), count)
	else
		TriggerClientEvent('esx:showNotification', _source, _U('invalid_amount'))
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})
