


AddEventHandler("chatMessage", function(source, args, raw)
  CancelEvent()
end)

TriggerEvent('es:addGroupCommand', 'staff', 'mod', function(source, args, user)
	local playerName = GetPlayerName(source)
    local msg = table.concat(args, " ")

	TriggerClientEvent('chat:addMessage', -1, {
	    template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(242, 10, 10, 0.75); color: white; border-radius: 20px;"><i class="fa fa-exclamation-triangle">&ensp;<font color="#fffff">STAFF | {0}: <font color="#fffff">{1}</font></div>',
        args = { playerName, msg }
    })
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = '/staff mensagem'})


TriggerEvent('es:addGroupCommand', 's', 'mod', function(source, args, user)
	local playerName = GetPlayerName(source)
    local msg = table.concat(args, " ")

	for k,v in ipairs(ESX.GetAdminPlayers()) do
		TriggerClientEvent('3dme:chatPrivado', v, playerName, msg)
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = '/s mensagem privada'})
