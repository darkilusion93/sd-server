local ESX = nil

CreateThread(function()
    if GetResourceState('cframework') == 'started' then
        local ok, sharedObject = pcall(function()
            return exports['cframework']:getSharedObject()
        end)

        if ok and sharedObject then
            ESX = sharedObject
        end
    end

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Wait(100)
    end
end)

local searchCooldowns = {}

local trashRewards = {
    --{ name = 'sacolixo', label = 'Sacola de Lixo', min = 1, max = 5, chance = 50 },
    { name = 'vidro', label = 'Vidro', min = 1, max = 3, chance = 60 },
    { name = 'btel', label = 'Telemovel Estragado', min = 1, max = 4, chance = 65 },
    { name = 'bradio', label = 'Radio Estragado', min = 1, max = 2, chance = 40 },
    { name = 'fibra', label = 'Fibra', min = 1, max = 2, chance = 35 },
    { name = 'leather', label = 'Couro', min = 1, max = 1, chance = 25 },
    { name = 'feather', label = 'Penas', min = 1, max = 1, chance = 15 },
    { name = 'kevlar', label = 'Kevlar', min = 1, max = 1, chance = 10 },
    { name = 'recicled_plastic', label = 'Plastico Reciclado', min = 1, max = 2, chance = 20 },
    { name = 'steel', label = 'Aco', min = 1, max = 2, chance = 15 },
    { name = 'componenteseletronicos', label = 'Componentes Eletronicos', min = 1, max = 1, chance = 5 },
    { name = 'jar', label = 'Frasco Vazio', min = 1, max = 1, chance = 10 }
}

local function notify(src, message)
    TriggerClientEvent('esx:showNotification', src, message)
end

local function getPlayer(src)
    if not ESX then
        return nil
    end

    return ESX.GetPlayerFromId(src)
end

local function getItemCount(xPlayer, itemName)
    local item = xPlayer.getInventoryItem(itemName)
    return item and item.count or 0
end

local function canCarryItem(src, itemName, quantity)
    local inventory = ESX.getInvContainer(src)
    return inventory.canAddItem(itemName, quantity)
end

local function findRecipe(itemData)
    if type(itemData) ~= 'table' then
        return nil
    end

    local recipeId = itemData.nome_sv or itemData.name or itemData.nome
    if not recipeId then
        return nil
    end

    for _, recipe in ipairs(Config.LojaItems or {}) do
        if recipe.nome_sv == recipeId or recipe.nome == recipeId then
            return recipe
        end
    end

    return nil
end

local function isNearCoords(src, coords, maxDistance)
    if not coords then
        return true
    end

    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then
        return true
    end

    local playerCoords = GetEntityCoords(ped)
    local targetCoords = vector3(coords.x, coords.y, coords.z)

    return #(playerCoords - targetCoords) <= maxDistance
end

local recicle = {vector3(146.0779,6368.899,31.52955)}

local function giveItem(xPlayer, src, itemName, label, quantity)
    if quantity <= 0 then
        return false
    end

    if not ESX.playerInsideLocation(src, recicle, 100.0) then
        return
    end

    if not canCarryItem(src, itemName, quantity) then
        notify(src, 'Nao tens espaco suficiente no inventario.')
        return false
    end

    local inventory = ESX.getInvContainer(src)

    inventory.addItem(itemName, quantity)
    --notify(src, ('Recebeste ~g~%sx %s~s~!'):format(quantity, label or itemName))
    return true
end

RegisterNetEvent('reciclagem:reciclar', function(itemData)
    local src = source
    local xPlayer = getPlayer(src)
    if not xPlayer then
        return
    end

    if not isNearCoords(src, Config.LojaCoordenadas, 8.0) then
        print(('[sd-reciclagem] %s tentou reciclar longe da loja.'):format(src))
        return
    end

    local recipe = findRecipe(itemData)
    if not recipe then
        notify(src, 'Receita de reciclagem invalida.')
        print(('[sd-reciclagem] %s enviou uma receita invalida.'):format(src))
        return
    end

    for _, requiredItem in ipairs(recipe.itemsrequeridos or {}) do
        if getItemCount(xPlayer, requiredItem.name) < requiredItem.quantity then
            notify(src, ('Nao tens ~r~%sx %s~s~!'):format(requiredItem.quantity, requiredItem.label or requiredItem.name))
            return
        end
    end

    for _, rewardItem in ipairs(recipe.itemsrecebidos or {}) do
        if not canCarryItem(xPlayer, rewardItem.name, rewardItem.quantity) then
            notify(src, 'Nao tens espaco suficiente no inventario.')
            return
        end
    end

    for _, requiredItem in ipairs(recipe.itemsrequeridos or {}) do
        xPlayer.removeInventoryItem(requiredItem.name, requiredItem.quantity)
    end

    for _, rewardItem in ipairs(recipe.itemsrecebidos or {}) do
        xPlayer.addInventoryItem(rewardItem.name, rewardItem.quantity)
        notify(src, ('Recebeste ~g~%sx %s~s~!'):format(rewardItem.quantity, rewardItem.label or rewardItem.name))
    end
end)

RegisterNetEvent('reciclagem:recompensaVasculhar', function()
    local src = source
    local xPlayer = getPlayer(src)

    if not xPlayer then
        return
    end

    local now = GetGameTimer()
    local nextSearch = searchCooldowns[src] or 0

    if now < nextSearch then
        notify(src, 'Aguarda um pouco antes de vasculhar outra vez.')
        return
    end

    searchCooldowns[src] = now + 4500

    -- 50% de chance de não receber nada
    if math.random(1, 100) > 50 then
        notify(src, 'Não encontraste nada neste caixote.')
        return
    end

    -- Quantidade de sacos do lixo (1 a 5)
    local quantity = math.random(1, 5)

    giveItem(xPlayer, src, 'sacolixo', 'Saco do Lixo', quantity)

    notify(src, ('Encontraste ~g~%sx Saco do Lixo~s~.'):format(quantity))
end)

RPC.register("reciclagem:removerSacosLixo", function()
    local source <const> = source
    local xPlayer = getPlayer(source)
    if not xPlayer then
        return
    end

    if not ESX.playerInsideLocation(source, recicle, 100.0) then
        return
    end

    local itemName = 'sacolixo'
    local quantity = 1

    if getItemCount(xPlayer, itemName) < quantity then
        notify(source, 'Nao tens sacos de lixo suficientes.')
        return
    end

    xPlayer.removeInventoryItem(itemName, quantity)

end)


RPC.register('reciclagem:recompensaSacosLixo', function()
    local source <const> = source
    local xPlayer = getPlayer(source)
    if not xPlayer then return end

    local availableItems = {}
    for _, item in ipairs(trashRewards) do
        if math.random(1, 100) <= item.chance then
            availableItems[#availableItems + 1] = item
        end
    end

    if #availableItems == 0 then
        return
    end

    local rewardsToGive = math.random(2, 4)

    for _ = 1, rewardsToGive do
        if #availableItems == 0 then break end
        local index = math.random(1, #availableItems)
        local reward = table.remove(availableItems, index)
        local quantity = math.random(reward.min, reward.max) * 2 -- Double reward for placing bags

        if not giveItem(xPlayer, source, reward.name, reward.label, quantity) then
            break
        end
    end
end)

CreateThread(function()
    while ESX == nil do
        Wait(100)
    end

    ESX.RegisterServerCallback('reciclagem:temQuantidadeItem', function(source, cb, itemName, quantity)
        local xPlayer = getPlayer(source)
        if not xPlayer then
            cb(false)
            return
        end

        itemName = tostring(itemName or '')
        quantity = tonumber(quantity) or 0

        if itemName == '' or quantity <= 0 then
            cb(false)
            return
        end

        cb(getItemCount(xPlayer, itemName) >= quantity)
    end)
end)

AddEventHandler('playerDropped', function()
    searchCooldowns[source] = nil
end)
