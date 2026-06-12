

-- Function to handle item usage based on the configuration
local function useConfiguredItem(source, slot, itemName, config)
    -- Remove the item from the inventory for regular items
    local inventory <const> = ESX.getInvContainer(source)

    inventory.removeItem(itemName, 1, slot)

    -- Trigger hunger and thirst effects if provided
    if config.hunger then
        TriggerClientEvent('esx_status:add', source, 'hunger', config.hunger)
    end
    if config.thirst then
        TriggerClientEvent('esx_status:add', source, 'thirst', config.thirst)
    end
    if config.drunk then
        TriggerClientEvent('esx_status:add', source, 'drunk', config.drunk)
    end

    -- Trigger the use item event if defined
    if config.effect then
        TriggerClientEvent('UseItem', source, config.effect)
    end

    -- Trigger custom effect/event if defined
    if config.customEffect then
        TriggerClientEvent(config.customEffect, source)
    end
end

-- Register all items, including those with special handlers
for itemName, config in pairs(ESX.Items) do
    if config.food then
        ESX.RegisterUsableItem(itemName, function(source, slot)
            useConfiguredItem(source, slot, itemName, config.food)
        end)
    end
end