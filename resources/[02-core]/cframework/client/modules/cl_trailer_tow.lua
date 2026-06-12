


function TrailerTowRoutine()
    local playerPed <const> = PlayerPedId()
    local playerCoords <const> = GetEntityCoords(playerPed)
    local vehiclePedIsIn <const> = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehiclePedIsIn) then
        ESX.ShowNotification(T("TRAILER_TOW_CANT_BE_IN_VEHICLE"), "error")
        return
    end

    local vehicles <const> = GetGamePool('CVehicle')
    local trailer, targetVehicle = 0, 0

    for _, v in ipairs(vehicles) do
        if GetVehicleType(v) == "trailer" and #(GetEntityCoords(v) - playerCoords) < 10.0 then
            trailer = v
            break
        end
    end

    for _, v in ipairs(vehicles) do
        local vType <const> = GetVehicleType(v)

        if (vType == "heli" or vType == "boat" or vType == "plane" or vType == "submarine") and #(GetEntityCoords(v) - playerCoords) < 10.0 then
            targetVehicle = v
            break
        end
    end

    if not DoesEntityExist(targetVehicle) then
        ESX.ShowNotification(T("TRAILER_TOW_NO_VEHICLE_TO_TOW"), "error")
        return
    end

    if not DoesEntityExist(trailer) then
        ESX.ShowNotification(T("TRAILER_TOW_NO_TRAILER_FOUND"), "error")
        return
    end

    if not IsVehicleStopped(targetVehicle) or not IsVehicleStopped(trailer) then
        ESX.ShowNotification(T("TRAILER_TOW_BOTH_VEHICLES_MUST_BE_STOPPED"), "error")
        return
    end

    TriggerServerEvent("cframework:requestControlOfVehicle", NetworkGetNetworkIdFromEntity(targetVehicle))
    TriggerServerEvent("cframework:requestControlOfVehicle", NetworkGetNetworkIdFromEntity(trailer))

    RequestAnimDict('mini@repair')
    while not HasAnimDictLoaded('mini@repair') do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), 'mini@repair' , 'fixing_a_ped' ,8.0, -8.0, -1, 1, 0, false, false, false )

    Citizen.Wait(1000)

    NetworkRequestControlOfEntity(targetVehicle)
    NetworkRequestControlOfEntity(trailer)

    local curTime <const> = GetGameTimer()

    while not NetworkHasControlOfEntity(targetVehicle) or not NetworkHasControlOfEntity(trailer) do
        Citizen.Wait(0)

        if GetGameTimer() - curTime > 8000 then
            ESX.ShowNotification(T("TRAILER_TOW_FAILED"), "error")
            ClearPedTasks(PlayerPedId())
            return
        end
    end

    Citizen.Wait(6000)
    ClearPedTasks(PlayerPedId())

    if GetEntityAttachedTo(targetVehicle) ~= 0 then
        local vehiclesCoords <const> = GetOffsetFromEntityInWorldCoords(trailer, 5.0, 0.0, 0.0)

        DetachEntity(targetVehicle, false, false)
        SetEntityCoords(targetVehicle, vehiclesCoords.x, vehiclesCoords.y, vehiclesCoords.z, true, false, false, true)
        SetVehicleOnGroundProperly(targetVehicle)

        ESX.ShowNotification(T("TRAILER_TOW_REMOVED_VEHICLE"), "success")
        return
    end

    local targetModelHash <const> = GetEntityModel(targetVehicle)
    local minDim <const>, maxDim <const> = GetModelDimensions(targetModelHash)
    local vehicleHeight <const> = maxDim.z - minDim.z

    local yoff = 0.0

    AttachEntityToEntity(targetVehicle, trailer, 0, 0.0, -1.0, yoff + vehicleHeight / 2.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

    while not IsEntityTouchingEntity(targetVehicle, trailer) do
        AttachEntityToEntity(targetVehicle, trailer, 0, 0.0, -1.0, yoff + vehicleHeight / 2.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)

        yoff = yoff - 0.1

        Citizen.Wait(0)
    end
end