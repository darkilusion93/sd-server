

local boostingData = LoadBoosting()
local stealingPlate = false

local function startPlateSteal(vehicleEntity)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, false)

    NetworkRequestControlOfEntity(vehicleEntity)
    while not NetworkHasControlOfEntity(vehicleEntity) do
        Citizen.Wait(0)
    end

    Citizen.Wait(10000)
    SetVehicleNumberPlateText(vehicleEntity, "")
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent("cframework:boostingPlateStolen")
end

RegisterNetEvent("cframework:boostingBeginStealPlate", function(vehicleNetId, missionType)
    local playerPed <const> = PlayerPedId()
    local vehicleEntity <const> = NetworkGetEntityFromNetworkId(vehicleNetId)

    stealingPlate = true

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_STEAL_VEHICLE_PLATE"))

    Citizen.CreateThread(function()
        while stealingPlate do
            Citizen.Wait(0)

            if #(GetEntityCoords(playerPed) - GetEntityCoords(vehicleEntity)) > 3.0 then
                goto continue
            end

            ESX.ShowHelpNotification(T("BOOSTING_PRESS_TO_STEAL_PLATE"))

            if IsControlJustReleased(0, 38) then -- E
                stealingPlate = false
                startPlateSteal(vehicleEntity)
            end

            ::continue::
        end
    end)
end)

RegisterNetEvent("cframework:boostingCompleteStealPlate", function()
    stealingPlate = false
    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_STEAL_VEHICLE_PLATE_SUCCESS"))
end)