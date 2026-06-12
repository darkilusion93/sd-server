

local fishingData = LoadFishing()

local equipedGear = {}
local currentFishingRod, isFishing, inFishingCooldown = nil, false, false
local createdMarkers = {}
local PlayerData = {}
local CurrentAction = nil

local canWorkFishing = false

local canningActive = false
local canningTime = 1000
local material = ""

local restaurantLocation = fishingData.restaurantLocation
local rentBoatLocation = fishingData.rentBoatLocation
local deleteBoatLocation = fishingData.deleteBoatLocation
local fishCanning = fishingData.fishCanning
local fishingCloakroom = fishingData.fishingCloakroom
local rentVehicleLocation = fishingData.rentVehicleLocation


local function isPedCloseToWater()
    local finalCoords = GetEntityCoords(PlayerPedId()) + GetEntityForwardVector(PlayerPedId()) * 10.0
    local retval, height = TestVerticalProbeAgainstAllWater(finalCoords.x, finalCoords.y, finalCoords.z + 32.0, 1)

    if height > 45.0 then return false end

    return retval == 1
end

local function isFishingEquipmentValid()
    if currentFishingRod == nil then return false end
    if equipedGear[currentFishingRod] == nil then return false end

    if equipedGear[currentFishingRod]["fishing-slot-1"] == nil then return false end
    if equipedGear[currentFishingRod]["fishing-slot-2"] == nil then return false end
    if equipedGear[currentFishingRod]["fishing-slot-3"] == nil then return false end
    if equipedGear[currentFishingRod]["fishing-slot-4"] == nil then return false end

    return true
end

local function removeFishingMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end

    for i=1, #restaurantLocation, 1 do
        if restaurantLocation[i].blip ~= nil then
            RemoveBlip(restaurantLocation[i].blip)
            restaurantLocation[i].blip = nil
        end
    end

    for i=1, #rentBoatLocation, 1 do
        if rentBoatLocation[i].blip ~= nil then
            RemoveBlip(rentBoatLocation[i].blip)
            rentBoatLocation[i].blip = nil
        end
    end

    for i=1, #fishCanning, 1 do
        if fishCanning[i].blip ~= nil then
            RemoveBlip(fishCanning[i].blip)
            fishCanning[i].blip = nil
        end
    end

    for i=1, #fishingCloakroom, 1 do
        if fishingCloakroom[i].blip ~= nil then
            RemoveBlip(fishingCloakroom[i].blip)
            fishingCloakroom[i].blip = nil
        end
    end

    for i=1, #rentVehicleLocation, 1 do
        if rentVehicleLocation[i].blip ~= nil then
            RemoveBlip(rentVehicleLocation[i].blip)
            rentVehicleLocation[i].blip = nil
        end
    end

    createdMarkers = {}
end

local function isFisherman()
   for i=1, #fishingData.fisherManJobs, 1 do
        if PlayerData.job.name == fishingData.fisherManJobs[i] then
            return true
        end
    end

    return false
end

local function isFishingShop()
    for i=1, #fishingData.fishingShopJobs, 1 do
        if PlayerData.job.name == fishingData.fishingShopJobs[i] then
            return true
        end
    end

    return false
end

local function getPedLocationData()
    local coords = GetEntityCoords(PlayerPedId())

    for _,v in ipairs(fishingData.fishingLocations) do
        local distance = #(vector2(v.x, v.y) - coords.xy)

        if distance < v.radius then
            return v
        end
    end

    return nil
end

local function isJobInFilter(job, filter)
    for i=1, #filter, 1 do
        if job == filter[i] then
            return true
        end
    end

    return false
end

local function createFishingMarkers()
    if PlayerData.job ~= nil and not isFishingShop() and not isFisherman() then
        return
    end

    canWorkFishing = false

    for i=1, #restaurantLocation, 1 do
        exports.ft_libs:AddMarker("fishing_restaurant" .. i, {type = 50, x = restaurantLocation[i].x, y = restaurantLocation[i].y, z = restaurantLocation[i].z, weight = 1, height = 1, red = 255, green = 128, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_restaurant" .. i, {x = restaurantLocation[i].x, y = restaurantLocation[i].y, z = restaurantLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "restaurant", active = {}})
        table.insert(createdMarkers, "fishing_restaurant" .. i)

        restaurantLocation[i].blip = AddBlipForCoord(restaurantLocation[i].x, restaurantLocation[i].y, restaurantLocation[i].z)
        SetBlipSprite(restaurantLocation[i].blip, 1)
        SetBlipDisplay(restaurantLocation[i].blip, 4)
        SetBlipScale(restaurantLocation[i].blip, 0.4)
        SetBlipColour(restaurantLocation[i].blip, 26)
        SetBlipAsShortRange(restaurantLocation[i].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(T("FISHING_RESTAURANT"))
        EndTextCommandSetBlipName(restaurantLocation[i].blip)
    end

    for i=1, #rentBoatLocation, 1 do
        if not isJobInFilter(PlayerData.job.name, rentBoatLocation[i].jobs) then goto jump_renting end

        exports.ft_libs:AddMarker("fishing_rentboat" .. i, {type = 50, x = rentBoatLocation[i].x, y = rentBoatLocation[i].y, z = rentBoatLocation[i].z, weight = 1, height = 1, red = 245, green = 84, blue = 66, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_rentboat" .. i, {x = rentBoatLocation[i].x, y = rentBoatLocation[i].y, z = rentBoatLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "rentboat", active = {}})
        table.insert(createdMarkers, "fishing_rentboat" .. i)

        rentBoatLocation[i].blip = AddBlipForCoord(rentBoatLocation[i].x, rentBoatLocation[i].y, rentBoatLocation[i].z)
        SetBlipSprite(rentBoatLocation[i].blip, 780)
        SetBlipDisplay(rentBoatLocation[i].blip, 4)
        SetBlipScale(rentBoatLocation[i].blip, 0.5)
        SetBlipColour(rentBoatLocation[i].blip, 44)
        SetBlipAsShortRange(rentBoatLocation[i].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(T("FISHING_BOAT_RENTAL"))
        EndTextCommandSetBlipName(rentBoatLocation[i].blip)

        ::jump_renting::
    end

    for i=1, #deleteBoatLocation, 1 do
        if not isJobInFilter(PlayerData.job.name, deleteBoatLocation[i].jobs) then goto jump_deleter end

        exports.ft_libs:AddMarker("fishing_deleter" .. i, {type = 50, x = deleteBoatLocation[i].x, y = deleteBoatLocation[i].y, z = deleteBoatLocation[i].z, weight = 1, height = 1, red = 255, green = 0, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_deleter" .. i, {x = deleteBoatLocation[i].x, y = deleteBoatLocation[i].y, z = deleteBoatLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "deleter", active = {}})
        table.insert(createdMarkers, "fishing_deleter" .. i)

        ::jump_deleter::
    end

    for i=1, #fishCanning, 1 do
        if not isFisherman() then goto jump_processer end

        exports.ft_libs:AddMarker("fishing_processing" .. i, {type = 50, x = fishCanning[i].x, y = fishCanning[i].y, z = fishCanning[i].z, weight = 1, height = 1, red = 255, green = 123, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_processing" .. i, {x = fishCanning[i].x, y = fishCanning[i].y, z = fishCanning[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "processing", active = {}})
        table.insert(createdMarkers, "fishing_processing" .. i)

        fishCanning[i].blip = AddBlipForCoord(fishCanning[i].x, fishCanning[i].y, fishCanning[i].z)
        SetBlipSprite(fishCanning[i].blip,728)
        SetBlipDisplay(fishCanning[i].blip, 4)
        SetBlipScale(fishCanning[i].blip, 0.5)
        SetBlipColour(fishCanning[i].blip, 61)
        SetBlipAsShortRange(fishCanning[i].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(T("FISHING_CANNING"))
        EndTextCommandSetBlipName(fishCanning[i].blip)

        ::jump_processer::
    end

    for i=1, #fishingCloakroom, 1 do
        if not isJobInFilter(PlayerData.job.name, fishingCloakroom[i].jobs) then goto jump_cloakroom end

        exports.ft_libs:AddMarker("fishing_cloakroom" .. i, {type = 50, x = fishingCloakroom[i].x, y = fishingCloakroom[i].y, z = fishingCloakroom[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_cloakroom" .. i, {x = fishingCloakroom[i].x, y = fishingCloakroom[i].y, z = fishingCloakroom[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "cloakroom", active = {}})
        table.insert(createdMarkers, "fishing_cloakroom" .. i)

        fishingCloakroom[i].blip = AddBlipForCoord(fishingCloakroom[i].x, fishingCloakroom[i].y, fishingCloakroom[i].z)
        SetBlipSprite(fishingCloakroom[i].blip, 280)
        SetBlipDisplay(fishingCloakroom[i].blip, 4)
        SetBlipScale(fishingCloakroom[i].blip, 0.5)
        SetBlipColour(fishingCloakroom[i].blip, 5)
        SetBlipAsShortRange(fishingCloakroom[i].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(T("FISHING_CLOAKROOM"))
        EndTextCommandSetBlipName(fishingCloakroom[i].blip)

        ::jump_cloakroom::
    end

    for i=1, #rentVehicleLocation, 1 do
        if not isJobInFilter(PlayerData.job.name, rentVehicleLocation[i].jobs) then goto jump_rentingvehicle end

        exports.ft_libs:AddMarker("fishing_rentvehicle" .. i, {type = 50, x = rentVehicleLocation[i].x, y = rentVehicleLocation[i].y, z = rentVehicleLocation[i].z, weight = 1, height = 1, red = 245, green = 84, blue = 66, showDistance = 25})
        exports.ft_libs:AddTrigger("fishing_rentvehicle" .. i, {x = rentVehicleLocation[i].x, y = rentVehicleLocation[i].y, z = rentVehicleLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "fishingEnteredMarker"}, exit = {eventClient = "fishingExitedMarker"}, data = "rentvehicle", active = {}})
        table.insert(createdMarkers, "fishing_rentvehicle" .. i)

        rentVehicleLocation[i].blip = AddBlipForCoord(rentVehicleLocation[i].x, rentVehicleLocation[i].y, rentVehicleLocation[i].z)
        SetBlipSprite(rentVehicleLocation[i].blip, 616)
        SetBlipDisplay(rentVehicleLocation[i].blip, 4)
        SetBlipScale(rentVehicleLocation[i].blip, 0.5)
        SetBlipColour(rentVehicleLocation[i].blip, 82)
        SetBlipAsShortRange(rentVehicleLocation[i].blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(T("FISHING_VEHICLE"))
        EndTextCommandSetBlipName(rentVehicleLocation[i].blip)

        ::jump_rentingvehicle::
    end
end

local function chooseFishToSell()
    local dispenseFilter = {}

    if isFisherman() then
        for k,_ in pairs(fishingData.fishSaleValue) do
            table.insert(dispenseFilter, k)
        end
    else
        for k,_ in pairs(fishingData.fishShopSaleValue) do
            table.insert(dispenseFilter, k)
        end
    end

    TriggerEvent("chud:dispense", T("GENERIC_SELL"), 100, dispenseFilter, function(items)
        TriggerServerEvent("cframework:sellRestaurant", items)
    end)
end

local function openRentBoatMenu()
    local elements = {}

    if isFishingShop() then
        table.insert(elements, { label = string.format("🛥️ %s (%s€)", T("FISHING_BOAT_RENTAL"), fishingData.fishingShopBoatPrice), value = "rent" })
    else
        table.insert(elements, { label = string.format("🛥️ %s (%s€)", T("FISHING_BOAT_RENTAL"), fishingData.fishermanBoatPrice), value = "rent" })
    end

    TriggerEvent("chud:menu", elements, T("FISHING_BOAT_RENTAL"), function(value)
        if value == "rent" then
            TriggerEvent("esx_inventoryhud:doClose")
            TriggerServerEvent("cframework:rentFishingBoat")
        end
    end)
end

local function openRentVehicleMenu()
    local elements = {
        { label = string.format("🚚 %s", T("FISHING_VAN_REMOVE")), value = "rent" }
    }

    TriggerEvent("chud:menu", elements, T("FISHING_VAN_RENTAL"), function(value)
        if value == "rent" then
            TriggerEvent("esx_inventoryhud:doClose")
            TriggerServerEvent("cframework:rentTruckVehicle")
        end
    end)
end

local function fishingCloakroomFunc()
    local elements = {
        {label = string.format("🧥 %s", T("GENERIC_CLOTHING_CITIZEN")), value = "cloakroom1"},
        {label = string.format("👔 %s", T("GENERIC_CLOTHING_JOB")), value = "cloakroom2"},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent("chud:menu", elements, T("FISHING_FISHERMAN"), function(value)
        if value == "cloakroom1" then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
            canWorkFishing = false
        end

        if value == "cloakroom2" then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_male)
                else
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_female)
                end
            end)
            canWorkFishing = true
        end
    end)
end

local function startCanning()
    Citizen.CreateThread(function()
        if canningActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        while canningActive do
            TriggerServerEvent("cframework:fishCanning", material)

            Citizen.Wait(canningTime)
        end
    end)

    Citizen.CreateThread(function()
        while canningActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification(T("FISHING_PRESS_TO_STOP_CANNING"))

            if IsControlJustReleased(1, 51) then
                Citizen.Wait(canningTime)
                TriggerEvent("fishingFail")
            end
        end
    end)
end

local function fishProcessCanning()
    local elements = {}

    for k,_ in pairs(fishingData.canning) do
        table.insert(elements, { label = ESX.GetItemLabel(k), value = k })
    end

    TriggerEvent("chud:itemselector", elements, T("FISHING_CAN"), T("FISHING_CAN"), function(value)
        if value == nil then return end

        material = value
        canningTime = fishingData.canning[value].time
        canningActive = true

        if canningActive then
            TriggerEvent("esx_inventoryhud:doClose")
            startCanning()
        end
    end)
end

ESX.IsThisFishingEquipmentValid = function(type, gear)
    for _, fish in pairs(fishingData.fishTypes) do
        if fish[type] and fish[type][gear] then
            return true
        end
    end

    return false
end

RegisterNetEvent("fishingFail", function()
    local ped = PlayerPedId()
    canningActive = false
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end)

RegisterNetEvent("cframework:onlyOneFishingVehicle", function()
    ESX.ShowNotification(T("FISHING_MAX_ONE_VEHICLE"), "error")
end)

RegisterNetEvent("cframework:fishingInsufficientMoney", function()
    ESX.ShowNotification(T("GENERIC_NOT_ENOUGH_MONEY"), "error")
end)

RegisterNetEvent("cframework:unableToSellRestaurant", function()
    ESX.ShowNotification(T("FISHING_UNABLE_TO_SELL_RESTAURANT"), "error")
end)

RegisterNetEvent("cframework:inStillCooldownRestaurant", function()
    ESX.ShowNotification(T("FISHING_STILL_IN_RESTAURANT_COOLDOWN"), "error")
end)

RegisterNetEvent("cframework:soldToRestaurant", function()
    TriggerEvent("esx_inventoryhud:doClose")

    local pCoords = GetEntityCoords(PlayerPedId())

    for i=1, #restaurantLocation, 1 do
        if #(vector3(restaurantLocation[i].x, restaurantLocation[i].y, restaurantLocation[i].z) - pCoords) < 8 then
            Citizen.CreateThread(function()
                SetBlipColour(restaurantLocation[i].blip, 1)
                Citizen.Wait(fishingData.restaurantCooldown)
                SetBlipColour(restaurantLocation[i].blip, 26)
            end)
        end
    end
end)

RegisterNetEvent("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
    removeFishingMarkers()
    createFishingMarkers()
end)

RegisterNetEvent("esx:setJob", function(job)
    PlayerData.job = job
    removeFishingMarkers()
    createFishingMarkers()
end)

RegisterNetEvent("fishingEnteredMarker", function(action)
    CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == "restaurant" then
                CurrentAction = nil
                if canWorkFishing or isFishingShop() then
                    chooseFishToSell()
                else
                    ESX.ShowNotification(T("GENERIC_NOT_EQUIPPED"), "error")
                end
            end

            if CurrentAction == "rentboat" then
                CurrentAction = nil
                if canWorkFishing or isFishingShop() then
                    openRentBoatMenu()
                else
                    ESX.ShowNotification(T("GENERIC_NOT_EQUIPPED"), "error")
                end
            end

            if CurrentAction == "deleter" then
                CurrentAction = nil
                TriggerServerEvent("cframework:storeVehicle", nil)
            end

            if CurrentAction == "processing" then
                CurrentAction = nil
                if canWorkFishing then
                    fishProcessCanning()
                else
                    ESX.ShowNotification(T("GENERIC_NOT_EQUIPPED"), "error")
                end
            end

            if CurrentAction == "cloakroom" then
                CurrentAction = nil
                fishingCloakroomFunc()
            end

            if CurrentAction == "rentvehicle" then
                CurrentAction = nil
                if canWorkFishing then
                    openRentVehicleMenu()
                else
                    ESX.ShowNotification(T("GENERIC_NOT_EQUIPPED"), "error")
                end
            end

            ::final::
        end
    end)
end)

RegisterNetEvent("fishingExitedMarker", function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

RegisterNetEvent("cframework:startFishing", function(rod)
    if isFishing then
        ESX.ShowNotification(T("FISHING_ALREADY_FISHING"), "error")
        return
    end

    if inFishingCooldown then
        ESX.ShowNotification(T("FISHING_COOLDOWN"), "error")
        return
    end

    if not isFishingEquipmentValid() then
        ESX.ShowNotification(T("FISHING_NOT_USING_CORRECT_EQUIMENT"), "error")
        return
    end

    if getPedLocationData() == nil then
        ESX.ShowNotification(T("FISHING_NOT_IN_FISHING_ZONE"), "error")
        return
    end

    local isCloseToWater = isPedCloseToWater()

    if not isCloseToWater then
        ESX.ShowNotification(T("FISHING_NOT_NEAR_WATER_TO_FISH"), "error")
        return
    end

    isFishing = true

    TriggerServerEvent("cframework:startFishing", equipedGear)

    TriggerEvent("esx_inventoryhud:doClose")

    TriggerEvent("cframework:closePhone")
	TriggerEvent("cframework:stopPegar")

	TriggerEvent("cframework:disableVehiclePush")
    TriggerEvent("cframework:disablePegar")
    TriggerEvent("cframework:disableEmotes")

    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_STAND_FISHING", 0, true)

    local scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

    repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(55)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 177, false))
    ScaleformMovieMethodAddParamPlayerNameString(T("GENERIC_CANCEL"))
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    inFishingCooldown = true

    Citizen.CreateThread(function()
        while isFishing do
            local timeToCatchFish = math.random(7500, 10000)

            Citizen.Wait(timeToCatchFish)

            math.randomseed(GetGameTimer())

            if not isFishing then break end

            TriggerEvent("cframework:closePhone")

            if ESX.taskBar(1, 5) then
                TriggerServerEvent("cframework:catchFish")
            else
                TriggerServerEvent("cframework:lostFish")
                ESX.ShowNotification(T("FISHING_YOUVE_LET_THE_FISH_GO"), "error")
            end
        end

        inFishingCooldown = false
    end)

    while isFishing do
        Citizen.Wait(0)

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

        if IsControlJustPressed(0, 177) then
            isFishing = false
        end
    end

    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())

    local coords = GetEntityCoords(PlayerPedId())
    ClearAreaOfObjects(coords.x, coords.y, coords.z, 4.5, 0)

    TriggerEvent("cframework:enableEmotes")
    TriggerEvent("cframework:enablePegar")
    TriggerEvent("cframework:enableVehiclePush")
end)

RegisterNetEvent("cframework:forceCancelFishing", function()
    isFishing = false

    ESX.ShowNotification(T("FISHING_CANCELED"), "error")

    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())

    local coords = GetEntityCoords(PlayerPedId())
    ClearAreaOfObjects(coords.x, coords.y, coords.z, 4.5, 0)

    TriggerEvent("cframework:enableEmotes")
    TriggerEvent("cframework:enablePegar")
    TriggerEvent("cframework:enableVehiclePush")
end)

RegisterNetEvent("cframework:useFishingRod", function(fishingRod)
    if equipedGear[fishingRod] == nil then equipedGear[fishingRod] = {} end

    currentFishingRod = fishingRod

    TriggerEvent("chud:fishing", fishingRod, equipedGear[fishingRod])
end)

RegisterNetEvent("cframework:fishing_equip", function(slot, item, label)
    if currentFishingRod == nil then return end
    if equipedGear[currentFishingRod] == nil then equipedGear[currentFishingRod] = {} end

    equipedGear[currentFishingRod][slot] = {name = item, label = label}
end)

Citizen.CreateThread(function()
    for _, v in ipairs(fishingData.fishingLocations) do
        if v.onMap then
            local blip = AddBlipForRadius(v.x, v.y, v.z, v.radius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, v.rcolor)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 2)

            local blip3 = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite (blip3, v.sprite)
            SetBlipDisplay(blip3, 2)
            SetBlipScale  (blip3, 0.5)
            SetBlipColour (blip3, v.color)
            SetBlipAsShortRange(blip3, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.name)
            EndTextCommandSetBlipName(blip3)
        end
    end
end)