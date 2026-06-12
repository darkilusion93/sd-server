

local DEFAULT_PLAYER_SLOTS <const> = 15
local POLICE_SLOT_INCREMENT <const> = 5

local function getBaseInventorySlots(jobName, extraSlots)
    local baseSlots = DEFAULT_PLAYER_SLOTS

    if jobName == 'police' then
        baseSlots += POLICE_SLOT_INCREMENT
    end

    if extraSlots > 0 then
        baseSlots += extraSlots
    end

    return baseSlots
end

ESX.GetBaseInvSlots = function(jobName, extraSlots)
    return getBaseInventorySlots(jobName, extraSlots)
end

AddEventHandler('esx:setJob', function(source, job, lastJob)
    local extraSlots = ESX.getExtraSlots(source)
    local baseSlots = getBaseInventorySlots(job.name, extraSlots)
    local inventory <const> = ESX.getInvContainer(source)

    inventory.setSlots(baseSlots)
end)