

local boostingData = LoadBoosting()
local zoneBlip = nil

RegisterNetEvent("cframework:boostingBeginFindVehicle", function(coords, missionType)
    local missionData <const> = boostingData.missions[missionType]
    local searchZoneBlip <const> = AddBlipForRadius(coords.x, coords.y, coords.z, boostingData.findVehicleBlipRadius)

    SetBlipColour(searchZoneBlip, boostingData.findVehicleBlipColor) -- Red
    SetBlipAlpha(searchZoneBlip, 128)

    zoneBlip = searchZoneBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_VEHICLE_LOCATION"))
end)

RegisterNetEvent("cframework:boostingFinishFindVehicleBoost", function()
    if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
        RemoveBlip(zoneBlip)
    end

    zoneBlip = nil
end)

RegisterNetEvent("cframework:boostingAgroPeds", function(spawnLocation, createdPedsNetId)
    local playerPed <const> = PlayerPedId()

    Citizen.CreateThread(function()
        while true do
            local allPedsDeadOrGone = true

            while spawnLocation ~= nil and #(GetEntityCoords(playerPed) - spawnLocation.xyz) > 75.0 do
                Citizen.Wait(1000)
            end

            for _, netId in ipairs(createdPedsNetId) do
                local ped <const> = NetworkGetEntityFromNetworkId(netId)

                NetworkRequestControlOfEntity(ped)

                if DoesEntityExist(ped) then
                    local pedCoords <const> = GetEntityCoords(ped)
                    local distance <const> = #(GetEntityCoords(playerPed) - pedCoords)

                    if distance < 50.0 then
                        SetPedFleeAttributes(ped, 0, false)
                        SetPedCombatAttributes(ped, 0, true)
                        --SetPedCombatAttributes(ped, 1, true)
                        SetPedCombatAttributes(ped, 2, true)
                        SetPedCombatAttributes(ped, 3, true)
                        SetPedCombatAttributes(ped, 46, true)
                        SetPedCombatAbility(ped, 2)
                        SetPedCombatMovement(ped, 1)
                        SetPedAsCop(ped, true)
                        SetPedAccuracy(ped, 100)
                        SetPedCombatRange(ped, 2)
                        SetPedKeepTask(ped, true)
                        TaskCombatPed(ped, playerPed, 0, 16)
                    end
                end

                if DoesEntityExist(ped) and not IsEntityDead(ped) then
                    allPedsDeadOrGone = false
                end
            end

            if allPedsDeadOrGone then
                break
            end

            Citizen.Wait(1000)
        end
    end)
end)

RegisterNetEvent("cframework:boostingInitPed", function(netId, scenario, animDict, anim)
    while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
		Citizen.Wait(20)
	end

    local ped = NetworkGetEntityFromNetworkId(netId)

    -- Return if we are not the network owner
    if not NetworkHasControlOfEntity(ped) then
        return
    end

    Citizen.Wait(1000)

    if scenario ~= nil and scenario ~= "" then
        TaskStartScenarioInPlace(ped, scenario, 0, false)
    elseif animDict ~= nil and animDict ~= "" and anim ~= nil and anim ~= "" then
        ESX.PlayAnimOnPed(ped, animDict, anim, 8.0, -1, 0)
    end
end)