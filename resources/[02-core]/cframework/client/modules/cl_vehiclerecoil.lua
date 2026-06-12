


AddEventHandler("cframework:shootingInsideVehicle", function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local speed = GetEntitySpeed(vehicle) * 3.6 / 200

    ShakeGameplayCam("JOLT_SHAKE", math.min(speed, 0.7))
end)