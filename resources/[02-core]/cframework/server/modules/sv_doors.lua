local doorState = Config.Doors

Citizen.CreateThread(function()
    for _, station in pairs(Config.Stations) do
        if station.Doors then
            for _,door in pairs(station.Doors) do
                table.insert(doorState, door)
            end
        end
    end
end)

function ESX.GetDoorIdFromName(doorName)
    for k,v in pairs(doorState) do
        if v.name and v.name == doorName then
            return k
        end
    end
end

local function isAuthorized(source, jobName, currentDoorId)
	for k,job in pairs(doorState[currentDoorId].job) do
		if job == jobName then return true end
        if job == 'none' then return true end

        if string.find(job, "tag:") then
            local role,_ = string.gsub(job, "tag:", "")

            if IsRolePresent(source, tonumber(role)) then
                return true
            end
        end
	end

	return false
end

RegisterNetEvent('gdoors:change-lock-state', function(currentDoorId, LockState)
    local source = source

	if isAuthorized(source, ESX.getJob(source).name, currentDoorId) then
		doorState[currentDoorId].lock = LockState
        TriggerClientEvent('gdoors:change-lock-state', -1, currentDoorId, LockState)
    end
end)

AddEventHandler('gdoors:script-change-lock-state', function(currentDoorId, LockState, OpenRatio)
    doorState[currentDoorId].lock = LockState
    doorState[currentDoorId].openRatio = OpenRatio
    TriggerClientEvent('gdoors:change-lock-state', -1, currentDoorId, LockState, OpenRatio)
end)

AddEventHandler('playerJoining', function()
    TriggerClientEvent('gdoors:initialize', source, doorState)
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    TriggerClientEvent('gdoors:initialize', -1, doorState)
end)