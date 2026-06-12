-- Title	:	cl_tow.lua
-- Author	:	Peter
-- Started	:	12/12/23

local towSettings <const> = LoadTow()
local createdMarkers = {}
local created = false
local CurrentAction = nil
local canWorkTow = false
local xoff = 0.0
local yoff = 0.0
local currentlyTowedVehicle = nil

local allowedTowModels <const> = towSettings.allowedTowModels
local cloakRoomLocation <const> = towSettings.cloakRoomLocation
local vehicleSpawnLocation <const> = towSettings.vehicleSpawnLocation
local vehicleDeleteLocation <const> = towSettings.vehicleDeleteLocation

local towBlips = towSettings.towBlips

local function towVehicle()
    TriggerEvent("cframework:tow")
end

local function createTowMarkers()
    if ESX.PlayerData.job == nil or ESX.PlayerData.job.name ~= "reboque" then
        return
    end

    exports.ft_libs:AddButton("tow_mobileaction", {key = VK_F6, use = { callback = towVehicle }})

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("tow_cloakroom" .. i, {type = 50, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("tow_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "towEnteredMarker"}, exit = {eventClient = "towExitedMarker"}, data = {"cloakroom", i}})
        table.insert(createdMarkers, "tow_cloakroom" .. i)
    end

    for i=1, #vehicleSpawnLocation, 1 do
        exports.ft_libs:AddMarker("tow_spawner" .. i, {type = 50, x = vehicleSpawnLocation[i].x, y = vehicleSpawnLocation[i].y, z = vehicleSpawnLocation[i].z, weight = 1, height = 1, red = 0, green = 255, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("tow_spawner" .. i, {x = vehicleSpawnLocation[i].x, y = vehicleSpawnLocation[i].y, z = vehicleSpawnLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "towEnteredMarker"}, exit = {eventClient = "towExitedMarker"}, data = {"spawner", i}})
        table.insert(createdMarkers, "tow_spawner" .. i)

    end

    for i=1, #vehicleDeleteLocation, 1 do
        exports.ft_libs:AddMarker("tow_deleter" .. i, {type = 50, x = vehicleDeleteLocation[i].x, y = vehicleDeleteLocation[i].y, z = vehicleDeleteLocation[i].z, weight = 1, height = 1, red = 255, green = 0, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("tow_deleter" .. i, {x = vehicleDeleteLocation[i].x, y = vehicleDeleteLocation[i].y, z = vehicleDeleteLocation[i].z, weight = 2, height = 5,
        enter = {eventClient = "towEnteredMarker"}, exit = {eventClient = "towExitedMarker"}, data = {"dropoff", i}})
        table.insert(createdMarkers, "tow_deleter" .. i)
    end

    for _, info in pairs(towBlips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(info.title)
        EndTextCommandSetBlipName(info.blip)
    end

    created = true
end


local function removeTowMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end

    exports.ft_libs:RemoveButton("tow_mobileaction")
    createdMarkers = {}

    if not created then
        return
    end

    for _, blip in pairs(towBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end


local function towCloakroom()
    local elements <const> = {
        {label = "🧥 Roupas de civil",         value = "cloakroom1"},
        {label = "👔 Roupa de trabalho",       value = "cloakroom2"},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent("chud:menu", elements, "Reboque", function(value)
        if value == "cloakroom1" then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
            canWorkTow = false
        end

        if value == "cloakroom2" and not canWorkTow then
            ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_male)
                else
                    TriggerEvent("skinchanger:loadClothes", skin, jobSkin.skin_female)
                end
            end)
            canWorkTow = true
        end
    end)
end

local function towSpawner(i)
    if not ESX.Game.IsSpawnPointClear(vehicleSpawnLocation[i], 5) then ESX.ShowNotification("Já há veículos na área.", "error")
        return
    end

    TriggerServerEvent("cframework:getTowVehicle", i)
end


local function towDeleter(i)
    local currentlyTowedVehicleId = 0

    if currentlyTowedVehicle ~= nil and DoesEntityExist(currentlyTowedVehicle) then
        currentlyTowedVehicleId = NetworkGetNetworkIdFromEntity(currentlyTowedVehicle)
    end

    TriggerServerEvent("cframework:dropOffTow", currentlyTowedVehicleId)
    currentlyTowedVehicle = nil
end


local function isVehicleATowTruck(vehicle)
    local isValid = false
    for model,posOffset in pairs(allowedTowModels) do
        if IsVehicleModel(vehicle, model) then
            xoff = posOffset.x
            yoff = posOffset.y
            isValid = true
            break
        end
    end
    return isValid
end


local function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle <const> = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local _, _, _, _, vehicle <const> = GetRaycastResult(rayHandle)
	return vehicle
end

local function createRollLoop()
    Citizen.CreateThread(function()
        while currentlyTowedVehicle ~= nil do
            local vehicle <const> = GetVehiclePedIsIn(PlayerPedId(), true)
            local roll <const> = GetEntityRoll(vehicle)

            if isVehicleATowTruck(vehicle) and IsEntityUpsidedown(vehicle) or roll > 70.0 or roll < -70.0 then
                DetachEntity(currentlyTowedVehicle, false, false)
                currentlyTowedVehicle = nil
            end

            Citizen.Wait(100)
        end
    end)
end


RegisterNetEvent("esx:playerLoaded", function()
    removeTowMarkers()
    Citizen.Wait(100)
    createTowMarkers()
end)


RegisterNetEvent("esx:setJob", function()
    removeTowMarkers()
    Citizen.Wait(100)
    createTowMarkers()
end)

RegisterNetEvent("towEnteredMarker", function(action)
    CurrentAction = action[1]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == "cloakroom" then
                CurrentAction = nil
                towCloakroom()
            end

            if CurrentAction == "dropoff" then
                CurrentAction = nil
                towDeleter(action[2])
            end

            if CurrentAction == "spawner" and canWorkTow then
                CurrentAction = nil
                towSpawner(action[2])
            end

            ::final::
        end
    end)
end)


RegisterNetEvent("towExitedMarker", function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

RegisterNetEvent("cframework:tow", function()
	local playerPed <const> = PlayerPedId()
	local vehicle <const> = GetVehiclePedIsIn(playerPed, true)
	local isVehicleTowCheck <const> = isVehicleATowTruck(vehicle)

	if not isVehicleTowCheck then
        ESX.ShowNotification("O teu veículo não é um reboque", "error")
        return
    end

    local playerCoords <const> = GetEntityCoords(playerPed, false)
    local coordsInFrontOfPlayer <const> = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
    local targetVehicle <const> = getVehicleInDirection(playerCoords, coordsInFrontOfPlayer)

    if IsVehicleStopped(vehicle) and currentlyTowedVehicle ~= nil then
        local vehiclesCoords <const> = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -12.0, 0.0)

        DetachEntity(currentlyTowedVehicle, false, false)
        SetEntityCoords(currentlyTowedVehicle, vehiclesCoords.x, vehiclesCoords.y, vehiclesCoords.z, true, false, false, true)
        SetVehicleOnGroundProperly(currentlyTowedVehicle)

        currentlyTowedVehicle = nil
        ESX.ShowNotification("Veículo removido do reboque", "success")

        return
    end

    if currentlyTowedVehicle ~= nil then
        return
    end

    if targetVehicle == 0 then
        ESX.ShowNotification("Veículo para rebocar não encontrado", "error")
        return
    end

    local targetVehicleLocation <const> = GetEntityCoords(targetVehicle, true)
    local towTruckVehicleLocation <const> = GetEntityCoords(vehicle, true)
    local distanceBetweenVehicles <const> = #(targetVehicleLocation - towTruckVehicleLocation)

    if distanceBetweenVehicles > 12.0 then
        ESX.ShowNotification("Estás demasiado longe do veículo", "error")
        return
    end

    if IsPedInAnyVehicle(playerPed, true) then
        ESX.ShowNotification("Tens que estar fora do reboque para rebocar", "error")
        return
    end

    if vehicle == targetVehicle or not IsVehicleStopped(vehicle) then
        ESX.ShowNotification("Não existe carro para rebocar", "error")
        return
    end

    TriggerServerEvent("cframework:requestControlOfVehicle", NetworkGetNetworkIdFromEntity(targetVehicle))

    RequestAnimDict('mini@repair')
    while not HasAnimDictLoaded('mini@repair') do
        Citizen.Wait(0)
    end

    TaskPlayAnim(PlayerPedId(), 'mini@repair' , 'fixing_a_ped' ,8.0, -8.0, -1, 1, 0, false, false, false )

    Citizen.Wait(1000)

    local curTime <const> = GetGameTimer()

    NetworkRequestControlOfEntity(targetVehicle)
    NetworkRequestControlOfEntity(vehicle)

    while not NetworkHasControlOfEntity(targetVehicle) or not NetworkHasControlOfEntity(vehicle) do
        Citizen.Wait(0)

        if GetGameTimer() - curTime > 8000 then
            ESX.ShowNotification("Não conseguiste rebocar o veículo, tenta novamente", "error")
            ClearPedTasks(PlayerPedId())
            return
        end
    end
    Citizen.Wait(6000)
    ClearPedTasks(PlayerPedId())

    local targetModelHash <const> = GetEntityModel(targetVehicle)
    local minDim <const>, maxDim <const> = GetModelDimensions(targetModelHash)
    local vehicleHeight <const> = maxDim.z - minDim.z

    AttachEntityToEntity(targetVehicle, vehicle, GetEntityBoneIndexByName(vehicle, "bodyshell"), 0.0 + xoff, -1.5 + yoff, 0.0 + vehicleHeight / 2.0, 0, 0, 0, true, true, false, true, 0, true)
    currentlyTowedVehicle = targetVehicle
    ESX.ShowNotification("Veículo rebocado", "success")

    createRollLoop()
end)
