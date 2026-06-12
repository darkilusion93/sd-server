local currentJobPlayerIsAccessing = nil

local function refreshOrgInventory()
    TriggerServerEvent('cframework:getOrgInventory', currentJobPlayerIsAccessing)
end

local function setOrgInventoryData(data)
    local items = {}
    local propertyItems = data.items

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
            type = "org"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

local function openOrgInventory()
    if ESX.isPlayerDead() then return end

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "org"
        }
    )
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')

    SetNuiFocus(true, true)
end

RegisterNetEvent("cframework:openOrgInventory", function(customJob)
    local job = ESX.GetPlayerData().job.name

    if customJob ~= nil then
		job = customJob
	end

    currentJobPlayerIsAccessing = job

    TriggerServerEvent('cframework:getOrgInventory', customJob)
end)

RegisterNetEvent('cframework:openNewOrgInventory', function(data)
    setOrgInventoryData(data)
    openOrgInventory()
end)

RegisterNetEvent("cframework:refreshOrgInventory", function()
    refreshOrgInventory()
    loadPlayerInventory()
end)

RegisterNUICallback("PutIntoOrg", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:putOrgItem", data.item.slot, count)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromOrg", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:takeOrgItem", data.item.slot, count, data.slot)
    end

    cb("ok")
end)
