-- to prevent trying to spawn multiple times
local spawnLock = false

-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, 0)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true, false)
        end

        if not IsPedInAnyVehicle(ped, false) then
            SetEntityCollision(ped, true, false)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false, false)
        end

        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

-- spawns the current player at a certain spawn point index (or a random one, for that matter)
function SpawnPlayer(spawn)
    if spawnLock then return end

    spawnLock = true

    DoScreenFadeOut(500)

    while IsScreenFadingOut() do Citizen.Wait(0) end

    -- freeze the local player
    freezePlayer(PlayerId(), true)

    if spawn.skin == nil then
        TriggerEvent('jsfour-register:open')
        LoadSkinSync({sex = 0})
    else
        LoadSkinSync(spawn.skin)
    end

    -- preload collisions for the spawnpoint
    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

    -- spawn the player
    --ResurrectNetworkPlayer(GetPlayerId(), spawn.x, spawn.y, spawn.z, spawn.heading)

    -- V requires setting coords as well
    SetEntityCoordsNoOffset(GetPlayerPed(-1), spawn.x, spawn.y, spawn.z, false, false, false)
    NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, 0.0, true, true)

    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPlayerWantedLevel(PlayerId())

    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(GetPlayerPed(-1)) and (GetGameTimer() - time) < 5000) do
        Citizen.Wait(0)
    end

    if spawn.skin == nil then
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end
    else
        SwitchPlayer()
    end

    -- and unfreeze the player
    freezePlayer(PlayerId(), false)

    SetEntityCoordsNoOffset(GetPlayerPed(-1), spawn.x, spawn.y, spawn.z, false, false, false)

    SetPedMaxHealth(PlayerPedId(), 200) --Fix max health
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) --Disable regen

    SetPedCanLosePropsOnDamage(PlayerPedId(), false, 0)

    SetPedConfigFlag(PlayerPedId(), 35, false) -- Disable auto helmet when riding bikes

    --SetEntityHealth(PlayerPedId(), health)
    TriggerServerEvent('cframework:restoreLoadout')

    TriggerEvent('playerSpawned', spawn)

    spawnLock = false
end