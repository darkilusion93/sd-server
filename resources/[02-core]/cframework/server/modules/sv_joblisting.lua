ESX.RegisterServerCallback('esx_joblisting:getJobsList', function(source, cb)
	local availableJobs = {}

	for k, v in pairs(ESX.Jobs) do
		if not v.whitelisted then
			table.insert(availableJobs, {
				job = v.name,
				label = v.label
			})
		end
	end

	cb(availableJobs)
end)


RegisterServerEvent('cframework:chooseJobFromList', function(job)
	local source = source

	for k, v in pairs(ESX.Jobs) do
		if not v.whitelisted and v.name == job then
			ESX.setJob(source, job, 0)
			break
		end
	end
end)

RegisterServerEvent('esx_joblisting:setJob2', function(job)
	TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Tentativa de SetJob', nil, false)
end)
