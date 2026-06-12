


RegisterNetEvent('3dme:shareDisplay', function(args, playerTable)
	local source = source
	local text = "* " ..  table.concat(args, " ") .. " *"

	for player, _ in pairs(playerTable) do
		TriggerClientEvent('3dme:shareDisplay', player, text, source)
	end

	TriggerEvent('3dme:log', text, source)
end)
