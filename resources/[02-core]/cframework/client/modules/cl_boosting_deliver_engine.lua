

local boostingData = LoadBoosting()
local dropBlip = nil
local isDeliveringEngine = false

RegisterNetEvent("cframework:boostingBeginDeliverEngine", function(deliverCoords, missionType, pedModel, boostId)
    local dropOffBlip <const> = AddBlipForCoord(deliverCoords.x, deliverCoords.y, deliverCoords.z)
    SetBlipSprite(dropOffBlip, boostingData.deliverEngineBlipSprite) -- Car
    SetBlipColour(dropOffBlip, boostingData.deliverEngineBlipColor) -- Red
    SetBlipScale(dropOffBlip, boostingData.deliverEngineBlipScale)
    SetBlipRoute(dropOffBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(T("BOOSTING_DELIVER_ENGINE_LOCATION"))
    EndTextCommandSetBlipName(dropOffBlip)

    dropBlip = dropOffBlip
    isDeliveringEngine = true

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_GOTO_DELIVER_ENGINE"))

    if pedModel ~= nil then
        exports.ft_libs:AddPed("boosting_deliverengineped", {model = pedModel, x = deliverCoords.x, y = deliverCoords.y, z = deliverCoords.z, w = deliverCoords.w})
    end

    while isDeliveringEngine do
        Citizen.Wait(0)

        local playerPed <const> = PlayerPedId()
        local playerCoords <const> = GetEntityCoords(playerPed)

        if #(playerCoords - vector3(deliverCoords.x, deliverCoords.y, deliverCoords.z)) > 2.5 then
            goto continue
        end

        if IsPedInAnyVehicle(playerPed, false) then
            ESX.ShowHelpNotification(T("BOOSTING_CANT_BE_INSIDE_VEHILCE"), "error")
            goto continue
        end

        ESX.ShowHelpNotification(T("BOOSTING_PRESS_TO_DELIVER_ENGINE"))

        if IsControlJustReleased(0, 38) then -- E
            TriggerServerEvent("cframework:boostingEngineDelivered", boostId)
            Citizen.Wait(1000)
        end

        ::continue::
    end
end)

RegisterNetEvent("cframework:boostingDeliveredEngine", function()
    local targetPed <const> = exports.ft_libs:GetPedHandle("boosting_deliverengineped")
    local playerPed <const> = PlayerPedId()

    isDeliveringEngine = false

    PlayPedAmbientSpeechNative(targetPed, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')

    ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
    ESX.PlayAnimOnPed(targetPed, 'mp_common', 'givetake1_a', 8.0, -1, 0)
    Citizen.Wait(1000)

    PlayPedAmbientSpeechNative(targetPed, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')

    ClearPedTasks(playerPed)
end)

RegisterNetEvent("cframework:boostingCompleteDeliverEngine", function(pedModel)
    if dropBlip ~= nil and DoesBlipExist(dropBlip) then
        RemoveBlip(dropBlip)
    end

    if pedModel ~= nil then
        exports.ft_libs:RemovePed("boosting_deliverengineped")
    end

    isDeliveringEngine = false
    dropBlip = nil
end)