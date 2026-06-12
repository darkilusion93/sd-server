

local updatedAmmo, deleteWeapon = true, nil
local weaponName, ammoCount = nil, nil
local lastShot = 0
local forceUpdate = false
local consumableWeapon = {
	['WEAPON_PETROLCAN'] = true,
	['GADGET_PARACHUTE'] = true,
}

AddEventHandler("cframework:forceUpdateWeaponAmmo", function(force)
    forceUpdate = force
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()

		if IsPedShooting(playerPed) or forceUpdate then
			local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
			local weapon, wName = ESX.GetWeaponFromHash(weaponHash)

			if weapon then
				ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
				weaponName = wName
				updatedAmmo = false
				if ammoCount < 100 and consumableWeapon[weaponName] then
					deleteWeapon = weaponName
				end

                TriggerEvent("esx:updateMetadata", {slot = ESX.GetWeaponInHandSlot()}, "ammo", ammoCount)
                lastShot = GetGameTimer() + 1000
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)

        if (lastShot < GetGameTimer()) and (not updatedAmmo and weaponName and ammoCount) then
            TriggerServerEvent('cframework:updateWeaponAmmo', ESX.GetWeaponInHandSlot(), weaponName, ammoCount, deleteWeapon)
			updatedAmmo = true
			deleteWeapon = nil
		end
	end
end)