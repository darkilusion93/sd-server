-- https://github.com/KadDarem/Walkable-Hands-Up
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

local tempo = 15000 --  miliseconds >> 1000 ms
local ragdoll = false

local disableEmotes = false
local disableRagdoll = false

AddEventHandler('cframework:disableEmotes', function()
  disableEmotes = true
end)

AddEventHandler('cframework:enableEmotes', function()
  disableEmotes = false
end)

AddEventHandler('cframework:disableRagdoll', function()
	disableRagdoll = true
end)

AddEventHandler('cframework:enableRagdoll', function()
	disableRagdoll = false
end)

local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

BlacklistedWeapons = { -- weapons that will get people banned
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG",
	"WEAPON_STINGER",
	"WEAPON_MINIGUN",
	"WEAPON_GRENADE",
	"WEAPON_BALL",
	"WEAPON_GARBAGEBAG",
	"WEAPON_RAILPISTOL",
	"WEAPON_RAILGUN",
	"WEAPON_RAYPISTOL", 
	"WEAPON_RAYCARBINE", 
	"WEAPON_RAYMINIGUN",
	"WEAPON_DIGISCANNER",
	--"WEAPON_SPECIALCARBINE_MK2",
	--"WEAPON_BULLPUPRIFLE_MK2",
	--"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_HOMINGLAUNCHER", 
	--"WEAPON_SMG_MK2",
	"weapon_heavysniper_mk2",
	"weapon_marksmanrifle",
	"weapon_marksmanrifle_mk2",
	"WEAPON_BZGAS"
}

local WeaponDamagesTable = {
	[-1357824103] = 34, -- AdvancedRifle
    [453432689] = 26, -- Pistol
    [1593441988] = 27, -- CombatPistol
    [584646201] = 25, -- APPistol
    [-1716589765] = 51, -- Pistol50
    [-1045183535] = 160, -- Revolver
    [-1076751822] = 28, -- SNSPistol
    [-771403250] = 40, -- HeavyPistol
    [137902532] = 34, -- VintagePistol
    [324215364] = 21, -- MicroSMG
    [736523883] = 22, -- SMG
    [-270015777] = 23, -- AssaultSMG
    [-1121678507] = 22, -- MiniSMG
    [-619010992] = 27, -- MachinePistol
    [171789620] = 28, -- CombatPDW
    [487013001] = 29, -- PumpShotgun
    [2017895192] = 40, -- SawnoffShotgun
    [-494615257] = 32, -- AssaultShotgun
    [-1654528753] = 14, -- BullpupShotgun
    [984333226] = 117, -- HeavyShotgun
    [-1074790547] = 30, -- AssaultRifle
    [-2084633992] = 32, -- CarbineRifle
    [-1063057011] = 32, -- SpecialCarbine
    [2132975508] = 32, -- BullpupRifle
    [1649403952] = 34, -- CompactRifle
    [-1660422300] = 40, -- MG
    [2144741730] = 45, -- CombatMG
    [1627465347] = 34, -- Gusenberg
    [100416529] = 101, -- SniperRifle
    [205991906] = 216, -- HeavySniper
    [-952879014] = 65, -- MarksmanRifle
    [1119849093] = 30, -- Minigun
    [-1466123874] = 165, -- Musket
    [911657153] = 1, -- StunGun
    [1198879012] = 10, -- FlareGun
    [-598887786] = 220, -- MarksmanPistol
    [1834241177] = 30, -- Railgun
    [-275439685] = 30, -- DoubleBarrelShotgun
    [-1746263880] = 81, -- Double Action Revolver
    [-2009644972] = 30, -- SNS Pistol Mk II
    [-879347409] = 200, -- Heavy Revolver Mk II
    [-1768145561] = 32, -- Special Carbine Mk II
    [-2066285827] = 33, -- Bullpup Rifle Mk II
    [1432025498] = 32, -- Pump Shotgun Mk II
    [1785463520] = 75, -- Marksman Rifle Mk II
    [961495388] = 40, -- Assault Rifle Mk II
    [-86904375] = 33, -- Carbine Rifle Mk II
    [-608341376] = 47, -- Combat MG Mk II
    [177293209] = 230, -- Heavy Sniper Mk II
    [-1075685676] = 32, -- Pistol Mk II
    [2024373456] = 25, -- SMG Mk II
}

local weaponsComponents = {
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_01'),
    GetHashKey('COMPONENT_COMBATPISTOL_CLIP_02'),
    GetHashKey('COMPONENT_APPISTOL_CLIP_01'),
    GetHashKey('COMPONENT_APPISTOL_CLIP_02'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_01'),
    GetHashKey('COMPONENT_MICROSMG_CLIP_02'),
    GetHashKey('COMPONENT_SMG_CLIP_01'),
    GetHashKey('COMPONENT_SMG_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_01'),
    GetHashKey('COMPONENT_CARBINERIFLE_CLIP_02'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_01'),
    GetHashKey('COMPONENT_ADVANCEDRIFLE_CLIP_02'),
    GetHashKey('COMPONENT_MG_CLIP_01'),
    GetHashKey('COMPONENT_MG_CLIP_02'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_01'),
    GetHashKey('COMPONENT_COMBATMG_CLIP_02'),
    GetHashKey('COMPONENT_PUMPSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_SAWNOFFSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSHOTGUN_CLIP_02'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_01'),
    GetHashKey('COMPONENT_PISTOL50_CLIP_02'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_01'),
    GetHashKey('COMPONENT_ASSAULTSMG_CLIP_02'),
    GetHashKey('COMPONENT_AT_RAILCOVER_01'),
    GetHashKey('COMPONENT_AT_AR_AFGRIP'),
    GetHashKey('COMPONENT_AT_PI_FLSH'),
    GetHashKey('COMPONENT_AT_AR_FLSH'),
    GetHashKey('COMPONENT_AT_SCOPE_MACRO'),
    GetHashKey('COMPONENT_AT_SCOPE_SMALL'),
    GetHashKey('COMPONENT_AT_SCOPE_MEDIUM'),
    GetHashKey('COMPONENT_AT_SCOPE_LARGE'),
    GetHashKey('COMPONENT_AT_SCOPE_MAX'),
    GetHashKey('COMPONENT_AT_PI_SUPP'),
}

local insideAnyVehicle = false

RegisterNetEvent('ft_libs:enteredVehicle')
AddEventHandler('ft_libs:enteredVehicle', function()
	insideAnyVehicle = true
	--[[Citizen.CreateThread(function()
		while insideAnyVehicle do
			Citizen.Wait(0)
			local ped = GetPlayerPed(-1)
			DisablePlayerVehicleRewards(PlayerId())
	
			if IsPedInAnyVehicle(ped, false) and disableShuffle then
				if GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), 0) == ped then
					if GetIsTaskActive(ped, 165) then
						SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
					end
				end
			end
		end
	end)]]
	SetPedConfigFlag(GetPlayerPed(-1), 184, true)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DisablePlayerVehicleRewards(PlayerId())
	end
end)

RegisterNetEvent('ft_libs:exitedVehicle')
AddEventHandler('ft_libs:exitedVehicle', function()
	insideAnyVehicle = false
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)

		if IsPedArmed(ped,6) then
            DisableControlAction(0,140,true)
            DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			if IsPedShooting(ped) then
				local selectedWeapon = GetSelectedPedWeapon(ped)
				local damage = math.floor(GetWeaponDamage(selectedWeapon))

                if WeaponDamagesTable[selectedWeapon] and damage > WeaponDamagesTable[selectedWeapon] then
                   TriggerServerEvent("cframework:damagemodifier")
                end

                if GetVehiclePedIsIn(ped, false) ~= 0 then
                    TriggerEvent("cframework:shootingInsideVehicle")
                end

				for _,theWeapon in ipairs(BlacklistedWeapons) do
					if GetHashKey(theWeapon) == selectedWeapon then
						TriggerServerEvent("semdestino:WeaponBan", theWeapon)
					end
				end
			end
		else
			Citizen.Wait(400)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        for i = 1, #weaponsComponents do
            local dmg_mod = GetWeaponComponentDamageModifier(weaponsComponents[i])
            local accuracy_mod = GetWeaponComponentAccuracyModifier(weaponsComponents[i])
            if dmg_mod > 1.1 or accuracy_mod > 1.2 then
                TriggerServerEvent("cframework:damagemodifier")
				return
            end
        end

		if GetPedConfigFlag(PlayerPedId(), 2, false) == 1 then
			TriggerServerEvent("cframework:headshot")
			return
		end
    end
end)

local handsup = false
local arms = false
local dict = "missminuteman_1ig_2"
local dict2 = "amb@world_human_hang_out_street@female_arms_crossed@base"

function sobeAsMaos()
	if disableEmotes then return end
    if ESX.IsHolstering() then return end

	if not handsup then
		TaskPlayAnim(PlayerPedId(), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
		handsup = true
	else
		handsup = false
		ClearPedTasks(PlayerPedId())
	end
end

AddEventHandler('cframework:handsUp', function()
	sobeAsMaos()
end)

function animacoes()
	if disableEmotes then return end
    if ESX.IsHolstering() then return end
	
	TriggerEvent('esx_animations:menu') 
end



function cruzabracos()
	if disableEmotes then return end
    if ESX.IsHolstering() then return end

	if not arms then
		TaskPlayAnim(GetPlayerPed(-1), dict2, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
		arms = true
	else
		arms = false
		ClearPedTasks(GetPlayerPed(-1))
	end
end

function cainochao()
	if disableEmotes then return end
	if disableRagdoll then return end
    if ESX.IsHolstering() then return end

	if IsPedInMeleeCombat(PlayerPedId()) then return end

	Citizen.CreateThread(function()
		while IsControlPressed(1, 20 --[[ "Z" key ]]) do
			Citizen.Wait(0)		
				-- https://runtime.fivem.net/doc/natives/#_0xAE99FB955581844A
			SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, true, true, false) 
		end
	end)
end

function backspacetecla()
	if disableEmotes then return end
    if ESX.IsHolstering() then return end

	TriggerEvent('cframework:emoteCancel')

	ClearPedTasks(GetPlayerPed(-1))
end

local inCooldown = false
local inCooldown2 = false

function inserttecla()
	if inCooldown then return end

	inCooldown = true

	TriggerServerEvent('cframework:synctecla', 'INSERT')

	Citizen.CreateThread(function()
		Citizen.Wait(1500)
		inCooldown = false
	end)
end

function deletetecla()
	if inCooldown2 then return end

	inCooldown2 = true

	TriggerServerEvent('cframework:synctecla', 'DELETE')

	Citizen.CreateThread(function()
		Citizen.Wait(1500)
		inCooldown2 = false
	end)
end


function startstoprecording()
	if IsRecording() then
		StopRecordingAndSaveClip()
	else
		StartRecording(1)
	end
end



Citizen.CreateThread(function()
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
	
	RequestAnimDict(dict2)
	while not HasAnimDictLoaded(dict2) do
		Citizen.Wait(100)
	end
	
	exports.ft_libs:AddButton("handsup:rpscripts", {
		key = 73,
		use = {
		  callback = sobeAsMaos,
		},
	})

	exports.ft_libs:AddButton("animacoes:rpscripts", {
		key = 170,
		use = {
		  callback = animacoes,
		},
	})

	exports.ft_libs:AddButton("cruzabracos:rpscripts", {
		key = 47,
		use = {
		  callback = cruzabracos,
		},
	})

	exports.ft_libs:AddButton("cainochao:rpscripts", {
		key = 20,
		use = {
		  callback = cainochao,
		},
	})

	exports.ft_libs:AddButton("backspace:rpscripts", {
		key = 194,
		use = {
		  callback = backspacetecla,
		},
	})

	exports.ft_libs:AddButton("insert:rpscripts", {
		key = 121,
		use = {
		  callback = inserttecla,
		},
	})

	exports.ft_libs:AddButton("delete:rpscripts", {
		key = 178,
		use = {
		  callback = deletetecla,
		},
	})

	exports.ft_libs:AddButton("record:rpscripts", {
		key = 182,
		use = {
		  callback = startstoprecording,
		},
	})

end)

local crouched = false

Citizen.CreateThread( function()
	RequestAnimSet("move_ped_crouched")

	while not HasAnimSetLoaded( "move_ped_crouched" ) do
		Citizen.Wait(0)
	end

    while true do
        local ped = PlayerPedId()

        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            DisableControlAction(0, 36, true) -- INPUT_DUCK  

            if not IsPauseMenuActive() and not IsPedInAnyVehicle(ped, true) then
                if IsDisabledControlJustPressed(0, 36) then
                    if crouched then
                        ResetPedMovementClipset(ped, 0.25)
                        crouched = false
                    elseif not crouched then
                        SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                        crouched = true
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end )

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
		CancelEvent()
	end
end)

