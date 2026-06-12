

local defaultDrifVehicleHandlings = {}

function EnableDriftHandling(vehicle, enable)
    if enable then
        if defaultDrifVehicleHandlings[vehicle] == nil then defaultDrifVehicleHandlings[vehicle] = {} end
        if defaultDrifVehicleHandlings[vehicle].enabled then return end

        defaultDrifVehicleHandlings[vehicle].fDriveBiasFront = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront")
        defaultDrifVehicleHandlings[vehicle].fBrakeBiasFront = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront")
        defaultDrifVehicleHandlings[vehicle].fHandBrakeForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce")
        defaultDrifVehicleHandlings[vehicle].fSteeringLock = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock")
        defaultDrifVehicleHandlings[vehicle].fTractionCurveMax = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax")
        defaultDrifVehicleHandlings[vehicle].fTractionCurveMin = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin")
        defaultDrifVehicleHandlings[vehicle].fTractionCurveLateral = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral")
        defaultDrifVehicleHandlings[vehicle].fTractionSpringDeltaMax = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionSpringDeltaMax")
        defaultDrifVehicleHandlings[vehicle].fLowSpeedTractionLossMult = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult")
        defaultDrifVehicleHandlings[vehicle].fCamberStiffnesss = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fCamberStiffnesss")
        defaultDrifVehicleHandlings[vehicle].fTractionBiasFront = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionBiasFront")
        defaultDrifVehicleHandlings[vehicle].fTractionLossMult = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionLossMult")
        defaultDrifVehicleHandlings[vehicle].fAntiRollBarForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarForce")
        defaultDrifVehicleHandlings[vehicle].fAntiRollBarBiasFront = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarBiasFront")
        defaultDrifVehicleHandlings[vehicle].fInitialDragCoeff = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff")
        defaultDrifVehicleHandlings[vehicle].fInitialDriveForce = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce")
        defaultDrifVehicleHandlings[vehicle].fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel")

        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront", 0.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront", 0.670000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", 3.500000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock", 65.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", 1.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin", 1.450000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral", 40.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionSpringDeltaMax", 0.150000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", 0.100000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fCamberStiffnesss", 0.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionBiasFront", 0.450000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionLossMult", 1.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarForce", 0.210000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarBiasFront", 0.560000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff", 9.50000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", 3.000000)
        SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", 180.000000)

        defaultDrifVehicleHandlings[vehicle].enabled = true
    else
        if defaultDrifVehicleHandlings[vehicle] then
            if not defaultDrifVehicleHandlings[vehicle].enabled then return end

            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fDriveBiasFront", defaultDrifVehicleHandlings[vehicle].fDriveBiasFront)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fBrakeBiasFront", defaultDrifVehicleHandlings[vehicle].fBrakeBiasFront)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fHandBrakeForce", defaultDrifVehicleHandlings[vehicle].fHandBrakeForce)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fSteeringLock", defaultDrifVehicleHandlings[vehicle].fSteeringLock)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMax", defaultDrifVehicleHandlings[vehicle].fTractionCurveMax)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveMin", defaultDrifVehicleHandlings[vehicle].fTractionCurveMin)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionCurveLateral", defaultDrifVehicleHandlings[vehicle].fTractionCurveLateral)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionSpringDeltaMax", defaultDrifVehicleHandlings[vehicle].fTractionSpringDeltaMax)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fLowSpeedTractionLossMult", defaultDrifVehicleHandlings[vehicle].fLowSpeedTractionLossMult)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fCamberStiffnesss", defaultDrifVehicleHandlings[vehicle].fCamberStiffnesss)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionBiasFront", defaultDrifVehicleHandlings[vehicle].fTractionBiasFront)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fTractionLossMult", defaultDrifVehicleHandlings[vehicle].fTractionLossMult)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarForce", defaultDrifVehicleHandlings[vehicle].fAntiRollBarForce)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fAntiRollBarBiasFront", defaultDrifVehicleHandlings[vehicle].fAntiRollBarBiasFront)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDragCoeff", defaultDrifVehicleHandlings[vehicle].fInitialDragCoeff)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveForce", defaultDrifVehicleHandlings[vehicle].fInitialDriveForce)
            SetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel", defaultDrifVehicleHandlings[vehicle].fInitialDriveMaxFlatVel)

            defaultDrifVehicleHandlings[vehicle].enabled = false
        end
    end
end


RegisterNetEvent("ft_libs:enteredVehicle", function()
    local vehicle <const> = GetVehiclePedIsIn(PlayerPedId(), true)
    local driftTyres <const> = GetDriftTyresEnabled(vehicle)

    EnableDriftHandling(vehicle, driftTyres)
end)
