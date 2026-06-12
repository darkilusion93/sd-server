


function StartVehicleChallenge(source, item)
    local generatedPlate <const> = ESX.GeneratePlate()
    local vehicleProps <const> = {model = GetHashKey(item.vehicle), plate = generatedPlate}
    local coords <const> = ESX.craftItems[item.partNum].spawnPoint or GetEntityCoords(GetPlayerPed(source))
    local closestZone <const> = ESX.getClosestGarageZone(coords)

    local vehType <const> = item.vehicleType or 'car'

    ESX.addVehicle(source, {vehicle = vehicleProps, stored = true, plate = vehicleProps.plate, type = vehType, zone = closestZone}, true)
    local v = CreateVehicle(GetHashKey(item.vehicle), coords.x, coords.y, coords.z, 0.0, true, false)

    SetVehicleNumberPlateText(v, vehicleProps.plate)
    TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

    ESX.setVehiclePlate(v, vehicleProps.plate)
end