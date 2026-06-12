local call = nil

AddEventHandler('chud:itemselector', function(elements, title, bText, callback, extraItems)
    SendNUIMessage(
        {
            action = "setType",
            type = "itemselector"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = title
        }
    )

    call = callback

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
            extraItemList = extraItems,
            buttonText = bText
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "menu"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback("selectItem", function(data, cb)
    call(data.value)

    cb("ok")
end)


--[[
RegisterCommand('selectitem', function()
    local elements = {
        { label = 'Ferro', value = 'iron' },
        { label = 'Cobre', value = 'copper' },
        { label = 'Ouro', value = 'gold_ingot' },
    }

    TriggerEvent('chud:itemselector', elements, 'Refinaria', 'Refinar', function(value)
        print('value -> '..value)
    end)

end)
]]