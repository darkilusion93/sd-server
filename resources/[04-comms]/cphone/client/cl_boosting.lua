-- Title	:	cl_boosting.lua
-- Author	:	Gonçalo Costa
-- Started	:	29/11/25

local function rewardsString(rewards)
    local rewardsLabel = ""

    if rewards == nil or (rewards.vehicle == nil and rewards.items == nil and rewards.coins == nil) then
        return "N/A"
    end

    if rewards.items then
        for k, v in ipairs(rewards.items) do
            if v.name == "cash" or v.name == "black_money" then
                rewardsLabel = rewardsLabel .. (rewardsLabel ~= "" and " e " or "") .. ESX.formatAsCurrency(v.minCount) .. " a " .. ESX.formatAsCurrency(v.maxCount)
            else
                rewardsLabel = rewardsLabel .. (rewardsLabel ~= "" and " e " or "") .. tostring(v.count) .. "x " .. ESX.GetItemLabel(v.name)
            end
        end
    end

    if rewards.coins then
        rewardsLabel = rewardsLabel .. (rewardsLabel ~= "" and " e " or "") .. tostring(rewards.coins) .. " coins"
    end

    if rewards.vehicle then
        rewardsLabel = rewardsLabel .. (rewardsLabel ~= "" and " e " or "") .. "Veículo"
    end

    return rewardsLabel
end

RegisterNetEvent("cframework:updateCurrentBoost", function(data)
    if data == nil then
        SendNUIMessage({
            action = "clearCurrentBoost"
        })
        return
    end

    local contractInfo = ESX.GetContractInfo(data.contractId)
    local missionInfo = ESX.GetMissionInfo(contractInfo.missionType)
    local rewardsLabel = rewardsString(contractInfo.rewards)

    SendNUIMessage({
        action = "updateCurrentBoost",
        contractId = data.contractId,
        boostId = data.boostId,
        timer = data.timer,
        missionLabel = missionInfo.label,
        rewards = contractInfo.rewards,
        missionType = contractInfo.missionType,
        vehicleTypeLabel = contractInfo.vehicleTypeLabel,
        memberName = data.memberName,
        rewardsLabel = rewardsLabel
    })
end)

RegisterNUICallback("joinBoostingContract", function(data, cb)
    TriggerServerEvent("cframework:boostingJoinBoost", tonumber(data.contractId))

    cb("ok")
end)

RegisterNetEvent("cframework:updateCurrentBoostMembers", function(data)
    SendNUIMessage({
        action = "updateCurrentBoostMembers",
        members = data.members,
        isOwner = data.isOwner
    })
end)

RegisterNUICallback("acceptBoostMember", function(data, cb)
    TriggerServerEvent("cframework:boostingAcceptMember", data.memberId)

    cb("ok")
end)

RegisterNUICallback("declineBoostMember", function(data, cb)
    TriggerServerEvent("cframework:boostingDeclineMember",  data.memberId)

    cb("ok")
end)

RegisterNetEvent("cframework:addExperience", function(type, amount)
    if type ~= "boosting" then return end

    Citizen.Wait(1000)

    SendNUIMessage({
        action = "updateBoostLvl",
        level = ESX.GetCurrentExperienceLevel("boosting")
    })
end)

RegisterNUICallback("boosting_getcontracts", function(data, cb)
    TriggerServerEvent("cframework:boostingRequestAvailableContracts")
    TriggerServerEvent("cframework:boostingRequestOfferContracts")

    SendNUIMessage({
        action = "updateBoostLvl",
        level = ESX.GetCurrentExperienceLevel("boosting")
    })

    cb("ok")
end)

RegisterNUICallback("startBoostContract", function(data, cb)
    TriggerServerEvent("cframework:boostingStartMission", data.contractId)

    cb("ok")
end)

RegisterNUICallback("claimBoostContract", function(data, cb)
    TriggerServerEvent("cframework:boostingClaimBoostContract", data.contractId)

    cb("ok")
end)

RegisterNUICallback("buyBoostingOffers", function(data, cb)
    TriggerServerEvent("cframework:boostingBuyNewOffers")

    cb("ok")
end)

RegisterNetEvent("cframework:updateAvailableContracts", function(contracts)
    for k, contract in ipairs(contracts) do
        local contractInfo = ESX.GetContractInfo(contract.id)
        local missionInfo = ESX.GetMissionInfo(contractInfo.missionType)

        contracts[k].rewardsLabel = rewardsString(contractInfo.rewards)
        contracts[k].requirementsLabel = rewardsString(contractInfo.requires)
        contracts[k].missionLabel = missionInfo.label
        contracts[k].vehicleTypeLabel = contractInfo.vehicleTypeLabel
        contracts[k].info = contractInfo
    end

    SendNUIMessage({
        action = "updateAvailableContracts",
        contracts = contracts
    })
end)

RegisterNetEvent("cframework:updateBoostOffers", function(contracts)
    for k, contract in ipairs(contracts) do
        local contractInfo = ESX.GetContractInfo(contract.id)
        local missionInfo = ESX.GetMissionInfo(contractInfo.missionType)

        contracts[k].rewardsLabel = rewardsString(contractInfo.rewards)
        contracts[k].requirementsLabel = rewardsString(contractInfo.requires)
        contracts[k].missionLabel = missionInfo.label
        contracts[k].vehicleTypeLabel = contractInfo.vehicleTypeLabel
        contracts[k].info = contractInfo
    end

    SendNUIMessage({
        action = "updateAvailableOffers",
        contracts = contracts
    })
end)

RegisterNUICallback("boosting_getleaderboard", function(data, cb)
    TriggerServerEvent("cframework:boostingRequestLeaderboard")

    cb("ok")
end)

RegisterNetEvent("cframework:updateBoostingLeaderboard", function(leaderboards)
    SendNUIMessage({
        action = "updateLeaderboard",
        leaderboards = leaderboards
    })
end)


RegisterNetEvent("cframework:showBoostingNotification", function(message)
    TriggerEvent("cphone:showPhoneNotification", "Boosting", message, "fa-solid fa-car", "#778DA9")
end)