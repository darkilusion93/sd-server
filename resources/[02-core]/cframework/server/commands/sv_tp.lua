


-- Register a new server command for teleporting to coordinates
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'tp', 'mod', function(source, args, _) -- This function will be executed when the 'tp' command is used by a player
	-- Declare constants 'x', 'y', and 'z' and assign them the values passed in as arguments
	local x, y, z <const> = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

	-- Check if the player executing the command has admin privileges
	if not ESX.inAdmin(source) then
		-- If the player does not have admin privileges, show a notification and return false
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Check if the coordinates passed in as arguments are valid
	if not (x and y and z) then
		-- If the coordinates are invalid, show an error message and return false
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Invalid coordinates!")
		return false
	end

	-- Declare constant 'playerPed' and assign it the value of the player's Ped
	local playerPed <const> = GetPlayerPed(source)

	-- Teleport the player to the specified coordinates
	SetEntityCoords(playerPed, x, y, z, true, false, false, false)

	return true
end, function(source, args, user) -- This function will be executed if the player executing the command does not have sufficient permissions
	-- Show an error message to the player
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "Teleport to coordinates", params = {{name = "x", help = "X coords"}, {name = "y", help = "Y coords"}, {name = "z", help = "Z coords"}}})
-- Provide help text and parameter information for the 'tp' command