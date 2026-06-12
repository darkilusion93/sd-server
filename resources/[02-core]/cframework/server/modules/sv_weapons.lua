
local currentWeaponSlot = {}

function ESX.GetWeaponHandCurrentSlot(source)
    return currentWeaponSlot[source] or 0
end

local function registerWeapon(itemName)
    ESX.RegisterUsableItem(itemName, function(source, slot)
        local pedWeapon <const> = GetSelectedPedWeapon(GetPlayerPed(source))
        local _, weaponName <const> = ESX.GetWeaponFromHash(pedWeapon)
        local inventory <const> = ESX.getInvContainer(source)
        local weaponItem <const> = inventory.getItemInSlot(slot)

        if weaponItem == nil then return end

        if weaponName ~= nil and weaponName == itemName then
            TriggerClientEvent("cframework:removeWeapons", source)
            return
        end

        TriggerClientEvent("cframework:addWeapon", source, slot, itemName, weaponItem.metadata)
        currentWeaponSlot[source] = slot
    end)
end

Citizen.CreateThread(function()
    for itemName, itemData in pairs(ESX.Items) do
        if itemData.type == "weapon" then
            registerWeapon(itemName)
        end
    end
end)
