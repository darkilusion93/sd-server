ESX.CasinoSources = {}

ESX.Trace = function(str)
	if Config.EnableDebug then
		print('ESX> ' .. str)
	end
end

ESX.SetTimeout = function(msec, cb)
	local id = ESX.TimeoutCount + 1

	SetTimeout(msec, function()
		if ESX.CancelledTimeouts[id] then
			ESX.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	ESX.TimeoutCount = id

	return id
end

ESX.ClearTimeout = function(id)
	ESX.CancelledTimeouts[id] = true
end

ESX.RegisterServerCallback = function(name, cb)
	ESX.ServerCallbacks[name] = cb
end

ESX.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if ESX.ServerCallbacks[name] ~= nil then
		ESX.ServerCallbacks[name](source, cb, ...)
	else
		print('cframework: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

ESX.SavePlayer = function(xPlayer, cb)
	local ped = GetPlayerPed(tonumber(xPlayer.source))

	if ped == 0 then -- Prevent saving wrong data
		return
	end

	local coords = GetEntityCoords(ped)
	local health = GetEntityHealth(ped)
	local armor = GetPedArmour(ped)

	coords = {x = ESX.Math.Round(coords[1], 2), y = ESX.Math.Round(coords[2], 2), z = ESX.Math.Round(coords[3], 2)}

	if not (coords.x <= 6.0 and coords.x >= -6.0 and coords.y <= 6.0 and coords.y >= -6.0) and not (coords.x > 16000.0) and not (coords.x < -16000.0) and not (coords.y < -16000.0) and not (coords.y > 16000.0) then
		xPlayer.setLastPosition(coords)
	end

	if xPlayer.overridecoords ~= nil then
		xPlayer.setLastPosition(xPlayer.overridecoords)
	end

	--Player time
	local cTime	= os.time()
	local sessionTime = cTime - xPlayer.logtime
	xPlayer.logtime = cTime

	if xPlayer.dead ~= 0 and xPlayer.dead ~= false and xPlayer.dead ~= "0" then
		if xPlayer.deathData.time ~= nil then
			if xPlayer.deathData.elapsedTime == nil then xPlayer.deathData.elapsedTime = 0 end

			xPlayer.deathData.elapsedTime = xPlayer.deathData.elapsedTime + os.time() - xPlayer.deathData.time
			xPlayer.deathData.time = os.time()
		end
	end

	-- Job and position
	MySQL.Async.execute('UPDATE users SET `name` = @name, `job` = @job, `job_grade` = @job_grade, `position` = @position, `armour` = @armour, `bank` = @bank, `phone_number` = @phone, `playtime` = @play_time + `playtime`, `globalPlayTime` = @play_time + `globalPlayTime`, `experience` = @experience, `health` = @health, `iban` = @iban, `skin` = @skin, `isDead` = @isDead, `communityservice` = @communityservice, `status` = @status, `jail` = @jail, `coins` = @coins, `boost_coins` = @boost_coins, `deathData` = @deathData WHERE identifier = @identifier', {
		['@name']       		= xPlayer.name,
		['@job']        		= xPlayer.job.name,
		['@job_grade']  		= xPlayer.job.grade,
		['@position']   		= json.encode(xPlayer.getLastPosition()),
		['@armour']  			= armor,
		['@identifier'] 		= xPlayer.identifier,
		['@bank'] 				= xPlayer.getBank(),
		['@phone']				= xPlayer.getPhoneNumber(),
		['@play_time']			= sessionTime,
		['@experience'] 		= json.encode(xPlayer.experience),
		['@health'] 			= health,
		['@iban']				= xPlayer.iban,
		['@skin']				= json.encode(xPlayer.skin),
		['@isDead']	 			= xPlayer.dead,
		['@communityservice'] 	= xPlayer.communityservice,
		['@status'] 			= json.encode(xPlayer.status),
		['@jail'] 				= cachedUsers[xPlayer.identifier].jail,
		['@coins'] 				= xPlayer.coins,
		['@boost_coins']        = xPlayer.boostCoins,
		['@deathData'] 			= json.encode(xPlayer.deathData),
	})

	cachedUsers[xPlayer.identifier].name       			= xPlayer.name
	cachedUsers[xPlayer.identifier].job      			= xPlayer.job.name
	cachedUsers[xPlayer.identifier].job_grade  			= xPlayer.job.grade
	cachedUsers[xPlayer.identifier].position  			= json.encode(xPlayer.getLastPosition())
	cachedUsers[xPlayer.identifier].armour 				= armor
	cachedUsers[xPlayer.identifier].identifier 			= xPlayer.identifier
	cachedUsers[xPlayer.identifier].bank				= xPlayer.getBank()
	cachedUsers[xPlayer.identifier].phone_number		= xPlayer.getPhoneNumber()
	cachedUsers[xPlayer.identifier].play_time			= sessionTime
	cachedUsers[xPlayer.identifier].experience 			= json.encode(xPlayer.experience)
	cachedUsers[xPlayer.identifier].health 				= health
	cachedUsers[xPlayer.identifier].iban				= xPlayer.iban
	cachedUsers[xPlayer.identifier].skin				= json.encode(xPlayer.skin)
	cachedUsers[xPlayer.identifier].isDead  			= xPlayer.dead
	cachedUsers[xPlayer.identifier].communityservice  	= xPlayer.communityservice
	cachedUsers[xPlayer.identifier].status  			= json.encode(xPlayer.status)
	cachedUsers[xPlayer.identifier].coins  				= xPlayer.coins
	cachedUsers[xPlayer.identifier].boost_coins         = xPlayer.boostCoins
	cachedUsers[xPlayer.identifier].deathData  			= json.encode(xPlayer.deathData)


	--RconPrint('[SAVED] ' .. xPlayer.identifier .. "^7\n")

	if cb ~= nil then
		cb()
	end
end

ESX.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			ESX.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 12, function(results)
		RconPrint('[SAVED] All players' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

ESX.StartDBSync = function()
	function saveData()
		ESX.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

ESX.GetPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.Players) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetAdminPlayers = function()
	local sources = {}

	for k,v in pairs(ESX.AdminPlayers) do
		table.insert(sources, k)
	end

	return sources
end

ESX.GetPlayerFromId = function(source)
	return ESX.Players[tonumber(source)]
end

ESX.GetPlayerIdFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v.source
		end
	end
end

ESX.isPlayerOnline = function(source)
	local xPlayer = ESX.Players[tonumber(source)]

	if xPlayer == nil then
		return false
	end

	return true
end

ESX.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(ESX.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

ESX.GetPlayerFromPhoneNumber = function(phoneNumber)
	for k,v in pairs(ESX.Players) do
		if v.phoneNumber == phoneNumber then
			return v
		end
	end
end

ESX.GetPlayerIdentifierFromPhoneNumber = function(phoneNumber)
	for k,v in pairs(ESX.Players) do
		if v.phoneNumber == phoneNumber then
			return v.identifier
		end
	end
end

ESX.GetSourceFromPhoneNumber = function(phoneNumber)
	for k,v in pairs(ESX.Players) do
		if v.phoneNumber == phoneNumber then
			return v.source
		end
	end
end

ESX.GetPlayerOnlineFromPhoneNumber = function(phoneNumber)
	for k,v in pairs(ESX.Players) do
		if v.phoneNumber == phoneNumber then
			return true
		end
	end

	return false
end

ESX.GetPlayerFromRPName = function(firstName, lastName)
	for k,v in pairs(ESX.Players) do
		if v.firstname == firstName and v.lastname == lastName then
			return v
		end
	end

	return nil
end

ESX.GetPlayerFromIban = function(iban)
	for k,v in pairs(ESX.Players) do
		if v.iban == iban then
			return v
		end
	end
end

ESX.tradeItem = function(name)
	if ESX.Items[name] ~= nil and ESX.Items[name].trade ~= nil and ESX.Items[name].trade.item ~= nil then
		return ESX.Items[name].trade
	end

	return nil
end

ESX.RegisterUsableItem = function(item, cb)
	ESX.UsableItemsCallbacks[item] = cb
end

ESX.UseItem = function(source, item, slot)
    if ESX.UsableItemsCallbacks[item] == nil then
        return
    end

	ESX.UsableItemsCallbacks[item](source, slot)
end

ESX.CreatePickup = function(type, name, count, label, player)
	local pickupId = (ESX.PickupId == 65635 and 0 or ESX.PickupId + 1)

	ESX.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count
	}

	TriggerClientEvent('esx:pickup', -1, pickupId, label, player)
	ESX.PickupId = pickupId
end

ESX.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if ESX.Jobs[job] and ESX.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

ESX.GetJobLabel = function(job)
    if ESX.Jobs[job] == nil then
        return "Unknown"
    end

	return ESX.Jobs[job].label
end

ESX.GetJobGradeLabel = function(job, grade)
    if ESX.Jobs[job] == nil then
        return "Unknown"
    end

    if ESX.Jobs[job].grades[grade] == nil then
        return "Unknown"
    end

	return ESX.Jobs[job].grades[grade].label
end

ESX.addSourceToJob = function(job, source)
	if job then
		ESX.Jobs[job].sources[source] = true
	end
end

ESX.removeSourceFromJob = function(job, source)
	if job then
		ESX.Jobs[job].sources[source] = nil
	end
end

ESX.getJobSourceList = function(job)
	if ESX.Jobs[job] == nil then
		return {}
	end

	return ESX.Jobs[job].sources
end

ESX.addSourceToCasino = function(source)
	ESX.CasinoSources[source] = true
end

ESX.removeSourceFromCasino = function(source)
	ESX.CasinoSources[source] = nil
end

ESX.getCasinoSourceList = function()
	return ESX.CasinoSources
end

ESX.getIdentifierByIban = function(iban) 
	local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.iban = @iban", {
		['@iban'] = iban
	})
	if result[1] ~= nil then
		return result[1].identifier
	end
	return nil
end

ESX.getRandomIban = function()
    local iban = 'PT50 '

    iban = iban .. '0' .. '0' .. math.random(1, 9) .. math.random(1, 9) .. ' '
    iban = iban .. '0' .. '0' .. '0' .. '0' .. ' '
    iban = iban .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9) .. ' '
    iban = iban .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9) .. math.random(1, 9) .. ' 1'

    return iban
end


ESX.getIdentifierByCitizenId = function(citizenId) 
	local result = MySQL.Sync.fetchAll("SELECT users.identifier FROM users WHERE users.citizen_id = @citizenId", {
		['@citizenId'] = citizenId
	})
	if result ~= nil and result[1] ~= nil then
		return result[1].identifier
	end
	return nil
end

-- Function to generate fallback ID if API fails
local function generateFallbackCitizenId()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local id = ""

    for i = 1, 6 do
        local randIndex = math.random(1, #chars)
        id = id .. chars:sub(randIndex, randIndex)
    end

    return id
end

ESX.getRandomCitizenId = function()
    local url = "https://www.random.org/strings/?num=1&len=6&digits=on&upperalpha=on&unique=on&format=plain&rnd=new"
    local p = promise.new()

    PerformHttpRequest(url, function(err, result, headers)
        if err == 200 then
            local randomNumber = tonumber(result)
            if randomNumber then
                p:resolve(randomNumber)
            end
        end
        p:resolve(generateFallbackCitizenId())
    end)

    return Citizen.Await(p)
end

ESX.GetClosestPlayer = function(_source, coords)
	local players    = {}
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = nil

	for _,player in ipairs(GetPlayers()) do
		table.insert(players, player)
	end

	if coords == nil then
		usePlayerPed = true
		playerPed    = GetPlayerPed(_source)
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local p = tonumber(players[i])
		local target = GetPlayerPed(p)

		if not usePlayerPed or (usePlayerPed and p ~= _source) then
			local targetCoords = GetEntityCoords(target)
			local distance     = #(targetCoords - coords)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = p
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

ESX.SpawnVehicle = function(modelName, coords, heading)
	local model   = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	return CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)
end

ESX.loadOwnerCars = function(owner)
	local dbVehicles = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
		['@owner'] = owner
	})
	local ownerCars = {}

	if dbVehicles == nil then return {} end

	for _,v in pairs(dbVehicles) do
		local vehicle = json.decode(v.vehicle)

		table.insert(ownerCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, type = v.type, zone = v.zone})
	end

	cachedVehicles[owner] = ownerCars
end

ESX.loadUserAccounts = function(identifier)
	local accounts = MySQL.Sync.fetchAll('SELECT * FROM `user_accounts` WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})

	if cachedAccounts[identifier] == nil then cachedAccounts[identifier] = {} end

	if accounts == nil then
		return
	end

	for i=1, #Config.Accounts, 1 do
		for j=1, #accounts, 1 do
			if accounts[j].name == Config.Accounts[i] then
				if cachedAccounts[accounts[j].identifier] == nil then cachedAccounts[accounts[j].identifier] = {} end

				table.insert(cachedAccounts[accounts[j].identifier], {
					name  = accounts[j].name,
					money = accounts[j].money,
					label = Config.AccountLabels[accounts[j].name]
				})
			end
		end
	end
end

ESX.ChangeVehicleOwnerRAM = function(plate, owner, newOwner)
    local vehicle = nil

    if ESX.Jobs[owner] ~= nil then
        if cachedVehicles[owner] ~= nil then
            for i=1, #cachedVehicles[owner], 1 do
                if cachedVehicles[owner][i].plate == plate then
                    vehicle = cachedVehicles[owner][i]
                    table.remove(cachedVehicles[owner], i)
                    break
                end
            end
		end
    else
        vehicle = ESX.deleteVehicle(owner, plate, false)
    end

    if vehicle == nil then return false end

    if ESX.Jobs[newOwner] ~= nil then
        if cachedVehicles[newOwner] == nil then
			ESX.loadOwnerCars(newOwner)
		end

        vehicle.stored = true

        table.insert(cachedVehicles[newOwner], vehicle)
    else
        return ESX.addVehicle(newOwner, vehicle, false)
    end
end

ESX.playerInsideLocation = function(source, locTable, radius)
	local ped = GetPlayerPed(tonumber(source))
	local coords = GetEntityCoords(ped)

    for i=1, #locTable, 1 do
        local loc <const> = type(locTable[i]) == "table" and vector3(locTable[i].x, locTable[i].y, locTable[i].z) or locTable[i]

        if #(coords - loc) < radius then
            return true
        end
    end

    return false
end

ESX.playerInsideLocationReturnId = function(source, locTable, radius)
	local ped = GetPlayerPed(tonumber(source))
	local coords = GetEntityCoords(ped)

    for i=1, #locTable, 1 do
        if #(coords - locTable[i]) < radius then
            return true, i
        end
    end

    return false, 0
end

local vehiclesOriginalPlates = {}

ESX.generateRandomString = function()
    local length = 8
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local str = ""

    for i = 1, length do
        local randomIndex = math.random(1, #characters)
        local randomChar = characters:sub(randomIndex, randomIndex)
        str = str .. randomChar
    end

    return str
end

ESX.setVehiclePlate = function(entity, plate)
	vehiclesOriginalPlates[entity] = plate
end

ESX.closeToVehicle = function(vehPlate, source)
    local allVehicles = GetAllVehicles()
    local vehicle = nil

    for k,veh in ipairs(allVehicles) do
		if DoesEntityExist(veh) then
			--local plate = GetVehicleNumberPlateText(veh)
			if vehiclesOriginalPlates[veh] == vehPlate then
				vehicle = veh
				break
			end
		end
    end

    if vehicle == nil then return false, nil end

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local vehicleCoords = GetEntityCoords(vehicle)

    if #(playerCoords - vehicleCoords) >= 15.0 then return false end

    return true, vehicle
end

ESX.getVehicleFromPlate = function(plate)
	local dbVehicle = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	})[1]

	if dbVehicle == nil then return nil end

	local vehicle = {vehicle = json.decode(dbVehicle.vehicle), stored = dbVehicle.stored, plate = dbVehicle.plate, type = dbVehicle.type, owner = dbVehicle.owner, zone = dbVehicle.zone}

	return vehicle
end

ESX.updateVehicleProps = function(vehprops)
	local vehicle = ESX.getVehicleFromPlate(vehprops.plate)

	if vehicle == nil then
		return false
	end

	local xPlayer = ESX.GetPlayerFromIdentifier(vehicle.owner)

	if xPlayer ~= nil and vehicle.vehicle.model == vehprops.model then
        if vehicle.vehicle.trailerModel ~= nil then
            vehprops.trailerModel = vehicle.vehicle.trailerModel
        end

		vehicle.vehicle = vehprops
		return ESX.updateVehiclePoundStateAndProps(xPlayer.source, vehicle, false, nil)
	end

	if vehicle.vehicle.model == vehprops.model then
        if vehicle.vehicle.trailerModel ~= nil then
            vehprops.trailerModel = vehicle.vehicle.trailerModel
        end

		vehicle.vehicle = vehprops

        if cachedVehicles[vehicle.owner] ~= nil then
            for i=1, #cachedVehicles[vehicle.owner], 1 do
                if cachedVehicles[vehicle.owner][i].plate == vehicle.plate then
                    cachedVehicles[vehicle.owner][i].vehicle = vehicle.vehicle
                end
            end
        end

		MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
			['@owner'] = vehicle.owner,
			['@vehicle'] = json.encode(vehicle.vehicle),
			['@plate'] = vehicle.plate,
		})

		return true
	end

	return false
end

ESX.setOfflineVehiclePoundState = function(identifier, plate, state, zone)
    local updated = false
    local vehicles = cachedVehicles[identifier]

    if vehicles ~= nil then
        for i=1, #vehicles, 1 do
            if vehicles[i].plate == plate then
                vehicles[i].stored, updated = state, true
                if zone ~= nil then
                    vehicles[i].zone = zone
                end
                break
            end
        end
    end

    if updated then
        cachedVehicles[identifier] = vehicles
    end

    if zone ~= nil then
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, `zone` = @zone WHERE plate = @plate', {
            ['@stored'] = state,
            ['@plate'] = plate,
            ['@zone'] = zone
        })
    else
        MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
            ['@stored'] = state,
            ['@plate'] = plate
        })
    end

    return true
end

ESX.getBills = function(identifier)
	local bills = cachedBilling[identifier]

	if bills ~= nil then
		return bills
	else
		return {}
	end
end

ESX.loadUserContacts = function(identifier)
	local contacts = MySQL.Sync.fetchAll('SELECT * FROM phone_users_contacts WHERE identifier = @identifier ORDER BY `display` ASC', {
		['@identifier'] = identifier
	})

	if contacts == nil or contacts[1] == nil then cachedContacts[identifier] = {} return end

	cachedContacts[identifier] = contacts
end

ESX.getContacts = function(identifier)
	if cachedContacts[identifier] == nil then ESX.loadUserContacts(identifier) end

	local contacts = cachedContacts[identifier]

	if contacts ~= nil then
		return contacts
	else
		return {}
	end
end

ESX.deleteContact = function(identifier, Name, Number)
	if cachedContacts[identifier] == nil then ESX.loadUserContacts(identifier) end

	for k, v in pairs(cachedContacts[identifier]) do
        if v.number == Number then
			table.remove(cachedContacts[identifier], k)
			break
		end
    end
end

ESX.addContact = function(identifier, name, number, iban)
	if cachedContacts[identifier] == nil then ESX.loadUserContacts(identifier) end

	table.insert(cachedContacts[identifier], {
		identifier = identifier,
		number = number,
		display = name,
		iban = iban
	})
end

ESX.editContact = function(identifier, newName, newNumber, newIban, oldName, oldNumber, oldIban)
	if cachedContacts[identifier] == nil then ESX.loadUserContacts(identifier) end

	for k, v in pairs(cachedContacts[identifier]) do
        if v.number == oldNumber then
			cachedContacts[identifier][k].display = newName
			cachedContacts[identifier][k].number = newNumber
			cachedContacts[identifier][k].iban = newIban
			break
		end
    end
end

ESX.getIdentifierByPhoneNumberOffline = function(phone_number)
	local player = MySQL.Sync.fetchAll('SELECT * FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phone_number
	})[1]
	
	if player == nil then return nil end

	return player.identifier
end

local cachedTransactions = {}

ESX.getTransactions = function(identifier)
    if cachedTransactions[identifier] == nil then
        local result = MySQL.Sync.fetchAll('SELECT * FROM `transaction_history` WHERE identifier = @identifier ORDER BY `date` DESC LIMIT 120', {
            ['@identifier'] = identifier
        })
        cachedTransactions[identifier] = result
    end

	return cachedTransactions[identifier]
end

ESX.addTransaction = function(identifier, trans_id, account, amount, trans_type, receiver, message)
    MySQL.Async.execute("INSERT INTO `transaction_history` (`identifier`, `trans_id`, `account`, `amount`, `trans_type`, `receiver`, `message`) VALUES(@tIdentifier, @transid, @account, @amount, @type, @receiver, @message);", {
        ["@tIdentifier"] = identifier,
        ["@transid"] = trans_id,
        ["@account"] = account,
        ["@amount"] = amount,
        ["@type"] = trans_type,
        ["@receiver"] = receiver,
        ["@message"] = message
    })

    if cachedTransactions[identifier] == nil then
        cachedTransactions[identifier] = {}
    end

    table.insert(cachedTransactions[identifier], 1, {
		identifier = identifier,
        trans_id = trans_id,
        account = account,
        amount = amount,
        trans_type = trans_type,
        receiver = receiver,
        message = message,
        date = os.time()*1000.0
    })
end

ESX.addSocietyVehicle = function(job, generatedPlate, vehicleProps)
	if cachedVehicles[job] == nil then
		ESX.loadOwnerCars(job)
	end

	table.insert(cachedVehicles[job], {vehicle = vehicleProps, stored = 1, plate = generatedPlate, type = 'car', zone = 'los_santos'})

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, zone) VALUES (@owner, @plate, @vehicle, @stored, @zone)',
	{
		['@owner']   = job,
		['@plate']   = vehicleProps.plate,
		['@vehicle'] = json.encode(vehicleProps),
		['@stored']	 = 1,
		['@zone']    = 'los_santos'
	})
end

ESX.GetPlayersInArea = function(coords, area)
	local players <const> = GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target <const> = GetPlayerPed(players[i])
		local targetCoords <const> = GetEntityCoords(target)
		local distance <const> = #(targetCoords - coords)

		if distance <= area then
			table.insert(playersInArea, tonumber(players[i]))
		end
	end

	return playersInArea
end

ESX.hasSearchMenu = function(job)
	local jobData = Config.Stations[job]

	if jobData == nil then return false end

	if #jobData.MobileAction == 0 then return false end

	for _, v in ipairs(jobData.MobileAction) do
		if v.value == "body_search" then return true end
	end

	return false
end

-- Function to calculate the forward vector from a rotation angle in degrees
ESX.calculateForwardVectorDegrees = function(angle_degrees)
    -- Convert the rotation angle from degrees to radians
    local angle_radians = math.rad(angle_degrees)

    -- Calculate the forward vector components
    local forward_x = math.cos(angle_radians)
    local forward_y = math.sin(angle_radians)

    return vector3(forward_y*-1, forward_x, 0.0)
end
