local ESX	 = nil
local GUI = {}
GUI.Time = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

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

local vehicleCruiser = 'off'
local seatbeltEjectSpeed = 45.0 
local seatbeltEjectAccel = 100.0
local beltWarningSet = false
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
local speedBuffer  	  = {}
local velBuffer  	  = {}
local isBlackedOut = false
local seatbeltSpeedPedOut = 1.6
local MinSpeedBelt = 45
local lastVehCache
local PedVehIsHeli = false
local PedVehIsPlane = false
local PedVehIsBoat = false 
local PedVehIsBike = false 
local PedVehIsCar = false
local PedVehIsMotorcycle = false

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local AllWeapons = json.decode('{"melee":{"dagger":"0x92A27487","bat":"0x958A4A8F","bottle":"0xF9E6AA4B","crowbar":"0x84BD7BFD","unarmed":"0xA2719263","flashlight":"0x8BB05FD7","golfclub":"0x440E4788","hammer":"0x4E875F73","hatchet":"0xF9DCBF2D","knuckle":"0xD8DF3C3C","knife":"0x99B507EA","machete":"0xDD5DF8D9","switchblade":"0xDFE37640","nightstick":"0x678B81B1","wrench":"0x19044EE0","battleaxe":"0xCD274149","poolcue":"0x94117305","stone_hatchet":"0x3813FC08"},"handguns":{"pistol":"0x1B06D571","pistol_mk2":"0xBFE256D4","combatpistol":"0x5EF9FEC4","appistol":"0x22D8FE39","stungun":"0x3656C8C1","pistol50":"0x99AEEB3B","snspistol":"0xBFD21232","snspistol_mk2":"0x88374054","heavypistol":"0xD205520E","vintagepistol":"0x83839C4","flaregun":"0x47757124","marksmanpistol":"0xDC4DB296","revolver":"0xC1B3C3D1","revolver_mk2":"0xCB96392F","doubleaction":"0x97EA20B8","raypistol":"0xAF3696A1"},"smg":{"microsmg":"0x13532244","smg":"0x2BE6766B","smg_mk2":"0x78A97CD0","assaultsmg":"0xEFE7E2DF","combatpdw":"0xA3D4D34","machinepistol":"0xDB1AA450","minismg":"0xBD248B55","raycarbine":"0x476BF155"},"shotguns":{"pumpshotgun":"0x1D073A89","pumpshotgun_mk2":"0x555AF99A","sawnoffshotgun":"0x7846A318","assaultshotgun":"0xE284C527","bullpupshotgun":"0x9D61E50F","musket":"0xA89CB99E","heavyshotgun":"0x3AABBBAA","dbshotgun":"0xEF951FBB","autoshotgun":"0x12E82D3D"},"assault_rifles":{"assaultrifle":"0xBFEFFF6D","assaultrifle_mk2":"0x394F415C","carbinerifle":"0x83BF0278","carbinerifle_mk2":"0xFAD1F1C9","advancedrifle":"0xAF113F99","specialcarbine":"0xC0A3098D","specialcarbine_mk2":"0x969C3D67","bullpuprifle":"0x7F229F94","bullpuprifle_mk2":"0x84D6FAFD","compactrifle":"0x624FE830"},"machine_guns":{"mg":"0x9D07F764","combatmg":"0x7FD62962","combatmg_mk2":"0xDBBD7280","gusenberg":"0x61012683"},"sniper_rifles":{"sniperrifle":"0x5FC3C11","heavysniper":"0xC472FE2","heavysniper_mk2":"0xA914799","marksmanrifle":"0xC734385A","marksmanrifle_mk2":"0x6A6C02E0"},"heavy_weapons":{"rpg":"0xB1CA77B1","grenadelauncher":"0xA284510B","grenadelauncher_smoke":"0x4DD2DC56","minigun":"0x42BF8A85","firework":"0x7F7497E5","railgun":"0x6D544C99","hominglauncher":"0x63AB0442","compactlauncher":"0x781FE4A","rayminigun":"0xB62D1F67"},"throwables":{"grenade":"0x93E220BD","bzgas":"0xA0973D5E","smokegrenade":"0xFDBC8A50","flare":"0x497FACC3","molotov":"0x24B17070","stickybomb":"0x2C3731D9","proxmine":"0xAB564B93","snowball":"0x787F0BB","pipebomb":"0xBA45E8B8","ball":"0x23C9F95C"},"misc":{"petrolcan":"0x34A67B97","fireextinguisher":"0x60EC506","parachute":"0xFBAB5776"}}')




local vehiclesCars = {0,1,2,3,4,5,6,7,8,9,10,11,12,17,18,19,20};

Citizen.CreateThread(function()

    local isPauseMenu = false

	while true do
		Citizen.Wait(0)

		if IsPauseMenuActive() then
			if not isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = false })
			end
		else
			if isPauseMenu then
				isPauseMenu = not isPauseMenu
				SendNUIMessage({ action = 'toggleUi', value = true })
			end

			HideHudComponentThisFrame(1)  
			HideHudComponentThisFrame(2)  
			HideHudComponentThisFrame(3)  
			HideHudComponentThisFrame(4)  
			HideHudComponentThisFrame(6)  
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9) 
			HideHudComponentThisFrame(13)
			HideHudComponentThisFrame(17) 
			HideHudComponentThisFrame(20) 
		end
	end
end)




Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)
			SendNUIMessage({ action = 'setText', id = 'idmostrar', value = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1))) })
			if Config.ui.showDate == true then
				SendNUIMessage({ action = 'setText', id = 'date', value = trewDate() })
			end
		Wait(100)

		local player = GetPlayerPed(-1)

		local position = GetEntityCoords(player)

		if Config.ui.showLocation == true then
			local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
			local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))

			local locationMessage = nil

			if zoneNameFull then 
				locationMessage = streetName .. ', ' .. zoneNameFull
			else
				locationMessage = streetName
			end

			if position.y < -4000 then
				locationMessage = 'Cayo Perico'
			end

			locationMessage = string.format(
				Locales[Config.Locale]['you_are_on_location'],
				locationMessage
			)

			SendNUIMessage({ action = 'setText', id = 'location', value = locationMessage })
		end
	Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if Config.ui.showHealth == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['isdead'] = false

			playerStatus['status'][showPlayerStatus] = {
				name = 'health',
				value = GetEntityHealth(GetPlayerPed(-1)) - 100
			}

			if IsEntityDead(GetPlayerPed(-1)) then
				playerStatus.isdead = true
			end
		end

		if Config.ui.showArmor == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'armor',
				value = GetPedArmour(GetPlayerPed(-1)),
			}
		end

		if Config.ui.showStamina == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'stamina',
				value = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
			}
		end

		TriggerServerEvent('trew_hud_ui:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end
		Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if Config.ui.showHealth == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['isdead'] = false

			playerStatus['status'][showPlayerStatus] = {
				name = 'health',
				value = GetEntityHealth(GetPlayerPed(-1)) - 100
			}

			if IsEntityDead(GetPlayerPed(-1)) then
				playerStatus.isdead = true
			end
		end

		if Config.ui.showArmor == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'armor',
				value = GetPedArmour(GetPlayerPed(-1)),
			}
		end

		if Config.ui.showStamina == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'stamina',
				value = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
			}
		end

		TriggerServerEvent('trew_hud_ui:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end
	

		Citizen.Wait(2000)

			local player = GetPlayerPed(-1)
			local status = {}

			if IsPedArmed(player, 7) then

				local weapon = GetSelectedPedWeapon(player)
				local ammoTotal = GetAmmoInPedWeapon(player,weapon)
				local bool,ammoClip = GetAmmoInClip(player,weapon)
				local ammoRemaining = math.floor(ammoTotal - ammoClip)
				
				status['armed'] = true

				for key,value in pairs(AllWeapons) do

					for keyTwo,valueTwo in pairs(AllWeapons[key]) do
						if weapon == GetHashKey('weapon_'..keyTwo) then
							status['weapon'] = keyTwo


							if key == 'melee' then
								SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
								SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
							else
								if keyTwo == 'stungun' then
									SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon_bullets' })
									SendNUIMessage({ action = 'element', task = 'disable', value = 'bullets' })
								else
									SendNUIMessage({ action = 'element', task = 'enable', value = 'weapon_bullets' })
									SendNUIMessage({ action = 'element', task = 'enable', value = 'bullets' })
								end
							end

						end
					end

				end
				SendNUIMessage({ action = 'setText', id = 'weapon_clip', value = ammoClip })
				SendNUIMessage({ action = 'setText', id = 'weapon_ammo', value = ammoRemaining })
			else
				status['armed'] = false	
			end

			SendNUIMessage({ action = 'updateWeapon', status = status })

		
	end
end)

local vehicleCruiser
local vehicleSignalIndicator = 'off'
local seatbeltIsOn = false
local currSpeed = 0.0
local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}



WichVehicleItIs = function(veh)
	if(lastVehCache == nil or lastVehCache ~= veh) then
		lastVehCache = veh
		PedVehIsHeli = false
		PedVehIsPlane = false
		PedVehIsBoat = false 
		PedVehIsBike = false 
		PedVehIsCar = false
		PedVehIsMotorcycle = false
		local vc = GetVehicleClass(veh)
		if( (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)) then
			PedVehIsCar = true
		elseif(vc == 8) then
			PedVehIsMotorcycle = true
		elseif(vc == 13) then
			PedVehIsBike = true
		elseif(vc == 14) then
			PedVehIsBoat = true
		elseif(vc == 15) then
			PedVehIsHeli = true
		elseif(vc == 16) then
			PedVehIsPlane = true
		end
	end
end

RegisterNetEvent('trew_hud_ui:setInfo')
AddEventHandler('trew_hud_ui:setInfo', function(info)

	SendNUIMessage({ action = 'setText', id = 'job', value = info['job'] })
	SendNUIMessage({ action = 'setMoney', id = 'wallet', value = info['money'] })
	SendNUIMessage({ action = 'setMoney', id = 'bank', value = info['bankMoney'] })
	SendNUIMessage({ action = 'setMoney', id = 'blackMoney', value = info['blackMoney'] })

	if ESX.PlayerData.job ~= nil then
		if ESX.PlayerData.job.grade_name ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
			if (Config.ui.showSocietyMoney == true) then
				SendNUIMessage({ action = 'element', task = 'enable', value = 'society' })
			end
			ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
				SendNUIMessage({ action = 'setMoney', id = 'society', value = money })
			end, ESX.PlayerData.job.name)
		else
			SendNUIMessage({ action = 'element', task = 'disable', value = 'society' })
		end
	end

	local playerStatus 
	local showPlayerStatus = 0
	playerStatus = { action = 'setStatus', status = {} }


	if Config.ui.showHunger == true then
		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('cframework:getStatus', 'hunger', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'hunger',
				value = math.floor(100-status.getPercent())
			}
		end)

	end

	if Config.ui.showThirst == true then
		showPlayerStatus = (showPlayerStatus+1)

		TriggerEvent('cframework:getStatus', 'thirst', function(status)
			playerStatus['status'][showPlayerStatus] = {
				name = 'thirst',
				value = math.floor(100-status.getPercent())
			}
		end)
	end

	if showPlayerStatus > 0 then
		SendNUIMessage(playerStatus)
	end


end)

Citizen.CreateThread(function()

	if Config.ui.showVoice == true then

	    RequestAnimDict('facials@gen_male@variations@normal')
	    RequestAnimDict('mp_facial')

	    while true do
	        Citizen.Wait(300)
	        local playerID = PlayerId()

	        for _,player in ipairs(GetActivePlayers()) do
	            local boolTalking = NetworkIsPlayerTalking(player)

	            if player ~= playerID then
	                if boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mic_chatter', 'mp_facial')
	                elseif not boolTalking then
	                    PlayFacialAnim(GetPlayerPed(player), 'mood_normal_1', 'facials@gen_male@variations@normal')
	                end
	            end
	        end
	    end

	end
end)



Citizen.CreateThread(function()
	if Config.ui.showVoice == true then

		local isTalking = false
		local voiceDistance = nil

		while true do
			Citizen.Wait(1)

			if NetworkIsPlayerTalking(PlayerId()) and not isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			elseif not NetworkIsPlayerTalking(PlayerId()) and isTalking then 
				isTalking = not isTalking
				SendNUIMessage({ action = 'isTalking', value = isTalking })
			end

			if IsControlJustPressed(1, Keys[Config.voice.keys.distance]) then

                Config.voice.levels.current = (Config.voice.levels.current + 1) % 3

				if Config.voice.levels.current == 0 then
					NetworkSetTalkerProximity(Config.voice.levels.default)
					voiceDistance = 'normal'
					exports['okokNotify']:Alert("VOZ", "Estás a falar normal.", 3000, 'success')

				elseif Config.voice.levels.current == 1 then
					NetworkSetTalkerProximity(Config.voice.levels.shout)
					voiceDistance = 'shout'
					exports['okokNotify']:Alert("VOZ", "Estás a gritar.", 3000, 'error')

				elseif Config.voice.levels.current == 2 then
					NetworkSetTalkerProximity(Config.voice.levels.whisper)
					voiceDistance = 'whisper'
					exports['okokNotify']:Alert("VOZ", "Estás a sussurrar.", 3000, 'info')
				end

                SendNUIMessage({ action = 'setVoiceDistance', value = voiceDistance })
            end

            if Config.voice.levels.current == 0 then
                voiceDistance = 'normal'
            elseif Config.voice.levels.current == 1 then
                voiceDistance = 'shout'
            elseif Config.voice.levels.current == 2 then
                voiceDistance = 'whisper'
            end


        end
	end
end)

Fwv = function (entity)
		    local hr = GetEntityHeading(entity) + 90.0
		    if hr < 0.0 then hr = 360.0 + hr end
		    hr = hr * 0.0174533
		    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        local MyPed = GetPlayerPed(-1)
        local MyPedVeh = GetVehiclePedIsIn(MyPed, false)
        if IsPedInAnyVehicle(MyPed, false) then
            WichVehicleItIs(MyPedVeh)
            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(MyPedVeh)
            
            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(MyPedVeh)
            
            -- perform extreme stunting exercise
           --[[ if ((speedBuffer[2] ~= nil and velBuffer[2] ~= nil) and ((speedBuffer[2] > (MinSpeedBelt / 3.6) and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * seatbeltSpeedPedOut)) or (speedBuffer[1] > (MinSpeedBelt / 7.2) and (speedBuffer[1] - speedBuffer[2]) > (speedBuffer[2] * seatbeltSpeedPedOut)))) then
                if(PedVehIsMotorcycle == false and PedVehIsBike == false and PedVehIsHeli == false and PedVehIsPlane == false and PedVehIsBoat == false) then
                    if(not seatbeltIsOn)then
                        local co = GetEntityCoords(MyPed)
                        local fw = Fwv(MyPed)
                        if (IsVehicleWindowIntact(MyPedVeh, 6)) then
                            SmashVehicleWindow(MyPedVeh, 6)
                        end
						SetEntityCoords(MyPed, co.x + fw.x, co.y + fw.y, co.z-0.47, true, true, true)
                        Citizen.Wait(1)
                        SetPedToRagdoll(MyPed, 1000, 1000, 0, 0, 0, 0)
                        SetEntityVelocity(MyPed, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                    else
                        blackout()
                    end
                end
                local pedIsDriver = (GetPedInVehicleSeat(MyPedVeh, -1) == MyPed)
                if(pedIsDriver)then
                    if(autopilotActive)then
                        DeactivateAutopilot()
                    end
                    if(not seatbeltIsOn)then
                        TriggerEvent("esx_status:add","stress",600000)
                    else
                        TriggerEvent("esx_status:add","stress",300000)
                    end
                end
			end]]

		else
			Citizen.Wait(1000)
		end
	end
end)

local function roundToNthDecimal(num, n)
    local mult = 10^(n or 0)
    return math.floor(num * mult + 0.5) / mult
  end

local prevGear = nil

local invehicle = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)

		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		local position = GetEntityCoords(player)
		local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)
		local vehicleInfo

		if IsPedInAnyVehicle(player, false) then
			if not invehicle then
				invehicle = true
				entervehicle()
				--entervehicle2()
			end
			--entervehicle2()
			-- Vehicle Speed
			local vehicleSpeedSource = GetEntitySpeed(vehicle)
			local vehicleSpeed
			vehicleSpeed = math.ceil(vehicleSpeedSource * 3.6)
			-- Vehicle Nail Speed
			local vehicleNailSpeed

			vehicleNailSpeed = math.ceil(  280 - math.ceil( math.ceil(vehicleSpeed * 205) / Config.vehicle.maxSpeed) )
			-- Vehicle Fuel and Gear
			local vehicleFuel = GetVehicleFuelLevel(vehicle)
			local vehicleGear = GetVehicleCurrentGear(vehicle)
			local vehicleClass = GetVehicleClass(vehicle)

			--[[if prevGear ~= vehicleGear then
				prevGear = vehicleGear
				Citizen.CreateThread(function()
					print('mudei')
					RequestAnimDict("veh@driveby@first_person@passenger_rear_right_handed@smg") 
					TaskPlayAnim(player, "veh@driveby@first_person@passenger_rear_right_handed@smg", "outro_90r", 8.0, 1, 50, 0, 0, 0, 0, 0 )
					Citizen.Wait(100)
					--StopAnimTask(player, 'veh@driveby@first_person@passenger_rear_right_handed@smg', 'outro_90r', 1.0)
					ClearPedTasks(player)
				end)
			end]]

			if (vehicleSpeed == 0 and vehicleGear == 0) or (vehicleSpeed == 0 and vehicleGear == 1) then
				vehicleGear = 'N'
			elseif vehicleSpeed > 0 and vehicleGear == 0 then
				vehicleGear = 'R'
			end
			-- Vehicle Lights
			local vehicleVal,vehicleLights,vehicleHighlights  = GetVehicleLightsState(vehicle)
			local vehicleIsLightsOn
			if vehicleLights == 1 and vehicleHighlights == 0 then
				vehicleIsLightsOn = 'normal'
			elseif (vehicleLights == 1 and vehicleHighlights == 1) or (vehicleLights == 0 and vehicleHighlights == 1) then
				vehicleIsLightsOn = 'high'
			else
				vehicleIsLightsOn = 'off'
            end
            
            -- Vehicle Indicators
			local indicatorLights  = GetVehicleIndicatorLights(vehicle)
			if indicatorLights == 1 then
                vehicleSignalIndicator = 'left'
			elseif (indicatorLights == 2) then
                vehicleSignalIndicator = 'right'
            elseif (indicatorLights == 3) then
                vehicleSignalIndicator = 'both'   
            else
                vehicleSignalIndicator = 'off'
			end
			-- Vehicle Seatbelt
			if PedVehIsCar == true then

				local prevSpeed = currSpeed
                currSpeed = vehicleSpeedSource

                SetPedConfigFlag(PlayerPedId(), 32, true)

                if not seatbeltIsOn then
                	local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if(beltWarningSet == false) then
                        if(currSpeed > 1 or currSpeed < -1) then
                            beltWarningSet = true
                            TriggerEvent("mole_notifications:SendNotification", {text = "Acuerdate de ponerte el cinturón", type = "info", timeout = 1400})
							
							--TriggerServerEvent('esx_mole_misiones:PlayOnSource', 'beltwarning', 0.7)
							DisableControlAction(0, 75, false)
						end
                    end
					--[[if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
						--if has then
							SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        	SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        	SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
							local desmaia = true
							Citizen.CreateThread(function()
								while desmaia do
									Citizen.Wait(0)
									SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
								end
							end)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
								desmaia = false
							end)
						--end
                    else
                        -- Update previous velocity for ejecting player
                        prevVelocity = GetEntityVelocity(vehicle)
                    end]]
                else
					DisableControlAction(0, 75, true)
				
                end
            end

			local vehicleSiren

			if IsVehicleSirenOn(vehicle) then
				vehicleSiren = true
			else
				vehicleSiren = false
			end
            
            rpm = GetVehicleCurrentRpm(vehicle)
            rpm = math.ceil(rpm * 10000, 2)
            vehicleNailRpm = 280 - math.ceil( math.ceil((rpm-2000) * 140) / 10000)
            cardamage = GetVehicleEngineHealth(vehicle) / 10 
            vehicleInfo = {
				action = 'updateVehicle',
				updateVehicle = true,
                status = true,
                speed = vehicleSpeed,
                nail = vehicleNailSpeed,
                gear = vehicleGear,
                fuel = vehicleFuel,
                lights = vehicleIsLightsOn,
                signals = vehicleSignalIndicator,
                cruiser = vehicleCruiser,
				type = vehicleClass,
				siren = vehicleSiren,
               -- currentKM = roundToNthDecimal(DecorGetFloat(vehicle,'TOTALKM')*100,1),
				seatbelt = Config.vehicle.seatbelt,
				haveBelt = PedVehIsCar,
                damage = cardamage,
                rpmnail = vehicleNailRpm,
                rpm = rpm,
                config = {
                    speedUnit = Config.vehicle.speedUnit,
                    maxSpeed = Config.vehicle.maxSpeed
                }
			}
			vehicleInfo['seatbelt']['status'] = seatbeltIsOn
		else

			invehicle = false

			vehicleCruiser = 'off'
			vehicleNailSpeed = 0
            vehicleSignalIndicator = 'off'
			speedBuffer[1], speedBuffer[2] = 0.0, 0.0
			if(beltWarningSet)then
				
				--TriggerServerEvent('esx_mole_misiones:StopSoundOnSource')
			end
            seatbeltIsOn = false
            beltWarningSet = false

			vehicleInfo = {
				action = 'updateVehicle',
				updateVehicle = true,
                status = false,
                nail = 0,
                rpmnail = 0,
                seatbelt = { status = seatbeltIsOn },
                cruiser = vehicleCruiser,
                signals = vehicleSignalIndicator,
				type = 0,
			}
			Citizen.Wait(1000)
		end
		SendNUIMessage(vehicleInfo)
	end
end)

function entervehicle()
local has = true
local vehicle
local playerCoords

Citizen.CreateThread(function()
	while invehicle do
		Citizen.Wait(0)
		--print('estou')

		local playerPed = PlayerPedId()
		has = HasCollisionLoadedAroundEntity(playerPed)
		vehicle = GetVehiclePedIsIn(playerPed, false)
		if has then
			playerCoords = GetEntityCoords(playerPed)
		end
		if not has then
			--print('perdeu texturas')
			if IsEntityInAir(vehicle) then
				SetEntityCoordsNoOffset(vehicle, playerCoords, 0, 0, 1)
				ESX.ShowNotification('Ias cair no limbo, verifica as tuas texturas.', 'error')
			end
		end
	end
end)

Citizen.CreateThread(function ()

	while invehicle do
		Citizen.Wait(0)
		local player = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(player, false)
		if vehicleCruiser == 'off' then
			SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
		end
		local vehicleClass = GetVehicleClass(vehicle)
		if seatbeltIsOn then 
			DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
			DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
		end
		-- Vehicle Seatbelt
		if IsPedInAnyVehicle(player, false) then
			if IsControlJustReleased(0,  Keys['B']) then
				WichVehicleItIs(vehicle)
				if(PedVehIsCar)then
					seatbeltIsOn = not seatbeltIsOn
					if seatbeltIsOn then
						if(beltWarningSet)then
							
							--TriggerServerEvent('esx_mole_misiones:StopSoundOnSource')
						end
						
							TriggerServerEvent('InteractSound_SV:PlayOnSource', 'porcinto', 0.5)
						--TriggerEvent("mole_notifications:SendNotification", {text = "Cinturón puesto", type = "success", timeout = 1400})
						
						--	TriggerServerEvent('esx_mole_misiones:PlayOnSource','buckle', 0.9)
					else
						
						TriggerServerEvent('InteractSound_SV:PlayOnSource', 'tirarcinto', 0.5)
						--TriggerEvent("mole_notifications:SendNotification", {text = "Cinturón quitado", type = "error", timeout = 1400})
						
						--TriggerServerEvent('esx_mole_misiones:PlayOnSource', 'unbuckle', 0.9)
						beltWarningSet = false
						if(autopilotActive)then
							DeactivateAutopilot()
						end
					end
				end
			end
		end

		-- Vehicle Cruiser
		if IsControlJustPressed(1, Config.vehicle.keys.cruiser) and GetPedInVehicleSeat(vehicle, -1) == player then
			local vehicleClass = GetVehicleClass(vehicle)
			if(vehicleClass ~= 13 and vehicleClass ~= 15 and vehicleClass ~= 16)then
				local vehicleSpeedSource = GetEntitySpeed(vehicle)
				local kmhSpeed = math.ceil(vehicleSpeedSource*3.6)
				if vehicleCruiser == 'on' then
					vehicleCruiser = 'off'
					--local handlingMaxSpeed = GetVehicleHandlingMaxSpeed(vehicle)
					SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel"))
				else
					if(kmhSpeed > 20)then
						vehicleCruiser = 'on'
						SetEntityMaxSpeed(vehicle, vehicleSpeedSource)
					end
				end
			end
        end
        if IsControlJustPressed(1, Config.vehicle.keys.signalLeft) then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'left'
			else
				vehicleSignalIndicator = 'off'
			end
			TriggerEvent('esx_mole_status:setCarSignalLights', vehicleSignalIndicator)
		end

		if IsControlJustPressed(1, Config.vehicle.keys.signalRight) then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'right'
			else
				vehicleSignalIndicator = 'off'
			end

			TriggerEvent('esx_mole_status:setCarSignalLights', vehicleSignalIndicator)
		end

		if IsControlJustPressed(1, Config.vehicle.keys.signalBoth) then
			if vehicleSignalIndicator == 'off' then
				vehicleSignalIndicator = 'both'
			else
				vehicleSignalIndicator = 'off'
			end
			TriggerEvent('esx_mole_status:setCarSignalLights', vehicleSignalIndicator)
        end
	end
end)
end
AddEventHandler('onClientMapStart', function()

	SendNUIMessage({ action = 'ui', config = Config.ui })
	SendNUIMessage({ action = 'setFont', url = Config.font.url, name = Config.font.name })
	SendNUIMessage({ action = 'setLogo', value = Config.serverLogo })
	
	if Config.ui.showVoice == true then
		if Config.voice.levels.current == 0 then
			NetworkSetTalkerProximity(Config.voice.levels.default)
		elseif Config.voice.levels.current == 1 then
			NetworkSetTalkerProximity(Config.voice.levels.shout)
		elseif Config.voice.levels.current == 2 then
			NetworkSetTalkerProximity(Config.voice.levels.whisper)
		end
	end
end)

AddEventHandler('playerSpawned', function()
	if Config.ui.showVoice == true then
	    NetworkSetTalkerProximity(5.0)
	end

	HideHudComponentThisFrame(7) 
	HideHudComponentThisFrame(9) 
	HideHudComponentThisFrame(6) 
	HideHudComponentThisFrame(3) 
	HideHudComponentThisFrame(4) 
	HideHudComponentThisFrame(13) 
end)


function trewDate()
	local timeString = nil

	local year3, month3, day3, hour3, minute3, second3 = GetLocalTime()

	local day2 = ''


	local hour = GetClockHours()
	local minutes = GetClockMinutes()
	local time = nil
	local AmPm = ''

	if Config.Simoes == true then

		if hour3 + 1 <= 9 then
			hour3 = '0' ..hour3 + 1
		end
		if minute3 <= 9 then
			minute3 = '0' ..minute3
		end
	end

	time78 = hour3 .. ':' .. minute3

	if Config.date.AmPm == true then

		if hour >= 13 and hour <= 24 then
			hour = hour - 12
			AmPm = 'PM'
		else
			if hour == 0 or hour == 24 then
				hour = 12
			end
			AmPm = 'AM'
		end

	end

	if hour <= 9 then
		hour = '0' .. hour
	end
	if minutes <= 9 then
		minutes = '0' .. minutes
	end

	time = hour .. ':' .. minutes .. ' ' .. AmPm

	local date_format = ' <b> ' .. time78 .. '</b> (UTC +1) <b>| ' .. time .. '</b> (Local)'

	if Config.date.format == 'default' then
		timeString = string.format(
			date_format,
			time
		)
	elseif Config.date.format == 'simple' then
		timeString = string.format(
			date_format,
			day, month
		)

	elseif Config.date.format == 'simpleWithHours' then
		timeString = string.format(
			date_format,
			time, time2, day5
		)	
	elseif Config.date.format == 'simoes' then
		timeString = string.format(
			date_format
		)	
	elseif Config.date.format == 'withWeekday' then
		timeString = string.format(
			date_format,
			weekDay, day, month, year
		)
	elseif Config.date.format == 'withHours' then
		timeString = string.format(
			date_format,
			time, day, month, year
		)
	elseif Config.date.format == 'withWeekdayAndHours' then
		timeString = string.format(
			date_format,
			time, weekDay, day, month, year
		)
	end
	return timeString
end


function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local toggleui = false
RegisterCommand('hud_todo', function()
	if not toggleui then
		SendNUIMessage({ action = 'element', task = 'disable', value = 'health' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'thirst' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'hunger' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'stamina' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'armor' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'voice' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'discord2' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'ids' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'location' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'idmostrar' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'infoid' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'infodd' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'date' })

		DisplayRadar(false)
		TriggerEvent('esx:desativarChat', true)
	else
		SendNUIMessage({ action = 'element', task = 'enable', value = 'health' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'thirst' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'hunger' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'stamina' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'armor' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'voice' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'discord2' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'ids' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'location' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'idmostrar' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'infoid' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'infodd' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'weapon' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'date' })
		DisplayRadar(true)
		TriggerEvent('esx:desativarChat', false)
	end

	if (GetGameTimer() - GUI.Time) > 300 then
		openInterface()	
	end
	toggleui = not toggleui
end)

RegisterCommand('hud', function()
	if not toggleui then
		SendNUIMessage({ action = 'element', task = 'disable', value = 'voice' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'discord2' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'ids' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'location' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'idmostrar' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'infoid' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'infodd' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'weapon' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'date' })
		DisplayRadar(false)
	else
		SendNUIMessage({ action = 'element', task = 'enable', value = 'voice' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'discord2' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'ids' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'location' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'idmostrar' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'infoid' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'infodd' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'weapon' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'date' })
		DisplayRadar(true)
	end
	
	if (GetGameTimer() - GUI.Time) > 300 then
		openInterface()	
	end

	toggleui = not toggleui
end)


local interface = true
local isPaused = false

function openInterface()
  interface = not interface
  if not interface then 
	ESX.UI.HUD.SetDisplay(0.0)
	TriggerEvent('es:setMoneyDisplay', 0.0)
  elseif interface then 
	ESX.UI.HUD.SetDisplay(1.0)
	TriggerEvent('es:setMoneyDisplay', 1.0)
  end
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if (IsPauseMenuActive() or IsControlPressed(1, 37)) and not isPaused and not interface then
		isPaused = true
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
	elseif (IsPauseMenuActive() or IsControlPressed(1, 37)) and not isPaused and interface then
		isPaused = true
     	ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
	elseif not (IsPauseMenuActive() or IsControlPressed(1, 37)) and isPaused and not interface then
		isPaused = false 
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
	elseif not (IsPauseMenuActive() or IsControlPressed(1, 37)) and isPaused and interface then
		isPaused = false
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('es:setMoneyDisplay', 1.0)
	elseif not interface then
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
    end
  end
end)

exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)

exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end)

RegisterNetEvent('esx_mole_status:setBeltOn')
AddEventHandler('esx_mole_status:setBeltOn', function()
	if not seatbeltIsOn then
		seatbeltIsOn = true
		TriggerEvent("mole_notifications:SendNotification", {text = "Cinturón puesto", type = "success", timeout = 1400})
		
TriggerServerEvent('esx_mole_misiones:PlayOnSource','buckle', 0.9)
	end
end)
RegisterNetEvent('esx_mole_status:setBeltOff')
AddEventHandler('esx_mole_status:setBeltOff', function()
	if  seatbeltIsOn then
		seatbeltIsOn = false
		TriggerEvent("mole_notifications:SendNotification", {text = "Cinturón quitado", type = "error", timeout = 1400})
		
TriggerServerEvent('esx_mole_misiones:PlayOnSource', 'unbuckle', 0.9)
		beltWarningSet = false
	end
end)

AddEventHandler('esx_mole_status:setCarSignalLights', function (status)
	local driver = GetVehiclePedIsIn(GetPlayerPed(-1), false)
	local hasTrailer,vehicleTrailer = GetVehicleTrailerVehicle(driver,vehicleTrailer)
	local leftLight
	local rightLight

	if status == 'left' then
		leftLight = false
		rightLight = true
		if hasTrailer then driver = vehicleTrailer end

	elseif status == 'right' then
		leftLight = true
		rightLight = false
		if hasTrailer then driver = vehicleTrailer end

	elseif status == 'both' then
		leftLight = true
		rightLight = true
		if hasTrailer then driver = vehicleTrailer end

	else
		leftLight = false
		rightLight = false
		if hasTrailer then driver = vehicleTrailer end

	end

	SetVehicleIndicatorLights(driver, 0, leftLight)
	SetVehicleIndicatorLights(driver, 1, rightLight)
end)



RegisterNetEvent('esx_mole_status:syncCarLights')
AddEventHandler('esx_mole_status:syncCarLights', function (driver, status)
	local target = GetPlayerFromServerId(driver)
	if target == nil or target == -1 then
		return
	  end
	if target ~= PlayerId() then
		local driver = GetVehiclePedIsIn(GetPlayerPed(target), false)

		if status == 'left' then
			leftLight = false
			rightLight = true

		elseif status == 'right' then
			leftLight = true
			rightLight = false

		elseif status == 'both' then
			leftLight = true
			rightLight = true

		else
			leftLight = false
			rightLight = false
		end

		SetVehicleIndicatorLights(driver, 0, leftLight)
		SetVehicleIndicatorLights(driver, 1, rightLight)

	end
end)