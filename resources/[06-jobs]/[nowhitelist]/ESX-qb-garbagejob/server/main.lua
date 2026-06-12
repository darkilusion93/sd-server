ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('qb-garbagejob:server:HasMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getAccount('bank').money >= Config.BailPrice then
        xPlayer.removeAccountMoney('bank', Config.BailPrice)
        cb(true)
    else
        cb(false)
    end
end)



local UsouPen = {}

local JobReward = {
    garbage   = { item = "sucata",            label = "de Sucata" },
    seguranca = { item = "dinheirobanco",     label = "Malas Seguras" },
    gopostal  = { item = "encomendaespecial", label = "Encomendas Especiais" },
    trucker   = { item = "caixa_medi",        label = "Químicos" },
}

RegisterServerEvent('qb-garbagejob:server:PayShitpt')
AddEventHandler('qb-garbagejob:server:PayShitpt', function(terminado)
    -- FIX C7 (2026-06-12): `Earnings` deixou de vir do cliente (dava dinheiro
    -- infinito) e o branch `else` que pagava sem requisitos foi removido.
    -- Pagamento e itens são SERVER-SIDE e só com pen usada + job certo + pendrive.
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    local playerID = xPlayer.identifier

    if not terminado then
        UsouPen[playerID] = false
        return
    end
    if UsouPen[playerID] ~= 1 then return end

    local reward = JobReward[xPlayer.job.name]
    if not reward then return end

    local pen = xPlayer.getInventoryItem("pendrive")
    if not pen or pen.count < 1 then return end

    local itemrandom = math.random(1, 5)
    local earnings = itemrandom * (Config.PayPerItem or 150)

    xPlayer.addInventoryItem(reward.item, itemrandom)
    xPlayer.removeInventoryItem("pendrive", 1)
    xPlayer.addAccountMoney('bank', earnings)
    UsouPen[playerID] = 0

    TriggerClientEvent('okokNotify:Alert', src, "TRABALHO", 'Recebeste x'..itemrandom..' '..reward.label..' e '..earnings..'€', 5000, 'success')
end)

RegisterServerEvent('esx_pens:usou')
AddEventHandler('esx_pens:usou', function(identifier, source)
    local xPlayer = ESX.GetPlayerFromId(source) 
    if xPlayer then
        if xPlayer.job.name == 'gopostal' then
            UsouPen[identifier] = 1
        elseif xPlayer.job.name == 'garbage' then
            UsouPen[identifier] = 1
        elseif xPlayer.job.name == 'seguranca' then
            UsouPen[identifier] = 1
        elseif xPlayer.job.name == 'trucker' then
            UsouPen[identifier] = 1
            TriggerClientEvent('esx:job-blackmode3', source, true)
        end
    else
        --print('putas')
    end
end)
