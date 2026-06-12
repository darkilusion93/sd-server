


-- This event adds a command called "dv" to a group called "mod"
---@param source number
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'dv', 'mod', function(source, _, _)
	-- Check if the player has admin rights, if not show an error notification and return false
	if not ESX.inAdmin(source) then
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Trigger an event on the client to delete the player's vehicle
	TriggerClientEvent('esx:deleteVehicle', source)

	return true
end, function(source, args, user)
	-- If the player doesn't have sufficient permissions to use the command, show an error message
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('delete_vehicle')})