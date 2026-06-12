

ESX.RegisterUsableItem("lockpick", function(source)
    TriggerClientEvent("cframework:useLockpick", source)
end)

RegisterNetEvent("cframework:removeLockpickAfterUse", function()
	local source <const> = source
    local inventory = ESX.getInvContainer(source)

    inventory.removeItem("lockpick", 1)
end)