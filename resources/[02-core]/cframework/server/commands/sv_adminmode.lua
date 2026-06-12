


TriggerEvent('es:addGroupCommand', 'sairadmin', 'mod', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Não estás em modo admin.', 'error') return end

    TriggerEvent("cframework:leaveAdmin", source)
	TriggerClientEvent("cframework:leaveAdmin", source, source)
	ESX.setAdmin(source, false)

	--ESX.logAdminActions(source, "SAIRADMIN", source)
    --ESX.logStaffsIngame()

	if ESX.getGroup(source) ~= 'superadmin' then
		TriggerClientEvent('chatMessage', -1,"", {20, 200, 20}, "^1 STAFF ^0| " .. GetPlayerName(source) .. " saiu de modo admin")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'sairadmin', params = {}})


TriggerEvent('es:addGroupCommand', 'entraradmin', 'mod', function(source, args, user)
    if ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Já estás em modo admin.', 'error') return end

    TriggerEvent("cframework:enterAdmin", source)
	TriggerClientEvent("cframework:enterAdmin", source, source)
	ESX.setAdmin(source, true)

	--ESX.logAdminActions(source, "ENTRARADMIN", source)
    --ESX.logStaffsIngame()

	if ESX.getGroup(source) ~= 'superadmin' then
		TriggerClientEvent('chatMessage', -1,"", {20, 200, 20}, "^1 STAFF ^0| " .. GetPlayerName(source) .. " entrou em modo admin")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'entraradmin', params = {}})
