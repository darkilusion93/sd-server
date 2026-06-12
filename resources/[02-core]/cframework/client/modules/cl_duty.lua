

local currentDutyMenuLocation, createdMarkers = nil, {} -- Entrar e sair de serviço
local dutyLocation = {}

for jobName, v in pairs(Config.Stations) do
    if v.Duty then
        for _, dutyPos in ipairs(v.Duty) do
            table.insert(dutyLocation, {x = dutyPos.x, y = dutyPos.y, z = dutyPos.z, job = jobName})
        end
    end
end

local function removeDutyMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end
end

local function createDutyMarkers(jobName)
    for i=1, #dutyLocation, 1 do
        if jobName == dutyLocation[i].job or jobName == 'off' .. dutyLocation[i].job then
            exports.ft_libs:AddTrigger("cframework:duty" .. i, {x = dutyLocation[i].x, y = dutyLocation[i].y, z = dutyLocation[i].z, weight = 2, height = 2,
                enter = {eventClient = "cframework:enteredDutyMenuMarker"}, exit = {eventClient = "cframework:exitedDutyMenuMarker"}, data = i})
            table.insert(createdMarkers, "cframework:duty" .. i)
        end
    end
end

local function openJobActionsMenu()
	local elements <const> = {
        {label = T("DUTY_ON_OFF"), value = 'duty_action'}
    }

    TriggerEvent('chud:menu', elements, T("DUTY_JOB"), function(value)
        if value == 'duty_action' then
            TriggerServerEvent('cframework:onDuty')
        end
	end)
end

AddEventHandler("cframework:enteredDutyMenuMarker", function(data)
    currentDutyMenuLocation = data

    while currentDutyMenuLocation ~= nil do
        if ESX.isHandcuffed() then
            currentDutyMenuLocation = nil
        end

        ESX.ShowHelpNotification(T("DUTY_PRESS_TO_TOGGLE_DUTY"))

        if IsControlJustReleased(0,  VK_KEY_E) then
            if ESX.isPlayerDead() then ESX.ShowNotification(T("PLAYERS_NO_MENU_WHEN_DEAD"), "error")
                return
            end

            openJobActionsMenu()
            currentDutyMenuLocation = nil
        end

        Citizen.Wait(0)
    end
end)

AddEventHandler("cframework:exitedDutyMenuMarker", function()
    currentDutyMenuLocation = nil
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    removeDutyMarkers()
    createDutyMarkers(xPlayer.job.name)
end)

RegisterNetEvent('esx:setJob', function(job)
    removeDutyMarkers()
    createDutyMarkers(job.name)
end)
