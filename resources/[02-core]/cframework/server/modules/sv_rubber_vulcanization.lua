

local rubberData = LoadRubber()
local activeVulcanizers = {}

local function handleVulcanization(player, material)
    local recipe = rubberData.vulcanization[material]
    if not recipe then return false end

    if not ESX.playerInsideLocation(player, rubberData.vulcanizationLocation, 10.0) then return false end

    local inv = ESX.getInvContainer(player)

    -- Check input
    local inputItems = recipe.input
    for _, req in ipairs(inputItems) do
        if not inv.canRemoveItem(req.item, req.count) then
            TriggerClientEvent('esx:showNotification', player, string.format(T("ACTIONS_DONT_HAVE_ENOUGH"), ESX.GetItemLabel(req.item)), 'error')
            return false
        end
    end

    -- Check space
    if not inv.canAddItem(recipe.output.item, recipe.output.count) then
        TriggerClientEvent('esx:showNotification', player, string.format(T("ACTIONS_CANT_CARRY"), ESX.GetItemLabel(recipe.output.item)), 'error')
        return false
    end

    -- Remove input
    for _, req in ipairs(inputItems) do
        inv.removeItem(req.item, req.count)
    end

    -- Add output
    inv.addItem(recipe.output.item, recipe.output.count)

    return true
end

RegisterNetEvent("cframework:startVulcanization", function(material)
    local src = source
    if ESX.getJob(src).name ~= rubberData.jobName then return end
    if not ESX.inService(src) then return end
    if not ESX.playerInsideLocation(src, rubberData.vulcanizationLocation, 10.0) then return end
    if activeVulcanizers[src] then return end

    local recipe = rubberData.vulcanization[material]
    if not recipe then return end

    activeVulcanizers[src] = true

    Citizen.CreateThread(function()
        while activeVulcanizers[src] do
            Citizen.Wait(recipe.time)
            local success = handleVulcanization(src, material)
            if not success then
                activeVulcanizers[src] = nil
                TriggerClientEvent('cframework:rubberFail', src)
                break
            end
        end
    end)
end)

RegisterNetEvent("cframework:stopVulcanization", function()
    local src = source
    activeVulcanizers[src] = nil
end)

AddEventHandler("playerDropped", function()
    local src = source
    activeVulcanizers[src] = nil
end)
