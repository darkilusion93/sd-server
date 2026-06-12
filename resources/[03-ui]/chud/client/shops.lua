local shopZone = nil

local function setShopData(zone, items, currency)
    shopZone = zone

    SendNUIMessage(
        {
            action = "setType",
            type = "shop",
            currency = currency
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
            itemList = items
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
            type = "shop"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end

RegisterNetEvent("esx_inventoryhud:openShop", function(zone, items, currency)
    setShopData(zone, items, currency)
    openShop()
end)

RegisterNUICallback("BuyItem", function(data, cb)
    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        if shopZone == "org" then
            TriggerServerEvent("cframework:buyItemSociety", data.item, count)
        else
            TriggerServerEvent("cframework:buyItem", data.item.name, count, shopZone, data.slot)
        end
    end

    Wait(250)
    loadPlayerInventory()

    cb("ok")
end)
