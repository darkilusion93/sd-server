local adminCommandsDisabled = true
local mapperCam = 0
local mapperStarted = false
local isSpectating, pedIsSpectating = false, 0

local function handleFreeCamThisFrame()
	local camCoords = GetCamCoord(mapperCam)
	local right, forward, _, _ <const> = GetCamMatrix(mapperCam)
	local speedMultiplier = 0.25

    if isSpectating then
	    local coords = GetEntityCoords(pedIsSpectating)
        SetCamCoord(mapperCam, coords.x, coords.y, coords.z + 5.0)

        goto skip_controls
    end

	if IsControlPressed(0, 21) or IsDisabledControlPressed(0, 21) then
		speedMultiplier = 8.0
	elseif IsControlPressed(0, 19) or IsDisabledControlPressed(0, 21) then
		speedMultiplier = 0.025
	end

	if IsControlPressed(0, 32) or IsDisabledControlPressed(0, 32) then --W
		local newCamPos = camCoords + forward * speedMultiplier
		SetCamCoord(mapperCam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 33) or IsDisabledControlPressed(0, 33) then --S
		local newCamPos = camCoords + forward * -speedMultiplier
		SetCamCoord(mapperCam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 34) or IsDisabledControlPressed(0, 34) then --A
		local newCamPos = camCoords + right * -speedMultiplier
		SetCamCoord(mapperCam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	if IsControlPressed(0, 35) or IsDisabledControlPressed(0, 35) then --D
		local newCamPos = camCoords + right * speedMultiplier
		SetCamCoord(mapperCam, newCamPos.x, newCamPos.y, newCamPos.z)
	end

	local xMagnitude <const> = GetDisabledControlNormal(0,  1)
	local yMagnitude <const> = GetDisabledControlNormal(0,  2)
	local camRot <const> = GetCamRot(mapperCam, 0)

	local x = camRot.x - yMagnitude * 10
	local y = camRot.y
	local z = camRot.z - xMagnitude * 10

	if x < -90.0 then x = -90.0 end
	if x > 100.0 then x = 100.0 end

	SetCamRot(mapperCam, x, y, z, 0)

    ::skip_controls::
end

local function startMapper()
	local playerPed <const> = PlayerPedId()

	if not DoesCamExist(mapperCam) then
		mapperCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end

	SetCamActive(mapperCam, true)
	RenderScriptCams(true, false, 0, true, true)

	local coords <const> = GetEntityCoords(playerPed)
	local camRotation <const> = GetGameplayCamRot(0)

	SetCamCoord(mapperCam, coords.x, coords.y, coords.z)
	SetCamRot(mapperCam, camRotation.x, camRotation.y, camRotation.z, 0)

	SetEntityCollision(playerPed, false, false)
	SetEntityVisible(playerPed, false, false)

	mapperStarted = true

	Citizen.CreateThread(function()
		while mapperStarted do
			Citizen.Wait(0)

			local pPed <const> = GetPlayerPed(-1)

			-- Disable collision
			for _, player in ipairs(GetActivePlayers()) do
				if player ~= PlayerId() then
					local otherPlayerPed = GetPlayerPed(player)
					SetEntityNoCollisionEntity(pPed,  otherPlayerPed,  true)
				end
			end

			-- Disable controls
            if not isSpectating then
                DisableControlAction(0, 30,   true) -- MoveLeftRight
                DisableControlAction(0, 31,   true) -- MoveUpDown
                DisableControlAction(0, 1,    true) -- LookLeftRight
                DisableControlAction(0, 2,    true) -- LookUpDown
            end

			DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

			DisableControlAction(0, 24,   true) -- Input Attack
			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
			DisableControlAction(0, 257,  true) -- Input Attack 2
			DisableControlAction(0, 263,  true) -- Input Melee Attack
			DisableControlAction(0, 264,  true) -- Input Melee Attack 2

			DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
			DisableControlAction(0, 14,   true) -- Weapon Wheel Next
			DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
			DisableControlAction(0, 16,   true) -- Select Next Weapon
			DisableControlAction(0, 17,   true) -- Select Prev Weapon

            if not isSpectating and IsControlJustPressed(0, 223) then -- Click
                local ped = 0
                local vehicle = ESX.Game.GetVehicleInDirection()
                if vehicle ~= nil and DoesEntityExist(vehicle) then
                    for i=-1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                        ped = GetPedInVehicleSeat(vehicle, i)
                        if DoesEntityExist(ped) then
                            break
                        end
                    end
                end

                if not DoesEntityExist(ped) then
                    local player, distance = ESX.Game.GetClosestPlayer()

                    if distance ~= -1 and distance <= 15.0 then
                        ped = GetPlayerPed(player)
                    end
                end

                if DoesEntityExist(ped) and IsPedAPlayer(ped) then
                    local playerId = NetworkGetPlayerIndexFromPed(ped)
                    local playerServerId = GetPlayerServerId(playerId)

                    SetCamActive(mapperCam, false)
                    RenderScriptCams(false, false, 0, true, true)

                    pedIsSpectating = ped
                    TriggerEvent("cframework:spectate", playerServerId)

                    isSpectating = true
                else
                    ESX.ShowNotification('Nenhum jogador encontrado', 'error')
                end
            end

            if isSpectating and IsControlJustPressed(0, 225) then
                TriggerEvent("cframework:exitSpectate")
                SetCamActive(mapperCam, true)
                RenderScriptCams(true, false, 0, true, true)

                isSpectating = false
            end

			-- Reset player position
			local camCoords <const> = GetCamCoord(mapperCam)

            if not isSpectating then
			    SetEntityCoords(pPed, camCoords.x, camCoords.y, camCoords.z, false, false, false, false)
            end

			if not IsPauseMenuActive() then
				handleFreeCamThisFrame()
			end
		end
	end)
end

local function stopMapper(keepInvisibility)
	local playerPed <const> = PlayerPedId()
	local camCoords <const> = GetCamCoord(mapperCam)

	SetCamActive(mapperCam, false)
	RenderScriptCams(false, false, 0, true, true)

	SetEntityCollision(playerPed, true, true)

    if not keepInvisibility then
	    SetEntityVisible(playerPed, true, false)
    end

	SetEntityCoords(playerPed, camCoords.x, camCoords.y, camCoords.z, false, false, false, false)

	mapperStarted = false
end

RegisterNetEvent('cframework:disableAdminCommands', function()
	adminCommandsDisabled = true

	if mapperStarted then
		stopMapper(false)
	end
end)

RegisterNetEvent('cframework:stopMapperImmediatly', function()
    if mapperStarted then
        stopMapper(true)
    end
end)

RegisterNetEvent('cframework:enableAdminCommands', function()
	adminCommandsDisabled = false
end)

RegisterNetEvent('es_mapper:toggle', function()
	if adminCommandsDisabled then ESX.ShowNotification('Comando desativado', 'error') return end

	if mapperStarted then
		stopMapper(false)
	else
		startMapper()
	end
end)
