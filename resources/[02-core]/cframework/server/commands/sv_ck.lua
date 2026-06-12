


-- Register a new server command for deleting a player
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'ck', 'superadmin', function(source, args, _) -- This function will be executed when the 'setjob' command is used by a player
	-- Declare constant 'targetIdentifier' and assign it the value passed in as argument
	local targetIdentifier <const> = args[1]

	-- Check if the player executing the command has admin privileges
	if not ESX.inAdmin(source) then
		-- If the player does not have admin privileges, show a notification and return false
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	-- Check if the arguments passed in are valid
	if targetIdentifier == nil or targetIdentifier == "" then
		-- If the arguments are invalid, show an error message and return false
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid usage.' } })
		return false
	end

    local doesPlayerExist = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {['@identifier'] = targetIdentifier})[1] ~= nil

    if not doesPlayerExist then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not found.' } })
        return false
    end

	-- Get the player with the specified ID
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	-- Check if the player is online
	if xPlayer ~= nil then
		-- If the player is online, kick him
		DropPlayer(xPlayer.source, "CK em progresso")
	end

    --ESX.logAdminActionsOffline(source, "CK", targetIdentifier)

    local houses = MySQL.Sync.fetchAll('SELECT * FROM casas WHERE owner = @owner', {['@owner'] = targetIdentifier})

    if houses ~= nil and houses[1] ~= nil then
        for _, house in ipairs(houses) do
            MySQL.Async.execute('DELETE FROM inventory_data WHERE identifier = @identifier', {['@identifier'] = "casa_"..house.id})
            MySQL.Async.execute('DELETE FROM inventory_data WHERE identifier = @identifier', {['@identifier'] = "garage_"..house.id})
        end
    end

	MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {['@identifier'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM addon_account_data WHERE owner = @owner', {['@owner'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM billing WHERE identifier = @identifier', {['@identifier'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM characters WHERE identifier = @identifier', {['@identifier'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM datastore_data WHERE owner = @owner', {['@owner'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE owner = @owner', {['@owner'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM user_accounts WHERE identifier = @identifier', {['@identifier'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM user_licenses WHERE owner = @owner', {['@owner'] = targetIdentifier})
	MySQL.Async.execute('DELETE FROM casas WHERE owner = @owner', {['@owner'] = targetIdentifier})
    MySQL.Async.execute('DELETE FROM inventory_data WHERE identifier LIKE @identifier', {['@identifier'] = "%"..targetIdentifier.."%"})

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'CK efetuado com sucesso.' } })

	return true
end, function(source, args, user) -- This function will be executed if the player executing the command does not have sufficient permissions
	-- Show an error message to the player
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "CK a player", params = {{name = "steam", help = "ID steam do player"}}})
-- Provide help text and parameter information for the 'ck' command