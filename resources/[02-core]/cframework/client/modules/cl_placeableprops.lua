local listening = false
local currentEntityCoords, currentEntity = vector3(0, 0, 0), nil

local function listenForKeypress()
    listening = true
    Citizen.CreateThread(function()
        ESX.ShowNotification('[E] Para apanhar a barreira', 'inform')

        while listening do
            ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
            if currentEntity ~= nil and IsControlJustReleased(0, 38) and #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), currentEntityCoords)) <= 1.8 then
                TriggerServerEvent('cframework:removeBarrier', NetworkGetNetworkIdFromEntity(currentEntity))
                listening = false
                return true
            end

            Citizen.Wait(0)
        end
    end)
end


AddEventHandler("np:target:changed", function(pEntity, pEntityType, pEntityCoords)
    if pEntityType == nil or pEntityType ~= 3 or GetEntityModel(pEntity) ~= `prop_barrier_work05` then
        listening, currentEntityCoords, currentEntity = false, vector3(0, 0, 0), nil
        return
    end

    currentEntity = pEntity
    currentEntityCoords = pEntityCoords

    if not listening then
        listenForKeypress()
    end
end)

RegisterNetEvent('cframework:placePropAnim', function()
    ESX.Streaming.RequestAnimDict("anim@heists@money_grab@briefcase", function()
        TaskPlayAnim(PlayerPedId(), "anim@heists@money_grab@briefcase", "put_down_case", 8.0, -8.0, -1, 1, 0, false, false, false)
    end)

    Citizen.Wait(1000)
    ClearPedTasks(PlayerPedId())
end)