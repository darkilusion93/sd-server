


local showingRadar = false
local frontMaxSpeed, rearMaxSpeed = 0, 0
local bvspeed, fvspeed = 0, 0
local bplate, fplate = "", ""

local function drawRadar()
	while showingRadar do
		Citizen.Wait(50)

        local veh <const> = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local vspeed <const> = GetEntitySpeed(veh)*3.6
        local coordA <const> = GetOffsetFromEntityInWorldCoords(veh, 0.0, 1.0, 1.0)
        local coordB <const> = GetOffsetFromEntityInWorldCoords(veh, 0.0, 105.0, 0.0)
        local frontcar <const> = StartShapeTestCapsule(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z, 3.0, 10, veh, 7)
        local _,_,_,_, frontVehicle <const> = GetShapeTestResult(frontcar)

        if IsEntityAVehicle(frontVehicle) then
            fvspeed = GetEntitySpeed(frontVehicle)*3.6
            fplate = GetVehicleNumberPlateText(frontVehicle)
            --local fplateStyle = GetVehicleNumberPlateTextIndex(frontVehicle)
        end

        local bcoordB <const> = GetOffsetFromEntityInWorldCoords(veh, 0.0, -105.0, 0.0)
        local rearcar <const> = StartShapeTestCapsule(coordA.x, coordA.y, coordA.z, bcoordB.x, bcoordB.y, bcoordB.z, 3.0, 10, veh, 7)
        local _,_,_,_, rearVehicle <const> = GetShapeTestResult(rearcar)

        if IsEntityAVehicle(rearVehicle) then
            bvspeed = GetEntitySpeed(rearVehicle)*3.6
            bplate = GetVehicleNumberPlateText(rearVehicle)
            --local bplateStyle = GetVehicleNumberPlateTextIndex(rearVehicle)
        end

        if fvspeed > frontMaxSpeed then
            frontMaxSpeed = fvspeed
        end

        if bvspeed > rearMaxSpeed then
            rearMaxSpeed = bvspeed
        end

        SendNUIMessage({
            action = "updateRadar",
            speedFront = math.floor(fvspeed),
            speedBack = math.floor(bvspeed),
            speed = math.floor(vspeed),
            plateFront = fplate,
            plateBack = bplate,
            maxSpeedFront = math.floor(frontMaxSpeed),
            maxSpeedBack = math.floor(rearMaxSpeed)
        })

		if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			showingRadar = false
            SendNUIMessage({
                action = "toggleRadar",
                show = false
            })
		end
	end
end

RegisterKeyMapping('radar', 'Radar', 'keyboard', 'numpad5')
RegisterCommand("radar", function(source, args, rawCommand)
    if IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) then
        if showingRadar then
            showingRadar = false
            SendNUIMessage({
                action = "toggleRadar",
                show = false
            })
        else
            showingRadar = true

            frontMaxSpeed, rearMaxSpeed = 0, 0
            bvspeed, fvspeed = 0, 0
            bplate, fplate = "", ""

            SendNUIMessage({
                action = "toggleRadar",
                show = true
            })
        end
    end

    if not showingRadar then
        return
    end

    Citizen.CreateThread(function()
        drawRadar()
    end)
end, false)
