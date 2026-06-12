

local isFpsOtimizationEnabled = false

RegisterNetEvent('cframework:enableFpsOtimization', function()
    if isFpsOtimizationEnabled then
        return
    end

    isFpsOtimizationEnabled = true

    RopeDrawShadowEnabled(false)

    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(false)
    CascadeShadowsEnableEntityTracker(true)
    CascadeShadowsSetDynamicDepthMode(false)
    CascadeShadowsSetEntityTrackerScale(0.0)
    CascadeShadowsSetDynamicDepthValue(0.0)
    CascadeShadowsSetCascadeBoundsScale(0.0)

    SetFlashLightFadeDistance(5.0)
    SetLightsCutoffDistanceTweak(5.0)
    --DistantCopCarSirens(false)
    --SetTimecycleModifier("cinema")
end)

RegisterNetEvent('cframework:disableFpsOtimization', function()
    if not isFpsOtimizationEnabled then
        return
    end

    isFpsOtimizationEnabled = false

    RopeDrawShadowEnabled(true)

    CascadeShadowsSetAircraftMode(true)
    CascadeShadowsEnableEntityTracker(false)
    CascadeShadowsSetDynamicDepthMode(true)
    CascadeShadowsSetEntityTrackerScale(5.0)
    CascadeShadowsSetDynamicDepthValue(5.0)
    CascadeShadowsSetCascadeBoundsScale(5.0)

    SetFlashLightFadeDistance(10.0)
    SetLightsCutoffDistanceTweak(10.0)
    --DistantCopCarSirens(true)
    SetArtificialLightsState(false)
    --ClearTimecycleModifier()
end)

Citizen.CreateThread(function()
    while true do
        if isFpsOtimizationEnabled then
            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            OverrideLodscaleThisFrame(0.6)
            SetArtificialLightsState(true)
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(0)
    end
end)