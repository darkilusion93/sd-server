---@diagnostic disable: need-check-nil
local SharedDataStores = {}
local playersInTrunk = {}

function GetVehicleDataStore(plate, weight)
    if SharedDataStores[plate] == nil and weight ~= nil then --handle this creation another way
        SharedDataStores[plate] = CreateInventory("vehicle", plate, weight)
    end

    return SharedDataStores[plate]
end

RegisterNetEvent("cframework:closeTrunkInventory", function(plate)
    local source = source
    local inventory = GetVehicleDataStore(plate)

    if inventory == nil then return end

    inventory.removeUpdateListener(source)
end)

RegisterNetEvent("cframework:getTrunkInventory", function(plate, weight, invId)
    local source = source
    local isClose, vehicle = ESX.closeToVehicle(plate, source)

    if not isClose then
        return
    end

    TriggerEvent("cframework:resetVehicleCleanup", vehicle)

    local hasPlayerInTrunk = playersInTrunk[vehicle] ~= nil
    local inventory = GetVehicleDataStore(plate, weight)
    local inventoryId = inventory.getInvId()

    inventory.addUpdateListener(source)

    if inventoryId == invId then
        TriggerClientEvent('cframework:openExistingTrunkInventory', source, hasPlayerInTrunk)
        return
    end

    local items = inventory.getItems()
    local currentWeight = inventory.getTotalItemCount()

    TriggerClientEvent('cframework:openNewTrunkInventory', source, {items = items, weight = currentWeight}, inventoryId, hasPlayerInTrunk)
end)

RegisterNetEvent("cframework:getTrunkInventoryForPreview", function(plate, invId, id, weight)
    local source = source

    ---@diagnostic disable-next-line: param-type-mismatch
    for k,veh in ipairs(GetAllVehicles()) do
        if DoesEntityExist(veh) and GetVehicleNumberPlateText(veh) == plate then
            TriggerClientEvent('cframework:existingVehicleDisablePreview', source, id, plate)
            return false
        end
    end

    local inventory = GetVehicleDataStore(plate, weight)

    if inventory == nil then
        TriggerClientEvent('cframework:openNewTrunkInventoryForPreview', source, {items = {}, weight = 0}, 0, id, plate)
        return
    end

    local inventoryId = inventory.getInvId()

    if inventoryId == invId then
        TriggerClientEvent('cframework:openExistingTrunkInventoryForPreview', source, id, plate)
        return
    end

    local items = inventory.getItems()
    local currentWeight = inventory.getTotalItemCount()

    TriggerClientEvent('cframework:openNewTrunkInventoryForPreview', source, {items = items, weight = currentWeight}, inventoryId, id, plate)
end)

RegisterServerEvent("cframework:getTrunkItem", function(plate, itemSlot, itemCount, toSlot)
    local source <const> = source

    if plate == nil or not ESX.closeToVehicle(plate, source) then
        return
    end

    local sourceInventory, targetInventory = GetVehicleDataStore(plate), ESX.getInvContainer(source)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)

    if not success then return end

    --ESX.logTrunkData(source, "retirar", item.name, itemCount, plate)

    if swappedItem ~= nil then
        --ESX.logTrunkData(source, "pôr", swappedItem.name, swappedItem.count, plate)
    end
end)

RegisterServerEvent("cframework:putTrunkItem", function(plate, itemSlot, itemCount)
    local source <const> = source

    if plate == nil or not ESX.closeToVehicle(plate, source) then return end

    local sourceInventory, targetInventory = ESX.getInvContainer(source), GetVehicleDataStore(plate)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    --ESX.logTrunkData(source, "pôr", item.name, itemCount, plate)

    if swappedItem ~= nil then
        --ESX.logTrunkData(source, "retirar", swappedItem.name, swappedItem.count, plate)
    end
end)


RegisterNetEvent("cframework:hideInTrunk", function(netId)
    local source = source
    local vehicle <const> = NetworkGetEntityFromNetworkId(netId)
    local plate <const> = GetVehicleNumberPlateText(vehicle)

    if not ESX.closeToVehicle(plate, source) then return end

    if not DoesEntityExist(vehicle) then
        TriggerClientEvent("cframework:trunkDoesntExist", source)
        return false
    end

    if playersInTrunk[vehicle] ~= nil then
        TriggerClientEvent("cframework:trunkOccupied", source)
        return false
    end

    playersInTrunk[vehicle] = source

    TriggerEvent("cframework:disableInvisibleCheck", source)

    TriggerClientEvent("cframework:enterTrunk", source)
end)

RegisterNetEvent("cframework:hideCarryInTrunk", function(netId, carryServerId)
    local source = source
    local vehicle <const> = NetworkGetEntityFromNetworkId(netId)
    local plate <const> = GetVehicleNumberPlateText(vehicle)

    if carryServerId == nil then return end

    if not ESX.closeToVehicle(plate, source) then return end
    if not ESX.closeToVehicle(plate, carryServerId) then return end

    if not DoesEntityExist(vehicle) then
        TriggerClientEvent("cframework:trunkDoesntExist", source)
        return false
    end

    if playersInTrunk[vehicle] ~= nil then
        TriggerClientEvent("cframework:trunkOccupied", source)
        return false
    end

    playersInTrunk[vehicle] = carryServerId

    TriggerEvent("cframework:disableInvisibleCheck", carryServerId)

    TriggerClientEvent("cframework:enterTrunkCarry", carryServerId, NetworkGetNetworkIdFromEntity(vehicle))
end)


RegisterNetEvent("cframework:removePlayerFromTrunk", function(netId)
    local source = source
    local vehicle <const> = NetworkGetEntityFromNetworkId(netId)

    local plate <const> = GetVehicleNumberPlateText(vehicle)

    if not ESX.closeToVehicle(plate, source) then return end

    if not DoesEntityExist(vehicle) then
        TriggerClientEvent("cframework:trunkDoesntExist", source)
        return false
    end

    if playersInTrunk[vehicle] == nil then
        TriggerClientEvent("cframework:trunkEmpty", source)
        return false
    end

    local target = playersInTrunk[vehicle]

    TriggerClientEvent("cframework:forceExitTrunk", target)
end)


RegisterNetEvent("cframework:exitTrunk", function()
  local source = source

    for vehicle, player in pairs(playersInTrunk) do
        if player == source then
            playersInTrunk[vehicle] = nil
            TriggerEvent("cframework:enableInvisibleCheck", source)
        end
    end
end)


AddEventHandler('playerDropped', function(_)
	local source = source

    for vehicle, player in pairs(playersInTrunk) do
        if player == source then
            playersInTrunk[vehicle] = nil
            TriggerEvent("cframework:enableInvisibleCheck", source)
        end
    end
end)