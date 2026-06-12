local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PlayerData              = {}
local HasAlreadyEnteredMarker = false
local LastStation             = nil
local LastPart                = nil
local LastPartNum             = nil
local LastEntity              = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local IsHandcuffed            = false
local HandcuffTimer           = {}
local DragStatus              = {}
DragStatus.IsDragged          = false
local hasAlreadyJoined        = false
local blipsCops               = {}
local isDead                  = false
local CurrentTask             = {}
local playerInService         = false
local configuracao			  = 'Config'
local safetyblock 			  = false	
local dados_carros 			  = {}	
ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	
	PlayerData = ESX.GetPlayerData()
	
	if isJobPermitido(PlayerData.job.name) then
		configuracao = PlayerData.job.name..'Config'
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	
	if isJobPermitido(PlayerData.job.name) then
		configuracao = PlayerData.job.name..'Config'
	else
		configuracao			  = 'Config'
	end
end)


function SetVehicleMaxMods(vehicle)
	local props = {
		modEngine       = 2,
		modBrakes       = 2,
		modTransmission = 2,
		modSuspension   = 3,
		modTurbo        = true
	}

	ESX.Game.SetVehicleProperties(vehicle, props)
end

function cleanPlayer(playerPed)
	SetPedArmour(playerPed, 0)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	ResetPedMovementClipset(playerPed, 0)
end

function setUniform(job, playerPed)
	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			if Config[configuracao].Uniforms[job].male ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config[configuracao].Uniforms[job].male)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				SetPedArmour(playerPed, 100)
			end
		else
			if Config[configuracao].Uniforms[job].female ~= nil then
				TriggerEvent('skinchanger:loadClothes', skin, Config[configuracao].Uniforms[job].female)
			else
				ESX.ShowNotification(_U('no_outfit'))
			end

			if job == 'bullet_wear' then
				--SetPedArmour(playerPed, 100)
			end
		end
	end)
end

function OpenCloakroomMenu()

	local playerPed = PlayerPedId()
	local grade = PlayerData.job.grade_name

	local elements = {
		{ label = _U('citizen_wear'), value = 'citizen_wear' },
		--{ label = _U('bullet_wear'), value = 'bullet_wear' },
		{ label = 'Roupa Tática', value = 'gilet_wear' }
	}

	if grade == 'soldato' then
		table.insert(elements, {label = 'Roupa Formal', value = 'soldato_wear'})
	elseif grade == 'capo' then
		table.insert(elements, {label = 'Roupa Formal', value = 'capo_wear'})
	elseif grade == 'consigliere' then
		table.insert(elements, {label = 'Roupa Formal', value = 'consigliere_wear'})
	elseif grade == 'boss' then
		table.insert(elements, {label = 'Roupa Formal', value = 'boss_wear'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
	{
		title    = _U('cloakroom'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		cleanPlayer(playerPed)

		if data.current.value == 'citizen_wear' then
			
			if Config[configuracao].EnableNonFreemodePeds then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
					local isMale = skin.sex == 0

					TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
						ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
							TriggerEvent('skinchanger:loadSkin', skin)
							TriggerEvent('esx:restoreLoadout')
						end)
					end)

				end)
			else
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
			end

			if Config[configuracao].MaxInService ~= -1 then

				ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
					if isInService then

						playerInService = false

						local notification = {
							title    = _U('service_anonunce'),
							subject  = '',
							msg      = _U('service_out_announce', GetPlayerName(PlayerId())),
							iconType = 1
						}

						TriggerServerEvent('esx_service:notifyAllInService', notification, PlayerData.job.name)

						TriggerServerEvent('esx_service:disableService', PlayerData.job.name)
						--TriggerEvent('esx_mafiajob:updateBlip')
						ESX.ShowNotification(_U('service_out'))
					end
				end, PlayerData.job.name)
			end

		end

		if Config[configuracao].MaxInService ~= -1 and data.current.value ~= 'citizen_wear' then
			local serviceOk = 'waiting'

			ESX.TriggerServerCallback('esx_service:isInService', function(isInService)
				if not isInService then

					ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
						if not canTakeService then
							ESX.ShowNotification(_U('service_max', inServiceCount, maxInService))
						else

							serviceOk = true
							playerInService = true

							local notification = {
								title    = _U('service_anonunce'),
								subject  = '',
								msg      = _U('service_in_announce', GetPlayerName(PlayerId())),
								iconType = 1
							}
	
							TriggerServerEvent('esx_service:notifyAllInService', notification, PlayerData.job.name)
							--TriggerEvent('esx_mafiajob:updateBlip')
							ESX.ShowNotification(_U('service_in'))
						end
					end, PlayerData.job.name)

				else
					serviceOk = true
				end
			end, PlayerData.job.name)

			while type(serviceOk) == 'string' do
				Citizen.Wait(5)
			end

			-- if we couldn't enter service don't let the player get changed
			if not serviceOk then
				return
			end
		end

		if
			data.current.value == 'soldato_wear' or
			data.current.value == 'capo_wear' or
			data.current.value == 'consigliere_wear' or
			data.current.value == 'boss_wear' or
			data.current.value == 'bullet_wear' or
			data.current.value == 'gilet_wear'
		then
			setUniform(data.current.value, playerPed)
		end

		if data.current.value == 'freemode_ped' then
			local modelHash = ''

			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					modelHash = GetHashKey(data.current.maleModel)
				else
					modelHash = GetHashKey(data.current.femaleModel)
				end

				ESX.Streaming.RequestModel(modelHash, function()
					SetPlayerModel(PlayerId(), modelHash)
					SetModelAsNoLongerNeeded(modelHash)

					TriggerEvent('esx:restoreLoadout')
				end)
			end)

		end



	end, function(data, menu)
		menu.close()

		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ""
		CurrentActionData = {}
	end)
end

function OpenArmoryMenu(station)

	if Config[configuracao].EnableArmoryManagement then

		local elements = {
			{label = 'Armário Geral', value = 'geral'},
			{label = 'Armário Chefia', value = 'geral2'}
		}
		
		if PlayerData.job.name == 'coast' then
			elements = {
				{label = 'Armário Geral', value = 'geralg6'},
				{label = 'Armário Chefia', value = 'geral2'}
			}
		
		end
		if PlayerData.job.grade_name == 'boss' then
			table.insert(elements, {label = 'Armário Secreto', value = 'geral3'})	
		end

		if PlayerData.job.grade > 1 then
			if PlayerData.job.name ~= 'mob' and PlayerData.job.name ~= 'unicorn' and PlayerData.job.name ~= 'galaxy' and PlayerData.job.name ~= 'offroad' and PlayerData.job.name ~= 'vigne' and PlayerData.job.name ~= 'revisao' and PlayerData.job.name ~= 'golf' and PlayerData.job.name ~= 'casino' and PlayerData.job.name ~= 'usados' and PlayerData.job.name ~= 'sata' then
				table.insert(elements, {label = 'Caixa de Correio', value = 'get_stock'})	
			end
		end
		
		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			if data.current.value == 'get_weapon' then
				if PlayerData.job.grade < 2 and (PlayerData.job.name == 'mungiki') then
					ESX.ShowNotification('~r~Sem acesso')
				else
					OpenGetWeaponMenu()
				end
			elseif data.current.value == 'put_weapon' then
				OpenPutWeaponMenu()
			elseif data.current.value == 'buy_weapons' then
				OpenBuyWeaponsMenu(station)
			elseif data.current.value == 'geral' then
				TriggerEvent('inventory:abrirdados', PlayerData.job.name, 'armario', '<b>Armário</b> Organização')
			elseif data.current.value == 'geral2' then
				TriggerEvent('inventory:abrirdados', PlayerData.job.name, 'armarioboss', '<b>Armário</b> Chefia')
			elseif data.current.value == 'geral3' then
				TriggerEvent('inventory:abrirdados', PlayerData.job.name, 'armariosecreto', '<b>Armário</b> Secreto')
			elseif data.current.value == 'geralg6' then
				AbrirArsenalG6()
			elseif data.current.value == 'put_stock' then
				OpenPutStocksMenu()
			elseif data.current.value == 'get_stock' then
				if PlayerData.job.grade < 2 and (PlayerData.job.name == 'mungiki') then
					ESX.ShowNotification('~r~Sem acesso')
				else
					OpenGetStocksMenu()
				end
			end
			
		end, function(data, menu)
			menu.close()
			CloseArmoryMenu()
			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = ""
			CurrentActionData = {station = station}
		end)

	else

		local elements = {}

		for i=1, #Config[configuracao].Stations[station].AuthorizedWeapons, 1 do
			local weapon = Config[configuracao].Stations[station].AuthorizedWeapons[i]
			table.insert(elements, {label = ESX.GetWeaponLabel(weapon.name), value = weapon.name})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory',
		{
			title    = _U('armory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local weapon = data.current.value
			TriggerServerEvent('esx_mafiajob:giveWeapon', weapon, 1000)
		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_armory'
			CurrentActionMsg  = ""
			CurrentActionData = {station = station}
		end)

	end

end

function OpenVehicleSpawnerMenu(station, partNum)

	ESX.UI.Menu.CloseAll()
	if PlayerData.job.name == 'usados' then
		local elements2 = {}
		table.insert(elements2,{label = 'Veículos Empresa', value = 'org'})
		table.insert(elements2,{label = 'Veículos Pessoais', value = 'pessoal'})
	
	
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'garage_menu',
		{
			title    = 'Garagem',
			align    = 'top-left',
			elements = elements2,
		},
		function(data, menu)
	
			menu.close()
			if(data.current.value == 'org') then
				local elements = {}
		
				ESX.TriggerServerCallback('esx_mafiajob:retrieveJobVehicles', function(garageVehicles)
		
					--for i=1, #garageVehicles, 1 do
					for k,v in ipairs(garageVehicles) do
						local props = json.decode(v.vehicle)
						local vehicleName = GetDisplayNameFromVehicleModel(props.model)
						table.insert(elements, {
							label = vehicleName.." ("..props.plate..")",
							value = props.model,
							vehicleProps123 = props
						})
					end
		
					ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
					{
						title    = _U('vehicle_menu'),
						align    = 'top-left',
						elements = elements
					}, function(data, menu)
						menu.close()
		
						local vehicleProps = data.current.value
						local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)
						--local matric = "CA2132"
		
						if foundSpawnPoint then
							ESX.Game.SpawnVehicle(vehicleProps, spawnPoint, spawnPoint.heading, function(vehicle)
								ESX.Game.SetVehicleProperties(vehicle, data.current.vehicleProps123)
								TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								exports["LegacyFuel"]:SetFuel(vehicle, 100)
								
							end)
		
							--TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mafia', vehicleProps)
						end
					end, function(data, menu)
						menu.close()
		
						CurrentAction     = 'menu_vehicle_spawner'
						CurrentActionMsg  = _U('vehicle_spawner')
						CurrentActionData = {station = station, partNum = partNum}
					end)
		
				end, PlayerData.job.name)
			end
			if(data.current.value == 'pessoal') then
				TriggerEvent('eden_garage:tirarcarro', Config[configuracao].Stations[station].Helicopters[1].SpawnPoint)
	
			end
		end,
		function(data, menu)
			menu.close()
			
		end)		
	
	
	else
	
	if Config[configuracao].EnableSocietyOwnedVehicles and station ~= 'aero' then

		local elements = {}

		ESX.TriggerServerCallback('esx_mafiajob:retrieveJobVehicles', function(garageVehicles)

			--for i=1, #garageVehicles, 1 do
			for k,v in ipairs(garageVehicles) do
				local props = json.decode(v.vehicle)
				local vehicleName = GetDisplayNameFromVehicleModel(props.model)
				table.insert(elements, {
					label = vehicleName.." ("..props.plate..")",
					value = props.model,
					vehicleProps123 = props
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('vehicle_menu'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				menu.close()

				local vehicleProps = data.current.value
				local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)
				--local matric = "CA2132"

				if foundSpawnPoint then
					ESX.Game.SpawnVehicle(vehicleProps, spawnPoint, spawnPoint.heading, function(vehicle)
						
						ESX.Game.SetVehicleProperties(vehicle, data.current.vehicleProps123)
						TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
						exports["LegacyFuel"]:SetFuel(vehicle, 100)
						if PlayerData.job.name == 'golf' then
							SetVehicleNumberPlateText(vehicle, string.sub("5ECL"..GetPlayerServerId(PlayerId()).."PT",1,8))
						end
					end)

					--TriggerServerEvent('esx_society:removeVehicleFromGarage', 'mafia', vehicleProps)
				end
			end, function(data, menu)
				menu.close()

				CurrentAction     = 'menu_vehicle_spawner'
				CurrentActionMsg  = _U('vehicle_spawner')
				CurrentActionData = {station = station, partNum = partNum}
			end)

		end, PlayerData.job.name)

	else

		local elements = {}

		local sharedVehicles = Config[configuracao].AuthorizedVehicles.Shared
		for i=1, #sharedVehicles, 1 do
			table.insert(elements, { label = sharedVehicles[i].label, model = sharedVehicles[i].model})
		end

		local authorizedVehicles = Config[configuracao].AuthorizedVehicles[PlayerData.job.grade_name]
		for i=1, #authorizedVehicles, 1 do
			table.insert(elements, { label = authorizedVehicles[i].label, model = authorizedVehicles[i].model})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
		{
			title    = _U('vehicle_menu'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			menu.close()
			local matric = "1ORG " .. math.random(9) .. math.random(9)
			local foundSpawnPoint, spawnPoint = GetAvailableVehicleSpawnPoint(station, partNum)

			if foundSpawnPoint then
				if Config[configuracao].MaxInService == -1 then
					ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
						SetVehicleNumberPlateText(vehicle, matric)
						TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
						SetVehicleMaxMods(vehicle)
						exports["LegacyFuel"]:SetFuel(vehicle, 100)
					end)
				else

					ESX.TriggerServerCallback('esx_service:isInService', function(isInService)

						if isInService then
							ESX.Game.SpawnVehicle(data.current.model, spawnPoint, spawnPoint.heading, function(vehicle)
								TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								SetVehicleMaxMods(vehicle)
								exports["LegacyFuel"]:SetFuel(vehicle, 100)
							end)
						else
							ESX.ShowNotification(_U('service_not'))
						end

					end, PlayerData.job.name)
				end
			end

		end, function(data, menu)
			menu.close()

			CurrentAction     = 'menu_vehicle_spawner'
			CurrentActionMsg  = _U('vehicle_spawner')
			CurrentActionData = {station = station, partNum = partNum}
		end)

	end
	end
end

function GetAvailableVehicleSpawnPoint(station, partNum)
	local spawnPoints = Config[configuracao].Stations[station].Vehicles[partNum].SpawnPoints
	local found, foundSpawnPoint = false, nil

	for i=1, #spawnPoints, 1 do
		if ESX.Game.IsSpawnPointClear(spawnPoints[i], spawnPoints[i].radius) then
			found, foundSpawnPoint = true, spawnPoints[i]
			break
		end
	end

	if found then
		return true, foundSpawnPoint
	else
		ESX.ShowNotification(_U('vehicle_blocked'))
		return false
	end
end

function OpenmafiaActionsMenu()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions',
	{
		title    = 'Organização',
		align    = 'top-left',
		elements = {
			{label = _U('citizen_interaction'),	value = 'citizen_interaction'},
			--{label = _U('vehicle_interaction'),	value = 'vehicle_interaction'},	
		}
	}, function(data, menu)

		if data.current.value == 'citizen_interaction' then
			local elements = {
				{label = _U('id_card'),			value = 'identity_card'},
				{label = _U('search'),			value = 'body_search'},
				{label = _U('handcuff'),		value = 'handcuff'},
				{label = _U('drag'),			value = 'drag'},
				{label = _U('put_in_vehicle'),	value = 'put_in_vehicle'},
				{label = _U('out_the_vehicle'),	value = 'out_the_vehicle'},
			}
			if Config[configuracao].EnableLicenses then
				table.insert(elements, { label = _U('license_check'), value = 'license' })
			end
		
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'citizen_interaction',
			{
				title    = _U('citizen_interaction'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu2)
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer ~= -1 and closestDistance <= 3.0 then
					local action = data2.current.value

					if action == 'identity_card' then
						TriggerServerEvent('esx_mafiajob:message', GetPlayerServerId(closestPlayer), '~y~A tua ~b~identificação ~y~está a ser vista!')
						OpenIdentityCardMenu(closestPlayer)
					elseif action == 'body_search' then
						TriggerServerEvent('esx_mafiajob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
						--OpenBodySearchMenu(closestPlayer)
						TriggerEvent('inventory:revistar', true)
					elseif action == 'handcuff' then
						TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(closestPlayer))
					elseif action == 'drag' then
						TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
					elseif action == 'put_in_vehicle' then
						TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'out_the_vehicle' then
						TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
					elseif action == 'fine' then
						OpenFineMenu(closestPlayer)
					elseif action == 'license' then
						ShowPlayerLicense(closestPlayer)
					elseif action == 'unpaid_bills' then
						OpenUnpaidBillsMenu(closestPlayer)
					end

				else
					ESX.ShowNotification(_U('no_players_nearby'))
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("civcare:carros")
AddEventHandler("civcare:carros", function(data)
	dados_carros = data
	MenuCarrosOrdem(dados_carros)
	
end)

function MenuCarrosOrdem(dados_carros)
	
	local elements = {}
	
	for k,v in pairs(dados_carros) do
		if v.veh_prio == 1 then
			table.insert(elements, {label = '<span style="color:LimeGreen;">'..v.plate..'</span>', value = 1, key = k, plate = v.plate })
		else
			table.insert(elements, {label = v.plate, value = 9, key = k, plate = v.plate})
		end	
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'carros_ordem',
	{
		title    = 'Prioridade Carros',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)


		
		if data.current.value == 1 then
			--print(data.current.key)
			dados_carros[data.current.key].veh_prio = 9
			TriggerServerEvent('civcare:carrosordem', data.current.plate, false)
		elseif data.current.value == 9 then
			--print(data.current.key)
			dados_carros[data.current.key].veh_prio = 1
			TriggerServerEvent('civcare:carrosordem', data.current.plate, true)
		end
		
		
		menu.close()
		exports['mythic_notify']:SendAlert('inform','A carregar a lista...', 3500)
		Citizen.Wait(500)
		MenuCarrosOrdem(dados_carros)
		
	end, function(data, menu)
		menu.close()
	end)
end

function OpenmafiaActions2Menu()
	ESX.UI.Menu.CloseAll()
	if PlayerData.job.name == 'golf' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'Eclipse',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
				{label = 'Tabuleiro Vazio',	value = 'e tabuleiro'},
				{label = 'Tabuleiro A',	value = 'e tabuleiro2'},
				{label = 'Tabuleiro B',	value = 'e tabuleiro3'},
				{label = 'Dar Tabuleiro Vazio',	value = 'tabuleiro'},
				{label = 'Dar Tabuleiro A',	value = 'tabuleiro2'},
				{label = 'Dar Tabuleiro B',	value = 'tabuleiro3'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura Eclipse'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 100000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_golf', 'Fatura Eclipse', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'e tabuleiro' or data.current.value == 'e tabuleiro2' or data.current.value == 'e tabuleiro3' then
				ExecuteCommand(data.current.value)
			elseif data.current.value == 'tabuleiro' or data.current.value == 'tabuleiro2' or data.current.value == 'tabuleiro3' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					TriggerServerEvent('esx_mafiajob:dartabuleiro', GetPlayerServerId(closestPlayer), data.current.value)
					ExecuteCommand('animcancelar')
					exports['mythic_notify']:SendAlert('inform','Tabuleiro Dado')
				end			
			end
	
		end, function(data, menu)
			menu.close()
		end)

	elseif PlayerData.job.name == 'ranger' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ranger',
		{
			title    = 'Park Rangers',
			align    = 'top-left',
			elements = {
				{label = 'Primeiros Socorros',	value = 'socorros'},
			}
		}, function(data, menu)
	
			if data.current.value == 'socorros' then
	
				local islandCoords = vector3(4503.08,-4520.01,3.41)
				local pCoords = GetEntityCoords(PlayerPedId())
				if #(pCoords - islandCoords) < 40.0 then	
					TriggerEvent('ajob:revive')
				else
					exports['mythic_notify']:SendAlert('error','Tens de estar mais perto do Aeroporto de Cayo Perico')
				end				
			end
	
		end, function(data, menu)
			menu.close()
		end)		
	
	elseif PlayerData.job.name == 'offroad' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'TT Offroad',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_offroad', 'Fatura TT Offroad', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)
		
	elseif PlayerData.job.name == 'galaxy' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'Galaxy',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_galaxy', 'Fatura Galaxy', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)
		
	elseif PlayerData.job.name == 'unicorn' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'Vanilla',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_unicorn', 'Fatura Vanilla', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)
	elseif PlayerData.job.name == 'mob' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'Yellow Jack',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_mob', 'Fatura Yellow Jack', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)	

	elseif PlayerData.job.name == 'vigne' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill2',
		{
			title    = 'Motogalia',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_vigne', 'Fatura Motogalia', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)	
		
	elseif PlayerData.job.name == 'reporter' then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'Jornal',
			align    = 'top-left',
			elements = {
				{label = 'Fatura',	value = 'fatura'},
			}
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 100000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_reporter', 'Fatura JPTV', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			end
	
		end, function(data, menu)
			menu.close()
		end)


	elseif PlayerData.job.name == 'sata' then
		
		local elements =  {
				{label = 'Fatura',	value = 'fatura'},
				{label = 'Dar Chave Porão',	value = 'porao'},
		}
		
		if PlayerData.job.grade > 0 then
			table.insert(elements, { label = 'Sinal Los Santos', value = 'LPLS' })
			table.insert(elements, { label = 'Sinal Cayo Perico', value = 'LPCP' })
			table.insert(elements, { label = 'Sinal Sandy Shores', value = 'LPSS' })
		end
		
		if PlayerData.job.grade > 3 then
				table.insert(elements, { label = 'Licença PPL(A)', value = 'licence2' })
		end
		if PlayerData.job.grade > 4 then
				table.insert(elements, { label = 'Licença ATPL(A)', value = 'licence3' })
				table.insert(elements, { label = 'Licença Flight Instructor', value = 'licence4' })
				table.insert(elements, { label = 'Licença Flight Examiner', value = 'licence5' })
		end
		
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'SATA',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura SATA'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sata', 'Fatura SATA', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
							TriggerServerEvent('esx:sata:logs123', GetPlayerServerId(closestPlayer), math.floor(amount))
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
				
			
			elseif data.current.value == 'LPLS' then
				TriggerEvent('sinal:sata', 47)
			elseif data.current.value == 'LPCP' then
				TriggerEvent('sinal:sata', 48)
			elseif data.current.value == 'LPSS' then
				TriggerEvent('sinal:sata', 50)
			elseif data.current.value == 'licence2' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then	
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					exports['mythic_notify']:SendAlert('success', 'Licença Emitida ao ID '..GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'ppl')
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sata', 'Licença Piloto Privado', 500)
				end
			elseif data.current.value == 'licence3' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then	
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					exports['mythic_notify']:SendAlert('success', 'Licença Emitida ao ID '..GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'atpl')
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sata', 'Licença ATPL', 500)
				end
			elseif data.current.value == 'licence4' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then	
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					exports['mythic_notify']:SendAlert('success', 'Licença Emitida ao ID '..GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'fi')
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sata', 'Licença FI', 500)
				end
			elseif data.current.value == 'licence5' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then	
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					exports['mythic_notify']:SendAlert('success', 'Licença Emitida ao ID '..GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'fe')
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_sata', 'Licença FE', 500)
				end
			elseif data.current.value == 'porao' then
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestPlayer == -1 or closestDistance > 3.0 then	
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					local vehFront = VehicleInFront()
					if DoesEntityExist(vehFront) then
						local plateprotempore = GetVehicleNumberPlateText(vehFront)
						if plateprotempore ~= nil then
							if string.sub(plateprotempore, 1, 4) == '0SAT' then
								TriggerServerEvent('esx:mafia:sata_porao', GetPlayerServerId(closestPlayer), plateprotempore)
								exports['mythic_notify']:SendAlert('success', 'Acesso ao porão dado ao ID '..GetPlayerServerId(closestPlayer))
							end
						end
					
					end
				end
			end
	
		end, function(data, menu)
			menu.close()
		end)
		
	elseif PlayerData.job.name == 'casino' then
		
		local tabela_coisas = {
				{label = 'Fatura',	value = 'fatura'},
				{label = 'Emissão Seguro',	value = 'seguro'},
				{label = 'Verificar Seguro',	value = 'seguro2'},
				{label = 'Mudança Registo Civil',	value = 'registo'},
				{label = 'Gerir Prioridade Garagem',	value = 'garagem'},
			}
			
		if PlayerData.job.grade > 0 then
			table.insert(tabela_coisas, {label = 'Painel de Investimentos',	value = 'painel'})
			table.insert(tabela_coisas, {label = 'Examinação de Condução',	value = 'drive'})
		end
			
			
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill',
		{
			title    = 'CivilityCare',
			align    = 'top-left',
			elements = tabela_coisas
		}, function(data, menu)
	
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 20000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_casino', 'Fatura CivilityCare', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
			
			elseif data.current.value == 'drive' then

				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
				if closestPlayer == -1 or closestDistance > 3.0 then
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
					local playerPed = PlayerPedId()
					TriggerServerEvent("civcare:resetcarta", GetPlayerServerId(closestPlayer))
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_casino', 'Fatura Examinação CivilityCare ', 9000)
					TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_state', 'Taxa IMT', 1000)
					exports['mythic_notify']:SendAlert('success','Examinação Concluída')
				end
				
			
			elseif data.current.value == 'painel' then
								
				
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
				if closestPlayer == -1 or closestDistance > 3.0 then
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
					if GetDistanceBetweenCoords(coords, -929.0, -2038.73, 10.0, true) < 100 then
					
						TriggerServerEvent("civcare:investments", GetPlayerServerId(closestPlayer))
					else
						exports['mythic_notify']:SendAlert('error','Ação Somente Possível na Sede')
						menu.close()
					end
				end
				
			elseif data.current.value == 'garagem' then
								
				
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				
				if closestPlayer == -1 or closestDistance > 3.0 then
					exports['mythic_notify']:SendAlert('error','Ninguém por perto')
				else
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
					if GetDistanceBetweenCoords(coords, -929.0, -2038.73, 10.0, true) < 100 then
					
						TriggerServerEvent("civcare:listacarros", GetPlayerServerId(closestPlayer))
					else
						exports['mythic_notify']:SendAlert('error','Ação Somente Possível na Sede')
						menu.close()
					end
				end
								
			elseif data.current.value == 'seguro' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Matrícula para o Seguro'
				}, function(data, menu)
	
					--local amount = tonumber(data.value)
					if data.value == nil then
						exports['mythic_notify']:SendAlert('error','Matrícula Inválida')
					else
						menu.close()
						TriggerServerEvent('t1ger_carinsurance:updateInsurance_auto', data.value)
						--local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						--if closestPlayer == -1 or closestDistance > 3.0 then
						--	--ESX.ShowNotification('~y~')
						--	exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						--else
						--	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_casino', 'Fatura CivilityCare', math.floor(amount))
						--	exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						--end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
			
			elseif data.current.value == 'seguro2' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Matrícula para o Seguro'
				}, function(data, menu)
	
					--local amount = tonumber(data.value)
					if data.value == nil then
						exports['mythic_notify']:SendAlert('error','Matrícula Inválida')
					else
						menu.close()
						TriggerServerEvent('t1ger_carinsurance:updateInsurance_auto_check', data.value)
						--local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						--if closestPlayer == -1 or closestDistance > 3.0 then
						--	--ESX.ShowNotification('~y~')
						--	exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						--else
						--	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_casino', 'Fatura CivilityCare', math.floor(amount))
						--	exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						--end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)

			elseif data.current.value == 'registo' then
				local playerPed = PlayerPedId()
				local coords    = GetEntityCoords(playerPed)
				
				if GetDistanceBetweenCoords(coords, -929.0, -2038.73, 10.0, true) < 100 then
						local closestPlayer, distance = ESX.Game.GetClosestPlayer()
								
						if distance ~= -1 and distance <= 3.0 then
							TriggerServerEvent('mafiajob:novaidentidade', GetPlayerServerId(closestPlayer))
						else
							exports['mythic_notify']:SendAlert('error','Ninguém por perto!')
						end
						menu.close()
				else
					exports['mythic_notify']:SendAlert('error','Ação Somente Possível na Sede')
					menu.close()
				end
			end
	
		end, function(data, menu)
			menu.close()
		end)	
		
	elseif PlayerData.job.name == 'revisao' then	
		local tabela_coisas = {
				{label = 'Fatura',	value = 'fatura'},
				{label = 'Emitir Inspeção',	value = 'seguro'},
				{label = 'Homologação Vidros',	value = 'v'},
				{label = 'Homologação Buzina',	value = 'b'},
				{label = 'Homologação Neons',	value = 'n'},
				{label = 'Homologação Fumaça',	value = 'f'},
				{label = 'Limpar Vidros',	value = 'vidros'},
				{label = 'Ver Selo',	value = 'selo'},
				{label = 'Inspecionar Carro',	value = 'inspect'},
			}
			
		if PlayerData.job.grade > 0 then
			table.insert(tabela_coisas, {label = 'Painel de Investimentos',	value = 'painel'})
		end
			
			
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'mafia_actions_bill1',
		{
			title    = 'Centrovia',
			align    = 'top-left',
			elements = tabela_coisas
		}, function(data, menu)	
			
			if data.current.value == 'fatura' then
	
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing1', {
					title = 'Fatura'
				}, function(data, menu)
	
					local amount = tonumber(data.value)
					if amount == nil or amount < 0 or amount > 1000000 then
						exports['mythic_notify']:SendAlert('error','Valor Inválido')
					else
						menu.close()
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 3.0 then
							--ESX.ShowNotification('~y~')
							exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						else
							TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_revisao', 'Fatura Centrovia', math.floor(amount))
							exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'selo' then
				ExecuteCommand("selo")
			elseif data.current.value == 'inspect' then
				ExecuteCommand("inspecionar")
			elseif data.current.value == 'seguro' or data.current.value == 'v' or data.current.value == 'b' or data.current.value == 'n' or data.current.value == 'f' then
				local ativo_cen = data.current.value
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
					title = 'Matrícula para Emissão'
				}, function(data, menu)
	
					--local amount = tonumber(data.value)
					if data.value == nil then
						exports['mythic_notify']:SendAlert('error','Matrícula Inválida')
					else
						menu.close()
						TriggerServerEvent('centrovia:seguro', data.value, ativo_cen)
						--local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						--if closestPlayer == -1 or closestDistance > 3.0 then
						--	--ESX.ShowNotification('~y~')
						--	exports['mythic_notify']:SendAlert('error','Ninguém por perto')
						--else
						--	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_casino', 'Fatura CivilityCare', math.floor(amount))
						--	exports['mythic_notify']:SendAlert('inform','Fatura Enviada')
						--end
	
					end
	
				end, function(data, menu)
					menu.close()
				end)
			elseif data.current.value == 'vidros' then
				local playerPed = PlayerPedId()
				local vehicle   = ESX.Game.GetVehicleInDirection()
				local coords    = GetEntityCoords(playerPed)
				
				if IsPedSittingInAnyVehicle(playerPed) then
					ESX.ShowNotification('Tens de sair do veículo')
					return
				end
				
				if DoesEntityExist(vehicle) then
					isBusy = true
					TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
					Citizen.CreateThread(function()
						Citizen.Wait(10000)
				
						SetVehicleDirtLevel(vehicle, 0)
						ClearPedTasks(playerPed)
				
						ESX.ShowNotification('Veículo Limpo')
						isBusy = false
					end)
				else
					ESX.ShowNotification('Nenhum veículo perto')
				end
			end
			
		end, function(data, menu)
			menu.close()
		end)
	end
end

RegisterNetEvent('mafiajob:aceitarnovaidentidade')
AddEventHandler('mafiajob:aceitarnovaidentidade', function()
	local elements = {}
	table.insert(elements, {label= "Sim (Custo 200.000€)", value = "sim"})
	table.insert(elements, {label= "Cancelar", value = "nao"})
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'propsta', {
		title    = "Aceita realizar alterações ao seu Registo Civil?",
		align    = 'center',
		elements = elements
	}, function(data, menu)
		if data.current.value == "sim" then
			TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_state', 'Taxa Administrativa Registo Civil', 150000)
			TriggerServerEvent('jsfour-register:fake', GetPlayerServerId(PlayerId()))		
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end)


AddEventHandler('playerSpawned', function(spawn)
	isDead = false
	hasAlreadyJoined = true
end)

function OpenIdentityCardMenu(player)

	ESX.TriggerServerCallback('esx_mafiajob:getOtherPlayerData', function(data)

		local elements    = {}
		local nameLabel   = _U('name', data.name)
		local jobLabel    = nil
		local sexLabel    = nil
		local dobLabel    = nil
		local heightLabel = nil
		local idLabel     = nil
	
		if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
			jobLabel = _U('job', data.job.label .. ' - ' .. data.job.grade_label)
		else
			jobLabel = _U('job', data.job.label)
		end
	
		if Config[configuracao].EnableESXIdentity then
	
			nameLabel = _U('name', data.firstname .. ' ' .. data.lastname)
	
			if data.sex ~= nil then
				if string.lower(data.sex) == 'm' then
					sexLabel = _U('sex', _U('male'))
				else
					sexLabel = _U('sex', _U('female'))
				end
			else
				sexLabel = _U('sex', _U('unknown'))
			end
	
			if data.dob ~= nil then
				dobLabel = _U('dob', data.dob)
			else
				dobLabel = _U('dob', _U('unknown'))
			end
	
			if data.height ~= nil then
				heightLabel = _U('height', data.height)
			else
				heightLabel = _U('height', _U('unknown'))
			end
	
			if data.name ~= nil then
				idLabel = _U('id', data.name)
			else
				idLabel = _U('id', _U('unknown'))
			end
	
		end
	
		local elements = {
			{label = nameLabel, value = nil},
			--{label = jobLabel,  value = nil},
		}
	
		if Config[configuracao].EnableESXIdentity then
			table.insert(elements, {label = sexLabel, value = nil})
			table.insert(elements, {label = dobLabel, value = nil})
			table.insert(elements, {label = heightLabel, value = nil})
			table.insert(elements, {label = idLabel, value = nil})
		end
	
		if data.drunk ~= nil then
			table.insert(elements, {label = _U('bac', data.drunk), value = nil})
		end
	
		if data.licenses ~= nil then
	
			table.insert(elements, {label = _U('license_label'), value = nil})
	
			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label, value = nil})
			end
	
		end
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
		{
			title    = _U('citizen_interaction'),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
	
		end, function(data, menu)
			menu.close()
		end)
	
	end, GetPlayerServerId(player))

end

function OpenBodySearchMenu(player)
	TriggerEvent("inventory:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end

function OpenVehicleInfosMenu(vehicleData)

	ESX.TriggerServerCallback('esx_mafiajob:getVehicleInfos', function(retrivedInfo)

		local elements = {}

		table.insert(elements, {label = _U('plate', retrivedInfo.plate), value = nil})

		if retrivedInfo.owner == nil then
			table.insert(elements, {label = _U('owner_unknown'), value = nil})
		else
			table.insert(elements, {label = _U('owner', retrivedInfo.owner), value = nil})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_infos',
		{
			title    = _U('vehicle_info'),
			align    = 'top-left',
			elements = elements
		}, nil, function(data, menu)
			menu.close()
		end)

	end, vehicleData.plate)

end

function OpenGetWeaponMenu()

  ESX.TriggerServerCallback('esx_mafiajob:getArmoryWeapons', function(weapons)

    local elements = {}

    for i=1, #weapons, 1 do
      if weapons[i].count > 0 then
        table.insert(elements, {label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name), value = weapons[i].name})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'armory_get_weapon',
      {
        title    = _U('get_weapon_menu'),
        align    = 'top-left',
        elements = elements,
      },
      function(data, menu)

        menu.close()

		local arma = data.current.value
		
		if (PlayerData.job.grade == 9 or PlayerData.job.grade == 9) then
			local flag = false
			for i=1, #Config[configuracao].ArmasPermitidas.Nivel1, 1 do
				if (arma == Config[configuracao].ArmasPermitidas.Nivel1[i].name) then
					flag = true
					ESX.TriggerServerCallback('esx_mafiajob:removeArmoryWeapon', function()
						OpenGetWeaponMenu()
					end, data.current.value)
				end
			end
			if not flag then
				ESX.ShowNotification("Não tens permissão para retirar uma/um " .. ESX.GetWeaponLabel(arma) .."!")
			end
		end
		
		if (PlayerData.job.grade == 9) then
			local flag = false
			for i=1, #Config[configuracao].ArmasPermitidas.Nivel2, 1 do
				if (arma == Config[configuracao].ArmasPermitidas.Nivel2[i].name) then
				flag = true
					ESX.TriggerServerCallback('esx_mafiajob:removeArmoryWeapon', function()
						OpenGetWeaponMenu()
					end, data.current.value)
				end
			end
			if not flag then
				ESX.ShowNotification("Não tens permissão para retirar uma/um " .. ESX.GetWeaponLabel(arma) .."!")
			end
		end

		--if (PlayerData.job.grade == 3 or PlayerData.job.grade == 2) then
			local flag = false
				flag = true
					ESX.TriggerServerCallback('esx_mafiajob:removeArmoryWeapon', function()
						OpenGetWeaponMenu()
					end, data.current.value)
		--end
      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()
	
	if safetyblock == true then return end
	
	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {label = weaponList[i].label, value = weaponList[i].name})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = _U('put_weapon_menu'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()
		if safetyblock == true then return else safetyblock = true end
		
		ESX.TriggerServerCallback('esx_mafiajob:addArmoryWeapon', function()
			safetyblock = false
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end

function OpenGetStocksMenu()

	ESX.TriggerServerCallback('esx_mafiajob:getStockItems', function(items)


		local elements = {}

		for i=1, #items, 1 do
			if items[i].count ~= 0 then
				table.insert(elements, {label = 'x' .. items[i].count .. ' ' .. items[i].label, value = items[i].name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('mafia_stock'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mafiajob:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end)

end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('esx_mafiajob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {label = item.label .. ' x' .. item.count, type = 'item_standard', value = item.name})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu',
		{
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)

				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('esx_mafiajob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)



AddEventHandler('esx_mafiajob:hasEnteredMarker', function(station, part, partNum)

	if part == 'Cloakroom' then
		CurrentAction     = 'menu_cloakroom'
		CurrentActionMsg  = ""
		CurrentActionData = {}

	elseif part == 'Armory' then

		CurrentAction     = 'menu_armory'
		CurrentActionMsg  = ""
		CurrentActionData = {station = station}

	elseif part == 'VehicleSpawner' then

		CurrentAction     = 'menu_vehicle_spawner'
		CurrentActionMsg  = _U('vehicle_spawner')
		CurrentActionData = {station = station, partNum = partNum}

	elseif part == 'HelicopterSpawner' then

	elseif part == 'VehicleDeleter' then

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
				CurrentAction     = 'delete_vehicle'
				CurrentActionMsg  = ""
				CurrentActionData = {}
	elseif part == 'BossActions' then

		CurrentAction     = 'menu_boss_actions'
		CurrentActionMsg  = ""
		CurrentActionData = {}

	end

end)

AddEventHandler('esx_mafiajob:hasExitedMarker', function(station, part, partNum)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

AddEventHandler('esx_mafiajob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

-- Display markers
Citizen.CreateThread(function()
	local waittime111 = 10
	local detetado111 = true
	
	while true do
		Citizen.Wait(waittime111)
		detetado111 = false
		if PlayerData.job ~= nil and isJobPermitido(PlayerData.job.name) then

			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			for k,v in pairs(Config[configuracao].Stations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < 4 then
						detetado111 = true
						DrawText3D(v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z+1, " Pressione [~r~E~s~] para aceder ao armário    ", 100.0, true)
						--DrawMarker(Config[configuracao].MarkerType, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config[configuracao].MarkerSize.x, Config[configuracao].MarkerSize.y, Config[configuracao].MarkerSize.z, Config[configuracao].MarkerColor.r, Config[configuracao].MarkerColor.g, Config[configuracao].MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < 4 then
						detetado111 = true
						DrawText3D(v.Armories[i].x, v.Armories[i].y, v.Armories[i].z+1, " Pressione [~r~E~s~] para aceder ao armário   ", 100.0, true)
						--DrawMarker(Config[configuracao].MarkerType, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config[configuracao].MarkerSize.x, Config[configuracao].MarkerSize.y, Config[configuracao].MarkerSize.z, Config[configuracao].MarkerColor.r, Config[configuracao].MarkerColor.g, Config[configuracao].MarkerColor.b, 100, false, true, 2, false, false, false, false)
					end
				end

				--####for i=1, #v.Vehicles, 1 do
				--####	if GetDistanceBetweenCoords(coords, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z, true) < Config[configuracao].DrawDistance then
				--####		detetado111 = true
				--####		if k == "aero" then
				--####			DrawMarker(33, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, Config[configuracao].MarkerSize.z+1, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				--####		else
				--####			DrawMarker(36, v.Vehicles[i].Spawner.x, v.Vehicles[i].Spawner.y, v.Vehicles[i].Spawner.z+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, Config[configuracao].MarkerSize.z+1, 0, 255, 0, 100, false, true, 2, false, false, false, false)
				--####		end
				--####	end
				--####end

				for i=1, #v.VehicleDeleters, 1 do
					local dis_del = GetDistanceBetweenCoords(coords, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z, true)
					if dis_del < Config[configuracao].DrawDistance then
						detetado111 = true
						if k == "aero" then
							DrawMarker(33, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, Config[configuracao].MarkerSize.y, Config[configuracao].MarkerSize.z+1, 255, 0, 0, 100, false, true, 2, false, false, false, false)
						else
							DrawMarker(36, v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.675, 1.34, 0, 100, 255, 100, false, true, 2, false, false, false, false)
							if dis_del < 3 then
								DrawText3Ddelete(v.VehicleDeleters[i].x, v.VehicleDeleters[i].y, v.VehicleDeleters[i].z+1.45, "Pressione ~b~[~s~E~b~]~s~ aceder à Garagem")
								
								if IsControlJustReleased(0, Keys['E']) then
					
									if not IsPedInAnyVehicle(PlayerPedId(), false) then
										local coords_ped = GetEntityCoords(PlayerPedId())
										local heading_ped = GetEntityHeading(PlayerPedId())
										TriggerEvent('cd_garage:JobVehicleSpawn', 'owned', PlayerData.job.name, 'car', true, vector4(coords_ped.x, coords_ped.y, coords_ped.z, heading_ped))
									else
										exports['mythic_notify']:PersistentAlert('start', 'carrog', 'error', 'A processar o veículo...', { ['background-color'] = '#42a4f5' })
										TriggerEvent('cd_garage:StoreVehicle_Main', false, PlayerData.job.name)
										local breakcou = 0
										while IsPedInAnyVehicle(PlayerPedId(), false) do
											Citizen.Wait(1000)
											breakcou = breakcou + 1
											if breakcou > 4 then
												local carrobye = GetVehiclePedIsIn(GetPlayerPed(-1), false)
												if carrobye ~= nil then
													DeleteEntity(carrobye)
												end
												break
											end
										end
										exports['mythic_notify']:PersistentAlert('end', 'carrog')
									end
								end
					
							end
						end
					end
				end


			

				for i=1, #Config.GaragensCayo, 1 do
					local dis_del = GetDistanceBetweenCoords(coords, Config.GaragensCayo[i].x, Config.GaragensCayo[i].y, Config.GaragensCayo[i].z, true)
					if dis_del < Config[configuracao].DrawDistance then
						detetado111 = true
						if k == "aero" then
							DrawMarker(33, Config.GaragensCayo[i].x, Config.GaragensCayo[i].y, Config.GaragensCayo[i].z+1.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, Config[configuracao].MarkerSize.y, Config[configuracao].MarkerSize.z+1, 255, 0, 0, 100, false, true, 2, false, false, false, false)
						else
							DrawMarker(36, Config.GaragensCayo[i].x, Config.GaragensCayo[i].y, Config.GaragensCayo[i].z+0.9, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.675, 1.34, 0, 100, 255, 100, false, true, 2, false, false, false, false)
							if dis_del < 3 then
								DrawText3Ddelete(Config.GaragensCayo[i].x, Config.GaragensCayo[i].y, Config.GaragensCayo[i].z+1.45, "Pressione ~b~[~s~E~b~]~s~ aceder à Garagem")
								
								if IsControlJustReleased(0, Keys['E']) then
					
									if not IsPedInAnyVehicle(PlayerPedId(), false) then
										ListVehiclesMenuCayo(Config.GaragensCayo[i].x, Config.GaragensCayo[i].y, Config.GaragensCayo[i].z, Config.GaragensCayo[i].h, PlayerData.job.name)
									else
										local carroguardar = GetVehiclePedIsIn(GetPlayerPed(-1), false)
										local carroguardar_plate = GetVehicleNumberPlateText(carroguardar)
										GuardarCayo(carroguardar,carroguardar_plate)
									end
								end
					
							end
						end
					end
				end
				
				if Config[configuracao].EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if not v.BossActions[i].disabled and GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < 4 then
							detetado111 = true
							DrawText3D(v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z+1, " Pressione [~r~E~s~] para aceder à gestão    ", 100.0, true)
						end
					end
				end

			end
			
			if detetado111 == true then
				waittime111 = 0
			else
				waittime111 = 1000
			end
		else
			Citizen.Wait(1000)
		end

	end
end)

function DrawText3Ddelete(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

--███████╗███╗   ██╗████████╗███████╗██████╗      ███████╗██╗  ██╗██╗████████╗    ███╗   ███╗ █████╗ ██████╗ ██╗  ██╗███████╗██████╗     ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
--██╔════╝████╗  ██║╚══██╔══╝██╔════╝██╔══██╗     ██╔════╝╚██╗██╔╝██║╚══██╔══╝    ████╗ ████║██╔══██╗██╔══██╗██║ ██╔╝██╔════╝██╔══██╗    ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
--█████╗  ██╔██╗ ██║   ██║   █████╗  ██████╔╝     █████╗   ╚███╔╝ ██║   ██║       ██╔████╔██║███████║██████╔╝█████╔╝ █████╗  ██████╔╝    █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
--██╔══╝  ██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗     ██╔══╝   ██╔██╗ ██║   ██║       ██║╚██╔╝██║██╔══██║██╔══██╗██╔═██╗ ██╔══╝  ██╔══██╗    ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
--███████╗██║ ╚████║   ██║   ███████╗██║  ██║     ███████╗██╔╝ ██╗██║   ██║       ██║ ╚═╝ ██║██║  ██║██║  ██║██║  ██╗███████╗██║  ██║    ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
--╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝

Citizen.CreateThread(function()

	while true do

		Citizen.Wait(500)

		if PlayerData.job ~= nil and isJobPermitido(PlayerData.job.name) then

			local playerPed      = PlayerPedId()
			local coords         = GetEntityCoords(playerPed)
			local isInMarker     = false
			local currentStation = nil
			local currentPart    = nil
			local currentPartNum = nil

			for k,v in pairs(Config[configuracao].Stations) do

				for i=1, #v.Cloakrooms, 1 do
					if GetDistanceBetweenCoords(coords, v.Cloakrooms[i].x, v.Cloakrooms[i].y, v.Cloakrooms[i].z, true) < Config[configuracao].MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Cloakroom'
						currentPartNum = i
					end
				end

				for i=1, #v.Armories, 1 do
					if GetDistanceBetweenCoords(coords, v.Armories[i].x, v.Armories[i].y, v.Armories[i].z, true) < Config[configuracao].MarkerSize.x then
						isInMarker     = true
						currentStation = k
						currentPart    = 'Armory'
						currentPartNum = i
					end
				end


				if Config[configuracao].EnablePlayerManagement and PlayerData.job.grade_name == 'boss' then
					for i=1, #v.BossActions, 1 do
						if GetDistanceBetweenCoords(coords, v.BossActions[i].x, v.BossActions[i].y, v.BossActions[i].z, true) < Config[configuracao].MarkerSize.x then
							isInMarker     = true
							currentStation = k
							currentPart    = 'BossActions'
							currentPartNum = i
						end
					end
				end

			end

			local hasExited = false

			if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

				if
					(LastStation ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('esx_mafiajob:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('esx_mafiajob:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_mafiajob:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end

		else
			Citizen.Wait(1000)
		end

	end
end)

--██████╗ ██╗  ██╗ ██████╗ ██╗  ██╗    ████████╗███████╗██╗  ██╗████████╗    ██╗   ██╗██╗
--██╔═══██╗██║ ██╔╝██╔═══██╗██║ ██╔╝    ╚══██╔══╝██╔════╝╚██╗██╔╝╚══██╔══╝   ██║   ██║██║
--██║   ██║█████╔╝ ██║   ██║█████╔╝        ██║   █████╗   ╚███╔╝    ██║      ██║   ██║██║
--██║   ██║██╔═██╗ ██║   ██║██╔═██╗        ██║   ██╔══╝   ██╔██╗    ██║      ██║   ██║██║
--╚██████╔╝██║  ██╗╚██████╔╝██║  ██╗       ██║   ███████╗██╔╝ ██╗   ██║      ╚██████╔╝██║
-- ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝       ╚═╝   ╚══════╝╚═╝  ╚═╝   ╚═╝       ╚═════╝ ╚═╝


Citizen.CreateThread(function()
	local estado_barra = false
	
	while true do
		Citizen.Wait(500)
		
		if CurrentAction ~= nil and estado_barra == false then
			estado_barra = true
			if CurrentActionMsg ~= nil and CurrentActionMsg ~= '' then
				exports['okokTextUI']:Open(CurrentActionMsg, 'darkblue', 'left') 
			end
		elseif CurrentAction == nil and estado_barra == true then
			estado_barra = false
			exports['okokTextUI']:Close()
		end
	end
end)

--██╗  ██╗███████╗██╗   ██╗███████╗     ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  ██████╗ ██╗     
--██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝    ██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔═══██╗██║     
--█████╔╝ █████╗   ╚████╔╝ ███████╗    ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝██║   ██║██║     
--██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║    ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██║   ██║██║     
--██║  ██╗███████╗   ██║   ███████║    ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║╚██████╔╝███████╗
--╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝

-- Key Controls
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(10)

		if CurrentAction ~= nil then
			--ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) and PlayerData.job ~= nil and isJobPermitido(PlayerData.job.name) then

				if CurrentAction == 'menu_cloakroom' then
					if PlayerData.job.name == 'test' then
						OpenCloakroomMenu()
					else
						ESX.UI.Menu.CloseAll()
						TriggerEvent('casa:roupas')
						CurrentAction = nil
					end
				elseif CurrentAction == 'menu_armory' then
					local isArmoryInUse = false
						if Config[configuracao].MaxInService == -1 then 							
							if PlayerData.job.name == 'vagos' then
								if PlayerData.job.grade > 0 then
									if not isArmoryInUse then
										isArmoryInUse = true
										OpenArmoryMenu(CurrentActionData.station)
									else
										ESX.ShowNotification('O armário já está em uso por outra pessoa.')
									end
								else
									ESX.ShowNotification('O teu chefe bloqueou o acesso ao arsenal')
								end
							else
								if not isArmoryInUse then
									isArmoryInUse = true
									OpenArmoryMenu(CurrentActionData.station)
								else
									ESX.ShowNotification('O armário já está em uso por outra pessoa.')
								end
							end
						end
				elseif CurrentAction == 'menu_vehicle_spawner' then
				elseif CurrentAction == 'delete_vehicle' then
				elseif CurrentAction == 'menu_boss_actions' then
					ESX.UI.Menu.CloseAll()
					TriggerEvent('esx_society:openBossMenu', PlayerData.job.name, function(data, menu)
						menu.close()
						CurrentAction     = 'menu_boss_actions'
						CurrentActionMsg  = ""
						CurrentActionData = {}
					end, { wash = false }) -- disable washing money
				elseif CurrentAction == 'remove_entity' then
					DeleteEntity(CurrentActionData.entity)
				end
				
				CurrentAction = nil
			end
		end -- CurrentAction end
		
		if IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and isJobPermitido(PlayerData.job.name) and PlayerData.job.name ~= 'revisao' and PlayerData.job.name ~= 'sata' and PlayerData.job.name ~= 'usados' and PlayerData.job.name ~= 'golf' and PlayerData.job.name ~= 'ammunation' and PlayerData.job.name ~= 'vigne' and PlayerData.job.name ~= 'casino' and PlayerData.job.name ~= 'mob' and PlayerData.job.name ~= 'unicorn' and PlayerData.job.name ~= 'galaxy' and PlayerData.job.name ~= 'offroad' and PlayerData.job.name ~= 'reporter' and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions') then
			if Config[configuracao].MaxInService == -1 then
				
				if PlayerData.job.name == 'coast' and PlayerData.job.grade < 1 then
				
				else
					OpenmafiaActionsMenu()
				end
			elseif playerInService then
				OpenmafiaActionsMenu()
			else
				ESX.ShowNotification(_U('service_not'))
			end
		elseif IsControlJustReleased(0, Keys['F6']) and not isDead and PlayerData.job ~= nil and (PlayerData.job.name == 'reporter' or PlayerData.job.name == 'sata'  or PlayerData.job.name == 'unicorn' or PlayerData.job.name == 'galaxy' or PlayerData.job.name == 'mob' or PlayerData.job.name == 'offroad' or PlayerData.job.name == 'vigne' or PlayerData.job.name == 'golf' or PlayerData.job.name == 'casino' or PlayerData.job.name == 'revisao') and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'mafia_actions_bill') then
			OpenmafiaActions2Menu()
		end
		
		if IsControlJustReleased(0, Keys['E']) and CurrentTask.Busy then
			ESX.ShowNotification(_U('impound_canceled'))
			ESX.ClearTimeout(CurrentTask.Task)
			ClearPedTasks(PlayerPedId())
			
			CurrentTask.Busy = false
		end
	end
end)

function CloseArmoryMenu()
	isArmoryInUse = false 
end

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

DrawText3D = function(x,y,z, text, modifier, bg)
  local onScreen,_x,_y = World3dToScreen2d(x,y,z)
  local px,py,pz = table.unpack(GetGameplayCamCoord())
  local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*(modifier or 100)

  if onScreen then
    SetTextColour(220, 220, 220, 255)
    SetTextScale(0.0*scale, 0.40*scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextCentre(true)
    BeginTextCommandWidth("STRING")
    local width,height;
    if bg then
      AddTextComponentString(text)
      height = GetTextScaleHeight(0.45*scale, 4)
      width = EndTextCommandGetWidth(4)
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(_x, _y)
    if bg then
      DrawRect(_x, _y+scale/73, width, height, 35, 35, 35 , 200)
    end
  end
end


--	██╗ ██████╗ ██████╗ ███████╗    ██████╗ ███████╗██████╗ ███╗   ███╗██╗████████╗██╗██████╗  ██████╗ ███████╗
--	██║██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗██╔════╝██╔══██╗████╗ ████║██║╚══██╔══╝██║██╔══██╗██╔═══██╗██╔════╝
--	██║██║   ██║██████╔╝███████╗    ██████╔╝█████╗  ██████╔╝██╔████╔██║██║   ██║   ██║██║  ██║██║   ██║███████╗
-- ██   ██║██║   ██║██╔══██╗╚════██║    ██╔═══╝ ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║   ██║██║  ██║██║   ██║╚════██║
-- ╚█████╔╝╚██████╔╝██████╔╝███████║    ██║     ███████╗██║  ██║██║ ╚═╝ ██║██║   ██║   ██║██████╔╝╚██████╔╝███████║
--  ╚════╝  ╚═════╝ ╚═════╝ ╚══════╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝╚═════╝  ╚═════╝ ╚══════╝
	--------------JOBS SETUP-----------------------------------------

jobslist = {
	"grove",
	"ballas",
	"gang",
	"mafia",
	"cartel",
	"mungiki",
	"tequilla",
	"vagos",
	"black",
	"casino",
	"mob",
	"party",
	    "docks",
	    "purple",
	    "coast",
	    "golf",
	    "revisao",
	    "usados",
	    "sata",
	    "ammunation",
	    "vigne",
	    "unicorn",
	    "offroad",
	    --"ranger",
	    "yakuza",
	    "snake",
	    "galaxy",
    }

function isJobPermitido(namejob)

	for _, nomejob in pairs(jobslist) do
		if namejob == nomejob then
			return true
		end
	end

	return false
end
--------------------------------------------------------------------

RegisterNetEvent('mjob:body_search')
AddEventHandler('mjob:body_search', function()
	ESX.UI.Menu.CloseAll()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
								
	if distance ~= -1 and distance <= 3.0 then
		TriggerServerEvent('esx_mafiajob:message', GetPlayerServerId(closestPlayer), _U('being_searched'))
		TriggerEvent('inventory:revistar', true)		
		
	else
		exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
	end
end)

RegisterNetEvent('mjob:identity_card')
AddEventHandler('mjob:identity_card', function()
	ESX.UI.Menu.CloseAll()
	local closestPlayer, distance = ESX.Game.GetClosestPlayer()
								
	if distance ~= -1 and distance <= 3.0 then
		OpenIdentityCardMenu(closestPlayer)		
		TriggerServerEvent('esx_mafiajob:message', GetPlayerServerId(closestPlayer), 'A tua identificação está a ser vista!')
	else
		exports['mythic_notify']:SendAlert('error', 'Ninguém por perto!', 1500)
	end
end)



-- ██████╗  █████╗ ██████╗  █████╗  ██████╗ ███████╗███╗   ███╗     ██████╗ █████╗ ██╗   ██╗ ██████╗     ██████╗ ███████╗██████╗ ██╗ ██████╗ ██████╗ 
--██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝ ██╔════╝████╗ ████║    ██╔════╝██╔══██╗╚██╗ ██╔╝██╔═══██╗    ██╔══██╗██╔════╝██╔══██╗██║██╔════╝██╔═══██╗
--██║  ███╗███████║██████╔╝███████║██║  ███╗█████╗  ██╔████╔██║    ██║     ███████║ ╚████╔╝ ██║   ██║    ██████╔╝█████╗  ██████╔╝██║██║     ██║   ██║
--██║   ██║██╔══██║██╔══██╗██╔══██║██║   ██║██╔══╝  ██║╚██╔╝██║    ██║     ██╔══██║  ╚██╔╝  ██║   ██║    ██╔═══╝ ██╔══╝  ██╔══██╗██║██║     ██║   ██║
--╚██████╔╝██║  ██║██║  ██║██║  ██║╚██████╔╝███████╗██║ ╚═╝ ██║    ╚██████╗██║  ██║   ██║   ╚██████╔╝    ██║     ███████╗██║  ██║██║╚██████╗╚██████╔╝
-- ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝     ╚═════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝     ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═════╝ 




function ListVehiclesMenuCayo(x,y,z,h,job)
	local elements = {}

	ESX.TriggerServerCallback('cayo:getVehicles', function(vehicles)

		for _,v in pairs(vehicles) do

		local hashVehicule = v.vehicle.model
    		local vehicleName = GetDisplayNameFromVehicleModel(hashVehicule)
    		local labelvehicle
		local plate = v.plate

    		if(v.state)then
    		labelvehicle = vehicleName.. ' (' .. plate .. ') ' .. ' - Guardado'
    		else
    		labelvehicle = vehicleName.. ' (' .. plate .. ') ' ..' - Fora da Garagem'
    		end	
			table.insert(elements, {label =labelvehicle , value = v})
			
		end
	
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'spawn_vehicle',
		{
			title    = 'Garegem Cayo Perico',
			align    = 'top-left',
			elements = elements,
		},
		function(data, menu)
			if(data.current.value.state)then
				menu.close()
				SpawnVehicleCayo(data.current.value.vehicle, data.current.value.plate,x,y,z,h,job)
			else
				exports['mythic_notify']:SendAlert('Inform','Este veículo está fora da garagem', 4000)
			end
		end,
		function(data, menu)
			menu.close()
		end
	)	
	end)
end

function SpawnVehicleCayo(vehicle, plate, x,y,z,h,job)

	ESX.Game.SpawnVehicle(vehicle.model,{
		x=x,
		y=y,
		z=z + 1											
		},h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
		SetVehicleColours(callback_vehicle, Config.CorCayo[job], Config.CorCayo[job])
		SetVehicleNumberPlateText(callback_vehicle, plate)	
		end)

	TriggerServerEvent('cayo:modifystate', plate, false)

end

function GuardarCayo(vehicle,plate)
	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('cayo:modifystate', plate, true)
	exports['mythic_notify']:SendAlert('Inform', 'O veículo foi guardado', 4000)
	Citizen.Wait(10)
end

---------------------------------------------FIM GARAGEM CAYO---------------------------------------------------

--███████╗ █████╗ ████████╗ █████╗     
--██╔════╝██╔══██╗╚══██╔══╝██╔══██╗    
--███████╗███████║   ██║   ███████║    
--╚════██║██╔══██║   ██║   ██╔══██║    
--███████║██║  ██║   ██║   ██║  ██║    
--╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    
function VehicleInFront()
  local pos = GetEntityCoords(GetPlayerPed(-1))
  local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 5.0, 1.5)
  local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
  local a, b, c, d, result = GetRaycastResult(rayHandle)
 	if result ~= 0 then
		return result
	else
		local well, well2 = ESX.Game.GetClosestVehicle()
		if well2 ~= nil then
			if well2 < 5 then 
				return well 
			else 
				return result
			end
		else
			return result
		end
	end
end

----------------------------------------------------

RegisterNetEvent('mafiajob:limparcarro')
AddEventHandler('mafiajob:limparcarro', function()

	local playerPed = PlayerPedId()
	local vehicle   = ESX.Game.GetVehicleInDirection()
	local coords    = GetEntityCoords(playerPed)
	
	if IsPedSittingInAnyVehicle(playerPed) then
		ESX.ShowNotification('Tens de sair do veículo')
		return
	end
	
	if DoesEntityExist(vehicle) then
		isBusy = true
		TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
		Citizen.CreateThread(function()
			Citizen.Wait(10000)
			
			NetworkRequestControlOfEntity(vehicle)
			Citizen.Wait(1)
			NetworkRequestControlOfEntity(vehicle)
			
			SetVehicleDirtLevel(vehicle, 0)
			ClearPedTasks(playerPed)
	
			ESX.ShowNotification('Veículo Limpo')
			isBusy = false
		end)
	else
		TriggerEvent('rcore_spray:removeClosestSpray')
	end
end)


RegisterNetEvent('esx_mafiajob:recebertabuleiro')
AddEventHandler('esx_mafiajob:recebertabuleiro', function(comando)
	if comando == 'e tabuleiro' or comando == 'e tabuleiro2' or comando == 'e tabuleiro3' then	
		ExecuteCommand(comando)
	end
end)



function AbrirArsenalG6(station)
	TriggerEvent('inventory:abrirstock',
	'stock',
	'Arsenal  <b>Gruppe 6</b>',
	{
		{
			name = "WEAPON_STUNGUN",
			type = "weapon",
			ammo = 1
		},
		{
			name = "WEAPON_NIGHTSTICK",
			type = "weapon",
			ammo = 1
		},
		{
			name = "WEAPON_FireExtinguisher",
			type = "weapon",
			ammo = 1000
		},
		{
			name = "WEAPON_Flashlight",
			type = "weapon",
			ammo = 1
		}

	
	})
end

local ativoumesas = 0
local mesasCriadas = {}

RegisterCommand("Colocarcadeiras", function()
    local source = source
    if (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff') and PlayerData.job.grade > 5 then
        ativoumesas = ativoumesas + 1
        TriggerEvent('Colocarcadeiras', ativoumesas)
    end
end, false)

RegisterNetEvent('Colocarcadeiras')
AddEventHandler('Colocarcadeiras', function(num)
    if num == 1 then
        local function CriarCadeira(x, y, z, heading)
            local modelHash = GetHashKey("p_soloffchair_s")
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Citizen.Wait(0)
            end

            local obj = CreateObject(modelHash, x, y, z, true, true, true)
            
            PlaceObjectOnGroundProperly(obj)
            SetEntityHeading(obj, heading)
            SetModelAsNoLongerNeeded(modelHash)
            table.insert(mesasCriadas, obj)
        end
	CriarCadeira(-560.342, 267.1330, 82.927, -80.54)

	local function criarMesaComGarrafa(x, y, z, heading)
		local mesaHash = GetHashKey("prop_table_03")
		RequestModel(mesaHash)
		while not HasModelLoaded(mesaHash) do
		    Citizen.Wait(0)
		end
    
		local mesa = CreateObject(mesaHash, x, y, z, true, true, true)
		SetEntityHeading(mesa, heading)
		PlaceObjectOnGroundProperly(mesa)
		SetModelAsNoLongerNeeded(mesaHash)
		table.insert(mesasCriadas, mesa)
    
		local garrafaX = x + 0.0
		local garrafaY = y + 0.0
		local garrafaZ = z -- Ajusta para a altura correta
    
		local garrafaHash = GetHashKey("prop_wine_bot_01")
		RequestModel(garrafaHash)
		while not HasModelLoaded(garrafaHash) do
		    Citizen.Wait(0)
		end
    
		local garrafa = CreateObject(garrafaHash, garrafaX, garrafaY, garrafaZ, true, true, true)
		SetEntityHeading(garrafa, heading)
		SetModelAsNoLongerNeeded(garrafaHash)
		table.insert(mesasCriadas, garrafa)
	    end

	    criarMesaComGarrafa(-562.350, 266.6381, 82.962, 287.35)
    end
end)

RegisterCommand("ApagarCadeiras", function()
    for _, mesa in pairs(mesasCriadas) do
        if DoesEntityExist(mesa) then
            DeleteObject(mesa)
        end
    end
    mesasCriadas = {}  
    ativoumesas = 0  
end, false)



RegisterNetEvent('esx_mafiajob:ComecarAnimTabuleio')
AddEventHandler('esx_mafiajob:ComecarAnimTabuleio', function(action)
    if action == 'tabuleiro' then
        ExecuteCommand('e tabuleiro')
    elseif action == 'tabuleiro2' then
	ExecuteCommand('e tabuleiro2')
    elseif action == 'tabuleiro3' then
        ExecuteCommand('e tabuleiro3')
    end
end)


	