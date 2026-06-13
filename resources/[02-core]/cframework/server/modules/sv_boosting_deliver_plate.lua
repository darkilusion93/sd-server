

local boostingData = LoadBoosting()
local waitingForPlateDeliver = {}

RegisterMissionSyncCallback("deliver_plate", function(playerId, boostId, missionData)
    if missionData.deliverLocation then
        TriggerClientEvent("cframework:boostingBeginDeliverPlate", playerId, missionData.deliverLocation, missionData.missionType, missionData.pedModel, boostId)
    end
end)

RegisterMissionCleanupCallback("deliver_plate", function(playerId, boostId, missionData)
    TriggerClientEvent("cframework:boostingCompleteDeliverPlate", playerId, missionData.pedModel)
end)

RegisterBoostMission("deliver_plate", function(contractId, boostId)
    local missionData = GetBoostingMissionData(boostId)
    local contractInfo <const> = boostingData.contracts[contractId]
    local source <const> = missionData.playerId
    local playerPed <const> = GetPlayerPed(source)

    local randomDeliverIndex <const> = math.random(1, #boostingData.locations[contractInfo.deliverLocation])
    local deliverLocation <const> = boostingData.locations[contractInfo.deliverLocation][randomDeliverIndex]

    waitingForPlateDeliver[boostId] = true

    missionData.deliverLocation = deliverLocation
    missionData.missionType = contractInfo.missionType
    missionData.pedModel = contractInfo.pedModel
    SetBoostingMissionData(boostId, missionData)

    TriggerClientEventForBoostParty("cframework:boostingBeginDeliverPlate", boostId, deliverLocation, contractInfo.missionType, contractInfo.pedModel, boostId)

    while waitingForPlateDeliver[boostId] or GetDistanceOfClosestBoostMemberParty(boostId, deliverLocation.xyz) > 10.0 do
        if not DoesEntityExist(playerPed) then
            return false
        end

        if os.time() - missionData.startTime > contractInfo.timer then
            TriggerClientEventForBoostParty("cframework:showBoostingNotification", boostId, T("BOOSTING_TIME_EXPIRED_DELIVERING_PLATE"))
            return false
        end

        Citizen.Wait(1000)
    end

    Citizen.Wait(5000)
    TriggerClientEventForBoostParty("cframework:boostingCompleteDeliverPlate", boostId, contractInfo.pedModel)

    return true
end)

RegisterNetEvent("cframework:boostingPlateDelivered", function(boostId)
    local source <const> = source
    local missionData = GetBoostingMissionData(boostId)

    if not missionData then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    -- O caller tem de ser membro ativo desta boost (mata boostId forjado / entrega por terceiros).
    local isMember = false
    for _, member in ipairs(missionData.members) do
        if member.playerId == source and (member.status == "party" or member.status == "owner") then
            isMember = true
            break
        end
    end

    if not isMember then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    -- Tem de estar no ponto de entrega (anti entrega remota).
    if not missionData.deliverLocation or #(GetEntityCoords(GetPlayerPed(source)) - missionData.deliverLocation.xyz) > 10.0 then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_MANAGING_BOOST"))
        return
    end

    local inventory <const> = ESX.getInvContainer(source)
    local item <const> = inventory.getItemByMetadata("label", missionData.vehiclePlate)

    if item == nil then
        TriggerClientEvent("cframework:showBoostingNotification", source, T("BOOSTING_NOT_HAVE_PLATE"))
        return
    end

    if waitingForPlateDeliver[boostId] then
        waitingForPlateDeliver[boostId] = nil
        inventory.removeItem(item.name, 1, item.slot)

        TriggerClientEvent("cframework:boostingDeliveredPlate", source)
    end
end)