RegisterNetEvent("cframework:ejectEveryoneFromVehicle", function()
    local source <const> = source
    local playerPed <const> = GetPlayerPed(source)
    local vehicle <const> = GetVehiclePedIsIn(playerPed, false)

    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        return
    end

    TriggerClientEvent("cframework:getEjectedFromVehicle", source)

    for i = 0, 6 do
        local passenger <const> = GetPedInVehicleSeat(vehicle, i)

        if DoesEntityExist(passenger) then
            local playerId <const> = NetworkGetEntityOwner(passenger)

            if playerId == 0 or playerId == -1 then
                goto continue
            end

            TriggerClientEvent("cframework:getEjectedFromVehicle", playerId)

            ::continue::
        end
    end
end)