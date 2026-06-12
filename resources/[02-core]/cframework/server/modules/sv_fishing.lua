

local fishingData = LoadFishing()

local playerFishingCoords = {}
local playerCurrentFishingRod = {}
local playerEquipedGear = {}

local fishTypes = fishingData.fishTypes
local rentBoatSpawnLocation = fishingData.rentBoatLocation
local rentVehicleSpawnLocation = fishingData.rentVehicleLocation

local restaurantLocation = {}
local rentBoatLocation = {}
local rentVehicleLocation = {}
local fishCanning = {}

local fishingSociety = fishingData.fishingSociety

Citizen.CreateThread(function()
    for _,v in ipairs(fishingData.restaurantLocation) do
        table.insert(restaurantLocation, vector3(v.x, v.y, v.z))
    end

    for _,v in ipairs(fishingData.rentBoatLocation) do
        table.insert(rentBoatLocation, vector3(v.x, v.y, v.z))
    end

    for _,v in ipairs(fishingData.rentVehicleLocation) do
        table.insert(rentVehicleLocation, vector3(v.x, v.y, v.z))
    end

    for _,v in ipairs(fishingData.fishCanning) do
        table.insert(fishCanning, vector3(v.x, v.y, v.z))
    end
end)

local restaurantCooldown = {}

local function getPedLocationData(source)
    local coords = GetEntityCoords(GetPlayerPed(source))

    for _,v in ipairs(fishingData.fishingLocations) do
        local distance = #(vector2(v.x, v.y) - coords.xy)

        if distance < v.radius then
            return v
        end
    end

    return nil
end

local function getFishByChance(fishableFish)
    local total = 0
    for _, fish in ipairs(fishableFish) do
        total = total + (fish.chance or 0)
    end

    if total <= 0 then return nil end

    local roll <const> = math.random() * total
    local sum = 0

    for _, fish in ipairs(fishableFish) do
        sum = sum + (fish.chance or 0)
        if roll < sum then
            return fish.name
        end
    end

    return nil
end

local function minimumRequisitesForFish(fishType, currentEquipment, currentRod)
    local rod = fishTypes[fishType].rod[currentRod]
    local reel = fishTypes[fishType].reel[currentEquipment["fishing-slot-4"].name]
    local nylon = fishTypes[fishType].nylon[currentEquipment["fishing-slot-3"].name]
    local anzol = fishTypes[fishType].anzol[currentEquipment["fishing-slot-2"].name]
    local bait = fishTypes[fishType].bait[currentEquipment["fishing-slot-1"].name]

    if rod == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_LET_FISH_GO_NOT_HAD_ROD"), "error")
        return false
    end

    if reel == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_LET_FISH_GO_NOT_HAD_REEL"), "error")
        return false
    end

    if nylon == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_LET_FISH_GO_NOT_HAD_NYLON"), "error")
        return false
    end

    if anzol == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_LET_FISH_GO_NOT_HAD_ANZOL"), "error")
        return false
    end

    if bait == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_LET_FISH_GO_NOT_HAD_BAIT"), "error")
        return false
    end

    return true
end

local function isFisherman(job)
   for i=1, #fishingData.fisherManJobs, 1 do
        if job == fishingData.fisherManJobs[i] then
            return true
        end
    end

    return false
end

local function isFishingShop(job)
    for i=1, #fishingData.fishingShopJobs, 1 do
        if job == fishingData.fishingShopJobs[i] then
            return true
        end
    end

    return false
end


ESX.RegisterUsableItem("elementalrod", function(source)
    playerCurrentFishingRod[source] = "elementalrod"
	TriggerClientEvent("cframework:useFishingRod", source, "elementalrod")
end)

ESX.RegisterUsableItem("magnumxlrod", function(source)
    playerCurrentFishingRod[source] = "magnumxlrod"
	TriggerClientEvent("cframework:useFishingRod", source, "magnumxlrod")
end)

RegisterNetEvent("cframework:startFishing", function(equipedGear)
    local source = source

    playerEquipedGear[source] = equipedGear
    playerFishingCoords[source] = {GetEntityCoords(GetPlayerPed(source))}
end)

RegisterNetEvent("cframework:lostFish", function()
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local currentEquipment = playerEquipedGear[source][playerCurrentFishingRod[source]]

    if currentEquipment == nil then return end

    local baitItemCount = inventory.getItemAmount(currentEquipment["fishing-slot-1"].name)

    if baitItemCount < 1 then return end

    inventory.removeItem(currentEquipment["fishing-slot-1"].name, 1)
end)

RegisterNetEvent("cframework:catchFish", function()
    local source = source
    local inventory <const> = ESX.getInvContainer(source)

    if not ESX.playerInsideLocation(source, playerFishingCoords[source], 10.0) then TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    if not ESX.passedCooldown(source, 7350) then return end
    if playerCurrentFishingRod[source] == nil then return end

    local rodItemCount = inventory.getItemAmount(playerCurrentFishingRod[source])

    if rodItemCount < 1 then TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    local locationData = getPedLocationData(source)
    local currentEquipment = playerEquipedGear[source][playerCurrentFishingRod[source]]

    if currentEquipment == nil then TriggerClientEvent("cframework:forceCancelFishing", source) return end

    if locationData == nil then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_NOT_IN_FISHING_ZONE"), "error")
        TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    if currentEquipment["fishing-slot-1"] == nil or currentEquipment["fishing-slot-2"] == nil or currentEquipment["fishing-slot-3"] == nil or currentEquipment["fishing-slot-4"] == nil then
        TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    if currentEquipment["fishing-slot-1"].name == nil or currentEquipment["fishing-slot-2"].name == nil or currentEquipment["fishing-slot-3"].name == nil or currentEquipment["fishing-slot-4"].name == nil then
        TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    local baitItemCount = inventory.getItemAmount(currentEquipment["fishing-slot-1"].name)
    local anzolItemCount = inventory.getItemAmount(currentEquipment["fishing-slot-2"].name)
    local nylonItemCount = inventory.getItemAmount(currentEquipment["fishing-slot-3"].name)
    local reelItemCount = inventory.getItemAmount(currentEquipment["fishing-slot-4"].name)

    if baitItemCount < 1 then TriggerClientEvent("cframework:forceCancelFishing", source) return end
    if anzolItemCount < 1 then TriggerClientEvent("cframework:forceCancelFishing", source) return end
    if nylonItemCount < 1 then TriggerClientEvent("cframework:forceCancelFishing", source) return end
    if reelItemCount < 1 then TriggerClientEvent("cframework:forceCancelFishing", source) return end

    local fishableFish = locationData.fishableFish

    if #fishableFish == 0 then
        TriggerClientEvent("esx:showNotification", source, T("FISHING_NO_FISH_AVAILABLE"), "error")
        TriggerClientEvent("cframework:forceCancelFishing", source)
        return
    end

    -- escolher pelo peso/chance
    local choosenFish = getFishByChance(fishableFish)

    inventory.removeItem(currentEquipment["fishing-slot-1"].name, 1)

    if not minimumRequisitesForFish(choosenFish, currentEquipment, playerCurrentFishingRod[source]) then
        return
    end

    if inventory.canAddItem(choosenFish, 1) then
        inventory.addItem(choosenFish, 1)
    else
        TriggerClientEvent("esx:showNotification", source, T("FISHING_NO_INVENTORY_SPACE_TO_CATCH_FISH"), "error")
    end
end)

RegisterNetEvent("cframework:sellRestaurant", function(items)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local job = ESX.getJob(source).name
    local allowedItems = {}

    local isInside, id = ESX.playerInsideLocationReturnId(source, restaurantLocation, 10.0)

    if not isInside then TriggerClientEvent("cframework:unableToSellRestaurant", source)
        return
    end

    if not isFisherman(job) and not isFishingShop(job) then TriggerClientEvent("cframework:unableToSellRestaurant", source)
        return
    end

    if restaurantCooldown[source] == nil then restaurantCooldown[source] = {} end

    local now = GetGameTimer() --miliseconds

    if restaurantCooldown[source][id] ~= nil and now - restaurantCooldown[source][id] < fishingData.restaurantCooldown then TriggerClientEvent("cframework:inStillCooldownRestaurant", source)--30 minutos
        return
    end

    restaurantCooldown[source][id] = now

    if isFisherman(job) then
        allowedItems = fishingData.fishermanSellPrices
    else
        allowedItems = fishingData.fishSaleValue
    end

    local shop = nil

    if fishingSociety[job] then
        shop = GetSharedAccount("society_"..fishingSociety[job])
    end

    TriggerClientEvent("cframework:soldToRestaurant", source)

    local count = 0

    for k,item in ipairs(items) do
        local itemCount = inventory.getItemAmount(item.name)

        if itemCount < item.count then
            goto next
        end

        if allowedItems[item.name] == nil then
            goto next
        end

        count = count + item.count

        inventory.removeItem(item.name, item.count)
        inventory.addItem("cash", allowedItems[item.name]*item.count)

        if shop ~= nil then
            shop.addMoney(ESX.Math.Round(allowedItems[item.name]*item.count*0.2))
        end

        ::next::
    end

end)


RegisterNetEvent("cframework:rentFishingBoat", function()
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local job = ESX.getJob(source).name
    local rentPrice = fishingData.fishermanBoatPrice

    if not isFisherman(job) and not isFishingShop(job) then
        return
    end

    local isInside, id = ESX.playerInsideLocationReturnId(source, rentBoatLocation, 10.0)

    if not isInside then return end

    if isFishingShop(job) then
        rentPrice = fishingData.fishingShopBoatPrice
    end

    if not inventory.canRemoveItem("cash", rentPrice) then TriggerClientEvent("cframework:fishingInsufficientMoney", source) return end

    if not ESX.passedCooldown(source, 10000) then
        return
    end

    inventory.removeItem("cash", rentPrice)

    local shop = nil

    if fishingSociety[job] then
        shop = GetSharedAccount("society_"..fishingSociety[job])
    end

    if shop ~= nil then
        shop.addMoney(ESX.Math.Round(rentPrice*0.2))
        GetSharedAccount("society_governo").addMoney(ESX.Math.Round(rentPrice*0.8))
    else
        GetSharedAccount("society_governo").addMoney(rentPrice)
    end

    local spawn = rentBoatSpawnLocation[id].spawn

    local v = CreateVehicle(fishingData.rentalBoatModel, spawn.x, spawn.y, spawn.z, spawn.w, true, true)

    local plate = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

    TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)
end)


local spawnedFishingTrucks = {}

RegisterNetEvent("cframework:rentTruckVehicle", function()
    local source = source
    local job = ESX.getJob(source).name

    if not isFisherman(job) then
        return
    end

    local isInside, id = ESX.playerInsideLocationReturnId(source, rentVehicleLocation, 10.0)

    if not isInside then return end

    if not ESX.passedCooldown(source, 10000) then
        return
    end

    if spawnedFishingTrucks[source] ~= nil and DoesEntityExist(spawnedFishingTrucks[source]) then TriggerClientEvent("cframework:onlyOneFishingVehicle", source) return end

    local spawn = rentVehicleSpawnLocation[id].spawn
    local hash = fishingData.fishermanVehicle[job]

    local v = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w, true, true)

    TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

    local plate = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

    spawnedFishingTrucks[source] = v
end)

RegisterNetEvent("cframework:fishCanning", function(type)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local canningData = fishingData.canning[type]

    if not isFisherman(ESX.getJob(source).name) then
        return
    end

    if not ESX.playerInsideLocation(source, fishCanning, 10.0) then
        return
    end

    if not ESX.passedCooldown(source, canningData.time - 150) then
        return
    end

    if canningData == nil then
        return
    end

    for _,v in ipairs(canningData.items_in) do
        if not inventory.canRemoveItem(v.name, v.count) then
            TriggerClientEvent("esx:showNotification", source, T("FISHING_NOT_ENOUGH_FISH"), "error")
            TriggerClientEvent("fishingFail", source)
            return
        end
    end

    for _,v in ipairs(canningData.items_out) do
        if not inventory.canAddItem(v.name, v.count) then
            TriggerClientEvent("esx:showNotification", source, T("FISHING_INVENTORY_FULL_FOR_CANNING"), "error")
            TriggerClientEvent("fishingFail", source)
            return
        end
    end

    for _,v in ipairs(canningData.items_in) do
        inventory.removeItem(v.name, v.count)
    end

    for _,v in ipairs(canningData.items_out) do
        inventory.addItem(v.name, v.count)
    end
end)