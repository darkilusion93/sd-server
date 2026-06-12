local targetPlayer = 0

local function setPlayerInventoryData()
    local data = RPC.execute("cframework:getPlayerInventory", targetPlayer)
    local items, inventory = {}, data.inventory

    SendNUIMessage(
        {
            action = "setInfoText",
            text = "<strong>" .. _U("player_inventory") .. "</strong><br>(" .. targetPlayer .. ")"
        }
    )

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            table.insert(items, inventory[key])
        end
    end

    SendNUIMessage(
        {
            action = "setType",
            type = "player"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

local function refreshPlayerInventory()
    setPlayerInventoryData()
end

local function openPlayerInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "player"
        }
    )
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')

    SetNuiFocus(true, true)
end

RegisterNetEvent("cframework:openPlayerInventory", function(target, playerName)
    targetPlayer = target
    setPlayerInventoryData()
    openPlayerInventory()
end)

RegisterNetEvent("cframework:refreshPlayerInventory", function()
    refreshPlayerInventory()
    loadPlayerInventory()
end)

RegisterNUICallback("PutIntoPlayer", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:tradePlayerItem", GetPlayerServerId(PlayerId()), targetPlayer, data.item.slot, count)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromPlayer", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:tradePlayerItem", targetPlayer, GetPlayerServerId(PlayerId()), data.item.slot, count, data.slot)
    end

    cb("ok")
end)
