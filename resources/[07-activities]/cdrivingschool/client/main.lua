ESX                     = nil
local CurrentAction     = nil
local CurrentActionMsg  = nil
local Licenses          = {}
local CurrentTest       = nil
local CurrentTestType   = nil
local CurrentVehicle    = nil
local CurrentCheckPoint = 0
local LastCheckPoint    = -1
local CurrentBlip       = nil
local CurrentZoneType   = nil
local DriveErrors       = 0
local IsAboveSpeedLimit = false
local LastVehicleHealth = nil
local driving = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	createMarkers()
end)

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end

function StartTheoryTest()
	CurrentTest = 'theory'

	-- Block UI
	Citizen.CreateThread(function()
		while CurrentTest == 'theory' do
			Citizen.Wait(1)			
			local playerPed = PlayerPedId()

			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisablePlayerFiring(playerPed, true) -- Disable weapon firing
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
		end
	end)

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(300, function()
		SetNuiFocus(true, true)
		TriggerScreenblurFadeIn(250.0)
	end)

	TriggerServerEvent('cdrivingschool:pay', 'dmv')
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false, false)
	--TriggerScreenblurFadeOut(0.0)

	if success then
		RPC.execute('addDrivingLicense', 'dmv')
		ESX.ShowNotification(_U('passed_test'), 'success')
	else
		ESX.ShowNotification(_U('failed_test'), 'error')
	end

	OpenDMVSchoolMenu()
end

RegisterNetEvent('cdrivingschool:startTest', function(type)
	CurrentTest       = 'drive'
	CurrentTestType   = type
	CurrentCheckPoint = 0
	LastCheckPoint    = -1
	CurrentZoneType   = 'residence'
	DriveErrors       = 0
	IsAboveSpeedLimit = false
	LastVehicleHealth = 1000.0

	driving = true
		-- Drive test
	Citizen.CreateThread(function()
		while driving do

			Citizen.Wait(0)

			
			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			CurrentVehicle = GetVehiclePedIsIn(playerPed)
			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil

				ESX.ShowNotification(_U('driving_test_complete'), 'inform')

				if DriveErrors < Config.MaxErrors then
					StopDriveTest(true)
				else
					StopDriveTest(false)
				end
			else

				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)

				if distance <= 100.0 then
					DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
				end
			end

		end
	end)

	-- Speed / Damage control
	Citizen.CreateThread(function()
		while driving do
			Citizen.Wait(10)
			local playerPed = PlayerPedId()

			if IsPedInAnyVehicle(playerPed, false) then

				local vehicle      = GetVehiclePedIsIn(playerPed, false)
				local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
				local tooMuchSpeed = false

				for k,v in pairs(Config.SpeedLimits) do
					if CurrentZoneType == k and speed > v then
						tooMuchSpeed = true

						if not IsAboveSpeedLimit then
							DriveErrors       = DriveErrors + 1
							IsAboveSpeedLimit = true

							ESX.ShowNotification(_U('driving_too_fast', v), 'error')
							ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors), 'error')
						end
					end
				end

				if not tooMuchSpeed then
					IsAboveSpeedLimit = false
				end

				local health = GetEntityHealth(vehicle)
				if health < LastVehicleHealth then

					DriveErrors = DriveErrors + 1

					ESX.ShowNotification(_U('you_damaged_veh'), 'error')
					ESX.ShowNotification(_U('errors', DriveErrors, Config.MaxErrors), 'error')

					-- avoid stacking faults
					LastVehicleHealth = health
					Citizen.Wait(1500)
				end
			end

		end
	end)
end)

function StopDriveTest(success)
	if success then
		RPC.execute('addDrivingLicense', CurrentTestType)
		ESX.ShowNotification(_U('passed_test'), 'success')
	else
		ESX.ShowNotification(_U('failed_test'), 'error')
	end

	driving = false

	CurrentTest     = nil
	CurrentTestType = nil
end

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

function OpenDMVSchoolMenu()
	local ownedLicenses = {}

	for i=1, #Licenses, 1 do
		ownedLicenses[Licenses[i].type] = true
	end

	local elements = {}

	if not ownedLicenses['dmv'] then
		table.insert(elements, {label = '📜 Teste Teórico ' .. Config.Prices['dmv'] .. '€', value = 'theory_test'})
	end

	if ownedLicenses['dmv'] then
		if not ownedLicenses['drive_bike'] then
			table.insert(elements, {label = '🏍️ Teste de Condução de Mota ' .. Config.Prices['drive_bike'] .. '€', value = 'drive_bike'})
		end

		if not ownedLicenses['drive'] then
			table.insert(elements, {label = '🚗 Teste de Condução de Carro ' .. Config.Prices['drive'] .. '€', value = 'drive'})
		end

		if not ownedLicenses['drive_truck'] then
			table.insert(elements, {label = '🚚 Teste de Condução de Pesados ' .. Config.Prices['drive_truck'] .. '€', value = 'drive_truck'})
		end
	end

    TriggerEvent('chud:menu', elements, _U('driving_school'), function(value)
		TriggerEvent('esx_inventoryhud:doClose')

		if value == 'theory_test' then
			StartTheoryTest()
		elseif value == 'drive_bike' then
			TriggerServerEvent('cdrivingschool:pay', 'drive_bike')
		elseif value == 'drive' then
			TriggerServerEvent('cdrivingschool:pay', 'drive')
		elseif value == 'drive_truck' then
			TriggerServerEvent('cdrivingschool:pay', 'drive_truck')
		end
    end)
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb('OK')
end)

AddEventHandler('cdrivingschool:hasEnteredMarker', function(zone)
	if zone[2] == 'DMVSchool' then
		CurrentAction     = 'dmvschool_menu'
		CurrentActionMsg  = _U('press_open_menu')
		CurrentActionData = {}
	end
end)

AddEventHandler('cdrivingschool:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('cdrivingschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.DMVSchool.Pos.x, Config.Zones.DMVSchool.Pos.y, Config.Zones.DMVSchool.Pos.z)

	SetBlipSprite (blip, 408)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(_U('driving_school_blip'))
	EndTextCommandSetBlipName(blip)
end)


function createMarkers()
	for k,v in pairs(Config.Zones) do
		if v.Type ~= -1 then
			exports.ft_libs:RemoveMarker("cdrivingschool:school")
			exports.ft_libs:AddMarker("cdrivingschool:school", {type = 50, x = v.Pos.x, y = v.Pos.y, z = v.Pos.z+1,
			red = v.Color.r, green = v.Color.g, blue = v.Color.b, showDistance = Config.DrawDistance})

			exports.ft_libs:RemoveTrigger("cdrivingschool:school")
			exports.ft_libs:AddTrigger("cdrivingschool:school", {
				x = v.Pos.x,
				y = v.Pos.y,
				z = v.Pos.z,
				weight = v.Size.x,
				height = 2,
				enter = {
				eventClient = "cdrivingschool:hasEnteredMarker",
				},
				exit = {
				eventClient = "cdrivingschool:hasExitedMarker",
			},
				data = {1, 'DMVSchool', 1},
				active = {
				callback = activeDmvMarkers,
				}
			})
		end
	end
end

-- Key Controls
function activeDmvMarkers()

	if CurrentAction ~= nil then

		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then
			if CurrentAction == 'dmvschool_menu' then
				OpenDMVSchoolMenu()
			end

			CurrentAction = nil
		end
	end
end

