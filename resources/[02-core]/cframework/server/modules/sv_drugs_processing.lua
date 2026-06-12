

local drugData = LoadDrugs()
local playersProcessingDrug = {}
local processing = {}

for _, loc in pairs(drugData.processing) do
    table.insert(processing, vector3(loc.x, loc.y, loc.z))
end

local function logWrongBucketProcessing(source)
    local routingBucket <const> = GetPlayerRoutingBucket(source)
    if routingBucket ~= 0 then
        TriggerEvent('semdestino:log', 'Drugs', 'Processar na dimensão errada', 'superadmin', ESX.getIdentifier(source) .."", 'azul', ESX.getName(source) .. ' [' .. source .. ']')
    end
end

local function authorizedToProcess(jobs, job)
    if jobs == nil or #jobs == 0 then
        return true
    end

    for _, v in pairs(jobs) do
        if v == job or v == "none" then
            return true
        end
    end

    return false
end

local function processDrug(player, type)
	local source <const> = player
    local inventory <const> = ESX.getInvContainer(source)
	local job = ESX.getJob(source).name

	if not ESX.playerInsideLocation(source, processing, 10.0) then
        return false
    end

    local processItems <const> = drugData.processableDrugs[type]

    if processItems == nil then
        TriggerClientEvent('esx:showNotification', source, 'Tipo de droga inválido.', 'error')
        return false
    end

    if not authorizedToProcess(processItems.jobs, job) then
        TriggerClientEvent('esx:showNotification', source, 'Não tens autorização para processar esta droga.', 'error')
        return false
    end

    for _, item in pairs(processItems.needs) do
        if not inventory.canRemoveItem(item.name, item.count) then
            TriggerClientEvent('esx:showNotification', source, 'Não tens ' .. ESX.GetItemLabel(item.name) .. ' suficiente.', 'error')
            return false
        end
    end

    for _, item in pairs(processItems.result) do
        if not inventory.canAddItem(item.name, item.count) then
            TriggerClientEvent('esx:showNotification', source, 'O teu inventário está cheio.', 'error')
            return false
        end
    end

    for _, item in pairs(processItems.needs) do
        if item.consume ~= nil and item.consume then
            inventory.removeItem(item.name, item.count)
        end
    end

    for _, item in pairs(processItems.result) do
        inventory.addItem(item.name, item.count)
    end

    logWrongBucketProcessing(source)

	return true
end


RegisterNetEvent("cframework:startProcessDrug", function(type)
    local source <const> = source

	if not ESX.playerInsideLocation(source, processing, 10.0) then
        return
    end

    playersProcessingDrug[source] = type
end)


RegisterNetEvent("cframework:stopProcessDrug", function()
    local source <const> = source
    local drugType <const> = playersProcessingDrug[source]

    if drugType == nil then return end

    playersProcessingDrug[source] = nil
end)


AddEventHandler("playerDropped", function()
    local source <const> = source

    playersProcessingDrug[source] = nil
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        for player, _ in pairs(playersProcessingDrug) do
            if playersProcessingDrug[player] ~= nil then
                local success <const> = processDrug(player, playersProcessingDrug[player])

                if not success then
                    TriggerClientEvent("cframework:processDrugFail", player)
                end
            end
        end
    end
end)