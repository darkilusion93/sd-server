local f_34Table = {}

function getRespawnLocation(coords)
	local respawnLocation = {
		vector3(-447.2036, -342.8395, 34.502), -- animação ded merda
		vector3(342.7344, -1397.851, 32.5092), -- NICEEEE
		vector3(357.3475, -585.6215, 28.831), -- Nice 
		vector3(1837.655, 3673.5, 34.308), -- Nice 
		vector3(-244.6081, 6324.963, 32.426), -- Nice 
		vector3(4499.72, -4521.58, 4.41), -- Nice 
		vector3(1092.07, 2724.41, 38.67) -- Nice 
	}
	local iVar3, iVar0, closestDist = 1, 1, #(coords - respawnLocation[1])

	while iVar3 <= #respawnLocation do
		local dist = #(coords - respawnLocation[iVar3])
		if dist < closestDist then
			closestDist = dist
			iVar0 = iVar3
		end

		iVar3 = iVar3 + 1
	end

	return iVar0
end

function getDoctorSpawnLocation(coords)
	local respawnLocation = {
		vector3(1095.13, 2726.75, 38.72),
        vector3(1678.97, 3654.99, 35.35),
        vector3(-822.53, -1223.41, 7.33),
        vector3(-244.6081, 6324.963, 32.426),
        vector3(-508.51, 7364.80, 12.84),
        vector3(4960.60, -5111.47, 2.92)
	}
	local iVar3, iVar0, closestDist = 1, 1, #(coords - respawnLocation[1])

	while iVar3 <= #respawnLocation do
		local dist = #(coords - respawnLocation[iVar3])
		if dist < closestDist then
			closestDist = dist
			iVar0 = iVar3
		end

		iVar3 = iVar3 + 1
	end

	return iVar0
end

function startDoctorReviveRoutine()
	local coords = GetEntityCoords(PlayerPedId())
	local locationIndex, modelNumber, respawnSettings = getDoctorSpawnLocation(coords), 1, {}

	if modelNumber == 1 then --Isto devia ir buscar o player model, mas como é freemode acho que meto random? gostei mais do azul então fica o michael
		respawnSettings.f_26 = "RespawnMichael"
		respawnSettings.facials = "facials@P_M_ZERO@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    elseif modelNumber == 2 then
		respawnSettings.f_26 = "RespawnFranklin"
		respawnSettings.facials = "facials@P_M_ONE@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    elseif modelNumber == 3 then
		respawnSettings.f_26 = "RespawnTrevor"
		respawnSettings.facials = "facials@P_M_TWO@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    else
		return false
	end

    respawnSettings.f_27 = "RESPAWN_SOUNDSET"
	respawnSettings.f_28 = "Hit"
	respawnSettings.f_29 = "Whoosh"

    if locationIndex == 1 then  --Hospital Doctor Sandy 2
        respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(1095.13, 2726.75, 38.72)
		respawnSettings.f_8 = vector3(0.0, 0.0, 88.15)
		respawnSettings.f_4 = -668482597
		respawnSettings.f_30 = 999.0
		respawnSettings.f_31 = 999.0
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = -15.0
		respawnSettings.f_57 = -15.0
    elseif locationIndex == 2 then  --Hospital Doctor Sandy
        respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(1678.97, 3654.99, 35.35)
		respawnSettings.f_8 = vector3(0.0, 0.0, 302.12)
		respawnSettings.f_4 = -668482597
		respawnSettings.f_30 = 999.0
		respawnSettings.f_31 = 999.0
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = -15.0
		respawnSettings.f_57 = -15.0
	elseif locationIndex == 3 then  --Hospital Doctor
		respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(-822.53, -1223.41, 7.33)
		respawnSettings.f_8 = vector3(0.0, 0.0, 90.931)
		respawnSettings.f_4 = -668482597
		respawnSettings.f_30 = 999.0
		respawnSettings.f_31 = 999.0
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = -15.0
		respawnSettings.f_57 = -15.0
	elseif locationIndex == 4 then --Hospital Doctor Paleto
		respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(-244.6081, 6324.963, 32.426)
		respawnSettings.f_8 = vector3(0.0, 0.0, -57.7613)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.7
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
    elseif locationIndex == 5 then --Hospital Doctor Roxwood
		respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(-508.51, 7364.80, 12.84)
		respawnSettings.f_8 = vector3(0.0, 0.0, 340.37)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.7
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
    elseif locationIndex == 6 then --Hospital Doctor Cayo
		respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(4960.60, -5111.47, 2.92)
		respawnSettings.f_8 = vector3(0.0, 0.0, 222.37)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.7
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
    else
        return false
    end

	respawnSettings.f_15 = -1.0

	respawnPlayerAnimation(respawnSettings, "AM_H_BUSTED", false)
end

function startBustedRoutine()
	local coords = GetEntityCoords(PlayerPedId())
	local locationIndex, modelNumber, respawnSettings = 2, 1, {}

	if modelNumber == 1 then --Isto devia ir buscar o player model, mas como é freemode acho que meto random? gostei mais do azul então fica o michael
		respawnSettings.f_26 = "RespawnMichael"
		respawnSettings.facials = "facials@P_M_ZERO@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    elseif modelNumber == 2 then
		respawnSettings.f_26 = "RespawnFranklin"
		respawnSettings.facials = "facials@P_M_ONE@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    elseif modelNumber == 3 then
		respawnSettings.f_26 = "RespawnTrevor"
		respawnSettings.facials = "facials@P_M_TWO@BASE"
		respawnSettings.f_17 = "mood_angry_1"
    else
		return false
	end

    respawnSettings.f_27 = "RESPAWN_SOUNDSET"
	respawnSettings.f_28 = "Hit"
	respawnSettings.f_29 = "Whoosh"

    if locationIndex == 1 then  --Policia principal
		respawnSettings.name = "RESPAWN@POLICE@DOWN_TOWN"
		respawnSettings.f_1 = "DOWN_TOWN"
		respawnSettings.f_2 = "DOWN_TOWN_CAM"
		respawnSettings.spawnLocation = vector3(480.3291, -976.4094, 26.992)
		respawnSettings.f_8 = vector3(0.0, 0.0, 4.931)
		respawnSettings.f_4 = -668482597
		respawnSettings.f_30 = 999.0
		respawnSettings.f_31 = 999.0
		respawnSettings.f_19 = vector3(27.9336, -958.3694, 486.8887) - respawnSettings.spawnLocation
		respawnSettings.f_22 = vector3(10.0, 10.0, 5.0)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = -15.0
		respawnSettings.f_57 = -15.0
	elseif locationIndex == 2 then  --Prisão
		respawnSettings.name = "RESPAWN@POLICE@DOWN_TOWN"
		respawnSettings.f_1 = "DOWN_TOWN"
		respawnSettings.f_2 = "DOWN_TOWN_CAM"
		respawnSettings.spawnLocation = vector3(1853.27, 2584.22, 44.67)
		respawnSettings.f_8 = vector3(0.0, 0.0, -90.931)
		respawnSettings.f_4 = -668482597
		respawnSettings.f_30 = 999.0
		respawnSettings.f_31 = 999.0
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = -15.0
		respawnSettings.f_57 = -15.0
    else
        return false
    end

	respawnSettings.f_15 = -1.0

	respawnPlayerAnimation(respawnSettings, "AM_H_BUSTED", false)
end

function startRespawnRoutine()
	local coords = GetEntityCoords(PlayerPedId())
	local locationIndex, modelNumber, respawnSettings = getRespawnLocation(coords), 1, {}

	if modelNumber == 1 then --Isto devia ir buscar o player model, mas como é freemode acho que meto random? gostei mais do azul então fica o michael
		respawnSettings.f_26 = "RespawnMichael"
		respawnSettings.facials = "facials@P_M_ZERO@BASE"
		respawnSettings.f_17 = "mood_injured_1"
    elseif modelNumber == 2 then
		respawnSettings.f_26 = "RespawnFranklin"
		respawnSettings.facials = "facials@P_M_ONE@BASE"
		respawnSettings.f_17 = "mood_injured_1"
    elseif modelNumber == 3 then
		respawnSettings.f_26 = "RespawnTrevor"
		respawnSettings.facials = "facials@P_M_TWO@BASE"
		respawnSettings.f_17 = "mood_injured_1"
    else
		return false
	end

    respawnSettings.f_27 = "RESPAWN_SOUNDSET"
	respawnSettings.f_28 = "Hit"
	respawnSettings.f_29 = "Whoosh"

    if locationIndex == 1 then
        respawnSettings.name = "RESPAWN@HOSPITAL@ROCKFORD"
        respawnSettings.f_1 = "ROCKFORD"
        respawnSettings.f_2 = "ROCKFORD_CAM"
        respawnSettings.spawnLocation = vector3(-830.48, -1216.04, 6.93)
        respawnSettings.f_8 = vector3(0.0, 0.0, 109.1352)
        respawnSettings.f_15 = 0.5
        respawnSettings.f_3 = 0.85
        respawnSettings.f_4 = -668482597
        respawnSettings.f_30 = 0.0
        respawnSettings.f_31 = -27.0
        respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
        respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
        respawnSettings.f_52 = 0.75
        respawnSettings.f_53 = vector3(15.0, 0.0, -11.0)
        respawnSettings.f_56 = respawnSettings.f_30
        respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 2 then
		respawnSettings.name = "RESPAWN@HOSPITAL@SOUTH_CENTRAL"
		respawnSettings.f_1 = "SOUTH_CENTRAL"
		respawnSettings.f_2 = "SOUTH_CENTRAL_CAM"
		respawnSettings.spawnLocation = vector3(342.7344, -1397.851, 32.5092)
		respawnSettings.f_8 = vector3(0.0, 0.0, 62.516) 
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(-39.0, 16.5, 0.0)
		respawnSettings.f_22 = vector3(25.0, 25.0, 5.0)
		respawnSettings.f_52 = 0.65
		respawnSettings.f_53 = vector3(7.65, 0.0, 2.55)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 3 then
		respawnSettings.name = "RESPAWN@HOSPITAL@DOWNTOWN"
		respawnSettings.f_1 = "DOWNTOWN"
		respawnSettings.f_2 = "DOWNTOWN_CAM"
		respawnSettings.spawnLocation = vector3(357.3475, -585.6215, 28.831)
		respawnSettings.f_8 = vector3(0.0, 0.0, -95.0926)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(34.5, -18.0, 0.0)
		respawnSettings.f_22 = vector3(30, 30, 7.5)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 4 then
		respawnSettings.name = "RESPAWN@HOSPITAL@SOUTH_CENTRAL"
		respawnSettings.f_1 = "SOUTH_CENTRAL"
		respawnSettings.f_2 = "SOUTH_CENTRAL_CAM"
		respawnSettings.spawnLocation = vector3(1681.21, 3659.89, 35.34)  -- Sandy Shores
		respawnSettings.f_8 = vector3(0.0, 0.0, 226.38)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.7
		respawnSettings.f_53 = vector3(13.31, 0.0, 4.32)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 5 then
		respawnSettings.name = "RESPAWN@HOSPITAL@PALETO_BAY"
		respawnSettings.f_1 = "PALETO_BAY"
		respawnSettings.f_2 = "PALETO_BAY_CAM"
		respawnSettings.spawnLocation = vector3(-244.6081, 6324.963, 32.426)
		respawnSettings.f_8 = vector3(0.0, 0.0, -57.7613)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_22 = vector3(0.0, 0.0, 0.0)
		respawnSettings.f_52 = 0.7
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 6 then
		respawnSettings.name = "RESPAWN@HOSPITAL@DOWNTOWN"
		respawnSettings.f_1 = "DOWNTOWN"
		respawnSettings.f_2 = "DOWNTOWN_CAM"
		respawnSettings.spawnLocation = vector3(4499.72, -4521.58, 4.41)
		respawnSettings.f_8 = vector3(0.0, 0.0, -80.0926)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(34.5, -18.0, 0.0)
		respawnSettings.f_22 = vector3(30, 30, 7.5)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
	elseif locationIndex == 7 then
		respawnSettings.name = "RESPAWN@HOSPITAL@DOWNTOWN"
		respawnSettings.f_1 = "DOWNTOWN"
		respawnSettings.f_2 = "DOWNTOWN_CAM"
		respawnSettings.spawnLocation = vector3(1092.07, 2724.41, 38.67)
		respawnSettings.f_8 = vector3(0.0, 0.0, 124.93)
		respawnSettings.f_15 = 0.5
		respawnSettings.f_4 = -668482597
		respawnSettings.f_19 = vector3(34.5, -18.0, 0.0)
		respawnSettings.f_22 = vector3(30, 30, 7.5)
		respawnSettings.f_52 = 0.75
		respawnSettings.f_53 = vector3(20.0, 0.0, 0.0)
		respawnSettings.f_56 = respawnSettings.f_30
		respawnSettings.f_57 = respawnSettings.f_31
    else
        return false
    end

	respawnSettings.f_15 = -1.0

	respawnPlayerAnimation(respawnSettings, "AM_H_BUSTED", true)
end

function prepareRespawnCam(Param0, fParam3, iParam4, iParam5) -- 0 1
	if IsPlayerPlaying(PlayerId()) then		
		SetGameplayCamRelativePitch(0.0, 1.0)
		SetGameplayCamRelativeHeading(0.0)
		return true
    end

	return false
end

function playRespawnCameraEffects(bParam1, bParam2, bParam3, bParam4, bParam5, iParam6)	
	if f_34Table.pointer == 1 then
        if bParam3 then
            if not f_34Table.f_8 then
                if GetGameTimer() >= (f_34Table.f_7 + f_34Table.f_16) then
                    if bParam5 then
                        if f_34Table.f_6 == 1 then
                            AnimpostfxPlay("CamPushInFranklin", 0, false)
                        elseif f_34Table.f_6 == 0 then
                            AnimpostfxPlay("CamPushInMichael", 0, false)
                        elseif f_34Table.f_6 == 2 then
                            AnimpostfxPlay("CamPushInTrevor", 0, false)
                        end
                    else
                        AnimpostfxPlay("CamPushInNeutral", 0, false)
                    end
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", true)
                    f_34Table.f_8 = 1
                end
            end
        end

        if GetGameTimer() >= (f_34Table.f_7 + f_34Table.f_15) then
            if bParam2 then
                destroyAllRespawnCameras()
                RenderScriptCams(false, false, 3000, true, false, 0)
			end
            return 1
        end

    elseif f_34Table.pointer == 2 then
		return true
    end

	return false
end

function setRespawnCameraSettings(iParam1, iParam2, fParam3, iParam4, iParam5, iParam6, iParam7, iParam8, iParam9)
	local uParam0 = {}
    uParam0.f_5 = iParam1
	uParam0.f_6 = iParam2
    uParam0.f_9 = iParam9
	uParam0.f_12 = fParam3
	uParam0.f_14 = iParam4
	uParam0.f_15 = iParam5
	uParam0.f_16 = iParam6
	uParam0.f_17 = iParam7
	uParam0.f_13 = iParam8
    return uParam0
end

function destroyAllRespawnCameras()
	if DoesCamExist(f_34Table.f_1) then
		DestroyCam(f_34Table.f_1, false)
    end
	if DoesCamExist(f_34Table.f_2) then
        DestroyCam(f_34Table.f_2, false)
    end
	if DoesCamExist(f_34Table.f_3) then
        DestroyCam(f_34Table.f_3, false)
    end
	if DoesCamExist(f_34Table.f_4) then
        DestroyCam(f_34Table.f_4, false)
    end
end

function respawnPedEvents(ped, coords)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned') -- compatibility with old scripts, will be removed soon
end

function respawnPlayerAnimation(respawnSettings, sParam2, wasDead)
	local scenePhase, synchronizedScene, scriptedCam, pedResetFlag = 0.0, -1, nil, nil
    local effectsPlayed, uVar9, sceneFlag32 = false, 16, false

    TriggerEvent("cframework:forceExitTrunk")
    TriggerEvent('cframework:stopPegar')
	DisableHolster()

	if wasDead then TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0) end

	if not IsScreenFadedOut() then
		DoScreenFadeOut(0)
    end

    while exports["chud"]:isPlayerInTrunk() do
        Citizen.Wait(0)
    end

	if wasDead then
		RPC.execute('esx_ambulancejob:removeItemsAfterRPDeath')

		ESX.SetPlayerData('lastPosition', respawnSettings.spawnLocation)

		TriggerServerEvent('esx:updateLastPosition', respawnSettings.spawnLocation)
		respawnPedEvents(PlayerPedId(), respawnSettings.spawnLocation)

		RemoveAllPedWeapons(PlayerPedId(), true)
	end

    StopScreenEffect('DeathFailOut')

    if wasDead and math.random(1, 10000) == 1 then
        ESX.RespawnMiracle()
    end

	SetPlayerControl(PlayerId(), false, 0)

	if not IsEntityDead(PlayerPedId(), false) then
		SetEntityInvincible(PlayerPedId(), true)
    end

	SetEntityCoords(PlayerPedId(), respawnSettings.spawnLocation, true, false, false, true)

	FreezeEntityPosition(PlayerPedId(), true)
	Citizen.Wait(0)

	--SetGamePaused(true) --Very risky function...

	RequestAnimDict(respawnSettings.name)
	RequestAnimDict(respawnSettings.facials)

	if not IsScreenFadedOut() then
		DoScreenFadeOut(0)
    end

	prepareRespawnCam(respawnSettings.spawnLocation, respawnSettings.f_8.y, 0, 1) --Não sei bem o que isto faz?

	if not IsScreenFadedOut() then
		DoScreenFadeOut(0)
    end

	local finishTime, animDictLoaded = GetGameTimer() + 20000, false

	respawnSettings.f_33 = 0 --Random variavel??

	while not animDictLoaded and finishTime > GetGameTimer() do --Load dictionary and make sure screen is faded out
		animDictLoaded = true

		RequestAnimDict(respawnSettings.name)
		if not HasAnimDictLoaded(respawnSettings.name) then
			animDictLoaded = false
        end

        RequestAnimDict(respawnSettings.facials)
		if not HasAnimDictLoaded(respawnSettings.facials) then
			animDictLoaded = false
        end

        if not IsScreenFadedOut() then
            DoScreenFadeOut(0)
        end

        Citizen.Wait(0)
	end

	if not IsEntityDead(PlayerPedId()) then
		ClearPlayerWantedLevel(PlayerId())
		SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
		ClearPedTasksImmediately(PlayerPedId())
    end

	FreezeEntityPosition(PlayerPedId(), false)
	--SetGamePaused(false) --Unlock all other threads??

	if not IsScreenFadedIn() and not IsScreenFadingIn() then
		DoScreenFadeIn(250)
    end

	--MISC::SET_FADE_IN_AFTER_DEATH_ARREST(true); --Useless??

    if not IsEntityDead(PlayerPedId()) then
        local netScene = NetworkCreateSynchronisedScene(respawnSettings.spawnLocation, respawnSettings.f_8, 2, false, false, 1.0, 0.0, 1.0)
        NetworkAddPedToSynchronisedScene(PlayerPedId(), netScene, respawnSettings.name, respawnSettings.f_1, 0.0, -8.0, 6, 0, 1000.0, 0)

        NetworkStartSynchronisedScene(netScene)

        while synchronizedScene == -1 do
            synchronizedScene = NetworkGetLocalSceneFromNetworkId(netScene)
            Citizen.Wait(0)
        end

		--synchronizedScene = CreateSynchronizedScene(respawnSettings.spawnLocation, respawnSettings.f_8, 2)
		--SetSynchronizedSceneLooped(synchronizedScene, false)
		--SetSynchronizedSceneHoldLastFrame(synchronizedScene, false)
		scriptedCam = CreateCam("DEFAULT_ANIMATED_CAMERA", true)

		--TaskSynchronizedScene(PlayerPedId(), synchronizedScene, respawnSettings.name, respawnSettings.f_1, 1000.0, -1.5, 6, 0, 1000.0, 0)
		SetForceFootstepUpdate(PlayerPedId(), true)
		SetPlayerClothPinFrames(PlayerId(), 1)

		pedResetFlag = GetPedResetFlag(PlayerPedId(), 77)
		SetPedResetFlag(PlayerPedId(), 77, true)
		PlaySynchronizedCamAnim(scriptedCam, synchronizedScene, respawnSettings.f_2, respawnSettings.name)
		RenderScriptCams(true, false, 3000, true, false, 0)
		TaskPlayAnim(PlayerPedId(), respawnSettings.facials, respawnSettings.f_17, 1000.0, -1.5, 10000, 33, 0.0, false, false, false)
    end

	if IsSynchronizedSceneRunning(synchronizedScene) then
		while IsSynchronizedSceneRunning(synchronizedScene) and not IsEntityDead(PlayerPedId()) do
			if not effectsPlayed and not IsScreenFadedOut() then
				AnimpostfxPlay(respawnSettings.f_26, 0, false)
				PlaySoundFrontend(-1, respawnSettings.f_28, respawnSettings.f_27, false)
				PlaySoundFrontend(-1, respawnSettings.f_29, respawnSettings.f_27, false)
				effectsPlayed = true
			end

			scenePhase = GetSynchronizedScenePhase(synchronizedScene)

			local iVar182 = false
			if HasAnimEventFired(PlayerPedId(), GetHashKey("WalkInterruptible")) then --WTF is this????
				local iVar183 = GetControlValue(2, 195) - 128
				local iVar184 = GetControlValue(2, 196) - 128
				if not (((iVar183 < 64 and iVar183 > -64) and iVar184 < 64) and iVar184 > -64) then
					iVar182 = true
                end
			else
				iVar182 = false
            end

			if GetFollowPedCamViewMode() == 4 and respawnSettings.f_52 > 0.0 then
				if scenePhase >= respawnSettings.f_52 then
					if not sceneFlag32 then
						f_34Table = setRespawnCameraSettings(PlayerPedId(), --[[func_15()]]1, 1E-06, 300, 300, 0, 0, 1045220557, respawnSettings.f_53)

						if not respawnSettings.f_33 then
							f_34Table.pointer = 1
							f_34Table.f_7 = GetGameTimer()
							f_34Table.f_8 = 0
							respawnSettings.f_33 = true
                        end

						if respawnSettings.f_57 == 999.0 then
							respawnSettings.f_56 = 0.0
                        end

						if respawnSettings.f_57 == 999.0 then
							respawnSettings.f_57 = (GetFinalRenderedCamRot(2).y - GetEntityHeading(PlayerPedId()))
							if respawnSettings.f_57 < 360.0 then
								respawnSettings.f_57 = respawnSettings.f_57 + 360.0
                            end
							if respawnSettings.f_57 > 360.0 then
								respawnSettings.f_57 = respawnSettings.f_57 - 360.0
                            end
						end

						SetGameplayCamRelativePitch(respawnSettings.f_56, 1.0)
						SetGameplayCamRelativeHeading(respawnSettings.f_57)
						SetGameplayCamRawPitch(respawnSettings.f_56)
						SetGameplayCamRawYaw(respawnSettings.f_57)
						sceneFlag32 = true
					else
						N_0x59424bd75174c9b1()
						playRespawnCameraEffects(1, 1, 1, 0, 0, 0)
					end
				end
			end

			if HasAnimEventFired(PlayerPedId(), GetHashKey("ForceBlendout")) or iVar182 then
				if not IsEntityDead(PlayerPedId(), false) then
					ClearPedTasks(PlayerPedId())

                    if respawnSettings.f_4 == -1871534317 then
                        ForcePedMotionState(PlayerPedId(), -1871534317, true, 0, false)
                        StopRenderingScriptCamsUsingCatchUp(false, 0.0, 3, 0)
                    elseif respawnSettings.f_4 == -668482597 then
                        ForcePedMotionState(PlayerPedId(), -668482597, true, 0, false)
                        SimulatePlayerInputGait(PlayerId(), 1.0, 500, 0.0, true, false)

                        if GetFollowPedCamViewMode() ~= 4 then
                            if respawnSettings.f_31 == 999.0 then
							    respawnSettings.f_30 = 0.0
                            end

                            if respawnSettings.f_31 == 999.0 then
                                respawnSettings.f_31 = (GetFinalRenderedCamRot(2).y - GetEntityHeading(PlayerPedId()))
                                if respawnSettings.f_31 < 360.0 then
                                    respawnSettings.f_31 = respawnSettings.f_31 + 360.0
                                end
                                if respawnSettings.f_31 > 360.0 then
                                    respawnSettings.f_31 = respawnSettings.f_31 - 360.0
                                end
                            end

                            SetGameplayCamRelativePitch(respawnSettings.f_30, 1.0)
						    SetGameplayCamRelativeHeading(respawnSettings.f_31)
                            RenderScriptCams(false, true, Round((#(GetFinalRenderedCamCoord() - GetGameplayCamCoord()) * 1000.0)), false, false, 0)
                        end
                    end
					if IsSynchronizedSceneRunning(synchronizedScene) then
						DetachSynchronizedScene(synchronizedScene)
						synchronizedScene = -1
                    end
				end
			end
			Citizen.Wait(0)
		end
	end

	SetPlayerControl(PlayerId(), true, 0)
	if not IsEntityDead(PlayerPedId(), false) then
		ClearPedTasks(PlayerPedId())
    end

	local bVar225, bVar226 = N_0x3044240d2e0fa842(), false

	if sceneFlag32 then
		N_0x59424bd75174c9b1()

		if not playRespawnCameraEffects(1, 1, 1, 0, 1, 0) then
			bVar226 = true
        end
	end

	if bVar225 or bVar226 then
		while (bVar225 or bVar226) and not IsPlayerSwitchInProgress() do
			DisableControlAction(1, 26)
			DisableControlAction(1, 79)
			DisableControlAction(1, 1)
			DisableControlAction(1, 2)
			DisableControlAction(0, 22)
			DisableControlAction(0, 36)
			DisableControlAction(0, 142)
			DisableControlAction(0, 141)
			DisableControlAction(0, 140)
			DisableControlAction(0, 263)
			DisableControlAction(0, 264)

            Citizen.Wait(0)

            bVar225 = N_0x3044240d2e0fa842()
			bVar226 = false
			if sceneFlag32 then
				N_0x59424bd75174c9b1()

                if not playRespawnCameraEffects(1, 1, 1, 0, 1, 0) then
                    bVar226 = true
                end
			end
		end
	end


	RemoveAnimDict(respawnSettings.facials)
	RemoveAnimDict(respawnSettings.name)

	DestroyCam(scriptedCam, false)
	destroyAllRespawnCameras()

	EnableHolster()

	if not IsEntityDead(PlayerPedId(), false) then
		SetPedResetFlag(PlayerPedId(), 77, pedResetFlag)
		SetEntityInvincible(PlayerPedId(), false)
    end
end