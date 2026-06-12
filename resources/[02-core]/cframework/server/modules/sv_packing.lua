

local function packItem(source, slot, item, bagItem, addedItem, packAmount)
    local inventory <const> = ESX.getInvContainer(source)

	if not inventory.canRemoveItem(bagItem, packAmount) then TriggerClientEvent('esx:showNotification', source, (T("ACTION_NEED_X_TO_PACK")):format(ESX.GetItemLabel(bagItem)), 'error')
		return
	end

	if not inventory.canRemoveItem(item, packAmount, slot) then TriggerClientEvent('esx:showNotification', source, T("ACTION_NEED_MORE_TO_PACK"), 'error')
		return
	end

	if not inventory.canAddItem(addedItem, packAmount) then TriggerClientEvent('esx:showNotification', source, T("INVENTORY_NOT_ENOUGH_SPACE"), 'error')
		return
	end

    inventory.removeItem(bagItem, packAmount)
    inventory.removeItem(item, packAmount, slot)
    inventory.addItem(addedItem, packAmount)

    TriggerClientEvent("cframework:packingAnimation", source)
end

Citizen.CreateThread(function()
    for k,v in pairs(ESX.Items) do
        if v.packable then
            ESX.RegisterUsableItem(k, function(source, slot) packItem(source, slot, k, v.packable.bag, v.packable.item, v.packable.count) end)
        end
    end
end)
