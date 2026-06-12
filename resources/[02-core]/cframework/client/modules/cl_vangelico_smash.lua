

local heist = LoadVangelicoHeist()
local smashState, scene, sceneNetId = 0, -1, -1
local invisibleGasGrenade = 0
local createdScriptCameras = false
local scriptCam1, scriptCam2, scriptCam3 = 0, 0, 0

local cabinetProp1, cabinetProp2, cabinetProp3, cabinetProp4 = "DES_Jewel_Cab", "DES_Jewel_Cab2", "DES_Jewel_Cab3", "DES_Jewel_Cab4"

local heistAnimDict = "missheist_jewel"

local Local_748_f_36 = "cam_smash_case_d"
local Local_748_f_37 = "smash_case_e"
local Local_748_f_38 = "cam_smash_case_e"
local Local_748_f_39 = "smash_case_necklace"
local Local_748_f_40 = "cam_smash_case_necklace"
local Local_748_f_42 = "smash_case_tray_a"
local Local_748_f_43 = "cam_smash_case_tray_a"
local Local_748_f_44 = "smash_case_tray_b"
local Local_748_f_45 = "cam_smash_case_tray_b"

local Local_748_f_18 = `prop_j_neck_disp_02`
local Local_748_f_19 = `prop_jewel_02a`
local Local_748_f_20 = `prop_jewel_04a`
local Local_748_f_21 = `prop_jewel_04b`

local sLocal_505 = ""
local sLocal_506 = ""
local iLocal_507 = ""
local fLocal_508 = 0.0
local fLocal_509 = 0.0
local fLocal_510 = 0.0
local fLocal_511 = -1.0
local fLocal_512 = -1.0

local robbedJewelEntity = 0

local glassCabinets = heist.glassCabinets

local function getCamNameForFirstPerson(camName)
	local firstPersonPrefix = "FP_"

	if GetCamViewModeForContext(0) == 4 then
		return firstPersonPrefix .. camName
    end

	return camName
end

local function hasSceneEnded(iParam0)
	if IsSynchronizedSceneRunning(iParam0) then
		if GetSynchronizedScenePhase(iParam0) >= 1.0 then
			return 1
        end
	end

	return 0
end

local function createScriptedCameras(bParam0, bParam1, bParam2, bParam3, iParam4)
	if createdScriptCameras then
        return
    end

    if not IsPedInjured(PlayerPedId()) then
        DestroyAllCams(false)
        if not bParam1 then
            scriptCam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            scriptCam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            SetCamCoord(scriptCam1, 1.0, 1.0, 1.0)
        else
            scriptCam1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            scriptCam2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
            scriptCam3 = CreateCam("DEFAULT_ANIMATED_CAMERA", false)
            SetCamCoord(scriptCam3, 1.0, 1.0, 1.0)
        end

        if bParam3 then
            SetWidescreenBorders(true, 500)
        end

        if bParam0 then
            SetPlayerControl(PlayerId(), false, 4)
        else
            SetPlayerControl(PlayerId(), false, 0)
        end

        HidePedWeaponForScriptedCutscene(PlayerPedId(), bParam2)
    end

    Settimerb(0)
    createdScriptCameras = true
end

local function destroyScriptedCameras(bParam0, bParam1, iParam2, bParam3, iParam4)
	if createdScriptCameras then
		SetWidescreenBorders(false, 500)
		if IsPlayerPlaying(PlayerId()) then
			if DoesCamExist(scriptCam1) then
				SetCamActive(scriptCam1, false)
				DestroyCam(scriptCam1, false)
            end
			if DoesCamExist(scriptCam2) then
				SetCamActive(scriptCam2, false)
				DestroyCam(scriptCam2, false)
            end
			if DoesCamExist(scriptCam3) then
				SetCamActive(scriptCam3, false)
				DestroyCam(scriptCam3, false)
            end
			if not bParam1 then
				RenderScriptCams(false, false, iParam2, true, false)
			elseif bParam3 then
				StopRenderingScriptCamsUsingCatchUp(false, 0, 3)
			else
				RenderScriptCams(false, true, iParam2, true, false)
            end
			StopGameplayCamShaking(true)
			if bParam0 then
				ClearPedTasks(PlayerPedId())
            end

            HidePedWeaponForScriptedCutscene(PlayerPedId(), false)

			if not IsPedInAnyVehicle(PlayerPedId(), false) then
				if not IsEntityAttachedToAnyObject(PlayerPedId()) then
					FreezeEntityPosition(PlayerPedId(), false)
                end
			end

			SetPlayerControl(PlayerId(), true, 0)
			createdScriptCameras = false
		end
	end
end

local function prepareSmashAnimAndCams(glassCabinetIndex)
	local Var4 --struct<16>
	local fVar5 = 0.0 --float

    if glassCabinets[glassCabinetIndex].cabinetProp == cabinetProp1 then
        sLocal_505 = Local_748_f_39;
        Var4 = getCamNameForFirstPerson(sLocal_505)
        sLocal_505 = Var4;
        sLocal_506 = Local_748_f_40;
        iLocal_507 = Local_748_f_20;
        fLocal_508 = 0.2;
        fLocal_509 = 0.4;
        fLocal_510 = 0.71;
        fLocal_511 = -1.0;
        fLocal_512 = -1.0;
        if glassCabinets[glassCabinetIndex].entityAnimState > 0 then
            fVar5 = 0.49;
        else
            fVar5 = 0.0;
        end

        if (glassCabinetIndex == 1) then
            sLocal_506 = Local_748_f_36
        end
    elseif glassCabinets[glassCabinetIndex].cabinetProp == cabinetProp2 then
        sLocal_505 = Local_748_f_37;
        Var4 = getCamNameForFirstPerson(sLocal_505)
        sLocal_505 = Var4;
        sLocal_506 = Local_748_f_38;
        if glassCabinetIndex == 5 then
            sLocal_506 = Local_748_f_43;
        end
        iLocal_507 = Local_748_f_21;
        fLocal_508 = 0.143;
        fLocal_509 = 0.625;
        fLocal_510 = 0.786;
        fLocal_511 = -1.0;
        fLocal_512 = -1.0;
        if glassCabinets[glassCabinetIndex].entityAnimState > 0 then
            fVar5 = 0.319;
        else
            fVar5 = 0.0;
        end
    elseif glassCabinets[glassCabinetIndex].cabinetProp == cabinetProp3 then
        sLocal_505 = Local_748_f_42;
        Var4 = getCamNameForFirstPerson(sLocal_505)
        sLocal_505 = Var4;
        sLocal_506 = Local_748_f_43;
        iLocal_507 = Local_748_f_19;
        fLocal_508 = 0.168;
        fLocal_509 = 0.483;
        fLocal_510 = 0.753;
        fLocal_511 = -1.0;
        fLocal_512 = -1.0;
        if glassCabinets[glassCabinetIndex].entityAnimState > 0 then
            fVar5 = 0.269;
        else
            fVar5 = 0.0;
        end

        if glassCabinetIndex == 6 then
            sLocal_506 = Local_748_f_45;
        end
    elseif AreStringsEqual(glassCabinets[glassCabinetIndex].cabinetProp, cabinetProp4) then
        sLocal_505 = Local_748_f_44;
        Var4 = getCamNameForFirstPerson(sLocal_505)
        sLocal_505 = Var4
        sLocal_506 = Local_748_f_45
        iLocal_507 = Local_748_f_18
        fLocal_508 = 0.041
        fLocal_509 = 0.415
        fLocal_510 = 0.738
        fLocal_511 = -1.0
        fLocal_512 = -1.0
        if glassCabinets[glassCabinetIndex].entityAnimState > 0 then
            fVar5 = 0.25
        else
            fVar5 = 0.0
        end
    end

    --SetCurrentPedWeapon(PlayerPedId(), joaat("WEAPON_ASSAULTRIFLE"), true)

    StartAudioScene("JSH_2B_CABINET_SMASH")
    if GetCamViewModeForContext(0) ~= 4 then
        createScriptedCameras(0, 1, 0, 0, 0)
    end

    ClearHelp(true)

    RequestAnimDict(heistAnimDict)
    while not HasAnimDictLoaded(heistAnimDict) do
        Wait(0)
    end

    local objectCoords <const> = glassCabinets[glassCabinetIndex].objectCoords
    local animRotation <const> = glassCabinets[glassCabinetIndex].animRotation

    sceneNetId = NetworkCreateSynchronisedScene(objectCoords.x, objectCoords.y, objectCoords.z, animRotation.x, animRotation.y, animRotation.z, 2, false, false, 1.0, fVar5, 1.0)

    if GetCamViewModeForContext(0) ~= 4 then
        NetworkAddPedToSynchronisedScene(PlayerPedId(), sceneNetId, heistAnimDict, sLocal_505, 8.0, -2.0, 6, 0, 1000.0, 0)
    else
        NetworkAddPedToSynchronisedScene(PlayerPedId(), sceneNetId, heistAnimDict, sLocal_505, 8.0, -2.0, 6, 0, 1000.0, 0)
    end

    NetworkStartSynchronisedScene(sceneNetId)

    while scene == -1 do
        Citizen.Wait(0)
        scene = NetworkGetLocalSceneFromNetworkId(sceneNetId)
    end

    if GetCamViewModeForContext(0) ~= 4 then
        local camCoords <const> = glassCabinets[glassCabinetIndex].camCoords

        if Vmag(camCoords.x, camCoords.y, camCoords.z) == 0.0 then
            PlaySynchronizedCamAnim(scriptCam3, scene, sLocal_506, heistAnimDict)
            SetCamActive(scriptCam3, true)
            SetCamControlsMiniMapHeading(scriptCam3, true)
        else
            local camCoords2 <const> = glassCabinets[glassCabinetIndex].camCoords2
            local camRot1 <const> = glassCabinets[glassCabinetIndex].camRot1
            local camRot2 <const> = glassCabinets[glassCabinetIndex].camRot2

            SetCamCoord(scriptCam1, camCoords.x, camCoords.y, camCoords.z)
            SetCamRot(scriptCam1, camRot1.x, camRot1.y, camRot1.z, 2)
            SetCamFov(scriptCam1, glassCabinets[glassCabinetIndex].camFov1)
            SetCamCoord(scriptCam2, camCoords2.x, camCoords2.y, camCoords2.z)
            SetCamRot(scriptCam2, camRot2.x, camRot2.y, camRot2.z, 2)
            SetCamFov(scriptCam2, glassCabinets[glassCabinetIndex].camFov2)
            SetCamActiveWithInterp(scriptCam2, scriptCam1, 2500, 3, 3)
            SetCamControlsMiniMapHeading(scriptCam2, true)
        end
        RenderScriptCams(true, false, 3000, true, false)
    end

    smashState += 1
end

local function playSmashingSounds(glassCabinetIndex)
    if IsSynchronizedSceneRunning(scene) then
        if GetSynchronizedScenePhase(scene) > fLocal_508 then
            if glassCabinets[glassCabinetIndex].entityAnimState == 0 then
                local objCoords <const> = glassCabinets[glassCabinetIndex].coords
                local soundId = GetSoundId()

                PlaySoundFromCoord(soundId, "SMASH_CABINET_NPC", objCoords.x, objCoords.y, objCoords.z, "JEWEL_HEIST_SOUNDS", false, 0, false)
                --if ((glassCabinetIndex % 2) == 0) then
                --    N_0x293220da1b46cebc(2.0, 4.0, 4)
                --end

                RequestNamedPtfxAsset("scr_jewelheist")
                while not HasNamedPtfxAssetLoaded("scr_jewelheist") do
                    Citizen.Wait(0)
                end

                SetPtfxAssetNextCall("scr_jewelheist")
                StartParticleFxNonLoopedOnEntity("scr_jewel_cab_smash", GetCurrentPedWeaponEntityIndex(PlayerPedId()), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1065353216, false, false, false)

                if DoesObjectOfTypeExistAtCoords(objCoords.x, objCoords.y, objCoords.z, 2.0, joaat("p_int_jewel_mirror"), false) then
                    local entity = GetClosestObjectOfType(objCoords.x, objCoords.y, objCoords.z, 2.0, joaat("p_int_jewel_mirror"), false, false, false)

                    if not DoesEntityExist(invisibleGasGrenade) then
                        local coords = GetEntityCoords(entity)
                        invisibleGasGrenade = CreateObject(joaat("prop_gas_grenade"), coords.x, coords.y, coords.z, false, true, false)
                    end

                    SetEntityVisible(invisibleGasGrenade, false, false);
                    ApplyForceToEntity(invisibleGasGrenade, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                end
            end
            smashState += 1
        end
    end
end

local function playCabinetAnim(glassCabinetIndex)
    if IsSynchronizedSceneRunning(scene) then
        if glassCabinets[glassCabinetIndex].entityAnimState == 0 then
            if GetSynchronizedScenePhase(scene) > fLocal_508 then
                local coords <const> = glassCabinets[glassCabinetIndex].coords
                local cabinet = GetRayfireMapObject(coords.x, coords.y, coords.z, 1.0, glassCabinets[glassCabinetIndex].cabinetProp)

                if GetStateOfRayfireMapObject(cabinet) == 5 then

                    SetStateOfRayfireMapObject(cabinet, 6)
                    glassCabinets[glassCabinetIndex].entityAnimState += 1

                    TriggerServerEvent("cframework:smashVangelicoCabinet", glassCabinetIndex)

                    local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
                    RecordBrokenGlass(coords.x, coords.y, groundZ, 2.0)
                end
            end
        end

        if not DoesEntityExist(robbedJewelEntity) then
            if GetSynchronizedScenePhase(scene) > fLocal_509 then
                local coords <const> = glassCabinets[glassCabinetIndex].objectCoords

                robbedJewelEntity = CreateObject(iLocal_507, coords.x, coords.y, coords.z, false, true, false)
                AttachEntityToEntity(robbedJewelEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

                if DoesEntityExist(invisibleGasGrenade) then
                    DeleteObject(invisibleGasGrenade)
                end
                --iLocal_413 = (iLocal_413 + glassCabinets[glassCabinetIndex].f_26);
                if ((glassCabinetIndex == 10 or glassCabinetIndex == 11) or glassCabinetIndex == 13) then
                    --iLocal_74 = 1;
                end
                smashState += 1
            end
        end
    end
end

local function attachJewelAndStoreInBag(glassCabinetIndex)
    if (IsSynchronizedSceneRunning(scene)) then
        if fLocal_511 < 0.0 then
            smashState += 1;
            PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
            TriggerServerEvent("cframework:receiveJewelryCabinet", glassCabinetIndex)
        elseif (DoesEntityExist(robbedJewelEntity)) then
            if GetSynchronizedScenePhase(scene) > fLocal_510 then
                DeleteObject(robbedJewelEntity)
            end
        elseif GetSynchronizedScenePhase(scene) > fLocal_511 then
            local coords <const> = glassCabinets[glassCabinetIndex].objectCoords

            robbedJewelEntity = CreateObject(iLocal_507, coords.x, coords.y, coords.z, false, true, false)
            AttachEntityToEntity(robbedJewelEntity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            smashState += 1
            PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
            TriggerServerEvent("cframework:receiveJewelryCabinet", glassCabinetIndex)
        end
    end
end

local function deleteRobbedObjectAndDestroyCams(glassCabinetIndex)
	local fVar2 = -1.0 -- float
	local bVar3 = false --bool

    if (IsSynchronizedSceneRunning(scene)) then
        if (DoesEntityExist(robbedJewelEntity)) then
            if (fLocal_511 < 0.0) then
                if (GetSynchronizedScenePhase(scene) > fLocal_510) then
                    DeleteObject(robbedJewelEntity)
                end
            elseif (GetSynchronizedScenePhase(scene) > fLocal_512) then
                DeleteObject(robbedJewelEntity)
            end
        end
        fVar2 = GetSynchronizedScenePhase(scene)
        if (fVar2 > 0.92) then
            bVar3 = true;
        end

        if (glassCabinetIndex == 1) then
            if (fVar2 > 0.8) then
                bVar3 = true
            end
        end
        if (hasSceneEnded(scene) or (HasAnimEventFired(PlayerPedId(), GetHashKey("early_out")) and (IsDisabledControlJustPressed(0, 30) or IsDisabledControlJustPressed(0, 31)))) then
            --print("early out")
           -- bVar3 = true
        end
    else
        bVar3 = true
    end

    if (bVar3) then
        if DoesEntityExist(robbedJewelEntity) then
            DeleteObject(robbedJewelEntity)
        end

        HidePedWeaponForScriptedCutscene(PlayerPedId(), false)
        if GetCamViewModeForContext(0) ~= 4 then
            destroyScriptedCameras(false, true, 1500, true, false)
        end
        ClearPedTasks(PlayerPedId());
        --NetworkStopSynchronisedScene(sceneNetId)
        StopAudioScene("JSH_2B_CABINET_SMASH");

        smashState += 1
    end
end

local function smashJewelryCabin(glassCabinetIndex) --func_941()
	DisableControlAction(0, 0, true)

    if smashState == 0 then
        prepareSmashAnimAndCams(glassCabinetIndex)
    elseif smashState == 1 then
        playSmashingSounds(glassCabinetIndex)
    elseif smashState == 2 then
        playCabinetAnim(glassCabinetIndex)
    elseif smashState == 3 then
        attachJewelAndStoreInBag(glassCabinetIndex)
    elseif smashState == 4 then
        deleteRobbedObjectAndDestroyCams(glassCabinetIndex)
    end
end


RegisterNetEvent("cframework:smashJelwryAndRob", function(glassCabinetIndex)
    local glassCabinet = tonumber(glassCabinetIndex)

    smashState, scene, sceneNetId = 0, -1, -1

    glassCabinets[glassCabinet].entityAnimState = 0

    while smashState < 5 do
        smashJewelryCabin(glassCabinet)

        Citizen.Wait(0)
    end
end)

RegisterNetEvent("cframework:smashVangelicoCabinet", function(cabinetIndex)
    local coords <const> = glassCabinets[cabinetIndex].coords

    if glassCabinets[cabinetIndex].entityAnimState > 0 then
        return
    end

    glassCabinets[cabinetIndex].entityAnimState = 1

    local cabin = GetRayfireMapObject(coords.x, coords.y, coords.z, 1.0, glassCabinets[cabinetIndex].cabinetProp)

    SetStateOfRayfireMapObject(cabin, 6)

    local _, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, false)
    RecordBrokenGlass(coords.x, coords.y, groundZ, 2.0)
end)

RegisterNetEvent("cframework:prepareSmashVangelicoCabinet", function(cabinetIndex)
    local coords <const> = glassCabinets[cabinetIndex].coords

    glassCabinets[cabinetIndex].entityAnimState = 0

    local cabin = GetRayfireMapObject(coords.x, coords.y, coords.z, 1.0, glassCabinets[cabinetIndex].cabinetProp)

    SetStateOfRayfireMapObject(cabin, 4)
end)

RegisterNetEvent("cframework:rebuildAllCabinets", function()
    for k, v in pairs(glassCabinets) do
        local coords <const> = glassCabinets[k].coords

        glassCabinets[k].entityAnimState = 0

        local cabin = GetRayfireMapObject(coords.x, coords.y, coords.z, 1.0, glassCabinets[k].cabinetProp);
		if glassCabinets[k].entityAnimState == 0 then
			SetStateOfRayfireMapObject(cabin, 4)
        end
    end

    ClearAllBrokenGlass()
end)

RegisterNetEvent("cframework:loadVangelicoHeist", function(cabinets)
    Citizen.Wait(10000)

    for k, v in pairs(cabinets) do
        local cabin = GetRayfireMapObject(v.coords.x, v.coords.y, v.coords.z, 1.0, v.cabinetProp)

        SetStateOfRayfireMapObject(cabin, 4)
    end

    Citizen.Wait(5000)

    for k, v in pairs(cabinets) do
        local cabin = GetRayfireMapObject(v.coords.x, v.coords.y, v.coords.z, 1.0, v.cabinetProp)

        if v.robbed then
            SetStateOfRayfireMapObject(cabin, 6)
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(glassCabinets) do
        exports.ft_libs:AddTrigger("vangelico_cabinet_" .. k, {x = v.coords.x, y = v.coords.y, z = v.coords.z, weight = 1.0, height = 2,
        enter = {eventClient = "vangelicoEnteredMarker"}, exit = {eventClient = "vangelicoExitedMarker"}, data = k, active = {}})
    end
end)

local currentCabinetIndex = 0

AddEventHandler("vangelicoEnteredMarker", function(cabinetIndex)
    currentCabinetIndex = cabinetIndex

    Citizen.CreateThread(function()
        while currentCabinetIndex ~= 0 do
            local cabinet, cabin
            local _, weapon = GetCurrentPedWeapon(PlayerPedId())
            local weapInfo, weapName = ESX.GetWeaponFromHash(weapon)

            if weapInfo == nil then
                goto final
            end

            cabinet = glassCabinets[currentCabinetIndex]
            cabin = GetRayfireMapObject(cabinet.coords.x, cabinet.coords.y, cabinet.coords.z, 1.0, cabinet.cabinetProp)

            if GetStateOfRayfireMapObject(cabin) >= 6 then
                goto final
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if not IsControlPressed(0, 38) then
                goto final
            end

            if not heist.validWeapons[weapName] then
                ESX.ShowNotification(T("VANGELICO_WEAPON_CANT_SMASH"), "error")
                goto final
            end

            TriggerServerEvent("cframework:prepareSmashVangelicoCabinet", currentCabinetIndex)
            currentCabinetIndex = 0

            ::final::

            Citizen.Wait(0)
        end
    end)
end)

AddEventHandler("vangelicoExitedMarker", function()
    currentCabinetIndex = 0
end)
