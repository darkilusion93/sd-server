local call = nil

AddEventHandler('chud:listmenu', function(elements, title, callback)
    SendNUIMessage(
        {
            action = "setType",
            type = "listmenu"
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
            itemList = elements
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "listmenu"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback("listMenuChoose", function(data, cb)
    call(data)

    cb("ok")
end)


--[[
RegisterCommand('abrirmen', function()
    local elements = {
        { label = '&#129526 Costureiro', value = 'costureiro' },
        { label = '&#128237 CTT', value = 'ctt' },
        { label = '&#128686 Lixeiro', value = 'lixeiro' },
        { label = '&#128296 Mineiro', value = 'miner' },
        { label = '&#127794 Borracheiro', value = 'rubber' },
        { label = '&#127790 Uber Eats', value = 'ubereats' },
        { label = '&#128188 Desempregado', value = 'unemployed' },
    }

    TriggerEvent('chud:menu', elements, title, function(value)
        print('value -> '..value)
    end)

end)
]]