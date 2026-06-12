

local cuttingLocations <const> = {
    vector3(-701.96, 5462.54, 44.56),
    vector3(-704.70, 5486.26, 44.90),
    vector3(-699.25, 5489.37, 45.60),
    vector3(-677.08, 5488.14, 48.89),
    vector3(-667.44, 5496.61, 48.06),
    vector3(-663.53, 5494.77, 48.84),
    vector3(-660.53, 5490.35, 49.67),
    vector3(-664.24, 5463.02, 51.06),
    vector3(-652.31, 5455.47, 51.79),
    vector3(-643.06, 5461.82, 53.24),
    vector3(-638.76, 5503.00, 51.32),
    vector3(-649.63, 5510.29, 48.91),
    vector3(-633.14, 5505.52, 51.27),
    vector3(-619.50, 5498.73, 51.24),
    vector3(-604.23, 5500.94, 51.67),
    vector3(-586.61, 5509.86, 52.50),
}

RegisterNetEvent("cframework:getCuttedItem", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local luck <const> = math.random(1,100)
    local item = 'none'

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Mining not lumberjack', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cuttingLocations, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner', nil, false) 
        return
    end

    if not ESX.passedCooldown(source, 850) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Fast Miner', nil, false) 
        return
    end

    if not ESX.inService(source) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : No Service Miner', nil, false) 
        return
    end

    if inventory.getItemAmount("chainsaw") >= 1 then
        item = 'chainsaw'
    elseif inventory.getItemAmount("axe") >= 1 then
        item = 'axe'
    end

    if item == 'none' then TriggerClientEvent('lumberjackFail', source) return end


    if luck < 50 and luck >= 0 and inventory.canAddItem('wood_log_pine', 1) then
        inventory.addItem('wood_log_pine', 1)
    elseif luck < 80 and luck >= 50 and inventory.canAddItem('wood_log_oak', 1) then
        inventory.addItem('wood_log_oak', 1)
    elseif luck < 95 and luck >= 80 and inventory.canAddItem('wood_log_cherry', 1) then
        inventory.addItem('wood_log_cherry', 1)
    elseif luck <= 100 and luck >= 95 and inventory.canAddItem('wood_log_ebony', 1) then
        inventory.addItem('wood_log_ebony', 1)
    else
        TriggerClientEvent('esx:showNotification', source, 'Inventário cheio.', 'error')
    end
end)

RPC.register("getCuttingTool", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if inventory.getItemAmount("chainsaw") >= 1 then
        return 'chainsaw'
    elseif inventory.getItemAmount("axe") >= 1 then
        return 'axe'
    else
        return 'none'
    end
end)