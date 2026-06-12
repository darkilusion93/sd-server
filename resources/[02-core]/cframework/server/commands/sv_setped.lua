


-- Adds a new command 'setped' to set a player ped
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'setped', 'admin', function(source, args, _)
	-- Check if the player executing the command is an admin
	if not ESX.inAdmin(source) then
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Get the target player's source ID
	local targetSource <const> = tonumber(args[1])

	if not targetSource then return false end

	-- Add the target player to the list of whitelisted peds
	AddPlayerToPedWhitelist(args[1])

	-- Set the target player's ped model to the specified one
	TriggerClientEvent('esx:setplayerped', targetSource, args[2])

	-- Log the admin action
	--ESX.logAdminItems(source, "PED", tonumber(args[1]), args[2], args[2], 1)

	return true
end, function(source, args, user)
	-- Notify the player that they don't have sufficient permissions to execute the command
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('spawn_ped'), params = {{name = "name", help = _U('spawn_ped_param')}}})
