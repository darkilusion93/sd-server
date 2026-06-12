


-- Adds a new command 'car' to spawn a vehicle
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'car', 'admin', function(source, args, _)
	-- Check if the player has admin privileges
	if not ESX.inAdmin(source) then
	  TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
	  return false
	end

	-- Get the coordinates of the player
	local coords <const> = GetEntityCoords(GetPlayerPed(source))

	-- Create a new vehicle at the player's coordinates
	local vehicle <const> = CreateVehicle(GetHashKey(args[1]), coords.x, coords.y, coords.z, 0.0, true, true)

	-- Put the player inside the vehicle
	TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)

	-- Log the spawned vehicle to the admin logs
	--ESX.logAdminItems(source, "SPAWN", source, args[1], args[1], 1)

	local plate = ESX.generateRandomString()

	SetVehicleNumberPlateText(vehicle, plate)
	ESX.setVehiclePlate(vehicle, plate)

	return true
end, function(source, args, user)
	-- If the player does not have admin privileges, show an error message
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('spawn_car'), params = {{name = "car", help = _U('spawn_car_param')}}})
