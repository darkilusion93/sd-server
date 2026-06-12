
function UpdatePlayerTable(connectedPlayers)
	--local ems, police, advogado, taxi, mechanic, ammu, realestateagent, gnr, driftclub, cardealerdiscord, players = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

	--for k,v in pairs(connectedPlayers) do
	--	players = players + 1

		--if v.job == 'ambulance' then
		--	ems = ems + 1
		--elseif v.job == 'police' or v.job == 'goe' then
		--	police = police + 1
		--elseif v.job == 'advogado' then
		--	advogado = advogado + 1	
		--elseif v.job == 'taxi' then
		--	taxi = taxi + 1
		--elseif v.job == 'mechanic' then
		--	mechanic = mechanic + 1
		--elseif v.job == 'realestateagent' then
		--	realestateagent = realestateagent + 1
		--elseif v.job == 'ammu' then
		--	ammu = ammu + 1	
		--elseif v.job == 'gnr' then
		--	gnr = gnr + 1	
		--elseif v.job == 'oficina1' then
		--	driftclub = driftclub + 1
		--elseif v.job == 'uber' then
		--	cardealerdiscord = cardealerdiscord +1
		--end
	--end

	SendNUIMessage({
		action = 'scoreboardUpdate',
		jobs   = { player_count = connectedPlayers}
	})
end

RegisterCommand('togglescoreboard', function()
	ESX.TriggerServerCallback('esx_scoreboard:getConnectedPlayers', function(connectedPlayers)
		UpdatePlayerTable(connectedPlayers)
	end)

    ToggleScoreBoard()
end, false)

RegisterKeyMapping('togglescoreboard', 'Scoreboard', 'keyboard', 'f10')


function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggleScoreboard'
	})
end

