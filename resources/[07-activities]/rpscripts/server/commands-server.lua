TriggerEvent('es:addGroupCommand', 'lookup', 'user', function(source, args, user)
	if args[1] and GetPlayerName(tonumber(args[1]))then
		TriggerClientEvent("commands:lookup", source, GetPlayerName(tonumber(args[1])))
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Get someones name from their server ID", params = {{name = "id", help = "player id"}}})

TriggerEvent('es:addGroupCommand', 'id', 'user', function(source, args, user)
	TriggerClientEvent('chatMessage', source, _U('commands_getid'), {239, 137, 47}, source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Returns your server id, usally what staff will ask you"})

TriggerEvent('es:addGroupCommand', 'addy', 'admin', function(source, args, user)
	if args[1] and tonumber(args[1]) ~= nil then
		TriggerClientEvent("commands:addy", source, args[1] + 0.01)
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect usage!")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = "Move up on the Y axis of your current position", params = {{name = "y", help = "how many units to move on the Y axis"}}})

TriggerEvent('es:addGroupCommand', 'colete', 'mod', function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(args[1])
	if xPlayer ~= nil then
		local value = xPlayer.getArmour()
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Colete:' .. value } })
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Jogador não existe' } })
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)

RegisterCommand('kickall', function(source, args)
    if source == 0 then
        for _, playerId in ipairs(GetPlayers()) do
			DropPlayer(playerId, 'Servidor a reiniciar, aguarda um pouco.')
			-- ('%s'):format('text') is same as string.format('%s', 'text)
		end
		TriggerEvent('cframework:serverAboutToClose')
    end
end, false)

RegisterCommand('vehdel', function(source, args)
    if source == 0 then
        TriggerClientEvent("wld:delallveh", -1)
    end
end, false)

RegisterCommand('players', function(source, args)
	if source == 0 then
        print('[^1Stats^0] Current player number -> ' .. #GetPlayers() )
    end
end, false)

RegisterCommand('ranuncio', function(source, args)
	if source == 0 then
        TriggerClientEvent("cframework:announce", -1, "~r~Anúncio", table.concat(args, " "), 10)
    end
end, false)

