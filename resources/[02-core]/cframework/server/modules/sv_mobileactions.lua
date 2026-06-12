


local function hasPlayerGotMobileActionPerm(source, value)
    local jobName <const> = ESX.getJob(source).name
    local hasPermission = false

    if Config.Stations[jobName] == nil then return false end
    if Config.Stations[jobName].MobileAction == nil then return false end

    for _, v in pairs(Config.Stations[jobName].MobileAction) do
        if v.value == value then
            hasPermission = true
            break
        end
    end

    return hasPermission
end

ESX.HasMobileActionPermission = function(source, value)
    if source == nil or source == 0 then
        return false
    end

    return hasPlayerGotMobileActionPerm(source, value)
end

RegisterServerEvent('cframework:putInVehicle', function(target)
    local source <const> = source
    local targetPed <const>, sourcePed <const> = GetPlayerPed(target), GetPlayerPed(source)

    if target == -1 then
        return
    end

    if not hasPlayerGotMobileActionPerm(source, "put_in_vehicle") then
        return
    end

    if not DoesEntityExist(targetPed) or not DoesEntityExist(sourcePed) then
        return
    end

    local targetCoords <const>, sourceCoords <const> = GetEntityCoords(targetPed), GetEntityCoords(sourcePed)

    if #(targetCoords - sourceCoords) > 3.0 then
        return
    end

    if DoesEntityExist(GetVehiclePedIsIn(targetPed, false)) then
        return
    end

    TriggerClientEvent('cframework:putInVehicle', target)
end)

RegisterServerEvent('cframework:OutVehicle', function(target)
    local source <const> = source
    local targetPed <const>, sourcePed <const> = GetPlayerPed(target), GetPlayerPed(source)

    if target == -1 then
        return
    end

    if not hasPlayerGotMobileActionPerm(source, "out_the_vehicle") then
        return
    end

    if not DoesEntityExist(targetPed) or not DoesEntityExist(sourcePed) then
        return
    end

    local targetCoords <const>, sourceCoords <const> = GetEntityCoords(targetPed), GetEntityCoords(sourcePed)

    if #(targetCoords - sourceCoords) > 3.0 then
        return
    end

    if not DoesEntityExist(GetVehiclePedIsIn(targetPed, false)) then
        return
    end

    local targetVehicle <const> = GetVehiclePedIsIn(targetPed, false)

    if targetVehicle == 0 then
        return
    end

    --TaskLeaveVehicle(targetPed, targetVehicle, 0)
    TriggerClientEvent("cframework:OutVehicle", target)
end)

ESX.RegisterServerCallback('esx_policejob:getFineList', function(source, cb, category)
	MySQL.Async.fetchAll('SELECT * FROM fine_types WHERE category = @category', {
		['@category'] = category
	}, function(fines)
		cb(fines)
	end)
end)

ESX.RegisterServerCallback('esx_orgs:getVehicleInfos', function(source, cb, plate)
	local foundIdentifier = nil

	local vehicle = ESX.getVehicleFromPlate(plate)

	if vehicle ~= nil then
		foundIdentifier = vehicle.owner
	end

    if foundIdentifier ~= nil then
        local ownerName = T("GENERIC_UNKOWN")

        if cachedUsers[foundIdentifier] and cachedUsers[foundIdentifier].firstname ~= nil and cachedUsers[foundIdentifier].lastname ~= nil then
            ownerName = cachedUsers[foundIdentifier].firstname .. " " .. cachedUsers[foundIdentifier].lastname
		else
			local users = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
				['@identifier'] = foundIdentifier
			})

			if users ~= nil and users[1] ~= nil and type(users[1].firstname) == "string" and type(users[1].lastname) == "string" then
				ownerName = users[1].firstname .. " " .. users[1].lastname
			end
        end

        local infos = {
            plate = plate,
            owner = ownerName
        }

        cb(infos)
    else
        local infos = {
        	plate = plate
        }

        cb(infos)
    end
end)