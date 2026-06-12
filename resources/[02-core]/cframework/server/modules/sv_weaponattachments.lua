

local function registerAttachmentItem(itemName, attachmentName)
    ESX.RegisterUsableItem(itemName, function(source, slot)
        local pedWeapon <const> = GetSelectedPedWeapon(GetPlayerPed(source))
        local weapon <const>, weaponName <const> = ESX.GetWeaponFromHash(pedWeapon)
        local weaponSlot <const> = ESX.GetWeaponHandCurrentSlot(source)
        local inventory <const> = ESX.getInvContainer(source)
        local weaponItem <const> = inventory.getItemInSlot(weaponSlot)
        local isAttachmentValid = false

        if weapon == nil then TriggerClientEvent("cframework:weaponInHandNotValid", source) return end
        if weaponItem == nil then TriggerClientEvent("cframework:weaponInHandNotValid", source) return end
        if weaponItem.name ~= weaponName then TriggerClientEvent("cframework:weaponInHandNotValid", source) return end

        for _,v in ipairs(weapon.components) do
            if v.name == attachmentName then
                isAttachmentValid = true
            end
        end

        if not isAttachmentValid then TriggerClientEvent("cframework:attachmentNotValid", source) return end

        if weaponItem.metadata.components == nil then
            weaponItem.metadata.components = {}
        end

        for _,v in ipairs(weaponItem.metadata.components) do
            if v == attachmentName then
                TriggerClientEvent("cframework:alreadyHasAttachment", source)
                return
            end
        end

        inventory.removeItem(itemName, 1, slot)

        table.insert(weaponItem.metadata.components, attachmentName)
		TriggerClientEvent('esx:addWeaponComponent', source, weaponName, attachmentName)

        inventory.updateMetadata(weaponSlot, "components", weaponItem.metadata.components)
    end)
end

Citizen.CreateThread(function()
    for itemName, itemData in pairs(ESX.Items) do
        if itemData.attachment then
            registerAttachmentItem(itemName, itemData.attachment)
        end
    end
end)
