local garageData = LoadGarages()
local this_Garage  = {}
local CurrentAction, CurrentActionMsg
local favoriteCars, carAlias = {}, {}

DecorRegister('Player_Vehicle', 3)

Citizen.CreateThread(function()
	AddTextEntry('GARAGEBLIP', T("GARAGES_GARAGE_BLIP"))
	AddTextEntry('POUNDBLIP', T("GARAGES_POUND_BLIP"))
end)

function SetCurrentGarage(x, y, z, h, zone)
	this_Garage.SpawnPoint = {x = x, y = y, z = z, h = h}
    this_Garage.Zone = zone
end

function ListOwnedVehiclesMenu(vType, title, isPound, isSociety, disableProximityCheck, houseCoords)
	local ownedCars = {}
    local isHouse = houseCoords ~= nil

    if isHouse then
        ownedCars = RPC.execute('cframework:getHouseVehicles', vType)
	elseif not isPound and not isSociety then
		ownedCars = ESX.getGarageVehicles(vType)
	elseif isPound and not isSociety then
		ownedCars = ESX.getPoundedVehicles(vType)
	elseif isSociety and not isPound then
		ownedCars = RPC.execute('cframework:getSocietyVehicles', vType)
	end

	local function getVehicleList()
		local e, f = {}, {}

		for k,v in pairs(ownedCars) do
			local aheadVehName = GetDisplayNameFromVehicleModel(v.vehicle.model)
			local carCustomName = ''
            local inThisGarage = false

			if carAlias[v.plate] then
				carCustomName = carAlias[v.plate]
				aheadVehName = '('..aheadVehName..')'
			else
				carCustomName = aheadVehName
				aheadVehName = ''
			end

            if this_Garage.Zone then
                if v.zone == this_Garage.Zone then
                    inThisGarage = true
                end
            else
                inThisGarage = true
            end

            if favoriteCars[v.plate] then
                table.insert(f, {label = aheadVehName, alias = carCustomName, value = v, id = k, inGarage = inThisGarage})
            else
                table.insert(e, {label = aheadVehName, alias = carCustomName, value = v, id = k, inGarage = inThisGarage})
            end
		end

		return e, f
	end

	if #ownedCars == 0 then ESX.ShowNotification(T("GARAGES_NO_VEHICLES"), 'error') return end

	local elements, favorites = getVehicleList()

	TriggerEvent('chud:garage', elements, favorites, title, isPound, function(value)
		if not isPound and not ownedCars[value].stored then ESX.ShowNotification(T("GARAGES_IMPOUNDED"), 'error') return end

        if this_Garage.Zone and ownedCars[value].zone ~= this_Garage.Zone then
            ESX.ShowNotification((T("GARAGES_WRONG_GARAGE")):format(garageData.zoneLabels[ownedCars[value].zone] or T("GARAGES_ZONE_LABEL_HOUSE")), 'error')
            return
        end

        if not disableProximityCheck then
            for _,v in pairs(GetGamePool('CVehicle')) do
                local vCoords = GetEntityCoords(v)

                if #(vCoords - vector3(this_Garage.SpawnPoint.x, this_Garage.SpawnPoint.y, this_Garage.SpawnPoint.z)) < 5.0 then
                    ESX.ShowNotification(T("GARAGES_SPAWN_OCCUPIED"), 'error')
                    return
                end
            end

            for _,v in pairs(GetGamePool('CPed')) do
                local vCoords = GetEntityCoords(v)

                if #(vCoords - vector3(this_Garage.SpawnPoint.x, this_Garage.SpawnPoint.y, this_Garage.SpawnPoint.z)) < 3.0 then
                    ESX.ShowNotification(T("GARAGES_SPAWN_OCCUPIED"), 'error')
                    return
                end
            end
        end

		if not isPound and not isSociety then
			SetEntityCoords(PlayerPedId(), this_Garage.SpawnPoint.x, this_Garage.SpawnPoint.y, this_Garage.SpawnPoint.z, true, false, false, false)
            TriggerEvent('esx_inventoryhud:doClose')
			Citizen.Wait(1000)
		end

		TriggerServerEvent('cframework:spawnGarageVehicle', ownedCars[value], ESX.GetVehicleType(ownedCars[value].vehicle.model), ownedCars[value].plate, this_Garage.SpawnPoint, isPound, isSociety, houseCoords)
	end, function(value)
		if favoriteCars[ownedCars[value].plate] then favoriteCars[ownedCars[value].plate] = nil else favoriteCars[ownedCars[value].plate] = true end

		SetResourceKvp('favoriteCars', json.encode(favoriteCars))

		elements, favorites = getVehicleList()
		TriggerEvent('chud:updateGarage', elements, favorites, isPound)
	end, function(value, alias)
		if alias == '' then carAlias[ownedCars[value].plate] = nil else carAlias[ownedCars[value].plate] = alias end

		SetResourceKvp('carAlias', json.encode(carAlias))

		elements, favorites = getVehicleList()
		TriggerEvent('chud:updateGarage', elements, favorites, isPound)
	end)
end


function StoreOwnedVehicle(zone)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then ESX.ShowNotification(T("VEHICLES_NOT_INSIDE"), 'error') return end

	TriggerServerEvent('cframework:storeVehicle', zone)
end


local function activeGarageMarkers()
	if not CurrentAction then return end

	ESX.ShowHelpNotification(CurrentActionMsg)

	if IsControlJustReleased(0, 38) then
		if CurrentAction == 'car_garage_point' then
			ListOwnedVehiclesMenu('car', T("GARAGES_CAR"), false, false, false, nil)
		elseif CurrentAction == 'boat_garage_point' then
			ListOwnedVehiclesMenu('boat', T("GARAGES_BOAT"), false, false, false, nil)
		elseif CurrentAction == 'aircraft_garage_point' then
			ListOwnedVehiclesMenu('aircraft', T("GARAGES_AIRCRAFT"), false, false, false, nil)
		elseif CurrentAction == 'car_store_point' then
			StoreOwnedVehicle(this_Garage.Zone)
		elseif CurrentAction == 'boat_store_point' then
			StoreOwnedVehicle(this_Garage.Zone)
		elseif CurrentAction == 'aircraft_store_point' then
			StoreOwnedVehicle(this_Garage.Zone)
		elseif CurrentAction == 'car_pound_point' then
			ListOwnedVehiclesMenu('car', T("GARAGES_CAR_POUND") .. " " .. ESX.formatAsCurrency(garageData.poundCosts["car"]), true, false, false, nil)
		elseif CurrentAction == 'boat_pound_point' then
			ListOwnedVehiclesMenu('boat', T("GARAGES_BOAT_POUND") .. " " .. ESX.formatAsCurrency(garageData.poundCosts["boat"]), true, false, false, nil)
		elseif CurrentAction == 'aircraft_pound_point' then
			ListOwnedVehiclesMenu('aircraft', T("GARAGES_AIRCRAFT_POUND") .. " " .. ESX.formatAsCurrency(garageData.poundCosts["aircraft"]), true, false, false, nil)
		end

		CurrentAction = nil
	end
end

-- Draw Markers
local function createGarageMarkers()
	for k,v in pairs(garageData.CarGarages) do
		exports.ft_libs:AddMarker("CarGaragesSpawn" .. k, {type = 50, x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z+1, 
			red = 0, green = 255, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("CarGaragesSpawn" .. k, {x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'car_garage_point', v},
			active = {callback = activeGarageMarkers}})

		exports.ft_libs:AddMarker("CarGaragesDelete" .. k, {type = 50, x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z+1,
			red = 255, green = 0, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("CarGaragesDelete" .. k, {x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z, weight = 2.5, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'car_store_point', v},
			active = {callback = activeGarageMarkers}})
	end

	for k,v in pairs(garageData.CarPounds) do
		exports.ft_libs:AddMarker("CarGaragesPounds" .. k, { type = 50, x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z+1,
			red = 255, green = 191, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("CarGaragesPounds" .. k, { x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'car_pound_point', v},
			active = {callback = activeGarageMarkers}})
	end

	for k,v in pairs(garageData.BoatGarages) do
		exports.ft_libs:AddMarker("BoatGaragesSpawn" .. k, { type = 50, x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z+1,
			red = 0, green = 255, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("BoatGaragesSpawn" .. k, { x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'boat_garage_point', v},
			active = {callback = activeGarageMarkers}})

		exports.ft_libs:AddMarker("BoatGaragesDelete" .. k, { type = 50, x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z+1,
			red = 255, green = 0, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("BoatGaragesDelete" .. k, { x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z, weight = 2.5, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"},data = {k, 'boat_store_point', v},
			active = {callback = activeGarageMarkers}})
	end

	for k,v in pairs(garageData.BoatPounds) do
		exports.ft_libs:AddMarker("BoatGaragesPounds" .. k, { type = 50, x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z+1,
			red = 255, green = 191, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("BoatGaragesPounds" .. k, { x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker", }, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'boat_pound_point', v},
			active = {callback = activeGarageMarkers}})
	end

	for k,v in pairs(garageData.AircraftGarages) do
		exports.ft_libs:AddMarker("AircraftGaragesSpawn" .. k, { type = 50, x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z+1,
			red = 0, green = 255, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("AircraftGaragesSpawn" .. k, { x = v.GaragePoint.x, y = v.GaragePoint.y, z = v.GaragePoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'aircraft_garage_point', v},
			active = {callback = activeGarageMarkers}})

		exports.ft_libs:AddMarker("AircraftGaragesDelete" .. k, { type = 50, x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z+1,
			red = 255, green = 0, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("AircraftGaragesDelete" .. k, { x = v.DeletePoint.x, y = v.DeletePoint.y, z = v.DeletePoint.z, weight = 2.5, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'aircraft_store_point', v},
			active = {callback = activeGarageMarkers}})
	end

	for k,v in pairs(garageData.AircraftPounds) do
		exports.ft_libs:AddMarker("AircraftGaragesPounds" .. k, { type = 50, x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z+1,
			red = 255, green = 191, blue = 0, showDistance = 25})

		exports.ft_libs:AddTrigger("AircraftGaragesPounds" .. k, { x = v.PoundPoint.x, y = v.PoundPoint.y, z = v.PoundPoint.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredGarageMarker"}, exit = {eventClient = "cframework:hasExitedGarageMarker"}, data = {k, 'aircraft_pound_point', v},
			active = {callback = activeGarageMarkers}})
	end
end


local function createGarageBlip(coords, isPound, sprite, color, scale)
	local blip = AddBlipForCoord(table.unpack(coords))

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)

	if isPound then
		BeginTextCommandSetBlipName('POUNDBLIP')
	else
		BeginTextCommandSetBlipName('GARAGEBLIP')
	end

	EndTextCommandSetBlipName(blip)
end


local function refreshBlipsGarage()
	local blipList = {}

	for k,v in pairs(garageData.CarGarages) do
		table.insert(blipList, {
			coords = { v.GaragePoint.x, v.GaragePoint.y },
			text   = false,
			sprite = 831,
			color  = 0,
			scale  = 0.6
		})
	end

	for k,v in pairs(garageData.BoatGarages) do
		table.insert(blipList, {
			coords = { v.GaragePoint.x, v.GaragePoint.y },
			text   = false,
			sprite = 356,
			color  = 30,
			scale  = 0.6
		})
	end

	for k,v in pairs(garageData.AircraftGarages) do
		table.insert(blipList, {
			coords = { v.GaragePoint.x, v.GaragePoint.y },
			text   = false,
			sprite = 360,
			color  = 30,
			scale  = 0.6
		})
	end

    for k,v in pairs(garageData.CarPounds) do
		table.insert(blipList, {
			coords = { v.PoundPoint.x, v.PoundPoint.y },
			text   = true,
			sprite = 831,
			color  =  5,
			scale  = 0.6
		})
	end

    for k,v in pairs(garageData.BoatPounds) do
		table.insert(blipList, {
			coords = { v.PoundPoint.x, v.PoundPoint.y },
			text   = true,
			sprite = 371,
			color  =  5,
			scale  = 0.6
		})
	end

	for k,v in pairs(garageData.AircraftPounds) do
		table.insert(blipList, {
			coords = { v.PoundPoint.x, v.PoundPoint.y },
			text   = true,
			sprite = 370,
			color  =  5,
			scale  = 0.6
		})
	end

	for i=1, #blipList, 1 do
		createGarageBlip(blipList[i].coords, blipList[i].text, blipList[i].sprite, blipList[i].color, blipList[i].scale)
	end
end

RegisterNetEvent('cframwork:existingVehicle', function()
	ESX.ShowNotification(T("VEHICLES_ALREADY_EXISTS"), 'error')
end)

RegisterNetEvent('cframework:poundInsufficentMoney', function()
	ESX.ShowNotification(T("VEHICLES_NOT_ENOUGH_MONEY_POUND"), 'error')
end)

RegisterNetEvent('cframework:errorSpawningVehicle', function()
	ESX.ShowNotification(T("VEHICLES_SPAWN_ERROR"), 'error')
end)

RegisterNetEvent('cframework:vehicleSpawned', function(netId)
	while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
		Citizen.Wait(20)
	end
	local vehicle = NetworkGetEntityFromNetworkId(netId)

	TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    TriggerEvent('esx_inventoryhud:doClose')
end)

RegisterNetEvent('cframework:trailerSpawned', function(netId, vehicleNetId)
	while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
		Citizen.Wait(20)
	end

    while vehicleNetId ~= 0 and not NetworkDoesNetworkIdExist(vehicleNetId) do
		Citizen.Wait(20)
	end

	local trailerVehicle = NetworkGetEntityFromNetworkId(netId)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    AttachVehicleToTrailer(vehicle, trailerVehicle, 1.0)
end)


RegisterNetEvent("cframework:initVehicle", function(netId, vehicleData)
    while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
        Citizen.Wait(20)
    end
    local vehicle = NetworkGetEntityFromNetworkId(netId)

    -- Return if we are not the network owner
    if not NetworkHasControlOfEntity(vehicle) then
        return
    end

    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')

	-- Marking a vehicle as ""player vehicle" for game code
	-- https://cookbook.fivem.net/2022/01/06/marking-a-vehicle-as-player-vehicle-for-game-code/
	if DecorIsRegisteredAsType('Player_Vehicle', 3) then
		DecorSetInt(vehicle, 'Player_Vehicle', -1)
	end

    -- Set vehicle properties if any
    if vehicleData then
		SetVehicleNumberPlateText(vehicle, vehicleData.plate)
        ESX.Game.SetVehicleProperties(vehicle, vehicleData.vehicle)
    end
end)

-- Entered Marker
AddEventHandler('cframework:hasEnteredGarageMarker', function(data)
	local station = data[1]
	local zone = data[2]
	this_Garage = data[3]
	CurrentAction = zone

	if zone == 'car_garage_point' or zone == 'boat_garage_point' or zone == 'aircraft_garage_point' then
		CurrentActionMsg  = T("GARAGES_PICKUP_MARKER")
	elseif zone == 'car_store_point' or zone == 'boat_store_point' or zone == 'aircraft_store_point' then
		CurrentActionMsg  = T("GARAGES_STORE_MARKER")
	elseif zone == 'car_pound_point' or zone == 'boat_pound_point' or zone == 'aircraft_pound_point' then
		CurrentActionMsg  = T("GARAGES_POUND_MARKER")
	end
end)

-- Exited Marker
AddEventHandler('cframework:hasExitedGarageMarker', function()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	refreshBlipsGarage()
	createGarageMarkers()
end)

Citizen.CreateThread(function()
	local favKvp = GetResourceKvpString('favoriteCars')
	local aliasKvp = GetResourceKvpString('carAlias')

	if favKvp then
		favoriteCars = json.decode(favKvp)
	end

	if aliasKvp then
		carAlias = json.decode(aliasKvp)
	end
end)
