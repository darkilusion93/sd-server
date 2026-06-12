-- BELOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE! --
local useBilling = true -- OPTIONS: (true/false)
local useCameraSound = false -- OPTIONS: (true/false)
local useFlashingScreen = false -- OPTIONS: (true/false)
local useBlips = true -- OPTIONS: (true/false)
local alertPolice = false -- OPTIONS: (true/false)
local alertSpeed = 150 -- OPTIONS: (1-5000 KMH)

local defaultPrice60 = 1000 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 60 ZONES
local defaultPrice80 = 2000 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 80 ZONES
local defaultPrice120 = 4000 -- THIS IS THE DEFAULT PRICE WITHOUT EXTRA COST FOR 120 ZONES

local extraZonePrice10 = 1000 -- THIS IS THE EXTRA COST IF 10 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice20 = 2000 -- THIS IS THE EXTRA COST IF 20 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
local extraZonePrice30 = 3000 -- THIS IS THE EXTRA COST IF 30 KM/H ABOVE LIMIT (REQUIRES "useBilling" to be set to true)
-- ABOVE IS YOUR SETTINGS, CHANGE THEM TO WHATEVER YOU'D LIKE & MORE SETTINGS WILL COME IN THE FUTURE!  --

ESX = nil
local hasBeenCaught = false
local finalBillingPrice = 0;

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- BLIP FOR SPEEDCAMERAS
local blips = {
	-- 60KM/H ZONES
	--{title="Radar (60KM/H)", colour=1, id=1, x = 224.36,y = -788.84,z = 30.73}, -- 60KM/H ZONE
	
	-- 80KM/H ZONES
	{title="Radar (140KM/H)", colour=1, id=485, x = 404.87,y = -576.411,z = 28.16}, -- 80KM/H ZONE
	--{title="Radar (120KM/H)", colour=1, id=485, x = 288.96,y = -858.65,z = 29.16}, -- 80KM/H ZONE
	--{title="Radar (120KM/H)", colour=1, id=485, x = 224.23,y = -1043.15,z = 29.16}, -- 80KM/H ZONE
	--{title="Radar (120KM/H)", colour=1, id=485, x = 105.52,y = -998.78,z = 29.16}, -- 80KM/H ZONE
	--{title="Radar (120KM/H)", colour=1, id=485, x = 172.43,y = -816.67,z = 33.16}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = 273.95,y = -553.64,z = 43.44}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = 352.2,y = -269.83,z = 55.01}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = -100.24,y = -1140.65,z = 25.01}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = -274.39,y = -1142.04,z = 23.09}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = -1460.74,y = -442.72,z = 35.51}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = 775.74,y = -851.72,z = 25.51}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = 788.02,y = -2068.82,z = 30.0}, -- 80KM/H ZONE
	{title="Radar (140KM/H)", colour=1, id=485, x = 371.92,y = -1557.66,z = 30.0}, -- 80KM/H ZONE
	
	-- 120KM/H ZONES
	{title="Radar (240KM/H)", colour=1, id=485, x = 567.59, y = -355.5, z = 36.3923} -- 120KM/H ZONE
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.52)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

-- AREAS
local Speedcamera60Zone = {
}

local Speedcamera80Zone = {
    {x = 404.87,y = -576.411,z = 28.16},
    --{x = 288.96,y = -858.65,z = 29.16},
    --{x = 105.52,y = -998.78,z = 29.16},
    --{x = 224.23,y = -1043.15,z = 29.16},
	{x = 273.95,y = -553.64,z = 43.44},
	{x = 352.2,y = -269.83,z = 55.01},
    --{x = 172.43,y = -816.67,z = 34.69},
	{x = -274.39,y = -1142.04,z = 23.09},
	{x = -100.24,y = -1140.65,z = 25.01},
	{x = -1460.74,y = -442.72,z = 35.51},
	{x = 775.69,y = -851.46,z = 25.51},
	{x = 788.02,y = -2068.82,z = 30.0},
	{x = 371.92,y = -1557.66,z = 30.0},
}

local Speedcamera120Zone = {
    {x = 567.59, y = -355.5, z = 36.3923}
}

-- ZONES
Citizen.CreateThread(function()
    while true do
		local waittime111 = 10
		local detetado111 = true
        
		Citizen.Wait(waittime111)
		detetado111 = false

		-- 60 zone
        for k in pairs(Speedcamera60Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera60Zone[k].x, Speedcamera60Zone[k].y, Speedcamera60Zone[k].z)

            if dist <= 10.0 then
				detetado111 = true
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6 * 1.1
				local maxSpeed = 141.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
								--[[if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "SHERIFF" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED--]]
								if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'pj' or ESX.PlayerData.job.name == 'siis' or ESX.PlayerData.job.name == 'ranger' or ESX.PlayerData.job.name == 'municipal' or ESX.PlayerData.job.name == 'state' or ESX.PlayerData.job.name == 'navy' or ESX.PlayerData.job.name == 'ambulance' then
								
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									if useBilling == true then

										finalBillingPrice = (math.floor(SpeedKM) - maxSpeed) * 50 + 50
										
										TriggerServerEvent('esx_speedcamera:PayBill60Zone', finalBillingPrice)
										TriggerEvent("pNotify:SendNotification", {text = "Foste apanhado em excesso de velocidade. Velocidade: " .. math.floor(SpeedKM) .. " KM/H - Multa: "..math.floor(finalBillingPrice).."€", type = "error", timeout = 5000, layout = "centerLeft"})
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) 
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 80 zone
		for k in pairs(Speedcamera80Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera80Zone[k].x, Speedcamera80Zone[k].y, Speedcamera80Zone[k].z)

            if dist <= 23.0 then
				detetado111 = true
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6 * 1.1
				local maxSpeed = 141.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'siis' or ESX.PlayerData.job.name == 'pj' or ESX.PlayerData.job.name == 'ranger' or ESX.PlayerData.job.name == 'municipal' or ESX.PlayerData.job.name == 'state' or ESX.PlayerData.job.name == 'navy' or ESX.PlayerData.job.name == 'ambulance' then
								--[[if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED--]]
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									
									
									if useBilling == true then
										finalBillingPrice = (math.floor(SpeedKM) - maxSpeed) * 100 + 50
										
										TriggerServerEvent('esx_speedcamera:PayBill60Zone', finalBillingPrice)
										TriggerEvent("pNotify:SendNotification", {text = "Foste apanhado em excesso de velocidade. Velocidade: " .. math.floor(SpeedKM) .. " KM/H - Multa: "..math.floor(finalBillingPrice).."€", type = "error", timeout = 5000, layout = "centerLeft"})
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) 
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 120 zone
		for k in pairs(Speedcamera120Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera120Zone[k].x, Speedcamera120Zone[k].y, Speedcamera120Zone[k].z)

            if dist <= 23.0 then
				detetado111 = true
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6 * 1.1
				local maxSpeed = 241.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'siis' or ESX.PlayerData.job.name == 'pj' or ESX.PlayerData.job.name == 'ranger' or ESX.PlayerData.job.name == 'municipal' or ESX.PlayerData.job.name == 'state' or ESX.PlayerData.job.name == 'navy' or ESX.PlayerData.job.name == 'ambulance' then
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_speedcamera:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_speedcamera:closeGUI')
									end
									-- FLASHING EFFECT (END)
								
									
									
									
									if useBilling == true then
										--if SpeedKM >= maxSpeed + 80 then
											--finalBillingPrice = defaultPrice120 + extraZonePrice30
										--elseif SpeedKM >= maxSpeed + 60 then
											--finalBillingPrice = defaultPrice120 + extraZonePrice20
										--elseif SpeedKM >= maxSpeed + 40 then
											--finalBillingPrice = defaultPrice120 + extraZonePrice10
										--else
											--finalBillingPrice = defaultPrice120
										--end
										
										
										finalBillingPrice = (math.floor(SpeedKM) - maxSpeed) * 100 + 50
									
										TriggerServerEvent('esx_speedcamera:PayBill60Zone', finalBillingPrice)
										TriggerEvent("pNotify:SendNotification", {text = "Foste apanhado em excesso de velocidade. Velocidade: " .. math.floor(SpeedKM) .. " KM/H - Multa: "..math.floor(finalBillingPrice).."€", type = "error", timeout = 5000, layout = "centerLeft"})
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
			if detetado111 == true then
				waittime111 = 0
			else
				waittime111 = 1000
			end
    end
end)

RegisterNetEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)
