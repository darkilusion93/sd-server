local loc = nil

RegisterNetEvent("cframework:openMarketManagement",function(location)
    local data = RPC.execute('cframework:getMarketManagement', location)

    loc = location

    setMarketManagementData(data)
    openMarketManagement()
end)

function refreshMarketManagement()
    local inventory = RPC.execute('cframework:getMarketManagement', loc)

    setMarketManagementData(inventory)
end

function setMarketManagementData(data)
    SendNUIMessage(
        {
            action = "setInfoText",
            text = 'Gestão da Barraca'
        }
    )

    SendNUIMessage(
        {
            action = "setType",
            type = "marketmanagement"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            items = data.items,
            onSale = data.onSale,
        }
    )
end

function openMarketManagement()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "marketmanagement"
        }
    )
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutOnMarketSale", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    TriggerServerEvent("cframework:addMarketShopItem", loc, data.item.slot, data.price)
    Citizen.Wait(150)
    refreshMarketManagement()

    cb("ok")
end)