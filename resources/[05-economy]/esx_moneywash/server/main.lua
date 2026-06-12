ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function sendToDiscord (message,color)
	local DiscordWebHook = 'https://discord.com/api/webhooks/'
    local embeds = {
	  {
		  ["type"]="rich",
		  ["color"] =color,
		  ["author"] = {
			["name"] = 'Teixeira Developer LOGS', 
			["icon_url"] = 'https://media.discordapp.net/attachments/879031674627833888/1150727751410651206/Logo_Tebex_2.png?ex=655b29bb&is=6548b4bb&hm=96b08d50158ca59ec5dcc5d990904d7744c1e9670ec341de7ccfbf4b5f6b9995&=&width=921&height=360'
		},
		  ["description"] = message, 
		  ["footer"] = {
			["text"] = "Teixeira Developer LOGS- "..os.date("%x %X %p"),
			["icon_url"] = "https://media.discordapp.net/attachments/879031674627833888/1150727751410651206/Logo_Tebex_2.png?ex=655b29bb&is=6548b4bb&hm=96b08d50158ca59ec5dcc5d990904d7744c1e9670ec341de7ccfbf4b5f6b9995&=&width=921&height=360",
		},
	  }
  	}
	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({
		embeds = embeds
	}), 
	{ ['Content-Type'] = 'application/json' })
end
RegisterServerEvent('esx_moneywash:washMoney')
AddEventHandler('esx_moneywash:washMoney', function(amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end
    amount = ESX.Math.Round(tonumber(amount))
    if not amount then return end

    -- FIX (2026-06-12): validar job permitido + proximidade à zona server-side.
    -- Antes não havia check nenhum → qualquer jogador lavava de qualquer sítio.
    local pcoords = GetEntityCoords(GetPlayerPed(src))
    local jobName = xPlayer.job and xPlayer.job.name
    local atValidZone = false
    for _, zone in ipairs(Config.Zones) do
        local jobAllowed = false
        for _, j in ipairs(zone.Jobs or {}) do
            if j == 'any' or j == jobName then jobAllowed = true break end
        end
        if jobAllowed then
            for _, pos in ipairs(zone.Pos) do
                if #(pcoords - vector3(pos.x, pos.y, pos.z)) <= 5.0 then
                    atValidZone = true break
                end
            end
        end
        if atValidZone then break end
    end
    if not atValidZone then
        TriggerClientEvent('esx:showNotification', src, 'Não estás numa zona de lavagem válida.')
        return
    end

    if amount < 500000 then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Valor mínimo para lavar é 500000€')
        return
    end

    local washedCash = amount
    local washedTotal = ESX.Math.Round(tonumber(washedCash))
    local malasSegurasToRemove = math.floor(washedTotal / 500000)

    if amount > 0 and xPlayer.getAccount('black_money').money >= amount and xPlayer.getInventoryItem('dinheirobanco').count >= malasSegurasToRemove then
        xPlayer.removeAccountMoney('black_money', amount)
        TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_washed') .. ESX.Math.GroupDigits(amount) .. _U('dirty_money') .. _U('you_have_received') .. ESX.Math.GroupDigits(washedTotal) .. _U('clean_money'))
        xPlayer.addMoney(amount)

        if malasSegurasToRemove > 0 then
            xPlayer.removeInventoryItem('dinheirobanco', malasSegurasToRemove)
        end

        sendToDiscord('O Player **'..xPlayer.name ..' (ID:'..src..')** Lavou **'.. washedTotal ..'** de Dinheiro Sujo e foi removido **'..malasSegurasToRemove..'x Malas Seguras**', 16711680)
    else
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Nãos tens malas seguras suficientes!')
    end
end)


