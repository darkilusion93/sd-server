local group = "admin"
local states = {}
states.frozen = false
states.frozenPos = nil
local adminCommandsDisabled = true

RegisterNetEvent('cframework:disableAdminCommands', function()
	adminCommandsDisabled = true
end)

RegisterNetEvent('cframework:enableAdminCommands', function()
	adminCommandsDisabled = false
end)

RegisterCommand("tpm", function()
    if group ~= "user" then
		if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end
		tpTillMarker()
	end
end, false)

RegisterCommand("menuadmin", function()
    if group ~= "user" then
		TriggerServerEvent('es_admin:getPlayers')
	end
end, false)

RegisterNetEvent('esx:playerLoaded', function(player)
	group = player.group
	if group ~= "user" then
		RegisterKeyMapping('tpm', 'TP para marcador', 'keyboard', 'INSERT')
		RegisterKeyMapping('menuadmin', 'Abre o menu admin', 'keyboard', 'PRIOR')
	end
end)

RegisterNetEvent('es_admin:openAdmin')
AddEventHandler('es_admin:openAdmin', function(players)
	if group ~= "user" then
		--SetNuiFocus(true, true)
		--SendNUIMessage({type = 'open', players = players})
	end
end)

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" then
		TriggerServerEvent('es_admin:all', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)

local noclip = false
RegisterNetEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(t, target)
	if t == "slay" then SetEntityHealth(PlayerPedId(), 0) end
	if t == "crash" then 

	end
	if t == "slap" then ApplyForceToEntity(PlayerPedId(), 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false) end
	if t == "noclip" then
		local msg = "Desligado"
		if(noclip == false)then
			noclip_pos = GetEntityCoords(PlayerPedId(), false)
		end

		noclip = not noclip

		if(noclip)then
			msg = "Ligado"
		end
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { "^*^1Servidor^0^*" , "Noclip ^2^*" .. msg}
		})
		--TriggerEvent("chatMessage", "Servidor", {255, 0, 0}, "Noclip ^2^*" .. msg)
	end
	if t == "freeze" then
		local player = PlayerId()

		local ped = PlayerPedId()

		states.frozen = not states.frozen
		states.frozenPos = GetEntityCoords(ped, false)

		if not state then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end

			FreezeEntityPosition(ped, false)
			SetPlayerInvincible(player, false)
		else
			SetEntityCollision(ped, false)
			FreezeEntityPosition(ped, true)
			SetPlayerInvincible(player, true)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end

		Citizen.CreateThread(function()
			while states.frozen do
				Citizen.Wait(0)
				ClearPedTasksImmediately(PlayerPedId())
				SetEntityCoords(PlayerPedId(), states.frozenPos)
			end
		end)
	end
end)

local heading = 0



RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

	local ped = PlayerPedId()

	states.frozen = state
	states.frozenPos = GetEntityCoords(ped, false)

	if not state then
		if not IsEntityVisible(ped) then
			SetEntityVisible(ped, true)
		end

		if not IsPedInAnyVehicle(ped) then
			SetEntityCollision(ped, true)
		end

		FreezeEntityPosition(ped, false)
		SetPlayerInvincible(player, false)
	else
		SetEntityCollision(ped, false)
		FreezeEntityPosition(ped, true)
		SetPlayerInvincible(player, true)

		if not IsPedFatallyInjured(ped) then
			ClearPedTasksImmediately(ped)
		end
	end

	Citizen.CreateThread(function()
		while states.frozen do
			Citizen.Wait(0)
			ClearPedTasksImmediately(PlayerPedId())
			SetEntityCoords(PlayerPedId(), states.frozenPos)
		end
	end)
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(x, y, z)
	SetEntityCoords(PlayerPedId(), x, y, z)
	states.frozenPos = {x = x, y = y, z = z}
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
	local ped = PlayerPedId()

	ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
	SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:heal')
AddEventHandler('es_admin:heal', function()
	SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()

end)

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "Desligado"
	if(noclip == false)then
		noclip_pos = GetEntityCoords(PlayerPedId(), false)
	end

	noclip = not noclip

	if(noclip)then
		msg = "Ligado"
		Citizen.CreateThread(function()
			while noclip do
				Citizen.Wait(0)
		
				if(noclip)then
					SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)
		
					if(IsControlPressed(1, 34))then
						heading = heading + 1.5
						if(heading > 360)then
							heading = 0
						end
		
						SetEntityHeading(PlayerPedId(), heading)
					end
		
					if(IsControlPressed(1, 9))then
						heading = heading - 1.5
						if(heading < 0)then
							heading = 360
						end
		
						SetEntityHeading(PlayerPedId(), heading)
					end
		
					if(IsControlPressed(1, 8))then
						noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
					end
		
					if(IsControlPressed(1, 32))then
						noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
					end
		
					if(IsControlPressed(1, 27))then
						noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
					end
		
					if(IsControlPressed(1, 173))then
						noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
					end
				end
			end
		end)
	end
	TriggerEvent('chat:addMessage', {
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { "^*^1Servidor^0^*" , "Noclip ^2^*" .. msg}
	})
	--TriggerEvent("chatMessage", "Servidor", {255, 0, 0}, "Noclip ^2^*" .. msg)
end)

RegisterNetEvent('es_admin:reparar')
AddEventHandler('es_admin:reparar', function()
	local playerPed = PlayerPedId()
    local carro = GetVehiclePedIsIn(playerPed, true)

	if adminCommandsDisabled then ESX.ShowNotification('Comando desativado', 'error') return end

    if IsPedInAnyVehicle(playerPed, true) then
		SetVehicleFixed(carro)
		SetVehicleDeformationFixed(carro)
		SetVehicleUndriveable(carro, false)
        SetVehicleDirtLevel(carro, 0)
        --exports['cframework']:SendAlert('inform', 'Carro tunado com sucesso', 4500, { ['background-color'] = '#99ff99', ['color'] = '#000000' })
    else
        --exports['cframework']:SendAlert('inform', 'Tens de estar dentro do veiculo para o reparar', 4500, { ['background-color'] = '#ff0000', ['color'] = '#000000' })
    end
end)

function tpTillMarker()
		local playerPed = GetPlayerPed(-1)
		local WaypointHandle = GetFirstBlipInfoId(8)
		if DoesBlipExist(WaypointHandle) then

		  local coord = _invokeM(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
		  --SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, coord.z, false, false, false, true)
		  SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
		  --ESX.ShowNotification('Teleporte com sucesso!')
		else
		  --ESX.ShowNotification('Não tem nenhum local marcado no mapa!')
		end
  end
