

-- Reusable function for special items like donut_box, pizza, brownie
local function handleBoxItem(source, itemName, boxData, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local item <const> = inventory.getItemInSlot(slot)

    if not inventory.canRemoveItem(itemName, 1, slot) then
        return
    end

    if item and item.count == 1 then
        -- If the player already has the special item, show an error notification
        if not inventory.canAddItemIfSlotIsEmpty(boxData.item, boxData.count, slot) then
            TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_CANT_CARRY"), ESX.GetItemLabel(boxData.item)), 'error')
            return
        end

        -- Remove the box item and add multiple special items
        inventory.removeItem(itemName, 1, slot)
        inventory.addItem(boxData.item, boxData.count, slot)

        return
    end

    -- If the player already has the special item, show an error notification
    if not inventory.canAddItem(boxData.item, boxData.count) then
        TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_CANT_CARRY"), ESX.GetItemLabel(boxData.item)), 'error')
        return
    end

    -- Remove the box item and add multiple special items
    inventory.removeItem(itemName, 1, slot)
    inventory.addItem(boxData.item, boxData.count)
end


-- Register all items, including those with special handlers
for itemName, config in pairs(ESX.Items) do
    if config.box then
        ESX.RegisterUsableItem(itemName, function(source, slot)
            handleBoxItem(source, itemName, config.box, slot)
        end)
    end
end