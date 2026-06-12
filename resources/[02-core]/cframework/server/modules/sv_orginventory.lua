local currentJobPlayerIsAccessing = {}
local customJobAccess = {
	['police'] = {
		['sheriff'] = true,
		['swat'] = true,
		['swat_chefe'] = true,
	},
}

RegisterNetEvent('cframework:takeOrgItem', function(itemSlot, itemCount, toSlot)
	local source <const> = source
	local job <const> = currentJobPlayerIsAccessing[source]

    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_FUNCTION_DISABLED_WHILE_DEAD"), 'error') return end

    local sourceInventory, targetInventory = GetSharedInventory(string.format("society_%s", job)), ESX.getInvContainer(source)

    local success <const>, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)

    if not success then return end

    --ESX.logOrgData(source, "RETIRAR", item.name, itemCount, job, ESX.getJob(source).label)
    TriggerClientEvent("cframework:refreshOrgInventory", source)

    if swappedItem ~= nil then
        --ESX.logOrgData(source, "PÔR", swappedItem.name, swappedItem.count, job, ESX.getJob(source).label)
    end
end)

RegisterNetEvent('cframework:putOrgItem', function(itemSlot, itemCount)
	local source <const> = source
	local job <const> = currentJobPlayerIsAccessing[source]

    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_FUNCTION_DISABLED_WHILE_DEAD"), 'error') return end

    local sourceInventory, targetInventory = ESX.getInvContainer(source), GetSharedInventory(string.format("society_%s", job))

    local success <const>, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    --ESX.logOrgData(source, "PÔR", item.name, itemCount, job, ESX.getJob(source).label)
    TriggerClientEvent("cframework:refreshOrgInventory", source)

    if swappedItem ~= nil then
        --ESX.logOrgData(source, "RETIRAR", swappedItem.name, swappedItem.count, job, ESX.getJob(source).label)
    end
end)

RegisterNetEvent('cframework:getOrgInventory', function(customJob)
	local source <const> = source
	local job = ESX.getJob(source).name

	if customJob ~= nil and customJob ~= job and (customJob == job.."_chefe" or (customJobAccess[job] and customJobAccess[job][customJob])) then
		job = customJob
	end

	currentJobPlayerIsAccessing[source] = job

    local inventory = GetSharedInventory(string.format("society_%s", job))

    if inventory == nil then
        return
    end

    TriggerClientEvent('cframework:openNewOrgInventory', source, {items = inventory.getItems()})
end)
