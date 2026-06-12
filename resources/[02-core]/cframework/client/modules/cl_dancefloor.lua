

local danceFloors = LoadDanceFloor()
local inBooth = false

Citizen.CreateThread(function()
    for k, v in pairs(danceFloors.locations) do
        exports.ft_libs:AddMarker("dancefloor_booth_" .. k, {type = 50, x = v.djbooth.x, y = v.djbooth.y, z = v.djbooth.z, weight = 1, height = 1, red = 132, green = 169, blue = 140, showDistance = 25})
        exports.ft_libs:AddTrigger("dancefloor_booth_" .. k, {x = v.djbooth.x, y = v.djbooth.y, z = v.djbooth.z, weight = 1, height = 2,
        enter = {eventClient = "djboothEnteredMarker"}, exit = {eventClient = "djboothExitedMarker"}, data = k, active = {}})

        exports.ft_libs:AddTrigger("dancefloor_dancefloor_" .. k, {x = v.dancefloor.x, y = v.dancefloor.y, z = v.dancefloor.z, weight = v.dancefloor.r, height = 10,
        enter = {eventClient = "danceFloorEnteredMarker"}, exit = {eventClient = "danceFloorExitedMarker"}, data = k, active = {}})
    end
end)

local function playMusic(danceFloorId)
    TriggerEvent('chud:textmenu', T("BOOMBOX_PLAY_MUSIC"), T("BOOMBOX_SPEAKER"), function(value2)
        if value2 ~= "" then
            local players <const> = ESX.Game.GetPlayersInArea(danceFloors.locations[danceFloorId].dancefloor, danceFloors.locations[danceFloorId].dancefloor.r)
            local serverSources = {}

            for _, playerId in ipairs(players) do
                serverSources[GetPlayerServerId(playerId)] = true
            end

            TriggerServerEvent('cframework:playDanceFloorMusic', danceFloorId, value2, serverSources)
            TriggerEvent('esx_inventoryhud:doClose')
        end
    end)
end

local function setVolume(danceFloorId)
    TriggerEvent('chud:textmenu', T("BOOMBOX_VOLUME_INPUT_RANGE"), T("BOOMBOX_SPEAKER"), function(value2)
        if value2 ~= "" and tonumber(value2) ~= nil then
            local value <const> = tonumber(value2)
            if value < 0 or value > 100 then
                ESX.ShowNotification(T("BOOMBOX_VOLUME_RANGE"), "error")
            else
                local players <const> = ESX.Game.GetPlayersInArea(danceFloors.locations[danceFloorId].dancefloor, danceFloors.locations[danceFloorId].dancefloor.r)
                local serverSources = {}

                for _, playerId in ipairs(players) do
                    serverSources[GetPlayerServerId(playerId)] = true
                end

                TriggerServerEvent('cframework:setDanceFloorVolume', danceFloorId, value, serverSources)
            end
        end

        TriggerEvent('esx_inventoryhud:doClose')
    end)
end

local function openBoothMenu(danceFloorId)
    local elements <const> = {
        {label = T("BOOMBOX_PLAY"), value = 'play'},
        {label = T("BOOMBOX_VOLUME"), value = 'volume'},
        {label = T("BOOMBOX_STOP"), value = 'stop'}
    }

    TriggerEvent('chud:menu', elements, T("BOOMBOX_SPEAKER"), function(value)
        if value == 'play' then
            playMusic(danceFloorId)
        elseif value == 'stop' then
            local players <const> = ESX.Game.GetPlayersInArea(danceFloors.locations[danceFloorId].dancefloor, danceFloors.locations[danceFloorId].dancefloor.r)
            local serverSources = {}

            for _, playerId in ipairs(players) do
                serverSources[GetPlayerServerId(playerId)] = true
            end

            TriggerServerEvent('cframework:playDanceFloorMusic', danceFloorId, nil, serverSources)
            TriggerEvent('esx_inventoryhud:doClose')
        elseif value == 'volume' then
            setVolume(danceFloorId)
        end
    end)
end

AddEventHandler('djboothEnteredMarker', function(danceFloorId)
    inBooth = true

    Citizen.CreateThread(function()
        while inBooth do

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            openBoothMenu(danceFloorId)

            ::final::
        end
    end)
end)

AddEventHandler('djboothExitedMarker', function()
    inBooth = false
end)

AddEventHandler('danceFloorEnteredMarker', function(danceFloorId)
    TriggerServerEvent('cframework:syncDanceFloorMusic', danceFloorId)
end)

RegisterNetEvent('cframework:danceFloorStartPlaying', function(danceFloorId, music, elapsedTime)
    local danceFloorLocation <const> = danceFloors.locations[danceFloorId]

    if danceFloorLocation == nil then
        return
    end

    local playerPed <const> = PlayerPedId()
    local playerCoords <const> = GetEntityCoords(playerPed)

    if #(playerCoords - vector3(danceFloorLocation.dancefloor.x, danceFloorLocation.dancefloor.y, danceFloorLocation.dancefloor.z)) > danceFloorLocation.dancefloor.r then
        return
    end

    if music == nil then
        SendNUIMessage({action = 'stopBoomboxMusic'})
        return
    end

    SendNUIMessage({action = 'playBoomboxMusic', music = music, elapsedTime = elapsedTime, maxDistance = danceFloorLocation.dancefloor.r, distance = #(GetEntityCoords(PlayerPedId()) - vector3(danceFloorLocation.dancefloor.x, danceFloorLocation.dancefloor.y, danceFloorLocation.dancefloor.z))})

    Citizen.CreateThread(function()
        while #(GetEntityCoords(PlayerPedId()) - vector3(danceFloorLocation.dancefloor.x, danceFloorLocation.dancefloor.y, danceFloorLocation.dancefloor.z)) <= danceFloorLocation.dancefloor.r do
            Citizen.Wait(25)
            SendNUIMessage({action = 'updateBoomboxDistance', distance = #(GetEntityCoords(PlayerPedId()) - vector3(danceFloorLocation.dancefloor.x, danceFloorLocation.dancefloor.y, danceFloorLocation.dancefloor.z))})
        end

        Citizen.Wait(1000)

        SendNUIMessage({action = 'stopBoomboxMusic'})
    end)
end)

RegisterNetEvent('cframework:danceFloorSetVolume', function(danceFloorId, volume)
    local danceFloorLocation <const> = danceFloors.locations[danceFloorId]

    if danceFloorLocation == nil then
        return
    end

    local playerPed <const> = PlayerPedId()
    local playerCoords <const> = GetEntityCoords(playerPed)

    if #(playerCoords - vector3(danceFloorLocation.dancefloor.x, danceFloorLocation.dancefloor.y, danceFloorLocation.dancefloor.z)) > danceFloorLocation.dancefloor.r then
        return
    end

    SendNUIMessage({action = 'setBoomboxVolume', volume=volume, netId=danceFloorId})
end)