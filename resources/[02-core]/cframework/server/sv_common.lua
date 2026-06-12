ESX                      = {}
ESX.Players              = {}
ESX.AdminPlayers         = {}
ESX.UsableItemsCallbacks = {}
ESX.Items                = {}
ESX.ServerCallbacks      = {}
ESX.TimeoutCount         = -1
ESX.CancelledTimeouts    = {}
ESX.Pickups              = {}
ESX.PickupId             = 0
ESX.Jobs                 = {}

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

AddEventHandler('esx:getShbuedaloucoaredObjbuedaloucoect', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

exports('getShbuedaloucoaredObjbuedaloucoect', function()
	return ESX
end)

ESX.RegisterJob = function(name, label, grades, whitelisted, maxMembers)
    ESX.Jobs[name] = {
        name = name,
        label = label,
        grades = grades,
        whitelisted = whitelisted or false,
        maxMembers = maxMembers or -1,
        metadata = {},
        sources = {}
    }

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs WHERE name = @name', {
        ['@name'] = name
    })

    if result == nil or #result == 0 then
        MySQL.Async.execute('INSERT INTO jobs (name, metadata) VALUES (@name, @metadata)', {
            ['@name'] = name,
            ['@metadata'] = json.encode({})
        })
    else
        ESX.Jobs[name].metadata = json.decode(result[1].metadata)
    end
end

Citizen.CreateThread(function()
    local jobs = LoadNonWhitelistedJobs()

    for jobName, jobInfo in pairs(jobs) do
        ESX.RegisterJob(jobName, jobInfo.label, jobInfo.grades, false, -1)
    end
end)


RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
	--RconPrint(msg .. "\n")
end)


--[[local targetSteam = "steam:11000016b233259"

AddEventHandler("cframework:setTargetLogEvents", function (steam)
    targetSteam = steam
end)]]

RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
	local _source = source
    --local pIdentifier = GetPlayerIdentifierByType(_source, 'steam')

    --if pIdentifier ~= nil and (pIdentifier == targetSteam or pIdentifier == "steam:1100001163ba035") then
    --    print("Player " .. _source .. " called callback " .. name)
    --
    --end

	ESX.TriggerServerCallback(name, requestId, _source, function(...)
		TriggerClientEvent('esx:serverCallback', _source, requestId, ...)
	end, ...)
end)
