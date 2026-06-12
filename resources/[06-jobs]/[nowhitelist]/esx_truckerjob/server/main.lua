ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_truckerjob:pay')
AddEventHandler('esx_truckerjob:pay', function(payment)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    -- FIX (2026-06-12): além de >0, exige job de trucker e um teto por entrega
    -- (antes pagava qualquer valor do cliente, ex: 999999999).
    if xPlayer.job.name ~= 'trucker' then return end
    payment = math.floor(tonumber(payment) or 0)
    if payment <= 0 or payment > 25000 then return end
    xPlayer.addMoney(payment)
end)

ESX.RegisterServerCallback('esx_truckerjob:hasMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bailPrice = 5000 -- Valor fixo da caução

    if xPlayer.getAccount('bank').money >= bailPrice then
        xPlayer.removeAccountMoney('bank', bailPrice)
        cb(true)
    elseif xPlayer.getMoney() >= bailPrice then
        xPlayer.removeMoney(bailPrice)
        cb(true)
    else
        cb(false)
    end
end)
