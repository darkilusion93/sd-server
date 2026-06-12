
local doors = {}
local currentDoorCoords, currentDoorId, currentDoorLockState, jobname = vector3(0, 0, 0), nil, nil, nil
local listening = false

Citizen.CreateThread(function()
    while not ESX.GetPlayerData().job do
        Citizen.Wait(10)
    end

    jobname = ESX.GetPlayerData().job.name
end)

RegisterNetEvent('esx:setJob', function(job) jobname = job.name end)


RegisterNetEvent('gdoors:initialize', function(pDoors)
    doors = pDoors
    for doorId, door in ipairs(doors) do
        if not IsDoorRegisteredWithSystem(doorId) then
            AddDoorToSystem(doorId, door.model, door.coords.x, door.coords.y, door.coords.z, false, false, false)

            if door.openRatio then
                DoorSystemSetOpenRatio(doorId, door.openRatio, true, true)
            end

            DoorSystemSetDoorState(doorId, door.lock, false, true)
        end
    end
end)

RegisterNetEvent('gdoors:change-lock-state', function(pDoorId, pDoorLockState, openRatio)
    if doors and doors[pDoorId] then
        doors[pDoorId].lock = pDoorLockState
        doors[pDoorId].openRatio = openRatio

        if openRatio then
            DoorSystemSetOpenRatio(pDoorId, openRatio, true, true)
        end

        DoorSystemSetDoorState(pDoorId, pDoorLockState, false, true)
        if pDoorId == currentDoorId then currentDoorLockState = pDoorLockState end
    end
end)

local function listenForKeypress()
    listening = true
    Citizen.CreateThread(function()

        local newDoorId, newLockState = currentDoorId, nil

        currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)

        local hasAccess = hasSecuredAccess(currentDoorId)

        --if not hasAccess and currentDoorLockState then ESX.ShowNotification('Porta trancada', 'error') end

        if hasAccess and currentDoorLockState then ESX.ShowNotification(T("DOORLOCK_UNLOCK"), 'error') end
        if hasAccess and not currentDoorLockState then ESX.ShowNotification(T("DOORLOCK_LOCK"), 'success') end

        while listening do
            local idle = 0

            if currentDoorId ~= newDoorId then
                currentDoorLockState = (DoorSystemGetDoorState(currentDoorId) ~= 0 and true or false)
                newDoorId = currentDoorId
            end

            if currentDoorLockState ~= newLockState then
                if #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 2.0 then newLockState = currentDoorLockState else idle = 100 end
            end

            if currentDoorId ~= nil and hasAccess and IsControlJustReleased(0, 38) and #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentDoorCoords)) <= 1.8 then
                ESX.ShowNotification(newLockState and T("DOORLOCK_UNLOCKED") or T("DOORLOCK_LOCKED"), newLockState and 'success' or 'error')
                TriggerServerEvent("gdoors:change-lock-state", currentDoorId, not currentDoorLockState)
            end

            Wait(idle)
        end
    end)
end

function GetTargetDoorId(pEntity)
    local activeDoors = DoorSystemGetActive()

    if activeDoors == nil then return end

    for _, activeDoor in pairs(activeDoors) do
        if activeDoor[2] == pEntity then
            return activeDoor[1]
        end
    end
end

function hasSecuredAccess(currentDoorId)
	for k,job in pairs(doors[currentDoorId].job) do
		if job == jobname then return true end
        if job == 'none' then return true end
	end

	return false
end

AddEventHandler("np:target:changed", function(pEntity, pEntityType, pEntityCoords)
    if pEntityType == nil or pEntityType ~= 3 then listening, currentDoorCoords, currentDoorId, currentDoorLockState = nil
        return
    end

    local doorId = GetTargetDoorId(pEntity)

    if (doorId) then
        currentDoorId = doorId
        currentDoorCoords = pEntityCoords

        if not listening then
            listenForKeypress()
        end
    end
end)