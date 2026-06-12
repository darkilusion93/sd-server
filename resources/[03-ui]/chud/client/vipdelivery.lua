local deliveredVips = {}
local playerLoaded = false

Citizen.CreateThread(function()
    while not chudReady do Citizen.Wait(0) end

    Citizen.Wait(30000)
    playerLoaded = true
end)

AddEventHandler('chud:vipdelivery', function(elements)
    SendNUIMessage(
        {
            action = "setType",
            type = "vipdelivery"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = "Vips Entregues"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "vipdelivery"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback("checkVipItems", function(data, cb)
    deliveredVips = {}
    TriggerEvent('esx_inventoryhud:doClose')

    cb("ok")
end)

AddEventHandler("inventoryClosed", function ()
    if not playerLoaded then
        return
    end

    deliveredVips = {}
end)


RegisterNetEvent("cframework:vipDelivery", function(packageName)
    table.insert(deliveredVips, packageName)

    while not playerLoaded do
        Citizen.Wait(100)
    end

    TriggerEvent('chud:vipdelivery', deliveredVips)
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