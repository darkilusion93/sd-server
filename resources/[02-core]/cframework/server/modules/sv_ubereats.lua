local deliveryPoints = {
	vector3(-1129.15, 395.020, 69.65),
	vector3(-1103.56, 284.569, 63.09),
	vector3(-1473.55, -10.789, 54.52),
	vector3(-1532.20, -37.736, 56.38),
	vector3(-1545.79, -33.281, 56.89),
	vector3(-1464.42, 51.018, 53.98),
	vector3(-1470.73, 63.99, 51.17),
	vector3(-1504.20, 44.28, 53.95),
	vector3(-1585.73, 44.50, 59.00),
	vector3(-1619.67, 57.41, 60.79),
	vector3(-1615.33, 74.72, 60.41),
	vector3(-822.11, -28.94, 37.66),
	vector3(-877.12, 1.43, 43.06),
	vector3(-883.50, 19.95, 43.85),
	vector3(-904.48, 17.95, 45.37),
	vector3(-849.53, 103.97, 51.92),
	vector3(-851.21, 178.97, 68.72),
	vector3(-923.23, 178.72, 65.93),
	vector3(-954.20, 177.81, 64.36),
	vector3(-934.73, 123.06, 55.74),
	vector3(-950.38, 125.10, 56.44),
	vector3(-979.54, 147.44, 59.90),
	vector3(-1046.28, 209.78, 62.42),
	vector3(-1091.98, -923.61, 2.14),
	vector3(-1038.87, -891.09, 4.21),
	vector3(-948.60, -898.53, 1.16),
	vector3(-919.51, -952.21, 1.16),
	vector3(-933.55, -1081.31, 1.15),
	vector3(-954.99, -1083.37, 1.15),
	vector3(-1025.90, -1129.66, 1.17),
	vector3(-1061.07, -1155.34, 1.11),
	vector3(-1253.89, -1330.29, 3.02),
	vector3(-1106.54, -1534.97, 3.38),
	vector3(-1116.16, -1575.66, 3.38),
	vector3(-50.93, -1783.62, 27.30),
	vector3(13.64, -1850.13, 23.05),
	vector3(110.53, -1956.01, 19.75),
	vector3(151.61, -1896.33, 22.09),
	vector3(158.33, -1876.60, 22.98),
	vector3(221.90, -1720.81, 28.20),
	vector3(249.87, -1730.81, 28.66),
	vector3(263.07, -1704.09, 28.20),
	vector3(332.95, -1742.12, 28.73),
	vector3(326.57, -1763.93, 28.01),
	vector3(321.97, -1838.96, 26.22),
	vector3(440.62, -1840.96, 26.87),
	vector3(385.88, -1882.31, 24.83),
}

local cloakRoomLocation = {
	vector3(-1182.44, -883.4, 13.78),
}

local vehicleSpawner = {
    vector3(-1172.13, -876.09, 14.11),
}

local vehicleDeleter = {
    vector3(-1169.09, -883.49, 14.11),
}

local drinkPrice = 18
local foodPrice = 20
local uberVehicleHash = GetHashKey('faggio2')
local cautionSources = {}
local uberWorkTable = {}

RegisterNetEvent('cframework:enterUberService', function()
    local source = source

    if ESX.getJob(source).name ~= 'ubereats' then return end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then return end

    ESX.setService(source, true)
end)

RegisterNetEvent('cframework:exitUberService', function()
    local source = source

    if ESX.getJob(source).name ~= 'ubereats' then return end

    if not ESX.playerInsideLocation(source, cloakRoomLocation, 10.0) then return end

    ESX.setService(source, false)
end)

RegisterNetEvent('cframework:spawnUberVehicle', function()
	local source = source
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

	if vehicle ~= 0 then return end

	if not ESX.inService(source) then return end

	if not ESX.playerInsideLocation(source, vehicleSpawner, 10.0) then return end

	if cautionSources[source] then TriggerClientEvent('cframework:uberHasVehicle', source) return end

	local v = CreateVehicle(uberVehicleHash, -1177.22, -881.28, 13.94, 29.0, true, false)

	TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

    local plate = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

	cautionSources[source] = true

	if uberWorkTable[source] == nil then
		math.randomseed(GetGameTimer())

		uberWorkTable[source] = {
			coords = deliveryPoints[math.random(1, #deliveryPoints)],
			drink = {name = 'cocacola', count = math.random(6, 12)},
			food = {name = 'chips', count = math.random(4, 8)}
		}
	end

	TriggerClientEvent('cframework:uberGetJob', source, uberWorkTable[source])

	while not DoesEntityExist(v) do
		Citizen.Wait(0)
	end

	SetEntityRoutingBucket(v, 0)
end)

RegisterNetEvent('cframework:storeVehicle', function()
	local source = source
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

	if not DoesEntityExist(vehicle) then return end

	local hash = GetEntityModel(vehicle)

	if hash == uberVehicleHash then
		cautionSources[source] = nil
		uberWorkTable[source] = nil

		TriggerClientEvent('cframework:uberOutOfService', source)
	end
end)

RegisterNetEvent('cframework:uberFinishDelivery', function()
	local source = source
    local inventory <const> = ESX.getInvContainer(source)
	local curJob = uberWorkTable[source]
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

	if vehicle ~= 0 then return end
	if curJob == nil then return end

	if not ESX.playerInsideLocation(source, { curJob.coords }, 10.0) then
        return
    end

	if not ESX.passedCooldown(source, 19500) then
		return
	end

	if inventory.canRemoveItem(curJob.food.name, curJob.food.count) and inventory.canRemoveItem(curJob.drink.name, curJob.drink.count) and inventory.canAddItem("cash", curJob.food.count*foodPrice + curJob.drink.count*drinkPrice) then
		inventory.removeItem(curJob.food.name, curJob.food.count)
		inventory.removeItem(curJob.drink.name, curJob.drink.count)

		inventory.addItem("cash", curJob.food.count*foodPrice + curJob.drink.count*drinkPrice)


		math.randomseed(GetGameTimer())

		uberWorkTable[source] = {
			coords = deliveryPoints[math.random(1, #deliveryPoints)],
			drink = {name = 'cocacola', count = math.random(6, 12)},
			food = {name = 'chips', count = math.random(4, 8)}
		}

		TriggerClientEvent('cframework:uberGetJob', source, uberWorkTable[source])

		return true
	end

	TriggerClientEvent('cframework:uberCantFinishJob', source)
	TriggerClientEvent('cframework:uberGetJob', source, uberWorkTable[source])
end)
