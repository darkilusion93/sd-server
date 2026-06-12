RegisterNetEvent("cframework:sendPoliceAlert", function(street, code)
	local source = source
	local job <const>, playerName <const>, coords <const> = ESX.getJob(source).name, ESX.getFullname(source), GetEntityCoords(GetPlayerPed(source))

    if job ~= "police" then return end

    local radioData <const> = exports["mumble-voip"]:isValidPlayer(source)

    if radioData == nil then return end

    local radioChannel <const> = radioData.radio

    if radioChannel == 0 then return end

    local playersInRadioChannel <const> = exports["mumble-voip"]:GetPlayersInRadioChannel(radioChannel)

	local length = 3500
	local data = {["code"] = (T("POLICE_ALERTS_CODE")):format(code), ["name"] = (T("POLICE_ALERTS_AGENT")):format(playerName), ["loc"] = street}

	if code == 99 then
		data.isImportant = 1
		length = 4500
	end

	if code == 3 then
		data.isImportant = 2
	end

	for player, _ in pairs(ESX.getJobSourceList("police")) do
		local targetRadioData <const> = exports["mumble-voip"]:isValidPlayer(player)

        if targetRadioData == nil then goto skip end

		if code == 99 and targetRadioData.radio ~= 0 then
			TriggerClientEvent("cframework:receivePoliceAlert", player, "police", data, length, code, coords)
		else
        	if playersInRadioChannel[player] == false then
		    	TriggerClientEvent("cframework:receivePoliceAlert", player, "police", data, length, code, coords)
        	end
		end

        ::skip::
	end
end)