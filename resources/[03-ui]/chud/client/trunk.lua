local trunkData = nil
local isTrunkOpen = false
local trunkInventories = {}

local invMax = 0
local curPlate = 0


-- Key controls
Citizen.CreateThread(function()
    Citizen.Wait(15000)
    exports.ft_libs:RemoveButton("esx:inventoryhud_trunk")
    exports.ft_libs:AddButton("esx:inventoryhud_trunk", {
        key = TrunkConfig.OpenKey,
        use = {
            callback = openVehicleInventory,
        },
    })
end)

RegisterNetEvent('inventoryClosed', function()
    if isTrunkOpen then
        TriggerServerEvent('cframework:closeTrunkInventory', curPlate)
    end
    isTrunkOpen = false
end)

RegisterNetEvent('cframework:backButtonPressed', function()
    if isTrunkOpen then
        TriggerServerEvent('cframework:closeTrunkInventory', curPlate)
    end
    isTrunkOpen = false
end)

local inTrunk, inTrunkVehicle = false, 0
local trunkVehicle = 0

exports('isPlayerInTrunk', function()
    return inTrunk
end)

local function cleanupTrunk()
    local ped <const> = PlayerPedId()

    inTrunk = false
    inTrunkVehicle = 0

    if IsEntityAttached(ped) then
        DetachEntity(ped, false, false)
    end

    SetEntityVisible(ped, true, false)
    ClearPedTasks(ped)
end

local function leaveTrunk()
    if not inTrunkVehicle == 0 then return end

    local vehicle <const> = trunkVehicle
    local ped <const> = PlayerPedId()
    local vehicleModel <const> = GetEntityModel(vehicle)
    local doorIdx = 5

    SetEntityVisible(ped, true, false)

    TriggerServerEvent("cframework:exitTrunk")
    TriggerEvent("cframework:enablePegar")
    TriggerEvent('cframework:enableEmotes')
    TriggerEvent('cframework:enableCair')

    if not DoesEntityExist(inTrunkVehicle) then
        cleanupTrunk()
        return
    end

    if not GetIsDoorValid(trunkVehicle, doorIdx) then return cleanupTrunk() end

    inTrunkVehicle = 0

    --if GetVehicleDoorAngleRatio(vehicle, doorIdx) < 0.1 then
        SetVehicleDoorOpen(vehicle, doorIdx, false, false)
    --end

    local dimMin <const>, dimMax <const> = GetModelDimensions(vehicleModel)
    local size <const> = (dimMax - dimMin).y
    local offset <const> = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -(size / 2 + 0.75), 0.0)

    Citizen.Wait(1000)
    DetachEntity(ped, false, false)
    ClearPedTasks(ped)
    SetEntityCoords(ped, offset.x, offset.y, offset.z, false, false, false, false)
    Citizen.Wait(500)
    SetVehicleDoorShut(vehicle, doorIdx, false)

    inTrunk = false
end

local function enterTrunk(vehicle)
    local doorIdx = 5

    TriggerEvent("cframework:stopPegar")
    TriggerEvent("cframework:disablePegar")
    TriggerEvent('cframework:disableEmotes')
    TriggerEvent('cframework:disableCair')

    if GetVehicleDoorAngleRatio(vehicle, doorIdx) < 0.1 then
        SetVehicleDoorOpen(vehicle, doorIdx, false, false)
    end

    local ped <const> = PlayerPedId()

    AttachEntityToEntity(ped, vehicle, -1, 0.0, -1.7, 0.3, 0.0, 0.0, 0.0, false, false, false, false, 20, true)

    RequestAnimDict("timetable@floyd@cryingonbed@base")

    while not HasAnimDictLoaded("timetable@floyd@cryingonbed@base") do
        Citizen.Wait(0)
    end

    TaskPlayAnim(ped, "timetable@floyd@cryingonbed@base", "base", 8.0, 8.0, -1, 1, 0, true, true, true)

    inTrunk = true
    inTrunkVehicle = vehicle

    local leavingTrunk = false

    Citizen.CreateThreadNow(function()
        while inTrunk do
            if not DoesEntityExist(vehicle) then
                cleanupTrunk()
                break
            else
                -- Force player to vehicle cam
                SetInVehicleCamStateThisUpdate(vehicle, 0)
            end

            if IsControlJustReleased(0, 23) and not ESX.isPlayerDead() then
                if not leavingTrunk then
                    leavingTrunk = true
                    Citizen.CreateThreadNow(function()
                        leaveTrunk()
                        leavingTrunk = false
                    end)
                end
            end

            if not IsEntityAttached(PlayerPedId()) then
                leaveTrunk()
            end

            Citizen.Wait(0)
        end
    end)

    Citizen.Wait(1000)

    SetVehicleDoorShut(vehicle, doorIdx, false)
    SetEntityVisible(ped, false, false)
end

local function playerInTrunkCheck(hasPlayerInTrunk)
    local availableActions = {}

    if not hasPlayerInTrunk then
        availableActions["enterTrunk"] = true
        availableActions["putTrunk"] = true
    else
        availableActions["removeTrunk"] = true
    end

    TriggerEvent("cframework:setAvailableActions", availableActions)
end

RegisterNetEvent("cframework:enterTrunk", function()
    if not DoesEntityExist(trunkVehicle) then return end

    enterTrunk(trunkVehicle)
end)

RegisterNetEvent("cframework:enterTrunkCarry", function(netId)
    trunkVehicle = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(trunkVehicle) then return end

    Citizen.Wait(1000)

    enterTrunk(trunkVehicle)
end)

RegisterNetEvent("cframework:trunkDoesntExist", function()
    ESX.ShowNotification("A bagageira não existe", "error")
end)

RegisterNetEvent("cframework:trunkOccupied", function()
    ESX.ShowNotification("A bagageira já se encontra ocupada", "error")
end)

RegisterNetEvent("cframework:trunkEmpty", function()
    ESX.ShowNotification("A bagageira está vazia", "error")
end)

RegisterNetEvent("cframework:forceExitTrunk", function()
    leaveTrunk()
end)

AddEventHandler('esx:onPlayerDeath', function()
	TriggerEvent("cframework:forceExitTrunk")
end)

RegisterNetEvent("cframework:chooseActionOption", function(id)
    if id == "enterTrunk" then
        TriggerEvent("cframework:stopPegar")

        local vehicle <const> = VehicleInFront()

        if inTrunk then return end

        local doorIdx <const> = 5

        if not GetIsDoorValid(vehicle, doorIdx) then return end

        if IsPedInAnyVehicle(PlayerPedId(), true) then return end

        trunkVehicle = vehicle

        TriggerServerEvent("cframework:hideInTrunk", NetworkGetNetworkIdFromEntity(vehicle))

        return
    end

    if id == "putTrunk" then
        local vehicle <const> = VehicleInFront()

        if inTrunk then return end

        local doorIdx <const> = 5

        if not GetIsDoorValid(vehicle, doorIdx) then return end

        if IsPedInAnyVehicle(PlayerPedId(), true) then return end

        trunkVehicle = vehicle

        TriggerEvent("cframework:hideCarryInTrunk", NetworkGetNetworkIdFromEntity(vehicle))

        return
    end

    if id == "removeTrunk" then
        local vehicle = VehicleInFront()

        TriggerServerEvent("cframework:removePlayerFromTrunk", NetworkGetNetworkIdFromEntity(vehicle))

        return
    end
end)

function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetShapeTestResult(rayHandle)
    return result
end

function openVehicleInventory()
    if ESX.isPlayerDead() then return end
    if ESX.isHandcuffed() then return end

    local playerPed = GetPlayerPed(-1)
    local vehicle = VehicleInFront()

    if not DoesEntityExist(vehicle) then ESX.ShowNotification('Nenhum veículo por perto.', 'error') return end
    if IsPedInAnyVehicle(playerPed, true) then ESX.ShowNotification('Não podes abrir a mala de um veículo dentro dele.', 'error') return end

    if GetPedInVehicleSeat(vehicle, -1) ~= 0 then ESX.ShowNotification('Alguém está dentro do veículo.', 'error') return end

    if not NetworkHasControlOfEntity(vehicle) then NetworkRequestControlOfEntity(vehicle) Citizen.Wait(250) end

    local locked = GetVehicleDoorLockStatus(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    if plate == nil or plate == "" or plate == " " then ESX.ShowNotification('Não foi possivel abrir a mala do veículo', 'error') return end

    if locked ~= 1 and locked ~= 0 then ESX.ShowNotification('Veículo trancado.', 'error') return end

    SetVehicleDoorOpen(vehicle, 5, false, false)

    isTrunkOpen = true

    ESX.UI.Menu.CloseAll()

    local size = ESX.getTrunkInventorySize(GetEntityModel(vehicle))

    OpenCoffreInventoryMenu(plate, size)

    while isTrunkOpen do
        Citizen.Wait(100)
        if not DoesEntityExist(vehicle) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > 6.0 or IsPedInAnyVehicle(playerPed, true) then
            closeInventory()
        end
    end

    SetVehicleDoorShut(vehicle, 5, false)
end

function OpenCoffreInventoryMenu(plate, max)
    if trunkInventories[plate] == nil then
        TriggerServerEvent('cframework:getTrunkInventory', plate, max, 0)
    else
        TriggerServerEvent('cframework:getTrunkInventory', plate, max, trunkInventories[plate].invId)
    end

    curPlate = plate
    invMax = max
end

RegisterNetEvent('cframework:openExistingTrunkInventory', function(hasPlayerInTrunk)
    local inventory = trunkInventories[curPlate].inventory
    local text = _U("trunk_info", curPlate, (inventory.weight / 100), (invMax / 100))
    local data = {plate = curPlate, max = invMax, myVeh = true, text = text}

    playerInTrunkCheck(hasPlayerInTrunk)

    TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.items)
end)

RegisterNetEvent('cframework:openNewTrunkInventory', function(inventory, invId, hasPlayerInTrunk)
    local text = _U("trunk_info", curPlate, (inventory.weight / 100), (invMax / 100))
    local data = {plate = curPlate, max = invMax, myVeh = true, text = text}

    playerInTrunkCheck(hasPlayerInTrunk)

    TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.items)

    trunkInventories[curPlate] = {
        inventory = inventory,
        invId = invId
    }
end)

RegisterNetEvent('cframework:addTrunkInventoryItem', function(item, count, invCount, insert, invId, weight)
    trunkInventories[curPlate].invId = invId
    trunkInventories[curPlate].inventory.weight = weight

    if insert then
        table.insert(trunkInventories[curPlate].inventory.items, item)
    else
        for k,v in ipairs(trunkInventories[curPlate].inventory.items) do
            if v.slot == item.slot then
                trunkInventories[curPlate].inventory.items[k].count = item.count
                break
            end
        end
    end

    local text = _U("trunk_info", curPlate, (trunkInventories[curPlate].inventory.weight / 100), (invMax / 100))
    local data = {plate = curPlate, max = invMax, myVeh = true, text = text}

    setTrunkInventoryData(data, trunkInventories[curPlate].inventory.items)
    loadPlayerInventory()
end)

RegisterNetEvent('cframework:removeTrunkInventoryItem', function(item, count, invCount, remove, invId, weight)
    trunkInventories[curPlate].invId = invId
    trunkInventories[curPlate].inventory.weight = weight

	for k,v in ipairs(trunkInventories[curPlate].inventory.items) do
		if v.name == item.name and v.slot == item.slot then
            if remove then
                table.remove(trunkInventories[curPlate].inventory.items, k)
            else
                trunkInventories[curPlate].inventory.items[k].count = item.count
            end
			break
		end
	end

    local text = _U("trunk_info", curPlate, (trunkInventories[curPlate].inventory.weight / 100), (invMax / 100))
    local data = {plate = curPlate, max = invMax, myVeh = true, text = text}

    setTrunkInventoryData(data, trunkInventories[curPlate].inventory.items)
    loadPlayerInventory()
end)



RegisterNetEvent("esx_inventoryhud:openTrunkInventory", function(data, inventory)
    setTrunkInventoryData(data, inventory)
    openTrunkInventory()
end)

RegisterNetEvent("esx_inventoryhud:openTrunkInventoryForPreview", function(inventory, id)
    table.sort(inventory, compare)

    local items = {}

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            inventory[key].usable = false
            inventory[key].limit = -1
            inventory[key].canRemove = false
            table.insert(items, inventory[key])
        end
    end

    SendNUIMessage(
        {
            action = "setGarageTrunkInv",
            items = items,
            id = id
        }
    )
end)

RegisterNetEvent("esx_inventoryhud:refreshTrunkInventory", function(data, inventory)
    setTrunkInventoryData(data, inventory)
    loadPlayerInventory()
end)

function setTrunkInventoryData(data, inventory)
    trunkData = data

    SendNUIMessage(
        {
            action = "setType",
            type = "trunk"
        }
    )

    SendNUIMessage(
        {
            action = "setInfoText",
            text = data.text
        }
    )

    table.sort(inventory, compare)

    local items = {}

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                inventory[key] = nil
            else
                inventory[key].usable = false
                inventory[key].limit = -1
                inventory[key].canRemove = false
                table.insert(items, inventory[key])
            end
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openTrunkInventory()
    if ESX.isPlayerDead() then return end

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "trunk"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end

RegisterNUICallback("PutIntoTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number and trunkData ~= nil then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:putTrunkItem", trunkData.plate, data.item.slot, count)
    end

    cb("ok")
end)

RegisterNUICallback("TakeFromTrunk", function(data, cb)
    if IsPedSittingInAnyVehicle(playerPed) then
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number and trunkData ~= nil then
        local limit = ESX.GetItemLimit(data.item.name)
        local count = (tonumber(data.number) > limit and limit ~= -1) and limit or tonumber(data.number)

        TriggerServerEvent("cframework:getTrunkItem", trunkData.plate, data.item.slot, count, data.slot)
    end

    cb("ok")
end)

RegisterNUICallback("showTrunkInv", function(data, cb)
    if trunkInventories[data.plate] == nil then
        TriggerServerEvent('cframework:getTrunkInventoryForPreview', data.plate, 0, data.id, ESX.getTrunkInventorySize(data.model))
    else
        TriggerServerEvent('cframework:getTrunkInventoryForPreview', data.plate, trunkInventories[data.plate].invId, data.id, ESX.getTrunkInventorySize(data.model))
    end

    cb("ok")
end)

RegisterNetEvent('cframework:openExistingTrunkInventoryForPreview', function(id, plate)
    local inventory = trunkInventories[plate].inventory

    TriggerEvent("esx_inventoryhud:openTrunkInventoryForPreview", inventory.items, id)
end)

RegisterNetEvent('cframework:openNewTrunkInventoryForPreview', function(inventory, invId, id, plate)
    TriggerEvent("esx_inventoryhud:openTrunkInventoryForPreview", inventory.items, id)

    trunkInventories[plate] = {
        inventory = inventory,
        invId = invId
    }
end)

RegisterNetEvent('cframework:existingVehicleDisablePreview', function(id, plate)
    SendNUIMessage(
        {
            action = "disableGarageTrunkPreview",
            id = id
        }
    )
end)