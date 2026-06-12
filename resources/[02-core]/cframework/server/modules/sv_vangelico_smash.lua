

local heist = LoadVangelicoHeist()
local glassCabinets = heist.glassCabinets
local isHeistRunning = false
local CurrentCops = 0

local function resetAllGlassCabinets()
    for i = 1, #glassCabinets do
        glassCabinets[i].robbed = false
    end

    for _, player in ipairs(ESX.GetPlayersInArea(glassCabinets[1].coords, 75.0)) do
        TriggerClientEvent("cframework:rebuildAllCabinets", player)
    end
end

local function startCooldownRobbery()
    Citizen.CreateThread(function()
        Citizen.Wait(heist.robberyCooldown * 1000)
        isHeistRunning = false

        resetAllGlassCabinets()
    end)
end

local function startVangelicoRobbery(source, coords)
    if CurrentCops < heist.minCops then
        TriggerClientEvent("esx:showNotification", source, T("VANGELICO_ROBBERY_NOT_ENOUGH_COPS"), "error")
        return false
    end

    if isHeistRunning then
        TriggerClientEvent("esx:showNotification", source, T("VANGELICO_ROBBERY_ALREADY_RUNNING"), "error")
        return false
    end

    isHeistRunning = true
    startCooldownRobbery()

    TriggerClientEvent('esx_atmRobbery:outlawNotify', -1, T("VANGELICO_ROBBERY_STARTED"))
    TriggerClientEvent('esx_atmRobbery:OutlawBlipSettings', -1, coords)

    --ESX.logRobberyData(source, "ASSALTAR", CurrentCops, "Joalharia")

    return true
end

AddEventHandler('esx:onlineCops', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent("cframework:smashVangelicoCabinet", function(cabinetIndex)
    local source <const> = source
    local weapon = GetCurrentPedWeapon(GetPlayerPed(source))
    local weapInfo, weapName = ESX.GetWeaponFromHash(weapon)

    if not isHeistRunning then
        return
    end

    if glassCabinets[cabinetIndex].robbed then
        return
    end

    if not ESX.playerInsideLocation(source, {glassCabinets[cabinetIndex].coords}, 10.0) then
        return
    end

    if weapInfo == nil then
        return
    end

    if not heist.validWeapons[weapName] then
        return
    end

    for _, player in ipairs(ESX.GetPlayersInArea(glassCabinets[cabinetIndex].coords, 75.0)) do
        TriggerClientEvent("cframework:smashVangelicoCabinet", player, cabinetIndex)
    end
end)

RegisterNetEvent("cframework:prepareSmashVangelicoCabinet", function(cabinetIndex)
    local source <const> = source
    local weapon = GetCurrentPedWeapon(GetPlayerPed(source))
    local weapInfo, weapName = ESX.GetWeaponFromHash(weapon)

    if glassCabinets[cabinetIndex].robbed then
        TriggerClientEvent("esx:showNotification", source, T("VANGELICO_EMPTY_VITRINE"), "error")
        return
    end

    if not ESX.playerInsideLocation(source, {glassCabinets[cabinetIndex].coords}, 10.0) then
        return
    end

    if weapInfo == nil then
        return
    end

    if not heist.validWeapons[weapName] then
        return
    end

    if not isHeistRunning then
        local started = startVangelicoRobbery(source, glassCabinets[cabinetIndex].coords)

        if not started then
            return
        end
    end

    for _, player in ipairs(ESX.GetPlayersInArea(glassCabinets[cabinetIndex].coords, 75.0)) do
        TriggerClientEvent("cframework:prepareSmashVangelicoCabinet", player, cabinetIndex)
    end

    TriggerClientEvent("cframework:smashJelwryAndRob", source, cabinetIndex)
end)

RegisterNetEvent("cframework:receiveJewelryCabinet", function(cabinetIndex)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local weapon = GetCurrentPedWeapon(GetPlayerPed(source))
    local weapInfo, weapName = ESX.GetWeaponFromHash(weapon)

    if not isHeistRunning then
        return
    end

    if not ESX.playerInsideLocation(source, {glassCabinets[cabinetIndex].coords}, 10.0) then
        return
    end

    if glassCabinets[cabinetIndex].robbed then
        return
    end

    if weapInfo == nil then
        return
    end

    if not heist.validWeapons[weapName] then
        return
    end

    glassCabinets[cabinetIndex].robbed = true

    inventory.addItem("jewels", math.random(18, 22))
end)

RegisterNetEvent('esx:playerLoaded', function(_source)
    local source <const> = _source

    if not isHeistRunning then
        return
    end

    TriggerClientEvent("cframework:loadVangelicoHeist", source, glassCabinets)
end)