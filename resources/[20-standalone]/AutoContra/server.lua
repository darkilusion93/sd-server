ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local declarations = {}

RegisterServerEvent('autocontra:novoAV')
AddEventHandler('autocontra:novoAV', function(ocorrenciaNumber)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local jobName = xPlayer.getJob().name

    if jobName == 'police' or jobName == 'sheriff' or jobName == 'municipal' or jobName == 'pj' or jobName == 'siis' then
        local newAV = {
            agente = xPlayer.getName(),
            codeAV = ocorrenciaNumber,
            data = os.date('%Y-%m-%d %H:%M:%S')
        }

        declarations[ocorrenciaNumber] = newAV
        TriggerClientEvent('autocontra:criar_noti', _source, newAV)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Sem permissão!' })
    end
end)

RegisterServerEvent('autocontra:enviarAV')
AddEventHandler('autocontra:enviarAV', function(data, target)
    TriggerClientEvent('autocontra:receberAV', target, data, source)
end)

RegisterServerEvent('autocontra:procurar_destinoAV')
AddEventHandler('autocontra:procurar_destinoAV', function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local target = data.target

    if xPlayer and target then
        TriggerClientEvent('autocontra:check_destinoAV', _source, data, target, GetPlayerName(target))
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'O destinatário não foi encontrado!' })
    end
end)

RegisterServerEvent('autocontra:assinadoAV')
AddEventHandler('autocontra:assinadoAV', function(data, fonte)
    TriggerClientEvent('autocontra:receberAV_assinado', fonte, data)
end)

RegisterServerEvent('autocontra:enviar')
AddEventHandler('autocontra:enviar', function(dados_papel_destino, destinatario)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(destinatario)

    if xTarget then
        TriggerClientEvent('autocontra:receber', destinatario, dados_papel_destino, _source)
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'O destinatário não está disponível!' })
    end
end)

RegisterServerEvent('autocontra:assinado')
AddEventHandler('autocontra:assinado', function(remetente)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerEvent('esx_billing:sendBill', remetente, 'society_state', 'Contraordenação Rodoviária', coima)
    TriggerClientEvent('autocontra:emitido', remetente)
end)
