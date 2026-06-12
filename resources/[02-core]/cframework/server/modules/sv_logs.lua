local LOG_INVENTORY = 1
local LOG_TRUNK = 2
local LOG_HOUSE = 3
local LOG_MOTEL = 4
local LOG_LOGIN = 5
local LOG_COMSERV = 6
local LOG_BAN = 7
local LOG_ORGVAULT = 8
local LOG_ORGACTIONS = 9
local LOG_STAFFACTIONS = 10
local LOG_STAFFITEMS = 11
local LOG_STAFFARRAY = 12
local LOG_ROBBERY = 13
local LOG_DEATHS = 14
local LOG_REVIVES = 15
local LOG_SERVERINFO = 16
local LOG_TRASH = 17
local LOG_TRANSFERS = 18
local LOG_SHOPS = 19
local LOG_PLAYERSTATS = 20
local LOG_CRAFTS = 21

local serverID = GetConvar("sv_id", "ATL-PT-01")
local logsUrl = GetConvar("logs_url", "")
local heatmapUrl = GetConvar("logs_heatmap", "")
local crashUrl = GetConvar("logs_crash", "")


local function sendHttpRequest(table)
    table.server = serverID

	PerformHttpRequest(logsUrl, function(err, text, headers) end, 'POST', json.encode(table), {
		['Content-Type'] = 'application/json'
	})
end

local function sendHeatmap(table)
    table.server = serverID

	PerformHttpRequest(heatmapUrl, function(err, text, headers) end, 'POST', json.encode(table), {
		['Content-Type'] = 'application/json'
	})
end

local function sendCrash(table)
    table.server = serverID

    PerformHttpRequest(crashUrl, function(err, text, headers) end, 'POST', json.encode(table), {
        ['Content-Type'] = 'application/json'
    })
end


-- Send message when Player died (including reason/killer check) (Not always working)
RegisterServerEvent('playerDied',function(id, killer, DeathReason, Weapon, pState)
	local source = source
	if Weapon == nil then _Weapon = " " else _Weapon = Weapon end
	if id == 1 then  -- Suicide/died
        local isOnline = ESX.isPlayerOnline(source)

        if not isOnline then return end --Prevent sending log from a player that is not yet loaded but was dead when left the server

		--ESX.logDeaths(source, source, DeathReason, _Weapon, pState)
	elseif id == 2 then -- Killed by other player
		if ESX.getPlayTime(killer) < 3600 then
			TriggerClientEvent('esx:deleteVehicle', killer)
			Citizen.Wait(100)
			TriggerEvent('esx_sendToCommunityService', killer, 50, "Matou um player e tem menos de 1 hora de jogo")
			TriggerClientEvent('esx:showNotification', killer, 'Levaste serviço comunitário por matares alguém', 'error')
			TriggerClientEvent('esx_ambulancejob:revive', source)

            --ESX.logComservData(killer, "APLICAR", tonumber(killer), "Matou um player e tem menos de 1 hora de jogo", 50)
		end

		--ESX.logDeaths(killer, source, DeathReason, _Weapon, pState)
	else -- When gets killed by something else
        --ESX.logDeaths(source, source, "MORREU", "Died", pState)
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

function ExtractIdentifiersOffline(identifier)
    local ids = MySQL.Sync.fetchAll("SELECT * FROM bwh_identifiers WHERE steam = @identifier", {
        ['@identifier'] = identifier
    })

    if ids == nil or ids[1] == nil then
        return {
            steam = "",
            name = "",
            discord = "",
            license = "",
            xbl = "",
            live = ""
        }
    end

    local identifiers = {
        steam = ids[1].steam,
        name = ids[1].name,
        discord = ids[1].discord,
        license = "",
        xbl = "",
        live = ""
    }


    return identifiers
end


local clientDropReason = {
	-- resource dropped the client
	"RESOURCE",
	-- client initiated a disconnect
	"CLIENT",
	-- server initiated a disconnect
	"SERVER",
	-- client with same guid connected and kicks old client
	"CLIENT_REPLACED",
	-- server -> client connection timed out
	"CLIENT_CONNECTION_TIMED_OUT",
	-- server -> client connection timed out with pending commands
	"CLIENT_CONNECTION_TIMED_OUT_WITH_PENDING_COMMANDS",
	-- server shutdown triggered the client drop
	"SERVER_SHUTDOWN",
	-- state bag rate limit exceeded
	"STATE_BAG_RATE_LIMIT",
	-- net event rate limit exceeded
	"NET_EVENT_RATE_LIMIT",
	-- latent net event rate limit exceeded
	"LATENT_NET_EVENT_RATE_LIMIT",
	-- command rate limit exceeded
	"COMMAND_RATE_LIMIT",
	-- too many missed frames in OneSync
	"ONE_SYNC_TOO_MANY_MISSED_FRAMES"
}


AddEventHandler('playerJoining', function()
    local source = source
    local name = GetPlayerName(source)

    if name then
		--ESX.logLoginData(source, 'Entrada', nil)
    end
end)

local purge = true

AddEventHandler('playerDropped', function(reason, resourceName, intDropReason)
    local source = source
    local name = GetPlayerName(source)
    local dropReason = clientDropReason[intDropReason] or intDropReason

    if name then
		--ESX.logLoginData(source, 'Saída', reason .. " [" .. dropReason .. "/" .. resourceName .. "]")
    end

    if string.find(reason:lower(), "crash") then
        local identifiers = ExtractIdentifiers(source)
        local playerPed <const> = GetPlayerPed(source)
        local playerCoords <const>, isInVehicle <const> = GetEntityCoords(playerPed), GetVehiclePedIsIn(playerPed, false) ~= 0

        --get nearby vehiclesInArea
        local vehiclesInArea = {}
        local allVehicle = GetAllVehicles()

        ---@diagnostic disable-next-line: param-type-mismatch
        for _, vehicle in ipairs(allVehicle) do
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(playerCoords - vehicleCoords) < 100.0 then
                table.insert(vehiclesInArea, GetEntityModel(vehicle))
            end
        end

        sendCrash({
            data = {
                coords = playerCoords,
                steam = identifiers.steam,
                wasInsideVehicle = isInVehicle,
                reason = reason,
                vehicles = vehiclesInArea
            },
            purge = purge
        })

        purge = false
    end
end)

AddEventHandler("cframework:logPlayerRadio", function(source, radioChannel)
    --ESX.logPlayerStatsActions(source, "RADIO", source, "radio", "Canal -> " .. radioChannel, radioChannel)
end)

function ESX.SendHeatmapData(data)
	sendHeatmap({coords = data})
end

function ESX.LogTrunkData(source, pAction, item, quantity, plate, label)
	local playerHex = ExtractIdentifiers(source)

	if label == nil then
		label = ESX.GetItemLabel(item)
	end
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		vehicle = {
			plate = plate,
		},
		type = LOG_TRUNK,
	})
end

function ESX.LogCraftData(source, pAction, item, quantity, craft, label)
	local playerHex = ExtractIdentifiers(source)

	if label == nil then
		label = ESX.GetItemLabel(item)
	end

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
        craft = {
            name = craft
        },
		action = pAction,
		type = LOG_CRAFTS,
	})
end

function ESX.LogTempInvData(source, pAction, item, quantity, invid, label)
	local playerHex = ExtractIdentifiers(source)

	if label == nil then
		label = ESX.GetItemLabel(item)
	end
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		trash = {
			id = invid,
		},
		type = LOG_TRASH,
	})
end

function ESX.LogHouseData(source, pAction, item, quantity, owner, label)
	local playerHex = ExtractIdentifiers(source)
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		house = {
			name = "",
			owner = owner,
		},
		type = LOG_HOUSE,
	})
end

function ESX.LogMotelData(source, pAction, item, quantity, label, properyId)
	local playerHex = ExtractIdentifiers(source)
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		motel = {
			location = properyId
		},
		type = LOG_MOTEL,
	})
end

function ESX.LogShopsData(source, pAction, location, item, quantity, label)
	local playerHex = ExtractIdentifiers(source)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		shop = {
			location = location
		},
		type = LOG_SHOPS,
	})
end

function ESX.LogLoginData(source, pAction, reason)
	local playerHex = ExtractIdentifiers(source)
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord},
		},
		action = pAction,
		reason = reason,
		type = LOG_LOGIN,
	})
end

function ESX.LogComservData(source, pAction, targetSource, reason, amount)
	local playerHex = ExtractIdentifiers(source)
	local target = {}

	if tonumber(targetSource) == targetSource then
		local targetHex = ExtractIdentifiers(targetSource)
		target = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		}
	else
		target = {
			name = targetSource,
			ids = {},
		}
	end

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		target = target,
		reason = reason,
		amount = amount,
		type = LOG_COMSERV,
	})
end

function ESX.LogBanData(source, pAction, targetSource, reason, expire)
	local playerHex = ExtractIdentifiers(source)
	local target = {}

	if tonumber(targetSource) == targetSource then
		local targetHex = ExtractIdentifiers(targetSource)
		target = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		}
	else
		target = {
			name = targetSource,
			ids = {},
		}
	end
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		target = target,
		reason = reason,
		expire = expire,
		type = LOG_BAN,
	})
end

function ESX.LogOrgData(source, pAction, rItem, rQuantity, jobName, jobLabel, rLabel)
	local playerHex = ExtractIdentifiers(source)

	if rLabel == nil then
		rLabel = ESX.GetItemLabel(rItem)
	end
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = rLabel,
			name = rItem,
			quantity = rQuantity,
		},
		action = pAction,
		job = {
			name = jobName,
			label = jobLabel
		},
		type = LOG_ORGVAULT,
	})
end

function ESX.LogOrgActionsData(source, pAction, jobName, jobLabel, targetSource)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		job = {
			name = jobName,
			label = jobLabel
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		type = LOG_ORGACTIONS,
	})
end

function ESX.LogAdminActions(source, pAction, targetSource)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		type = LOG_STAFFACTIONS,
	})
end

function ESX.LogAdminActionsOffline(source, pAction, targetIdentifier)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiersOffline(targetIdentifier)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		receiver = {
			name = targetHex.name,
			ids = {0, targetHex.steam, targetHex.discord, targetHex.name},
		},
		type = LOG_STAFFACTIONS,
	})
end

function ESX.LogAdminItems(source, pAction, targetSource, item, label, quantity)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		type = LOG_STAFFITEMS,
	})
end

function ESX.LogPlayerStatsActions(source, pAction, targetSource, item, label, quantity)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		type = LOG_PLAYERSTATS,
	})
end

local startTime = os.time()
local staffCount = 0
local staffAdmin = 0
local pendingReports = 0


function ESX.LogStaffsIngame()
	local staffsIngame, count, count2 = {}, 0, 0

	for k, v in pairs(ESX.AdminPlayers) do
		local ids = ExtractIdentifiers(k)
        local inAdmin = ESX.inAdmin(k)

		table.insert(staffsIngame, {discord = ids.discord, inAdmin = inAdmin})
		count = count + 1

		if inAdmin then
			count2 = count2 + 1
		end
	end

	staffCount = count
	staffAdmin = count2

	sendHttpRequest({
		staffs = staffsIngame,
		type = LOG_STAFFARRAY,
	})
end


function ESX.updatePendingReports(count)
	pendingReports = count
end


function ESX.LogServerInfo()
	sendHttpRequest({
		players = #GetPlayers(),
		staff = staffCount,
		reports = pendingReports,
		starttime = startTime,
		admin = staffAdmin,
		type = LOG_SERVERINFO,
	})
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		--ESX.logServerInfo()
	end
end)


function ESX.LogRobberyData(source, pAction, police, rPlace)
	local playerHex = ExtractIdentifiers(source)
  
	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = "Polícias em Serviço",
			name = "police",
			quantity = police,
		},
		action = pAction,
		place = {
			name = rPlace,
		},
		type = LOG_ROBBERY,
	})
end

local deathBleeding = {}

function ESX.LogDeaths(source, targetSource, pAction, pReason, pState)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	deathBleeding[targetSource] = pState

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		action = pAction,
		reason = pReason,
		state = pState,
		type = LOG_DEATHS,
	})
end

function ESX.LogRevives(source, targetSource, pAction, pReason)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)
	local pState = "NOT FOUND"

	if deathBleeding[targetSource] ~= nil then
		pState = deathBleeding[targetSource]

		deathBleeding[targetSource] = nil
	end

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		action = pAction,
		reason = pReason,
		state = pState,
		type = LOG_REVIVES,
	})
end

function ESX.LogInventoryGive(source, targetSource, pAction, item, quantity, label)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		type = LOG_INVENTORY,
	})
end

function ESX.LogTransfers(source, targetSource, pAction, item, quantity, label)
	local playerHex = ExtractIdentifiers(source)
	local targetHex = ExtractIdentifiers(targetSource)

	sendHttpRequest({
		user = {
			name = GetPlayerName(source),
			ids = {source, playerHex.steam, playerHex.discord, ESX.getFullname(source)},
		},
		item = {
			label = label,
			name = item,
			quantity = quantity,
		},
		action = pAction,
		receiver = {
			name = GetPlayerName(targetSource),
			ids = {targetSource, targetHex.steam, targetHex.discord, ESX.getFullname(targetSource)},
		},
		type = LOG_TRANSFERS,
	})
end