-- Title	:	sv_tow.lua
-- Author	:	Peter
-- Started	:	12/12/23

local towSettings <const> = LoadTow()
local towModel <const> = `flatbed`
local isTowTaken = {}

local towDropoffaLocation = {}
local vehicleSpawnLocation <const> = towSettings.vehicleSpawnLocation

for _, loc in pairs(towSettings.vehicleDeleteLocation) do
    table.insert(towDropoffaLocation, vector3(loc.x, loc.y, loc.z))
end

RegisterNetEvent("cframework:getTowVehicle", function(index)
    local source <const> = source

    if not ESX.passedCooldown(source, 5000) then
        return
    end

    if ESX.getJob(source).name ~= 'reboque' then
        return
    end

    if not ESX.playerInsideLocation(source, {vector3(vehicleSpawnLocation[index].x, vehicleSpawnLocation[index].y, vehicleSpawnLocation[index].z)}, 10.0) then
        return
    end

    if not CheckLicense(source, "drive_truck") then
        TriggerClientEvent("esx:showNotification", source, T("TOW_NO_DRIVER_LICENSE"), "error")
        return
    end

    if DoesEntityExist(isTowTaken[source]) then
        TriggerClientEvent("esx:showNotification", source, T("TOW_ALREADY_SPAWNED"), "error")
        return
    end

    local v <const> = CreateVehicle(towModel, vehicleSpawnLocation[index].x, vehicleSpawnLocation[index].y, vehicleSpawnLocation[index].z, vehicleSpawnLocation[index].h, true, true)

    isTowTaken[source] = v

    local plate <const> = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

    TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

    TriggerClientEvent("esx:showNotification", source, T("TOW_USE_F6"), "inform")
end)

RegisterNetEvent("cframework:requestControlOfVehicle", function(netid)
    local source <const> = source
    local vehicleAttached <const> = NetworkGetEntityFromNetworkId(netid)

    if ESX.getJob(source).name ~= 'reboque' then
        return
    end

    SetEntityIgnoreRequestControlFilter(vehicleAttached, true)
end)

RegisterNetEvent("cframework:dropOffTow", function(currentlyTowedVehicleId)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local vehiclePedIsIn <const> = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local vehicleType <const> = GetEntityModel(vehiclePedIsIn)
    local vehicleAttached <const> = NetworkGetEntityFromNetworkId(currentlyTowedVehicleId)

    if inventory == nil then
        return
    end

    if not ESX.playerInsideLocation(source, towDropoffaLocation, 20.0) then
        return
    end

    if ESX.getJob(source).name ~= 'reboque' then
        return
    end

    if not inventory.canAddItem("cash", 1500) then
        TriggerClientEvent("esx:showNotification", source, T("INVENTORY_NOT_ENOUGH_SPACE"), "error")
        return
    end

    if DoesEntityExist(vehiclePedIsIn) and vehicleType == towModel and DoesEntityExist(vehicleAttached) then
        inventory.addItem("cash", 1500)
        DeleteEntity(vehicleAttached)
        return
    end

    if vehicleType == towModel then
        DeleteEntity(vehiclePedIsIn)
    end
end)

