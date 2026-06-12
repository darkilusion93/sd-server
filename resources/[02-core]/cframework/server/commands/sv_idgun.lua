


TriggerEvent('es:addGroupCommand', 'idgun', 'mod', function(source, args, user)
	TriggerClientEvent('idgun', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'IDGUN', params = {{name = "playerId", help = _U('command_playerid_param')}}})
