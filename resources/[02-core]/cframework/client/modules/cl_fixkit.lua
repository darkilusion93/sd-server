local isRepairingVehicle = false
local usableFixKits <const> = {
    ['fixkit'] = {
        [VEH_CLASS_COMPACT] = true,
        [VEH_CLASS_SEDAN] = true,
        [VEH_CLASS_SUV] = true,
        [VEH_CLASS_COUPES] = true,
        [VEH_CLASS_MUSCLE] = true,
        [VEH_CLASS_SPORTS_CLASSICS] = true,
        [VEH_CLASS_SPORTS] = true,
        [VEH_CLASS_SUPER] = true,
        [VEH_CLASS_MOTORCYCLES] = true,
        [VEH_CLASS_OFF_ROAD] = true,
        [VEH_CLASS_INDUSTRIAL] = true,
        [VEH_CLASS_UTILITY] = true,
        [VEH_CLASS_VANS] = true,
        [VEH_CLASS_CYCLES] = true,
        [VEH_CLASS_SERVICE] = true,
        [VEH_CLASS_EMERGENCY] = true,
        [VEH_CLASS_MILITARY] = true,
        [VEH_CLASS_COMMERCIAL] = true,
        [VEH_CLASS_TRAINS] = true
    },
    ['fixkith'] = {
        [VEH_CLASS_HELICOPTERS] = true,
        [VEH_CLASS_PLANES] = true,
    },
    ['fixkitb'] = {
        [VEH_CLASS_BOATS] = true,
    },
}

local function repairLoop()
    while isRepairingVehicle do
        local playerPed <const> = PlayerPedId()

        DisableControlAction(0, 30, true)
        DisableControlAction(0, 31, true)
        DisableControlAction(0, 32, true)
        DisableControlAction(0, 33, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 35, true)

        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
        DisableControlAction(0, 75, true)

        if not IsEntityPlayingAnim(playerPed, "mini@repair", "fixing_a_ped", 3) then
            TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 51, 0, false, false, false)
        end

        Citizen.Wait(0)
    end
end

RegisterNetEvent('cframework:onFixkit', function(type, slot)
    local playerPed <const> = PlayerPedId()
    local coords <const> = GetEntityCoords(playerPed)

    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        return
    end

    local vehicle <const> = IsPedInAnyVehicle(playerPed, false) and GetVehiclePedIsIn(playerPed, false) or GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if not DoesEntityExist(vehicle) then
        ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
        return
    end

    local class <const> = GetVehicleClass(vehicle)

    if not usableFixKits[type][class] then
        ESX.ShowNotification(T("CANT_USE_KIT_ON_VEHICLE_TYPE"), 'error')
        return
    end

    if GetIsVehicleEngineRunning(vehicle) then
        ESX.ShowNotification(T("CANT_REPAIR_WITH_VEHICLE_ON"), 'error')
        return
    end

    if GetVehicleBodyHealth(vehicle) == 0 then
        ESX.ShowNotification(T("CANT_REPAIR_EXPLODED_VEHICLE"), 'error')
        return
    end

    TriggerServerEvent('cframework:useFixkit', type, slot)

    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 51, 0, false, false, false)

    isRepairingVehicle = true

    Citizen.CreateThread(repairLoop)

    Citizen.Wait(20000)

    ClearPedTasks(playerPed)

    isRepairingVehicle = false

    if GetIsVehicleEngineRunning(vehicle) then
        ESX.ShowNotification(T("COULDNT_REPAIR_MOTOR_WAS_STARTED"), 'error')
        return
    end

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    ESX.ShowNotification(T("VEHICLES_REPAIRED"), 'success')
end)

RegisterNetEvent("cframework:onBlowtorchHijack", function(slot)
	local playerPed <const> = PlayerPedId()
	local coords <const> = GetEntityCoords(playerPed)
    local vehicle

	if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        return
    end

    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    end

    local chance <const>, alarm <const> = math.random(100), math.random(100)

    if not DoesEntityExist(vehicle) then
        return
    end

    if alarm <= 33 then
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
    end

    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
    TriggerServerEvent('cframework:useFixkit', "blowtorch", slot)

    Citizen.CreateThread(function()
        Citizen.Wait(10000)
        if chance <= 66 then
            SetVehicleDoorsLocked(vehicle, 1)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            ClearPedTasksImmediately(playerPed)
            ESX.ShowNotification(T("VEHICLES_UNLOCKED"), "success")
        else
            ESX.ShowNotification(T("VEHICLES_COULDNT_UNLOCK"), "error")
            ClearPedTasksImmediately(playerPed)
        end
    end)
end)

RegisterNetEvent("cframework:cleanVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = ESX.Game.GetVehicleInDirection()

    if vehicle == nil then
        return
    end

    if IsPedSittingInAnyVehicle(playerPed) then
        ESX.ShowNotification(T("VEHICLES_INSIDE"), 'error')
        return
    end

    if not DoesEntityExist(vehicle) then
        ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
        return
    end

    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
    Citizen.CreateThread(function()
        Citizen.Wait(10000)

        SetVehicleDirtLevel(vehicle, 0)
        ClearPedTasksImmediately(playerPed)

        ESX.ShowNotification(T("VEHICLES_CLEANED"), 'success')
    end)
end)