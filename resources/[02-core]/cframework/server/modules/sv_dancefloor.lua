

local danceFloors = LoadDanceFloor()
local runningDanceFloors = {}


RegisterServerEvent('cframework:playDanceFloorMusic', function(danceFloorId, songYtId, serverSources)
    local source <const> = source

    if danceFloors.locations[danceFloorId] == nil then
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - vector3(danceFloors.locations[danceFloorId].djbooth.x, danceFloors.locations[danceFloorId].djbooth.y, danceFloors.locations[danceFloorId].djbooth.z)) > 10.0 then
        return
    end

    if runningDanceFloors[danceFloorId] == nil then
        runningDanceFloors[danceFloorId] = {}
        runningDanceFloors[danceFloorId].volume = 100
    end

    runningDanceFloors[danceFloorId].music = songYtId
    runningDanceFloors[danceFloorId].startTime = os.time()

	for player, _ in pairs(serverSources) do
		TriggerClientEvent('cframework:danceFloorStartPlaying', player, danceFloorId, songYtId, 0)
	end
end)

RegisterServerEvent('cframework:setDanceFloorVolume', function(danceFloorId, volume, serverSources)
    if danceFloors.locations[danceFloorId] == nil then
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - vector3(danceFloors.locations[danceFloorId].djbooth.x, danceFloors.locations[danceFloorId].djbooth.y, danceFloors.locations[danceFloorId].djbooth.z)) > 10.0 then
        return
    end

    if runningDanceFloors[danceFloorId] == nil then
        runningDanceFloors[danceFloorId] = {}
        runningDanceFloors[danceFloorId].music = nil
        runningDanceFloors[danceFloorId].startTime = os.time()
    end

    runningDanceFloors[danceFloorId].volume = volume

	for player, _ in pairs(serverSources) do
		TriggerClientEvent('cframework:danceFloorSetVolume', player, danceFloorId, volume)
	end
end)

RegisterServerEvent('cframework:syncDanceFloorMusic', function(danceFloorId)
    local source <const> = source

    if danceFloors.locations[danceFloorId] == nil or runningDanceFloors[danceFloorId] == nil then
        return
    end

    if #(GetEntityCoords(GetPlayerPed(source)) - vector3(danceFloors.locations[danceFloorId].dancefloor.x, danceFloors.locations[danceFloorId].dancefloor.y, danceFloors.locations[danceFloorId].dancefloor.z)) > danceFloors.locations[danceFloorId].dancefloor.r then
        return
    end

    local music <const> = runningDanceFloors[danceFloorId].music
    local volume <const> = runningDanceFloors[danceFloorId].volume
    local startTime <const> = runningDanceFloors[danceFloorId].startTime
    local elapsedTime <const> = os.time() - startTime

    TriggerClientEvent('cframework:danceFloorStartPlaying', source, danceFloorId, music, elapsedTime)

    if music ~= nil then
        TriggerClientEvent('cframework:danceFloorSetVolume', source, danceFloorId, volume)
    end
end)