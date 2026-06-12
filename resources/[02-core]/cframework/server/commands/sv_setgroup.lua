


---Adds a new command 'setgroup' to set a player group
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'setgroup', 'superadmin', function(source, args, _)
    -- Extract the 'identifier' and 'amount' from the command arguments
    local identifier <const>, group <const> = args[1], args[2]
    local validGroups = {['user'] = true, ['mod'] = true, ['admin'] = true, ['superadmin'] = true}

    -- Check if 'identifier' is nil (invalid player)
    if identifier == nil then
        -- Notify the player that the player is invalid
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player inválido.' } })
        return false -- Return false to indicate failure
    end

    -- Check if 'group' is valid
    if not validGroups[group] then
        -- Notify the player that the group is invalid
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Grupo inválido.' } })
        return false -- Return false to indicate failure
    end

    -- Attempt to retrieve the player with the given 'identifier'
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    -- Check if 'xPlayer' is not nil (player with the given identifier exists)
    if xPlayer ~= nil then
        DropPlayer(xPlayer.source, 'As tuas permissões foram alteradas.')
    end

    -- If 'xPlayer' is nil, check if the player is in the 'cachedUsers' table
    if cachedUsers[identifier] ~= nil then
		-- Set 'group' to the player in the 'cachedUsers' table
		cachedUsers[identifier].group = group
    end

    -- Execute a MySQL query to update the group for the player in the database
    MySQL.Async.execute("UPDATE `users` SET `group` = @group WHERE `identifier` = @identifier", {["@identifier"] = identifier, ["@group"] = group})

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Permissões alteradas.' } })

    return true -- Return true to indicate success
end, function(source, _, _)
    -- If the superadmin player doesn't have sufficient permissions, notify them
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "givecoins", params = {{name = "identifier", help = "steam"}, {name = "amount", help = _U('amount')}}})
