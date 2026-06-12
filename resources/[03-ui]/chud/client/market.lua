local loc = nil
local isGettingMarketUpdates = false

RegisterNetEvent("cframework:openMarketInventory",function(location)
    local inventory = RPC.execute('cframework:openMarketInventory', location)

    loc = location

    isGettingMarketUpdates = true
    TriggerServerEvent('cframework:requestMarketUpdates', location)

    setMarketInventoryData(inventory)
    openMarketInventory()
end)

RegisterNetEvent('inventoryClosed', function()
    if not isGettingMarketUpdates then
        return
    end

    isGettingMarketUpdates = false
    TriggerServerEvent('cframework:dismissMarketUpdates')
end)

RegisterNetEvent('cframework:updateMarket', function(inventory)
    setMarketInventoryData(inventory)
    Wait(150)
    loadPlayerInventory()
end)

function refreshMarketInventory()
    local inventory = RPC.execute('cframework:openMarketInventory', loc)

    setMarketInventoryData(inventory)
end

function setMarketInventoryData(data)
    local items = {}
    local identifier = ESX.GetPlayerData().identifier

    for k, v in pairs(data) do
        local item = v

        item.type = item.item_type
        item.usable = false
        item.rare = false
        item.limit = -1
        item.canRemove = false
        item.id = item.id
        item.slot = item.slot
        item.name = item.item
        item.label = item.label .. ' (x' .. item.quantity .. ')'
        item.isOwner = false

        table.insert(items, item)
    end

    SendNUIMessage(
        {
            action = "setInfoText",
            text = 'Market'
        }
    )

    SendNUIMessage(
        {
            action = "setType",
            type = "market"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openMarketInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "market"
        }
    )
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')

    SetNuiFocus(true, true)
end

RegisterNUICallback("PutIntoMarket", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number and type(data.price) == "number" and math.floor(data.price) == data.price then
        if data.number > data.item.count then data.number = data.item.count end

        --TriggerServerEvent("gmarket:__internal:add", data.item.slot, data.price, data.number)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromMarket", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    TriggerServerEvent("cframework:marketShopBuy", loc, data.item.id, data.number, data.slot)

    cb("ok")
end)
