

local heist = LoadOrnateHeist()
local zipTies = heist.zipTies

local function applyZipTieOnDoor(source, currentDoor, inventory, slot)
    local zipTie <const> = zipTies[currentDoor]

    if zipTie == nil then return end

    if zipTie.locked then
        TriggerClientEvent("esx:showNotification", source, T("ORNATE_HEIST_DOOR_TIED"), "error")
        return
    end

    local doorId1 <const>, doorId2 <const> = ESX.GetDoorIdFromName(zipTie.door1), ESX.GetDoorIdFromName(zipTie.door2)

    if doorId1 == nil or doorId2 == nil then return end

    local zipEntity <const> = CreateObject(GetHashKey("hei_prop_zip_tie_positioned"), zipTie.loc.x, zipTie.loc.y, zipTie.loc.z - 10.0, true, true, false)

    local curTime <const> = os.time()

    while not DoesEntityExist(zipEntity) do
        Citizen.Wait(20)

        if os.time() - curTime > 20 then return nil end
    end

    inventory.removeItem("ziptie", 1, slot)

    FreezeEntityPosition(zipEntity, true)
    SetEntityHeading(zipEntity, zipTie.loc.w)
    SetEntityCoords(zipEntity, zipTie.loc.x, zipTie.loc.y, zipTie.loc.z, false, false, false, false)

    TriggerEvent("gdoors:script-change-lock-state", doorId1, true)
    TriggerEvent("gdoors:script-change-lock-state", doorId2, true)

    zipTies[currentDoor].entity = zipEntity
    zipTies[currentDoor].locked = true
    zipTies[currentDoor].timestamp = os.time() + 3600
end

RegisterNetEvent("cframework:removeZipTieFromBankDoor", function(currentDoor)
    local source <const> = source
    local playerCoords <const> = GetEntityCoords(GetPlayerPed(source))
    local zipTie <const> = zipTies[currentDoor]

    if zipTie == nil then return end

    if not zipTie.locked then
        TriggerClientEvent("esx:showNotification", source, T("ORNATE_HEIST_DOOR_NOT_TIED"), "error")
        return
    end

    if #(playerCoords - zipTie.loc.xyz) > 2.0 then
        return
    end

    local doorId1 <const>, doorId2 <const> = ESX.GetDoorIdFromName(zipTie.door1), ESX.GetDoorIdFromName(zipTie.door2)

    if doorId1 == nil or doorId2 == nil then return end

    TriggerEvent("gdoors:script-change-lock-state", doorId1, false)
    TriggerEvent("gdoors:script-change-lock-state", doorId2, false)

    if DoesEntityExist(zipTie.entity) then
        DeleteEntity(zipTie.entity)
    end

    zipTies[currentDoor].entity = nil
    zipTies[currentDoor].locked = false
    zipTies[currentDoor].timestamp = 0
end)

ESX.RegisterUsableItem("ziptie", function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local playerCoords <const> = GetEntityCoords(GetPlayerPed(source))

    for k, v in pairs(zipTies) do
        local doorCoords <const> = v.loc.xyz

        if #(playerCoords - doorCoords) < 2.0 then
            applyZipTieOnDoor(source, k, inventory, slot)
            break
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)

        for k, v in pairs(zipTies) do
            if v.locked and os.time() > v.timestamp then
                local doorId1 <const>, doorId2 <const> = ESX.GetDoorIdFromName(v.door1), ESX.GetDoorIdFromName(v.door2)

                if doorId1 == nil or doorId2 == nil then return end

                TriggerEvent("gdoors:script-change-lock-state", doorId1, false)
                TriggerEvent("gdoors:script-change-lock-state", doorId2, false)

                if DoesEntityExist(v.entity) then
                    DeleteEntity(v.entity)
                end

                zipTies[k].entity = nil
                zipTies[k].locked = false
                zipTies[k].timestamp = 0
            end
        end
    end
end)