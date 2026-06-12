

ESX.RegisterUsableItem('car_ownership_transfer', function(source, slot)
	local ped <const> = GetPlayerPed(source)
	local vehicle <const> = GetVehiclePedIsIn(ped, false)
    local inventory <const> = ESX.getInvContainer(source)
    local job <const> = ESX.getJob(source)

    if vehicle == nil or vehicle == 0 then TriggerClientEvent('esx:showNotification', source, T("VEHICLES_NOT_INSIDE"), 'error')
		return
	end

    if not inventory.canRemoveItem('car_ownership_transfer', 1, slot) then TriggerClientEvent('esx:showNotification', source, T("VEHICLES_DONT_HAVE_CONTRACT"), 'error')
        return
    end

	local plate <const> = GetVehicleNumberPlateText(vehicle)
    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate})

    if result ~= nil and result[1] ~= nil then -- Found vehicle
        if result[1].owner ~= ESX.getIdentifier(source) and result[1].owner ~= job.name then
            TriggerClientEvent('esx:showNotification', source, T("VEHICLES_DONT_OWN"), 'error')
            return
        end

        if result[1].owner == job.name and (job.grade_name ~= 'boss' or Config.Stations[job.name] == nil or not Config.Stations[job.name].CanBossAddCars) then
            TriggerClientEvent('esx:showNotification', source, T("ACTIONS_DONT_HAVE_ORG_PERMISSION"), 'error')
            return
        end
    else
        TriggerClientEvent('esx:showNotification', source, T("VEHICLES_DONT_OWN"), 'error')
        return
    end

	local closestPlayer <const>, closestDistance <const> = ESX.GetClosestPlayer(source)

	if closestPlayer == nil or closestPlayer == -1 or closestDistance > 4.0 then TriggerClientEvent('esx:showNotification', source, T("PLAYERS_NO_NEARBY"), 'error')
		return
	end

	inventory.removeItem('car_ownership_transfer', 1, slot)

	MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate',
	{
		['@owner'] = ESX.getIdentifier(closestPlayer),
		['@plate'] = plate,
	})

    if result[1].owner == ESX.getIdentifier(source) then
        ESX.ChangeVehicleOwnerRAM(plate, source, closestPlayer)
    elseif result[1].owner == job.name then
        ESX.ChangeVehicleOwnerRAM(plate, job.name, closestPlayer)
    end

	TriggerClientEvent('esx:showNotification', source, (T("VEHICLES_TRANSFERED_OWNERSHIP")):format(ESX.getFirstName(closestPlayer) .. ' ' .. ESX.getLastName(closestPlayer)), 'success')
	TriggerClientEvent('esx:showNotification', closestPlayer, T("VEHICLES_RECEIVE_OWNERSHIP"), 'success')

    --ESX.logTransfers(source, closestPlayer, "TRANSFERIR", "veículo", 1, plate)
end)