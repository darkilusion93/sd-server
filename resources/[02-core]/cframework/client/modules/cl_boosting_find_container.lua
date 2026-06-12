

local boostingData = LoadBoosting()
local zoneBlip = nil

RegisterNetEvent("cframework:boostingBeginFindContainer", function(coords, missionType)
    local searchZoneBlip <const> = AddBlipForRadius(coords.x, coords.y, coords.z, boostingData.findContainerBlipRadius)

    SetBlipColour(searchZoneBlip, boostingData.findContainerBlipColor) -- Red
    SetBlipAlpha(searchZoneBlip, 128)

    zoneBlip = searchZoneBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_CONTAINER_LOCATION"))
end)

RegisterNetEvent("cframework:boostingFinishFindContainer", function()
    if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
        RemoveBlip(zoneBlip)
    end

    zoneBlip = nil
end)