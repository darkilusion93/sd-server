


-- Register a new server command for setting a player's job
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'setjob', 'mod', function(source, args, _) -- This function will be executed when the 'setjob' command is used by a player
	-- Declare constants 'targetSource', 'jobName', and 'jobGrade' and assign them the values passed in as arguments
	local targetSource, jobName, jobGrade <const> = tonumber(args[1]), args[2], tonumber(args[3])

	-- Check if the player executing the command has admin privileges
	if not ESX.inAdmin(source) then
		-- If the player does not have admin privileges, show a notification and return false
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Check if the arguments passed in are valid
	if not (targetSource and jobName and jobGrade) then
		-- If the arguments are invalid, show an error message and return false
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
		return false
	end

	-- Check if the job specified exists
	if not ESX.DoesJobExist(jobName, jobGrade) then
		-- If the job does not exist, show an error message and return false
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'That job does not exist.' } })
		return false
	end

	-- Get the player with the specified ID
	local xPlayer = ESX.GetPlayerFromId(targetSource)

	-- Check if the player is online
	if xPlayer == nil then
		-- If the player is not online, show an error message and return false
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
		return false
	end

	-- Set the player's job
	xPlayer.setJob(jobName, jobGrade)

	-- Log the action in the server's admin log
	--ESX.logAdminItems(source, "JOB", targetSource, jobName, xPlayer.getJob().label, jobGrade)

	return true
end, function(source, args, user) -- This function will be executed if the player executing the command does not have sufficient permissions
	-- Show an error message to the player
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('setjob'), params = {{name = "id", help = _U('id_param')}, {name = "job", help = _U('setjob_param2')}, {name = "grade_id", help = _U('setjob_param3')}}})
-- Provide help text and parameter information for the 'setjob' command
