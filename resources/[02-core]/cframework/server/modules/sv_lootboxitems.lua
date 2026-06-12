
local function generateLootboxItem(lootboxData)
    local totalChance = 0
    for _, itemData in pairs(lootboxData) do
        totalChance = totalChance + itemData.chance
    end

    local randomChance = math.random() * totalChance
    local accumulatedChance = 0

    for _, itemData in pairs(lootboxData) do
        accumulatedChance = accumulatedChance + itemData.chance
        if randomChance <= accumulatedChance then
            return {item = itemData.item, count = itemData.count}
        end
    end
end

-- Reusable function for special items like donut_box, pizza, brownie
local function handleLootboxItem(source, itemName, lootboxData, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local boxData <const> = generateLootboxItem(lootboxData)

    if not inventory.canRemoveItem(itemName, 1, slot) then
        return
    end

    -- Remove the box item and add multiple special items
    inventory.removeItem(itemName, 1, slot)
    local added <const> = inventory.addItem(boxData.item, boxData.count)

    -- Show notification if item couldn't be added but still loose the box
    if not added then
        TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_CANT_CARRY"), ESX.GetItemLabel(boxData.item)), 'error')
        return
    end
end


-- Register all items, including those with special handlers
for itemName, config in pairs(ESX.Items) do
    if config.lootbox then
        ESX.RegisterUsableItem(itemName, function(source, slot)
            handleLootboxItem(source, itemName, config.lootbox, slot)
        end)
    end
end