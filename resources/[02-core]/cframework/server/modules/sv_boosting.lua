

local levels <const> = {0, 800, 2100, 3800, 6100, 9500, 12500, 16000, 19800, 24000, 28500, 33400, 38700, 44200, 50200, 56400, 63000,
69900, 77100, 84700, 92500, 100700, 109200, 118000, 127100, 136500, 146200, 156200, 166500, 177100, 188000, 199200, 210700, 222400,
234500, 246800, 259400, 272300, 285500, 299000, 312700, 326800, 341000, 355600, 370500, 385600, 401000, 416600, 432600, 448800, 465200,
482000, 499000, 516300, 533800, 551600, 569600, 588000, 606500, 625400, 644500, 663800, 683400, 703300, 723400, 743800, 764500, 785400,
806500, 827900, 849600, 871500, 893600, 961600, 984700, 1008100, 1031800, 1055700, 1079800, 1104200, 1128800, 1153700, 1178800, 1204200,
1229800, 1255600, 1281700, 1308100, 1334600, 1361400, 1388500, 1415800, 1443300, 1471100, 1499100, 1527300, 1555800, 1584350, 1612950,
1641600, 1670300, 1699050, 1727850, 1785600, 1814550, 1843550, 1872600, 1901700, 1930850, 1960050, 1989300, 2018600, 2047950, 2077350,
2106800, 2136300, 2165850, 2195450, 2225100, 2254800, 2284550, 2314350, 2344200, 2374100, 2404050, 2434050, 2464100}

local boostingData = LoadBoosting()
local copCount = 0
local activeBoosts = {}

local registeredMissions = {}
local registeredSyncCallbacks = {}
local registeredCleanupCallbacks = {}

local inBoost = {}
local ownedBoosts = {}

function RegisterBoostMission(missionName, missionFunction)
    registeredMissions[missionName] = missionFunction
end

function GetRegisteredMission(missionName)
    return registeredMissions[missionName]
end

function GetBoostingMissionData(missionId)
    return activeBoosts[missionId]
end

function GetBoostingMissionDataByPlayer(playerId)
    for _, missionData in pairs(activeBoosts) do
        if missionData.playerId == playerId then
            return missionData
        end
    end

    return nil
end

function GetBoostingMissionDataByPlayerMember(playerId)
    for _, missionData in pairs(activeBoosts) do
        for _, member in ipairs(missionData.members) do
            if member.playerId == playerId then
                return missionData
            end
        end
    end

    return nil
end

function SetBoostingMissionData(missionId, data)
    activeBoosts[missionId] = data
end

function TriggerClientEventForBoostParty(eventName, missionId, ...)
    local missionData <const> = GetBoostingMissionData(missionId)

    if not missionData then
        return
    end

    for _, member in ipairs(missionData.members) do
        if member.status == "party" or member.status == "owner" then
            TriggerClientEvent(eventName, member.playerId, ...)
        end
    end
end

function GetDistanceOfClosestBoostMemberParty(missionId, coords)
    local missionData <const> = GetBoostingMissionData(missionId)

    if not missionData then
        return 10000.0
    end

    local closestDistance = 10000.0

    for _, member in ipairs(missionData.members) do
        if member.status == "party" or member.status == "owner" then
            local playerPed <const> = GetPlayerPed(member.playerId)

            if DoesEntityExist(playerPed) then
                local distance <const> = #(GetEntityCoords(playerPed) - coords)

                if closestDistance == nil or distance < closestDistance then
                    closestDistance = distance
                end
            end
        end
    end

    return closestDistance
end


function RegisterMissionSyncCallback(missionName, syncCallback)
    registeredSyncCallbacks[missionName] = syncCallback
end

function SyncNewMemberToMission(playerId, boostId)
    local missionData = GetBoostingMissionData(boostId)

    if not missionData or not missionData.currentStep then
        return
    end

    local syncCallback = registeredSyncCallbacks[missionData.currentStep]

    if syncCallback then
        syncCallback(playerId, boostId, missionData)
    end
end

function RegisterMissionCleanupCallback(missionName, cleanupCallback)
    registeredCleanupCallbacks[missionName] = cleanupCallback
end

function CleanupMemberFromMission(playerId, boostId)
    local missionData = GetBoostingMissionData(boostId)

    if not missionData or not missionData.currentStep then
        return
    end

    local cleanupCallback = registeredCleanupCallbacks[missionData.currentStep]

    if cleanupCallback then
        cleanupCallback(playerId, boostId, missionData)
    end
end

AddEventHandler('esx:onlineCops', function(amount)
    copCount = amount
end)

local function updateOwnedContracts(source)
    local identifier <const> = ESX.getIdentifier(source)

    ownedBoosts[identifier] = ownedBoosts[identifier] or {}

    local availableContracts = {}

    for contractId, contractInfo in pairs(boostingData.contracts) do
        local ownedCount = ownedBoosts[identifier][contractId] or 0

        if ownedCount > 0 then
            table.insert(availableContracts, {
                id = contractId,
                ownedCount = ownedCount
            })
        end
    end

    TriggerClientEvent("cframework:updateAvailableContracts", source, availableContracts)
end

local function processBoostRewards(source, rewards, missionData)
    local numMembers = #missionData.members

    if rewards.items then
        for _, member in ipairs(missionData.members) do
            local memberInventory <const> = ESX.getInvContainer(member.playerId)

            for _, item in ipairs(rewards.items) do
                memberInventory.addItem(item.name, math.floor((math.random(item.minCount, item.maxCount))/numMembers))
            end
        end
    end

    if rewards.coins then
        for _, member in ipairs(missionData.members) do
            ESX.setBoostCoins(member.playerId, ESX.getBoostCoins(member.playerId) + math.floor(rewards.coins / numMembers))
        end
    end

    if rewards.vehicle then
        local generatedPlate <const> = ESX.GeneratePlate()
        local vehicleProps <const> = {model = GetHashKey(missionData.vehicleModel), plate = generatedPlate}
        local closestZone <const> = ESX.getClosestGarageZone(GetEntityCoords(GetPlayerPed(source)))

        ESX.addVehicle(source, {vehicle = vehicleProps, stored = true, plate = vehicleProps.plate, type = "car", zone = closestZone}, true)
    end
end

local function proccessBoostRequirements(source, contractInfo)
    local inventory <const> = ESX.getInvContainer(source)

    if contractInfo.requires.items then
        for _, req in ipairs(contractInfo.requires.items) do
            if not inventory.canRemoveItem(req.name, req.count) then
                return false
            end
        end
    end

    if contractInfo.requires.coins then
        if ESX.getBoostCoins(source) < contractInfo.requires.coins then
            return false
        end
    end

    return true
end

local function consumeBoostRequirements(source, contractInfo)
    local inventory <const> = ESX.getInvContainer(source)

    if contractInfo.requires.items then
        for _, req in ipairs(contractInfo.requires.items) do
            inventory.removeItem(req.name, req.count)
        end
    end

    if contractInfo.requires.coins then
        ESX.setBoostCoins(source, ESX.getBoostCoins(source) - contractInfo.requires.coins)
    end
end

MySQL.ready(function()
    MySQL.Async.fetchAll('SELECT * FROM owned_boosts', {}, function(results)
        for _, row in ipairs(results) do
            if ownedBoosts[row.identifier] == nil then
                ownedBoosts[row.identifier] = {}
            end

            ownedBoosts[row.identifier][row.boostId] = row.count
        end
    end)
end)

RegisterNetEvent("cframework:boostingStartMission", function(cId)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    if inBoost[source] or GetBoostingMissionDataByPlayerMember(source) then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_ALREADY_IN_BOOST"))
        return
    end

    inBoost[source] = true

    ownedBoosts[identifier] = ownedBoosts[identifier] or {}

    if ownedBoosts[identifier][cId] == nil then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_DOESNT_OWN_CONTRACT"))
        inBoost[source] = nil
        return
    end

    local contractId <const> = cId
    local contract <const> = boostingData.contracts[contractId]
    local randomBoostId = math.random(10000, 99999)

    if copCount < contract.minCops then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_ENOUGH_COPS"))
        inBoost[source] = nil
        return
    end

    if not proccessBoostRequirements(source, contract) then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_ENOUGH_REQUIREMENTS"))
        inBoost[source] = nil
        return
    end

    if ESX.getExperience(source, "boosting") < levels[contract.level] then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_ENOUGH_EXPERIENCE"))
        inBoost[source] = nil
        return
	end

    ownedBoosts[identifier][cId] = ownedBoosts[identifier][cId] - 1

    MySQL.Async.execute('UPDATE owned_boosts SET count = count - 1 WHERE identifier = @player_id AND boostId = @contract_id', {
        ['@player_id'] = identifier,
        ['@contract_id'] = cId
    })

    if ownedBoosts[identifier][cId] <= 0 then
        ownedBoosts[identifier][cId] = nil

        MySQL.Async.execute('DELETE FROM owned_boosts WHERE identifier = @player_id AND boostId = @contract_id', {
            ['@player_id'] = identifier,
            ['@contract_id'] = cId
        })
    end

    updateOwnedContracts(source)

    consumeBoostRequirements(source, contract)

    while GetBoostingMissionData(randomBoostId) do
        randomBoostId = math.random(10000, 99999)
    end

    SetBoostingMissionData(randomBoostId, {
        boostId = randomBoostId,
        playerId = source,
        members = {
            {playerId = source, name = ESX.getFullname(source) or T("BOOSTING_UNKNOWN_PLAYER"), status = "owner"}
        },
        contractId = contractId,
        rewards = contract.rewards,
        timer = contract.timer,
        startTime = os.time(),
        isActive = true,
    })

    local memberName = ESX.getFullname(source) or T("BOOSTING_UNKNOWN_PLAYER")
    local completed = true

    TriggerClientEvent("cframework:updateCurrentBoost", source, {contractId = contractId, boostId = randomBoostId, timer = contract.timer, memberName = memberName})

    for stepIndex, stepName in ipairs(boostingData.missions[contract.missionType].steps) do
        local missionFunction <const> = GetRegisteredMission(stepName)

        if missionFunction then
            local missionData = GetBoostingMissionData(randomBoostId)

            missionData.currentStep = stepName

            SetBoostingMissionData(randomBoostId, missionData)

            local success = missionFunction(contractId, randomBoostId)

            if not success then
                for _, member in ipairs(missionData.members) do
                    CleanupMemberFromMission(member.playerId, randomBoostId)
                end

                TriggerClientEventForBoostParty("cframework:showBoostingNotification", contractId, T("BOOSTING_FAILED"))
                completed = false
                break
            end
        end
    end

    local missionData = GetBoostingMissionData(randomBoostId)

    if completed then
        processBoostRewards(source, contract.rewards, missionData)

        local numMembers = #missionData.members

        for _, member in ipairs(missionData.members) do
            if ESX.getExperience(member.playerId, "boosting") < levels[contract.level + 1] then
                ESX.addExperience(member.playerId, "boosting", math.floor(contract.increment/numMembers))
            end
        end

        MySQL.Async.execute('INSERT INTO boosting_leaderboard (identifier, level, count) VALUES (@player_id, @level, @count) ON DUPLICATE KEY UPDATE count = count + @count', {
            ['@player_id'] = identifier,
            ['@level'] = contract.level,
            ['@count'] = 1
        })
    end

    local vehicleEntity = missionData and missionData.vehicleEntity
    local towEntity = missionData and missionData.towEntity
    local createdPeds = missionData and missionData.createdPeds

    Citizen.CreateThread(function()
        Citizen.Wait(10000)

        if vehicleEntity and DoesEntityExist(vehicleEntity) then
            DeleteEntity(vehicleEntity)
        end

        if towEntity and DoesEntityExist(towEntity) then
            DeleteEntity(towEntity)
        end

        if createdPeds then
            for _, ped in ipairs(createdPeds) do
                if DoesEntityExist(ped) then
                    DeleteEntity(ped)
                end
            end
        end
    end)

    TriggerClientEventForBoostParty("cframework:updateCurrentBoost", randomBoostId, nil)
    SetBoostingMissionData(randomBoostId, nil)

    inBoost[source] = nil
end)

RegisterNetEvent("cframework:boostingJoinBoost", function(missionId)
    local source <const> = source
    local missionData <const> = GetBoostingMissionData(missionId)

    if not missionData then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_DOESNT_EXIST"))
        return
    end

    if not missionData.isActive then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_ALREADY_COMPLETED"))
        return
    end

    if #missionData.members >= 4 then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_FULL"))
        return
    end

    local memberName = ESX.getFullname(source) or T("BOOSTING_UNKNOWN_PLAYER")

    table.insert(missionData.members, {playerId = source, name = memberName, status = "pending"})

    for k, v in pairs(missionData.members) do
        if v.playerId == source then
            goto continue
        end

        TriggerClientEvent("cframework:updateCurrentBoostMembers", v.playerId, {members = missionData.members, isOwner = (v.playerId == missionData.playerId)})
        ::continue::
    end

    TriggerClientEvent("cframework:showBoostingNotification", missionData.playerId, T("BOOSTING_NEW_MEMBER_PENDING"))

    SetBoostingMissionData(missionId, missionData)
end)

RegisterNetEvent("cframework:boostingAcceptMember", function(playerId)
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayer(source)

    if not missionData then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    if missionData.playerId ~= source then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_OWNER"))
        return
    end

    local memberFound = false

    for k, member in ipairs(missionData.members) do
        if member.playerId == playerId and member.status == "pending" then
            missionData.members[k].status = "party"
            memberFound = true
            break
        end
    end

    if not memberFound then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_INVALID_MEMBER"))
        return
    end

    TriggerClientEvent("cframework:updateCurrentBoost", playerId, {contractId = missionData.contractId, boostId = missionData.boostId, timer = missionData.timer - (os.time() - missionData.startTime), memberName = ""})

    SyncNewMemberToMission(playerId, missionData.boostId)

    for k, v in pairs(missionData.members) do
        TriggerClientEvent("cframework:updateCurrentBoostMembers", v.playerId, {members = missionData.members, isOwner = (v.playerId == missionData.playerId)})
    end

    SetBoostingMissionData(missionData.boostId, missionData)
end)

RegisterNetEvent("cframework:boostingDeclineMember", function(playerId)
    local source <const> = source
    local missionData <const> = GetBoostingMissionDataByPlayer(source)

    if not missionData then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    if missionData.playerId ~= source then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_OWNER"))
        return
    end

    local memberFound = false

    for k, member in ipairs(missionData.members) do
        if member.playerId == playerId then
            memberFound = true

            if member.status == "party" then
                CleanupMemberFromMission(playerId, missionData.boostId)
                TriggerClientEvent("cframework:updateCurrentBoost", playerId, nil)
            end

            table.remove(missionData.members, k)
            break
        end
    end

    if not memberFound then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_INVALID_MEMBER"))
        return
    end

    for k, v in pairs(missionData.members) do
        TriggerClientEvent("cframework:updateCurrentBoostMembers", v.playerId, {members = missionData.members, isOwner = (v.playerId == missionData.playerId)})
    end

    SetBoostingMissionData(missionData.boostId, missionData)
end)

local requestingRandomContracts = {}

RegisterNetEvent("cframework:boostingRequestAvailableContracts", function()
    local source <const> = source

    updateOwnedContracts(source)
end)

AddEventHandler('playerDropped', function(_)
	local source <const> = source

    if requestingRandomContracts[source] then
        requestingRandomContracts[source] = nil
    end

    if inBoost[source] then
        inBoost[source] = nil
    end
end)

local boostOffers = {}

--Each 30 minutes, generate 3 new random boost offers based on player level, and update all players with the new offers
local function generateContractOffersBasedOnLevel(source)
    local offers = {}

    local playerLevel = ESX.getExperience(source, "boosting") or 0
    local possibleContracts = {}

    for contractId, contractInfo in pairs(boostingData.contracts) do
        if playerLevel >= levels[contractInfo.level] then
            table.insert(possibleContracts, contractId)
        end
    end

    for i = 1, 3 do
        if #possibleContracts == 0 then
            break
        end

        local randomIndex <const> = math.random(1, #possibleContracts)
        local contractId <const> = possibleContracts[randomIndex]

        table.insert(offers, {
            id = contractId,
            info = boostingData.contracts[contractId]
        })

        table.remove(possibleContracts, randomIndex)
    end

    return offers
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30*60000) -- 30 minutes

        for playerId, _ in pairs(requestingRandomContracts) do
            local identifier <const> = ESX.getIdentifier(playerId)
            local offers <const> = generateContractOffersBasedOnLevel(playerId)

            boostOffers[identifier] = offers

            TriggerClientEvent("cframework:updateBoostOffers", playerId, offers)
        end
    end
end)

RegisterNetEvent("cframework:boostingRequestOfferContracts", function()
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    requestingRandomContracts[source] = true

    boostOffers[identifier] = boostOffers[identifier] or generateContractOffersBasedOnLevel(source)

    TriggerClientEvent("cframework:updateBoostOffers", source, boostOffers[identifier])
end)

RegisterNetEvent("cframework:boostingBuyNewOffers", function()
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    if ESX.getBoostCoins(source) < 10 then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_ENOUGH_COINS"))
        return
    end

    ESX.setBoostCoins(source, ESX.getBoostCoins(source) - 10)

    boostOffers[identifier] = generateContractOffersBasedOnLevel(source)

    TriggerClientEvent("cframework:updateBoostOffers", source, boostOffers[identifier])
end)

RegisterNetEvent("cframework:boostingClaimBoostContract", function(selectedContractId)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)
    ownedBoosts[identifier] = ownedBoosts[identifier] or {}

    if boostOffers[identifier] == nil or #boostOffers[identifier] == 0 then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NO_OFFERS_AVAILABLE"))
        return
    end

    local found = false
    for k, offer in ipairs(boostOffers[identifier]) do
        if offer.id == selectedContractId then
            table.remove(boostOffers[identifier], k)
            found = true
            break
        end
    end

    if not found then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_INVALID_OFFER"))
        return
    end

    local contractId <const> = selectedContractId

    if ownedBoosts[identifier][contractId] == nil then
        ownedBoosts[identifier][contractId] = 1

        MySQL.Async.execute('INSERT INTO owned_boosts (identifier, boostId, count) VALUES (@player_id, @contract_id, @amount)', {
            ['@player_id'] = identifier,
            ['@contract_id'] = contractId,
            ['@amount'] = 1
        })
    else
        ownedBoosts[identifier][contractId] = ownedBoosts[identifier][contractId] + 1

        MySQL.Async.execute('UPDATE owned_boosts SET count = count + 1 WHERE identifier = @player_id AND boostId = @contract_id', {
            ['@player_id'] = identifier,
            ['@contract_id'] = contractId
        })
    end

    TriggerClientEvent("cframework:updateBoostOffers", source, boostOffers[identifier])

    updateOwnedContracts(source)
end)

RegisterNetEvent("cframework:boostingRequestLeaderboard", function()
    local source <const> = source
    local playerIdentifier <const> = ESX.getIdentifier(source)

    local leaderboard = {
        total = {},
        perLevel = {}
    }

    local top10Total = MySQL.query.await([[
        SELECT 
            t.identifier,
            COALESCE(CONCAT(u.firstname, ' ', u.lastname), 'Unknown') AS player_name,
            t.total_experience
        FROM (
            SELECT identifier, SUM(count) AS total_experience
            FROM boosting_leaderboard
            GROUP BY identifier
        ) AS t
        LEFT JOIN users u ON u.identifier = t.identifier
        ORDER BY total_experience DESC
        LIMIT 10;
    ]])

    leaderboard.total.top10 = top10Total or {}

    local totalRankQuery = MySQL.single.await([[
        SELECT 
            ranked.rank,
            COALESCE(CONCAT(u.firstname, ' ', u.lastname), 'Unknown') AS player_name,
            ranked.total_experience
        FROM (
            SELECT 
                identifier,
                SUM(count) AS total_experience,
                ROW_NUMBER() OVER (ORDER BY SUM(count) DESC) AS rank
            FROM boosting_leaderboard
            GROUP BY identifier
        ) AS ranked
        LEFT JOIN users u ON ranked.identifier = u.identifier
        WHERE ranked.identifier = ?
    ]], { playerIdentifier })

    leaderboard.total.playerRank = totalRankQuery or {}


    local alllevels = MySQL.query.await("SELECT DISTINCT level FROM boosting_leaderboard ORDER BY level ASC") or {}

    for _, levelRow in pairs(alllevels) do
        local level = levelRow.level

        leaderboard.perLevel[level] = {}

        -- Top 10 for this level
        local lvlTop10 = MySQL.query.await([[
            SELECT 
                b.identifier,
                COALESCE(CONCAT(u.firstname, ' ', u.lastname), 'Unknown') AS player_name,
                b.count
            FROM boosting_leaderboard b
            LEFT JOIN users u ON u.identifier = b.identifier
            WHERE b.level = ?
            ORDER BY b.count DESC
            LIMIT 10;
        ]], { level })

        leaderboard.perLevel[level].top10 = lvlTop10 or {}

        -- Player rank for this level
        local lvlRankQuery = MySQL.single.await([[
            SELECT 
                ranked.rank,
                COALESCE(CONCAT(u.firstname, ' ', u.lastname), 'Unknown') AS player_name,
                ranked.count
            FROM (
                SELECT
                    identifier,
                    count,
                    ROW_NUMBER() OVER (ORDER BY count DESC) AS rank
                FROM boosting_leaderboard
                WHERE level = ?
            ) AS ranked
            LEFT JOIN users u ON u.identifier = ranked.identifier
            WHERE ranked.identifier = ?
        ]], { level, playerIdentifier })

        leaderboard.perLevel[level].playerRank = lvlRankQuery or {}
    end


    TriggerClientEvent("cframework:updateBoostingLeaderboard", source, leaderboard)
end)

