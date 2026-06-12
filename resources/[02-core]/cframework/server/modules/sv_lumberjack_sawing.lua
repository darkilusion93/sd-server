

local sawingLocation = {
    vector3(-494.37, 5289.57, 79.61),
}

RegisterNetEvent("cframework:lumberjackSawing", function(type)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Washing not lumberjack', nil, false)
        return
    end

    if not ESX.playerInsideLocation(source, sawingLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Washer', nil, false) 
        return
    end

    if not ESX.passedCooldown(source, 700) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Fast Washer', nil, false) 
        return
    end

    if not ESX.inService(source) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : No Service Washer', nil, false) 
        return
    end

    if type == 'cerejeira' then
        if not inventory.canRemoveItem('wood_log_cherry', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wet_wood_plank_cherry', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Cerejeira.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wood_dust', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Serradura.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wood_log_cherry', 1)
        inventory.addItem('wet_wood_plank_cherry', 1)
        inventory.addItem('wood_dust', 1)
        return true
    end

    if type == 'carvalho' then
        if not inventory.canRemoveItem('wood_log_oak', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wet_wood_plank_oak', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Carvalho.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wood_dust', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Serradura.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wood_log_oak', 1)
        inventory.addItem('wet_wood_plank_oak', 1)
        inventory.addItem('wood_dust', 1)
        return true
    end

    if type == 'pinho' then
        if not inventory.canRemoveItem('wood_log_pine', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wet_wood_plank_pine', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Pinho.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wood_dust', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Serradura.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        inventory.removeItem('wood_log_pine', 1)
        inventory.addItem('wet_wood_plank_pine', 1)
        inventory.addItem('wood_dust', 1)
        return true
    end

    if type == 'ebano' then
        if not inventory.canRemoveItem('wood_log_ebony', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wet_wood_plank_ebony', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Ébano.', 'error')
            TriggerClientEvent("lumberjackFail", source)
            return false
        end

        if not inventory.canAddItem('wood_dust', 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Serradura.', 'error')
            TriggerClientEvent("lumberjackFail", source)
           return false
        end

        inventory.removeItem('wood_log_ebony', 1)
        inventory.addItem('wet_wood_plank_ebony', 1)
        inventory.addItem('wood_dust', 1)
        return true
    end
end)