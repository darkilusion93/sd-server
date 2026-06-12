

local rubberData = LoadRubber()
local cloakRoomLocation <const> = rubberData.cloakRoomLocation

RegisterNetEvent('cframework:enterRubberService', function()
    local source <const> = source

    if ESX.getJob(source).name ~= 'rubber' then
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then
        return
    end

    ESX.setService(source, true)
end)

RegisterNetEvent('cframework:exitRubberService', function()
    local source <const> = source

    if ESX.getJob(source).name ~= 'rubber' then
        return
    end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then
        return
    end

    ESX.setService(source, false)
end)

--Anti Cheat Stuff
RegisterNetEvent("gborracheiro:giveLatex", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Bebes latex ao pequeno almoço?', nil, false)
end)

RegisterNetEvent("gborracheiro:giveBorracha", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Borracha... Tão bom...', nil, false)
end)

RegisterNetEvent("esx_borracheiro:giveitem", function(item)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Toda uma panóplia de items...', nil, false)
end)