-- FiveM Heli Cam by davwheat and mraes
-- Version 2.0 05-11-2018 (DD-MM-YYYY)
-- config
local fov_max = 110
local fov_min = 7.5 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)
local minHeightAboveGround = 1.5 -- default: 1.5. Minimum height above ground to activate Heli Cam (in metres). Should be between 1 and 20.

-- Script starts here
local helicam = false -- is in helicam
local allowedHelis = {`2vd_supervolito`, `2vd_bmaverick`, `2vd_annihilator`, `2vd_conada`}
local fov = (fov_max + fov_min) * 0.5
local vision_state = 0 -- 0 is normal, 1 is night vision, 2 is thermal vision
local spotlight_state = false

local currentPlayerId = GetPlayerServerId(PlayerId())
local letSleep = true


local function IsPlayerInPolmav()
    local vehicle <const> = GetVehiclePedIsIn(PlayerPedId(), false)

    for _, hash in ipairs(allowedHelis) do
        if IsVehicleModel(vehicle, hash) then
            return true
        end
    end

    return false
end

local function IsHeliHighEnough(heli)
    return GetEntityHeightAboveGround(heli) > minHeightAboveGround
end

local function ChangeVision()
    if vision_state == 0 then
        SetNightvision(true)
        vision_state = 1
    elseif vision_state == 1 then
        SetNightvision(false)
        SetSeethrough(true)
        vision_state = 2
    else
        SetSeethrough(false)
        vision_state = 0
    end
end

local function HideHUDThisFrame()
    HideHelpTextThisFrame()
    HideHudAndRadarThisFrame()
    HideHudComponentThisFrame(1) -- Wanted Stars
    HideHudComponentThisFrame(2) -- Weapon icon
    HideHudComponentThisFrame(3) -- Cash
    HideHudComponentThisFrame(4) -- MP CASH
    HideHudComponentThisFrame(7) -- Area Name
    HideHudComponentThisFrame(8) -- Vehicle Class
    HideHudComponentThisFrame(9) -- Street Name
    HideHudComponentThisFrame(11) -- Floating Help Text
    HideHudComponentThisFrame(12) -- more floating help text
    HideHudComponentThisFrame(13) -- Cash Change
    HideHudComponentThisFrame(15) -- Subtitle Text
    HideHudComponentThisFrame(18) -- Game Stream
    HideHudComponentThisFrame(19) -- weapon wheel
    HideHudComponentThisFrame(21) -- weapon wheel
end

local function CheckInputRotation(cam, zoomvalue)
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
        local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end
end

local function RotAnglesToVec(rot) -- input vector3
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

local function HandleZoom(cam)
    if IsControlJustPressed(0, 241) then -- Scrollup
        fov = math.max(fov - zoomspeed, fov_min)
    end
    if IsControlJustPressed(0, 242) then
        fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05) -- Smoothing of camera zoom
end

local function GetVehicleInView(cam)
    local coords = GetCamCoord(cam)
    local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
    -- DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    local rayhandle = StartExpensiveSynchronousShapeTestLosProbe(coords, coords + (forward_vector * 350.0), 10, GetVehiclePedIsIn(PlayerPedId(), false), 0)
    local _, _, _, _, entityHit = GetShapeTestResult(rayhandle)
    if entityHit > 0 and IsEntityAVehicle(entityHit) then
        return entityHit
    else
        return nil
    end
end

local function HandleSpotlight(cam)
    if IsControlJustPressed(0, toggle_spotlight) then
        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
        spotlight_state = not spotlight_state

        if spotlight_state then
            TriggerServerEvent("heli:spotlight_on", currentPlayerId, 0)
        else
            TriggerServerEvent("heli:spotlight_off", currentPlayerId, 0)
        end
    end
    if spotlight_state then
        local rotation = GetCamRot(cam, 2)
        local forward_vector = RotAnglesToVec(rotation)
        local camcoords = GetCamCoord(cam)
        ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
        DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 0.5, 0.5, 7.50, 75.0)

        TriggerServerEvent("heli:spotlight_update", currentPlayerId, {
            comcoords = camcoords,
            forward_vector = forward_vector
        })
    end
end

Citizen.CreateThread(function()
    while true do
        letSleep = true
        Citizen.Wait(0)
        if IsPlayerInPolmav() then
            letSleep = false
            local lPed = PlayerPedId()
            local heli = GetVehiclePedIsIn(lPed, false)

            if IsHeliHighEnough(heli) then
                if IsControlJustPressed(0, toggle_helicam) and not helicam then -- Toggle Helicam
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    helicam = true
                end

                if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
                    if GetPedInVehicleSeat(heli, 1) == lPed or
                        GetPedInVehicleSeat(heli, 2) == lPed then
                        PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                        TaskRappelFromHeli(lPed, 1)
                    else
                        ESX.ShowNotification("Não podes fazer rapel neste lugar", "error")
                        PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
                    end
                end
            end

            if IsControlJustPressed(0, toggle_spotlight) and
                GetPedInVehicleSeat(heli, -1) == lPed then
                spotlight_state = not spotlight_state
                --TriggerServerEvent("heli:spotlight", spotlight_state)
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
            end
        end

        if helicam then
            letSleep = false

            -- SetTimecycleModifier("heliGunCam")
            -- SetTimecycleModifierStrength(0.3)
            local scaleform = RequestScaleformMovie("DRONE_CAM")
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end

            local lPed = PlayerPedId()
            local heli = GetVehiclePedIsIn(lPed, false)
            local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
            AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)

            ---@diagnostic disable-next-line: missing-parameter
            SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
            SetCamFov(cam, fov)
            RenderScriptCams(true, false, 0, true, false)

            -- BeginScaleformMovieMethod(scaleform, "SET_LOCATION")
            -- ScaleformMovieMethodAddParamInt(0)
            -- EndScaleformMovieMethod()

            local locked_on_vehicle = nil
            while helicam and not IsEntityDead(lPed) and
                (GetVehiclePedIsIn(lPed, false) == heli) and IsHeliHighEnough(heli) do
                if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    helicam = false
                    --SendNUIMessage({type = 'hide'})
                end
                if IsControlJustPressed(0, toggle_vision) then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                    ChangeVision()
                end

                DisableControlAction(0, 75, true) -- disable exit vehicle
                DisableControlAction(27, 75, true) -- disable exit vehicle

                if locked_on_vehicle then
                    if DoesEntityExist(locked_on_vehicle) then

                        PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
                        if IsControlJustPressed(0, toggle_lock_on) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            locked_on_vehicle = nil
                            local oldRot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
                            local oldFov = GetCamFov(cam)
                            DestroyCam(cam, false)
                            cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
                            AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
                            ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
                            SetCamRot(cam, oldRot, 2)
                            SetCamFov(cam, oldFov)
                            RenderScriptCams(true, false, 0, true, false)
                        end
                    else
                        locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
                    end
                else
                    local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
                    CheckInputRotation(cam, zoomvalue)
                    local vehicle_detected = GetVehicleInView(cam)

                    if vehicle_detected ~= nil and DoesEntityExist(vehicle_detected) then
                        if IsControlJustPressed(0, toggle_lock_on) then
                            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                            locked_on_vehicle = vehicle_detected
                        end
                    end
                end
                HandleZoom(cam)
                HideHUDThisFrame()

                HandleSpotlight(cam)

                BeginScaleformMovieMethod(scaleform, "SET_DISPLAY_CONFIG")
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamInt(0)
                ScaleformMovieMethodAddParamFloat(0.0)
                ScaleformMovieMethodAddParamFloat(0.0)
                ScaleformMovieMethodAddParamFloat(0.0)
                ScaleformMovieMethodAddParamFloat(0.0)
                ScaleformMovieMethodAddParamBool(true)
                ScaleformMovieMethodAddParamBool(true)
                ScaleformMovieMethodAddParamBool(false)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(scaleform, "SET_ALT_FOV_HEADING")
                ScaleformMovieMethodAddParamFloat(GetEntityCoords(heli).z)
                ScaleformMovieMethodAddParamFloat(0.0)--zoomvalue)
                ScaleformMovieMethodAddParamFloat(GetCamRot(cam, 2).z)
                EndScaleformMovieMethod()

                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0.0)

                Citizen.Wait(0)
            end
            helicam = false
            -- ClearTimecycleModifier()
            fov = (fov_max + fov_min) * 0.5 -- reset to starting zoom level
            RenderScriptCams(false, false, 0, true, false) -- Return to gameplay camera
            SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
            DestroyCam(cam, false)
            SetNightvision(false)
            SetSeethrough(false)

            vision_state = 0
            spotlight_state = false
        end

        if letSleep then
            Citizen.Wait(1000)
        end
    end
end)

local spotlights = {}
local letSpotlightsSleep = true

Citizen.CreateThread(function()
    while true do
        letSpotlightsSleep = true
        if spotlights then
            for key, value in pairs(spotlights) do
                if value.enabled and key ~= currentPlayerId and value.camcoords ~= nil and value.forward_vector ~= nil then
                    letSpotlightsSleep = false
                    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
                    DrawSpotLight(value.camcoords, value.forward_vector, 255, 255, 255, 300.0, 0.5, 0.5, 7.50, 75.0)
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)

        if letSpotlightsSleep then
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent("heli:spotlight_on", function(playerId)
    spotlights[playerId] = {
        camcoords = nil,
        forward_vector = nil,
        enabled = true
    }
end)

RegisterNetEvent("heli:spotlight_off", function(playerId)
    spotlights[playerId] = nil
end)

RegisterNetEvent("heli:spotlight_update", function(playerId, data)
    spotlights[playerId].camcoords = data.comcoords;
    spotlights[playerId].forward_vector = data.forward_vector;
end)
