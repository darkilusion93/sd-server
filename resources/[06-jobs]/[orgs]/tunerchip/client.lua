local menu = false
ESX = nil

function getVehData(veh)
    if not DoesEntityExist(veh) then return nil end
    local lvehstats = {
        boost = GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce"),
        fuelmix = GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia"),
        braking = GetVehicleHandlingFloat(veh ,"CHandlingData", "fBrakeBiasFront"),
        drivetrain = GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront"),
        brakeforce = GetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce")
    }
    return lvehstats
end

function setVehData(veh,data)
    if not DoesEntityExist(veh) or not data then return nil end
	if GetVehicleClass(veh) == 8 then

		SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost*0.75)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.fuelmix*0.75)
		SetVehicleEnginePowerMultiplier(veh, data.gearchange*0.75)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.braking*1.0)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", data.drivetrain*1.0)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce", data.brakeforce*0.8)	
	
	else
	
		SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost*0.95)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.fuelmix*0.95)
		SetVehicleEnginePowerMultiplier(veh, data.gearchange*0.95)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.braking*1.0)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", data.drivetrain*1.0)
		SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce", data.brakeforce*1.0)
	
	end
	--SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff", GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff")*1.2)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function toggleMenu(b,send)
    menu = b
    SetNuiFocus(b,b)
    local vehData = getVehData(GetVehiclePedIsIn(GetPlayerPed(-1),false))
    if send then SendNUIMessage(({type = "togglemenu", state = b, data = vehData})) end
end

RegisterNUICallback("togglemenu",function(data,cb)
    toggleMenu(data.state,false)
end)

RegisterNUICallback("save",function(data,cb)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    if not IsPedInAnyVehicle(GetPlayerPed(-1)) or GetPedInVehicleSeat(veh, -1)~=GetPlayerPed(-1) then return end
    setVehData(veh,data)
	TriggerServerEvent('tuning:SetData',data,ESX.Game.GetVehicleProperties(veh))
    lastVeh = veh
    lastStats = stats
end)

RegisterNUICallback("reset",function(data,cb)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    if not IsPedInAnyVehicle(GetPlayerPed(-1)) or GetPedInVehicleSeat(veh, -1)~=GetPlayerPed(-1) then return end
    TriggerServerEvent('tuning:SetData',"",ESX.Game.GetVehicleProperties(veh))
end)

RegisterNetEvent("tuning:useLaptop")
AddEventHandler("tuning:useLaptop", function()
    if not menu then
        --TriggerEvent('esx_inventoryhud:doClose')
        Citizen.Wait(3000)
        local ped = GetPlayerPed(-1)
        toggleMenu(true,true)
        while IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1)==ped do
            Citizen.Wait(100)
        end
        toggleMenu(false,true)
    else
        return
    end
end)

RegisterNetEvent("tuning:closeMenu")
AddEventHandler("tuning:closeMenu",function()
    toggleMenu(false,true)
end)

local lastVeh = false
local lastData = false
local gotOut = false
--Citizen.CreateThread(function(...)
--    while not ESX do Citizen.Wait(0); end
--    while not ESX.IsPlayerLoaded() do Citizen.Wait(0); end
--    while true do
--        Citizen.Wait(30)
--        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
--            local veh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
--            if veh ~= lastVeh or gotOut then
--                if gotOut then gotOut = false; end
--                local responded = false
--                ESX.TriggerServerCallback('tuning:CheckStats', function(doTune,stats)
--                    if doTune then
--                        Citizen.Wait(2000)
--						if IsPedInAnyVehicle(GetPlayerPed(-1)) then
--							setVehData(veh,stats)
--							lastStats = stats
--						else
--							gotOut = true
--						end
--                    else
--                        if lastVeh and veh and lastVeh == veh and lastData then
--                            setVehData(veh,lastData)
--						else
--							--SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDragCoeff", 120.0)
--							--SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", GetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce")*0.7)
--							--SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", GetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia")*0.7)
--							--ModifyVehicleTopSpeed(veh, -4.0)
--                        end
--                    end
--
--                    lastVeh = veh
--                    responded = true
--                end, ESX.Game.GetVehicleProperties(veh))
--                while not responded do Citizen.Wait(0); end
--            end
--        else
--            if not gotOut then
--                gotOut = true
--            end
--        end
--    end
--end)

RegisterNetEvent("tuning:APLICAR")
AddEventHandler("tuning:APLICAR", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			Citizen.Wait(5000)
			local ped = PlayerPedId()
			local veh = GetVehiclePedIsIn(ped)
			local seat = GetPedInVehicleSeat(veh, -1)		
			if seat == ped and veh ~= nil then
				ESX.TriggerServerCallback('tuning:CheckStats', function(doTune,stats)
					if doTune then
						if IsPedInAnyVehicle(GetPlayerPed(-1)) then
							local veh1 = GetVehiclePedIsIn(ped)
							local seat1 = GetPedInVehicleSeat(veh1, -1)		
							if seat1 == ped then
								setVehData(veh,stats)
								--print('REPRO APLICADA')
							end
						end
					end
				end, ESX.Game.GetVehicleProperties(veh))
			end
	end

end)