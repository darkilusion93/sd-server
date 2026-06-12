local propertyId = 'casa'

local function getCasaText(weight, maxWeight)
    if propertyId == 'casa' then
        if maxWeight == -1 then
            return 'Casa'
        else
            return string.format("<h3>Casa</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    elseif propertyId == 'garage' then
        if maxWeight == -1 then
            return 'Garagem'
        else
            return string.format("<h3>Garagem</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    end

    return 'ERRO'
end

local function setCasaInventoryData(data)
    local items = {}
    local propertyItems = data.items
    local weight, maxWeight = data.weight, data.maxWeight

    table.sort(propertyItems, compare)

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.usable = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    SendNUIMessage(
        {
            action = "setType",
            type = "casa"
        }
    )

    SendNUIMessage({
        action = "setInfoText",
        text = getCasaText(weight, maxWeight)
    })

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

local function refreshCasaInventory()
    local inventory = RPC.execute('cframework:getCasaInventory', propertyId)
    setCasaInventoryData(inventory)
end

local function openCasaInventory()
    if ESX.isPlayerDead() then return end

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "casa"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end

RegisterNetEvent("cframework:openCasaInventory", function(id)
    local inventory = RPC.execute('cframework:getCasaInventory', id)

    propertyId = id

    setCasaInventoryData(inventory)
    openCasaInventory()
end)

RegisterNetEvent("cframework:refreshCasaInventory", function()
    refreshCasaInventory()
    loadPlayerInventory()
end)

RegisterNUICallback("PutIntoCasa", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:putCasaItem", propertyId, data.item.slot, count)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromCasa", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:getCasaItem", propertyId, data.item.slot, count, data.slot)
    end

    cb("ok")
end)
