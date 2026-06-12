local instance, instancedPlayers, registeredInstanceTypes, playersToHide = {}, {}, {}, {}
local instanceInvite, insideInstance

function GetInstance()
	return instance
end

function CreateInstance(type, data)
	TriggerServerEvent('instance:create', type, data)
end

function CloseInstance()
	instance = {}

	TriggerServerEvent('instance:close')
	insideInstance = false
end

function EnterInstance(instance)
	insideInstance = true


	TriggerServerEvent('instance:enter', instance.host)

	if registeredInstanceTypes[instance.type].enter then
		registeredInstanceTypes[instance.type].enter(instance)
	end
end

function LeaveInstance()
	if instance.host then
		if #instance.players > 1 then
			ESX.ShowNotification(T("GENERIC_LEFT_CURRENT_PROPERTY"), "error")
		end

		if registeredInstanceTypes[instance.type].exit then
			registeredInstanceTypes[instance.type].exit(instance)
		end

		TriggerServerEvent('instance:leave', instance.host)
	end

	insideInstance = false
end

function InviteToInstance(type, player, data)
	TriggerServerEvent('instance:invite', instance.host, type, player, data)
end

function RegisterInstanceType(type, enter, exit)
	registeredInstanceTypes[type] = {
		enter = enter,
		exit  = exit
	}
end

AddEventHandler('instance:get', function(cb)
	cb(GetInstance())
end)

AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, data)
end)

AddEventHandler('instance:close', function()
	CloseInstance()
end)

AddEventHandler('instance:enter', function(_instance)
	EnterInstance(_instance)
end)

AddEventHandler('instance:leave', function()
	LeaveInstance()
end)

AddEventHandler('instance:invite', function(type, player, data)
	InviteToInstance(type, player, data)
end)

AddEventHandler('instance:registerType', function(name, enter, exit)
	RegisterInstanceType(name, enter, exit)
end)

RegisterNetEvent('instance:onInstancedPlayersData')
AddEventHandler('instance:onInstancedPlayersData', function(_instancedPlayers)
	instancedPlayers = _instancedPlayers
end)

RegisterNetEvent('instance:onCreate')
AddEventHandler('instance:onCreate', function(_instance)
	instance = {}
end)

RegisterNetEvent('instance:onEnter')
AddEventHandler('instance:onEnter', function(_instance)
	instance = _instance
end)

RegisterNetEvent('instance:onLeave')
AddEventHandler('instance:onLeave', function(_instance)
	instance = {}
end)

RegisterNetEvent('instance:onClose')
AddEventHandler('instance:onClose', function(_instance)
	instance = {}
end)

RegisterNetEvent('instance:onPlayerEntered')
AddEventHandler('instance:onPlayerEntered', function(_instance, player)
	instance = _instance
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

	ESX.ShowNotification((T("GENERIC_ENTERED_PROPERTY")):format(playerName), "inform")
end)

RegisterNetEvent('instance:onPlayerLeft')
AddEventHandler('instance:onPlayerLeft', function(_instance, player)
	instance = _instance
	local playerName = GetPlayerName(GetPlayerFromServerId(player))

    ESX.ShowNotification((T("GENERIC_LEFT_PROPERTY")):format(playerName), "inform")
end)

RegisterNetEvent('instance:onInvite')
AddEventHandler('instance:onInvite', function(_instance, type, data)
	instanceInvite = {
		type = type,
		host = _instance,
		data = data
	}

	Citizen.CreateThread(function()
		-- Controls for invite
		Citizen.CreateThread(function()
			while instanceInvite do
				Citizen.Wait(0)

				ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_ENTER_PROPERTY"))

				if IsControlJustReleased(0, 38) then
					EnterInstance(instanceInvite)
					instanceInvite = nil
				end
			end
		end)
		Citizen.Wait(10000)

		if instanceInvite then
			ESX.ShowNotification(T("GENERIC_INVITE_EXPIRED"), "error")
			instanceInvite = nil
		end
	end)
end)

RegisterInstanceType('default')

Citizen.CreateThread(function()
	TriggerEvent('instance:loaded')
end)
