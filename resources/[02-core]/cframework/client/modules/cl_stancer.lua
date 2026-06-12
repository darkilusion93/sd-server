

local function SetVehicleFrontTrackWidth(vehicle, width)
    SetVehicleWheelXOffset(vehicle, 0, -width/2)
    SetVehicleWheelXOffset(vehicle, 1, width/2)
end

local function SetVehicleBackTrackWidth(vehicle, width)
    SetVehicleWheelXOffset(vehicle, 2, -width/2)
    SetVehicleWheelXOffset(vehicle, 3, width/2)
end

local function SetVehicleFrontTrackRotation(vehicle, rotation)
    SetVehicleWheelYRotation(vehicle, 0, rotation)
    SetVehicleWheelYRotation(vehicle, 1, -rotation)
end

local function SetVehicleBackTrackRotation(vehicle, rotation)
    SetVehicleWheelYRotation(vehicle, 2, rotation)
    SetVehicleWheelYRotation(vehicle, 3, -rotation)
end

Citizen.CreateThread(function()
    while true do
        local vehiclePool = GetGamePool('CVehicle') -- Get the list of vehicles (entities) from the pool

        for i = 1, #vehiclePool do -- loop through each vehicle (entity)
            local vehicle <const> = vehiclePool[i] -- Get the vehicle (entity) at the current index
            local state <const> = Entity(vehicle).state
            local vehType <const> = GetVehicleType(vehicle) -- Get the type of the vehicle (entity)
            local frontTrackWidth <const> = state.frontTrackWidth or 0.0
            local backTrackWidth <const> = state.backTrackWidth or 0.0
            local frontTrackRotation <const> = state.frontTrackRotation or 0.0
            local backTrackRotation <const> = state.backTrackRotation or 0.0
            local nitroEnabled <const> = state.nitroEnabled or false

            if vehType ~= "automobile" then
                goto jump_loop
            end

            if frontTrackWidth ~= 0.0 then
                SetVehicleFrontTrackWidth(vehicle, frontTrackWidth)
            end

            if backTrackWidth ~= 0.0 then
                SetVehicleBackTrackWidth(vehicle, backTrackWidth)
            end

            SetVehicleFrontTrackRotation(vehicle, frontTrackRotation)
            SetVehicleBackTrackRotation(vehicle, backTrackRotation)

            if state.nitroEnabled ~= nil then
                SetOverrideNitrousLevel(vehicle, nitroEnabled, 0.0, 0.0, 0.0, true)
            end

            ::jump_loop::
        end

        Citizen.Wait(0)
    end
end)