

local dutyJobs = {}

Citizen.CreateThread(function()
    for jobName, station in pairs(Config.Stations) do
        if station.Duty then
            dutyJobs[jobName] = "off" .. jobName
            dutyJobs["off" .. jobName] = jobName
        end
    end
end)

RegisterServerEvent("cframework:onDuty", function()
	local source <const> = source
	local job <const> = ESX.getJob(source)

	if not dutyJobs[job.name] then TriggerClientEvent("esx:showNotification", source, T("DUTY_JOB_NO_DUTY_AVAILABLE"), "error")
		return
	end

	ESX.setJob(source, dutyJobs[job.name], job.grade)
	TriggerClientEvent("esx:showNotification", source, T("DUTY_JOB_ON_OFF"), "success")
end)