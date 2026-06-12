local call, call2 = nil, nil

AddEventHandler('chud:process', function(elements, title, bText, callback, callback2)
    SendNUIMessage(
        {
            action = "setType",
            type = "process"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = title
        }
    )

    call = callback
    call2 = callback2

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
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

RegisterNUICallback("startProcess", function(data, cb)
    if call == nil then return end

    call(data)

    cb("ok")
end)

RegisterNUICallback("upgradeProcess", function(data, cb)
    if call2 == nil then return end

    call2(data)

    cb("ok")
end)


--[[
RegisterCommand('process', function()
    local elements = {
        { label = 'Ferro', name = 'iron', output = {{label = 'Ferro', name = 'iron', count = 1}, {label = 'Cobre', name = 'copper', count = 1}, {label = 'Ouro', name = 'gold_ingot', count = 1}} },
        { label = 'asd', name = 'coal_ore', output = {{label = 'Cobre', name = 'copper', count = 1}, {label = 'Ouro', name = 'gold_ingot', count = 1}, {label = 'Ferro', name = 'iron', count = 1}} },
        { label = 'dsd', name = 'crushed_iron_ore', output = {{label = 'Ferro', name = 'iron', count = 1}, {label = 'Cobre', name = 'copper', count = 1}, {label = 'Ouro', name = 'gold_ingot', count = 1}} },
        { label = 'dfdfd', name = 'chalk', output = {{label = 'Ferro', name = 'iron', count = 1}, {label = 'Ouro', name = 'gold_ingot', count = 1}, {label = 'Cobre', name = 'copper', count = 1}} },
    }

    TriggerEvent('chud:process', elements, 'Lavagem', 'Lavar', function(value)
        print('value -> '..json.encode(value))
    end)

end, false)
]]