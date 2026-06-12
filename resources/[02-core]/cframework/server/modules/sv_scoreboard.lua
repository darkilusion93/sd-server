local cops = 0
local ambulance = 0
local totalPlayers = 0
local connectedPlayers = {}

ESX.RegisterServerCallback('esx_scoreboard:getConnectedPlayers', function(source, cb)
	cb(totalPlayers)
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
    if connectedPlayers[playerId] == nil then
        return
    end

	connectedPlayers[playerId].job = job.name
	
	UpdatePlayerTable()
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	AddPlayerToScoreboard(xPlayer, true)
	
	UpdatePlayerTable()
end)


AddEventHandler('playerDropped', function(reason)
	local _source = source

	connectedPlayers[_source] = nil

	UpdatePlayerTable()
end)

AddEventHandler('esx:playerDropped', function(playerId)
	connectedPlayers[playerId] = nil
	
	UpdatePlayerTable()
end)

function AddPlayerToScoreboard(xPlayer, update)
	local playerId = xPlayer.source

	connectedPlayers[playerId] = {}
	connectedPlayers[playerId].job = xPlayer.job.name
	
	UpdatePlayerTable()
end

function UpdatePlayerTable()
	local ems, police, advogado, taxi, mechanic, ammu, realestateagent, gnr, driftclub, cardealerdiscord, players = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 

	for k,v in pairs(connectedPlayers) do
		players = players + 1

		if v.job == 'ambulance' then
			ems = ems + 1
		elseif v.job == 'police' or v.job == 'goe' or v.job == 'pm' then
			police = police + 1
		elseif v.job == 'advogado' then
			advogado = advogado + 1	
		elseif v.job == 'taxi' then
			taxi = taxi + 1
		elseif v.job == 'mechanic' then
			mechanic = mechanic + 1
		elseif v.job == 'realestateagent' then
			realestateagent = realestateagent + 1
		elseif v.job == 'ammu' then
			ammu = ammu + 1	
		elseif v.job == 'gnr' then
			gnr = gnr + 1	
		elseif v.job == 'oficina3' then
			driftclub = driftclub + 1
		elseif v.job == 'uber' then
			cardealerdiscord = cardealerdiscord +1
		end
	end

	
	if cops ~= (police + gnr) then
		cops = police + gnr
		TriggerEvent('esx:onlineCops', cops)
		TriggerClientEvent('esx:onlineCops', -1, cops)
	end

	if ambulance ~= ems then
		ambulance = ems
		TriggerEvent('esx:onlineEms', ambulance)
		TriggerClientEvent('esx:onlineEms', -1, ambulance)
	end

    totalPlayers = players
end

RegisterNetEvent('cframework:getOnlineEms', function()
	local source = source

	TriggerClientEvent('esx:onlineEms', source, ambulance)
end)

RegisterNetEvent('cframework:getOnlineCops', function()
	local source = source

	TriggerClientEvent('esx:onlineCops', source, cops)
end)

