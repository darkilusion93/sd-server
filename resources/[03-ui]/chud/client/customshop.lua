local call = nil

local function setShopData(items, selector, text)
    SendNUIMessage(
        {
            action = "setType",
            type = "customshop"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = _U("store")
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            buttonText = text,
            itemList = items,
            itemSelector = selector,
        }
    )
end

local function openShop()
    if ESX.isPlayerDead() then return end

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "customshop"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end

RegisterNetEvent("cframework:openCustomShop", function(items, selector, buttonText, callback)
    call = callback
    setShopData(items, selector, buttonText)
    openShop()
end)

RegisterNUICallback("buyCustomShopItem", function(data, cb)
    call(data)

    cb("ok")
end)
