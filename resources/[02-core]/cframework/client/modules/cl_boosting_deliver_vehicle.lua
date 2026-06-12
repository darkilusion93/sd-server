

local boostingData = LoadBoosting()
local dropBlip = nil

RegisterNetEvent("cframework:boostingBeginDeliverVehicle", function(deliverCoords, missionType, pedModel)
    local dropOffBlip <const> = AddBlipForCoord(deliverCoords.x, deliverCoords.y, deliverCoords.z)
    SetBlipSprite(dropOffBlip, boostingData.deliverVehicleBlipSprite) -- Car
    SetBlipColour(dropOffBlip, boostingData.deliverVehicleBlipColor) -- Red
    SetBlipScale(dropOffBlip, boostingData.deliverVehicleBlipScale)
    SetBlipRoute(dropOffBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(T("BOOSTING_DELIVER_VEHICLE"))
    EndTextCommandSetBlipName(dropOffBlip)

    dropBlip = dropOffBlip

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_DELIVER_VEHICLE"))

    if pedModel ~= nil then
        exports.ft_libs:AddPed("boosting_deliverped", {model = pedModel, x = deliverCoords.x, y = deliverCoords.y, z = deliverCoords.z, w = deliverCoords.w})
    end
end)

RegisterNetEvent("cframework:boostingFinishDeliverVehicleBoost", function(pedModel)
    if dropBlip ~= nil and DoesBlipExist(dropBlip) then
        RemoveBlip(dropBlip)
    end

    if pedModel ~= nil then
        exports.ft_libs:RemovePed("boosting_deliverped")
    end

    dropBlip = nil
end)