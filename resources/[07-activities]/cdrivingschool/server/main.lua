ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Licenças pagas e a aguardar teste, por jogador. O grant (addDrivingLicense)
-- é um RPC do cliente — sem isto, qualquer jogador o chamava e ganhava a licença
-- de graça (basta ter pago/iniciado o teste correspondente).
local pendingLicense = {}

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('cdrivingschool:loadLicenses', source, licenses)
	end)
end)

AddEventHandler('playerDropped', function()
	pendingLicense[source] = nil
end)

RPC.register('addDrivingLicense', function(type)
	local _source = source

	-- FIX (2026-06-12): só licenças da escola (chaves de Config.Prices). Antes
	-- dava QUALQUER licença grátis, incluindo porte de arma.
	if Config.Prices[type] == nil then return end

	-- FIX (2026-06-13): o jogador tem de ter pago este teste (cdrivingschool:pay)
	-- antes de a licença ser concedida. One-shot: consome o crédito do teste.
	if not (pendingLicense[_source] and pendingLicense[_source][type]) then return end
	pendingLicense[_source][type] = nil

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

    -- Guard: rtype tem de ser um teste real (senão price=nil rebenta o canRemoveItem).
    if not price then return end

    if not inventory.canRemoveItem("cash", price) then
        TriggerClientEvent('esx:showNotification', _source, "Não tens dinheiro suficiente", 'error')
        return
    end

    inventory.removeItem("cash", price)

    -- Marca o teste como pago — habilita o addDrivingLicense deste tipo quando passar.
    pendingLicense[_source] = pendingLicense[_source] or {}
    pendingLicense[_source][rtype] = true

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
