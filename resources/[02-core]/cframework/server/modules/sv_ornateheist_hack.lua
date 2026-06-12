

local heist = LoadOrnateHeist()
local hackableDoors <const> = heist.hackableDoors
local hackableDoorNames <const> = heist.hackableDoorNames
local playerHackingDoor = {}
local doorsBroken = {}

RPC.register("cframework:spawnHackProps", function(plant)
    local source <const> = source
    local player <const> = playerHackingDoor[plant]

    if player == nil or player ~= source then return end

    local coords <const> = GetEntityCoords(GetPlayerPed(source))
    local bag <const> = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), coords.x, coords.y, coords.z - 10.0, true, true, false)
    local laptop <const> = CreateObject(GetHashKey("hei_prop_hst_laptop"), coords.x, coords.y, coords.z - 10.0, true, true, false)
    local card <const> = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), coords.x, coords.y, coords.z - 10.0, true, true, false)

    local curTime <const> = os.time()

    while not DoesEntityExist(bag) or not DoesEntityExist(laptop) or not DoesEntityExist(card) do
        Citizen.Wait(20)

        if os.time() - curTime > 20 then return nil end
    end

    return NetworkGetNetworkIdFromEntity(bag), NetworkGetNetworkIdFromEntity(laptop), NetworkGetNetworkIdFromEntity(card)
end)

RegisterNetEvent("cframework:finishHackingDoor", function(plant, success)
    local source <const> = source
    local player <const> = playerHackingDoor[plant]
    local doorName <const> = hackableDoorNames[plant]

    if player == nil or doorName == nil then return end

    if player ~= source then return end

    playerHackingDoor[plant] = nil

    if not success then return end

    local doorId <const> = ESX.GetDoorIdFromName(doorName)

    if doorId == nil then return end

    if plant == "vault"then
        TriggerEvent("gdoors:script-change-lock-state", doorId, false, -1.0)
        return
    end

    TriggerEvent("gdoors:script-change-lock-state", doorId, false)
    doorsBroken[plant] = true
end)

function ResetOrnateHeistHackedDoors()
    doorsBroken = {}

    for plant,_ in pairs(hackableDoors) do
        local doorId <const> = ESX.GetDoorIdFromName(hackableDoorNames[plant])

        if doorId ~= nil then
            if plant == "vault"then
                TriggerEvent("gdoors:script-change-lock-state", doorId, false, 0.0)
            else
                TriggerEvent("gdoors:script-change-lock-state", doorId, true)
            end
        end
    end
end

ESX.RegisterUsableItem("laptop_h", function(source, slot)
    local playerCoords <const> = GetEntityCoords(GetPlayerPed(source))

    for plant, door in pairs(hackableDoors) do
        if #(playerCoords - door.xyz) < 2.0 then
            if doorsBroken[plant] ~= nil then
                return
            end

            local inRobbery <const> = IsOrnateHeistRobberyActive()

            if not inRobbery then
                return
            end

            playerHackingDoor[plant] = source
            TriggerClientEvent("cframework:tryToHackDoor", source, plant, door)
            break
        end
    end
end)
