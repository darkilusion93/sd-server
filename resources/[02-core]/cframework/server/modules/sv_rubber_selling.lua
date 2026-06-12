

local rubberData = LoadRubber()
local sellLocation <const> = rubberData.sellLocation

RegisterNetEvent("cframework:rubberSelling", function(value)
    local source <const> = source
    local sellData <const> = rubberData.selling[value]

    if not sellData then
        return
    end

    local inventory <const> = ESX.getInvContainer(source)
    local itemAmount <const> = inventory.getItemAmount(sellData.item)
    local price <const> = itemAmount * sellData.price

    if ESX.getJob(source).name ~= rubberData.jobName then
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        return
    end

    if itemAmount < 1 then TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_DONT_HAVE_ENOUGH"), ESX.GetItemLabel(sellData.item)), 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then
        TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_CANT_CARRY"), ESX.GetItemLabel('cash')), 'error')
        return
    end

    inventory.removeItem(sellData.item, itemAmount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, string.format(T("ACTIONS_SOLD"), ESX.GetItemLabel(sellData.item)), 'success')
end)
