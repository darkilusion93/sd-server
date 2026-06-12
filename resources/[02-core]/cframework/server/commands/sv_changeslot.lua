


TriggerEvent('es:addGroupCommand', 'changeslot', 'superadmin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(args[1])
	--local item    = args[2]
	local fromSlot   = (args[2] == nil and 1 or tonumber(args[2]))
    local toSlot    = (args[3] == nil and 1 or tonumber(args[3]))


	xPlayer.inventory.transferToSlot(fromSlot, toSlot)

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})
