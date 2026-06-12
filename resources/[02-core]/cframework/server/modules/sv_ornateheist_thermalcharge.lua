

local heist = LoadOrnateHeist()
local thermalChargeDoors = heist.thermalChargeDoors
local playerUsingThermalCharge = {}
local CurrentCops = 0
local robberyInProgress = false
local doorsBroken = {}

function IsOrnateHeistRobberyActive()
    return robberyInProgress
end

AddEventHandler('esx:onlineCops', function(amount)
    CurrentCops = amount
end)

RPC.register("cframework:spawnOrnateheistBag", function()
    local source <const> = source
    local coords <const> = GetEntityCoords(GetPlayerPed(source))
    local bag <const> = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), coords.x, coords.y, coords.z - 10.0, true, true, false)

    local curTime <const> = os.time()

    while not DoesEntityExist(bag) do
        Citizen.Wait(20)

        if os.time() - curTime > 20 then return nil end
    end

    return NetworkGetNetworkIdFromEntity(bag)
end)

RPC.register("cframework:spawnOrnateheistThermalCharge", function()
    local source <const> = source
    local playerUsing <const> = playerUsingThermalCharge[source]

    if not playerUsing then return end

    local coords <const> = GetEntityCoords(GetPlayerPed(source))
    local thermalCharge <const> = CreateObject(GetHashKey("hei_prop_heist_thermite"), coords.x, coords.y, coords.z + 0.2, true, true, false)

    local curTime <const> = os.time()

    while not DoesEntityExist(thermalCharge) do
        Citizen.Wait(20)

        if os.time() - curTime > 20 then return nil end
    end

    return NetworkGetNetworkIdFromEntity(thermalCharge)
end)

RegisterNetEvent("cframework:replaceThermalChargeDoorClosePlayers", function(currentplant)
    local source <const> = source
    local door <const> = thermalChargeDoors[currentplant]
    local playerUsing <const> = playerUsingThermalCharge[source]

    if not playerUsing then return end
    if door == nil then return end

    for _, player in ipairs(ESX.GetPlayersInArea(door.loc.xyz, 75.0)) do
        TriggerClientEvent("cframework:replaceThermalChargeDoor", player, currentplant, false)
    end

    playerUsingThermalCharge[source] = nil
end)

RegisterNetEvent("cframework:playPtfxThermiteOnClosePlayers", function(currentplant)
    local source <const> = source
    local door <const> = thermalChargeDoors[currentplant]
    local playerUsing <const> = playerUsingThermalCharge[source]

    if not playerUsing then return end
    if door == nil then return end

    for _, player in ipairs(ESX.GetPlayersInArea(door.loc.xyz, 75.0)) do
        TriggerClientEvent("cframework:playPtfxThermite", player, currentplant)
    end
end)

function ResetOrnateHeistThermalChargeDoors()
    doorsBroken = {}

    for plant, door in pairs(thermalChargeDoors) do
        for _, player in ipairs(ESX.GetPlayersInArea(door.loc.xyz, 75.0)) do
            TriggerClientEvent("cframework:replaceThermalChargeDoor", player, plant, true)
        end

        local doorId <const> = ESX.GetDoorIdFromName(door.doorName)

        if doorId ~= nil then
            TriggerEvent("gdoors:script-change-lock-state", doorId, true)
        end
    end
end

local function startCooldownRobbery()
    Citizen.CreateThread(function()
        Citizen.Wait(heist.robberyCooldown * 1000)
        robberyInProgress = false

        ResetOrnateHeistHackedDoors()
        ResetOrnateHeistThermalChargeDoors()
        DeleteOrnateHeistCashCarts()
    end)
end

local function tryToUseThermalCharge(inventory, slot, source, plant, door)
    if doorsBroken[plant] ~= nil then
        return
    end

    if plant == "main" then
        if CurrentCops < heist.minCops then
            TriggerClientEvent("esx:showNotification", source, T("ORNATE_HEIST_NOT_ENOUGH_COPS"), "error")
            return
        end

        if robberyInProgress then
            TriggerClientEvent("esx:showNotification", source, T("ORNATE_HEIST_ALREADY_RUNNING"), "error")
            return
        end

        robberyInProgress = true
        SpawnOrnateHeistCashCarts()
        startCooldownRobbery()

        TriggerClientEvent('esx_atmRobbery:outlawNotify', -1, T("ORNATE_HEIST_STARTED"))
        TriggerClientEvent('esx_atmRobbery:OutlawBlipSettings', -1, door.loc.xyz)

        --ESX.logRobberyData(source, "ASSALTAR", CurrentCops, "Banco Principal")
    else
        local inRobbery <const> = IsOrnateHeistRobberyActive()

        if not inRobbery then
            return
        end
    end

    doorsBroken[plant] = true

    TriggerClientEvent("cframework:useThermalCharge", source, plant)
    inventory.removeItem("thermal_charge", 1, slot)

    Citizen.CreateThread(function()
        Citizen.Wait(17500)
        local doorId <const> = ESX.GetDoorIdFromName(door.doorName)

        if doorId == nil then return end

        TriggerEvent("gdoors:script-change-lock-state", doorId, false)
    end)
end

ESX.RegisterUsableItem("thermal_charge", function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local playerCoords <const> = GetEntityCoords(GetPlayerPed(source))

    for plant, door in pairs(thermalChargeDoors) do
        if #(playerCoords - door.loc.xyz) < 2.0 then
            playerUsingThermalCharge[source] = true
            tryToUseThermalCharge(inventory, slot, source, plant, door)
            break
        end
    end
end)
