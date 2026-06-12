ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('megafone', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        TriggerClientEvent('megaphone:use', source)
    end
end)

RegisterNetEvent('megaphone:applySubmix', function(bool)
    TriggerClientEvent('megaphone:updateSubmixStatus', -1, bool, source)
end)


