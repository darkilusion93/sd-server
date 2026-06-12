local BinsAvailable = {
    `prop_bin_01a`,
    `prop_bin_02a`,
    `prop_bin_03a`,
    `prop_bin_04a`,
    `prop_bin_05a`,
    `prop_bin_06a`,
    `prop_bin_07a`,
    `prop_bin_07b`,
    `prop_bin_07c`,
    `prop_bin_07d`,
    `prop_bin_08a`,
    `prop_bin_09a`,
    `prop_bin_08open`,
    `zprop_bin_01a_old`,
    `prop_dumpster_01a`,
    `prop_dumpster_02a`,
    `prop_dumpster_02b`,
    `prop_dumpster_03a`,
    `prop_dumpster_04a`,
    `prop_dumpster_04b`,
}

local entity, entityDst, originCoords, isTrashSearchingDisabled = 0, nil, nil, false

local function openTrashCan(invId)
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(6000)
    TriggerEvent("cframework:openTempInventory", invId, "trash")
    ClearPedTasks(PlayerPedId())
end

RegisterNetEvent('cframework:disableSearchTrash', function()
    isTrashSearchingDisabled = true
end)

RegisterNetEvent('cframework:enableSearchTrash', function()
    isTrashSearchingDisabled = false
end)

Citizen.CreateThread(function()
    while true do
        entity, entityDst, originCoords = ESX.Game.GetClosestObject(BinsAvailable)
        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100)

    while true do
        local sleepThread = 1000

        if DoesEntityExist(entity) and entityDst <= 1.5 and not isTrashSearchingDisabled and GetVehiclePedIsIn(PlayerPedId(), false) == 0 and originCoords ~= nil then
            sleepThread = 0

            local binCoords = GetEntityCoords(entity)

            ESX.Game.Utils.DrawText3D(binCoords + vector3(0.0, 0.0, 0.5), "[~g~E~s~] Procurar lixo", 0.4)

            if IsControlJustReleased(0, 38) then
                openTrashCan("GARBAGE-X"..math.floor(originCoords.x).."Y"..math.floor(originCoords.y))
            end
        end

        Citizen.Wait(sleepThread)
    end
end)
