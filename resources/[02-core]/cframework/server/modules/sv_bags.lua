


local function handleBagItem(source, itemName, bagData, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local currentExtraSlots <const> = ESX.getExtraSlots(source)
    local extraSlotsSlots <const> = bagData.slots or 0
    local durationDays <const> = 30

    if currentExtraSlots >= extraSlotsSlots then
        TriggerClientEvent('esx:showNotification', source, T("BAGS_ALREADY_HAVE"), 'error')
        return
    end

    if not inventory.canRemoveItem(itemName, 1, slot) then
        return
    end

    -- Remove the bag item and add slots
    inventory.removeItem(itemName, 1, slot)
    ESX.setExtraSlots(source, extraSlotsSlots)


    local identifier <const> = ESX.getIdentifier(source)
    local expires = os.date('%Y-%m-%d %H:%M:%S', os.time() + (durationDays * 86400))

    MySQL.Async.execute([[
        INSERT INTO user_bags (identifier, extra_slots, expires_at)
        VALUES (@identifier, @extra_slots, @expires_at)
        ON DUPLICATE KEY UPDATE 
            extra_slots = VALUES(extra_slots), 
            expires_at = VALUES(expires_at)
    ]], {
        ['@identifier'] = identifier,
        ['@extra_slots'] = extraSlotsSlots,
        ['@expires_at'] = expires
    })
end

-- Register all items, including those with special handlers
for itemName, config in pairs(ESX.Items) do
    if config.bag then
        ESX.RegisterUsableItem(itemName, function(source, slot)
            handleBagItem(source, itemName, config.bag, slot)
        end)
    end
end