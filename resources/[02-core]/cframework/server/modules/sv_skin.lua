RegisterServerEvent('esx_skin:save', function(skin)
    local source <const> = source
	ESX.setSkin(source, skin)
end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local skin, job = ESX.getSkin(source), ESX.getJob(source)

	local jobSkin = {
		skin_male   = job.skin_male,
		skin_female = job.skin_female
	}

	cb(skin, jobSkin)
end)

RPC.register('cframework:getPlayerSkin', function()
	return ESX.getSkin(source)
end)

-- Commands
TriggerEvent('es:addGroupCommand', 'skin', 'admin', function(source, args, user)
	local id = tonumber(args[1])

    if id == nil then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', T("COMMANDS_INVALID_PLAYER_ID") } })
        return
    end

    --ESX.logAdminActions(source, "SKIN", tonumber(id))

	TriggerClientEvent('esx_skin:openSaveableMenu', id)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', T("COMMANDS_INSUFFICIENT_PERMS") } })
end, {help = _U('skin')})

RegisterNetEvent('cframework:openSkinMenuSurgery', function(target)
	local source = source
	local job = ESX.getJob(source)

	if job.name ~= 'ambulance' then TriggerClientEvent('cframework:notEnoughPermsToSurgery', source) return end

	if job.grade ~= 4 and job.grade ~= 5 then TriggerClientEvent('cframework:notEnoughPermsToSurgery', source) return end

	if target == 0 or target == -1 then return end

	TriggerClientEvent('esx_skin:openSaveableMenu', target)
end)
