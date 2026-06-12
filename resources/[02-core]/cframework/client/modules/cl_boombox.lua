

local lastEntity = nil
local currentData = nil
local closestDistance = -1
local carryingBoombox = false

local function startAnimation(lib,anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end)
end

local function playBoomboxMusic()
    if not currentData or not DoesEntityExist(currentData) then
        return
    end

    if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
        return
    end

    TriggerEvent('chud:textmenu', T("BOOMBOX_PLAY_MUSIC"), T("BOOMBOX_SPEAKER"), function(value2)
        if value2 ~= "" then
            local players <const> = ESX.Game.GetPlayersInArea(GetEntityCoords(currentData), 25.0)
            local serverSources = {}

            for _, playerId in ipairs(players) do
                serverSources[GetPlayerServerId(playerId)] = true
            end

            TriggerServerEvent('cframework:playBoomboxMusic', NetworkGetNetworkIdFromEntity(currentData), value2, serverSources)
            TriggerEvent('esx_inventoryhud:doClose')
        end
    end)
end

local function setVolume()
    if not currentData or not DoesEntityExist(currentData) then
        return
    end

    if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
        return
    end

    TriggerEvent('chud:textmenu', T("BOOMBOX_VOLUME_INPUT_RANGE"), T("BOOMBOX_SPEAKER"), function(value2)
        if value2 ~= "" and tonumber(value2) ~= nil then
            local value <const> = tonumber(value2)
            if value < 0 or value > 100 then
                ESX.ShowNotification(T("BOOMBOX_VOLUME_RANGE"), "error")
            else
                local players <const> = ESX.Game.GetPlayersInArea(GetEntityCoords(currentData), 25.0)
                local serverSources = {}

                for _, playerId in ipairs(players) do
                    serverSources[GetPlayerServerId(playerId)] = true
                end

                TriggerServerEvent('cframework:setBoomboxVolume', NetworkGetNetworkIdFromEntity(currentData), value, serverSources)
            end
        end

        TriggerEvent('esx_inventoryhud:doClose')
    end)
end

local function OpenBoomboxMenu()
    local elements <const> = {
        {label = T("BOOMBOX_STORE"), value = 'get_hifi'},
        {label = carryingBoombox and T("BOOMBOX_DROP") or T("BOOMBOX_CARRY"), value = 'carry_hifi'},
        {label = T("BOOMBOX_PLAY"), value = 'play'},
        {label = T("BOOMBOX_VOLUME"), value = 'volume'},
        {label = T("BOOMBOX_STOP"), value = 'stop'}
    }

    TriggerEvent('chud:menu', elements, T("BOOMBOX_SPEAKER"), function(value)
        local playerPed = PlayerPedId()

        if value == 'get_hifi' then
            TriggerEvent('esx_inventoryhud:doClose')

            startAnimation("anim@heists@narcotics@trash","pickup")
            Citizen.Wait(700)

            if currentData and DoesEntityExist(currentData) then
                if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
                    return
                end

                TriggerServerEvent('cframework:removeBoombox', NetworkGetNetworkIdFromEntity(currentData))
                currentData = nil
            end
            Citizen.Wait(500)
            ClearPedTasks(PlayerPedId())
        elseif value == 'play' then
            playBoomboxMusic()
        elseif value == 'carry_hifi' then
            if not currentData or not DoesEntityExist(currentData) then
                return
            end

            if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
                return
            end

            TriggerEvent('esx_inventoryhud:doClose')

            if carryingBoombox then
                DetachEntity(currentData, true, true)
                ClearPedTasks(PlayerPedId())
                PlaceObjectOnGroundProperly(currentData)
                TriggerEvent('cframework:placePropAnim')
                return
            end

            TriggerEvent('cframework:placePropAnim')
            TriggerServerEvent("cframework:requestControlOfVehicle", NetworkGetNetworkIdFromEntity(currentData))

            local curTime <const> = GetGameTimer()

            NetworkRequestControlOfEntity(currentData)

            while not NetworkHasControlOfEntity(currentData) do
                Citizen.Wait(0)

                if GetGameTimer() - curTime > 8000 then
                    ESX.ShowNotification(T("BOOMBOX_UNABLE_TO_PICKUP"), "error")
                    ClearPedTasks(PlayerPedId())
                    return
                end
            end

            AttachEntityToEntity(currentData, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.15, 0.0, 0.0, 0.0, true, true, false, false, 2, true)

            carryingBoombox = true

            Citizen.CreateThread(function()
                RequestAnimDict("misscarsteal4@meltdown")
                while not HasAnimDictLoaded("misscarsteal4@meltdown") do
                    Citizen.Wait(0)
                end

                while DoesEntityExist(currentData) and IsEntityAttachedToEntity(currentData, PlayerPedId()) do
                    Citizen.Wait(100)

                    if not IsEntityPlayingAnim(PlayerPedId(), "misscarsteal4@meltdown", "_rehearsal_camera_man", 3) then
                        TaskPlayAnim(PlayerPedId(), "misscarsteal4@meltdown", "_rehearsal_camera_man", 8.0, -8.0, -1, 51, 0, false, false, false)
                    end
                end

                carryingBoombox = false
            end)
        elseif value == 'stop' then
            if not currentData or not DoesEntityExist(currentData) then
                return
            end

            if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
                return
            end

            local players <const> = ESX.Game.GetPlayersInArea(GetEntityCoords(currentData), 25.0)
            local serverSources = {}

            for _, playerId in ipairs(players) do
                serverSources[GetPlayerServerId(playerId)] = true
            end

            TriggerServerEvent('cframework:playBoomboxMusic', NetworkGetNetworkIdFromEntity(currentData), nil, serverSources)
            TriggerEvent('esx_inventoryhud:doClose')
        elseif value == 'volume' then
            setVolume()
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed <const> = PlayerPedId()
        local coords <const> = GetEntityCoords(playerPed)

        local closestEntity = 0

        local object <const> = GetClosestObjectOfType(coords.x, coords.y, coords.z, 25.0, GetHashKey('prop_boombox_01'), false, false, false)

        if DoesEntityExist(object) then
            local objCoords <const> = GetEntityCoords(object)
            local distance <const> = #(coords - objCoords)

            closestDistance = distance
            closestEntity   = object
        end

        if closestDistance ~= -1 and closestDistance <= 25.0 then
            if lastEntity ~= closestEntity then
                lastEntity = closestEntity
                currentData = closestEntity

                TriggerServerEvent('cframework:syncBoomboxMusic', NetworkGetNetworkIdFromEntity(closestEntity))
            end
        else
            if lastEntity then
                lastEntity = nil
                currentData = nil
                closestDistance = -1
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if currentData and DoesEntityExist(currentData) and closestDistance <= 3.0 and closestDistance ~= -1 then
            if DoesEntityExist(GetEntityAttachedTo(currentData)) and GetEntityAttachedTo(currentData) ~= PlayerPedId() then
                goto jump
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if IsControlJustReleased(0, 38) then
                OpenBoomboxMenu()
            end

            if ESX.isHandcuffed() and GetEntityAttachedTo(currentData) == PlayerPedId() then
                TriggerServerEvent('cframework:removeBoombox', NetworkGetNetworkIdFromEntity(currentData))
            end

            ::jump::
        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('cframework:boomboxStartPlaying', function(netId, music, elapsedTime)
    local propEntity <const> = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(propEntity) then
        return
    end

    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(propEntity)) > 25.0 then
        return
    end

    if music == nil then
        SendNUIMessage({action = 'stopBoomboxMusic'})
        return
    end

    SendNUIMessage({action = 'playBoomboxMusic', music = music, elapsedTime = elapsedTime, distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(propEntity)), maxDistance = 25.0})

    Citizen.CreateThread(function()
        while DoesEntityExist(propEntity) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(propEntity)) <= 25.0 do
            Citizen.Wait(25)
            SendNUIMessage({action = 'updateBoomboxDistance', distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(propEntity))})
        end

        Citizen.Wait(1000)

        SendNUIMessage({action = 'stopBoomboxMusic'})
    end)
end)

RegisterNetEvent('cframework:boomboxSetVolume', function(netId, volume)
    local propEntity <const> = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(propEntity) then
        return
    end

    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(propEntity)) > 25.0 then
        return
    end

    SendNUIMessage({action = 'setBoomboxVolume', volume=volume, netId=netId})
end)
