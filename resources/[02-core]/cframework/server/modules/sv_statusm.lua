

function GetDefaultStatus()
    local data = {}

    for i=1, #ESX.Status, 1 do
        table.insert(data, {
            name = ESX.Status[i].name,
            val  = ESX.Status[i].val
        })
    end

    return data
end

AddEventHandler("cframework:getStatus", function(playerId, statusName, cb)
	local xPlayer <const> = ESX.GetPlayerFromId(playerId)
	local status <const> = xPlayer.status

	for i=1, #status, 1 do
		if status[i].name == statusName then
			cb(status[i])
			break
		end
	end
end)

RegisterServerEvent("cframework:setStatus", function(status)
    local source <const> = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.status = status
	end
end)
