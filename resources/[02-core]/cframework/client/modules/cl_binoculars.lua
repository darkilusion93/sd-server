local PlayerIsReady, EnterAnimIsStarted, EnterAnimIsPlayed, BaseAnimIsPlayed, ExitAnimIsStarted, ExitAnimIsPlayed, ObjectCreated, CamCreated, ScaleformRequested = 0, 0, 0, 0, 0, 0, 0, 0, 0
local CurrentWeapon, ZoomSound, BinocularsCamera, CamFov, Scaleform

Citizen.CreateThread(function()
    while true do
        OnBinocularsTick()
        HandleBinocularsKeys()
        Citizen.Wait(0)
    end
end)

function OnBinocularsTick()
    EnterBinocularsAnimStarting()
    EnterBinocularsAnimPlaying()
    BaseBinocularsAnimPlaying()
    BinocularsExitAnimPlaying()
    BinocularsAnimReset()
    BinocularsObject()
    BinocularsCamHandler()
    RequestBinocularsScaleformMovie()
    BinocularsScaleformMovie()
    BinocularsSound()
    BinocularsPlayerHeading()
    CancelBinoculars()
    BinocularsPlayerControl()
end

function HandleBinocularsKeys()
    if PlayerIsReady == 0 then
        return
    end

    if IsControlPressed(0, 38) or IsDisabledControlPressed(0, 38) or IsControlPressed(0, 177) or IsDisabledControlPressed(0, 177) then
        ExitAnimStarting()
    end
end

RegisterNetEvent("cframework:useBinoculars", function()
    if PlayerIsReady == 0 then
        GetPlayerReady()
        return
    end

    ExitAnimStarting()
end)

local function canPlayerGetReady()
    return PlayerIsReady == 0 and not IsPlayerCamControlDisabled() and UpdateOnscreenKeyboard() ~= 0 and IsPlayerFreeForAmbientTask(PlayerId()) and not IsCutsceneActive() and
    not IsCutscenePlaying() and not IsMissionCompletePlaying() and not IsPlayerInCutscene(PlayerId()) and not IsMinigameInProgress() and
    not IsPlayerDead(PlayerId()) and not IsPlayerBeingArrested(PlayerId(), true) and IsPlayerPlaying(PlayerId()) and not IsPedRagdoll(PlayerPedId()) and
    not IsPedRunningRagdollTask(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) and
    not IsPedClimbing(PlayerPedId()) and not IsPedVaulting(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedJumping(PlayerPedId()) and
    not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedGoingIntoCover(PlayerPedId()) and not IsPedInCover(PlayerPedId(), false) and
    not IsPedInMeleeCombat(PlayerPedId()) and not IsPlayerFreeAiming(PlayerId()) and not IsPlayerTargettingAnything(PlayerId()) and not IsPedShooting(PlayerPedId()) and
    not IsEntityOnFire(PlayerPedId()) and not IsPedReloading(PlayerPedId()) and not IsPedPlantingBomb(PlayerPedId()) and
    not IsPedRunningMobilePhoneTask(PlayerPedId()) and not IsPlayingPhoneGestureAnim(PlayerPedId()) and not IsPedInAnyVehicle(PlayerPedId(), true) and
    not IsPedSittingInAnyVehicle(PlayerPedId()) and not IsPedGettingIntoAVehicle(PlayerPedId())
end

function GetPlayerReady()
    if canPlayerGetReady() then
        local _, currentWeapon = GetCurrentPedWeapon(PlayerPedId(), true)

        if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
            CurrentWeapon = currentWeapon

            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
        end

        if IsPedWearingHelmet(PlayerPedId()) then
            RemovePlayerHelmet(PlayerId(), true)
        end

        PlayerIsReady = 1
    end
end

function EnterBinocularsAnimStarting()
    if PlayerIsReady == 1 and EnterAnimIsStarted == 0 then
        --SetPlayerControl(PlayerId(), false, 256)
        RequestAnimDict("oddjobs@hunter")

        while not HasAnimDictLoaded("oddjobs@hunter") do
            Citizen.Wait(50)
        end

        local taskSequenceId = OpenSequenceTask()
        TaskPlayAnim(0, "oddjobs@hunter", "binoculars_intro", 8.0, -8.0, -1, 16, 0.0, false, false, false)
        TaskPlayAnim(0, "oddjobs@hunter", "binoculars_loop", 8.0, -8.0, -1, 17, 0.0, false, false, false)

        CloseSequenceTask(taskSequenceId)
        TaskPerformSequence(PlayerPedId(), taskSequenceId)
        EnterAnimIsStarted = 1
    end
end

function EnterBinocularsAnimPlaying()
    if EnterAnimIsStarted == 1 and EnterAnimIsPlayed == 0 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_intro", 3) then
        EnterAnimIsPlayed = 1
    end
end

function BaseBinocularsAnimPlaying()
    if EnterAnimIsStarted == 1 and BaseAnimIsPlayed == 0 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_loop", 3) then
        BaseAnimIsPlayed = 1
    end
end

function ExitAnimStarting()
    if PlayerIsReady == 1 and EnterAnimIsStarted == 1 and ExitAnimIsStarted == 0 and ObjectCreated == 1 then
        --SetPlayerControl(PlayerId(), true, 256)
        TaskPlayAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_outro", 8.0, -8.0, -1, 16, 0.0, false, false, false)
        ExitAnimIsStarted = 1
    end
end

function BinocularsExitAnimPlaying()
    if ExitAnimIsStarted == 1 and ExitAnimIsPlayed == 0 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_outro", 3) then
        ExitAnimIsPlayed = 1
    end
end

function BinocularsAnimReset()
    if PlayerIsReady == 1 and EnterAnimIsStarted == 1 and ExitAnimIsStarted == 1 and
    not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_intro", 3) and
    not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_loop", 3) and 
    not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_outro", 3) then
        SetCurrentPedWeapon(PlayerPedId(), CurrentWeapon, true)
        PlayerIsReady = 0
        EnterAnimIsStarted = 0
        EnterAnimIsPlayed = 0
        BaseAnimIsPlayed = 0
        ExitAnimIsStarted = 0
        ExitAnimIsPlayed = 0
    end
end

function BinocularsObject()
	if EnterAnimIsStarted == 1 and ObjectCreated == 0 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_intro", 3) and
    GetEntityAnimCurrentTime(PlayerPedId(), "oddjobs@hunter", "binoculars_intro") > 0.242 then
        TriggerEvent("attachItem", "binoculars01")

        ObjectCreated = 1
    end

    if ExitAnimIsStarted == 1 and ObjectCreated == 1 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_outro", 3) and
    GetEntityAnimCurrentTime(PlayerPedId(), "oddjobs@hunter", "binoculars_outro") > 0.5 then
        TriggerEvent("destroyProp")
        ObjectCreated = 0
    end
end

function BinocularsCamHandler()
    if EnterAnimIsStarted == 1 and ExitAnimIsStarted == 0 and IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_intro", 3) and
    GetEntityAnimCurrentTime(PlayerPedId(), "oddjobs@hunter", "binoculars_intro") > 0.5 and CamCreated == 0 then
        local num = GetEntityHeading(PlayerPedId())
        local vector = GetEntityCoords(PlayerPedId(), true)

        if not DoesCamExist(BinocularsCamera) then
            BinocularsCamera = CreateCam("SNIPER_AIM_CAMERA", false)
        end

        SetCamCoord(BinocularsCamera, vector.x, vector.y, vector.z + 0.6)

        if GetCamViewModeForContext(0) == 4 then
            SetCamRot(BinocularsCamera, 0.0, 0.0, num - 360.0, 2)
        else
            SetCamRot(BinocularsCamera, 0.0, 0.0, num - 360.0, 2)
        end

        SetCamFov(BinocularsCamera, GetGameplayCamFov())

        if not IsCamActive(BinocularsCamera) then
            SetCamActive(BinocularsCamera, true)
        end

        RenderScriptCams(true, false, 3000, true, false)
        ZoomSound = GetSoundId()
        CamCreated = 1
    end

    if ExitAnimIsStarted == 1 and CamCreated == 1 then
        if GetCamViewModeForContext(0) == 4 then
            local vector2 <const> = GetCamRot(BinocularsCamera, 2)
            SetEntityRotation(PlayerPedId(), 0.0, 0.0, vector2.z, 2, true)
            SetGameplayCamRawYaw(0.0)
            SetGameplayCamRawPitch(vector2.x)
        else
            local vector2 <const> = GetCamRot(BinocularsCamera, 2)
            SetEntityRotation(PlayerPedId(), 0.0, 0.0, vector2.z, 2, true)
            SetGameplayCamRelativeHeading(0.0)
        end

        RenderScriptCams(false, false, 3000, true, false)

        if IsCamActive(BinocularsCamera) then
            SetCamActive(BinocularsCamera, false)
            DestroyCam(BinocularsCamera, true)
        end

        CamCreated = 0
    end
end

function RequestBinocularsScaleformMovie()
    if ScaleformRequested == 0 and not HasScaleformMovieLoaded(Scaleform) then
        Scaleform = RequestScaleformMovie("binoculars")
        ScaleformRequested = 1
    end
end

function BinocularsScaleformMovie()
    if CamCreated == 1 then
        if IsHelpMessageBeingDisplayed() then
            HideHelpTextThisFrame()
        end

        HideHudAndRadarThisFrame()

        if HasScaleformMovieLoaded(Scaleform) then
            DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 0, 0)
        end
    end
end

function BinocularsSound()
    if CamCreated == 1 then
        if IsControlPressed(0, 42) or IsDisabledControlPressed(0, 42) or IsControlPressed(0, 43) or IsDisabledControlPressed(0, 43) then
            CamFov = GetCamFov(BinocularsCamera)

            if CamFov > 5.0 and CamFov < 45.0 then
                if HasSoundFinished(ZoomSound) then
                    PlaySoundFrontend(ZoomSound, "Camera_Zoom", "Phone_Soundset_Default", true)
                    return
                end
            elseif not HasSoundFinished(ZoomSound) then
                StopSound(ZoomSound)
                return
            end
        elseif not HasSoundFinished(ZoomSound) then
            StopSound(ZoomSound)
            return
        end
    elseif not HasSoundFinished(ZoomSound) then
        StopSound(ZoomSound)
    end
end

function BinocularsPlayerHeading()
    if CamCreated == 1 and GetEntityRotation(PlayerPedId(), 2).z ~= GetCamRot(BinocularsCamera, 2).z then
        local vector <const> = GetCamRot(BinocularsCamera, 2)
        SetEntityHeading(PlayerPedId(), vector.z)
    end
end

function CancelBinoculars()
    if PlayerIsReady == 1 then
        if EnterAnimIsStarted == 1 and EnterAnimIsPlayed == 1 and BaseAnimIsPlayed == 0 and ExitAnimIsStarted == 0 and ExitAnimIsPlayed == 0 and not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_intro", 3) then
            ResetSettings()
        end

        if BaseAnimIsPlayed == 1 and ExitAnimIsStarted == 0 and ExitAnimIsPlayed == 0 and not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_loop", 3) then
            ResetSettings()
        end

        if ExitAnimIsStarted == 1 and ExitAnimIsPlayed == 1 and not IsEntityPlayingAnim(PlayerPedId(), "oddjobs@hunter", "binoculars_outro", 3) then
            ResetSettings()
        end

        if IsPlayerDead(PlayerId()) or IsPlayerBeingArrested(PlayerId(), true) then
            ResetSettings()
        end

        if IsPedRagdoll(PlayerPedId()) or IsPedRunningRagdollTask(PlayerPedId()) then
            ClearPedTasks(PlayerPedId())
            ResetSettings()
        end

        if IsPedSwimming(PlayerPedId()) or IsPedFalling(PlayerPedId()) or IsPedClimbing(PlayerPedId()) or IsPedVaulting(PlayerPedId()) or IsPedDiving(PlayerPedId()) or IsPedInMeleeCombat(PlayerPedId()) then
            ClearPedTasks(PlayerPedId())
            ResetSettings()
        end
    end
end

function ResetSettings()
    if ObjectCreated == 1 then
        TriggerEvent("destroyProp")
        ObjectCreated = 0
    end

    if CamCreated == 1 then
        if GetCamViewModeForContext(0) == 4 then
            local vector = GetCamRot(BinocularsCamera, 2)

            SetEntityRotation(PlayerPedId(), 0.0, 0.0, vector.z, 2, true)
            SetGameplayCamRawYaw(0.0)
            SetGameplayCamRawPitch(vector.x)
        else
            local vector = GetCamRot(BinocularsCamera, 2)

            SetEntityRotation(PlayerPedId(), 0.0, 0.0, vector.z, 2, true)
            SetGameplayCamRelativeHeading(0.0)
        end

        RenderScriptCams(false, false, 3000, true, false)

        if IsCamActive(BinocularsCamera) then
            SetCamActive(BinocularsCamera, false)
            DestroyCam(BinocularsCamera, true)
        end

        CamCreated = 0
    end

    --SetPlayerControl(PlayerId(), true, 256)

    PlayerIsReady = 0
    EnterAnimIsStarted = 0
    EnterAnimIsPlayed = 0
    BaseAnimIsPlayed = 0
    ExitAnimIsStarted = 0
    ExitAnimIsPlayed = 0
end

function BinocularsPlayerControl()
    if CamCreated == 1 then
        DisableControlAction(2, 0, true)
    end
end
