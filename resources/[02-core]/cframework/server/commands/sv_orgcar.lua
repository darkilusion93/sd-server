


local function addCommandVehicle(args, vType)
	local xPlayer = ESX.GetPlayerFromIdentifier(args[1])
	local vehicleplate <const> = ESX.GeneratePlate()

    local vehicleInfo <const> = {model = GetHashKey(args[2]), plate = vehicleplate}

    if args[3] ~= nil and vType == "car" then
        vehicleInfo.trailerModel = GetHashKey(args[3])
    end

	if xPlayer == nil then
		if cachedVehicles[args[1]] == nil then ESX.loadOwnerCars(args[1]) end

		table.insert(cachedVehicles[args[1]], {vehicle = vehicleInfo, stored = 1, plate = vehicleplate, type = vType, zone = 'los_santos'})

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, stored, zone) VALUES (@owner, @plate, @vehicle, @type, @stored, @zone)', {
			['@owner']   = args[1],
			['@plate']   = vehicleplate,
			['@vehicle'] = json.encode(vehicleInfo),
			['@type']    = vType,
			['@stored']	 = 1,
			['@zone']    = 'los_santos'
		})
	else
		ESX.addVehicle(xPlayer.source, {vehicle = vehicleInfo, stored = true, plate = vehicleplate, type = vType, zone = 'los_santos'}, true)
	end
end

TriggerEvent('es:addGroupCommand', 'orgcar', 'superadmin', function(source, args, user)
	if args[2] == nil then
		return
	end

    addCommandVehicle(args, "car")

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'spawn_object', params = {{name = "name"}}})

TriggerEvent('es:addGroupCommand', 'orgheli', 'superadmin', function(source, args, user)
	if args[2] == nil then
		return
	end

    addCommandVehicle(args, "aircraft")

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'spawn_object', params = {{name = "name"}}})

TriggerEvent('es:addGroupCommand', 'orgboat', 'superadmin', function(source, args, user)
	if args[2] == nil then
		return
	end

    addCommandVehicle(args, "boat")

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'spawn_object', params = {{name = "name"}}})
