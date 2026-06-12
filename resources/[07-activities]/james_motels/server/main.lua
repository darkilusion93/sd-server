ESX = nil

Async = {}
Async.parallel = function(tasks, cb)
    if #tasks == 0 then
        cb({})
        return
    end

    local results = {}
    local completed = 0

    for i, task in ipairs(tasks) do
        task(function(res)
            results[i] = res
            completed = completed + 1

            if completed == #tasks then
                cb(results)
            end
        end)
    end
end


cachedData = {
    ["motels"] = {},
    ["storages"] = {},
    ["furnishings"] = {},
    ["names"] = {}
}

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

local Webhook = 'https://canary.discord.com/api/webhooks//'

MySQL.ready(function()
    local sqlTasks = {}

    table.insert(sqlTasks, function(callback)        
        local firstSqlQuery = [[
            SELECT
                userIdentifier, motelData
            FROM
                world_motels
        ]]

        MySQL.Async.fetchAll(firstSqlQuery, {
            
        }, function(response)
            if #response <= 0 then callback(false) return end

            for motelIndex, motelData in ipairs(response) do
                local decodedData = json.decode(motelData["motelData"])
    
                if not cachedData["motels"][decodedData["room"]] then
                    cachedData["motels"][decodedData["room"]] = {}
                    cachedData["motels"][decodedData["room"]]["rooms"] = {}
                end
    
                table.insert(cachedData["motels"][decodedData["room"]]["rooms"], {
                    ["motelData"] = decodedData
                })
            end
            
            callback(true)
        end)
    end)

    table.insert(sqlTasks, function(callback)  
        local secondSqlQuery = [[
            SELECT
                storageId, storageData
            FROM
                world_storages
        ]]
        
        MySQL.Async.fetchAll(secondSqlQuery, {
            
        }, function(response)
            if #response <= 0 then callback(false) return end

            for storageIndex, storageData in ipairs(response) do
                local decodedData = json.decode(storageData["storageData"])

                if not cachedData["storages"][storageData["storageId"]] then
                    cachedData["storages"][storageData["storageId"]] = {}
                    cachedData["storages"][storageData["storageId"]]["items"] = {}
                end

                cachedData["storages"][storageData["storageId"]] = decodedData
            end

            callback(true)
        end)
    end)

    table.insert(sqlTasks, function(callback)    
        local thirdSqlQuery = [[
            SELECT
                motelId, furnishingData, ownedFurnishingData
            FROM
                world_furnishings
        ]]

        MySQL.Async.fetchAll(thirdSqlQuery, {
            
        }, function(response)
            if #response <= 0 then callback(false) return end

            for furnishingIndex, furnishingData in ipairs(response) do
                local decodedFurnishingData = json.decode(furnishingData["furnishingData"] or "{}")
                local decodedOwnedFurnishingData = json.decode(furnishingData["ownedFurnishingData"] or "{}")

                cachedData["furnishings"][furnishingData["motelId"]] = {}
                cachedData["furnishings"][furnishingData["motelId"]]["furnishing"] = decodedFurnishingData
                cachedData["furnishings"][furnishingData["motelId"]]["ownedFurnishing"] = decodedOwnedFurnishingData
            end

            callback(true)
        end)
    end)

    Async.parallel(sqlTasks, function(responses)
        ESX.Trace("SQL Tasks finished.")
    end)
end)

RegisterServerEvent("james_motels:globalEvent")
AddEventHandler("james_motels:globalEvent", function(options)
    TriggerClientEvent("james_motels:eventHandler", -1, options["event"] or "none", options["data"] or nil)
end)

ESX.RegisterServerCallback("james_motels:fetchMotels", function(source, callback)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local sqlQuery = [[
            SELECT
                keyData
            FROM
                world_keys
            WHERE
                owner = @owner
        ]]

        MySQL.Async.fetchAll(sqlQuery, {
            ["@owner"] = player["identifier"]
        }, function(response)
            local playerKeys = {}

            for keyIndex, keyData in ipairs(response) do
                local decodedData = json.decode(keyData["keyData"])

                table.insert(playerKeys, decodedData)
            end

            GetCharacterName(player, function(playerName)
                callback(cachedData["motels"], cachedData["storages"], cachedData["furnishings"], playerKeys, playerName)
            end)
        end)
    else
        callback(false)
    end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end


-- FIX C12/C13 (2026-06-12): storage server-autoritária. Antes o cliente enviava
-- a tabela inteira (`newTable`) E o item-delta de forma independente → "adicionar"
-- 1 item barato enquanto a newTable trazia ouro/armas = dupe infinito. Agora o
-- servidor é dono: ADD exige possuir o item; TAKE exige existir na storage.
-- (Residual: falta validar posse/chave do storageId.)
local function jm_getItems(storageId)
    local s = cachedData["storages"][storageId]
    if type(s) ~= "table" then s = { items = {} }; cachedData["storages"][storageId] = s end
    if type(s.items) ~= "table" then s.items = {} end
    return s.items
end
local function jm_storageAdd(storageId, itemType, name, count)
    local items = jm_getItems(storageId)
    for _, e in ipairs(items) do
        if e.type == itemType and e.name == name then e.count = (e.count or 0) + count; return end
    end
    items[#items+1] = { type = itemType, name = name, count = count }
end
local function jm_storageRemove(storageId, itemType, name, count)
    local items = jm_getItems(storageId)
    for i, e in ipairs(items) do
        if e.type == itemType and e.name == name then
            if (e.count or 0) < count then return false end
            e.count = e.count - count
            if e.count <= 0 then table.remove(items, i) end
            return true
        end
    end
    return false
end
local function jm_validItem(newItem)
    if type(newItem) ~= "table" then return nil end
    local count = math.floor(tonumber(newItem.count) or 0)
    local itemType, name = newItem.type, newItem.name
    if count <= 0 or type(name) ~= "string" then return nil end
    if itemType ~= "item" and itemType ~= "weapon" and itemType ~= "black_money" then return nil end
    return itemType, name, count
end

ESX.RegisterServerCallback("james_motels:addItemToStorage", function(source, callback, newTable, newItem, storageId, data)
    local player_id = source
    local ids = ExtractIdentifiers(player_id)
    local player = ESX.GetPlayerFromId(source)

	local information = {
		{
			["color"] = 5763719,
			["author"] = {
				["name"] = 'Adicionou um Item ao Armário',
			},
			["description"] = '**Steam Name:** ' ..GetPlayerName(source).. '\n**ID:** ' ..source.. '\n**Steam ID:** ' ..ids.steam.. '\n**License:** ' ..ids.license.. '\n **Tipo:** ' ..newItem["type"].. '\n **Item:** ' ..newItem["name"].. '\n **Quantidade:** ' ..newItem["count"].. '\n**Armário ID:** ' ..storageId.. '',
			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X]'),
			}
		}
	}

    if player then
        local itemType, name, count = jm_validItem(newItem)
        if not itemType then return callback(false) end
        local ok = false
        if itemType == "item" then
            local inv = player.getInventoryItem(name)
            if inv and inv.count >= count then player.removeInventoryItem(name, count); ok = true end
        elseif itemType == "weapon" then
            player.removeWeapon(name, count); ok = true
        elseif itemType == "black_money" then
            if player.getAccount("black_money").money >= count then player.removeAccountMoney("black_money", count); ok = true end
        end
        if not ok then return callback(false) end
        jm_storageAdd(storageId, itemType, name, count)
        local updated = cachedData["storages"][storageId]

        TriggerClientEvent("james_motels:eventHandler", -1, "update_storages", {
            ["newTable"] = updated,
            ["storageId"] = storageId
        })

        UpdateStorageDatabase(storageId, updated)

        callback(true)
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Motel, embeds = information}), {['Content-Type'] = 'application/json'})
    else
        callback(false)
    end
    
end)

ESX.RegisterServerCallback("james_motels:takeItemFromStorage", function(source, callback, newTable, newItem, storageId)
    local player_id = source
    local ids = ExtractIdentifiers(player_id)
    local player = ESX.GetPlayerFromId(source)

	local information = {
		{
			["color"] = 15158332,
			["author"] = {
				["name"] = 'Retirou um Item ao Armário',
			},
			["description"] = '**Steam Name:** ' ..GetPlayerName(source).. '\n**ID:** ' ..source.. '\n**Steam ID:** ' ..ids.steam.. '\n**License:** ' ..ids.license.. '\n **Tipo:** ' ..newItem["type"].. '\n **Item:** ' ..newItem["name"].. '\n **Quantidade:** ' ..newItem["count"].. '\n**Armário ID:** ' ..storageId.. '',
			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X]'),
			}
		}
	}

    if player then
        local itemType, name, count = jm_validItem(newItem)
        if not itemType then return callback(false) end
        -- só dá se o item existir mesmo na storage (server-side)
        if not jm_storageRemove(storageId, itemType, name, count) then return callback(false) end
        if itemType == "item" then
            player.addInventoryItem(name, count)
        elseif itemType == "weapon" then
            player.addWeapon(name, count)
        elseif itemType == "black_money" then
            player.addAccountMoney("black_money", count)
        end
        local updated = cachedData["storages"][storageId]

        TriggerClientEvent("james_motels:eventHandler", -1, "update_storages", {
            ["newTable"] = updated,
            ["storageId"] = storageId
        })

        UpdateStorageDatabase(storageId, updated)

        callback(true)
        PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Motel, embeds = information}), {['Content-Type'] = 'application/json'})
    else
        callback(false)
    end
end)

ESX.RegisterServerCallback("james_motels:retreivePlayers", function(source, callback, playersSent)
	local player = ESX.GetPlayerFromId(source)

	if #playersSent <= 0 then
		callback(false)

		return
	end

	if player then
		local newPlayers = {}

        for playerIndex, playerSource in ipairs(playersSent) do
			local player = ESX.GetPlayerFromId(playerSource)

            local characterNames = cachedData["names"][player["source"]]

			if player then
				if player["source"] ~= source then
					table.insert(newPlayers, {
						["firstname"] = characterNames["firstname"],
						["lastname"] = characterNames["lastname"],
						["source"] = player["source"]
					})
				end
			end
		end

		callback(newPlayers)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback("james_motels:buyMotel", function(source, callback, room)
	local player = ESX.GetPlayerFromId(source)

    if player then
        if player.getMoney() >= Config.MotelPrice then
            player.removeMoney(Config.MotelPrice)
        elseif player.getAccount("bank")["money"] >= Config.MotelPrice then
            player.removeAccountMoney("bank", Config.MotelPrice)
        else
            return callback(false)
        end

        CreateMotel(source, room, function(confirmed, uuid)
            if confirmed then
                callback(true, uuid)
            else
                callback(false)
            end
        end)
	else
		callback(false)
	end
end)

ESX.RegisterServerCallback("james_motels:getPlayerDressing", function(source, cb)
    local player = ESX.GetPlayerFromId(source)
  
    TriggerEvent("esx_datastore:getDataStore", "property", player["identifier"], function(store)
        local count = store.count("dressing")

        local labels = {}
  
        for index = 1, count do
            local entry = store.get("dressing", index)

            table.insert(labels, entry["label"])
        end
  
        cb(labels)
    end)
end)
  
ESX.RegisterServerCallback("james_motels:getPlayerOutfit", function(source, cb, num)
    local player = ESX.GetPlayerFromId(source)

    TriggerEvent("esx_datastore:getDataStore", "property", player["identifier"], function(store)
        local outfit = store.get("dressing", num)

        cb(outfit["skin"])
    end)
end)

ESX.RegisterServerCallback("james_motels:saveFurnishing", function(source, callback, motelId, furnishingData, ownedFurnishingData)
    local player = ESX.GetPlayerFromId(source)

    if not player then return callback(false) end

    local sqlQuery = [[
        INSERT
            INTO
        world_furnishings
            (motelId, furnishingData)
        VALUES
            (@id, @data)
        ON DUPLICATE KEY UPDATE
            furnishingData = @data, ownedFurnishingData = @ownedData
    ]]

    MySQL.Async.execute(sqlQuery, {
        ["@id"] = motelId,
        ["@data"] = json.encode(furnishingData),
        ["@ownedData"] = json.encode(ownedFurnishingData)
    }, function(rowsChanged)
        if rowsChanged > 0 then
            if not cachedData["furnishings"][motelId] then
                cachedData["furnishings"][motelId] = {}
            end
        
            cachedData["furnishings"][motelId]["furnishing"] = furnishingData
            cachedData["furnishings"][motelId]["ownedFurnishing"] = ownedFurnishingData

            callback(true)
        else
            callback(false)
        end
    end)
end)

ESX.RegisterServerCallback("james_motels:checkMoney", function(source, callback)
    local player = ESX.GetPlayerFromId(source)

    if not player then return callback(false) end

    if player.getMoney() >= Config.KeyPrice then
        player.removeMoney(Config.KeyPrice)

        callback(true)
    elseif player.getAccount("bank")["money"] >= Config.KeyPrice then
        player.removeAccountMoney("bank", Config.KeyPrice)
        
        callback(true)
    else
        callback(false)
    end
end)

ESX.RegisterServerCallback("james_motels:sellMotel", function(source, callback, motelData)
    local player = ESX.GetPlayerFromId(source)

    if not player then return callback(false) end

    local removeSqlTasks = {}

    table.insert(removeSqlTasks, function(callback)        
        local sqlQuery = [[
            DELETE
                FROM
            world_motels
                WHERE
            userIdentifier = @identifier
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@identifier"] = player["identifier"]
        }, function(rowsChanged)
            if rowsChanged > 0 then
                callback(true)
            else
                callback(false)
            end
        end)
    end)

    table.insert(removeSqlTasks, function(callback)        
        local sqlQuery = [[
            DELETE
                FROM
            world_storages
                WHERE
            storageId = @motelId
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@motelId"] = "motel-" .. motelData["uniqueId"]
        }, function(rowsChanged)
            if rowsChanged > 0 then
                callback(true)
            else
                callback(false)
            end
        end)
    end)

    table.insert(removeSqlTasks, function(callback)        
        local sqlQuery = [[
            DELETE
                FROM
            world_furnishings
                WHERE
            motelId = @motelId
        ]]

        MySQL.Async.execute(sqlQuery, {
            ["@motelId"] = motelData["uniqueId"]
        }, function(rowsChanged)
            if rowsChanged > 0 then
                callback(true)
            else
                callback(false)
            end
        end)
    end)

    table.insert(removeSqlTasks, function(callback)
        -- FIX SQLi (2026-06-12): uniqueId era concatenado direto no LIKE.
        -- Agora é parametrizado (e validado como numérico).
        local uuid = tostring(motelData["uniqueId"] or "")
        if not uuid:match("^%d+$") then return callback(false) end
        MySQL.Async.execute('DELETE FROM world_keys WHERE keyData LIKE @uuid', {
            ['@uuid'] = '%' .. uuid .. '%'
        }, function(rowsChanged)
            if rowsChanged > 0 then
                callback(true)
            else
                callback(false)
            end
        end)
    end)

    Async.parallel(removeSqlTasks, function(responses)
        if #responses == 4 then
            ESX.Trace("Motel excluído com sucesso em: " .. player["name"])

            for roomIndex, roomData in ipairs(cachedData["motels"][motelData["room"]]["rooms"]) do
                if roomData["motelData"]["uniqueId"] == motelData["uniqueId"] then
                    table.remove(cachedData["motels"][motelData["room"]]["rooms"], roomIndex)

                    TriggerClientEvent("james_motels:eventHandler", -1, "update_motels", cachedData["motels"])

                    break
                end
            end

            player.addMoney(math.ceil(Config.MotelPrice / 2))

            callback(true)
        else
            ESX.Trace("A exclusão do motel falhou em: " .. player["name"])

            callback(false)
        end
    end)
end)

ESX.RegisterServerCallback("james_motels:purchaseFurnishing", function(source, callback, furnishingData, motelId)
    local player = ESX.GetPlayerFromId(source)

    if not player then return callback(false) end

    -- FIX C13 (2026-06-12): price tem de ser inteiro > 0 (antes 0 = mobília grátis,
    -- negativo creditava). TODO: preço server-side por id de mobília (não do cliente).
    if type(furnishingData) ~= "table" then return callback(false) end
    local price = math.floor(tonumber(furnishingData["price"]) or 0)
    if price <= 0 then return callback(false) end

    if player.getMoney() >= price then
        player.removeMoney(price)
    elseif player.getAccount("bank")["money"] >= price then
        player.removeAccountMoney("bank", price)
    else
        return callback(false)
    end

    if not cachedData["furnishings"][motelId] then
        cachedData["furnishings"][motelId] = {}
    end

    if not cachedData["furnishings"][motelId]["ownedFurnishing"] then
        cachedData["furnishings"][motelId]["ownedFurnishing"] = {}
    end

    furnishingData["coords"] = nil
    furnishingData["rotation"] = nil

    table.insert(cachedData["furnishings"][motelId]["ownedFurnishing"], furnishingData)

    local sqlQuery = [[
        INSERT
            INTO
        world_furnishings
            (motelId, ownedFurnishingData)
        VALUES
            (@id, @data)
        ON DUPLICATE KEY UPDATE
            ownedFurnishingData = @data
    ]]

    MySQL.Async.execute(sqlQuery, {
        ["@id"] = motelId,
        ["@data"] = json.encode(cachedData["furnishings"][motelId]["ownedFurnishing"])
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent("james_motels:eventHandler", -1, "update_owned_furnishing", {
                ["id"] = motelId,
                ["newData"] = cachedData["furnishings"][motelId]["ownedFurnishing"]
            })

            callback(true)
        else
            callback(false)
        end
    end)
end)


ESX.RegisterServerCallback("james_motels:getStorageItems", function(source, callback, storageId)
    local player = ESX.GetPlayerFromId(source)
    
    if not player then
        callback({})
        return
    end
    
    local items = {}
    
    if cachedData and cachedData.storages and cachedData.storages[storageId] then
        if cachedData.storages[storageId].items then
            items = cachedData.storages[storageId].items
        end
    end
    
    callback(items)
end)