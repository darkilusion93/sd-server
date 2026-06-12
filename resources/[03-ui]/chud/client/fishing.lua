AddEventHandler('chud:fishing', function(rod, currentItems)
    SendNUIMessage(
        {
            action = "setType",
            type = "fishing"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = 'Equipar cana'
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = {rod = rod, items = currentItems}
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "fishing"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback("updateFishing", function(data, cb)
    if data.slot == 'fishing-slot-1' and ESX.IsThisFishingEquipmentValid("bait", data.item) then
        TriggerEvent('cframework:fishing_equip', 'fishing-slot-1', data.item, data.label)
        cb(true)
        return
    end

    if data.slot == 'fishing-slot-2' and ESX.IsThisFishingEquipmentValid("anzol", data.item) then
        TriggerEvent('cframework:fishing_equip', 'fishing-slot-2', data.item, data.label)
        cb(true)
        return
    end

    if data.slot == 'fishing-slot-3' and ESX.IsThisFishingEquipmentValid("nylon", data.item) then
        TriggerEvent('cframework:fishing_equip', 'fishing-slot-3', data.item, data.label)
        cb(true)
        return
    end

    if data.slot == 'fishing-slot-4' and ESX.IsThisFishingEquipmentValid("reel", data.item) then
        TriggerEvent('cframework:fishing_equip', 'fishing-slot-4', data.item, data.label)
        cb(true)
        return
    end

    cb(false)
end)

RegisterNUICallback("startFishing", function(data, cb)
    TriggerEvent('cframework:startFishing', data.rod)

    cb("ok")
end)


--[[
RegisterCommand('pescaria', function()
    TriggerEvent('chud:fishing', 'elementalrod', {
        ['fishing-slot-1'] = {name = 'iron', label = 'Ferro'},
        ['fishing-slot-4'] = {name = 'drill', label = 'Britadeira'}
    })
end)]]
