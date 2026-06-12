RegisterServerEvent('mythic_hospital:server:AttemptHiddenRevive')
AddEventHandler('mythic_hospital:server:AttemptHiddenRevive', function()
    local src = source
    math.randomseed(os.time())
    local luck = math.random(100) < Config.HiddenRevChance

    local totalBill = CalculateBill(GetCharsInjuries(src), Config.HiddenInjuryBase)
    
    if BillPlayer(src, totalBill) then
        if luck then
            TriggerClientEvent('okokNotify:Alert', src, 'Informação', 'Recebeste tratamento e já te sentes melhor.', 5000, 'info')
        else
            TriggerClientEvent('okokNotify:Alert', src, 'Informação', 'Recebeste tratamento mas certas coisas não correram como planeado.', 10000, 'info')
        end
        RecentlyUsedHidden[source] = os.time() + 180000
        TriggerClientEvent('mythic_hospital:client:FinishServices', src, true, luck)
    else
        TriggerClientEvent('okokNotify:Alert', src, 'Informação', 'Só falo com o dinheiro em mão...', 5000, 'info')
        TriggerClientEvent('mythic_hospital:client:NoCash', src)
    end
end)