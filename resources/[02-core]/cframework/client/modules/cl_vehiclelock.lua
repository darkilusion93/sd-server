

local VehicleList = {}

function table.empty(tabela)
	if tabela == nil then return false end
	for _, _ in pairs(tabela) do return false end
	return true
end

local function findVehicle(plate)
	for _,v in pairs(VehicleList) do
		if v.plate == plate then
			return true
		end
	end

	return false
end

local function playLockAnim()
	local dict <const> = "anim@mp_player_intmenu@key_fob@"

	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(100)
		end
	end

	TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
end

local function useLock()
	local player <const> = PlayerPedId()
	local pos <const> = GetEntityCoords(player)
	local vehicle <const> = GetVehiclePedIsIn(player,true)
	local vehicleplate <const> = GetVehicleNumberPlateText(vehicle)
	local islocked <const> = GetVehicleDoorLockStatus(vehicle)

	local clostestvehicle, closestDistance <const> = ESX.Game.GetClosestVehicle()

    if closestDistance > 10.0 then
        clostestvehicle = 0
    end

	local clostestvehicleplate <const> = GetVehicleNumberPlateText(clostestvehicle)
	local islockedclostestvehicle <const> = GetVehicleDoorLockStatus(clostestvehicle)

	local entityWorld <const> = GetOffsetFromEntityInWorldCoords(player, 0.0, 20.0, 0.0)
	local rayHandle <const> = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 7, player, 0)
	local _, _, _, _, vehicleHandle <const> = GetRaycastResult(rayHandle)
	local vehicleHandleplate <const>, islockedHandle <const> = GetVehicleNumberPlateText(vehicleHandle), GetVehicleDoorLockStatus(vehicleHandle)

	local foundclostestvehicle, isvehiclefound = false, false


	if not DoesEntityExist(vehicle) then
		if DoesEntityExist(vehicleHandle) and clostestvehicleplate ~= nil then
			if not findVehicle(clostestvehicleplate) then
				ESX.ShowNotification("O veículo que você deseja abrir está fechado.", 'error')
				return false
			end

			if islockedHandle == 1 then
				TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicleHandle), 2)
				ESX.ShowNotification("O veículo está fechado.", 'error')
				playLockAnim()
			else
				TriggerServerEvent("cframework:setLockStatus",NetworkGetNetworkIdFromEntity(vehicleHandle), 1)
				ESX.ShowNotification("O veículo está aberto.", 'success')
				playLockAnim()
			end
		end

		return false
	end

	if not IsPedInAnyVehicle(player, false) and not IsPedInAnyHeli(player) then
		if table.empty(VehicleList) then
			ESX.ShowNotification("Nenhum veículo para fechar ou o veículo está fechado.", 'error')
			return false
		end

		if vehicleHandleplate == nil and clostestvehicleplate == nil then
			ESX.ShowNotification("Nenhum veículo proximo a você!", 'error')
			return false
		end

		if findVehicle(clostestvehicleplate) then
			isvehiclefound = true
			foundclostestvehicle = true
		end

		if not foundclostestvehicle and findVehicle(vehicleHandleplate) then
			isvehiclefound = true
		end

		if not isvehiclefound then
			ESX.ShowNotification("O veículo que você deseja abrir, não está disponível para você.", 'error')
			return false
		end

		if not foundclostestvehicle then
			if islockedHandle == 1 then
				TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicleHandle), 2)
				ESX.ShowNotification("O veículo está fechado.", 'error')
				playLockAnim()
			else
				TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicleHandle), 1)
				ESX.ShowNotification("O veículo está aberto.", 'success')
				playLockAnim()
			end
		else
			if islockedclostestvehicle == 1 then
				TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(clostestvehicle), 2)
				ESX.ShowNotification("O veículo está fechado.", 'error')
				playLockAnim()
				SetVehicleLights(clostestvehicle, 2) Wait (400)
				SetVehicleLights(clostestvehicle, 0) Wait (400)
				SetVehicleLights(clostestvehicle, 2) Wait (400)
				SetVehicleLights(clostestvehicle, 0) Wait (50)
				StartVehicleHorn(clostestvehicle, 100, 1, false)
			else
				TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(clostestvehicle),1)
				ESX.ShowNotification("O veículo está aberto.", 'success')
				playLockAnim()
				SetVehicleLights(clostestvehicle, 2) Wait (400)
				SetVehicleLights(clostestvehicle, 0) Wait (400)
				SetVehicleLights(clostestvehicle, 2) Wait (400)
				SetVehicleLights(clostestvehicle, 0) Wait (50)
				StartVehicleHorn(clostestvehicle, 100, 1, false)
			end

		end

		return true
	end

	if vehicleplate == nil then
		ESX.ShowNotification("Nenhum veículo proximo a ti!", 'error')
		return false
	end

    local ped <const> = GetPedInVehicleSeat(vehicle, -1)

    if ped ~= player then
        ESX.ShowNotification("Tens que ser condutor para tirar as chaves do veículo.", 'error')
        return false
    end

	if table.empty(VehicleList) then
		TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicle), 2)
		ESX.ShowNotification("Pegaste as chaves do carro", 'inform')
		table.insert(VehicleList, {plate = vehicleplate})

		TriggerServerEvent("cframework:sendLockData", VehicleList)
		return true
	end

	if not findVehicle(vehicleplate) then
		if islocked == 1 then
			TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicle), 2)
			ESX.ShowNotification("Pegaste as chaves do carro", 'inform')
			table.insert(VehicleList, {plate = vehicleplate})

			TriggerServerEvent("cframework:sendLockData", VehicleList)
		else
			TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicle), 1)
			ESX.ShowNotification("O veículo está aberto.", 'success')
			playLockAnim()
		end

		return true
	end

	if islocked == 1 then
		TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicle), 2)
		ESX.ShowNotification("O veículo está fechado.", 'error')
		playLockAnim()
	else
		TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(vehicle), 1)
		ESX.ShowNotification("O veículo está aberto.", 'success')
		playLockAnim()
	end
end

Citizen.CreateThread(function()
	exports.ft_libs:AddButton("esx:vehiclelock", {
		key = 303,
		use = {
			callback = useLock,
		},
	})
end)

RegisterNetEvent("esx:playerLoaded", function()
	VehicleList = RPC.execute("getLockData")
	if VehicleList == nil then VehicleList = {} end
end)

Citizen.CreateThread(function()
	while true do
		local playerPed <const> = PlayerPedId()
		local vehicleIsPedEntering <const> = GetVehiclePedIsTryingToEnter(playerPed)

		if DoesEntityExist(vehicleIsPedEntering) then
			local lock <const> = GetVehicleDoorLockStatus(vehicleIsPedEntering)

			if lock == 7 then
				SetVehicleDoorsLocked(vehicleIsPedEntering, 2)
			end

			local ped <const> = GetPedInVehicleSeat(vehicleIsPedEntering, -1)

			--if DoesEntityExist(ped) then
				--SetPedCanBeDraggedOut(ped, false)
			--end
		end

		Citizen.Wait(500)
	end
end)
