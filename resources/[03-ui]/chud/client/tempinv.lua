local invId = ""
local invType = ""

local function setTempInventoryData(data)
    local items = {}
    local invItems = data.items

    table.sort(invItems, compare)

    for i = 1, #invItems, 1 do
        local item = invItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    SendNUIMessage({
        action = "setType",
        type = "tempinv"
    })

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

local function refreshTempInventory()
    local inventory = RPC.execute('cframework:getTempInventory', invId, invType)

    if inventory == nil then return end

    setTempInventoryData(inventory)
end

local function openTempInventory()
    if ESX.isPlayerDead() then return end

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage({
        action = "display",
        type = "property"
    })
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')

    SetNuiFocus(true, true)
end

RegisterNetEvent("cframework:openTempInventory", function(id, type)
    local inventory = RPC.execute('cframework:getTempInventory', id, type)

    if inventory == nil then return end

    invId = id
    invType = type

    setTempInventoryData(inventory)
    openTempInventory()
end)


RegisterNUICallback("PutIntoTempInv", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then return end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:putTempInvItem", invId, data.item.slot, count)
    end

    refreshTempInventory()
    loadPlayerInventory()

    cb("ok")
end)

RegisterNUICallback("TakeFromTempInv", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then return end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:getTempInvItem", invId, data.item.slot, count, data.slot)
    end

    refreshTempInventory()
    loadPlayerInventory()

    cb("ok")
end)
