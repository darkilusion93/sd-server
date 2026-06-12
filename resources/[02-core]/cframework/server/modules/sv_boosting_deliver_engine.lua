

local boostingData = LoadBoosting()
local waitingForEngineDeliver = {}

RegisterMissionSyncCallback("deliver_engine", function(playerId, boostId, missionData)
    if missionData.deliverLocation then
        TriggerClientEvent("cframework:boostingBeginDeliverEngine", playerId, missionData.deliverLocation, missionData.missionType, missionData.pedModel, boostId)
    end
end)

RegisterMissionCleanupCallback("deliver_engine", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingCompleteDeliverEngine", playerId, missionData.pedModel)
end)

RegisterBoostMission("deliver_engine", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomDeliverIndex <const> = math.random(1, #boostingData.locations[contractInfo.deliverLocation])
    local deliverLocation <const> = boostingData.locations[contractInfo.deliverLocation][randomDeliverIndex]

    missionData.deliverLocation = deliverLocation
    missionData.missionType = contractInfo.missionType
    missionData.pedModel = contractInfo.pedModel
    SetBoostingMissionData(boostId, missionData)

    waitingForEngineDeliver[boostId] = true

    TriggerClientEventForBoostParty("cframework:boostingBeginDeliverEngine", boostId, deliverLocation, contractInfo.missionType, contractInfo.pedModel, boostId)

    while waitingForEngineDeliver[boostId] or GetDistanceOfClosestBoostMemberParty(boostId, deliverLocation.xyz) > 10.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_ENGINE"))
            return false
        end

        Citizen.Wait(1000)
    end

    Citizen.Wait(5000)
    TriggerClientEventForBoostParty("cframework:boostingCompleteDeliverEngine", boostId, contractInfo.pedModel)

    return true
end)

RegisterNetEvent("cframework:boostingEngineDelivered", function(boostId)
    local source <const> = source
    local missionData = GetBoostingMissionData(boostId)
    local inventory <const> = ESX.getInvContainer(source)

    if not missionData then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    if not inventory.canRemoveItem("car_motor", 1) then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_HAVE_ENGINE"))
        return
    end

    if waitingForEngineDeliver[source] then
        waitingForEngineDeliver[source] = nil

        inventory.removeItem("car_motor", 1)

        TriggerClientEvent("cframework:boostingDeliveredEngine", source)
    end
end)