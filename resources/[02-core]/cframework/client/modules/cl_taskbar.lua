local activeTasks = 0
local chance = 0
local skillGap = 20
local factor = 1
local taskInProcess = false
local calm = true

local function openGui(sentLength,taskID,namesent,chancesent,skillGapSent)
    guiEnabled = true
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({action = 'taskbar', runProgress = true, Length = sentLength, Task = taskID, name = namesent, chance = chancesent, skillGap = skillGapSent})
end

local function closeGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled,false)
    SendNUIMessage({action = 'taskbar', closeProgress = true})
end

local function closeNormalGui()
    guiEnabled = false
    SetNuiFocus(guiEnabled, false)
end
  
RegisterNUICallback('taskCancel', function(data, cb)
  closeGui()
  activeTasks = 2
end)

RegisterNUICallback('taskEnd', function(data, cb)
    closeNormalGui()
    activeTasks = 3
    factor = 1
end)

ESX.taskBar = function(difficulty,skillGapSent)
    Wait(100)
    skillGap = skillGapSent
    if skillGap < 5 then
        skillGap = 5
    end
    local name = "E"
    local playerPed = PlayerPedId()
    if taskInProcess then
        return true
    end

    chance = math.random(15,90)

    local length = math.ceil(difficulty * factor)

    taskInProcess = true
    local taskIdentifier = "taskid" .. math.random(1000000)
    openGui(length,taskIdentifier,name,chance,skillGap)
    activeTasks = 1

    while activeTasks == 1 do
        Citizen.Wait(1)
    end

    if activeTasks == 2 then
        closeGui()
        taskInProcess = false
        return false
    else
        closeGui()
        taskInProcess = false
        return true
    end 
end
