ESX = nil
local modelos = {}
local modelospreco = {}
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	TriggerServerEvent("esx_vehicleshop:lista")
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('esx_vehicleshop:sendVehicles')
AddEventHandler('esx_vehicleshop:sendVehicles', function(vehicles)
	modelos = {}
	modelospreco = {}
	for k,v in pairs(vehicles) do
		modelos[GetHashKey(v.model)] = v.name
		modelospreco[GetHashKey(v.model)] = v.price
	end	
end)

RegisterNetEvent('okokContract:GetVehicleInfo')
AddEventHandler('okokContract:GetVehicleInfo', function(source_playername, date, description, price, source, target, targetName)
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local sellerID = source
	local imposto = 500000

		local vehicle = ESX.Game.GetClosestVehicle(coords)
		local vehiclecoords = GetEntityCoords(vehicle)
		local vehDistance = GetDistanceBetweenCoords(coords, vehiclecoords, true)
		if DoesEntityExist(vehicle) and (vehDistance <= 3) then
			local vehProps = ESX.Game.GetVehicleProperties(vehicle)
			--ESX.TriggerServerCallback("okokContract:GetTargetName", function(targetName)
				
				if modelospreco[GetEntityModel(vehicle, false)] ~= nil then
					if modelospreco[GetEntityModel(vehicle, false)] < 500000 then
						imposto = 0
					else
						imposto = math.floor(modelospreco[GetEntityModel(vehicle, false)] * 0.05)
					end
					if imposto > 500000 then imposto = 500000 end
				end
				
				SetNuiFocus(true, true)
				SendNUIMessage({
					action = 'openContractSeller',
					plate = vehProps.plate,
					model = modelos[GetEntityModel(vehicle, false)] or GetDisplayNameFromVehicleModel(vehProps.model),
					source_playername = source_playername,
					sourceID = sellerID,
					target_playername = targetName,
					targetID = target,
					date = date,
					description = description,
					price = price,
					price2 = imposto,
					price3 = tonumber(price) + tonumber(imposto)				
				})
			--end, target)
		else
			ClearPedTasks(PlayerPedId())
			exports['okokNotify']:Alert("CONTRATO", "Tens de estar perto de um veículo", 10000, 'error')
		end
	--else
		--ClearPedTasks(PlayerPedId())
		--exports['okokNotify']:Alert("CONTRATO", "Tens de estar perto de alguém ", 10000, 'error')
	--end
end)

RegisterNetEvent('okokContract:OpenContractInfo')
AddEventHandler('okokContract:OpenContractInfo', function()
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractInfo'
	})
end)

RegisterNetEvent('okokContract:OpenContractOnBuyer')
AddEventHandler('okokContract:OpenContractOnBuyer', function(data)
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'openContractOnBuyer',
		plate = data.plateNumber,
		model = data.vehicleModel,
		source_playername = data.sourceName,
		sourceID = data.sourceID,
		target_playername = data.targetName,
		targetID = data.targetID,
		date = data.date,
		description = data.description,
		price = data.price,
		price2 = data.price2,
		price3 = data.price3
	})
end)

RegisterNUICallback("action", function(data, cb)
	if data.action == "submitContractInfo" then		
		local closestPlayer, playerDistance = ESX.Game.GetClosestPlayer()
		local target = GetPlayerServerId(closestPlayer)
		----REMOVER LINHA----local target = 3

		if (closestPlayer ~= -1 and playerDistance <= 3.0) then
			TriggerServerEvent("okokContract:SendVehicleInfo", data.vehicle_description, data.vehicle_price, target)
		else
			exports['okokNotify']:Alert("CONTRATO", "Tens de estar perto de alguém ", 10000, 'error')
		end
		SetNuiFocus(false, false)
	elseif data.action == "signContract1" then
		TriggerServerEvent("okokContract:SendContractToBuyer", data)
		--ClearPedTasks(PlayerPedId())
		ExecuteCommand('animcancelar')
		SetNuiFocus(false, false)
	elseif data.action == "signContract2" then
		if data.sourceIDSeller < 0 or data.sourceIDSeller > 99999 then
			TriggerServerEvent("esx_boat:comprabarco_done", data)
		else
			TriggerServerEvent("okokContract:changeVehicleOwner", data)
			--ClearPedTasks(PlayerPedId())
			ExecuteCommand('animcancelar')
		end
		SetNuiFocus(false, false)
	elseif data.action == "close" then
		--ClearPedTasks(PlayerPedId())
		ExecuteCommand('animcancelar')
		SetNuiFocus(false, false)
	end
end)

RegisterNetEvent('okokContract:startContractAnimation')
AddEventHandler('okokContract:startContractAnimation', function(player)
	ExecuteCommand('e clipboard')
end)

--function loadAnimDict(dict)
--	while (not HasAnimDictLoaded(dict)) do
--		RequestAnimDict(dict)
--		Citizen.Wait(0)
--	end
--end

