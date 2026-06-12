
local holdingHostageInProgress = false
local scaleform = nil
local hostageAllowedWeapons = {
	`WEAPON_PISTOL`,
	`WEAPON_PISTOL_MK2`,
	`WEAPON_COMBATPISTOL`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_SNSPISTOL_MK2`,
	`WEAPON_PISTOL50`,
	`WEAPON_HEAVYPISTOL`,
	`WEAPON_VINTAGEPISTOL`,
	`WEAPON_SNSPISTOL`,
	`WEAPON_MARKSMANPISTOL`,
	`WEAPON_REVOLVER`,
	`WEAPON_DOUBLEACTION`,
	`WEAPON_MACHINEPISTOL`,
	`WEAPON_MICROSMG`,
	`WEAPON_MINISMG`,
	`WEAPON_TECPISTOL`,
}

RegisterCommand("refem",function(source, args, _)
    local canTakeHostage, foundWeapon = false, ""
    local playerPed <const> = PlayerPedId()

	ClearPedSecondaryTask(playerPed)
	DetachEntity(playerPed, true, false)

	for i=1, #hostageAllowedWeapons do
		if GetSelectedPedWeapon(playerPed) == hostageAllowedWeapons[i] then
			canTakeHostage = true
			foundWeapon = hostageAllowedWeapons[i]
			break
		end
	end

	if not canTakeHostage then
		ESX.ShowNotification("Precisas de uma pistola!", 'error')
	end

	Citizen.CreateThread(function()
		scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

		repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

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
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 47, false))
		ScaleformMovieMethodAddParamPlayerNameString("Largar")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
		ScaleformMovieMethodAddParamInt(2)
		ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 24, false))
		ScaleformMovieMethodAddParamPlayerNameString("Matar")
		EndScaleformMovieMethod()

		BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
		EndScaleformMovieMethod()
	end)

	if not holdingHostageInProgress and canTakeHostage then
		local player = PlayerPedId()
		lib = 'anim@gangops@hostage@'
		anim1 = 'perp_idle'
		lib2 = 'anim@gangops@hostage@'
		anim2 = 'victim_idle'
		distans = 0.11 --Alto = perto da arma
		distans2 = -0.24 --+alto = esquerda
		height = 0.0
		spin = 0.0		
		length = 100000
		controlFlagMe = 49
		controlFlagTarget = 49
		animFlagTarget = 50
		attachFlag = true 
		local closestPlayer = GetClosestPlayer(2)
		target = GetPlayerServerId(closestPlayer)
		if closestPlayer ~= nil then
			SetCurrentPedWeapon(GetPlayerPed(-1), foundWeapon, true)
			holdingHostageInProgress = true
			holdingHostage = true 
			TriggerServerEvent('cframework:takeHostage', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
			Citizen.CreateThread(function()
				while holdingHostage or beingHeldHostage do 
					if holdingHostage then
						if GetEntityHealth(GetPlayerPed(-1)) <= 102 then --Death check edita para o teu sv		
							holdingHostage = false
							holdingHostageInProgress = false 
							local closestPlayer = GetClosestPlayer(2)
							target = GetPlayerServerId(closestPlayer)
							TriggerServerEvent("cframework:releaseHostage",target)
							Wait(100)
							releaseHostage()
						end 
						disableCriminalControls()
						local playerCoords = GetEntityCoords(GetPlayerPed(-1))
						local inPauseMenu = IsPauseMenuActive()
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

						if IsDisabledControlJustPressed(0,47) and not inPauseMenu then --Largar		
							holdingHostage = false
							holdingHostageInProgress = false 
							local closestPlayer = GetClosestPlayer(2)
							target = GetPlayerServerId(closestPlayer)
							TriggerServerEvent("cframework:releaseHostage",target)
							Wait(100)
							releaseHostage()
						elseif IsDisabledControlJustPressed(0,24) and not inPauseMenu then --Matar
							local ammoInClip = GetAmmoInPedWeapon(PlayerPedId(), foundWeapon)

							if ammoInClip <= 0 then ESX.ShowNotification("Não tens balas!", 'error') goto skip_kill end

							holdingHostage = false
							holdingHostageInProgress = false 		
							local closestPlayer = GetClosestPlayer(2)
							target = GetPlayerServerId(closestPlayer)
							TriggerServerEvent("cframework:releaseHostage",target)				
							killHostage(foundWeapon, ammoInClip)

							::skip_kill::
						end
					end
					Wait(0)
				end
			end)
		else
			--print("[CMG Anim] nenhum player por perto")
			ESX.ShowNotification("Nenhum player para fazer de refem!", "error")
		end 
	end
end, false)

RegisterNetEvent('cframework:takeHostageTargetSync', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag,animFlagTarget,attach)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	if holdingHostageInProgress then
		holdingHostageInProgress = false
	else
		holdingHostageInProgress = true
	end

	if beingHeldHostage then 
		beingHeldHostage = false 
	else 
        if not DoesEntityExist(targetPed) then return end

		beingHeldHostage = true
		Citizen.CreateThread(function()
			while holdingHostage or beingHeldHostage do 
				if beingHeldHostage then 
					disableHostageControls()
				end
				Wait(0)
			end
		end)
	end  

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then
        if not DoesEntityExist(targetPed) then beingHeldHostage = false return end

		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	end
	
	if controlFlag == nil then controlFlag = 0 end
	
	if animation2 == "victim_fail" then 
		SetEntityHealth(GetPlayerPed(-1),0)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
		holdingHostageInProgress = false 
	elseif animation2 == "shoved_back" then 
		holdingHostageInProgress = false 
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false 
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false	
	end
end)

RegisterNetEvent('cframework:takeHostageSelfSync')
AddEventHandler('cframework:takeHostageSelfSync', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	if animation == "perp_fail" then 
		--SetPedShootsAtCoord(GetPlayerPed(-1), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(GetPlayerPed(-1))
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('cframework:releaseHostageClient')
AddEventHandler('cframework:releaseHostageClient', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

function disableHostageControls()
	DisableControlAction(0,21,true) -- disable sprint
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,25,true) -- disable aim
	DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisableControlAction(0,263,true) -- disable melee
	DisableControlAction(0,264,true) -- disable melee
	DisableControlAction(0,257,true) -- disable melee
	DisableControlAction(0,140,true) -- disable melee
	DisableControlAction(0,141,true) -- disable melee
	DisableControlAction(0,142,true) -- disable melee
	DisableControlAction(0,143,true) -- disable melee
	DisableControlAction(0,75,true) -- disable exit vehicle
	DisableControlAction(27,75,true) -- disable exit vehicle  
	DisableControlAction(0,22,true) -- disable jump
	DisableControlAction(0,32,true) -- disable move up
	DisableControlAction(0,268,true)
	DisableControlAction(0,33,true) -- disable move down
	DisableControlAction(0,269,true)
	DisableControlAction(0,34,true) -- disable move left
	DisableControlAction(0,270,true)
	DisableControlAction(0,35,true) -- disable move right
	DisableControlAction(0,271,true)
end

function disableCriminalControls()
	DisableControlAction(0,24,true) -- disable attack
	DisableControlAction(0,25,true) -- disable aim
	DisableControlAction(0,47,true) -- disable weapon
	DisableControlAction(0,58,true) -- disable weapon
	DisablePlayerFiring(GetPlayerPed(-1),true)
end



function GetPlayers()
    local players = {}

	for _, i in ipairs(GetActivePlayers()) do
        table.insert(players, i)
    end

    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius then
		return closestPlayer
	else
		return nil
	end
end

--//TODO: refactor thisssss

function releaseHostage()
	local player = PlayerPedId()	
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		--print("triggering cframework:takeHostage")
		TriggerServerEvent('cframework:takeHostage', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	else
		--print("[CMG Anim] Nenhum player por perto")
	end
end 

function killHostage(weaponHash, ammoInClip)
	local player = PlayerPedId()	
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11 --Higher = closer to camera
	distans2 = -0.24 --higher = left
	height = 0.0
	spin = 0.0		
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= nil then
		local targetPed = GetPlayerPed(closestPlayer)
		local x, y, z = table.unpack(GetPedBoneCoords(targetPed, GetEntityBoneIndexByName(targetPed, 'SKEL_HEAD'), 0.0, 0.0, 0.0))

		SetPedShootsAtCoord(GetPlayerPed(-1), x, y, z, 0)
		SetPedAmmo(PlayerPedId(), weaponHash, ammoInClip - 1)

		TriggerServerEvent('cframework:takeHostage', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget,attachFlag)
	end	
end 
