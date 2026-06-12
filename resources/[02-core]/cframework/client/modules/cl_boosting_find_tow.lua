

local boostingData = LoadBoosting()
local zoneBlip = nil

RegisterNetEvent("cframework:boostingBeginFindTow", function(coords, missionType)
    local missionData <const> = boostingData.missions[missionType]
    local searchZoneBlip <const> = AddBlipForRadius(coords.x, coords.y, coords.z, boostingData.findTowBlipRadius)

    SetBlipColour(searchZoneBlip, boostingData.findTowBlipColor) -- Red
    SetBlipAlpha(searchZoneBlip, 128)

    zoneBlip = searchZoneBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_TOW_LOCATION"))
end)

RegisterNetEvent("cframework:boostingFinishFindTow", function()
    if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
        RemoveBlip(zoneBlip)
    end

    zoneBlip = nil
end)