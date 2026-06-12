ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local BAIL_AMOUNT = 5000
local MAX_ROUTE_EARNINGS = 100000 -- teto de segurança anti-exploit
local bailPaid = {} -- FIX (2026-06-12): só devolve caução a quem a pagou

-- ─── TERMINAR ROTA COM SUCESSO (recebe pagamento) ────────────────────────────
RegisterNetEvent('blarglebus:finishRoute')
AddEventHandler('blarglebus:finishRoute', function(amount, busUndamaged)
    local _source = source
    local safeAmount = tonumber(amount) or 0
    if safeAmount < 0 then safeAmount = 0 end
    if safeAmount > MAX_ROUTE_EARNINGS then safeAmount = MAX_ROUTE_EARNINGS end

    updateMoney(_source, function(player)
        -- Pagar o ganho da rota
        player.addMoney(safeAmount)

        -- Devolver caução se o autocarro não estiver danificado E tiver sido paga
        if busUndamaged and bailPaid[_source] then
            bailPaid[_source] = nil
            player.addMoney(BAIL_AMOUNT)
            TriggerClientEvent('esx:showNotification', _source,
                '~g~Rota concluída! Recebeste ~y~€' .. safeAmount ..
                '~g~ + caução de ~y~€' .. BAIL_AMOUNT .. '~g~ devolvida (autocarro sem danos).')
        else
            TriggerClientEvent('esx:showNotification', _source,
                '~g~Rota concluída! Recebeste ~y~€' .. safeAmount ..
                '~r~ — caução retida (autocarro com danos).')
        end
    end)
end)

-- ─── CANCELAR ROTA (perde o que ganhou, caução devolvida) ────────────────────
RegisterNetEvent('blarglebus:abortRoute')
AddEventHandler('blarglebus:abortRoute', function(amount)
    local _source = source
    local safeAmount = tonumber(amount) or 0
    if safeAmount < 0 then safeAmount = 0 end
    if safeAmount > MAX_ROUTE_EARNINGS then safeAmount = MAX_ROUTE_EARNINGS end

    updateMoney(_source, function(player)
        -- Perde o dinheiro ganho durante a rota (se houver)
        if safeAmount > 0 then
            local cash = player.getMoney()
            local toRemove = math.min(safeAmount, cash)
            if toRemove > 0 then
                player.removeMoney(toRemove)
            end
        end
        TriggerClientEvent('esx:showNotification', _source,
            '~r~Rota cancelada. Perdeste ~y~€' .. safeAmount .. '~r~ ganhos nesta rota.')
    end)
end)

-- ─── DEVOLVER CAUÇÃO (só no abort/kick, não no finish) ───────────────────────
RegisterNetEvent('blarglebus:refundBail')
AddEventHandler('blarglebus:refundBail', function()
    local _source = source
    -- só devolve se realmente pagou caução (senão era +5000€ por chamada)
    if not bailPaid[_source] then return end
    bailPaid[_source] = nil
    updateMoney(_source, function(player)
        player.addMoney(BAIL_AMOUNT)
        TriggerClientEvent('esx:showNotification', _source,
            '~g~Caução de ~y~€' .. BAIL_AMOUNT .. '~g~ devolvida.')
    end)
end)

-- ─── PAGAR CAUÇÃO (ao iniciar rota) ─────────────────────────────────────────
ESX.RegisterServerCallback('blarglebus:payBail', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer == nil then cb(false) return end

    -- Tenta tirar do banco primeiro, depois do cash
    if xPlayer.getAccount('bank').money >= BAIL_AMOUNT then
        xPlayer.removeAccountMoney('bank', BAIL_AMOUNT)
        bailPaid[source] = true
        TriggerClientEvent('esx:showNotification', source,
            '~y~€' .. BAIL_AMOUNT .. '~s~ de caução debitados do banco.')
        cb(true)
    elseif xPlayer.getMoney() >= BAIL_AMOUNT then
        xPlayer.removeMoney(BAIL_AMOUNT)
        bailPaid[source] = true
        TriggerClientEvent('esx:showNotification', source,
            '~y~€' .. BAIL_AMOUNT .. '~s~ de caução debitados do cash.')
        cb(true)
    else
        cb(false)
    end
end)

-- ─── UTILITÁRIO: verificar job e executar ação ───────────────────────────────
function updateMoney(_source, updateMoneyCallback)
    local player = ESX.GetPlayerFromId(_source)
    if player == nil then return end

    if player.job.name ~= 'busdriver' then
        print('[blarglebus] Exploit tentado por: ' .. tostring(player.identifier))
        player.kick('Expulso por tentativa de exploit.')
        return
    end

    updateMoneyCallback(player)
end