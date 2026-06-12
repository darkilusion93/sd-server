

local dryingLocation <const> = {
    vector3(-554.16, 5325.24, 72.60),
}

RegisterNetEvent("cframework:lumberjackDrying", function(type)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Remelting not lumberjack', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, dryingLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Remelting', nil, false) 
        return
    end

    if not ESX.passedCooldown(source, 1100) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Fast Remelter', nil, false) 
        return
    end

    if not ESX.inService(source) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : No Service Remelter', nil, false) 
        return
    end

    if type == 'cerejeira' then
        if not inventory.canRemoveItem("wet_wood_plank_cherry", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem("wood_plank_cherry", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Cerejeira.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wet_wood_plank_cherry', 1)
        inventory.addItem('wood_plank_cherry', 1)
        return true
    end

    if type == 'carvalho' then
        if not inventory.canRemoveItem("wet_wood_plank_oak", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem("wood_plank_oak", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Carvalho.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wet_wood_plank_oak', 1)
        inventory.addItem('wood_plank_oak', 1)
        return true
    end

    if type == 'pinho' then
        if not inventory.canRemoveItem("wet_wood_plank_pine", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem("wood_plank_pine", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Pinho.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wet_wood_plank_pine', 1)
        inventory.addItem('wood_plank_pine', 1)
        return true
    end

    if type == 'ebano' then
        if not inventory.canRemoveItem("wet_wood_plank_ebony", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem("wood_plank_ebony", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Ébano.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wet_wood_plank_ebony', 1)
        inventory.addItem('wood_plank_ebony', 1)
        return true
    end
end)