


---Adds a new command 'givecoins' to add coins to a player
---@param source number
---@param args table
---@param _ any
---@return boolean
TriggerEvent('es:addGroupCommand', 'givecoins', 'superadmin', function(source, args, _)
    -- Extract the 'identifier' and 'amount' from the command arguments
    local identifier <const>, amount <const> = args[1], tonumber(args[2])

    -- Check if 'identifier' is nil (invalid player)
    if identifier == nil then
        -- Notify the player that the player is invalid
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player inválido.' } })
        return false -- Return false to indicate failure
    end

    -- Check if 'amount' is nil or less than or equal to 0
    if amount == nil or amount <= 0 then
        -- Notify the player that the amount is invalid
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Quantia inválida.' } })
        return false -- Return false to indicate failure
    end

    -- Attempt to retrieve the player with the given 'identifier'
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

    -- Check if 'xPlayer' is not nil (player with the given identifier exists)
    if xPlayer ~= nil then
        -- Add 'amount' of coins to the player
        xPlayer.addCoins(amount)
        -- Notify the player that coins have been added
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Coins adicionadas.' } })
        return true -- Return true to indicate success
    end

    -- If 'xPlayer' is nil, check if the player is in the 'cachedUsers' table
    if cachedUsers[identifier] ~= nil then
		-- Add 'amount' of coins to the player in the 'cachedUsers' table
		cachedUsers[identifier].coins = cachedUsers[identifier].coins + amount
    end

    -- Execute a MySQL query to update the coins for the player in the database
    MySQL.Async.execute("UPDATE users SET coins = coins + " .. amount .. " WHERE identifier = @identifier", {["@identifier"] = identifier})

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Coins adicionadas.' } })

    return true -- Return true to indicate success
end, function(source, _, _)
    -- If the superadmin player doesn't have sufficient permissions, notify them
    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "givecoins", params = {{name = "identifier", help = "steam"}, {name = "amount", help = _U('amount')}}})
