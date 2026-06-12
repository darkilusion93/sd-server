


local holstered = true
local isHolstering = false
local disabledHolster = false
local holsterAnim = "back"

local function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end
end

function ESX.IsHolstering()
    return isHolstering
end

exports('isHolstering', function()
    return isHolstering
end)

function DisableHolster()
	disabledHolster = true
	holstered = true
end

function EnableHolster()
	disabledHolster = false
end

local function unholsterWeapon(ped, anim)
    isHolstering = true

    if anim == "back" then
        SetPedCurrentWeaponVisible(ped, false, false, false, false)
        loadAnimDict( "reaction@intimidation@1h" )
        TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 8.0, 2.0, -1, 48, 2, false, false, false)
        Citizen.CreateThread(function()
            while holstered do
                Citizen.Wait(0)
                DisablePlayerFiring(ped, true)
            end
        end)
        Citizen.Wait(1200)
        SetPedCurrentWeaponVisible(ped, true, false, false, false)
        Citizen.Wait(1300)
        ClearPedTasks(ped)

        Citizen.Wait(100)
        DisablePlayerFiring(ped, false)
    end

    if anim == "front" then
        Citizen.Wait(500)
		TaskReloadWeapon(ped, false)
		Citizen.Wait(2250)
    end

    if anim == "side" then
        SetPedCurrentWeaponVisible(ped, false, false, false, false)
		loadAnimDict('reaction@intimidation@cop@unarmed')
		TaskPlayAnim(ped, 'reaction@intimidation@cop@unarmed', 'intro', 8.0, 2.0, -1, 50, 2.0, false, false, false)
		RemoveAnimDict('reaction@intimidation@cop@unarmed')
		Citizen.Wait(700)
		SetPedCurrentWeaponVisible(ped, true, false, false, false)
		loadAnimDict('rcmjosh4')
		TaskPlayAnim(ped, 'rcmjosh4', 'josh_leadout_cop2', 8.0, 2.0, -1, 48, 10, false, false, false)
		RemoveAnimDict('rcmjosh4')
		Citizen.Wait(400)
    end

    holstered = false
    isHolstering = false
end

local function holsterWeapon(ped, anim)
    isHolstering = true

    if anim == "back" then
        loadAnimDict("weapons@pistol_1h@gang")
        TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 2.0, -1, 48, 2, false, false, false)
        DisablePlayerFiring(ped, true)
        Citizen.Wait(1500)
        DisablePlayerFiring(ped, false)
        ClearPedTasks(ped)
    end

    if anim == "front" then

    end

    if anim == "side" then
        loadAnimDict('rcmjosh4')
		TaskPlayAnim(ped, 'rcmjosh4', 'josh_leadout_cop2', 8.0, 2.0, -1, 48, 10, false, false, false)
		RemoveAnimDict('rcmjosh4')
		Citizen.Wait(500)
		loadAnimDict('reaction@intimidation@cop@unarmed')
		TaskPlayAnim(ped, 'reaction@intimidation@cop@unarmed', 'outro', 8.0, 2.0, -1, 50, 2.0, false, false, false)
		RemoveAnimDict('reaction@intimidation@cop@unarmed')
		Citizen.Wait(60)
    end

    holstered = true
    isHolstering = false
end

Citizen.CreateThread(function()
	while true do
        local ped <const> = PlayerPedId()
        local playWeaponAnim = ESX.playWeaponAnim(GetSelectedPedWeapon(ped))

		if disabledHolster or IsPedInAnyVehicle(ped, true) then
            while IsPedInAnyVehicle(ped, true) do
                Citizen.Wait(0)
            end

            Citizen.Wait(100)

            playWeaponAnim = ESX.playWeaponAnim(GetSelectedPedWeapon(ped))
            if holstered and playWeaponAnim then
                holstered = false
            elseif not holstered and not playWeaponAnim then
                holstered = true
            end

			goto final
		end

		if DoesEntityExist(ped) and not IsEntityDead(ped) then
			if playWeaponAnim then
				if holstered then
                    unholsterWeapon(ped, holsterAnim)
				end
			elseif not playWeaponAnim then
				if not holstered then
                    holsterWeapon(ped, holsterAnim)
				end
			end
		end

		::final::

        Citizen.Wait(50)
	end
end)

RegisterNetEvent("cframework:removeWeaponsFromHandInstant", function()
	DisableHolster()
	SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
	EnableHolster()
end)

--[[RegisterCommand("setholsteranim", function(source, args, raw)
    holsterAnim = args[1]
end, false)]]