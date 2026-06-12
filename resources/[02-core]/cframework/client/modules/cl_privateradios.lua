


RegisterNetEvent("esx:playerLoaded", function(player)
    if player.job.name == 'police' or player.job.name == 'ambulance' then
		exports["mumble-voip"]:GivePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6)
	else
		exports["mumble-voip"]:RemovePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6)
	end

    if player.job.name == 'tribunal' or player.job.name == 'governo' then
		exports["mumble-voip"]:GivePlayerAccessToFrequencies(7, 8)
	else
		exports["mumble-voip"]:RemovePlayerAccessToFrequencies(7, 8)
	end
end)

RegisterNetEvent('esx:setJob', function(job)
    if job.name == 'police' or job.name == 'ambulance' then
		exports["mumble-voip"]:GivePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6)
	else
		exports["mumble-voip"]:RemovePlayerAccessToFrequencies(1, 2, 3, 4, 5, 6)
	end

    if job.name == 'tribunal' or job.name == 'governo' then
		exports["mumble-voip"]:GivePlayerAccessToFrequencies(7, 8)
	else
		exports["mumble-voip"]:RemovePlayerAccessToFrequencies(7, 8)
	end
end)