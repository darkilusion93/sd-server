

local comservData = LoadCommunityService()

TriggerEvent('es:addGroupCommand', 'comserv', 'admin', function(source, args, user)
	local reason = "Nenhuma razão especificada"
    local amount = tonumber(args[2])

	if amount <= 0 then TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } ) return end
	if args[3] == nil then TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), "Razão inválida" } } ) return end

    if amount > 1000000 then
        amount = 1000000
    end

	if args[3] ~= nil then
		-- Concatenate elements from index 3 to last into a string separated by spaces
		local result = ""
		for i = 3, #args do
			result = result .. args[i] .. " "
		end

		-- Remove trailing space
		reason = string.sub(result, 1, -2)
	end

	if args[1] and GetPlayerName(args[1]) ~= nil and amount and not string.match(args[1], "steam") then
		TriggerEvent('esx_sendToCommunityService', tonumber(args[1]), amount, reason)

		--ESX.logComservData(source, "APLICAR", tonumber(args[1]), reason, amount)
	elseif amount and string.match(args[1], "steam") then
		local yPlayer = ESX.GetPlayerFromIdentifier(args[1])

		if yPlayer ~= nil then
			TriggerEvent('esx_sendToCommunityService', tonumber(yPlayer.source), amount, reason)

			--ESX.logComservData(source, "APLICAR", tonumber(yPlayer.source), reason, amount)
		else
			if cachedUsers[args[1]] ~= nil then 
				cachedUsers[args[1]].communityservice = amount
			end

			MySQL.Async.execute('UPDATE users SET `communityservice` = @communityservice WHERE identifier = @identifier', {
				['@communityservice'] = amount,
				['@identifier'] = args[1],
			})

			--ESX.logComservData(source, "APLICAR OFFLINE", args[1], reason, amount)
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id_or_actions') } } )
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('give_player_community'), params = {{name = "id", help = _U('target_id')}, {name = "actions", help = _U('action_count_suggested')}}})
_U('system_msn')


TriggerEvent('es:addGroupCommand', 'endcomserv', 'admin', function(source, args, user)
	if args[1] then
		if args[2] == nil then TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), "Razão inválida" } } ) return end

		local reason = "Nenhuma razão especificada"
	
		if args[2] ~= nil then
			-- Concatenate elements from index 3 to last into a string separated by spaces
			local result = ""
			for i = 2, #args do
				result = result .. args[i] .. " "
			end
	
			-- Remove trailing space
			reason = string.sub(result, 1, -2)
		end

		if GetPlayerName(args[1]) ~= nil then
			--ESX.logComservData(source, "RETIRAR", tonumber(args[1]), reason, ESX.getActionsRemaining(tonumber(args[1])))
			
			TriggerEvent('esx_communityservice:endCommunityServiceCommand', tonumber(args[1]), 7631)
		else
			TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('invalid_player_id')  } } )
		end
	else
		TriggerEvent('esx_communityservice:endCommunityServiceCommand', source, 7631)
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { _U('system_msn'), _U('insufficient_permissions') } })
end, {help = _U('unjail_people'), params = {{name = "id", help = _U('target_id')}}})


AddEventHandler('esx_communityservice:endCommunityServiceCommand', function(source, key)
	if not key or key ~= 7631 then
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Destino Anti-Cheat : Comserv', nil, false)
		return
	end
	if source ~= nil then
		releaseFromCommunityService(source)
	end
end)

local comservloc = {
	vector3(1679.8, 2503.9, 45.56),
	vector3(1677.91, 2501.49, 45.56),
	vector3(1675.25, 2503.82, 45.56),
	vector3(1672.88, 2506.02, 45.56),
	vector3(1670.46, 2508.2, 45.56),
	vector3(1668.72, 2509.89, 45.56),
	vector3(1670.74, 2512.4, 45.56),
	vector3(1672.72, 2517.75, 45.56),
	vector3(1667.86, 2517.64, 45.56),
	vector3(1663.68, 2520.92, 45.56),
	vector3(1660.08, 2517.46, 45.56),
	vector3(1656.36, 2512.46, 45.56),
	vector3(1658.4, 2506.67, 45.56)
}

local exhaustedComservLocation = {}

RegisterServerEvent('esx_communityservice:removeAction', function(remaining)
	local source = source

	if exhaustedComservLocation[source] ~= nil and ESX.playerInsideLocation(source, exhaustedComservLocation[source], 1.5) then
		return
	end

	if not ESX.playerInsideLocation(source, comservloc, 10.0) then 
        return 
    end

	if not ESX.passedCooldown(source, 9850) then 
        return
    end

	local actions = ESX.getActionsRemaining(source)

	ESX.setActionsRemaining(source, actions - 1)

	exhaustedComservLocation[source] = { GetEntityCoords(GetPlayerPed(source)) }

	if actions - 1 ~= remaining then
		TriggerClientEvent('cframework:fixComservActions', source, actions - 1)
	end

	if actions - 1 == 0 then
		releaseFromCommunityService(source)
	end
end)


RegisterServerEvent('esx_communityservice:extendService')
AddEventHandler('esx_communityservice:extendService', function()

	local _source = source
	local identifier = GetPlayerIdentifiers(_source)[1]

	local actions = ESX.getActionsRemaining(_source)

	ESX.setActionsRemaining(_source, actions + comservData.ServiceExtensionOnEscape)
end)

AddEventHandler('esx_sendToCommunityService', function(target, actions_count, reason)
	local identifier = GetPlayerIdentifiers(target)[1]

	ESX.setActionsRemaining(target, actions_count)

	for k,admin in ipairs(ESX.GetAdminPlayers()) do
		if ESX.inAdmin(admin) then
			TriggerClientEvent('chat:addMessage', admin,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); border-radius: 20px;">{0}: {1}</div>',
				args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) }
			})
		end
    end

	--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_communityservice:inCommunityService', target, actions_count, reason)
end)


RegisterServerEvent('esx_communityservice:sendToCommunityService', function()
	local src = source

	TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat : Pior ratoeira de sempre', nil, false)
end)


RPC.register('sendToCommunityService', function(target, actions_count, key)
	local src = source
	if not key or key ~= 7631 then
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat : Comserv', nil, false)
		return
	end

	if target == -1 then
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat : Pôrca Pá', nil, false)
		return
	end

    if not ESX.inAdmin(src) then
        return
    end

	local identifier = GetPlayerIdentifiers(target)[1]

	ESX.setActionsRemaining(target, actions_count)

	for k,admin in ipairs(ESX.GetAdminPlayers()) do
		if ESX.inAdmin(admin) then
			TriggerClientEvent('chat:addMessage', admin,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); border-radius: 20px;">{0}: {1}</div>',
				args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) }
			})
		end
    end

	--TriggerClientEvent('chat:addMessage', -1, { args = { _U('judge'), _U('comserv_msg', GetPlayerName(target), actions_count) } })
	TriggerClientEvent('esx_policejob:unrestrain', target)
	TriggerClientEvent('esx_communityservice:inCommunityService', target, actions_count)
end)


function releaseFromCommunityService(target)

	local identifier = GetPlayerIdentifiers(target)[1]

	ESX.setActionsRemaining(target, 0)

	for k,admin in ipairs(ESX.GetAdminPlayers()) do
		if ESX.inAdmin(admin) then
			TriggerClientEvent('chat:addMessage', admin, { args = { _U('judge'), _U('comserv_finished', GetPlayerName(target)) }, color = { 147, 196, 109 } })
		end
    end

	TriggerClientEvent('esx_communityservice:finishCommunityService', target)
end
