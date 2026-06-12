

local currentWeaponSlot, weaponCooldown = 0, false

function ESX.GetWeaponInHandSlot()
    return currentWeaponSlot
end

RegisterNetEvent("cframework:removeWeapons", function()
    RemoveAllPedWeapons(PlayerPedId(), true)
    currentWeaponSlot = 0
end)

RegisterNetEvent("cframework:addWeapon", function(slot, weaponName, metadata)
    local weaponHash <const> = GetHashKey(weaponName)
    local playerPed <const> = PlayerPedId()
    local weaponAmmo <const> = metadata.ammo or 0

    if weaponCooldown then
        return
    end

    RemoveAllPedWeapons(playerPed, true)
    weaponCooldown = true

    if currentWeaponSlot ~= 0 then
        Citizen.Wait(1500) -- Time for holster to complete
    end

    GiveWeaponToPed(playerPed, weaponHash, weaponAmmo, false, true)

    SetCurrentPedWeapon(playerPed, weaponHash, true)
	SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
	SetWeaponsNoAutoswap(true)

    currentWeaponSlot = slot
    weaponCooldown = false

    if metadata ~= nil and metadata.components ~= nil then
        for i=1, #metadata.components, 1 do
            local component <const> = ESX.GetWeaponComponent(weaponName, metadata.components[i])

            if component ~= nil then
                GiveWeaponComponentToPed(playerPed, weaponHash, component.hash)
            end
        end
    end
end)


RegisterNetEvent('esx:removeInventoryItem', function(item, count, invCount, remove)
    if item.slot == currentWeaponSlot then
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeaponSlot = 0
    end
end)

RegisterNetEvent('esx:changeSlotItem', function(item, fromSlot, remove)
    if fromSlot == currentWeaponSlot or item.slot == currentWeaponSlot then
        RemoveAllPedWeapons(PlayerPedId(), true)
        currentWeaponSlot = 0
    end
end)