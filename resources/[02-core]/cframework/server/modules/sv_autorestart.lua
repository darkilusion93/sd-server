

function ServerOnMessage()
	local channelID = GetConvar("discord_channel_id", "") -- enable dev mode on discord, right-click on the channel, copy ID
	local token = GetConvar("discord_bot_token", "")

	local baseURL = "https://discordapp.com/api/channels/"..channelID.."/messages"
	local headers = { ["Authorization"]=token, ["User-Agent"]="myBotThing (http://some.url, v0.1)", ["Content-Type"]="application/json" }
	local message = (T("RESTART_SERVER_ON_MESSAGE")):format(GetConvar("discord_announce_ip", ""))

	local formattedMessage = json.encode({content = message})

	PerformHttpRequest(baseURL, function(_,_,_) end, "POST", formattedMessage, headers)
end

RegisterCommand('rrtime', function(source, args)
	if source == 0 then
		ExecuteCommand('weather thunder')
		print("[RESTART] " .. T("RESTART_IN_5_MINUTES"))
        TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_5_MINUTES"), 10)
		Citizen.Wait(60000)
		print("[RESTART] " .. T("RESTART_IN_4_MINUTES"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_4_MINUTES"), 10)
		Citizen.Wait(60000)
		print("[RESTART] " .. T("RESTART_IN_3_MINUTES"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_3_MINUTES"), 10)
		Citizen.Wait(60000)
		print("[RESTART] " .. T("RESTART_IN_2_MINUTES"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_2_MINUTES"), 10)
		Citizen.Wait(60000)
		print("[RESTART] " .. T("RESTART_IN_1_MINUTE"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_1_MINUTE"), 10)
		Citizen.Wait(30000)
		print("[RESTART] " .. T("RESTART_IN_30_SECONDS"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_IN_30_SECONDS"), 10)
		Citizen.Wait(30000)
		print("[RESTART] " .. T("RESTART_NOW"))
		TriggerClientEvent("cframework:announce", -1, T("RESTART_ANNOUNCE"), T("RESTART_NOW"), 10)
		Citizen.Wait(2500)
		ExecuteCommand("kickall")
		Citizen.Wait(7500)
		ExecuteCommand("quit")
    end
end, false)

local function autoRestartServer(d,h,m)
	ExecuteCommand('rrtime')
end

Citizen.CreateThread(function()
	if ESX.DEV then return end

	TriggerEvent("cron:runAt", 7, 0, autoRestartServer)
    --TriggerEvent("cron:runAt", 20, 30, autoRestartServer)

	ServerOnMessage()
end)