

local function getJobMetadata(job)
    if ESX.Jobs[job] then
        return ESX.Jobs[job].metadata
    end

    return {}
end

local function getJobMetadataKey(job, key)
    if ESX.Jobs[job] then
        return ESX.Jobs[job].metadata[key]
    end

    return nil
end

local function setJobMetadataKey(job, key, value)
    if ESX.Jobs[job] == nil then
        return
    end

    if ESX.Jobs[job].metadata == nil then
        ESX.Jobs[job].metadata = {}
    end

    ESX.Jobs[job].metadata[key] = value

    for player, _ in pairs(ESX.getJobSourceList(job)) do
        TriggerClientEvent("cframework:updateJobMetadata", player, getJobMetadata(job))
    end

    MySQL.Async.execute("INSERT INTO jobs (name, metadata) VALUES (@name, @metadata) ON DUPLICATE KEY UPDATE metadata = @metadata", {
        ["@metadata"] = json.encode(getJobMetadata(job)),
        ["@name"] = job
    })
end

local function canJobUseExperience(job)
    return ESX.Jobs[job].whitelisted
end

function ESX.clearJobMetadata(job)
    if ESX.Jobs[job] == nil then
        return
    end

    ESX.Jobs[job].metadata = {}

    for player, _ in pairs(ESX.getJobSourceList(job)) do
        TriggerClientEvent("cframework:updateJobMetadata", player, getJobMetadata(job))
    end

    MySQL.Async.execute("INSERT INTO jobs (name, metadata) VALUES (@name, @metadata) ON DUPLICATE KEY UPDATE metadata = @metadata", {
        ["@metadata"] = json.encode({}),
        ["@name"] = job
    })
end

function ESX.addJobExperience(job, type, amount, source)
    if not canJobUseExperience(job) then
        return
    end

    local numAmount <const> = tonumber(amount)
    local oldExperience = getJobMetadataKey(job, type)

    if oldExperience == nil then
        setJobMetadataKey(job, type, 0)
        oldExperience = 0
    end

    setJobMetadataKey(job, type, oldExperience + numAmount)

    if source ~= nil then
        TriggerClientEvent("cframework:giveExperience", source, oldExperience, numAmount)
    end
end

function ESX.getJobExperience(job, type)
    return getJobMetadataKey(job, type) or 0
end