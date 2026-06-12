local propertyId = 'property'

local function getPropertyText(weight, maxWeight)
    if propertyId == 'property' then
        if maxWeight == -1 then
            return 'Motel'
        else
            return string.format("<h3>Motel</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    elseif propertyId == 'police_vault' then
        if maxWeight == -1 then
            return 'Cacifo da polícia'
        else
            return string.format("<h3>Cacifo da polícia</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    elseif propertyId == 'market_vault' or propertyId == 'market_vault_cayo' then
        if maxWeight == -1 then
            return 'Armazém do Mercado'
        else
            return string.format("<h3>Armazém do Mercado</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    elseif propertyId == 'storage_unit' then
        return 'Unidade de armazenamento'
    elseif propertyId == 'armazem1' or propertyId == "armazem2" or propertyId == "armazem3" or propertyId == "armazem4" then
        if maxWeight == -1 then
            return 'Armazém'
        else
            return string.format("<h3>Armazém</h3><br><strong>Capacidade:</strong><br> %s / %s", weight/100, maxWeight/100)
        end
    end

    return 'ERRO'
end

local function setPropertyInventoryData(data)
    local items = {}
    local propertyItems = data.items
    local weight, maxWeight = data.weight, data.maxWeight

    table.sort(propertyItems, compare)

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        item.usable = false
        item.limit = -1
        item.canRemove = false

        table.insert(items, item)
    end

    SendNUIMessage({
        action = "setType",
        type = "property"
    })

    SendNUIMessage({
        action = "setInfoText",
        text = getPropertyText(weight, maxWeight)
    })

    SendNUIMessage({
        action = "setSecondInventoryItems",
        itemList = items
    })
end

local function openPropertyInventory()
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

local function refreshPropertyInventory()
    local inventory = RPC.execute('cframework:getPropertyInventory', propertyId)
    setPropertyInventoryData(inventory)
end

RegisterNetEvent("cframework:openPropertyInventory", function(id)
    propertyId = id

    local inventory = RPC.execute('cframework:getPropertyInventory', propertyId)

    setPropertyInventoryData(inventory)
    openPropertyInventory()
end)

RegisterNetEvent("cframework:refreshPropertyInventory", function()
    refreshPropertyInventory()
    loadPlayerInventory()
end)

RegisterNUICallback("PutIntoProperty", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then return end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:putPropertyItem", propertyId, data.item.slot, count)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromProperty", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then return end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:getPropertyItem", propertyId, data.item.slot, count, data.slot)
    end

    cb("ok")
end)
