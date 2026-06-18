-- {steamID, points, source}
local players = {}
local waiting = {}
local connecting = {}
local prePoints = Config.Points;
local EmojiList = Config.EmojiList

local Config2 = {
	DiscordToken = GetConvar("discord_bot_token", ""),
	GuildId = GetConvar("discord_guild_id", ""),

	-- Format: ["Role Nickname"] = "Role ID" You can get role id by doing \@RoleName
	Roles = {
		["staff"] = GetConvar("discord_staff_id", ""), -- This would be checked by doing exports.discord_perms:IsRolePresent(user, "TestRole")
        ["dev"] = GetConvar("discord_dev_id", ""),
        ["estagiario"] = GetConvar("discord_intern_id", ""),
	}
}

local notWhitelistedMessage = [[
	<div style="background-color: rgba(9, 23, 43, 1.0); color: white; padding: 20px; border: solid 2px var(--color-modal-border); border-radius: var(--border-radius-normal); margin-top: -17%; margin-bottom: -6%; position: relative;">
		<h2 style="color: white;">]].. T("CONNECTING_COULDNT_SHAKE_OCEANS") ..[[</h2>
		<p style="font-size: 1.25rem; padding: 0px; max-width: 80%">
			]].. T("CONNECTING_COULDNT_FIND_WHITELIST") ..[[
		</p>
		<br>]].. T("CONNECTING_TO_PLAY_JOIN_DISCORD") ..[[ <span style="font-style: italic;">]].. GetConvar("Discord", "") ..[[</span>.
		<img src="https://cdn.discordapp.com/attachments/1434675901362208860/1509639610828067016/logo_7.png?ex=6a1be332&is=6a1a91b2&hm=0dde62d16954bedda14e58ae1075a7666d781e164df34e6628a54834e4d0f59c&" style="position: absolute; right: 15px; bottom: 15px; max-height: 50%">
	</div>
]]

local discordNotAllowed = [[
	<div style="background-color: rgba(9, 23, 43, 1.0); color: white; padding: 20px; border: solid 2px var(--color-modal-border); border-radius: var(--border-radius-normal); margin-top: -17%; margin-bottom: -6%; position: relative;">
		<h2 style="color: white;">]].. T("CONNECTING_COULDNT_SHAKE_OCEANS") ..[[</h2>
		<p style="font-size: 1.25rem; padding: 0px; max-width: 80%">
			]].. T("CONNECTING_DISCORD_TOO_RECENT") ..[[
		</p>
		<br>]].. T("CONNECTING_TO_CONTEST_LIMIT") ..[[ <span style="font-style: italic;">]].. GetConvar("Discord", "") ..[[</span>.
		<img src="https://cdn.discordapp.com/attachments/1434675901362208860/1509639610828067016/logo_7.png?ex=6a1be332&is=6a1a91b2&hm=0dde62d16954bedda14e58ae1075a7666d781e164df34e6628a54834e4d0f59c&" style="position: absolute; right: 15px; bottom: 15px; max-height: 50%">
	</div>
]]

local vpnNotAllowed = [[
	<div style="background-color: rgba(9, 23, 43, 1.0); color: white; padding: 20px; border: solid 2px var(--color-modal-border); border-radius: var(--border-radius-normal); margin-top: -17%; margin-bottom: -6%; position: relative;">
		<h2 style="color: white;">]].. T("CONNECTING_COULDNT_SHAKE_OCEANS") ..[[</h2>
		<p style="font-size: 1.25rem; padding: 0px; max-width: 80%">
			]].. T("CONNECTING_VPN_NOT_ALLOWED") ..[[
		</p>
		<br>]].. T("CONNECTING_VPN_NOT_ALLOWED_TICKET") ..[[ <span style="font-style: italic;">]].. GetConvar("Discord", "") ..[[</span>.
		<img src="https://cdn.discordapp.com/attachments/1434675901362208860/1509639610828067016/logo_7.png?ex=6a1be332&is=6a1a91b2&hm=0dde62d16954bedda14e58ae1075a7666d781e164df34e6628a54834e4d0f59c&" style="position: absolute; right: 15px; bottom: 15px; max-height: 50%">
	</div>
]]

local vpnWhitelistRoles = { -- Vpn Whitelist role
	GetConvar("discord_vpn_id", ""), --VPN Whitelist
}

local whitelistRoles = { -- Role IDs needed to pass the whitelist
    GetConvar("discord_civil_id", ""), --Civil
	--GetConvar("discord_staff_id", ""), --Staff
}


local isServerOpen = true

RegisterCommand('changeserverstate', function(source, args)
	if source == 0 then
		isServerOpen = not isServerOpen
        if not isServerOpen then
			whitelistRoles = {
				GetConvar("discord_staff_id", ""), --staff
			}
			print('[INFO] Server closed')
		else
			whitelistRoles = {
				GetConvar("discord_civil_id", ""), --Civil
			}
			print('[INFO] Server opened')
		end
    end
end, true)

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM quilometros', {}, function(ListaKM)
		for i=1, #ListaKM, 1 do
			table.insert(prePoints, {ListaKM[i].identifier, ListaKM[i].km})
		end
	end)
end)

--[[
StopResource('hardcap')
RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if GetResourceState('hardcap') == 'stopped' then
			StartResource('hardcap')
		end
	end
end)]]

function has_value(table, val)
	if table then
		for index, value in ipairs(table) do
			if value == val then
				return true
			end
		end
	end
	return false
end

function steamIdToDecimal(steamId)
	local steamId64Hex = steamId:sub(7)  -- remove "steam:" prefix
	local steamId64Dec = tonumber(steamId64Hex, 16)
	return steamId64Dec
end

local function getDiscordTimestamp(discordId)
	local number = string.gsub(discordId, "discord:", "")

    -- Discord epoch starts from January 1, 2015, 00:00:00 UTC
    local discordEpoch = 1420070400000
    -- The ID contains a timestamp with 22 digits

    -- Add Discord epoch to the timestamp to get Unix timestamp
	return math.floor(tonumber(number) / 4194304 + discordEpoch)
end

-- Connexion d'un client
AddEventHandler("playerConnecting", function(name, reject, def)
	local source = source

	def.defer()

	local steamID = GetSteamID(source)

	-- pas de steam ? ciao
	if not steamID then
		reject(Config.NoSteam)
		CancelEvent()
		return
	end

	local xPlayer = ESX.GetPlayerFromIdentifier(steamID)

	if xPlayer ~= nil and not ESX.DEV  then
		DropPlayer(xPlayer.source, T("CONNECTING_SOMEONE_JOINED_USING_YOUR_ACCOUNT"))
	end

	if not Rocade(steamID, def, source, reject) then
		CancelEvent()
	end
end)

-- Fonction principale, utilise l'objet "def" transmis par l'evenement "playerConnecting"
function Rocade(steamID, def, source, reject)
	-- retarder la connexion
	--def.defer()

	-- faire patienter un peu pour laisser le temps aux listes de s'actualiser
	AntiSpam(def, source, reject)

	-- retirer notre ami d'une éventuelle liste d'attente ou connexion
	--Purge(steamID)

	-- l'ajouter aux players
	-- ou actualiser la source
	--AddPlayer(steamID, source)

	-- le mettre en file d'attente
	--table.insert(waiting, steamID)

	-- tant que le steamID n'est pas en connexion
	--local stop = false
	--repeat

	--	for i,p in ipairs(connecting) do
	--		if p[1] == steamID then
	--			stop = true
	--			break
	--		end
	--	end

	--	if GetPlayerPing(source) == 0 then
			-- le purger
	--		Citizen.Wait(3000)
	--		if GetPlayerPing(source) == 0 then
	--			Purge(steamID)
				-- comme il a annulé, def.done ne sert qu'à identifier un cas non géré
	--			def.done(Config.Accident)

	--			return false
	--		end
	--	end

		-- Mettre à jour le message d'attente
	--	def.update(GetMessage(steamID))

	--	Citizen.Wait(Config.TimerRefreshClient * 1000)

	--until stop

	-- quand c'est fini, lancer la co
	def.done()
	return true
end

-- Vérifier si une place se libère pour le premier de la file
Citizen.CreateThread(function()
	local maxServerSlots = 2048

	while true do
		Citizen.Wait(Config.TimerCheckPlaces * 1000)

		CheckConnecting()

		-- si une place est demandée et disponible
		if #waiting > 0 and #connecting + #GetPlayers() < maxServerSlots and #connecting < 60 then
			ConnectFirst()
		end
	end
end)

-- Mettre régulièrement les points à jour
Citizen.CreateThread(function()
	while true do
		UpdatePoints()

		Citizen.Wait(Config.TimerUpdatePoints * 1000)
	end
end)

-- Lorsqu'un joueur est kick
-- lui retirer le nombre de points fourni en argument
RegisterServerEvent("rocademption:playerKicked")
AddEventHandler("rocademption:playerKicked", function(src, points)
	local sid = GetSteamID(src)

	Purge(sid)

	for i,p in ipairs(prePoints) do
		if p[1] == sid then
			p[2] = p[2] - points
			return
		end
	end

	local initialPoints = GetInitialPoints(sid)

	table.insert(prePoints, {sid, initialPoints - points})
end)

-- Quand un joueur spawn, le purger
RegisterServerEvent("rocademption:playerConnected")
AddEventHandler("rocademption:playerConnected", function()
	local sid = GetSteamID(source)

	Purge(sid)
end)

-- Quand un joueur drop, le purger
AddEventHandler("playerDropped", function(reason)
	local steamID = GetSteamID(source)

	Purge(steamID)
end)

-- si le ping d'un joueur en connexion semble partir en couille, le retirer de la file
-- Pour éviter un fantome en connexion
function CheckConnecting()
	for i,sid in ipairs(connecting) do
		if GetPlayerPing(sid[2]) >= 500 then
			table.remove(connecting, i)
		end
	end
end

-- ... connecte le premier de la file
function ConnectFirst()
	if #waiting == 0 then return end

	local maxPoint = 0
	local maxSid = waiting[1][1]
	local maxWaitId = 1
	local maxSource = 1

	for i,sid in ipairs(waiting) do
		local points, pSource = GetPoints(sid)
		if points > maxPoint then
			maxPoint = points
			maxSid = sid
			maxWaitId = i
			maxSource = pSource
		end
	end
	
	table.remove(waiting, maxWaitId)
	table.insert(connecting, {maxSid, maxSource})
end

-- retourne le nombre de kilomètres parcourus par un steamID
function GetPoints(steamID)
	for i,p in ipairs(players) do
		if p[1] == steamID then
			return p[2], p[3]
		end
	end
end

-- Met à jour les points de tout le monde
function UpdatePoints()
	for i,p in ipairs(players) do

		local found = false

		for j,sid in ipairs(waiting) do
			if p[1] == sid then
				p[2] = p[2] + Config.AddPoints
				found = true
				break
			end
		end

		if not found then
			for j,sid in ipairs(connecting) do
				if p[1] == sid[1] then
					found = true
					break
				end
			end
		
			if not found then
				p[2] = p[2] - Config.RemovePoints
				if p[2] < GetInitialPoints(p[1]) - Config.RemovePoints then
					Purge(p[1])
					table.remove(players, i)
				end
			end
		end

	end
end

function AddPlayer(steamID, source)
	for i,p in ipairs(players) do
		if steamID == p[1] then
			players[i] = {p[1], p[2], source}
			return
		end
	end

	local initialPoints = GetInitialPoints(steamID)
	table.insert(players, {steamID, initialPoints, source})
end

function GetInitialPoints(steamID)
	local points = Config.RemovePoints + 1

	for n,p in ipairs(prePoints) do
		if p[1] == steamID then
			points = p[2]
			break
		end
	end

	return points
end

function GetPlace(steamID)
	local points = GetPoints(steamID)
	local place = 1

	for i,sid in ipairs(waiting) do
		for j,p in ipairs(players) do
			if p[1] == sid and p[2] > points then
				place = place + 1
			end
		end
	end
	
	return place
end

function GetMessage(steamID)
	local msg = ""

	if GetPoints(steamID) ~= nil then
		msg = Config.EnRoute .. " " .. GetPoints(steamID) .." " .. Config.PointsRP ..".\n"

		msg = msg .. Config.Position .. GetPlace(steamID) .. "/".. #waiting .. " " .. ".\n"

		msg = msg .. "[ " .. Config.EmojiMsg

		local e1 = RandomEmojiList()
		local e2 = RandomEmojiList()
		local e3 = RandomEmojiList()
		local emojis = e1 .. e2 .. e3

		if( e1 == e2 and e2 == e3 ) then
			emojis = emojis .. Config.EmojiBoost
			LoterieBoost(steamID)
		end

		-- avec les jolis emojis
		msg = msg .. emojis .. " ]"
	else
		msg = Config.Error
	end

	return msg
end

function LoterieBoost(steamID)
	for i,p in ipairs(players) do
		if p[1] == steamID then
			p[2] = p[2] + Config.LoterieBonusPoints
			return
		end
	end
end

function Purge(steamID)
	for n,sid in ipairs(connecting) do
		if sid[1] == steamID then
			table.remove(connecting, n)
		end
	end

	for n,sid in ipairs(waiting) do
		if sid == steamID then
			table.remove(waiting, n)
		end
	end
end

function AntiSpam(def, source, reject)
	

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
	end
	
	passAuth = false
	local checkVpn = true

	-- interruptor de teste/dev: `set cf_whitelist false` no cfg desliga a whitelist Discord
	-- (default "true" => whitelist ativa em produção). Útil quando o bot token/ip-api
	-- ainda não estão configurados (evita o "tag whitelist não encontrada" a bloquear todos).
	if GetConvar('cf_whitelist', 'true') ~= 'true' then
		def.done()
		return
	end

    if identifierDiscord then
    	usersRoles = GetRoles(source)
		for index, valueReq in ipairs(whitelistRoles) do 
            if has_value(usersRoles, valueReq) then
				passAuth = true
			end
        end

		for index, valueReq in ipairs(vpnWhitelistRoles) do 
            if has_value(usersRoles, valueReq) then
				checkVpn = false
			end
        end
	end

	if not passAuth then
		--print('nao entra')
		def.done(notWhitelistedMessage)
		return
	end

	local playerIp = GetPlayerEndpoint(source)

	if playerIp == nil then
		reject(T("CONNECTING_ERROR_VERIFIYING_NETWORK"))
		def.done(T("CONNECTING_ERROR_VERIFIYING_NETWORK"))
		return
	end

	if checkVpn then
		PerformHttpRequest('https://pro.ip-api.com/json/'.. playerIp ..'?fields=188416&key='.. GetConvar('ipapi_key', ''), function(statusCode, resultData, headers)
			if statusCode == 200 then
				local result = json.decode(resultData)

				if result.proxy then
					reject(vpnNotAllowed)
					def.done(vpnNotAllowed)
				end
			else
				reject(T("CONNECTING_ERROR_VERIFIYING_NETWORK"))
				def.done(T("CONNECTING_ERROR_VERIFIYING_NETWORK"))
			end
		end)
	end

	local userUnix = getDiscordTimestamp(identifierDiscord)/1000
	local unixNow = os.time()

	local diffSeconds = unixNow - userUnix

	if diffSeconds < 604800 then --Check if discord is a week old / the month is 2592000
		def.done(discordNotAllowed)
		return
	end

	for i=Config.AntiSpamTimer,0,-1 do
		def.update(Config.PleaseWait_1 .. Config.PleaseWait[i+1])
		Citizen.Wait(1000)
	end
end

function RandomEmojiList()
	randomEmoji = EmojiList[math.random(#EmojiList)]
	return randomEmoji
end

-- Helper pour récupérer le steamID or false
function GetSteamID(src)
	local sid = GetPlayerIdentifiers(src)[1] or false

	if (sid == false or sid:sub(1,5) ~= "steam") then
		return false
	end

	return sid
end

local FormattedToken = Config2.DiscordToken

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetRoles(user)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			--print("[LOADING] "..discordId)
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config2.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			return roles
		else
			--print("An error occured, maybe they arent in the discord? Error: "..member.data)
			return false
		end
	else
		--print("[LOADING] error: missing identifier")
		return false
	end
end

function IsRolePresent(user, role)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(user)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			--print("Found discord id: "..discordId)
			break
		end
	end

	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	else
		theRole = Config2.Roles[role]
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config2.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			for i=1, #roles do
				if roles[i] == theRole then
					--print("Found role")
					return true
				end
			end
			--print("Not found!")
			return false
		else
			--print("An error occured, maybe they arent in the discord? Error: "..member.data)
			return false
		end
	else
		--print("missing identifier")
		return false
	end
end

Citizen.CreateThread(function()
	local guild = DiscordRequest("GET", "guilds/"..Config2.GuildId, {})
	if guild.code == 200 then
		local data = json.decode(guild.data)
		print("Permission system guild set to: "..data.name.." ("..data.id..")")
	else
		print("An error occured, please check your Config2 and ensure everything is correct. Error: "..(guild.data or guild.code)) 
	end
end)

----------------------------------------
--- Discord Whitelist, Made by FAXES ---
----------------------------------------

-- Documentation: https://docs.faxes.zone/docs/discord-whitelist-setup
--- Config ---
