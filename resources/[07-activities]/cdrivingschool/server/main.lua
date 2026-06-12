ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('cdrivingschool:loadLicenses', source, licenses)
	end)
end)

RPC.register('addDrivingLicense', function(type)
	local _source = source

	-- FIX (2026-06-12): só licenças da escola (chaves de Config.Prices). Antes
	-- dava QUALQUER licença grátis, incluindo porte de arma.
	-- TODO: exigir teste passado/pagamento antes de conceder.
	if Config.Prices[type] == nil then return end

	TriggerEvent('esx_license:addLicense', _source, type, function()
		TriggerEvent('esx_license:getLicenses', _source, function(licenses)
			TriggerClientEvent('cdrivingschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('cdrivingschool:pay', function(rtype)
	local _source = source
    local inventory <const> = ESX.getInvContainer(_source)
	local price = Config.Prices[rtype]

    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent('esx:showNotification', _source, "Não tens dinheiro suficiente", 'error')
        return
    end

    inventory.removeItem("cash", price)
    TriggerClientEvent('esx:showNotification', _source, _U('you_paid', price), 'inform')

	local vehHash = Config.VehicleModels[rtype]

	if vehHash ~= nil then
		local v = CreateVehicle(vehHash, Config.Zones.VehicleSpawnPoint.Pos.x, Config.Zones.VehicleSpawnPoint.Pos.y, Config.Zones.VehicleSpawnPoint.Pos.z, Config.Zones.VehicleSpawnPoint.Pos.h, true, true)

		local plate = ESX.generateRandomString()

		SetVehicleNumberPlateText(v, plate)
		ESX.setVehiclePlate(v, plate)

		TaskWarpPedIntoVehicle(GetPlayerPed(_source), v, -1)

        TriggerClientEvent('cdrivingschool:startTest', _source, rtype)
	end
end)
