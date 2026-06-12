ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local declarations = {}

-- Auto pendente por cidadão (server-autoritário): coima validada no envio,
-- cobrada ao cidadão só quando ele assina. Mata o `coima` global nil e o
-- relay de multas a alvo arbitrário (impersonar polícia).
local pendingAutos = {}

local AUTHORIZED_JOBS = {
    police = true, sheriff = true, municipal = true, pj = true, siis = true
}

local COIMA_MAX = 50000 -- teto de sanidade para a coima

local function isAuthorized(xPlayer)
    if not xPlayer then return false end
    local job = xPlayer.getJob()
    return job ~= nil and AUTHORIZED_JOBS[job.name] == true
end

RegisterServerEvent('autocontra:novoAV')
AddEventHandler('autocontra:novoAV', function(ocorrenciaNumber)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isAuthorized(xPlayer) then
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sem permissão!' })
        return
    end

    local newAV = {
        agente = xPlayer.getName(),
        codeAV = ocorrenciaNumber,
        data = os.date('%Y-%m-%d %H:%M:%S')
    }

    declarations[ocorrenciaNumber] = newAV
    TriggerClientEvent('autocontra:criar_noti', _source, newAV)
end)

RegisterServerEvent('autocontra:enviarAV')
AddEventHandler('autocontra:enviarAV', function(data, target)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    -- só um agente emite uma AV para um cidadão
    if not isAuthorized(xPlayer) then return end
    local xTarget = ESX.GetPlayerFromId(target)
    if not xTarget then return end
    TriggerClientEvent('autocontra:receberAV', target, data, _source)
end)

RegisterServerEvent('autocontra:procurar_destinoAV')
AddEventHandler('autocontra:procurar_destinoAV', function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isAuthorized(xPlayer) then return end
    local target = data and data.target

    if target and ESX.GetPlayerFromId(target) then
        TriggerClientEvent('autocontra:check_destinoAV', _source, data, target, GetPlayerName(target))
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'O destinatário não foi encontrado!' })
    end
end)

RegisterServerEvent('autocontra:assinadoAV')
AddEventHandler('autocontra:assinadoAV', function(data, fonte)
    local _source = source
    -- o cidadão (qualquer um) assina; só devolve ao agente que está online
    if ESX.GetPlayerFromId(_source) and fonte and ESX.GetPlayerFromId(fonte) then
        TriggerClientEvent('autocontra:receberAV_assinado', fonte, data)
    end
end)

RegisterServerEvent('autocontra:enviar')
AddEventHandler('autocontra:enviar', function(dados_papel_destino, destinatario)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not isAuthorized(xPlayer) then return end

    local xTarget = ESX.GetPlayerFromId(destinatario)
    if not xTarget then
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'O destinatário não está disponível!' })
        return
    end

    -- coima validada e fixada no servidor no momento da emissão
    local coima = math.floor(tonumber(dados_papel_destino and dados_papel_destino.coima) or 0)
    if coima < 0 then coima = 0 end
    if coima > COIMA_MAX then coima = COIMA_MAX end

    pendingAutos[destinatario] = { coima = coima, officer = _source }
    TriggerClientEvent('autocontra:receber', destinatario, dados_papel_destino, _source)
end)

RegisterServerEvent('autocontra:assinado')
AddEventHandler('autocontra:assinado', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    -- só cobra se houver um auto pendente emitido por um agente para ESTE cidadão
    local pending = pendingAutos[_source]
    if not pending then return end
    pendingAutos[_source] = nil

    if pending.coima > 0 then
        -- cobrança server-autoritária: o cidadão (_source) é multado, não um alvo arbitrário
        TriggerEvent('esx_billing:sendBill', _source, 'society_state', 'Contraordenação Rodoviária', pending.coima)
    end

    -- notifica o agente emissor (se ainda online)
    if pending.officer and ESX.GetPlayerFromId(pending.officer) then
        TriggerClientEvent('autocontra:emitido', pending.officer)
    end
end)
