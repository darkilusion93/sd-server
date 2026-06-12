local call, call2, call3 = nil, nil, nil

AddEventHandler('chud:garage', function(elements, favorites, title, isPound, callback, callback2, callback3)
    SendNUIMessage(
        {
            action = "setType",
            type = "garage"
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
    call3 = callback3

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
            favoriteList = favorites,
            isPound = isPound
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "garage"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

AddEventHandler('chud:updateGarage', function(elements, favorites, isPound)
    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
            favoriteList = favorites,
            isPound = isPound
        }
    )
end)

RegisterNUICallback("garageSelect", function(data, cb)
    call(tonumber(data.value))

    cb("ok")
end)

RegisterNUICallback("toggleGarageFavorite", function(data, cb)
    call2(tonumber(data.value))

    cb("ok")
end)

RegisterNUICallback("setVehicleAlias", function(data, cb)
    call3(tonumber(data.value), data.alias)

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