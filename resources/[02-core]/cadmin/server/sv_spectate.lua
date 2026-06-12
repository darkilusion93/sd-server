ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)


RegisterCommand("spectate", function(source, args, user)
    TriggerClientEvent('esx_spectate:spectate', source)
end, false)

ESX.RegisterServerCallback("cframework:getSpectateData", function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(id)

    if not ESX.inAdmin(source) then
		-- If the player does not have admin privileges, show a notification and return false
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
        cb(nil)
		return false
	end

    if not DoesEntityExist(GetPlayerPed(id)) then
        cb(nil)
        return
    end

    local coords = GetEntityCoords(GetPlayerPed(id))
    local targetBucket = GetPlayerRoutingBucket(id)

    ESX.LogAdminActions(source, "SPECTATE", tonumber(id))
    SetPlayerRoutingBucket(source, targetBucket)

    if xPlayer ~= nil then
        cb(xPlayer, coords)
    end
end)

RegisterServerEvent('cframework:exitSpectate', function()
    local source = source

    SetPlayerRoutingBucket(source, 0)
end)


RegisterServerEvent('esx_spectate:getPlayers', function()
    local source = source
    local data = {}
    for _, playerId in ipairs(ESX.GetPlayers()) do
		local _data = {
			id = playerId,
			name = GetPlayerName(playerId) or "Unknown",
            playtime = ESX.getPlayTime(playerId) or 0,
        }

		table.insert(data, _data)
	end
	TriggerClientEvent('esx_spectate:getPlayers', source, data)
end)

ESX.RegisterServerCallback('esx_spectate:getOtherPlayerData', function(source, cb, target)
    local xPlayer = ESX.GetPlayerFromId(target)
    if xPlayer == nil then
	    cb({})
        return false
    end

    local data = {
        name = GetPlayerName(target),
        source = target,
        playtime = xPlayer.getPlayTime(),
        job = xPlayer.job,
        inventory = xPlayer.getInventory(),
        accounts = xPlayer.accounts,
        firstname = xPlayer.firstName,
        lastname = xPlayer.lastName,
        comserv = xPlayer.getActionsRemaining(),
        sex = "disabled",
        dob = "disabled",
        height = "disabled",
        bank = xPlayer.bank
    }

    TriggerEvent('esx_license:getLicenses', target, function(licenses)
        data.licenses = licenses
        cb(data)
    end)
end)
