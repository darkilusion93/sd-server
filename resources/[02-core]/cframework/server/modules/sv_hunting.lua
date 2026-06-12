

local huntingData = LoadHunting()

local playersSpawnedAnimal = {}
local playersCanSpawnAnimal = {}

local function isValidZone(source, baitItem)
    for _, zone in pairs(huntingData.validHuntingZones) do
        if #(GetEntityCoords(GetPlayerPed(source)) - zone.loc) < zone.radius then
            for _, filter in pairs(zone.filter) do
                if filter == baitItem then
                    return true
                end
            end

            if #zone.filter == 0 then
                return true
            end
        end
    end

    return false
end

Citizen.CreateThread(function()
    for k,_ in pairs(huntingData.huntingAnimals) do
        ESX.RegisterUsableItem(k, function(source, slot)
            local inventory <const> = ESX.getInvContainer(source)

            if not isValidZone(source, k) then
                TriggerClientEvent("esx:showNotification", source, T("HUNTING_INVALID_ZONE"), 'error')
                return
            end

            if not ESX.passedCooldown(source, 60000) then
                TriggerClientEvent("esx:showNotification", source, T("HUNTING_BAIT_COOLDOWN"), 'error')
                return
            end

            inventory.removeItem(k, 1, slot)

            TriggerClientEvent('hunting:useBait', source, k)

            playersCanSpawnAnimal[source] = k
        end)
    end
end)


RegisterNetEvent("hunting:spawnAnimal", function(coords, loc)
    local source <const> = source

    if playersCanSpawnAnimal[source] == nil then return end

    if not ESX.passedCooldown(source, 10000) then
        return
    end

    playersSpawnedAnimal[source] = playersCanSpawnAnimal[source]
    playersCanSpawnAnimal[source] = nil

    TriggerClientEvent('cframework:makeAnimalWalk', source, coords, loc, playersSpawnedAnimal[source])
end)

RegisterNetEvent("hunting:getSkinnedItem", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if playersSpawnedAnimal[source] == nil then
        TriggerClientEvent('esx:showNotification', source, T("HUNTING_NO_BAIT_PLANTED"), 'error')
        return
    end

    local baitUsed <const> = playersSpawnedAnimal[source]

    for _, skinItem in ipairs(huntingData.huntingAnimals[baitUsed].skinItems) do
        if math.random() <= skinItem.chance then
            local itemName <const> = skinItem.item
            local amount <const> = math.random(skinItem.quantity.min, skinItem.quantity.max)

            inventory.addItem(itemName, amount)
        end
    end

    playersSpawnedAnimal[source] = nil
end)
