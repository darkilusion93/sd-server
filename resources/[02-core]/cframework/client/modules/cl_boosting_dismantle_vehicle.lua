

local boostingData = LoadBoosting()
local dismantlingVehicle = false

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

local function PlayOpenAnim(ped)
    local dict <const> = "anim@heists@prison_heiststation@cop_reactions"
    local anim <const> = "cop_b_idle"

    LoadAnimDict(dict)
    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, 1500, 0, 0, false, false, false)
    Citizen.Wait(1500)
    ClearPedTasks(ped)
end

local function PlayCloseAnim(ped)
    local dict <const> = "anim@heists@prison_heiststation@cop_reactions"
    local anim <const> = "cop_b_idle"

    LoadAnimDict(dict)
    TaskPlayAnim(ped, dict, anim, 2.0, 2.0, 1200, 0, 0, false, false, false)
    Citizen.Wait(1200)
    ClearPedTasks(ped)
end

local function RemoveEngine(vehicle)
    SetVehicleEngineHealth(vehicle, -4000.0)
    SetVehicleEngineOn(vehicle, false, true, true)
end

local function startVehicleDismantle(vehicleEntity)
    local playerPed <const> = PlayerPedId()

    PlayOpenAnim(playerPed)

    NetworkRequestControlOfEntity(vehicleEntity)
    while not NetworkHasControlOfEntity(vehicleEntity) do
        Citizen.Wait(0)
    end

    SetVehicleDoorOpen(vehicleEntity, 4, false, false)

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
    Citizen.Wait(6000)
    ClearPedTasks(playerPed)

    TriggerServerEvent("cframework:boostingVehicleDismantled")
    RemoveEngine(vehicleEntity)

    PlayCloseAnim(playerPed)
    SetVehicleDoorShut(vehicleEntity, 4, false)
end

RegisterNetEvent("cframework:boostingBeginDismantleVehicle", function(vehicleNetId, missionType)
    local playerPed <const> = PlayerPedId()
    local vehicleEntity <const> = NetworkGetEntityFromNetworkId(vehicleNetId)

    dismantlingVehicle = true

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_DISMANTLE_VEHICLE"))

    Citizen.CreateThread(function()
        while dismantlingVehicle do
            Citizen.Wait(0)

            if #(GetEntityCoords(playerPed) - GetEntityCoords(vehicleEntity)) > 3.0 then
                goto continue
            end

            ESX.ShowHelpNotification(T("BOOSTING_PRESS_TO_DISMANTLE_VEHICLE"))

            if IsControlJustReleased(0, 38) then -- E
                dismantlingVehicle = false
                startVehicleDismantle(vehicleEntity)
            end

            ::continue::
        end
    end)
end)

RegisterNetEvent("cframework:boostingCompleteDismantleVehicle", function()
    dismantlingVehicle = false

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_VEHICLE_DISMANTLED_SUCCESS"))
end)