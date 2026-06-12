local carryingBackInProgress = false
local carryServerId = 0
local inCooldown = false
local carryingBackDisabled = false
local disableCooldown = false

local function hasPlayerHaveVisonToOtherPlayer(otherPlayer)
	if not IsEntityDead(GetPlayerPed(otherPlayer)) then
		---@diagnostic disable-next-line: missing-parameter
		local _, hit <const>, _, _, targetEntity <const> = RayCast(GetPedBoneCoords(PlayerPedId(), 31086), GetEntityCoords(GetPlayerPed(otherPlayer)), 286, PlayerPedId(), 0.2)

		if not hit and targetEntity == 0 then ESX.ShowNotification(T("CARRY_ERROR"), 'error') return false end
		if targetEntity ~= GetPlayerPed(otherPlayer) then ESX.ShowNotification(T("CARRY_OBJECT_IN_FRONT"), 'error') return false end
	end

	if not HasEntityClearLosToEntity(PlayerPedId(), GetPlayerPed(otherPlayer), -1) then
		ESX.ShowNotification(T("CARRY_THROUGH_WALL"), 'error')
		return false
	end

	return true
end

local function carrySyncMe(animationLib, animation, length, controlFlag, animFlag)
	local carryAnimNamePlaying <const>, carryAnimDictPlaying <const>, carryControlFlagPlaying <const>, playerPed <const> = animation, animationLib, controlFlag, PlayerPedId()

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(0)
	end

	if controlFlag == nil then
		controlFlag = 0
	end

	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	Citizen.CreateThread(function()
		TriggerEvent('cframework:disableEmotes')
		TriggerEvent('cframework:disableVehiclePush')
		TriggerEvent('cframework:disableCair')

		while carryingBackInProgress do
			local ped <const> = PlayerPedId()

			while not IsEntityPlayingAnim(ped, carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(ped, carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end
			Citizen.Wait(0)
		end

		ClearPedTasks(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)

		TriggerEvent('cframework:enableEmotes')
		TriggerEvent('cframework:enableVehiclePush')
		TriggerEvent('cframework:enableCair')
	end)
end

RegisterNetEvent('cframework:disablePegar', function()
	carryingBackDisabled = true
end)

RegisterNetEvent('cframework:enablePegar', function()
	carryingBackDisabled = false
end)

RegisterNetEvent('cframework:disablePegarCooldown', function()
	disableCooldown = true
end)

RegisterNetEvent('cframework:enablePegarCooldown', function()
	disableCooldown = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	TriggerEvent('cframework:stopPegar')
end)

RegisterNetEvent("cframework:hideCarryInTrunk", function(netId)
	local target <const> = carryServerId

	if not carryingBackInProgress then
		ESX.ShowNotification(T("CARRY_NOT_CARRYING"), "error")
		return
	end

	TriggerEvent('cframework:stopPegar')

	TriggerServerEvent("cframework:hideCarryInTrunk", netId, target)
end)

RegisterNetEvent('cframework:stopPegar', function()
	if not carryingBackInProgress then return end

	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)

	TriggerServerEvent("cframework:stopCarry", carryServerId)
end)

RegisterCommand("pegar",function()
	if ESX.isSentenced() then
		ESX.ShowNotification(T("CARRY_CANT_CARRY_COMSERV"), 'error')
		return
	end

	if IsEntityDead(PlayerPedId()) then return end

	if inCooldown or carryingBackDisabled then return end

	if not disableCooldown then inCooldown = true end

	Citizen.CreateThread(function()
		Citizen.Wait(3500)
		inCooldown = false
	end)

	if carryingBackInProgress then
		TriggerEvent('cframework:stopPegar')
		return
	end

	local closestPlayer <const>, closestDistance <const> = ESX.Game.GetClosestPlayer()

	if closestDistance > 3 then ESX.ShowNotification(T("CARRY_NOBODY_CLOSE"), 'error') return end

	local pTarget <const> = GetPlayerServerId(closestPlayer)
	if pTarget == 0 then ESX.ShowNotification(T("CARRY_NOBODY_CLOSE"), 'error') return end

	if not hasPlayerHaveVisonToOtherPlayer(closestPlayer) then return end

	local success <const> = RPC.execute("cframework:carrySync", pTarget)

	if not success then ESX.ShowNotification(T("CARRY_CANT_CARRY_PERSON"), 'error') return end

	carryingBackInProgress = true
	carryServerId = pTarget
	carrySyncMe('missfinale_c2mcs_1', 'fin_c2_mcs_1_camman', 100000, 49, 1)
end, false)

RegisterNetEvent('cframework:syncCarryTarget', function(target, disableCheck)
	local targetPed <const> = GetPlayerPed(GetPlayerFromServerId(target))

	if not DoesEntityExist(targetPed) then return end
	if carryingBackInProgress then return end

    if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(targetPed)) > 10.0 then return end

	local animationLib, animation2, distans, distans2, height, spin, length, controlFlag = 'nm', 'firemans_carry', 0.15, 0.27, 0.63, 0.0, 100000, 1

	carryingBackInProgress = true
	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(0)
	end

	AttachEntityToEntity(PlayerPedId(), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)

	TaskPlayAnim(PlayerPedId(), animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)

	local carryAnimNamePlaying, carryAnimDictPlaying, carryControlFlagPlaying = animation2, animationLib, controlFlag

	Citizen.CreateThread(function()
		while carryingBackInProgress do
			while not IsEntityPlayingAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
				TaskPlayAnim(PlayerPedId(), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
				Citizen.Wait(0)
			end

            if not disableCheck and (not DoesEntityExist(targetPed) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(targetPed)) > 10.0) then
                carryingBackInProgress = false
                ClearPedSecondaryTask(PlayerPedId())
                DetachEntity(PlayerPedId(), true, false)
            end

			Citizen.Wait(0)
		end

		ClearPedTasks(PlayerPedId())
		DetachEntity(PlayerPedId(), true, false)
		TriggerServerEvent("cframework:stopCarry", target)
	end)
end)

RegisterNetEvent('cframework:stopCarrySync', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(PlayerPedId())
	DetachEntity(PlayerPedId(), true, false)
end)