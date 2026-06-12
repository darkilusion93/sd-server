local onShowVehicles = {}

RegisterNetEvent("cframework:buyOrgVehicle", function(model, pos, head, type)
	local source <const> = source
	local vehicleData = nil
	local job <const> =	ESX.getJob(source)

	if ESX.orgStandVehicles[job.name] ~= nil then
		for i=1, #ESX.orgStandVehicles[job.name], 1 do
			if ESX.orgStandVehicles[job.name][i].value == model then
				vehicleData = ESX.orgStandVehicles[job.name][i]
				break
			end
		end
	end

	if ESX.orgStandVehicles[job.name .. "2"] ~= nil then
		for i=1, #ESX.orgStandVehicles[job.name .. "2"], 1 do
			if ESX.orgStandVehicles[job.name .. "2"][i].value == model then
				vehicleData = ESX.orgStandVehicles[job.name .. "2"][i]
				break
			end
		end
	end

	if vehicleData == nil then return false end

	TriggerEvent("esx_addonaccount:getSharedAccount", "society_" .. job.name, function(account)

		if account.money >= vehicleData.price then
			account.removeMoney(vehicleData.price)

			local generatedPlate <const> = ESX.GeneratePlate()
			local vehicleProps <const> = {model = GetHashKey(model), plate = generatedPlate}
            local closestZone <const> = ESX.getClosestGarageZone(pos)

			ESX.addVehicle(source, {vehicle = vehicleProps, stored = true, plate = vehicleProps.plate, type = type, zone = closestZone}, true)

			local v = CreateVehicle(GetHashKey(model), pos.x, pos.y, pos.z, head, true, false)

			SetVehicleNumberPlateText(v, vehicleProps.plate)
			TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

			ESX.setVehiclePlate(v, vehicleProps.plate)

			--ESX.logOrgData(source, "COMPRAR", vehicleData.value, 1, job.name, job.label, vehicleData.label)
		end

	end)
end)

RegisterNetEvent("cframework:showOrgVehicle", function(model, pos, head)
	local source <const> = source
	local vehicleData = nil
	local job <const> =	ESX.getJob(source)

	if ESX.orgStandVehicles[job.name] ~= nil then
		for i=1, #ESX.orgStandVehicles[job.name], 1 do
			if ESX.orgStandVehicles[job.name][i].value == model then
				vehicleData = ESX.orgStandVehicles[job.name][i]
				break
			end
		end
	end

	if ESX.orgStandVehicles[job.name .. "2"] ~= nil then
		for i=1, #ESX.orgStandVehicles[job.name .. "2"], 1 do
			if ESX.orgStandVehicles[job.name .. "2"][i].value == model then
				vehicleData = ESX.orgStandVehicles[job.name .. "2"][i]
				break
			end
		end
	end

	if vehicleData == nil then return false end

	if onShowVehicles[job.name] ~= nil and DoesEntityExist(onShowVehicles[job.name]) then
		DeleteEntity(onShowVehicles[job.name])
		onShowVehicles[job.name] = nil
	end

	local v = CreateVehicle(GetHashKey(model), pos.x, pos.y, pos.z, head, true, false)

	local curTime <const> = os.time()

	while not DoesEntityExist(v) do
		Citizen.Wait(0)

		if os.time() - curTime > 10 then return end
	end

	onShowVehicles[job.name] = v

    local plate <const> = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

	SetEntityRoutingBucket(v, 0)

	TriggerClientEvent("cframework:setVehicleUndrivable", source, NetworkGetNetworkIdFromEntity(v))
end)


RegisterNetEvent("cframework:cancelVehicleShow", function()
	local source = source
	local job <const> =	ESX.getJob(source)

	if onShowVehicles[job.name] == nil or not DoesEntityExist(onShowVehicles[job.name]) then
		return false
	end

	DeleteEntity(onShowVehicles[job.name])
	onShowVehicles[job.name] = nil
end)