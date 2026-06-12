local isDead = false

local function startRespawnToHospitalMenuTimer()
	Citizen.CreateThread(function()
		local X, Y, W; H = 0.0125
		local Duration = 5000
		local timer = GetGameTimer()

		if not HasStreamedTextureDictLoaded('timerbars') then
			RequestStreamedTextureDict('timerbars', false)
			while not HasStreamedTextureDictLoaded('timerbars') do
			Citizen.Wait(0)
			end
		end

		local scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

		repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

		W = 0.0

		BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(0)
		ScaleformMovieMethodAddParamInt(55)
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(1)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 25, false))
		ScaleformMovieMethodAddParamPlayerNameString("Respawn")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()

		while isDead do
			if IsControlPressed(0, 25) then --INPUT_AIM
				if GetTimeDifference(GetGameTimer(), timer) < Duration then
					W = (GetTimeDifference(GetGameTimer(), timer) * (0.085 / Duration))
				end
			else
				if W > 0.0 then
					W = W - 0.0005
				else
					W = 0.0
				end
				timer = GetGameTimer()
			end

			if W ~= nil and W > 0.084 then
				startRespawnRoutine()
				break
			end

			local correction = ((1.0 - Round(GetSafeZoneSize(), 2)) * 100) * 0.005
			X, Y = 0.9255 - correction, 0.92 - correction

			SetScriptGfxDrawOrder(0)
			DrawSprite('timerbars', 'all_black_bg', X, Y, 0.20, 0.0325, 0.0, 255, 255, 255, 180)

			SetScriptGfxDrawOrder(1)
			DrawRect(X + 0.0275, Y, 0.085, 0.0125, 100, 0, 0, 180)

			SetScriptGfxDrawOrder(2)
			DrawRect(X - 0.015 + (W / 2), Y, W, H, 150, 0, 0, 180)

			SetTextColour(255, 255, 255, 180)
			SetTextFont(0)
			SetTextScale(0.3, 0.3)
			SetTextCentre(true)
			BeginTextCommandDisplayText('STRING')
			AddTextComponentSubstringPlayerName(T("RESPAWN_BAR"))
			SetScriptGfxDrawOrder(3)
			EndTextCommandDisplayText(X - 0.06, Y - 0.012)

			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

			Citizen.Wait(0)
		end
	end)
end

local function showDeathTimer(timer)
	local lastime = GetGameTimer()
	local menushown = false

	Citizen.CreateThread(function()
		while timer > 0 and isDead do
			Citizen.Wait(0)

			local raw_seconds = timer/1000
			local raw_minutes = raw_seconds/60
			local minutes = stringsplit(raw_minutes, ".")[1]
			local seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

			SetTextFont(4)
			SetTextProportional(false)
			SetTextScale(0.0, 0.5)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()

			local text = (T("RESPAWN_TIMER")):format(minutes, seconds)

			SetTextCentre(true)
			BeginTextCommandDisplayText("STRING")
			AddTextComponentSubstringPlayerName(text)
			EndTextCommandDisplayText(0.5, 0.8)

			if (Config.RespawnDelayAfterRPDeath - Config.MenuRespawnToHospitalDelay) >= timer and not menushown then
				menushown = true
				startRespawnToHospitalMenuTimer()
			end

			local auxtime = GetGameTimer()
			timer = timer - (auxtime - lastime)
			lastime = auxtime
		end

	  	if isDead then
			startRespawnRoutine()
		end
	end)
end

function StartDeathLoop()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)

			local player = PlayerId()

			if NetworkIsPlayerActive(player) then
				local playerPed = PlayerPedId()

				if IsPedFatallyInjured(playerPed) and not isDead then
					isDead = true

					local killer, killerWeapon = NetworkGetEntityKillerOfPlayer(player)
					local killerServerId = NetworkGetPlayerIndexFromPed(killer)

					if killer ~= playerPed and killerServerId ~= nil and NetworkIsPlayerActive(killerServerId) then
						PlayerKilledByPlayer(GetPlayerServerId(killerServerId), killerServerId, killerWeapon)
					else
						PlayerKilled()
					end

				elseif not IsPedFatallyInjured(playerPed) then
					isDead = false
				end
			end
		end
	end)
end

function PlayerKilledByPlayer(killerServerId, killerClientId, killerWeapon)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance     = #(victimCoords - killerCoords)

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },
		killerCoords = { x = ESX.Math.Round(killerCoords.x, 1), y = ESX.Math.Round(killerCoords.y, 1), z = ESX.Math.Round(killerCoords.z, 1) },

		killedByPlayer = true,
		deathCause     = killerWeapon,
		distance       = ESX.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end

function PlayerKilled()
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(PlayerPedId())

	local data = {
		victimCoords = { x = ESX.Math.Round(victimCoords.x, 1), y = ESX.Math.Round(victimCoords.y, 1), z = ESX.Math.Round(victimCoords.z, 1) },

		killedByPlayer = false,
		deathCause     = GetPedCauseOfDeath(playerPed)
	}

	TriggerEvent('esx:onPlayerDeath', data)
	TriggerServerEvent('esx:onPlayerDeath', data)
end


--/med
local health, multi
local alreadyDead, pulse, area, blood, bleeding, dead = false, 70, "N/D", 100, 0, false

function SpawnAlreadyDead(data)
	isDead = true

	SetEntityHealth(PlayerPedId(), 0)

	ClearPedTasksImmediately(GetPlayerPed(-1))
	AnimpostfxPlay('DeathFailOut', 0, true)

	showDeathTimer(Config.RespawnDelayAfterRPDeath - (data.elapsedTime*1000))

	multi, bleeding, area = 0.0, data.bleeding, data.area

	exports["mumble-voip"]:setOverrideCoords(true)

    Citizen.CreateThread(function()
		while isDead do
			Citizen.Wait(1000)
		end

        bleeding = 0
        blood = 100
	end)
end

AddEventHandler('esx:onPlayerDeath', function(data)
	local DeathCauseHash = data.deathCause

	showDeathTimer(Config.RespawnDelayAfterRPDeath)

	ClearPedTasksImmediately(GetPlayerPed(-1))
	AnimpostfxPlay('DeathFailOut', 0, true)

	if not alreadyDead then
		local _, bone = GetPedLastDamageBone(GetPlayerPed(-1))

		multi, blood, health, area, bleeding = 2.0, 100, GetEntityHealth(GetPlayerPed(-1)), T("RESPAWN_AFFECTED_MEMBERS"), 1

		if bone == 31086 then
			multi, bleeding, area = 0.0, 4, T("RESPAWN_AFFECTED_HEAD")

			if ESX.DoesWeaponKill(DeathCauseHash) then
				bleeding = 5
			end
		elseif ESX.DoesWeaponKill(DeathCauseHash) then
			multi, bleeding, area = 0.0, 5, T("RESPAWN_AFFECTED_TORSO_WITH_BULLETS")
		elseif bone == 24817 or bone == 24818 or bone == 10706 or bone == 24816 or bone == 11816 then
			multi, bleeding, area = 1.0, 2, T("RESPAWN_AFFECTED_TORSO")
		end
	end

	alreadyDead = false
	pulse = ((health / 4 + 20) * multi) + math.random(0, 4)
	dead = true

	TriggerServerEvent('cframework:setDeathStatus', 1, bleeding, area)

	Citizen.CreateThread(function()
		while dead do
			Citizen.Wait(1000)
			local hp = GetEntityHealth(GetPlayerPed(-1))
			if hp >= 1 and dead then
				dead = false
				bleeding = 0
				blood = 100
			end
			if dead and blood > 0 then
				blood = blood - (bleeding/25)
			end
		end
	end)

	Citizen.Wait(1000)

	exports["mumble-voip"]:setOverrideCoords(true)
end)


RegisterNetEvent('medSystem:send', function(req)
  local players = ESX.Game.GetPlayersInArea(GetEntityCoords(GetPlayerPed(-1)), 50)
	local serverSources = {}

	for _, playerId in ipairs(players) do
		serverSources[GetPlayerServerId(playerId)] = true
	end

	local pHealth = GetEntityHealth(GetPlayerPed(-1))

	if pHealth > 0 then
		pulse = (pHealth / 4 + math.random(19, 28))
	end

	local a, b, c = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

  	TriggerServerEvent('medSystem:print', req, math.floor(pulse * (blood / 90)), area, math.floor(blood), a, b, c, bleeding, serverSources)
end)

ESX.getPlayerBleeding = function ()
    return bleeding
end

ESX.isPlayerDead = function ()
	return isDead
end