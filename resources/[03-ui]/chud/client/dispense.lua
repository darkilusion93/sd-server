local call = nil

AddEventHandler('chud:dispense', function(bTitle, limit, filter, callback)
    SendNUIMessage(
        {
            action = "setType",
            type = "dispense"
        }
    )

    call = callback

    local infoText = "Stock<br>0/" .. limit

    if limit == -1 then
        infoText = "Stock<br>0"
    end

    SendNUIMessage(
        {
            action = "setInfoText",
            text = infoText
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = {},
            buttonTitle = bTitle,
            itemFilter = filter,
            itemLimit = limit
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "dispense"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback("dispenseAction", function(data, cb)
    call(data.value)

    cb("ok")
end)

--TriggerEvent('chud:dispense', "", "Vender", 10, {}, function() print("cenas") end)