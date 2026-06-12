---@diagnostic disable-next-line: duplicate-set-field
ESX.SetTimeout = function(msec, cb)
	table.insert(ESX.TimeoutCallbacks, {
		time = GetGameTimer() + msec,
		cb   = cb
	})
	return #ESX.TimeoutCallbacks
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.ClearTimeout = function(i)
	ESX.TimeoutCallbacks[i] = nil
end

ESX.IsPlayerLoaded = function()
	return ESX.PlayerLoaded
end

ESX.GetPlayerData = function()
	return ESX.PlayerData
end

ESX.SetPlayerData = function(key, val)
	ESX.PlayerData[key] = val
end

ESX.getTrunkInventorySize = function(hash)
	local class = GetVehicleClassFromName(hash)

	local size = ESX.TrunkLimit[class]
	if ESX.TrunkSpecialLimit[hash] then
		size = ESX.TrunkSpecialLimit[hash]
	end

	if size == nil then
		size = 50 -- default size
	end

	return size
end

ESX.ShowNotification = function(msg, type)
	if type == nil then
		SendAlert("notify", msg, 6000)
	else
		SendAlert(type, msg, 6000)
	end
end

ESX.DrawMissionText = function(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

ESX.ShowAlert = function(type, msg)
	SendAlert(type, msg)
end

ESX.ShowAdvancedNotification = function(title, subject, msg, icon, iconType)
	SendAlert("notify", title .. '-' .. subject .. '\n' .. msg, 8000 )
end

ESX.ShowHelpNotification = function(msg)
	--if not IsHelpMessageBeingDisplayed() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	--end
end

ESX.PlayAnim = function(dict, anim, speed, time, flag)
	ESX.Streaming.RequestAnimDict(dict, function()
		TaskPlayAnim(PlayerPedId(), dict, anim, speed, speed, time, flag, 1, false, false, false)
	end)
end

ESX.PlayAnimOnPed = function(ped, dict, anim, speed, time, flag)
	ESX.Streaming.RequestAnimDict(dict, function()
		TaskPlayAnim(ped, dict, anim, speed, speed, time, flag, 1, false, false, false)
	end)
end

ESX.MakeEntityFaceEntity = function(entity1, entity2)
	local p1 = GetEntityCoords(entity1, true)
	local p2 = GetEntityCoords(entity2, true)

	local dx = p2.x - p1.x
	local dy = p2.y - p1.y

	local heading = GetHeadingFromVector_2d(dx, dy)
	SetEntityHeading( entity1, heading )
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.TriggerServerCallback = function(name, cb, ...)
	ESX.ServerCallbacks[ESX.CurrentRequestId] = cb

	TriggerServerEvent('esx:triggerServerCallback', name, ESX.CurrentRequestId, ...)

	if ESX.CurrentRequestId < 65535 then
		ESX.CurrentRequestId = ESX.CurrentRequestId + 1
	else
		ESX.CurrentRequestId = 0
	end
end

ESX.UI.HUD.SetDisplay = function(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

ESX.UI.HUD.RegisterElement = function(name, index, priority, html, data)
	local found = false

	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	table.insert(ESX.UI.HUD.RegisteredElements, name)

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	ESX.UI.HUD.UpdateElement(name, data)
end

ESX.UI.HUD.RemoveElement = function(name)
	for i=1, #ESX.UI.HUD.RegisteredElements, 1 do
		if ESX.UI.HUD.RegisteredElements[i] == name then
			table.remove(ESX.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

ESX.UI.HUD.UpdateElement = function(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

ESX.UI.Menu.RegisterType = function(type, open, close)
	ESX.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

ESX.UI.Menu.Open = function(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		ESX.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #ESX.UI.Menu.Opened, 1 do
			if ESX.UI.Menu.Opened[i] ~= nil then
				if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
					ESX.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close ~= nil then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	table.insert(ESX.UI.Menu.Opened, menu)
	ESX.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

ESX.UI.Menu.Close = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				ESX.UI.Menu.Opened[i].close()
				ESX.UI.Menu.Opened[i] = nil
			end
		end
	end
end

ESX.UI.Menu.CloseAll = function()
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			ESX.UI.Menu.Opened[i].close()
			ESX.UI.Menu.Opened[i] = nil
		end
	end
end

ESX.UI.Menu.GetOpened = function(type, namespace, name)
	for i=1, #ESX.UI.Menu.Opened, 1 do
		if ESX.UI.Menu.Opened[i] ~= nil then
			if ESX.UI.Menu.Opened[i].type == type and ESX.UI.Menu.Opened[i].namespace == namespace and ESX.UI.Menu.Opened[i].name == name then
				return ESX.UI.Menu.Opened[i]
			end
		end
	end
end

ESX.UI.Menu.GetOpenedMenus = function()
	return ESX.UI.Menu.Opened
end

ESX.UI.Menu.IsOpen = function(type, namespace, name)
	return ESX.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

ESX.UI.ShowInventoryItemNotification = function(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

ESX.Game.GetPedMugshot = function(ped)
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return mugshot, GetPedheadshotTxdString(mugshot)
end

ESX.Game.Teleport = function(entity, coords, cb)
	RequestCollisionAtCoord(coords.x, coords.y, coords.z)

	while not HasCollisionLoadedAroundEntity(entity) do
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(0)
	end

	SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, false)

	if cb ~= nil then
		cb()
	end
end

ESX.Game.SpawnObject = function(model, coords, cb)
	model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

ESX.Game.SpawnLocalObject = function(model, coords, cb)
	model = (type(model) == 'number' and model or GetHashKey(model))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)

		if cb ~= nil then
			cb(obj)
		end
	end)
end

ESX.Game.DeleteVehicle = function(vehicle)
	if NetworkGetEntityIsLocal(vehicle) then
		SetEntityAsMissionEntity(vehicle, false, true)
		DeleteVehicle(vehicle)
		print(("[Local] Delete Vehicle Local | Entity: %s"):format(vehicle))
	end

	if DoesEntityExist(vehicle) then
        Sync.DeleteVehicleServer(vehicle)
        print(("[Sync] Delete Vehicle Server | Entity: %s"):format(vehicle))
    end
end

ESX.Game.DeleteObject = function(object)
	SetEntityAsMissionEntity(object, false, true)
	DeleteObject(object)
end

ESX.Game.SpawnVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)

		SetModelAsNoLongerNeeded(model)

		local id = NetworkGetNetworkIdFromEntity(vehicle)
		SetNetworkIdCanMigrate(id, true)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

ESX.Game.SpawnLocalVehicle = function(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)

		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(0)
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

ESX.Game.IsVehicleEmpty = function(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

ESX.Game.GetObjects = function()
	local objects = {}

	for object in EnumerateObjects() do
		table.insert(objects, object)
	end

	return objects
end

local originalObjectCoords = {}

ESX.Game.GetClosestObject = function(filter, coords)
	local objects         = ESX.Game.GetObjects()
	local closestDistance = -1
	local closestObject   = -1
	local filter          = filter
	local coords          = coords

	if type(filter) == 'string' then
		if filter ~= '' then
			filter = {filter}
		end
	end

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
	end

	for i=1, #objects, 1 do
		local foundObject = false

		if filter == nil or (type(filter) == 'table' and #filter == 0) then
			foundObject = true
		else
			local objectModel = GetEntityModel(objects[i])

			for j=1, #filter, 1 do
				if objectModel == filter[j] then
					foundObject = true
				end
			end
		end

		if foundObject then
			local objectCoords = GetEntityCoords(objects[i])
			local distance     = #(objectCoords - coords)

			if originalObjectCoords[objects[i]] == nil then
				originalObjectCoords[objects[i]] = objectCoords
			end

			if closestDistance == -1 or closestDistance > distance then
				closestObject   = objects[i]
				closestDistance = distance
			end
		end
	end

	return closestObject, closestDistance, originalObjectCoords[closestObject]
end

ESX.Game.GetEntitiesWithinDistance = function(entities, isPlayerEntities, coords, maxDistance, includeFilter, excludeFilter)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if includeFilter then
		local filteredEntities = {}
		for _,entity in pairs(entities) do
			if includeFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
		entities = filteredEntities
	end

	if excludeFilter then
		local filteredEntities = {}
		for _,entity in pairs(entities) do
			if not excludeFilter[GetEntityModel(entity)] and not excludeFilter[entity] then
				table.insert(filteredEntities, entity)
			end
		end
		entities = filteredEntities
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

ESX.Game.DeleteEntity = function(entity)
	if DoesEntityExist(entity) then
		if not NetworkGetEntityIsNetworked(entity) or NetworkHasControlOfEntity(entity) then
			SetEntityAsMissionEntity(entity, false, true)
			DeleteEntity(entity)
		else
			TriggerServerEvent('esx:deleteEntity', NetworkGetNetworkIdFromEntity(entity))
		end
	end
end

ESX.Game.GetObjetsInArea = function(coords, maxDistance, includeFilter, excludeFilter) return ESX.Game.GetEntitiesWithinDistance(ESX.Game.GetObjects(), false, coords, maxDistance, includeFilter, excludeFilter) end

ESX.Game.GetPlayers = function()
	local players    = {}
	for i,player in ipairs(GetActivePlayers()) do
		table.insert(players, player)
	end

	return players
end

ESX.Game.GetClosestPlayer = function(coords)
	local players         = ESX.Game.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
    else
        coords = vector3(coords.x, coords.y, coords.z)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = #(targetCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

ESX.Game.GetPlayersInArea = function(coords, area)
	local players       = ESX.Game.GetPlayers()
	local playersInArea = {}

    coords = vector3(coords.x, coords.y, coords.z)

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = #(targetCoords - coords)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

ESX.Game.GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

ESX.Game.GetClosestVehicle = function(coords)
	local vehicles        = ESX.Game.GetVehicles()
	local closestDistance = -1
	local closestVehicle  = -1
	local coords          = coords

	if coords == nil then
		local playerPed = PlayerPedId()
		coords          = GetEntityCoords(playerPed)
    else
        coords = vector3(coords.x, coords.y, coords.z)
	end

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = #(vehicleCoords - coords)

		if closestDistance == -1 or closestDistance > distance then
			closestVehicle  = vehicles[i]
			closestDistance = distance
		end
	end

	return closestVehicle, closestDistance
end

ESX.Game.GetClosestEntity = function(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				table.insert(filteredEntities, entity)
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

ESX.Game.GetVehiclesInArea = function(coords, area)
	local vehicles       = ESX.Game.GetVehicles()
	local vehiclesInArea = {}

    coords = vector3(coords.x, coords.y, coords.z)

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = #(vehicleCoords - coords)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

ESX.Game.GetVehicleInDirection = function()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		return entityHit
	end

	return nil
end

ESX.Game.IsSpawnPointClear = function(coords, radius)
	local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

ESX.Game.GetPeds = function(ignoreList)
	local ignoreList = ignoreList or {}
	local peds       = {}

	for ped in EnumeratePeds() do
		local found = false

		for j=1, #ignoreList, 1 do
			if ignoreList[j] == ped then
				found = true
			end
		end

		if not found then
			table.insert(peds, ped)
		end
	end

	return peds
end

ESX.Game.GetClosestPed = function(coords, ignoreList)
	local ignoreList      = ignoreList or {}
	local peds            = ESX.Game.GetPeds(ignoreList)
	local closestDistance = -1
	local closestPed      = -1

    coords = vector3(coords.x, coords.y, coords.z)

	for i=1, #peds, 1 do
		local pedCoords = GetEntityCoords(peds[i])
		local distance  = #(pedCoords - coords)

		if closestDistance == -1 or closestDistance > distance then
			closestPed      = peds[i]
			closestDistance = distance
		end
	end

	return closestPed, closestDistance
end

ESX.Game.GetVehicleProperties = function(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local paintType1, whoCaresColor1, nnn = GetVehicleModColor_1(vehicle)
		local paintType2, whoCaresColor2 = GetVehicleModColor_2(vehicle)
		local color3 = {}
		local color4 = {}
		color3[1], color3[2], color3[3] = GetVehicleCustomPrimaryColour(vehicle)
		color4[1], color4[2], color4[3] = GetVehicleCustomSecondaryColour(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local dshcolor = GetVehicleDashboardColour(vehicle)
		local intcolor = GetVehicleInteriorColour(vehicle)
		local drift = GetDriftTyresEnabled(vehicle)
		local extras = {}

		for id=0, 12 do
			if DoesExtraExist(vehicle, id) then
				local state = IsVehicleExtraTurnedOn(vehicle, id) == 1
				extras[tostring(id)] = state
			end
		end

		return {
			model             = GetEntityModel(vehicle),

			plate             = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = ESX.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = ESX.Math.Round(GetVehicleEngineHealth(vehicle), 1),

			fuelLevel         = ESX.Math.Round(exports["rpscripts"]:GetFuel(vehicle), 1),
			dirtLevel         = ESX.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,
			color3            = color3,
			color4            = color4,
			paintType		  = {paintType1, paintType2},
			ColorType 		  = {whoCaresColor1, whoCaresColor2},	
			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,
			dshcolor 		  = dshcolor,
			intcolor 		  = intcolor,
			drift			  = drift,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColour(vehicle),

            frontTrackWidth     = GetVehicleWheelXOffset(vehicle, 1)*2,
            backTrackWidth      = GetVehicleWheelXOffset(vehicle, 3)*2,
            frontTrackRotation  = GetVehicleWheelYRotation(vehicle, 0),
            backTrackRotation   = GetVehicleWheelYRotation(vehicle, 2),
            wheelWidth          = GetVehicleWheelWidth(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),
			modWheelVariat	  = GetVehicleModVariation(vehicle,23),
			modTyresBurst     = GetVehicleTyresCanBurst(vehicle),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modWindows        = GetVehicleMod(vehicle, 46),
			modLivery         = GetVehicleLivery(vehicle),
			modLivery2        = GetVehicleMod(vehicle, 48),
		}
	else
		return
	end
end

ESX.Game.SetVehicleProperties = function(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.fuelLevel then exports["rpscripts"]:SetFuel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end

        if props.color1 == nil or props.color1 < 141 then -- When color is chameleon don't set custom color
            if props.color3 ~= nil then
                ClearVehicleCustomPrimaryColour(vehicle)
                SetVehicleCustomPrimaryColour(vehicle, props.color3[1], props.color3[2], props.color3[3])
            end
            if props.color4 ~= nil then
                ClearVehicleCustomSecondaryColour(vehicle)
                SetVehicleCustomSecondaryColour(vehicle, props.color4[1], props.color4[2], props.color4[3])
            end
            if props.paintType ~= nil then
                local coraplicarp = 0
                local coraplicars = 0
                if props.ColorType then
                    coraplicarp = props.ColorType[1]
                    coraplicars = props.ColorType[2]
                end
                SetVehicleModColor_1(vehicle, props.paintType[1], coraplicarp, 0)
                SetVehicleModColor_2(vehicle, props.paintType[2], coraplicars)
            end
        end

		if props.dshcolor ~= nil then
			SetVehicleDashboardColour(vehicle, props.dshcolor)
		end
		if props.intcolor ~= nil then
			SetVehicleInteriorColour(vehicle, props.intcolor)
		end
		if props.drift ~= nil then
            if props.drift and not GetDriftTyresEnabled(vehicle) then
                SetDriftTyresEnabled(vehicle, true)
                EnableDriftHandling(vehicle, true)
            elseif not props.drift and GetDriftTyresEnabled(vehicle) then
                SetDriftTyresEnabled(vehicle, false)
                EnableDriftHandling(vehicle, false)
            end
		end

        if props.wheelWidth ~= nil then SetVehicleWheelWidth(vehicle, props.wheelWidth) end

        if props.frontTrackWidth ~= nil or props.backTrackWidth ~= nil or props.frontTrackRotation ~= nil or props.backTrackRotation ~= nil then
            TriggerServerEvent("cframework:syncStance", NetworkGetNetworkIdFromEntity(vehicle), props.frontTrackWidth or true, props.backTrackWidth or true, props.frontTrackRotation or true, props.backTrackRotation or true)
        end

		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for id,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id) or 0, false)
				else
					SetVehicleExtra(vehicle, tonumber(id) or 0, true)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modTyresBurst ~= nil then
			SetVehicleTyresCanBurst(vehicle,props.modTyresBurst)
		end
		if props.modFrontWheels ~= nil then
			local aplicar = false
			if props.modWheelVariat then
				aplicar = props.modWheelVariat
			end
			SetVehicleMod(vehicle, 23, props.modFrontWheels, aplicar)
		end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleLivery(vehicle, props.modLivery)
		end
		if props.modLivery2 then
			SetVehicleMod(vehicle, 48, props.modLivery2, false)
		end
	end
end

ESX.Game.Utils.DrawText3D = function(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = #(camCoords - vector3(coords.x, coords.y, coords.z))
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextProportional(true)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(true)

		AddTextComponentSubstringPlayerName(text)
		DrawText(x, y)
	end
end

local randomID = 0
local nomeMenu = 'menu'

ESX.DefaultMenu = function(title, elements)
	local selected = nil
	local submited = false

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), nomeMenu .. randomID, {
		title		= title,
		align		= 'top-left',
		elements	= elements
	}, function(data, menu)
		menu.close()
		selected = data.current
		submited = true
	end, function(data, menu)
		selected = nil
		submited = true
		menu.close()
	end)

	while not submited do
		Citizen.Wait(100)
	end

	randomID = randomID + 1

	return selected
end

ESX.DialogMenu = function(title)
	local input = nil
	local submited = false

	local menu = ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), nomeMenu .. randomID, {
		title = title
	}, function(data, menu)
		menu.close()
		input = data.value
		submited = true
	end, function(data, menu)
		input = 0
		submited = true
		menu.close()
	end)

	while not submited do
		Citizen.Wait(100)
	end

	randomID = randomID + 1

	return input
end

ESX.compatibleClip = function(hash, clip)
	for k, item in pairs(ESX.Items) do
		if item.type == "weapon" and GetHashKey(k) == hash then
			return clip == item.ammo.type
		end
	end

	return false
end

ESX.playWeaponAnim = function(hash)
    for k, item in pairs(ESX.Items) do
		if item.type == "weapon" and GetHashKey(k) == hash then
			return item.anim
		end
	end

	return false
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.getVehicle = function(plate)
	for _,v in pairs(ESX.PlayerData.vehicles) do
		if v.plate == plate then return v end
	end
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.getPoundedVehicles = function(type)
	local vehicles = {}

	for _,v in pairs(ESX.PlayerData.vehicles) do
		if not v.stored and v.type == type then table.insert(vehicles, v) end
	end

	return vehicles
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.getGarageVehicles = function(type)
	local vehicles = {}

	for _,v in pairs(ESX.PlayerData.vehicles) do
		if v.stored and v.type == type then table.insert(vehicles, v) end
	end

	return vehicles
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.getVehicles = function()
	return ESX.PlayerData.vehicles
end

ESX.clearAttachedProps = function()
	for k,v in pairs(GetGamePool('CObject')) do
		if GetEntityAttachedTo(v) == PlayerPedId() then
			DeleteEntity(v)
		end
	end
end

---@diagnostic disable-next-line: duplicate-set-field
ESX.getExperience = function(type)
	return ESX.PlayerData.experience[type]
end

RegisterNetEvent('esx:serverCallback')
AddEventHandler('esx:serverCallback', function(requestId, ...)
	ESX.ServerCallbacks[requestId](...)
	ESX.ServerCallbacks[requestId] = nil
end)


local function showNotification(msg, type)
	if type == nil then
		ESX.ShowNotification(msg)
	else
		ESX.ShowNotification(msg, type)
	end
end


RegisterNetEvent('esx:showNotification', showNotification)
RegisterNetEvent('cframework:showNotification', showNotification)


RegisterNetEvent('esx:showAdvancedNotification', function(title, subject, msg, icon, iconType)
	ESX.ShowAdvancedNotification(title, subject, msg, icon, iconType)
end)

RegisterNetEvent('esx:showHelpNotification', function(msg)
	ESX.ShowHelpNotification(msg)
end)

-- SetTimeout
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local letSleep = true
		local currTime = GetGameTimer()

		for i=1, #ESX.TimeoutCallbacks, 1 do
			letSleep = false
			if ESX.TimeoutCallbacks[i] then
				if currTime >= ESX.TimeoutCallbacks[i].time then
					ESX.TimeoutCallbacks[i].cb()
					ESX.TimeoutCallbacks[i] = nil
				end
			end
		end

		if letSleep then
			Citizen.Wait(1000)
		end
	end
end)


function SetupInstructionalButtons(buttons)
	local scaleform <const> = RequestScaleformMovie("instructional_buttons")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

	BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_CLEAR_SPACE")
	ScaleformMovieMethodAddParamInt(200)
	EndScaleformMovieMethod()

	local i = 0
	for _, button in pairs(buttons) do
		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(i)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(2, button.key, true))
		BeginTextCommandScaleformString("STRING")
		AddTextComponentSubstringKeyboardDisplay(button.label)
		EndTextCommandScaleformString()
		EndScaleformMovieMethod()
		i = i + 1
	end

	BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(0)
	ScaleformMovieMethodAddParamInt(70)
	EndScaleformMovieMethod()

	return scaleform
end

function FormatNumberWithSpaces(number)
	local formatted = string.format("%d", number)  -- Format number without any separators

	-- Insert spaces as thousand separators
	formatted = string.gsub(formatted, "(%d)(%d%d%d)$", "%1 %2") -- Matches last 3 digits
	formatted = string.gsub(formatted, "(%d)(%d%d%d)(%s-)", "%1 %2%3") -- Matches remaining sets of 3 digits

	return formatted
end


local numberOfBars = 0
local safeZone = (1.0 - GetSafeZoneSize()) * 0.5
local activeBars = {}

function ESX.CreateTimerBar(title, duration, barR, barG, barB, backR, backG, bakB)
    local X, Y, W, H = 0.0125, 0, 0, 0.0125
    local isLoading = true
    local timer = GetGameTimer()

    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars', false)
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    local scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")
    repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

    W = 0.0

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(55)
    EndScaleformMovieMethod()

    -- Store active bars
    local currentBar = numberOfBars
    numberOfBars = numberOfBars + 1

    local barData = {
        title = title,
        startTime = timer,
        duration = duration
    }

    table.insert(activeBars, barData)

    while isLoading do
        -- Find the current bar's index in activeBars
        for i, bar in ipairs(activeBars) do
            if bar == barData then
                currentBar = i - 1 -- Update position dynamically
                break
            end
        end

        local yOffset = (0.92 - safeZone) - (currentBar * 0.038)

        if GetTimeDifference(GetGameTimer(), timer) < duration then
            W = (GetTimeDifference(GetGameTimer(), timer) * (0.085 / duration))
        end

        if W ~= nil and W > 0.084 then
            isLoading = false
        end

        X, Y = 0.9255 - safeZone, yOffset

        SetScriptGfxDrawOrder(0)
        DrawSprite('timerbars', 'all_black_bg', X, Y, 0.20, 0.0325, 0.0, 255, 255, 255, 180)

        SetScriptGfxDrawOrder(1)
        DrawRect(X + 0.0275, Y, 0.085, 0.0125, backR, backG, bakB, 180)

        SetScriptGfxDrawOrder(2)
        DrawRect(X - 0.015 + (W / 2), Y, W, H, barR, barG, barB, 180)

        SetTextColour(255, 255, 255, 180)
        SetTextFont(0)
        SetTextScale(0.3, 0.3)
        SetTextCentre(true)
        BeginTextCommandDisplayText('STRING')
        AddTextComponentSubstringPlayerName(title)
        SetScriptGfxDrawOrder(3)
        EndTextCommandDisplayText(X - 0.06, Y - 0.012)

        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

        Citizen.Wait(0)
    end

    -- Remove finished bar and shift remaining bars
    for i, bar in ipairs(activeBars) do
        if bar == barData then
            table.remove(activeBars, i)
            break
        end
    end

    numberOfBars = numberOfBars - 1
end