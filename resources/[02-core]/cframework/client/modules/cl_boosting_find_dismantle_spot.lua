

local boostingData = LoadBoosting()
local zoneBlip = nil

RegisterNetEvent("cframework:boostingBeginFindDismantleSpot", function(coords, missionType)
    local dropOffBlip <const> = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(dropOffBlip, boostingData.findDismantleSpotBlipSprite) -- Car
    SetBlipColour(dropOffBlip, boostingData.findDismantleSpotBlipColor) -- Red
    SetBlipScale(dropOffBlip, boostingData.findDismantleSpotBlipScale)
    SetBlipRoute(dropOffBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(T("BOOSTING_DISMANTLE_ZONE"))
    EndTextCommandSetBlipName(dropOffBlip)

    zoneBlip = dropOffBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_DISMANTLE_ZONE"))
end)

RegisterNetEvent("cframework:boostingFinishFindDismantleSpot", function()
    if zoneBlip ~= nil and DoesBlipExist(zoneBlip) then
        RemoveBlip(zoneBlip)
    end

    zoneBlip = nil
end)