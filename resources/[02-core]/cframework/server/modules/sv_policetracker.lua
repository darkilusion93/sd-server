local trackedPlayers = {}
local adminTrackedPlayers = {}
local playersToUpdate = {}
local bigDataTrackers = {}

local function updateAddPoliceTrackerMembers(source, isCriminal, playerName)
    for k,_ in pairs(playersToUpdate) do
        TriggerClientEvent("cframework:addPoliceTrackerMember", k, source, isCriminal, playerName)
    end
end

local function updateRemovePoliceTrackerMembers(source)
    for k,_ in pairs(playersToUpdate) do
        TriggerClientEvent("cframework:removePoliceTrackerMember", k, source)
    end
end

local function forceCoordsPoliceTrackerMembers(source, coords)
    for k,_ in pairs(playersToUpdate) do
        TriggerClientEvent("cframework:forceCoordsPoliceTrackerMembers", k, source, coords)
    end
end

AddEventHandler("cframework:playerSetOverrideCoords", function(source, coords)
    if trackedPlayers[source] == nil then
        return
    end

    forceCoordsPoliceTrackerMembers(source, coords)
end)

AddEventHandler("esx:playerLoaded", function(source, xPlayer)
    local job <const> = xPlayer.job.name
    local playerName <const> = xPlayer.getFullname()
    local inventory <const> = xPlayer.getInvContainer()
    local hasBracelet <const> = inventory.getItemAmount("electronic_bracelet") > 0

    if job == "police" then
        local isTargetInRadio <const> = exports["mumble-voip"]:isValidPlayer(source).radio

        if isTargetInRadio == 0 then return end

        trackedPlayers[source] = {serverId = source, isCriminal = false, name = playerName}

        updateAddPoliceTrackerMembers(source, false, playerName)

        playersToUpdate[source] = true
        TriggerClientEvent("cframework:loadPoliceTracker", source, trackedPlayers)
    end

    if hasBracelet and job ~= "police" then
        trackedPlayers[source] = {serverId = source, isCriminal = true, name = playerName}

        updateAddPoliceTrackerMembers(source, true, playerName)
    end
end)

AddEventHandler('esx:setJob', function(source, job, lastJob)
    if job.name == "police" then
        local isTargetInRadio <const> = exports["mumble-voip"]:isValidPlayer(source).radio

        if isTargetInRadio == 0 then return end

        local playerName <const> = ESX.getFullname(source)

        if ESX.inAdmin(source) then
            adminTrackedPlayers[source] = {serverId = source, isCriminal = false, name = playerName}
            playersToUpdate[source] = true
            TriggerClientEvent("cframework:loadPoliceTracker", source, trackedPlayers)
            return
        end

        trackedPlayers[source] = {serverId = source, isCriminal = false, name = playerName}
        updateAddPoliceTrackerMembers(source, false, playerName)
        playersToUpdate[source] = true
        TriggerClientEvent("cframework:loadPoliceTracker", source, trackedPlayers)
    elseif lastJob.name == "police" then
        trackedPlayers[source] = nil
        playersToUpdate[source] = nil
        if ESX.inAdmin(source) then
            adminTrackedPlayers[source] = nil
        end
        TriggerClientEvent("cframework:unloadPoliceTracker", source)
        updateRemovePoliceTrackerMembers(source)
    end
end)

RegisterNetEvent('pma-voice:setPlayerRadio', function(radioChannel)
	local source <const> = source
    local job <const> = ESX.getJob(source).name

    if job ~= "police" then return end

    if radioChannel == 0 then
        trackedPlayers[source] = nil
        playersToUpdate[source] = nil
        if ESX.inAdmin(source) then
            adminTrackedPlayers[source] = nil
        end
        TriggerClientEvent("cframework:unloadPoliceTracker", source)
        updateRemovePoliceTrackerMembers(source)
        return
    end

    local playerName <const> = ESX.getFullname(source)

    if ESX.inAdmin(source) then
        adminTrackedPlayers[source] = {serverId = source, isCriminal = false, name = playerName}
        playersToUpdate[source] = true
        TriggerClientEvent("cframework:loadPoliceTracker", source, trackedPlayers)
        return
    end

    trackedPlayers[source] = {serverId = source, isCriminal = false, name = playerName}

    updateAddPoliceTrackerMembers(source, false, playerName)

    playersToUpdate[source] = true
    TriggerClientEvent("cframework:loadPoliceTracker", source, trackedPlayers)
end)

AddEventHandler("playerDropped", function()
    local source <const> = source

    if playersToUpdate[source] then
        playersToUpdate[source] = nil
    end

    if adminTrackedPlayers[source] then
        adminTrackedPlayers[source] = nil
    end

    if trackedPlayers[source] then
        trackedPlayers[source] = nil

        updateRemovePoliceTrackerMembers(source)
    end
end)

AddEventHandler("esx:onAddInventoryItem", function(source, item)
    if item.name ~= "electronic_bracelet" then return end
    if trackedPlayers[source] ~= nil then return end

    local inventory <const> = ESX.getInvContainer(source)
    local hasBracelet <const> = inventory.getItemAmount("electronic_bracelet") > 0

    if not hasBracelet then return end

    local job <const> = ESX.getJob(source).name
    local playerName <const> = ESX.getFullname(source)

    if job == "police" then return end

    if ESX.inAdmin(source) then
        adminTrackedPlayers[source] = {serverId = source, isCriminal = true, name = playerName}
        return
    end

    trackedPlayers[source] = {serverId = source, isCriminal = true, name = playerName}
    updateAddPoliceTrackerMembers(source, true)
end)

AddEventHandler("esx:onRemoveInventoryItem", function(source, item)
    if item.name ~= "electronic_bracelet" then return end
    if trackedPlayers[source] == nil then return end

    local inventory <const> = ESX.getInvContainer(source)
    local hasBracelet <const> = inventory.getItemAmount("electronic_bracelet") > 0

    if hasBracelet then return end

    adminTrackedPlayers[source] = nil
    trackedPlayers[source] = nil
    updateRemovePoliceTrackerMembers(source)
end)

AddEventHandler("cframework:leaveAdmin", function(source)
    if adminTrackedPlayers[source] ~= nil then
        trackedPlayers[source] = {serverId = source, isCriminal = adminTrackedPlayers[source].isCriminal, name = adminTrackedPlayers[source].name}
        playersToUpdate[source] = true
        updateAddPoliceTrackerMembers(source, adminTrackedPlayers[source].isCriminal, adminTrackedPlayers[source].name)
        adminTrackedPlayers[source] = nil
    end
end)

AddEventHandler("cframework:enterAdmin", function(source)
    if trackedPlayers[source] ~= nil then
        adminTrackedPlayers[source] = {serverId = source, isCriminal = trackedPlayers[source].isCriminal, name = trackedPlayers[source].name}
        trackedPlayers[source] = nil
        playersToUpdate[source] = nil
        updateRemovePoliceTrackerMembers(source)
    end
end)

RegisterNetEvent("cframework:bigDataPoliceTracker", function(enable)
    local source <const> = source

    if enable then
        bigDataTrackers[source] = true
    else
        bigDataTrackers[source] = nil
    end
end)

RegisterNetEvent("cframework:putElectronicBracelet", function(target)
    local source <const> = source
    local job <const> = ESX.getJob(source).name
    local inventory <const> = ESX.getInvContainer(target)
    local hasBracelet <const> = inventory.getItemAmount("electronic_bracelet") > 0

    if hasBracelet then return end
    if job ~= "police" then return end

    if target == -1 then return end
    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) >= 5.0 then return end

    inventory.addItem("electronic_bracelet", 1)
end)

RegisterNetEvent("cframework:takeElectronicBracelet", function(target)
    local source <const> = source
    local job <const> = ESX.getJob(source).name
    local inventory <const> = ESX.getInvContainer(target)
    local hasBracelet <const> = inventory.getItemAmount("electronic_bracelet") > 0

    if not hasBracelet then return end
    if job ~= "police" then return end

    if target == -1 then return end
    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) >= 5.0 then return end

    inventory.removeItem("electronic_bracelet", 1)
end)

Citizen.CreateThread(function()
    while true do
        local auxTrackingPlayers = {}

        for k,_ in pairs(trackedPlayers) do
            auxTrackingPlayers[k] = {}
            auxTrackingPlayers[k].serverId = trackedPlayers[k].serverId
            auxTrackingPlayers[k].isCriminal = trackedPlayers[k].isCriminal
            auxTrackingPlayers[k].name = trackedPlayers[k].name
            auxTrackingPlayers[k].pos = ESX.getOverrideCoords(k) or GetEntityCoords(GetPlayerPed(k))
        end

        for player,_ in pairs(bigDataTrackers) do
            TriggerClientEvent("cframework:sendBigDataPoliceTracker", player, auxTrackingPlayers)
        end

        Citizen.Wait(1000)
    end
end)