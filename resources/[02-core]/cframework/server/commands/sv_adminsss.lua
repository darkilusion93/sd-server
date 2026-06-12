


TriggerEvent('es:addGroupCommand', 'adminsss', 'mod', function(source, args, user)
    for k,v in ipairs(ESX.GetAdminPlayers()) do
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM: ', '(' .. v .. ') ' .. GetPlayerName(v) and GetPlayerName(v) or ""} })
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})
