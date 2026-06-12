

local huntingData = LoadHunting()

local baitLocation = nil
local baitLastType = nil
local baitLastPlaced = 0
local targetedEntity = 0

local SCRIPT_TASK_GO_TO_ENTITY <const> = 0x4924437D

AddEventHandler("np:target:changed", function(pEntity)
    targetedEntity = pEntity
end)

local function isValidZone()
    for _, zone in pairs(huntingData.validHuntingZones) do
        if #(GetEntityCoords(PlayerPedId()) - zone.loc) < zone.radius then
            return true
        end
    end

    return false
end

local function getSpawnLoc()
    local spawnDistanceRadius <const> = 60.0
    local playerCoords <const> = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil

    if baitLocation == nil then
        return vector3(0.0, 0.0, 0.0)
    end

    while spawnCoords == nil do
        local spawnX = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnY = math.random(-spawnDistanceRadius, spawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)
        if #(playerCoords - vec) > spawnDistanceRadius then
            spawnCoords = vec
        end
    end

    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)

    return vector3(spawnCoords.x, spawnCoords.y, groundZ)
end

local function spawnAnimal(loc)
    local spawnLoc <const> = getSpawnLoc()
    TriggerServerEvent("hunting:spawnAnimal", spawnLoc, loc)

    ESX.ShowNotification(T("HUNTING_DONT_SCARE_ANIMAL"), 'inform')
end

local function baitDown()
    Citizen.CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(PlayerPedId())
            if #(baitLocation - coords) > huntingData.baitDistanceInUnits then
                if math.random() < 0.15 then
                    spawnAnimal(baitLocation)
                    baitLocation = nil
                end
            end
            Citizen.Wait(5000)
        end
    end)
end

RegisterNetEvent("hunting:useBait", function(baitType)
    if not isValidZone() then
        ESX.ShowNotification(T("HUNTING_INVALID_ZONE"), 'error')
        return
    end
    if baitLastPlaced ~= 0 and GetGameTimer() < (baitLastPlaced + 60000) then -- 1 minuto
        ESX.ShowNotification(T("HUNTING_BAIT_COOLDOWN"), 'error')
        return
    end

    local animalData <const> = huntingData.huntingAnimals[baitType]

    baitLocation = nil

    if animalData.useBaitScenario then
        TaskStartScenarioInPlace(PlayerPedId(), animalData.useBaitScenario, 0, true)
    elseif animalData.useBaitAnim and animalData.useBaitDict then
        ESX.Streaming.RequestAnimDict(animalData.useBaitDict, function()
            TaskPlayAnim(PlayerPedId(), animalData.useBaitDict, animalData.useBaitAnim, 8.0, -8.0, -1, 1, 0, false, false, false)
        end)
    end

    ESX.ShowNotification(T("HUNTING_BURYING_BAIT"), 'inform')
    Citizen.Wait(animalData.baitTime)
    ClearPedTasks(PlayerPedId())
    baitLastPlaced = GetGameTimer()
    baitLocation = GetEntityCoords(PlayerPedId())
    baitLastType = baitType
    ESX.ShowNotification(T("HUNTING_BAIT_NEARBY_ANIMAL"), 'inform')
    baitDown()
end)

local usingKnife = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        -- Check if the player is shooting
        if IsPedInMeleeCombat(PlayerPedId()) and GetSelectedPedWeapon(PlayerPedId()) == `WEAPON_KNIFE` then
            --local _, targetEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if targetedEntity and DoesEntityExist(targetedEntity) and GetPedType(targetedEntity) == 28 and IsPedDeadOrDying(targetedEntity, true) then
                TriggerEvent("hunting:useKnife")
            end
        end
    end
end)

RegisterNetEvent("hunting:useKnife", function()
    if GetPedType(targetedEntity) ~= 28 or not IsPedDeadOrDying(targetedEntity, true) then
        ESX.ShowNotification(T("HUNTING_NO_ANIMAL_NEARBY"), 'error')
        return
    end
    if usingKnife then return end
    local myAnimal <const> = targetedEntity

    usingKnife = true

    if baitLastType == nil then return end

    local animalData <const> = huntingData.huntingAnimals[baitLastType]

    if animalData == nil then return end

    TriggerEvent("cframework:removeWeaponsFromHandInstant")
    TaskTurnPedToFaceEntity(PlayerPedId(), myAnimal, -1)
    Citizen.Wait(1500)
    ClearPedTasksImmediately(PlayerPedId())

    if animalData.skinAnimScenario then
        TaskStartScenarioInPlace(PlayerPedId(), animalData.skinAnimScenario, 0, true)
    elseif animalData.skinAnimDict and animalData.skinAnim then
        ESX.Streaming.RequestAnimDict(animalData.skinAnimDict, function()
            TaskPlayAnim(PlayerPedId(), animalData.skinAnimDict, animalData.skinAnim, 8.0, -8.0, -1, 1, 0, false, false, false)
        end)
    end

    ESX.ShowNotification(T("HUNTING_PREPARING_ANIMAL"), 'inform')
    Citizen.Wait(animalData.skinTime)
    ESX.ShowNotification(T("HUNTING_SKINNED_ANIMAL"), 'success')
    ClearPedTasks(PlayerPedId())
    NetworkFadeOutEntity(myAnimal, true, false)
    Citizen.Wait(1500)
    TriggerServerEvent('hunting:getSkinnedItem')
    DeleteEntity(myAnimal)
    usingKnife = false
end)

RegisterNetEvent("cframework:makeAnimalWalk", function(coords, loc, animalType)
    local animalModel = huntingData.huntingAnimals[animalType].model

    RequestModel(animalModel)
    while not HasModelLoaded(animalModel) do
        Citizen.Wait(0)
    end

    local animalPed <const> = CreatePed(28, animalModel, coords.x, coords.y, coords.z, 0.0, false, true)

    SetEntityMaxHealth(animalPed, huntingData.huntingAnimals[animalType].health)
    SetEntityHealth(animalPed, huntingData.huntingAnimals[animalType].health)

    TaskGoStraightToCoord(animalPed, loc.x, loc.y, loc.z, 1.0, -1, 0.0, 0.0)

    if huntingData.huntingAnimals[animalType].attacksPlayer then
        Citizen.CreateThread(function()
            while DoesEntityExist(animalPed) do
                local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(animalPed))

                if dist > 5.0 then
                    if GetScriptTaskStatus(animalPed, SCRIPT_TASK_GO_TO_ENTITY) ~= 1 then
                        TaskGoToEntity(animalPed, PlayerPedId(), -1, 4.0, 100.0, 1073741824, 0)
                    end
                    Citizen.Wait(1000)
                else
                    TaskCombatPed(animalPed, PlayerPedId(), 0, 16)

                    if not LastPedTurn or (GetCloudTimeAsInt() - LastPedTurn) > 1000 then
                        LastPedTurn = GetCloudTimeAsInt()
                        TaskTurnPedToFaceEntity(animalPed, PlayerPedId(), -1)
                    end

                    Citizen.Wait(0)
                end
                Citizen.Wait(0)
            end
        end)
    end
end)

Citizen.CreateThread(function()
    for _, v in ipairs(huntingData.validHuntingZones) do
        if v.onMap then
            local blip = AddBlipForRadius(v.loc.x, v.loc.y, v.loc.z, v.radius)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, v.rcolor)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 2)

            local blip3 = AddBlipForCoord(v.loc.x, v.loc.y, v.loc.z)
            SetBlipSprite (blip3, v.sprite)
            SetBlipDisplay(blip3, 2)
            SetBlipScale  (blip3, 0.5)
            SetBlipColour (blip3, v.color)
            SetBlipAsShortRange(blip3, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.name)
            EndTextCommandSetBlipName(blip3)
        end
    end
end)