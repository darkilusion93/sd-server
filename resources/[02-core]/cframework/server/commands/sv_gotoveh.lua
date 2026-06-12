


-- Adds a new command 'gotoveh' to teleport the player to the specified vehicle.
-- This command is only available for users with 'admin' permission.
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'gotoveh', 'admin', function(source, args, _)
    -- Check if the user has 'admin' permission, if not, show a notification and return false.
	if not ESX.inAdmin(source) then 
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Extract the vehicle's license plate number from the command arguments.
	local plate <const> = table.concat(args, " ")

	-- Loop through all the vehicles in the game world.
	---@diagnostic disable-next-line: param-type-mismatch
	for _, veh in ipairs(GetAllVehicles()) do
		-- If a vehicle's license plate number matches with the given one, teleport the player to that vehicle's location and return true.
		if GetVehicleNumberPlateText(veh) == plate then
			---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
			SetEntityCoords(GetPlayerPed(source), GetEntityCoords(veh))
			return true
		end
	end

	-- If no vehicle matches with the given license plate number, return false.
	return false
end, function(source, args, user)
	-- If the user does not have permission to use this command, show an error message.
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('play_anim')})