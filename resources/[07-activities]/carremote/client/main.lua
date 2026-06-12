-----------------------------------------------------------------------------------------
---                                        INIT                                       ---
-----------------------------------------------------------------------------------------
ESX	= nil
local currentVehicle, lockStatus, engineStatus, alarmStatus, lastVehicle, owner, sent
local vehicles = {}
local keystenhochave = {}
local menuaberto = false
local carroroubar 
local PlayerData              = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
end)

function tenschave(matricula)
	if matricula ~= nil then
		for _, chave in pairs(keystenhochave) do
			if chave ~= nil then
				if ESX.Math.Trim(matricula) == ESX.Math.Trim(chave) then
					return true
				end
			end
		end
	end
	return false
end

function checkOwner(vehicle)
	local plate = GetVehicleNumberPlateText(vehicle)
	ESX.TriggerServerCallback('carremote:checkOwnedVehicle', function(result)
		if result then
			return true
		else
			return tenschave(plate)
		end
	end, plate)
end

function MostrarNotifi(texto, state)
	exports['okokNotify']:Alert("INFO", texto, 4000, state or 'info')
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, markerData["bob"] and true or false, true, 2, false, false, false, false)
end

function ConfirmGiveKey(plate)
    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestPlayerDistance > 4.0 then
		MostrarNotifi("Ninguém na área a quem dar a chave.", "error")
        return 
    end

    Citizen.CreateThread(function()
        while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "main_accept_key") do
            Citizen.Wait(5)

            local cPlayer, cPlayerDst = ESX.Game.GetClosestPlayer()

            if cPlayer ~= closestPlayer then
                closestPlayer = cPlayer
            end

            local cPlayerPed = GetPlayerPed(closestPlayer)

            if DoesEntityExist(cPlayerPed) then
                DrawScriptMarker({
					["type"] = 2,
					["pos"] = GetEntityCoords(cPlayerPed) + vector3(0.0, 0.0, 1.2),
					["r"] = 0,
					["g"] = 0,
					["b"] = 255,
					["sizeX"] = 0.3,
					["sizeY"] = 0.3,
					["sizeZ"] = 0.3,
                    ["rotate"] = true,
                    ["bob"] = true
				})
            end
        end
    end)

    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_accept_key", {
        ["title"] = "Queres dar a chave?",
        ["align"] = 'top-left',
        ["elements"] = {
            {
                ["label"] = "Sim",
                ["action"] = "yes"
            },
            {
                ["label"] = "Não",
                ["action"] = "no"
            }
        }
    }, function(menuData, menuHandle)
        local action = menuData["current"]["action"]
        
        menuHandle.close()

        if action == "yes" then
			if closestPlayer ~= nil then
				TriggerServerEvent('carremote:darchave', GetVehicleNumberPlateText(plate), GetPlayerServerId(closestPlayer))
				menuHandle.close()
			end
        else
            menuHandle.close()
        end
    end, function(menuData, menuHandle)
        menuHandle.close()
    end)
end

function unlockVehicle(vehicle)
	local ply = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(ply, true))then
		NetworkRequestControlOfEntity(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		NetworkRequestControlOfEntity(vehicle)
		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleAlarm(vehicle, 0)
		MostrarNotifi(_U('unlocked'))
		TriggerServerEvent("carremote:playSound", 4, "unlock-inside", 0.10)
		lockStatus = 1
	else
		--print(GetPlayerServerId(NetworkGetEntityOwner(vehicle)))
		--print(NetworkHasControlOfEntity(vehicle))
		NetworkRequestControlOfEntity(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		NetworkRequestControlOfEntity(vehicle)
		playAnimation()
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(vehicle)
		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleAlarm(vehicle, 0)
		MostrarNotifi(_U('unlocked')) 
		local vehicleNetId = VehToNet(vehicle)
		TriggerServerEvent("carremote:playSoundFromVehicle", Config.MaxAlarmDistance, "unlock-inside", Config.MaxFobBeepVolume, vehicleNetId)
		lockStatus = 1
	end
end

function lockVehicle(vehicle)
	local ply = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(ply, true))then
		NetworkRequestControlOfEntity(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		NetworkRequestControlOfEntity(vehicle)
		SetVehicleDoorsLocked(vehicle, 2)
		MostrarNotifi(_U('locked'))
		TriggerServerEvent("carremote:playSound", 4, "lock-inside", 0.10)
		lockStatus = 2
	else
		NetworkRequestControlOfEntity(vehicle)
		SetEntityAsMissionEntity(vehicle, true, true)
		NetworkRequestControlOfEntity(vehicle)
		playAnimation()
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(vehicle)
		SetVehicleDoorsLocked(vehicle, 2)
		MostrarNotifi(_U('locked'))
		local vehicleNetId = VehToNet(vehicle)
		TriggerServerEvent("carremote:playSoundFromVehicle", Config.MaxAlarmDistance, "lock-outside", Config.MaxFobBeepVolume, vehicleNetId)
		lockStatus = 2
	end
end

function engineOn(vehicle)
	local ply = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(ply, true))then
		MostrarNotifi(_U('engine_on'))
		SetVehicleEngineOn(vehicle, true, true, false)
	else
		ClearPedTasks(ply)
		playAnimation()
		SetVehicleEngineOn(vehicle, true, true, false)
	end
end

function engineOff(vehicle)
	local ply = GetPlayerPed(-1)
	if(IsPedInAnyVehicle(ply, true))then
		MostrarNotifi(_U('engine_off'))
		SetVehicleEngineOn(vehicle, false, false, true)
	else
		ClearPedTasks(ply)
		playAnimation()
		SetVehicleEngineOn(vehicle, false, false, false)
	end
end

function getVehicleNetId(vehID)
	return NetToVeh(NetworkGetNetworkIdFromEntity(vehID))
end

function VehicleInFront2(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	--return vehicle
	
 	if vehicle ~= 0 then
		return vehicle
	else
		local well, well2 = ESX.Game.GetClosestVehicle()
		if well2 ~= nil then
			if well2 < 5 then 
				return well 
			else 
				return vehicle
			end
		else
			return vehicle
		end
	end
end

function playAnimation()
	local ply = GetPlayerPed(-1)
	local lib = "anim@mp_player_intmenu@key_fob@"
	local anim = "fob_click"

	ESX.Streaming.RequestAnimDict(lib, function()
		--TaskPlayAnim(ply, lib, anim, 8.0, -8.0, 3000, 49, 0, false, false, false)
		TaskPlayAnim(ply, lib, anim, 8.0, -8.0, 1000, 49, 0, false, false, false)
	end)
end


RegisterNetEvent('carremote:lockpick')
AddEventHandler('carremote:lockpick', function()
	local ply = GetPlayerPed(-1)
	local coordA = GetEntityCoords(ply, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
	local vehicle = VehicleInFront2(coordA, coordB)
	local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
	carroroubar = nil
	--print (vehicleDistance)
	if vehicleDistance < 2.25 then
		
	    RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
            while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
                Citizen.Wait(0)
            end
			
			--print(GetVehicleDoorLockStatus(vehicle))
			if GetVehicleDoorLockStatus(vehicle) > 1 then
				
				TriggerEvent('lockpick:openlockpick')
				--SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(vehicle))
				FreezeEntityPosition(PlayerPedId(), false)			
				TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )				
				--exports['lockpick']:Lockpick('carremote:stage2')
				carroroubar = vehicle
				
			else	
				MostrarNotifi('O veículo não está trancado', 'error')
			end
	else
		MostrarNotifi('Nenhum veículo perto', 'error')
	end
end)


RegisterNetEvent('carremote:stage1')
AddEventHandler('carremote:stage1', function(resultado)

	if resultado == 'fail' then
		MostrarNotifi('Partiste a Gazua', 'error')
		TriggerServerEvent('carremote:retirar')
		Citizen.Wait(1500)
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(GetPlayerPed(-1))
	else
		Citizen.Wait(1500)
		exports['lockpick']:Lockpick('carremote:stage2')
	end
	
end)


RegisterNetEvent('carremote:stage2')
AddEventHandler('carremote:stage2', function(resultado)

	if resultado == false then
		MostrarNotifi('Partiste a Gazua', 'error')
		TriggerServerEvent('carremote:retirar')
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(GetPlayerPed(-1))
	else
		--MostrarNotifi('Destrancaste o veículo', 'success')
		unlockVehicle(carroroubar)
		FreezeEntityPosition(PlayerPedId(), false)
		ClearPedTasks(GetPlayerPed(-1))
	end
	
end)

RegisterNetEvent('carremote:aceitarchave')
AddEventHandler('carremote:aceitarchave', function(plate)
	MostrarNotifi('Recebeste a chave do veículo '..plate)
	table.insert(keystenhochave, plate)
	
end)

RegisterNetEvent('carremote:playSound')
AddEventHandler('carremote:playSound', function(playerNetId, maxDistance, soundFile, soundVolume)
    local lCoords = GetEntityCoords(GetPlayerPed(-1))
    local eCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(playerNetId)))
    local distIs  = Vdist(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z)
    if(distIs <= maxDistance) then
        SendNUIMessage({
            transactionType   = 'playSound',
            transactionFile   = soundFile,
            transactionVolume = soundVolume
        })
    end
end)

RegisterNetEvent('carremote:playSoundFromVehicle')
AddEventHandler('carremote:playSoundFromVehicle', function(playerNetId, maxDistance, soundFile, maxVolume, sourceEntity)
	local distPerc = nil
	local volume = maxVolume
	local lCoords = GetEntityCoords(GetPlayerPed(-1))
	local eCoords = GetEntityCoords(NetToVeh(sourceEntity), true)
	local distIs  = tonumber(string.format("%.1f", GetDistanceBetweenCoords(lCoords.x, lCoords.y, lCoords.z, eCoords.x, eCoords.y, eCoords.z, true)))
	if (distIs <= maxDistance) then
		distPerc = distIs / maxDistance
		volume = (1-distPerc) * maxVolume
		SendNUIMessage({
			transactionType   = 'playSound',
			transactionFile   = soundFile,
			transactionVolume = volume
		})
	end
end)

RegisterCommand('fecharchave', function(source, args, raw)
	SetNuiFocus(false, false)
	menuaberto = false
end)	


-- NUICallback for Turning The Menu Off
RegisterNUICallback('NUIFocusOff', function()
	SetNuiFocus(false, false)
	menuaberto = false
end)

-- NUICallback For Locking Vehicle
RegisterNUICallback('NUILock', function()
	SendNUIMessage({type = 'disableButtons'})

	if lastVehicle then
		local ply = GetPlayerPed(-1)
		local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		if Config.MaxRemoteRange>= vehicleDistance then
			lockStatus = GetVehicleDoorLockStatus(lastVehicle)
			if lockStatus < 2 then
				lockVehicle(lastVehicle)
				SendNUIMessage({type = 'locked'})
				Citizen.Wait(200)
				SetVehicleLights(lastVehicle, 2)
				Citizen.Wait(100)
				SetVehicleLights(lastVehicle, 0)
				Citizen.Wait(200)
				SetVehicleLights(lastVehicle, 2)
				Citizen.Wait(100)
				SetVehicleLights(lastVehicle, 0)		
			else
				MostrarNotifi(_U('already_locked'))
			end
		else
			MostrarNotifi(_U('out_of_range'), 'error')
		end
	else
		MostrarNotifi(_U('not_connected'), "error")
	end

	SendNUIMessage({type = 'enableButtons'})
end)

-- NUICallback for Unlocking Vehicle
RegisterNUICallback('NUIUnlock', function()
	SendNUIMessage({type = 'disableButtons'})

	if lastVehicle then
		local ply = GetPlayerPed(-1)
		local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		if Config.MaxRemoteRange>= vehicleDistance then
			lockStatus = GetVehicleDoorLockStatus(lastVehicle)
			if lockStatus >= 2 then
				unlockVehicle(lastVehicle)
				SendNUIMessage({type = 'unlocked'})
				Citizen.Wait(200)
				SetVehicleLights(lastVehicle, 2)
				Citizen.Wait(100)
				SetVehicleLights(lastVehicle, 0)
				Citizen.Wait(200)
				SetVehicleLights(lastVehicle, 2)
				Citizen.Wait(100)
				SetVehicleLights(lastVehicle, 0)
			else
				MostrarNotifi(_U('already_unlocked'))
			end
		else
			MostrarNotifi(_U('out_of_range'), 'error')
		end
	else
		MostrarNotifi(_U('not_connected'), "error")
	end

	SendNUIMessage({type = 'enableButtons'})
end)

-- NUICallback for Toggling Engine
RegisterNUICallback('NUIToggleEngine', function()
	SendNUIMessage({type = 'disableButtons'})

	if lastVehicle then
		local ply = GetPlayerPed(-1)
		local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		if Config.MaxRemoteRange>= vehicleDistance then
			engineStatus   = GetIsVehicleEngineRunning(lastVehicle)
			if engineStatus == 1 then
				engineOff(lastVehicle)
				SendNUIMessage({type = 'engineOff'})
			else
				engineOn(lastVehicle)
				SendNUIMessage({type = 'engineOn'})
			end
		else
			MostrarNotifi(_U('out_of_range'), 'error')
		end
	else
		MostrarNotifi(_U('not_connected'), "error")
	end

	Citizen.Wait(500)
	SendNUIMessage({type = 'enableButtons'})
end)

-- NUICallback for Toggling Alarm
RegisterNUICallback('NUIPanic', function()
	SendNUIMessage({type = 'disableButtons'})

	if lastVehicle then
		ConfirmGiveKey(lastVehicle)
	else
		MostrarNotifi(_U('not_connected'), "error")
	end
	
	Citizen.Wait(250)
	SendNUIMessage({type = 'enableButtons'})
end)





RegisterNetEvent("comando:abrir")
AddEventHandler("comando:abrir", function()
	Citizen.Wait(500)
	local ply = GetPlayerPed(-1)

	if (IsPedInAnyVehicle(ply, true)) then
		currentVehicle = GetVehiclePedIsIn(ply, false)
		lockStatus     = GetVehicleDoorLockStatus(currentVehicle)
		if lockStatus == 2 then
			unlockVehicle(currentVehicle)
		else
			lockVehicle(currentVehicle)
		end

		Citizen.Wait(1000)
	else
		local coordA = GetEntityCoords(ply, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
		local vehicle = VehicleInFront2(coordA, coordB)
		local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		local plate = GetVehicleNumberPlateText(vehicle)
		if vehicleDistance < Config.SwitchDistance then
			local tenhochave = false
			tenhochave = tenschave(plate)
			ESX.TriggerServerCallback('carremote:checkOwnedVehicle', function(result)
				if result or tenhochave == true then
					lastVehicle = vehicle
					MostrarNotifi(_U('now_connected', plate), 'success')
					local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)

					if Config.MaxRemoteRange>= vehicleDistance then
						local range = vehicleDistance / Config.MaxRemoteRange
						range = 100 - (math.floor((range * 10) + 0.5) * 10)
						battery = 'battery-' .. tostring(range)
						SendNUIMessage({type = tostring(battery)})
					else
						SendNUIMessage({type = 'battery-0'})
					end

					engineStatus = GetIsVehicleEngineRunning(vehicle)

					if engineStatus then
						SendNUIMessage({type = 'engineOn'})
					else
						SendNUIMessage({type = 'engineOff'})
					end

					lockStatus = GetVehicleDoorLockStatus(vehicle)

					if lockStatus then
						if lockStatus == 2 then
							SendNUIMessage({type = 'locked'})
						else
							SendNUIMessage({type = 'unlocked'})
						end
					else
						SendNUIMessage({type = 'unlocked'})
					end

					SendNUIMessage({type = 'carConnected'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				else
					if lastVehicle then
						if DoesEntityExist(lastVehicle) then
							vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
	
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
	
							engineStatus = GetIsVehicleEngineRunning(lastVehicle)
	
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
	
							lockStatus = GetVehicleDoorLockStatus(lastVehicle)
	
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
	
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						SendNUIMessage({type = 'carDisconnected'})
						SendNUIMessage({type = 'unlocked'})
						SendNUIMessage({type = 'engineOff'})
						SendNUIMessage({type = 'battery-0'})
						SetNuiFocus(true, true)
						menuaberto = true
						SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
						SendNUIMessage({type = 'enableButtons'})
						SendNUIMessage({type = 'openKeyFob'})
					end
				end
			end, plate)
		else
			if lastVehicle then
				if DoesEntityExist(lastVehicle) then
					vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)

					if Config.MaxRemoteRange>= vehicleDistance then
						local range = vehicleDistance / Config.MaxRemoteRange
						range = 100 - (math.floor((range * 10) + 0.5) * 10)
						battery = 'battery-' .. tostring(range)
						SendNUIMessage({type = tostring(battery)})
					else
						SendNUIMessage({type = 'battery-0'})
					end

					engineStatus = GetIsVehicleEngineRunning(lastVehicle)

					if engineStatus then
						SendNUIMessage({type = 'engineOn'})
					else
						SendNUIMessage({type = 'engineOff'})
					end

					lockStatus = GetVehicleDoorLockStatus(lastVehicle)

					if lockStatus then
						if lockStatus == 2 then
							SendNUIMessage({type = 'locked'})
						else
							SendNUIMessage({type = 'unlocked'})
						end
					else
						SendNUIMessage({type = 'unlocked'})
					end

					SendNUIMessage({type = 'carConnected'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				else
					SendNUIMessage({type = 'carDisconnected'})
					SendNUIMessage({type = 'unlocked'})
					SendNUIMessage({type = 'engineOff'})
					SendNUIMessage({type = 'battery-0'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				end
			else
				SendNUIMessage({type = 'carDisconnected'})
				SendNUIMessage({type = 'unlocked'})
				SendNUIMessage({type = 'engineOff'})
				SendNUIMessage({type = 'battery-0'})
				SetNuiFocus(true, true)
				menuaberto = true
				SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
				SendNUIMessage({type = 'enableButtons'})
				SendNUIMessage({type = 'openKeyFob'})
			end
		end
	end
end)


RegisterNetEvent("comando:abrir2")
AddEventHandler("comando:abrir2", function()
	Citizen.Wait(500)
	local ply = GetPlayerPed(-1)

	if (IsPedInAnyVehicle(ply, true)) then
		currentVehicle = GetVehiclePedIsIn(ply, false)
		lockStatus     = GetVehicleDoorLockStatus(currentVehicle)
		if lockStatus == 2 then
			unlockVehicle(currentVehicle)
		else
			lockVehicle(currentVehicle)
		end

		Citizen.Wait(1000)
	else
		local coordA = GetEntityCoords(ply, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
		local vehicle = VehicleInFront2(coordA, coordB)
		local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		local plate = GetVehicleNumberPlateText(vehicle)
		if vehicleDistance < Config.SwitchDistance then
			local tenhochave = false
			tenhochave = tenschave(plate)
			ESX.TriggerServerCallback('carremote:checkOwnedVehicleJob', function(result)
				if result or tenhochave == true then
					lastVehicle = vehicle
					MostrarNotifi(_U('now_connected', plate), 'success')
					local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)

					if Config.MaxRemoteRange>= vehicleDistance then
						local range = vehicleDistance / Config.MaxRemoteRange
						range = 100 - (math.floor((range * 10) + 0.5) * 10)
						battery = 'battery-' .. tostring(range)
						SendNUIMessage({type = tostring(battery)})
					else
						SendNUIMessage({type = 'battery-0'})
					end

					engineStatus = GetIsVehicleEngineRunning(vehicle)

					if engineStatus then
						SendNUIMessage({type = 'engineOn'})
					else
						SendNUIMessage({type = 'engineOff'})
					end

					lockStatus = GetVehicleDoorLockStatus(vehicle)

					if lockStatus then
						if lockStatus == 2 then
							SendNUIMessage({type = 'locked'})
						else
							SendNUIMessage({type = 'unlocked'})
						end
					else
						SendNUIMessage({type = 'unlocked'})
					end

					SendNUIMessage({type = 'carConnected'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				else
					if lastVehicle then
						if DoesEntityExist(lastVehicle) then
							vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
	
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
	
							engineStatus = GetIsVehicleEngineRunning(lastVehicle)
	
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
	
							lockStatus = GetVehicleDoorLockStatus(lastVehicle)
	
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
	
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						SendNUIMessage({type = 'carDisconnected'})
						SendNUIMessage({type = 'unlocked'})
						SendNUIMessage({type = 'engineOff'})
						SendNUIMessage({type = 'battery-0'})
						SetNuiFocus(true, true)
						menuaberto = true
						SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
						SendNUIMessage({type = 'enableButtons'})
						SendNUIMessage({type = 'openKeyFob'})
					end
				end
			end, plate)
		else
			if lastVehicle then
				if DoesEntityExist(lastVehicle) then
					vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)

					if Config.MaxRemoteRange>= vehicleDistance then
						local range = vehicleDistance / Config.MaxRemoteRange
						range = 100 - (math.floor((range * 10) + 0.5) * 10)
						battery = 'battery-' .. tostring(range)
						SendNUIMessage({type = tostring(battery)})
					else
						SendNUIMessage({type = 'battery-0'})
					end

					engineStatus = GetIsVehicleEngineRunning(lastVehicle)

					if engineStatus then
						SendNUIMessage({type = 'engineOn'})
					else
						SendNUIMessage({type = 'engineOff'})
					end

					lockStatus = GetVehicleDoorLockStatus(lastVehicle)

					if lockStatus then
						if lockStatus == 2 then
							SendNUIMessage({type = 'locked'})
						else
							SendNUIMessage({type = 'unlocked'})
						end
					else
						SendNUIMessage({type = 'unlocked'})
					end

					SendNUIMessage({type = 'carConnected'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				else
					SendNUIMessage({type = 'carDisconnected'})
					SendNUIMessage({type = 'unlocked'})
					SendNUIMessage({type = 'engineOff'})
					SendNUIMessage({type = 'battery-0'})
					SetNuiFocus(true, true)
					menuaberto = true
					SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
					SendNUIMessage({type = 'enableButtons'})
					SendNUIMessage({type = 'openKeyFob'})
				end
			else
				SendNUIMessage({type = 'carDisconnected'})
				SendNUIMessage({type = 'unlocked'})
				SendNUIMessage({type = 'engineOff'})
				SendNUIMessage({type = 'battery-0'})
				SetNuiFocus(true, true)
				menuaberto = true
				SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
				SendNUIMessage({type = 'enableButtons'})
				SendNUIMessage({type = 'openKeyFob'})
			end
		end
	end
end)


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	local tenhochave = false
	Citizen.Wait(5000)
	table.insert(keystenhochave, "ALUG"..GetPlayerServerId(PlayerId()))	
	table.insert(keystenhochave, "ALUG"..GetPlayerServerId(PlayerId()))	
	while true do
		Citizen.Wait(1)

		if IsControlJustPressed(0, Config.HotkeyUI) then
			local ply = GetPlayerPed(-1)
		
			if (IsPedInAnyVehicle(ply, true)) then
				--currentVehicle = GetVehiclePedIsIn(ply, false)
				--lockStatus     = GetVehicleDoorLockStatus(currentVehicle)
				--if lockStatus == 2 then
				--	unlockVehicle(currentVehicle)
				--else
				--	lockVehicle(currentVehicle)
				--end
				--
				--Citizen.Wait(1000)
			else
				local coordA = GetEntityCoords(ply, 1)
				local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
				local vehicle = VehicleInFront2(coordA, coordB)
				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
				local plate = GetVehicleNumberPlateText(vehicle)
				if vehicleDistance < Config.SwitchDistance then
					tenhochave = false
					tenhochave = tenschave(plate)
					ESX.TriggerServerCallback('carremote:checkOwnedVehicle', function(result)
						if result or tenhochave == true then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							if lastVehicle then
								if DoesEntityExist(lastVehicle) then
									vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		
									if Config.MaxRemoteRange>= vehicleDistance then
										local range = vehicleDistance / Config.MaxRemoteRange
										range = 100 - (math.floor((range * 10) + 0.5) * 10)
										battery = 'battery-' .. tostring(range)
										SendNUIMessage({type = tostring(battery)})
									else
										SendNUIMessage({type = 'battery-0'})
									end
		
									engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		
									if engineStatus then
										SendNUIMessage({type = 'engineOn'})
									else
										SendNUIMessage({type = 'engineOff'})
									end
		
									lockStatus = GetVehicleDoorLockStatus(lastVehicle)
		
									if lockStatus then
										if lockStatus == 2 then
											SendNUIMessage({type = 'locked'})
										else
											SendNUIMessage({type = 'unlocked'})
										end
									else
										SendNUIMessage({type = 'unlocked'})
									end
		
									SendNUIMessage({type = 'carConnected'})
									SetNuiFocus(true, true)
									menuaberto = true
									SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
									SendNUIMessage({type = 'enableButtons'})
									SendNUIMessage({type = 'openKeyFob'})
								else
									SendNUIMessage({type = 'carDisconnected'})
									SendNUIMessage({type = 'unlocked'})
									SendNUIMessage({type = 'engineOff'})
									SendNUIMessage({type = 'battery-0'})
									SetNuiFocus(true, true)
									menuaberto = true
									SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
									SendNUIMessage({type = 'enableButtons'})
									SendNUIMessage({type = 'openKeyFob'})
								end
							else
								SendNUIMessage({type = 'carDisconnected'})
								SendNUIMessage({type = 'unlocked'})
								SendNUIMessage({type = 'engineOff'})
								SendNUIMessage({type = 'battery-0'})
								SetNuiFocus(true, true)
								menuaberto = true
								SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
								SendNUIMessage({type = 'enableButtons'})
								SendNUIMessage({type = 'openKeyFob'})
							end
						end
					end, plate)
				else
					if lastVehicle then
						if DoesEntityExist(lastVehicle) then
							vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(lastVehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						SendNUIMessage({type = 'carDisconnected'})
						SendNUIMessage({type = 'unlocked'})
						SendNUIMessage({type = 'engineOff'})
						SendNUIMessage({type = 'battery-0'})
						SetNuiFocus(true, true)
						menuaberto = true
						SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
						SendNUIMessage({type = 'enableButtons'})
						SendNUIMessage({type = 'openKeyFob'})
					end
				end
			end
		end
		--
		--if IsControlJustPressed(0, Config.HotkeyEngine) then
		--	local ply = GetPlayerPed(-1)
		--	if (IsPedInAnyVehicle(ply, true)) then
		--		currentVehicle = GetVehiclePedIsIn(ply, false)
		--		engineStatus   = GetIsVehicleEngineRunning(currentVehicle)
		--		if engineStatus == 1 then
		--			engineOff(currentVehicle)
		--		else
		--			engineOn(currentVehicle)
		--		end
		--		Citizen.Wait(1000)
		--	else
		--		local coordA = GetEntityCoords(ply, 1)
		--		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, 0.0)
		--		local vehicle = VehicleInFront2(coordA, coordB)
		--		if vehicle ~= 0 and vehicle ~= nil then
		--			if checkOwner(vehicle) then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(vehicle)
		--					ToggleEngines(vehicle)
		--				end
		--			else
		--				if lastVehicle then
		--					local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--					if Config.MaxRemoteRange>= vehicleDistance then
		--						engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--						ToggleEngines(lastVehicle)
		--					end
		--				end
		--			end
		--		else
		--			if lastVehicle then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--					ToggleEngines(lastVehicle)
		--				end
		--			end
		--		end
		--	end
		--end
	end
end)

Citizen.CreateThread(function()
	local tenhochave = false
	Citizen.Wait(5000)
	table.insert(keystenhochave, "0EST13PT")	
	while true do
		Citizen.Wait(1)

		if IsControlJustPressed(0, Config.HotkeyUI) then
			local ply = GetPlayerPed(-1)
		
			if (IsPedInAnyVehicle(ply, true)) then
				--currentVehicle = GetVehiclePedIsIn(ply, false)
				--lockStatus     = GetVehicleDoorLockStatus(currentVehicle)
				--if lockStatus == 2 then
				--	unlockVehicle(currentVehicle)
				--else
				--	lockVehicle(currentVehicle)
				--end
				--
				--Citizen.Wait(1000)
			else
				local coordA = GetEntityCoords(ply, 1)
				local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
				local vehicle = VehicleInFront2(coordA, coordB)
				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
				local plate = GetVehicleNumberPlateText(vehicle)
				if vehicleDistance < Config.SwitchDistance then
					tenhochave = false
					tenhochave = tenschave(plate)
					ESX.TriggerServerCallback('carremote:checkOwnedVehicleJob', function(result)
						if result or tenhochave == true then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							if lastVehicle then
								if DoesEntityExist(lastVehicle) then
									vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		
									if Config.MaxRemoteRange>= vehicleDistance then
										local range = vehicleDistance / Config.MaxRemoteRange
										range = 100 - (math.floor((range * 10) + 0.5) * 10)
										battery = 'battery-' .. tostring(range)
										SendNUIMessage({type = tostring(battery)})
									else
										SendNUIMessage({type = 'battery-0'})
									end
		
									engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		
									if engineStatus then
										SendNUIMessage({type = 'engineOn'})
									else
										SendNUIMessage({type = 'engineOff'})
									end
		
									lockStatus = GetVehicleDoorLockStatus(lastVehicle)
		
									if lockStatus then
										if lockStatus == 2 then
											SendNUIMessage({type = 'locked'})
										else
											SendNUIMessage({type = 'unlocked'})
										end
									else
										SendNUIMessage({type = 'unlocked'})
									end
		
									SendNUIMessage({type = 'carConnected'})
									SetNuiFocus(true, true)
									menuaberto = true
									SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
									SendNUIMessage({type = 'enableButtons'})
									SendNUIMessage({type = 'openKeyFob'})
								else
									SendNUIMessage({type = 'carDisconnected'})
									SendNUIMessage({type = 'unlocked'})
									SendNUIMessage({type = 'engineOff'})
									SendNUIMessage({type = 'battery-0'})
									SetNuiFocus(true, true)
									menuaberto = true
									SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
									SendNUIMessage({type = 'enableButtons'})
									SendNUIMessage({type = 'openKeyFob'})
								end
							else
								SendNUIMessage({type = 'carDisconnected'})
								SendNUIMessage({type = 'unlocked'})
								SendNUIMessage({type = 'engineOff'})
								SendNUIMessage({type = 'battery-0'})
								SetNuiFocus(true, true)
								menuaberto = true
								SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
								SendNUIMessage({type = 'enableButtons'})
								SendNUIMessage({type = 'openKeyFob'})
							end
						end
					end, plate)
				else
					if lastVehicle then
						if DoesEntityExist(lastVehicle) then
							vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(lastVehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						SendNUIMessage({type = 'carDisconnected'})
						SendNUIMessage({type = 'unlocked'})
						SendNUIMessage({type = 'engineOff'})
						SendNUIMessage({type = 'battery-0'})
						SetNuiFocus(true, true)
						menuaberto = true
						SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
						SendNUIMessage({type = 'enableButtons'})
						SendNUIMessage({type = 'openKeyFob'})
					end
				end
			end
		end
		--
		--if IsControlJustPressed(0, Config.HotkeyEngine) then
		--	local ply = GetPlayerPed(-1)
		--	if (IsPedInAnyVehicle(ply, true)) then
		--		currentVehicle = GetVehiclePedIsIn(ply, false)
		--		engineStatus   = GetIsVehicleEngineRunning(currentVehicle)
		--		if engineStatus == 1 then
		--			engineOff(currentVehicle)
		--		else
		--			engineOn(currentVehicle)
		--		end
		--		Citizen.Wait(1000)
		--	else
		--		local coordA = GetEntityCoords(ply, 1)
		--		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, 0.0)
		--		local vehicle = VehicleInFront2(coordA, coordB)
		--		if vehicle ~= 0 and vehicle ~= nil then
		--			if checkOwner(vehicle) then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(vehicle)
		--					ToggleEngines(vehicle)
		--				end
		--			else
		--				if lastVehicle then
		--					local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--					if Config.MaxRemoteRange>= vehicleDistance then
		--						engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--						ToggleEngines(lastVehicle)
		--					end
		--				end
		--			end
		--		else
		--			if lastVehicle then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--					ToggleEngines(lastVehicle)
		--				end
		--			end
		--		end
		--	end
		--end
	end
end)
function Comando()
Citizen.CreateThread(function()
	local tenhochave = false
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(1)

		if IsControlJustPressed(0, Config.HotkeyUI) then
			local ply = GetPlayerPed(-1)
			
		
			if (IsPedInAnyVehicle(ply, true)) then
				--currentVehicle = GetVehiclePedIsIn(ply, false)
				--lockStatus     = GetVehicleDoorLockStatus(currentVehicle)
				--if lockStatus == 2 then
				--	unlockVehicle(currentVehicle)
				--else
				--	lockVehicle(currentVehicle)
				--end
				--
				--Citizen.Wait(1000)
			else
				local coordA = GetEntityCoords(ply, 1)
				local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, -0.6)
				local vehicle = VehicleInFront2(coordA, coordB)
				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
				local plate = GetVehicleNumberPlateText(vehicle)
				if vehicleDistance < Config.SwitchDistance then
					if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' then
						if string.sub(plate, 1, 4) == '0EST' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						elseif plate == 'AGUIAPSP' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						elseif plate == 'AGUIAGNR' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'ambulance' then
						if plate == 'BOMBEIRO' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						elseif plate == '  INEM  ' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'state' then
						if plate == 'ESTADO' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'pj' then
						if plate == 'LPC 001' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						elseif plate == 'LPC 002' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						elseif string.sub(plate, 1, 3) == 'AEG' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'mechanic' then
						if string.sub(plate, 1, 4) == 'NORA' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'ranger' then
						if plate == 'MARITIMA' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					elseif PlayerData.job.name == 'golf' then
						if string.sub(plate, 1, 4) == '5ECL' then
							lastVehicle = vehicle
							MostrarNotifi(_U('now_connected', plate), 'success')
							local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(vehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(vehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						if lastVehicle then
							if DoesEntityExist(lastVehicle) then
								vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
	
								if Config.MaxRemoteRange>= vehicleDistance then
									local range = vehicleDistance / Config.MaxRemoteRange
									range = 100 - (math.floor((range * 10) + 0.5) * 10)
									battery = 'battery-' .. tostring(range)
									SendNUIMessage({type = tostring(battery)})
								else
									SendNUIMessage({type = 'battery-0'})
								end
	
								engineStatus = GetIsVehicleEngineRunning(lastVehicle)
	
								if engineStatus then
									SendNUIMessage({type = 'engineOn'})
								else
									SendNUIMessage({type = 'engineOff'})
								end
	
								lockStatus = GetVehicleDoorLockStatus(lastVehicle)
	
								if lockStatus then
									if lockStatus == 2 then
										SendNUIMessage({type = 'locked'})
									else
										SendNUIMessage({type = 'unlocked'})
									end
								else
									SendNUIMessage({type = 'unlocked'})
								end
	
								SendNUIMessage({type = 'carConnected'})
								SetNuiFocus(true, true)
								menuaberto = true
								SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
								SendNUIMessage({type = 'enableButtons'})
								SendNUIMessage({type = 'openKeyFob'})
							else
								SendNUIMessage({type = 'carDisconnected'})
								SendNUIMessage({type = 'unlocked'})
								SendNUIMessage({type = 'engineOff'})
								SendNUIMessage({type = 'battery-0'})
								SetNuiFocus(true, true)
								menuaberto = true
								SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
								SendNUIMessage({type = 'enableButtons'})
								SendNUIMessage({type = 'openKeyFob'})
							end
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					end
				else
					if lastVehicle then
						if DoesEntityExist(lastVehicle) then
							vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		
							if Config.MaxRemoteRange>= vehicleDistance then
								local range = vehicleDistance / Config.MaxRemoteRange
								range = 100 - (math.floor((range * 10) + 0.5) * 10)
								battery = 'battery-' .. tostring(range)
								SendNUIMessage({type = tostring(battery)})
							else
								SendNUIMessage({type = 'battery-0'})
							end
		
							engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		
							if engineStatus then
								SendNUIMessage({type = 'engineOn'})
							else
								SendNUIMessage({type = 'engineOff'})
							end
		
							lockStatus = GetVehicleDoorLockStatus(lastVehicle)
		
							if lockStatus then
								if lockStatus == 2 then
									SendNUIMessage({type = 'locked'})
								else
									SendNUIMessage({type = 'unlocked'})
								end
							else
								SendNUIMessage({type = 'unlocked'})
							end
		
							SendNUIMessage({type = 'carConnected'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						else
							SendNUIMessage({type = 'carDisconnected'})
							SendNUIMessage({type = 'unlocked'})
							SendNUIMessage({type = 'engineOff'})
							SendNUIMessage({type = 'battery-0'})
							SetNuiFocus(true, true)
							menuaberto = true
							SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
							SendNUIMessage({type = 'enableButtons'})
							SendNUIMessage({type = 'openKeyFob'})
						end
					else
						SendNUIMessage({type = 'carDisconnected'})
						SendNUIMessage({type = 'unlocked'})
						SendNUIMessage({type = 'engineOff'})
						SendNUIMessage({type = 'battery-0'})
						SetNuiFocus(true, true)
						menuaberto = true
						SendNUIMessage({type = 'setHotKey', value = Config.HotkeyUI})
						SendNUIMessage({type = 'enableButtons'})
						SendNUIMessage({type = 'openKeyFob'})
					end
				end
			end
		end
		--
		--if IsControlJustPressed(0, Config.HotkeyEngine) then
		--	local ply = GetPlayerPed(-1)
		--	if (IsPedInAnyVehicle(ply, true)) then
		--		currentVehicle = GetVehiclePedIsIn(ply, false)
		--		engineStatus   = GetIsVehicleEngineRunning(currentVehicle)
		--		if engineStatus == 1 then
		--			engineOff(currentVehicle)
		--		else
		--			engineOn(currentVehicle)
		--		end
		--		Citizen.Wait(1000)
		--	else
		--		local coordA = GetEntityCoords(ply, 1)
		--		local coordB = GetOffsetFromEntityInWorldCoords(ply, 0.0, 5.0, 0.0)
		--		local vehicle = VehicleInFront2(coordA, coordB)
		--		if vehicle ~= 0 and vehicle ~= nil then
		--			if checkOwner(vehicle) then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(vehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(vehicle)
		--					ToggleEngines(vehicle)
		--				end
		--			else
		--				if lastVehicle then
		--					local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--					if Config.MaxRemoteRange>= vehicleDistance then
		--						engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--						ToggleEngines(lastVehicle)
		--					end
		--				end
		--			end
		--		else
		--			if lastVehicle then
		--				local vehicleDistance = GetDistanceBetweenCoords(GetEntityCoords(ply), GetEntityCoords(lastVehicle, false), true)
		--				if Config.MaxRemoteRange>= vehicleDistance then
		--					engineStatus = GetIsVehicleEngineRunning(lastVehicle)
		--					ToggleEngines(lastVehicle)
		--				end
		--			end
		--		end
		--	end
		--end
	end
end)
end

Comando()