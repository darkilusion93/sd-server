

local rubberData = LoadRubber()
local extractionLocations <const> = rubberData.extractionLocations

local playersExtracting = {}

local function getExtractedItem(player)
    local source <const> = player
    local inventory <const> = ESX.getInvContainer(source)

    if ESX.getJob(source).name ~= rubberData.jobName then
        return
    end

    if not ESX.playerInsideLocation(source, extractionLocations, 10.0) then
        return
    end

    if not ESX.inService(source) then
        return
    end

    if not inventory.addItem(rubberData.extraction.item, rubberData.extraction.count) then
        TriggerClientEvent("cframework:rubberFail", source)
    end
end

RegisterNetEvent("cframework:startExtraction", function()
    local source <const> = source

    if ESX.getJob(source).name ~= rubberData.jobName then
        return
    end

    if not ESX.playerInsideLocation(source, extractionLocations, 10.0) then
        return
    end

    if not ESX.inService(source) then
        return
    end

    playersExtracting[source] = true
end)

RegisterNetEvent("cframework:stopExtraction", function()
    local source <const> = source

    playersExtracting[source] = nil
end)

AddEventHandler("playerDropped", function()
    local source <const> = source

    playersExtracting[source] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(rubberData.extraction.time)
        for player, _ in pairs(playersExtracting) do
            if playersExtracting[player] then
                getExtractedItem(player)
            end
        end
    end
end)
