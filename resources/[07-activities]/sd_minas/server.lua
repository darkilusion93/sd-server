local ESX = exports['cframework']:getSharedObject()

-- Variáveis de controlo
local playerMiningStatus = {}

local BlipsMinerar = {
    vector3(2948.993, 2817.89, 42.43056),
    vector3(2944.238, 2816.472, 42.64713),
    vector3(2951.146, 2770.701, 38.99),
    vector3(2934.948, 2784.931, 39.55),
    vector3(2922.827, 2798.708, 41.196),
    vector3(2937.274, 2812.215, 42.85),
    vector3(2957.973, 2819.992, 42.672),
    vector3(2938.123, 2775.371, 39.223),
    vector3(2970.358, 2776.561, 38.367),
    vector3(2977.479, 2790.77, 40.545)
}

RegisterNetEvent('sd_minas:iniciarMineracao')
AddEventHandler('sd_minas:iniciarMineracao', function()
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local inventory <const> = ESX.getInvContainer(playerId)

    if not xPlayer then return end

    if not ESX.playerInsideLocation(source, BlipsMinerar, 10.0) then
        return
    end

    -- Verifica se tem a britadeira
    local hasBritadeira = inventory.getItemAmount(Config.ItemBritadeira)
    if hasBritadeira == 0  then
        TriggerClientEvent('esx:showNotification', playerId, 'Não tens nenhuma ' .. ESX.GetItemLabel(Config.ItemBritadeira) .. '!', 'error')
        TriggerClientEvent('sd_minas:acabarMinar', playerId)
        return
    end

    -- Verifica se tem a broca
    local hasBroca = inventory.getItemAmount(Config.ItemBroca)
    if hasBroca == 0 then
        TriggerClientEvent('esx:showNotification', playerId, 'Não tens nenhuma ' .. ESX.GetItemLabel(Config.ItemBroca) .. ' para a britadeira!', 'error')
        TriggerClientEvent('sd_minas:acabarMinar', playerId)
        return
    end

    -- Processa o sistema de avarias
    local quebrouAlgo = false
    
    -- Verifica quebra da britadeira
    if math.random(1, 100) <= Config.Avaria.Britadeira then
        if not inventory.canRemoveItem(Config.ItemBritadeira, 1) then
            return
        end
        inventory.removeItem(Config.ItemBritadeira, 1)
        TriggerClientEvent('esx:showNotification', playerId, 'A tua britadeira partiu-se!', 'error')
        quebrouAlgo = true
    end

    -- Verifica quebra da broca
    if not quebrouAlgo and math.random(1, 100) <= Config.Avaria.Broca then
        if not inventory.canRemoveItem(Config.ItemBroca, 1) then
            return
        end
        inventory.removeItem(Config.ItemBroca, 1)
        TriggerClientEvent('esx:showNotification', playerId, 'A tua broca partiu-se!', 'error')
        quebrouAlgo = true
    end

    if quebrouAlgo then
        TriggerClientEvent('sd_minas:acabarMinar', playerId)
        return
    end

    -- Processa as recompensas baseadas na probabilidade de cada item
    local recebeuAlgo = false
    
    for i=1, #Config.ItemMinerar do
        local mineral = Config.ItemMinerar[i]
        if math.random(1, 100) <= mineral.chance then
            local quantidade = math.random(mineral.min, mineral.max)
            if not inventory.canAddItem(mineral.item, quantidade) then
                TriggerClientEvent('esx:showNotification', playerId, 'Não tens espaço suficiente para ' .. quantidade .. 'x ' .. ESX.GetItemLabel(mineral.item) .. '.', 'error')
                return
            end
            inventory.addItem(mineral.item, quantidade)
            TriggerClientEvent('esx:showNotification', playerId, 'Mineraste ' .. quantidade .. 'x ' .. ESX.GetItemLabel(mineral.item), 'success')
            recebeuAlgo = true
        end
    end
    
    if not recebeuAlgo then
        TriggerClientEvent('esx:showNotification', playerId, 'Não encontraste nada de útil desta vez...', 'inform')
    end
end)

RegisterNetEvent('sd_minas:pararEntrega')
AddEventHandler('sd_minas:pararEntrega', function()
    local playerId = source
    playerMiningStatus[playerId] = false
end)
