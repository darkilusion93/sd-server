

local drugData = LoadDrugs()

local pedSelling <const> = drugData.pedSelling

local copCount = 0

AddEventHandler('esx:onlineCops', function(count)
    copCount = count
end)

local function isJobValid(jobName, jobList)
    for i=1, #jobList do
        if jobName == jobList[i] then
            return true
        end
    end

    return false
end

RegisterNetEvent("cframework:sellPedDrug", function(type)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local jobName <const> = ESX.getJob(source).name
    local dealerData <const> = pedSelling[type]

    if copCount < dealerData.minCops then
        TriggerClientEvent('esx:showNotification', source, T("DRUGS_NOT_ENOUGH_COPS"), 'error')
        return
    end

    local selectedDrug = nil

    for k, v in ipairs(dealerData.items) do
        if inventory.canRemoveItem(v.name, v.count) then
            selectedDrug = v
            break
        end
    end

    if selectedDrug == nil then
        return
    end

    local price = selectedDrug.count * selectedDrug.price

    if selectedDrug.jobPrice and isJobValid(jobName, selectedDrug.jobs) then
        price = selectedDrug.count * selectedDrug.jobPrice
    end

    if not inventory.canRemoveItem(selectedDrug.name, selectedDrug.count) then
        TriggerClientEvent('esx:showNotification', source, (T("INVENTORY_DONT_HAVE_ENOUGH")):format(ESX.GetItemLabel(selectedDrug.name)), 'error')
        return
    end

    if not inventory.canAddItem(selectedDrug.cash, price) then
        TriggerClientEvent('esx:showNotification', source, (T("INVENTORY_CANT_CARRY_MORE")):format(ESX.GetItemLabel(selectedDrug.cash)), 'error')
        return
    end

    inventory.removeItem(selectedDrug.name, selectedDrug.count)
    inventory.addItem(selectedDrug.cash, price)

    TriggerClientEvent("tradeDrugWithPed", source)
end)