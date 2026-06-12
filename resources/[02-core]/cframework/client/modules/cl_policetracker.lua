local isTracking = false
local bigDataPoliceTracker = false
local policeTracker = {}

AddTextEntry('POLICETRACKBLIP', '~a~')

local function removeBigDataBlips()
    for k,v in pairs(policeTracker) do
        if v.sblip ~= nil then
            RemoveBlip(v.sblip)
            policeTracker[k].sblip = nil
        end
    end
end

local function createCrewThreads()
    Citizen.CreateThread(function()
        while isTracking do
            local myCoords = GetEntityCoords(PlayerPedId())

            for _, id in ipairs(GetActivePlayers()) do
                local playerPed = GetPlayerPed(id)

                if playerPed ~= PlayerPedId() then
                    local serverId = GetPlayerServerId(id)

                    if policeTracker['p' .. serverId] ~= nil and policeTracker['p' .. serverId].blip == nil then
                        policeTracker['p' .. serverId].blip = AddBlipForEntity(playerPed)
                        BeginTextCommandSetBlipName('POLICETRACKBLIP')
                        AddTextComponentSubstringPlayerName(policeTracker['p' .. serverId].name)
                        EndTextCommandSetBlipName(policeTracker['p' .. serverId].blip)

                        SetBlipColour(policeTracker['p' .. serverId].blip, 26)
                        SetBlipCategory(policeTracker['p' .. serverId].blip, 2)
                        SetBlipScale(policeTracker['p' .. serverId].blip, 0.8)
                    end

                    if policeTracker['p' .. serverId] ~= nil and policeTracker['p' .. serverId].blip ~= nil then
                        if policeTracker['p' .. serverId].isCriminal then
                            SetBlipColour(policeTracker['p' .. serverId].blip, 6)
                        else
                            SetBlipColour(policeTracker['p' .. serverId].blip, 26)
                        end
                    end
                end
            end

            for k, data in pairs(policeTracker) do
                if data.blip ~= nil and data.forceCoords ~= nil then
                    SetBlipCoords(data.blip, data.forceCoords.x, data.forceCoords.y, data.forceCoords.z)
                end

                if data.blip ~= nil and data.forceCoords ~= nil and #(myCoords - vector3(data.forceCoords.x, data.forceCoords.y, data.forceCoords.z)) >= 420.0 then
                    RemoveBlip(data.blip)
                    policeTracker[k].blip = nil
                end

                if data.blip ~= nil and not DoesEntityExist(GetPlayerPed(GetPlayerFromServerId(data.serverId))) and data.forceCoords == nil then
                    RemoveBlip(data.blip)
                    policeTracker[k].blip = nil
                end

                if data.blip ~= nil and DoesEntityExist(GetPlayerPed(GetPlayerFromServerId(data.serverId))) and not DoesBlipExist(GetBlipFromEntity(GetPlayerPed(GetPlayerFromServerId(data.serverId)))) and data.forceCoords == nil then
                    RemoveBlip(data.blip)
                    policeTracker[k].blip = nil
                end

                if data.blip == nil and data.forceCoords ~= nil and #(myCoords - vector3(data.forceCoords.x, data.forceCoords.y, data.forceCoords.z)) < 420.0 then
                    if GetPlayerServerId(PlayerId()) ~= data.serverId and policeTracker[k] ~= nil and policeTracker[k].blip == nil and policeTracker[k].sblip == nil then
                        policeTracker[k].blip = AddBlipForCoord(data.forceCoords.x, data.forceCoords.y, data.forceCoords.z)
                        BeginTextCommandSetBlipName('POLICETRACKBLIP')
                        AddTextComponentSubstringPlayerName(data.name)
                        EndTextCommandSetBlipName(policeTracker[k].blip)

                        if policeTracker[k].isCriminal then
                            SetBlipColour(policeTracker[k].blip, 6)
                        else
                            SetBlipColour(policeTracker[k].blip, 26)
                        end
                        SetBlipCategory(policeTracker[k].blip, 2)
                        SetBlipScale(policeTracker[k].blip, 0.8)
                    end
                end
            end
            Citizen.Wait(500)
        end
    end)
end

RegisterNetEvent('onPlayerDropped', function(serverId)
    if policeTracker['p' .. serverId] then
        policeTracker['p' .. serverId].blip = nil
    end
end)

RegisterNetEvent('cframework:loadPoliceTracker', function(trackedPlayers)
    for _, player in ipairs(trackedPlayers) do
        policeTracker['p' .. player.serverId] = {blip = nil, isCriminal = player.isCriminal, name = player.name, serverId = player.serverId}
    end

    if isTracking then return end

    isTracking = true
    createCrewThreads()
end)

RegisterNetEvent('cframework:unloadPoliceTracker', function()
    isTracking = false

    for _,v in pairs(policeTracker) do
        if v.blip ~= nil then RemoveBlip(v.blip) end
        if v.sblip ~= nil then RemoveBlip(v.sblip) end
    end

    policeTracker = {}
end)

RegisterNetEvent('cframework:removePoliceTrackerMember', function(serverId)
    if policeTracker['p' .. serverId] == nil then return end

    if policeTracker['p' .. serverId].blip ~= nil then
        RemoveBlip(policeTracker['p' .. serverId].blip)
    end

    if policeTracker['p' .. serverId].sblip ~= nil then
        RemoveBlip(policeTracker['p' .. serverId].sblip)
    end

    policeTracker['p' .. serverId] = nil
end)

RegisterNetEvent('cframework:addPoliceTrackerMember', function(serverId, isCriminal, playerName)
    policeTracker['p' .. serverId] = {blip = nil, isCriminal = isCriminal, name = playerName, serverId = serverId}
end)

RegisterNetEvent('cframework:forceCoordsPoliceTrackerMembers', function(serverId, forceCoords)
    if policeTracker['p' .. serverId] == nil then return end

    policeTracker['p' .. serverId].forceCoords = forceCoords
end)

AddEventHandler("cframework:pauseMenu", function(inPauseMenu)
    if not isTracking then return end

    if inPauseMenu then
        bigDataPoliceTracker = true
        TriggerServerEvent("cframework:bigDataPoliceTracker", true)
    else
        bigDataPoliceTracker = false
        TriggerServerEvent("cframework:bigDataPoliceTracker", false)
        removeBigDataBlips()
    end
end)

RegisterNetEvent("cframework:sendBigDataPoliceTracker", function(data)
    if not bigDataPoliceTracker then
        removeBigDataBlips()
        return
    end

    for _, player in pairs(data) do
        if policeTracker['p' .. player.serverId] == nil then
            policeTracker['p' .. player.serverId] = {blip = nil, isCriminal = player.isCriminal, name = player.name, serverId = player.serverId}
        end

        if GetPlayerServerId(PlayerId()) ~= player.serverId and policeTracker['p' .. player.serverId] ~= nil and policeTracker['p' .. player.serverId].blip == nil and policeTracker['p' .. player.serverId].sblip == nil then
            policeTracker['p' .. player.serverId].sblip = AddBlipForCoord(player.pos.x, player.pos.y, player.pos.z)
            BeginTextCommandSetBlipName('POLICETRACKBLIP')
            AddTextComponentSubstringPlayerName(player.name)
            EndTextCommandSetBlipName(policeTracker['p' .. player.serverId].sblip)

            if policeTracker['p' .. player.serverId].isCriminal then
                SetBlipColour(policeTracker['p' .. player.serverId].sblip, 6)
            else
                SetBlipColour(policeTracker['p' .. player.serverId].sblip, 26)
            end
            SetBlipCategory(policeTracker['p' .. player.serverId].sblip, 2)
            SetBlipScale(policeTracker['p' .. player.serverId].sblip, 0.8)
        end

        if policeTracker['p' .. player.serverId] ~= nil and policeTracker['p' .. player.serverId].sblip ~= nil then
            SetBlipCoords(policeTracker['p' .. player.serverId].sblip, player.pos.x, player.pos.y, player.pos.z)
        end

        if policeTracker['p' .. player.serverId] ~= nil and policeTracker['p' .. player.serverId].blip ~= nil and policeTracker['p' .. player.serverId].sblip ~= nil then
            RemoveBlip(policeTracker['p' .. player.serverId].sblip)
            policeTracker['p' .. player.serverId].sblip = nil
        end
    end
end)