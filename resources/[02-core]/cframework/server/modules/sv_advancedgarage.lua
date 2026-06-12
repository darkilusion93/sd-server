local garageData = LoadGarages()
local spawnCooldowns = {}

ESX.getClosestGarageZone = function(coords)
    local closestZone = nil
    local closestDistance = -1

    for _,v in pairs(garageData.CarGarages) do
        local garageCoords = v.GaragePoint
        local distance = #(vector3(coords.x, coords.y, coords.z) - vector3(garageCoords.x, garageCoords.y, garageCoords.z))

        if closestDistance == -1 or closestDistance > distance then
            closestZone = v.Zone
            closestDistance = distance
        end
    end

    return closestZone or "los_santos"
end

RegisterNetEvent('cframework:spawnGarageVehicle', function(vehicleData, vehicleType, plate, coords, isPound, isSociety, houseCoords)
	local source <const> = source
    local playerRoutingBucket <const> = GetPlayerRoutingBucket(source)
    local isHouse <const> = houseCoords ~= nil
    local houseId = ESX.getHouseIdPlayerIsIn(source)

    if spawnCooldowns[source] then
        return
    end

    spawnCooldowns[source] = true

    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent("esx:showNotification", source, T("GENERIC_FUNCTION_DISABLED_WHILE_DEAD"), "error")
        spawnCooldowns[source] = nil
        return
    end

    if ESX.isTaxEvading(source) then
        TriggerClientEvent("esx:showNotification", source, T("GENERIC_FUNCTION_DISABLED_WHILE_TAX_EVADING"), "error")
        spawnCooldowns[source] = nil
        return
    end

	Citizen.CreateThread(function()
		---@diagnostic disable-next-line: param-type-mismatch
		for k,veh in ipairs(GetAllVehicles()) do
            if DoesEntityExist(veh) and GetVehicleNumberPlateText(veh) == plate then
                TriggerClientEvent('cframwork:existingVehicle', source)
                spawnCooldowns[source] = nil
                return
            end
        end

		local vehicleInfo = {}

		if isSociety then
			local job = ESX.getJob(source).name
			local vehicle = ESX.getVehicleFromPlate(plate)

			if vehicle and vehicle.owner == job then
				vehicleInfo = vehicle
			end
		elseif isHouse then
			local vehicle = ESX.getVehicleFromPlate(plate)

			if vehicle and vehicle.zone == houseId then
				vehicleInfo = vehicle
			end
        else
			vehicleInfo = ESX.getVehicle(source, plate)
		end

        if not vehicleInfo.stored then
            local cost <const> = garageData.poundCosts[vehicleInfo.type]
            local inventory <const> = ESX.getInvContainer(source)

            if inventory == nil or not isPound or cost == nil then
                spawnCooldowns[source] = nil
                return
            end

            if not inventory.removeItem("cash", cost) then
                TriggerClientEvent('cframework:poundInsufficentMoney', source)
                spawnCooldowns[source] = nil
                return
            end
        end

        local trailer = nil

        if vehicleInfo.vehicle.trailerModel then
            local distance = 8.0 -- spawn 8 units behind

            local rad = math.rad(coords.h)
            local forwardX = -math.sin(rad)
            local forwardY =  math.cos(rad)

            local spawnX = coords.x - forwardX * distance
            local spawnY = coords.y - forwardY * distance
            local spawnZ = coords.z

            trailer = CreateVehicle(vehicleInfo.vehicle.trailerModel, spawnX, spawnY, spawnZ, coords.h, true, true)
        end

		local v = CreateVehicle(vehicleInfo.vehicle.model, coords.x, coords.y, coords.z, coords.h, true, true)

		ESX.setVehiclePlate(v, plate)

		if not isSociety and not isPound then
            local closestZone = nil

            if houseCoords then
                closestZone = ESX.getClosestGarageZone(houseCoords)
            end

            if isHouse then
                local houseOwnerXplayer = ESX.GetPlayerFromIdentifier(vehicleInfo.owner)
                if houseOwnerXplayer then
                    ESX.setVehiclePoundState(houseOwnerXplayer.source, plate, false, closestZone)
                else
                    ESX.setOfflineVehiclePoundState(vehicleInfo.owner, plate, false, closestZone)
                end
            else
                ESX.setVehiclePoundState(source, plate, false, closestZone)
            end
		end

		local curTime <const> = os.time()

		while not DoesEntityExist(v) do
			Citizen.Wait(20)

			if os.time() - curTime > 20 then spawnCooldowns[source] = nil return end
		end

		TriggerClientEvent('cframework:initVehicle', NetworkGetEntityOwner(v), NetworkGetNetworkIdFromEntity(v), vehicleData)

		local curTime2 <const> = os.time()

		while DoesEntityExist(v) and GetVehicleNumberPlateText(v) ~= plate do
			Citizen.Wait(20)

			if os.time() - curTime2 > 20 then
				DeleteEntity(v)
				if not isSociety and not isPound then
                    if isHouse then
                        local houseOwnerXplayer = ESX.GetPlayerFromIdentifier(vehicleInfo.owner)
                        if houseOwnerXplayer then
                            ESX.setVehiclePoundState(houseOwnerXplayer.source, plate, true, nil)
                        else
                            ESX.setOfflineVehiclePoundState(vehicleInfo.owner, plate, true, nil)
                        end
                    else
					    ESX.setVehiclePoundState(source, plate, true, nil)
                    end
				end
				TriggerClientEvent('cframework:errorSpawningVehicle', source)
                spawnCooldowns[source] = nil
				return
			end
		end

		if not DoesEntityExist(v) then
			if not isSociety and not isPound then
                if isHouse then
                    local houseOwnerXplayer = ESX.GetPlayerFromIdentifier(vehicleInfo.owner)
                    if houseOwnerXplayer then
                        ESX.setVehiclePoundState(houseOwnerXplayer.source, plate, true, nil)
                    else
                        ESX.setOfflineVehiclePoundState(vehicleInfo.owner, plate, true, nil)
                    end
                else
				    ESX.setVehiclePoundState(source, plate, true, nil)
                end
			end
			TriggerClientEvent('cframework:errorSpawningVehicle', source)
            spawnCooldowns[source] = nil
			return
		end

        SetEntityRoutingBucket(v, playerRoutingBucket)

		TriggerClientEvent('cframework:vehicleSpawned', source, NetworkGetNetworkIdFromEntity(v))

        if trailer then
            SetEntityRoutingBucket(trailer, playerRoutingBucket)
            TriggerClientEvent('cframework:trailerSpawned', source, NetworkGetNetworkIdFromEntity(trailer), NetworkGetNetworkIdFromEntity(v))
        end

        spawnCooldowns[source] = nil
	end)
end)

RegisterNetEvent('cframework:storeVehicle', function(zone)
	local source <const> = source
	local vehicle <const> = GetVehiclePedIsIn(GetPlayerPed(source), false)
    local coords <const> = GetEntityCoords(GetPlayerPed(source))

	if not DoesEntityExist(vehicle) then return end

	local plate <const> = GetVehicleNumberPlateText(vehicle)
	local vehicleInfo = ESX.getVehicleFromPlate(plate)

	if vehicleInfo == nil then
		DeleteEntity(vehicle)
		return
	end

    local ownerPlayer = ESX.GetPlayerFromIdentifier(vehicleInfo.owner)

	vehicleInfo.vehicle.bodyHealth = GetVehicleBodyHealth(vehicle)
	vehicleInfo.vehicle.engineHealth = GetVehicleEngineHealth(vehicle)
    vehicleInfo.vehicle.fuelLevel = exports['rpscripts']:getVehicleFuel(NetworkGetNetworkIdFromEntity(vehicle)) or 0.0

    local success = false
    local zoneLabel = garageData.zoneLabels[zone]

    if zoneLabel == nil then
        local houseId = ESX.getHouseIdPlayerIsIn(source)

        if houseId == nil or not (Config.properties[houseId].owner == vehicleInfo.owner or Config.properties[houseId].access[vehicleInfo.owner]) then
            zone = ESX.getClosestGarageZone(coords)
        else
            zone = houseId
        end
    end

    if ownerPlayer then
        success = ESX.updateVehiclePoundStateAndProps(ownerPlayer.source, {vehicle = vehicleInfo.vehicle, stored = true, plate = plate}, true, zone)
    else
        success = ESX.setOfflineVehiclePoundState(vehicleInfo.owner, plate, true, zone)

        ESX.updateVehicleProps(vehicleInfo.vehicle)
    end

	if not success then return end

	DeleteEntity(vehicle)
end)

RPC.register('cframework:getSocietyVehicles', function(vType)
	local source <const> = source
	local job <const> = ESX.getJob(source).name
	local societyCars = cachedVehicles[job]

	if societyCars == nil then
		local dbVehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
			['@owner'] = job,
		})
		societyCars = {}

		if dbVehicles == nil then return {} end

		for _,v in pairs(dbVehicles) do
			local vehicle = json.decode(v.vehicle)

			table.insert(societyCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, type = v.type, zone = v.zone})
		end

		cachedVehicles[job] = societyCars
	end

    local filteredCars = {}

    for _,v in pairs(societyCars) do
        if v.type == vType then
            table.insert(filteredCars, v)
        end
    end

	return filteredCars
end)

RPC.register('cframework:getHouseVehicles', function(vType)
	local source <const> = source
	local houseId = ESX.getHouseIdPlayerIsIn(source)

    if houseId == nil then
        return {}
    end

    local dbVehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE zone = @zone', {
        ['@zone'] = houseId,
    })

    local userVehicles = {}

    if dbVehicles == nil then return {} end

    for _,v in pairs(dbVehicles) do
        local vehicle = json.decode(v.vehicle)

        if v.type == vType then
            table.insert(userVehicles, {vehicle = vehicle, stored = v.stored, plate = v.plate, type = v.type, zone = v.zone})
        end
    end

	return userVehicles
end)
