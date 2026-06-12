local ESX = nil
local login = false
local PlayerData = {}
local dentro = false
local popupativo = false
local popupativo2 = false
local estadochamada = false
local owner = 0
local cambiopin = false
local selfblock = {}
local garagem_entrada = false
local tentativa = 0
local id_armazem = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

MySQL.ready(function()
    local source = source
    if ESX ~= nil then
        ESX.RegisterServerCallback('armazem:checkOwnership', function(source, cb)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then
                return cb(false)
            end
            local identifier = xPlayer.identifier
            local result = MySQL.Sync.fetchScalar('SELECT owner FROM armazem_ownership WHERE owner = @owner', {
                ['@owner'] = identifier
            })
            cb(result ~= nil)
        end)

        ESX.RegisterServerCallback('armazem:buyArmazem', function(source, cb)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then
                return cb(false, 'Erro ao obter informações do jogador.')
            end
            local identifier = xPlayer.identifier
            

            MySQL.Async.fetchScalar('SELECT owner FROM armazem_ownership WHERE owner = @owner', {
                ['@owner'] = identifier
            }, function(result)
                if result ~= nil then
                    cb(false, 'Já possuis um armazém.')
                else
                    local price = 400000
                    if xPlayer.getMoney() >= price then
                        xPlayer.removeMoney(price)
                        MySQL.Async.execute('INSERT INTO armazem_ownership (owner) VALUES (@owner)', {
                            ['@owner'] = identifier
                        }, function(rowsAffected)
                            if rowsAffected > 0 then
                                TriggerClientEvent('armazem:updateOwnership', source, true)
                                cb(true, 'Armazém comprado com sucesso.')
                            else
                                cb(false, 'Erro ao comprar o armazém.')
                            end
                        end)
                    else
                        cb(false, 'Dinheiro insuficiente para comprar um armazém.')
                    end
                end
            end)
        end)

        ESX.RegisterServerCallback('armazem:getArmazemData', function(source, cb)
            local xPlayer = ESX.GetPlayerFromId(source)
            if not xPlayer then
                return cb(nil)
            end
            local identifier = xPlayer.identifier

            MySQL.Async.fetchAll('SELECT * FROM armazem_ownership WHERE owner = @owner', {
                ['@owner'] = identifier
            }, function(result)
                if result[1] ~= nil then
                    cb(result[1])
                else
                    cb(nil)
                end
            end)
        end)
    end
end)
-- FIX C17 (2026-06-12): o armazém acedido é SEMPRE o do próprio jogador
-- (owner = identifier do source), não um `owner` arbitrário do cliente.
-- Guarda-se o bucket permitido para validar o setdimension.
local allowedBucket = {}

RegisterNetEvent("armazem:check")
AddEventHandler("armazem:check", function(owner,pin)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll('SELECT * FROM armazem_ownership WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(result)
        if result[1] ~= nil then
            if result[1].pin == tostring(pin) then
                allowedBucket[source] = tonumber(result[1].id)
                TriggerClientEvent('armazem:resultado', source, 'spawn', identifier, result[1].id)
            else
                TriggerClientEvent('esx:showNotification', source, 'PIN incorreto.')
            end
        end
    end)
end)


local PIN1 = '0000'
RegisterNetEvent('armazem:comprar')
AddEventHandler('armazem:comprar', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return
    end

    local identifier = xPlayer.identifier
    local price = 400000

MySQL.Async.fetchScalar('SELECT owner FROM armazem_ownership WHERE owner = @owner', {
    ['@owner'] = identifier
}, function(result)

        if result ~= nil then
            TriggerClientEvent('chat:addMessage', { args = { 'Erro:', 'Você já possui um armazém.' } })
        else
            if xPlayer.getMoney() >= price then
                xPlayer.removeMoney(price)
                MySQL.Async.execute('INSERT INTO armazem_ownership (owner,pin) VALUES (@owner,@pin)', {
                    ['@owner'] = identifier,
                    ['@pin'] = PIN1
                }, function(rowsAffected)
                    if rowsAffected > 0 then
                        TriggerClientEvent('armazem:resultado', source, 'comprado', PIN1)
                    else
                        TriggerClientEvent('chat:addMessage', { args = { 'Erro:', 'Erro ao comprar o armazém.' } })
                    end
                end)
            else
                TriggerClientEvent('chat:addMessage', { args = { 'Erro:', 'Dinheiro insuficiente para comprar um armazém.' } })
            end
        end
    end)
end)

RegisterNetEvent("armazem:alterarpin")
AddEventHandler("armazem:alterarpin", function(owner,pin)
    local source = source
    -- FIX C16 (2026-06-12): só podes mudar o PIN do TEU armazém (owner=identifier
    -- do source), não de um owner arbitrário do cliente.
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if type(pin) ~= 'string' and type(pin) ~= 'number' then return end
    pin = tostring(pin)
    if not pin:match('^%d+$') or #pin < 4 or #pin > 8 then return end
    MySQL.Async.execute('UPDATE armazem_ownership SET pin=@pin WHERE owner = @owner',
    {
        ['@pin'] = pin,
        ['@owner'] = xPlayer.identifier,
    },
    function(rowsAffected)
        if rowsAffected > 0 then
            TriggerClientEvent('armazem:notificacao', source, pin)
        end
    end)
end)


Citizen.CreateThread(function()
    while true do
        local playerTable = GetPlayers()

        MySQL.Async.fetchAll('SELECT * FROM armazem_ownership', {}, function(result)
            if result then
                for _, playerId in ipairs(playerTable) do
                    local xPlayer = ESX.GetPlayerFromId(playerId)
                    if xPlayer then
                        local identifier = xPlayer.identifier
                        for _, row in ipairs(result) do
                            if row.owner == identifier then
                                TriggerClientEvent('armazem:resultado', playerId, 'reload', row.owner)
                            end
                        end
                    end
                end
            end
        end)

        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('armazem:setdimension')
AddEventHandler('armazem:setdimension', function(dimension)
    -- FIX (2026-06-12): só permite o bucket 0 (mundo) ou o do armazém do
    -- próprio jogador (validado no armazem:check). Antes aceitava qualquer
    -- dimensão → ghost para a storage instanciada de outros.
    dimension = tonumber(dimension)
    if dimension == nil then return end
    if dimension ~= 0 and dimension ~= allowedBucket[source] then return end
    SetPlayerRoutingBucket(source, dimension)
end)

AddEventHandler('playerDropped', function()
    allowedBucket[source] = nil
end)


if Config.AtivarComandoDimensao then
    RegisterCommand('verdimensao', function(source, args, rawCommand)
        local player = tonumber(args[1])
        if player then
            local dimension = GetPlayerRoutingBucket(player)
            TriggerClientEvent('esx:showNotification', source, 'Estas na dimensão: ' .. dimension)
        else
            TriggerClientEvent('chatMessage', source, "^1ERRO^7: Use /verdimensao [ID do jogador]")
        end
    end, false)
end
