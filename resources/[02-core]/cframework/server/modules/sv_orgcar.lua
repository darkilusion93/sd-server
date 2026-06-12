-- Title  : sv_orgcar.lua
-- Author : Gonçalo Costa
-- Started: 05/08/24

ESX.RegisterUsableItem('business_car_ownership_transfer', function(source, slot)
	local ped <const> = GetPlayerPed(source)
	local vehicle <const> = GetVehiclePedIsIn(ped, false)
    local inventory <const> = ESX.getInvContainer(source)
    local job <const> = ESX.getJob(source)

    if job.grade_name ~= 'boss' or Config.Stations[job.name] == nil or Config.Stations[job.name].CanBossAddCars ~= true then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_DONT_HAVE_PERMISSION_OR_ORG"), 'error')
        return
    end

    if vehicle == nil or vehicle == 0 then TriggerClientEvent('esx:showNotification', source, T("VEHICLES_NOT_INSIDE"), 'error')
        return
    end

    local plate <const> = GetVehicleNumberPlateText(vehicle)
    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate})

    if result == nil or result[1] == nil or result[1].owner ~= ESX.getIdentifier(source) then
        TriggerClientEvent('esx:showNotification', source, T("VEHICLES_DONT_OWN"), 'error')
        return
    end

    inventory.removeItem('business_car_ownership_transfer', 1, slot)

    MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @owner, stored = @stored WHERE plate = @plate',
    {
        ['@owner'] = job.name,
        ['@stored'] = 1,
        ['@plate'] = plate,
    })

    ESX.ChangeVehicleOwnerRAM(plate, source, job.name)
    TriggerClientEvent('esx:showNotification', source, T("VEHICLES_TRANSFERED_TO_ORG"), 'success')
end)