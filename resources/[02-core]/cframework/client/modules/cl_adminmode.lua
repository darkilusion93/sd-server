

local inAdminMode = false

ESX.inAdminMode = function()
    return inAdminMode
end

local function drawOnScreenText(text, x, y, scale)
	SetTextFont(0)
	SetTextProportional(true)
	SetTextScale(0.0, scale)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

local function toDecimal(number)
	return string.format("%.2f", number)
end

local function startAdminLoop()
	while inAdminMode do
		local playerPed <const> = PlayerPedId()
		local inVehicle <const> = IsPedInAnyVehicle(playerPed, false)
		local coords, speed, heading, health <const> = GetEntityCoords(playerPed, true), GetEntitySpeed(playerPed), GetEntityHeading(playerPed), GetEntityHealth(playerPed)

		local roundx, roundy, roundz <const> = toDecimal(coords.x), toDecimal(coords.y), toDecimal(coords.z)
		local rounds, roundh <const> = toDecimal(speed),  toDecimal(heading)

		drawOnScreenText(("~r~X:~s~ %s"):format(roundx),  inVehicle and 0.18 or 0.35, 0.90, 0.50)
		drawOnScreenText(("~r~Y:~s~ %s"):format(roundy), inVehicle and 0.28 or 0.45, 0.90, 0.50)
		drawOnScreenText(("~r~Z:~s~ %s"):format(roundz), inVehicle and 0.38 or 0.55, 0.90, 0.50)
		drawOnScreenText(("~r~%s:~s~ %s"):format(T("ADMIN_HEADING"), roundh), inVehicle and 0.23 or 0.40, 0.96, 0.50)

		drawOnScreenText(("~r~%s:~s~ %s"):format(T("ADMIN_SPEED"), rounds), 0.01, 0.62, 0.40)
		drawOnScreenText(("~r~%s:~s~ %s"):format(T("ADMIN_HEALTH"), health), 0.01, 0.58, 0.40)

		if inVehicle then
			local vehicle <const> = GetVehiclePedIsUsing(playerPed)
			local veheng, vehbody <const> = GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle)
			local vehenground, vehbodround <const> = toDecimal(veheng), toDecimal(vehbody)

			drawOnScreenText(("~r~%s:~s~ %s"):format(T("ADMIN_ENGINE_HEALTH"), vehenground), 0.01, 0.50, 0.40)
			drawOnScreenText(("~r~%s:~s~ %s"):format(T("ADMIN_BODY_HEALTH"), vehbodround), 0.01, 0.54, 0.40)
		end

		Citizen.Wait(0)
	end
end

local function exitAdminMode()
	local playerPed <const> = PlayerPedId()

	SetEntityInvincible(playerPed, false)
	SetPlayerInvincible(PlayerId(), false)
	SetPedCanRagdoll(playerPed, true)
	ClearPedLastWeaponDamage(playerPed)
	SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
	SetEntityCanBeDamaged(playerPed, true)
end

local function enterAdminMode()
	local playerPed <const> = PlayerPedId()

	SetEntityInvincible(playerPed, true)
	SetPlayerInvincible(PlayerId(), true)
	SetPedCanRagdoll(playerPed, false)
	ClearPedBloodDamage(playerPed)
	ResetPedVisibleDamage(playerPed)
	ClearPedLastWeaponDamage(playerPed)
	SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)
	SetEntityOnlyDamagedByPlayer(playerPed, false)
	SetEntityCanBeDamaged(playerPed, false)

	Citizen.CreateThread(function()
		startAdminLoop()
	end)
end

RegisterNetEvent("cframework:enterAdmin", function()
	TriggerEvent('cframework:disablePegarCooldown')
	TriggerEvent('cframework:enableAdminCommands')
	ESX.PauseStatus(true)
    inAdminMode = true
	enterAdminMode()
end)

RegisterNetEvent("cframework:leaveAdmin", function()
	TriggerEvent('cframework:enablePegarCooldown')
	TriggerEvent('cframework:disableAdminCommands')
	ESX.PauseStatus(false)
	inAdminMode = false
	exitAdminMode()
end)
