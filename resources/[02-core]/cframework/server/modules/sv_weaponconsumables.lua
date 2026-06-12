

RegisterNetEvent('cframework:updateWeaponAmmo', function(slot, weaponName, ammoCount, deleteWeapon)
	local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    inventory.updateMetadata(slot, "ammo", ammoCount)

	if deleteWeapon then
		inventory.removeItem(weaponName, 1, slot)
	end
end)