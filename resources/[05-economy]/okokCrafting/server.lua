
ESX = nil

local Webhook = ''
local craftQueues = {} -- [src] = { {item, amount, isItem, timeMs, recipe, start}, ... }

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- ════════════════════════════════════════════════════════════════
--  FIX C5 (2026-06-12): servidor passa a ser DONO das receitas.
--  Antes confiava em recipe/item/amount/time vindos do cliente
--  (okokCrafting:craftItemDeath / craftItemFinished / CanCraftItem) →
--  spawn de qualquer item em qualquer quantidade com custo zero.
--  Agora tudo é validado/lido de Config.Crafting (shared) por itemID,
--  com check de job + distância à bancada, e fila server-side.
-- ════════════════════════════════════════════════════════════════

local function findCraftDef(itemID)
	for _, bench in ipairs(Config.Crafting) do
		for _, craft in ipairs(bench.crafts or {}) do
			if craft.item == itemID then
				return craft, bench
			end
		end
	end
	return nil, nil
end

local function jobAllowed(craft, xPlayer)
	if not craft.job or #craft.job == 0 then return true end
	local jobName = xPlayer.job and xPlayer.job.name
	for _, j in ipairs(craft.job) do
		if j == '' or j == 'any' or j == jobName then return true end
	end
	return false
end

local function nearBench(src, bench)
	local p = GetEntityCoords(GetPlayerPed(src))
	return #(p - bench.coordinates) <= ((bench.maxCraftRadius or 5.0) + 1.0)
end

RegisterServerEvent('okokCrafting:craftStartItem')
AddEventHandler('okokCrafting:craftStartItem', function() end) -- timing é server-side (start guardado no enqueue)

RegisterServerEvent('okokCrafting:craftStopItem')
AddEventHandler('okokCrafting:craftStopItem', function() end)

RegisterServerEvent('okokCrafting:failedCraft')
AddEventHandler('okokCrafting:failedCraft', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	if Webhook ~= '' then
		local identifierlist = ExtractIdentifiers(xPlayer.source)
		noSession({
			playerid = xPlayer.source,
			identifier = identifierlist.license:gsub("license2:", ""),
			discord = "<@"..identifierlist.discord:gsub("discord:", "")..">",
			type = "failed",
			item = item,
		})
	end
end)

-- Morte: devolve os ingredientes REAIS (do config) de tudo o que está na fila.
RegisterServerEvent('okokCrafting:craftItemDeath')
AddEventHandler('okokCrafting:craftItemDeath', function(_queueClientIgnored)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end
	local q = craftQueues[src]
	if q and #q > 0 then
		for _, entry in ipairs(q) do
			for _, ing in ipairs(entry.recipe) do
				if ing[3] == true then
					xPlayer.addInventoryItem(ing[1], ing[2])
				end
			end
		end
		craftQueues[src] = nil
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "You died, crafting ingredients were given back", 5000, 'info')
	end
end)

-- Concluir: ignora item/crafts/amount/isItem do cliente; usa a entrada server-side.
RegisterServerEvent('okokCrafting:craftItemFinished')
AddEventHandler('okokCrafting:craftItemFinished', function(_item, _crafts, itemName, _isItem)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return end

	local q = craftQueues[src]
	if not q or #q == 0 then
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "No session!", 5000, 'error')
		return
	end

	local entry = table.remove(q, 1) -- FIFO
	if #q == 0 then craftQueues[src] = nil end

	local elapsed = GetGameTimer() - entry.start
	if elapsed + 500 < entry.timeMs then
		-- concluiu cedo demais → devolver ingredientes e bloquear
		for _, ing in ipairs(entry.recipe) do
			if ing[3] == true then xPlayer.addInventoryItem(ing[1], ing[2]) end
		end
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "Anti-cheat protection!", 5000, 'error')
		if Webhook ~= '' then
			local idl = ExtractIdentifiers(xPlayer.source)
			noSession({ playerid = xPlayer.source, identifier = idl.license:gsub("license2:", ""),
				discord = "<@"..idl.discord:gsub("discord:", "")..">", type = "crafted-soon",
				time_taken = elapsed, time_needed = entry.timeMs, itemName = entry.item })
		end
		return
	end

	if entry.isItem then
		xPlayer.addInventoryItem(entry.item, entry.amount)
	else
		xPlayer.addWeapon(entry.item, 1)
	end

	if Webhook ~= '' then
		local idl = ExtractIdentifiers(xPlayer.source)
		noSession({ playerid = xPlayer.source, identifier = idl.license:gsub("license2:", ""),
			discord = "<@"..idl.discord:gsub("discord:", "")..">", type = "conclude-crafting",
			itemName = entry.item, time = elapsed })
	end
end)

ESX.RegisterServerCallback("okokCrafting:inv2", function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getInventoryItem(item))
end)

ESX.RegisterServerCallback("okokCrafting:itemNames", function(source, cb)
	MySQL.Async.fetchAll("SELECT * FROM items", {}, function(items)
		local itemNames = {}
		for _, v in ipairs(items) do
			itemNames[v.name] = v.label
		end
		cb(itemNames)
	end)
end)

-- Enfileirar craft: valida tudo server-side a partir do config (ignora recipe/amount do cliente).
ESX.RegisterServerCallback("okokCrafting:CanCraftItem", function(source, cb, itemID, _recipeIgnored, itemName, _amountIgnored)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if not xPlayer then return cb(false) end

	local craft, bench = findCraftDef(itemID)
	if not craft or not bench then return cb(false) end
	if not jobAllowed(craft, xPlayer) then
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "You can't craft this here", 5000, 'error')
		return cb(false)
	end
	if not nearBench(src, bench) then
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "You are too far from the table", 5000, 'error')
		return cb(false)
	end

	-- ingredientes verificados a partir do config, não do cliente
	for _, ing in ipairs(craft.recipe) do
		local item = xPlayer.getInventoryItem(ing[1])
		if not item or item.count < ing[2] then
			TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "You don't have the ingredients", 5000, 'error')
			return cb(false)
		end
	end
	if not xPlayer.canCarryItem(itemID, craft.amount) then
		TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", "You can't carry that", 5000, 'error')
		return cb(false)
	end

	for _, ing in ipairs(craft.recipe) do
		if ing[3] == true then
			xPlayer.removeInventoryItem(ing[1], ing[2])
		end
	end

	craftQueues[src] = craftQueues[src] or {}
	table.insert(craftQueues[src], {
		item = itemID,
		amount = craft.amount,
		isItem = craft.isItem,
		timeMs = (craft.time or 5) * 1000,
		recipe = craft.recipe,
		start = GetGameTimer(),
	})

	cb(true)
	TriggerClientEvent('okokNotify:Alert', src, "CRAFTING", (itemName and itemName[itemID] or itemID).." added to the crafting queue", 5000, 'success')
	if Webhook ~= '' then
		local idl = ExtractIdentifiers(xPlayer.source)
		noSession({ playerid = xPlayer.source, identifier = idl.license:gsub("license2:", ""),
			discord = "<@"..idl.discord:gsub("discord:", "")..">", type = "crafting", itemName = itemID })
	end
end)

AddEventHandler('playerDropped', function()
	craftQueues[source] = nil
end)

-------------------------- IDENTIFIERS

function ExtractIdentifiers(id)
	local identifiers = { steam = "", ip = "", discord = "", license = "", xbl = "", live = "" }
	for i = 0, GetNumPlayerIdentifiers(id) - 1 do
		local playerID = GetPlayerIdentifier(id, i)
		if string.find(playerID, "steam") then identifiers.steam = playerID
		elseif string.find(playerID, "ip") then identifiers.ip = playerID
		elseif string.find(playerID, "discord") then identifiers.discord = playerID
		elseif string.find(playerID, "license") then identifiers.license = playerID
		elseif string.find(playerID, "xbl") then identifiers.xbl = playerID
		elseif string.find(playerID, "live") then identifiers.live = playerID
		end
	end
	return identifiers
end

-------------------------- NO SESSION WEBHOOK

function noSession(data)
	local color = '65352'
	local category = 'test'

	if data.type == 'Death' then
		color = Config.AnticheatProtectionWebhookColor
		category = 'Tried to receive the crafting items without starting a crafting, he might be cheating'
	elseif data.type == 'conclude' then
		color = Config.AnticheatProtectionWebhookColor
		category = 'Tried to conclude a crafting without starting it first, he might be cheating'
	elseif data.type == 'crafted-soon' then
		color = Config.AnticheatProtectionWebhookColor
		category = 'Concluded the crafting of '..tostring(data.itemName)..' after '..tostring(data.time_taken)..'ms while it takes '..tostring(data.time_needed)..'ms to craft, he might be cheating'
	elseif data.type == 'crafting' then
		color = Config.StartCraftWebhookColor
		category = 'Added '..tostring(data.itemName)..' to queue'
	elseif data.type == 'conclude-crafting' then
		color = Config.ConcludeCraftWebhookColor
		category = 'Crafted a '..tostring(data.itemName)..' after '..tostring(data.time)..'ms'
	elseif data.type == 'failed' then
		color = Config.FailWebhookColor
		category = 'Failed to craft a '..tostring(data.item)
	end

	local information = {
		{
			["color"] = color,
			["author"] = { ["icon_url"] = Config.IconURL, ["name"] = Config.ServerName..' - Logs' },
			["title"] = 'CRAFTING',
			["description"] = '**Action:** '..category..'\n\n**ID:** '..data.playerid..'\n**Identifier:** '..data.identifier..'\n**Discord:** '..data.discord,
			["footer"] = { ["text"] = os.date(Config.DateFormat) }
		}
	}

	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end
