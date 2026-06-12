local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function hasItem(src, item)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then
        return false
    end

    local inventoryItem = xPlayer.getInventoryItem(item)
    local foundItem = inventoryItem and inventoryItem.count > 0

    if not foundItem then
        for k, v in ipairs(xPlayer.loadout) do
            if item:upper() == v.name:upper() then
                foundItem = true
                break
            end
        end
    end

    return foundItem
end
