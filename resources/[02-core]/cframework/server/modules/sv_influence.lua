

local cachedInfluences = {}

local function getInfluence(influenceId)
    if cachedInfluences[influenceId] then
        return cachedInfluences[influenceId]
    end

    local result = MySQL.Sync.fetchAll("SELECT * FROM `influence` WHERE `id` = @id", {
        ['@id'] = influenceId
    })

    if result and result[1] then
        result[1].label = ESX.Jobs[result[1].identifier] and ESX.Jobs[result[1].identifier].label or "N/A"

        cachedInfluences[influenceId] = result[1]
        return result[1]
    else
        return {}
    end
end

local function setInfluence(identifier, influenceId, level)
    cachedInfluences[influenceId] = {
        identifier = identifier,
        id = influenceId,
        level = level,
        label = ESX.Jobs[identifier] and ESX.Jobs[identifier].label or "N/A"
    }

    MySQL.Async.execute("INSERT INTO `influence` (`identifier`, `id`, `level`) VALUES (@identifier, @id, @level) ON DUPLICATE KEY UPDATE `level` = @level, `identifier` = @identifier", {
        ['@identifier'] = identifier,
        ['@id'] = influenceId,
        ['@level'] = level
    })
end

local function processInfluence(identifier, influenceName, influenceVariation)
    local influence <const> = ESX.getInfluence(influenceName)
    local variation <const> = influenceVariation or 0

    if influence.level == nil or influence.level == 0 then
        ESX.setInfluence(influenceName, identifier, variation)

        return false
    else
        if influence.identifier == identifier then
            local newLevel <const> = math.min(1000, influence.level + variation)
            ESX.setInfluence(influenceName, identifier, newLevel)

            if newLevel == 1000 then
                return true
            end

            return false
        else
            local newLevel <const> = math.max(0, influence.level - variation)

            if newLevel == 0 then
                ESX.setInfluence(influenceName, identifier, variation)
            else
                ESX.setInfluence(influenceName, influence.identifier, newLevel)
            end

            return false
        end
    end
end

function ESX.getInfluence(influenceId)
    return getInfluence(influenceId)
end

function ESX.setInfluence(influenceId, identifier, level)
    setInfluence(identifier, influenceId, level)
end

function ESX.proccessInfluence(identifier, influenceId, variation)
    return processInfluence(identifier, influenceId, variation)
end

RPC.register("cframework:getInfluence", function(craftIdentifier)
    local influenceLevel <const> = getInfluence(craftIdentifier)

    return influenceLevel
end)