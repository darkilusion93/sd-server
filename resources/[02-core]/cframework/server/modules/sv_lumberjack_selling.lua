

local sellLocation <const> = {
   -- vector3(87.59, -1601.75, 30.08),
}

RegisterNetEvent("cframework:sellWoodDust", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemCount = inventory.getItemAmount('wood_dust')
    local price = itemCount * 8

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem('wood_dust', itemCount) then TriggerClientEvent('esx:showNotification', source, 'Não tens serradura suficiente.', 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then TriggerClientEvent('esx:showNotification', source, 'Não tens espaço para levar Dinheiro.', 'error')
        return
    end

    inventory.removeItem('wood_dust', itemCount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste '.. itemCount ..' de serradura.', 'success')
end)

RegisterNetEvent("cframework:sellCerejeira", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemCount = inventory.getItemAmount('wood_plank_cherry')
    local price = itemCount * 25

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem('wood_plank_cherry', itemCount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Cerejeira suficiente.', 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then TriggerClientEvent('esx:showNotification', source, 'Não tens espaço para levar Dinheiro.', 'error')
        return
    end

    inventory.removeItem('wood_plank_cherry', itemCount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste '.. itemCount ..' de cerejeira.', 'success')
end)

RegisterNetEvent("cframework:sellCarvalho", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemCount = inventory.getItemAmount('wood_plank_oak')
    local price = itemCount * 20

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem('wood_plank_oak', itemCount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Carvalho suficiente.', 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then TriggerClientEvent('esx:showNotification', source, 'Não tens espaço para levar Dinheiro.', 'error')
        return
    end

    inventory.removeItem('wood_plank_oak', itemCount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste '.. itemCount ..' de carvalho.', 'success')
end)

RegisterNetEvent("cframework:sellPinho", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemCount = inventory.getItemAmount('wood_plank_pine')
    local price = itemCount * 15

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem('wood_plank_pine', itemCount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Pinho suficiente.', 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then TriggerClientEvent('esx:showNotification', source, 'Não tens espaço para levar Dinheiro.', 'error')
        return
    end

    inventory.removeItem('wood_plank_pine', itemCount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste '.. itemCount ..' de pinho.', 'success')
end)

RegisterNetEvent("cframework:sellEbano", function(rare)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemCount = inventory.getItemAmount('wood_plank_ebony')
    local price = itemCount * 70

    if rare then
        price = item.count * 100
    end

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem('wood_plank_ebony', itemCount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Ébano suficiente.', 'error')
        return
    end

    if not inventory.canAddItem('cash', price) then TriggerClientEvent('esx:showNotification', source, 'Não tens espaço para levar Dinheiro.', 'error')
        return
    end

    inventory.removeItem('wood_plank_ebony', itemCount)
    inventory.addItem('cash', price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste '.. itemCount ..' de ébano.', 'success')
end)