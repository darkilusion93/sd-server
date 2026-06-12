local weaponModifiers <const> = {
    [`WEAPON_UNARMED`] = 0.1,
    [`WEAPON_KNUCKLE`] = 0.2,
    [`WEAPON_FLASHLIGHT`] = 0.2,
    [`WEAPON_NIGHTSTICK`] = 0.2,
    [`WEAPON_BOTTLE`] = 0.3,
    [`WEAPON_CROWBAR`] = 0.3,
    [`WEAPON_WRENCH`] = 0.3,
    [`WEAPON_BAT`] = 0.4,
    [`WEAPON_GOLFCLUB`] = 0.4,
    [`WEAPON_POOLCUE`] = 0.4,
    [`WEAPON_DAGGER`] = 0.5,
    [`WEAPON_KNIFE`] = 0.5,
    [`WEAPON_SWITCHBLADE`] = 0.5,
    [`WEAPON_MACHETE`] = 0.5,
    [`WEAPON_HAMMER`] = 0.6,
    [`WEAPON_BATTLEAXE`] = 0.6,
    [`WEAPON_HATCHET`] = 0.6,
    [`WEAPON_GADGETPISTOL`]  = 0.5,
    [`WEAPON_SNSPISTOL_MK2`]  = 0.9,
    [`WEAPON_PISTOL_MK2`]  = 0.9,
    [`WEAPON_ASSAULTRIFLE`]  = 1.1,
    [`WEAPON_COMPACTRIFLE`]  = 1.1,
    [`WEAPON_ASSAULTRIFLE_MK2`]  = 0.9,
    [`WEAPON_SPECIALCARBINE_MK2`]  = 0.9,
    [`WEAPON_BULLPUPRIFLE_MK2`]    = 0.9,
    [`WEAPON_MARKSMANPISTOL`]    = 0.3,
}

Citizen.CreateThread(function()
    for weapon, modifier in pairs(weaponModifiers) do
        SetWeaponDamageModifier(weapon, modifier)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	        DisableControlAction(1, 140, true)
       	    DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)