

local placedBoomboxes = {}

ESX.RegisterUsableItem('hifi', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

	inventory.removeItem('hifi', 1, slot)

	TriggerClientEvent('cframework:placePropAnim', source)

	Citizen.Wait(1000)

	local coords <const> = GetEntityCoords(GetPlayerPed(source))
	local propEntity <const> = CreateObject(`prop_boombox_01`, coords.x, coords.y, coords.z - 1.0, true, true, false)

	while not DoesEntityExist(propEntity) do
		Citizen.Wait(0)
	end

	FreezeEntityPosition(propEntity, true)

	placedBoomboxes[propEntity] = { music = nil, volume = 100, startTime = 0 }
end)

RegisterServerEvent('cframework:removeBoombox', function(netId)
	local source = source
    local inventory <const> = ESX.getInvContainer(source)
	local propEntity <const> = NetworkGetEntityFromNetworkId(netId)

	if placedBoomboxes[propEntity] == nil then
		return
	end

	DeleteEntity(propEntity)
	placedBoomboxes[propEntity] = nil

    inventory.addItem('hifi', 1)
end)

RegisterServerEvent('cframework:playBoomboxMusic', function(netId, songYtId, serverSources)
    local propEntity <const> = NetworkGetEntityFromNetworkId(netId)

    if placedBoomboxes[propEntity] == nil then
        return
    end

    placedBoomboxes[propEntity].music = songYtId
    placedBoomboxes[propEntity].startTime = os.time()

	for player, _ in pairs(serverSources) do
		TriggerClientEvent('cframework:boomboxStartPlaying', player, netId, songYtId, 0)
	end
end)

RegisterServerEvent('cframework:setBoomboxVolume', function(netId, volume, serverSources)
    local propEntity <const> = NetworkGetEntityFromNetworkId(netId)

    if placedBoomboxes[propEntity] == nil then
        return
    end

    placedBoomboxes[propEntity].volume = volume

	for player, _ in pairs(serverSources) do
		TriggerClientEvent('cframework:boomboxSetVolume', player, netId, volume)
	end
end)

RegisterServerEvent('cframework:syncBoomboxMusic', function(netId)
    local source = source
    local propEntity = NetworkGetEntityFromNetworkId(netId)

    if placedBoomboxes[propEntity] == nil then
        return
    end

    local music <const> = placedBoomboxes[propEntity].music
    local volume <const> = placedBoomboxes[propEntity].volume
    local startTime <const> = placedBoomboxes[propEntity].startTime
    local elapsedTime <const> = os.time() - startTime

    TriggerClientEvent('cframework:boomboxStartPlaying', source, netId, music, elapsedTime)

    if music ~= nil then
        TriggerClientEvent('cframework:boomboxSetVolume', source, netId, volume)
    end
end)