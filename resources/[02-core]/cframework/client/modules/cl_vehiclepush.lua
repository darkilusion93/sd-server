

local damageNeeded = 1000.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
local forceDettach = false
local isPushing = false
local isPushingDisabled = false

local function pushVehicle()
    local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
    local ped = PlayerPedId()
    local closestVehicle, Distance = ESX.Game.GetClosestVehicle()
    local vehicleCoords = GetEntityCoords(closestVehicle)
    local dimension = GetModelDimensions(GetEntityModel(closestVehicle))

    if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
        Vehicle.Coords = vehicleCoords
        Vehicle.Dimensions = dimension
        Vehicle.Vehicle = closestVehicle
        Vehicle.Distance = Distance
        if #(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) - GetEntityCoords(ped)) > #((GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1) - GetEntityCoords(ped)) then
            Vehicle.IsInFront = false
        else
            Vehicle.IsInFront = true
        end
    end

    if Vehicle.Vehicle == nil then
        return
    end

    if not HasEntityClearLosToEntity(ped, Vehicle.Vehicle, -1) then
        return
    end

    local _, hit, targetCoords, _, targetEntity = RayCast(GetPedBoneCoords(PlayerPedId(), 31086, 0.0, 0.0, 0.0), GetEntityCoords(Vehicle.Vehicle), 286, PlayerPedId(), 0.2)

    if not hit and targetEntity == 0 then return end

    if targetEntity ~= Vehicle.Vehicle then return end

    if IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and GetVehicleEngineHealth(Vehicle.Vehicle) <= damageNeeded then
        NetworkRequestControlOfEntity(Vehicle.Vehicle)

        if Vehicle.IsInFront then
            AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(ped, 6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, false, false, false, true, 0.0, true)
        else
            AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(ped, 6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, false, false, false, true, 0.0, true)
        end

        ESX.Streaming.RequestAnimDict('missfinale_c2ig_11')
        TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, false, false, false)
        Citizen.Wait(200)

        while true do
            Citizen.Wait(5)

            isPushing = true

            if IsDisabledControlPressed(0, 34) then
                TaskVehicleTempAction(PlayerPedId(), Vehicle.Vehicle, 11, 1000)
            end

            if IsDisabledControlPressed(0, 9) then
                TaskVehicleTempAction(PlayerPedId(), Vehicle.Vehicle, 10, 1000)
            end

            if Vehicle.IsInFront then
                SetVehicleForwardSpeed(Vehicle.Vehicle, -1.0)
            else
                SetVehicleForwardSpeed(Vehicle.Vehicle, 1.0)
            end

            if HasEntityCollidedWithAnything(Vehicle.Vehicle) then
                SetVehicleOnGroundProperly(Vehicle.Vehicle)
            end

            if IsControlReleased(0, 38) or forceDettach then
                forceDettach = false
                isPushing = false
                DetachEntity(ped, false, false)
                StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                FreezeEntityPosition(ped, false)
                break
            end
        end
    end
end

local function startPushVehicle()
    local ped <const> = GetPlayerPed(PlayerId())

    if IsPedDeadOrDying(ped, true) then return false end
    if IsPedRagdoll(ped) then return false end
    if isPushingDisabled then return false end

    if IsControlPressed(0, 38) then
        pushVehicle()
    end
end

Citizen.CreateThread(function()
    exports.ft_libs:AddButton("vehiclePush", {
      key = 21,
      use = {
        callback = startPushVehicle,
      },
    })
end)

RegisterNetEvent('cframework:disableVehiclePush', function()
    isPushingDisabled = true
end)

RegisterNetEvent('cframework:enableVehiclePush', function()
    isPushingDisabled = false
end)