local cloakRoomLocation = {
    vector3(707.12, -966.53, 30.41),
    vector3(405.59, 6526.21, 27.70),
}

local cottonLocation = {
    vector3(364.67, 6462.29, 30.24),
    vector3(364.87, 6464.12, 30.20),
    vector3(364.85, 6466.77, 30.14),
    vector3(365.10, 6469.88, 30.00),
    vector3(364.91, 6475.91, 29.63),
    vector3(365.05, 6478.03, 29.52),
    vector3(364.87, 6481.89, 29.20),
    vector3(357.79, 6483.20, 29.11),
    vector3(357.70, 6480.34, 29.32),
    vector3(357.89, 6477.77, 29.47),
    vector3(357.66, 6472.39, 29.83),
    vector3(357.64, 6467.36, 30.12),
    vector3(357.96, 6464.54, 30.22),
}

local cottonProccess = {
    vector3(713.87, -959.94, 30.4),
    vector3(716.77, -960.09, 30.4),
    vector3(718.75, -960.00, 30.4),
    vector3(718.87, -962.44, 30.4),
    vector3(716.49, -962.46, 30.4),
    vector3(714.88, -967.59, 30.4),
    vector3(714.98, -969.66, 30.4),
    vector3(714.91, -971.79, 30.4),
}

local sellLocation = {
  --  vector3(89.73, -1592.95, 29.89),
}

RegisterNetEvent('cframework:enterCostureiroService', function()
    local source = source

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Service not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Service', nil, false) 
        return
    end

    ESX.setService(source, true)
end)

RegisterNetEvent('cframework:exitCostureiroService', function()
    local source = source

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Service not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Service', nil, false) 
        return
    end

    ESX.setService(source, false)
end)

RegisterNetEvent("cframework:getHarvestedItem", function(item)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Mining not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cottonLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner', nil, false) 
        return
    end

    if not ESX.passedCooldown(source, 1850) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Fast Miner', nil, false) 
        return
    end

    if not ESX.inService(source) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : No Service Miner', nil, false) 
        return
    end

    --if ESX.getInventoryItem(source, item).count < 1 then TriggerClientEvent('stopMining', source) return end

    if not inventory.addItem('cotton', 1) then TriggerClientEvent('esx:showNotification', source, 'Inventário cheio.', 'error') return end
end)

RegisterNetEvent("cframework:costureiroProcessing", function(type)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Mining not miner', nil, false)
        return
    end

    if not ESX.playerInsideLocation(source, cottonProccess, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner', nil, false)
        return
    end

    if not ESX.passedCooldown(source, 1350) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Fast Miner', nil, false)
        return
    end

    if not ESX.inService(source) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : No Service Miner', nil, false)
        return
    end

    if type == 'fabric' then
        if not inventory.canRemoveItem("cotton", 2) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent('costureiroFail', source)
            return false
        end

        if not inventory.canAddItem("fabric", 2) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Tecido.', 'error')
            TriggerClientEvent('costureiroFail', source)
            return false
        end

        inventory.removeItem('cotton', 2)
        inventory.addItem('fabric', 2)
        return true
    end

    if type == 'kevlar' then
        if not inventory.canRemoveItem("fabric", 3) then TriggerClientEvent('esx:showNotification', source, 'Não tens tecido suficiente.', 'error')
            TriggerClientEvent('costureiroFail', source)
            return false
        end

        if not inventory.canRemoveItem("rubber", 3) then TriggerClientEvent('esx:showNotification', source, 'Não tens borracha suficiente.', 'error')
            TriggerClientEvent('costureiroFail', source)
            return false
        end

        if not inventory.canAddItem("kevlar", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Kevlar.', 'error')
            TriggerClientEvent('costureiroFail', source)
            return false
        end

        inventory.removeItem('rubber', 3)
        inventory.removeItem('fabric', 3)
        inventory.addItem('kevlar', 1)
        return true
    end
end)

RegisterNetEvent("cframework:sellTecido", function()
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemAmount = inventory.getItemAmount('fabric')
    local price = itemAmount * 20

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem("fabric", itemAmount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Tecido suficiente.', 'error')
        return
    end

    if not inventory.canAddItem("cash", price) then TriggerClientEvent('esx:showNotification', source, 'Não tens Tecido suficiente.', 'error')
        return
    end

    inventory.removeItem('fabric', itemAmount)
    inventory.addItem("cash", price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste Tecido.', 'success')
end)

RegisterNetEvent("cframework:sellKevlar", function()
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local itemAmount = inventory.getItemAmount('kevlar')
    local price = itemAmount * 70

    if ESX.getJob(source).name ~= 'costureiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Selling not miner', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, sellLocation, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Selling', nil, false) 
        return
    end

    if not inventory.canRemoveItem("kevlar", itemAmount) then TriggerClientEvent('esx:showNotification', source, 'Não tens Kevlar suficiente.', 'error')
        return
    end

    if not inventory.canAddItem("cash", price) then TriggerClientEvent('esx:showNotification', source, 'Não tens Tecido suficiente.', 'error')
        return
    end

    inventory.removeItem('kevlar', itemAmount)
    inventory.addItem("cash", price)
    TriggerClientEvent('esx:showNotification', source, 'Vendeste Kevlar.', 'success')
end)


RegisterNetEvent("esx_costureiro:giveitem", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Costureiro é para dar tecido... Ofereço-te este ban :D', nil, false)
end)

RegisterNetEvent("gcostureiro:giveKevlar", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Kevlar... Tão bom...', nil, false)
end)

RegisterNetEvent("gcostureiro:giveTecido", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Costureiro é para dar tecido v2...', nil, false)
end)