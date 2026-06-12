


TriggerEvent('es:addGroupCommand', 'motel', 'superadmin', function(source, args, user)
	local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
	local id = MySQL.Sync.fetchScalar("SELECT id FROM properties WHERE id=(SELECT max(id) FROM properties)")

	MySQL.Async.execute('INSERT INTO properties (name, label, entering, outside) VALUES (@name, @label, @entering, @outside)', {
		['@name']   = 'motel' .. id,
		['@label']  = 'quarto' .. id,
		['@entering'] = json.encode(playerCoords),
		['@outside']  = json.encode(playerCoords),
	}, function(rowsChanged)

	end)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})
