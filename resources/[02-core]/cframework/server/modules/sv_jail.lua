RegisterCommand("jail", function(src, args, raw)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)

				TriggerClientEvent("esx:showNotification", src, GetPlayerName(jailPlayer) .. " Jailed for " .. jailTime .. " minutes!")
				
			else
				TriggerClientEvent("esx:showNotification", src, "Coloca um tempo valido!")
			end
		else
			TriggerClientEvent("esx:showNotification", src, "Este ID não está na cidade!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "Não és policia!")
	end
end, false)

RegisterCommand("unjail", function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == "police" then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			TriggerClientEvent("esx:showNotification", src, "Este ID não está na cidade!")
		end
	else
		TriggerClientEvent("esx:showNotification", src, "Não és policia!")
	end
end, false)

RegisterServerEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function(targetSrc, jailTime, jailReason, key)
	local src = source
	local targetSrc = tonumber(targetSrc)

	TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat: Da próxima compra cheats melhores.', nil, false)
end)

RPC.register("jailPlayer", function(targetSrc, jailTime, jailReason, key)
	local src = source
    local jobName = ESX.getJob(src).name
	local targetSrc = tonumber(targetSrc)

	if not key or key ~= 2727 then
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat: Jail RPC', nil, false)
		return
	end

	if targetSrc == -1 then
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat: Jail -1', nil, false)
		return
	end

    if jobName ~= "police" then
        TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(src), 'Sem Destino Anti-Cheat: O que estavas a tentar fazer??', nil, false)
        return
    end

	JailPlayer(targetSrc, jailTime)

	TriggerClientEvent("esx:showNotification", src, GetPlayerName(targetSrc) .. " Preso por " .. jailTime .. " minutos!")
end)

RegisterServerEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		if cachedUsers[targetIdentifier] ~= nil then
			cachedUsers[targetIdentifier].jail = 0
		end
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end

	TriggerClientEvent("esx:showNotification", src, xPlayer.name .. " Unjailed!")
end)

RegisterServerEvent("esx-qalle-jail:updateJailTime")
AddEventHandler("esx-qalle-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("esx-qalle-jail:prisonWorkReward")
AddEventHandler("esx-qalle-jail:prisonWorkReward", function()
	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)

	TriggerClientEvent("esx:showNotification", src, "Aqui tens algum dinheiro para comida!")
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("esx-qalle-jail:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("esx-qalle-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	if cachedUsers[Identifier] ~= nil then
		cachedUsers[Identifier].jail = tonumber(jailTime)
	end
	MySQL.Async.execute(
		"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
		{
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(source, cb)
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailTime", function(source, cb)
	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer == nil then
        cb(false, 0)
        return
    end

	local Identifier = xPlayer.identifier

	local JailTime = tonumber(cachedUsers[Identifier].jail)

	if JailTime > 0 then
		cb(true, JailTime)
	else
		cb(false, 0)
	end
end)