local LogWebhookAmmunation = 'https://discord.com/api/webhooks/'
local LogWebhookLojaWeed = 'https://discord.com/api/webhooks/'

RegisterServerEvent('TxDEV:Logs')
AddEventHandler('TxDEV:Logs', function(src, tipo)
    if tipo == '1' then
        TriggerClientEvent('inventory:notify', src, 'error', Config.LogsLojaWeed)
        teixa_log('O Player '..GetPlayerName(src)..'**(ID:'..src..')** está a tentar duplicar na **LOJA DA WEED**', LogWebhookLojaWeed)
    else
        TriggerClientEvent('inventory:notify', src, 'error', Config.LogsAmmunation)
        teixa_log('O Player '..GetPlayerName(src)..'**(ID:'..src..')** está a tentar duplicar na **AMMUNATION**!', LogWebhookAmmunation)
    end
end)

local LogCor = '#FF0000'
function teixa_log(msg,canal)
	local corfinal = tonumber(LogCor:gsub("#",""),16)
	PerformHttpRequest(canal, function(err, text, headers) end, 'POST', json.encode(
        {username = 'Teixeira DEV PT LOGS',
             embeds = {{
                ["color"] = corfinal, 
                ["author"] = {
                    ["name"] = 'Teixeira DEV PT LOGS', 
                    ["icon_url"] = ''
                },
                 ["description"] = msg, 
                 ["footer"] = {
                    ["text"] = "Teixeira DEV PT LOGS - "..os.date("%x %X %p"),
                    ["icon_url"] = "",
                },
            }
        },
    }
),{ ['Content-Type'] = 'application/json' })
end
