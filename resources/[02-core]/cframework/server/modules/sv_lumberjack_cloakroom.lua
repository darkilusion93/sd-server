
local cloakRoomLocation <const> = {
    vector3(-552.73, 5348.56, 74.74),
    vector3(-841.12, 5401.33, 34.62),
}

RegisterNetEvent('cframework:enterLumberjackService', function()
    local source <const> = source

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Service not lumberjack', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway lumberjack Service', nil, false) 
        return
    end

    ESX.setService(source, true)
end)

RegisterNetEvent('cframework:exitLumberjackService', function()
    local source <const> = source

    if ESX.getJob(source).name ~= 'lumberjack' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Service not lumberjack', nil, false) 
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Faraway Miner Service', nil, false) 
        return
    end

    ESX.setService(source, false)
end)