

local boostingData = LoadBoosting()
local openingContainer = false

local ANIM = {
    objects = {
        'tr_prop_tr_grinder_01a',
        'ch_p_m_bag_var02_arm_s'
    },
    animations = { 'action', 'action_container', 'action_lock', 'action_angle_grinder', 'action_bag'}
}

local function startOpenContainer(containerEntity, lockEntity)
    local playerPed <const> = PlayerPedId()

    NetworkRequestControlOfEntity(containerEntity)
    while not NetworkHasControlOfEntity(containerEntity) do
        Citizen.Wait(0)
    end

    NetworkRequestControlOfEntity(lockEntity)
    while not NetworkHasControlOfEntity(lockEntity) do
        Citizen.Wait(0)
    end

    local anim_dict = 'anim@scripted@player@mission@tunf_train_ig1_container_p1@male@'

    RequestAnimDict(anim_dict)
    while not HasAnimDictLoaded(anim_dict) do
        Citizen.Wait(0)
    end

    RequestNamedPtfxAsset('scr_tn_tr')
    while not HasNamedPtfxAssetLoaded('scr_tn_tr') do
        Citizen.Wait(0)
    end

    local containerCoords <const>, containerRotation <const> = GetEntityCoords(containerEntity), GetEntityRotation(containerEntity)

    local objects = {}
    for index, value in ipairs(ANIM.objects) do
        local model = GetHashKey(value)
        RequestModel(model)

        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        objects[index] = CreateObject(model, containerCoords.x, containerCoords.y, containerCoords.z, true, true, false)
        SetEntityCollision(objects[index], false, true)
    end

    local scene = NetworkCreateSynchronisedScene(containerCoords.x, containerCoords.y, containerCoords.z, containerRotation.x, containerRotation.y, containerRotation.z, 2, true, false, 1.0, 0.0, 1.0)

    NetworkAddPedToSynchronisedScene(playerPed, scene, anim_dict, ANIM.animations[1], 4.0, -4.0, 1033, 0, 1000.0, 0)
    NetworkAddEntityToSynchronisedScene(containerEntity, scene, anim_dict, ANIM.animations[2], 1.0, -1.0, 0)
    NetworkAddEntityToSynchronisedScene(lockEntity, scene, anim_dict, ANIM.animations[3], 1.0, -1.0, 0)
    NetworkAddEntityToSynchronisedScene(objects[1], scene, anim_dict, ANIM.animations[4], 1.0, -1.0, 0)
    NetworkAddEntityToSynchronisedScene(objects[2], scene, anim_dict, ANIM.animations[5], 1.0, -1.0, 0)

    SetEntityCoords(playerPed, containerCoords.x, containerCoords.y, containerCoords.z, false, false, false, false)
    NetworkStartSynchronisedScene(scene)

    Citizen.Wait(4000)

    UseParticleFxAssetNextCall('scr_tn_tr')
    local sparks = StartParticleFxLoopedOnEntity("scr_tn_tr_angle_grinder_sparks", objects[1], 0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)

    Citizen.Wait(1000)

    StopParticleFxLooped(sparks, true)

    Citizen.Wait(GetAnimDuration(anim_dict, 'action') * 1000 - 5000)

    for index, value in ipairs(objects) do
        DeleteObject(value)
    end

    SetEntityVisible(containerEntity, false, false)
    SetEntityVisible(lockEntity, false, false)

    SetEntityCollision(containerEntity, false, true)
    SetEntityCollision(lockEntity, false, true)

    local container = CreateObject(GetHashKey('tr_prop_tr_container_01a'), containerCoords.x, containerCoords.y, containerCoords.z, false, false, false)
    SetEntityRotation(container, containerRotation.x, containerRotation.y, containerRotation.z, 2, true)

    local lock = CreateObject(GetHashKey('tr_prop_tr_lock_01a'), containerCoords.x, containerCoords.y, containerCoords.z, false, false, false)
    SetEntityRotation(lock, containerRotation.x, containerRotation.y, containerRotation.z, 2, true)

    local localScene = CreateSynchronizedScene(containerCoords.x, containerCoords.y, containerCoords.z, containerRotation.x, containerRotation.y, containerRotation.z, 2)
    PlaySynchronizedEntityAnim(container, localScene, ANIM.animations[2], anim_dict, 1.0, -1.0, 0, 0)
    ForceEntityAiAndAnimationUpdate(container)
    PlaySynchronizedEntityAnim(lock, localScene, ANIM.animations[3], anim_dict, 1.0, -1.0, 0, 0)
    ForceEntityAiAndAnimationUpdate(lock)

    SetSynchronizedScenePhase(localScene, 0.99)

    SetEntityCollision(container, false, true)
    FreezeEntityPosition(container, true)

    ClearPedTasks(playerPed)

    TriggerServerEvent("cframework:boostingContainerOpened")
end

RegisterNetEvent("cframework:boostingBeginOpenContainer", function(containerNetId, lockNetId, missionType)
    local playerPed <const> = PlayerPedId()
    local containerEntity <const> = NetworkGetEntityFromNetworkId(containerNetId)
    local lockEntity <const> = NetworkGetEntityFromNetworkId(lockNetId)

    openingContainer = true

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_OPEN_CONTAINER"))

    Citizen.CreateThread(function()
        while openingContainer do
            Citizen.Wait(0)

            if #(GetEntityCoords(playerPed) - GetEntityCoords(containerEntity)) > 8.0 then
                goto continue
            end

            ESX.ShowHelpNotification(T("BOOSTING_PRESS_TO_OPEN_CONTAINER"))

            if IsControlJustReleased(0, 38) then -- E
                openingContainer = false
                startOpenContainer(containerEntity, lockEntity)
            end

            ::continue::
        end
    end)
end)

RegisterNetEvent("cframework:boostingCompleteOpenContainer", function()
    openingContainer = false

    TriggerEvent("cframework:showBoostingNotification", T("BOOSTING_CONTAINER_OPENED_SUCCESSFULLY"))
end)