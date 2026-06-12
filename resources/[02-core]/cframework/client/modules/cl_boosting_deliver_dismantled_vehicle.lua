

local boostingData = LoadBoosting()
local dropBlip = nil

RegisterNetEvent("cframework:boostingBeginDeliverDismantledVehicle", function(deliverCoords, missionType, pedModel)
    local dropOffBlip <const> = AddBlipForCoord(deliverCoords.x, deliverCoords.y, deliverCoords.z)
    SetBlipSprite(dropOffBlip, boostingData.dismantleVehicleBlipSprite) -- Car
    SetBlipColour(dropOffBlip, boostingData.dismantleVehicleBlipColor) -- Red
    SetBlipScale(dropOffBlip, boostingData.dismantleVehicleBlipScale)
    SetBlipRoute(dropOffBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(T("BOOSTING_DELIVER_DISMANTLED_LOCATION"))
    EndTextCommandSetBlipName(dropOffBlip)

    dropBlip = dropOffBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_DELIVER_DISMANTLED_VEHICLE"))

    if pedModel ~= nil then
        exports.ft_libs:AddPed("boosting_deliverdismantledped", {model = pedModel, x = deliverCoords.x, y = deliverCoords.y, z = deliverCoords.z, w = deliverCoords.w})
    end
end)

RegisterNetEvent("cframework:boostingFinishDeliverDismantledVehicleBoost", function(pedModel)
    if dropBlip ~= nil and DoesBlipExist(dropBlip) then
        RemoveBlip(dropBlip)
    end

    if pedModel ~= nil then
        exports.ft_libs:RemovePed("boosting_deliverdismantledped")
    end

    dropBlip = nil
end)