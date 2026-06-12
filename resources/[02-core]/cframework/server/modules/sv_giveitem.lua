


RegisterServerEvent("cframework:giveInventoryItem", function(target, itemCount, itemSlot)
	local source = source
	local sourceInventory = ESX.getInvContainer(source)
	local targetInventory = ESX.getInvContainer(target)

	if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent("esx:showNotification", source, "Estás morto, funcionalidade desativada.", "error") return end

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    TriggerClientEvent("cframework:playGiveAnim", source)
    TriggerClientEvent("cframework:playGiveAnim", target)

    --ESX.logInventoryGive(source, target, "DAR", item.name, itemCount, ESX.GetItemLabel(item.name))
end)