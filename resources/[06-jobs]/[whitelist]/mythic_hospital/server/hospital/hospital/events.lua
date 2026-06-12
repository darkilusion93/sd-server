--HOSPITAL CIDADE--
local beds = {
    {x = -1862.66, y = -334.290, z = 50.188, h=135.99},
    {x = -1865.72, y = -332.080, z = 50.194, h=144.34},
    {x = -1868.64, y = -329.891, z = 50.188, h = 139.44},
    {x = -1872.13, y = -327.016, z = 50.188, h = 131.97},
    {x = -1875.27, y = -324.681, z = 50.188, h = 133.6},   
    {x = -1878.53, y = -322.095, z = 50.188, h = 138.88},   
    {x = -1875.13, y = -318.064, z = 50.188, h = 320.89},   
    {x = -1871.88, y = -320.566, z = 50.188, h = 312.08},   
    {x = -1868.77, y = -323.083, z = 50.188, h = 319.41},   
}

local bedsTaken = {}

AddEventHandler('playerDropped', function()
    if bedsTaken[source] ~= nil then
        beds[bedsTaken[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed')
AddEventHandler('mythic_hospital:server:RequestBed', function(dead)
    local source = source
    local totalBill = CalculateBill(GetCharsInjuries(source), Config.InjuryBase)

    if not dead then
        if BillPlayer(source, totalBill) then
            for k, v in pairs(beds) do
                if not v.taken then
                    v.taken = true
                    bedsTaken[source] = k
                    TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
                    return
                end
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, 'Erro', 'Não tens dinheiro suficiente. ['.. totalBill ..']', 5000, 'error')
            return
        end
    else
        for k, v in pairs(beds) do
            if not v.taken then
                v.taken = true
                bedsTaken[source] = k
                TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
                return
            end
        end
    end
    TriggerClientEvent('okokNotify:Alert', source, 'Erro', 'Não existem macas disponíveis', 5000, 'error')
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed')
AddEventHandler('mythic_hospital:server:RPRequestBed', function(plyCoords)
    local src = source
    local foundbed = false
    for k, v in pairs(beds) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 50.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', src, k, v)
                return
            else
                TriggerClientEvent('okokNotify:Alert', src, 'Erro', 'Maca ocupada.', 5000, 'error')
            end
        end
    end

    if not foundbed then
        TriggerClientEvent('okokNotify:Alert', src, 'Erro', 'Nenhuma maca por perto.', 5000, 'error')
    end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local totalBill = CalculateBill(GetCharsInjuries(src), Config.InjuryBase)

    TriggerClientEvent('okokNotify:Alert', src, 'Informação', 'Recebeste tratamento e já te sentes melhor.', 5000, 'info')
    TriggerClientEvent('mythic_hospital:client:FinishServices', src, false, true)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    beds[id].taken = false
end)

--HOSPITAL NORTE

local bedsNORTE = {   
    {x = -265.962, y = 6319.705, z = 33.302, h = 43.47},   
    {x = -267.947, y = 6317.827, z = 33.302, h= 39.64},
    {x = -260.266, y = 6319.306, z = 33.302, h = 221.06},
    {x = -261.900, y = 6317.674, z = 33.302, h = 220.98},
}

local bedsTakenNORTE = {}

AddEventHandler('playerDropped', function()
    if bedsTakenNORTE[source] ~= nil then
        bedsNORTE[bedsTakenNORTE[source]].taken = false
    end
end)

RegisterServerEvent('mythic_hospital:server:RequestBed2')
AddEventHandler('mythic_hospital:server:RequestBed2', function(dead)
    local source = source
    local totalBill = CalculateBill(GetCharsInjuries(source), Config.InjuryBase)

    if not dead then
        if BillPlayer(source, totalBill) then
            for k, v in pairs(bedsNORTE) do
                if not v.taken then
                    v.taken = true
                    bedsTakenNORTE[source] = k
                    TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
                    return
                end
            end
        else
            TriggerClientEvent('okokNotify:Alert', source, 'Erro', 'Não tens dinheiro suficiente. ['.. totalBill ..']', 5000, 'error')
            return
        end
    else
        for k, v in pairs(bedsNORTE) do
            if not v.taken then
                v.taken = true
                bedsTakenNORTE[source] = k
                TriggerClientEvent('mythic_hospital:client:SendToBed', source, k, v)
                return
            end
        end
    end
    TriggerClientEvent('okokNotify:Alert', source, 'Erro', 'Não existem macas disponíveis', 5000, 'error')
end)

RegisterServerEvent('mythic_hospital:server:RPRequestBed2')
AddEventHandler('mythic_hospital:server:RPRequestBed2', function(plyCoords)
    local src = source
    local foundbed = false
    for k, v in pairs(bedsNORTE) do
        local distance = #(vector3(v.x, v.y, v.z) - plyCoords)
        if distance < 50.0 then
            if not v.taken then
                v.taken = true
                foundbed = true
                TriggerClientEvent('mythic_hospital:client:RPSendToBed', src, k, v)
                return
            else
                TriggerClientEvent('okokNotify:Alert', src, 'Erro', 'Maca ocupada.', 5000, 'error')
            end
        end
    end

    if not foundbed then
        TriggerClientEvent('okokNotify:Alert', src, 'Erro', 'Nenhuma maca por perto.', 5000, 'error')
    end
end)

RegisterServerEvent('mythic_hospital:server:EnteredBed')
AddEventHandler('mythic_hospital:server:EnteredBed', function()
    local src = source
    local totalBill = CalculateBill(GetCharsInjuries(src), Config.InjuryBase)

    TriggerClientEvent('okokNotify:Alert', src, 'Informação', 'Recebeste tratamento e já te sentes melhor.', 5000, 'info')
    TriggerClientEvent('mythic_hospital:client:FinishServices', src, false, true)
end)

RegisterServerEvent('mythic_hospital:server:LeaveBed')
AddEventHandler('mythic_hospital:server:LeaveBed', function(id)
    bedsNORTE[id].taken = false
end)