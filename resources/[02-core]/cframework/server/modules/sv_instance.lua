local instances = {}
local universes = {}

AddEventHandler('playerDropped', function(reason)
	if instances[source] then
		CloseInstance(source)
	end
end)

function CreateInstance(type, player, data)
	instances[player] = {
		type    = type,
		host    = player,
		players = {},
		data    = data
	}

	TriggerEvent('instance:onCreate', instances[player])
	TriggerClientEvent('instance:onCreate', player, instances[player])

	local universe = 2

	for i = 2,255,1 do
		if universes[i] == nil then
			universes[i] = true
			universe = i
			break
		end
	end

	SetPlayerRoutingBucket(player, universe)
end

function CloseInstance(instance)
	if instances[instance] then
		local universe = GetPlayerRoutingBucket(instances[instance].host)

		SetPlayerRoutingBucket(instances[instance].host, 0)

		universes[universe] = nil

		for i=1, #instances[instance].players do
			SetPlayerRoutingBucket(instances[instance].players[i], 0)
			TriggerClientEvent('instance:onClose', instances[instance].players[i])
		end

		instances[instance] = nil

		TriggerEvent('instance:onClose', instance)
	end
end

function AddPlayerToInstance(instance, player)
	local found = false

	for i=1, #instances[instance].players do
		if instances[instance].players[i] == player then
			found = true
			break
		end
	end

	if not found then
		table.insert(instances[instance].players, player)
	end

	local universe = GetPlayerRoutingBucket(instances[instance].host)

	SetPlayerRoutingBucket(player, universe)

	TriggerClientEvent('instance:onEnter', player, instances[instance])

	for i=1, #instances[instance].players do
		if instances[instance].players[i] ~= player then
			TriggerClientEvent('instance:onPlayerEntered', instances[instance].players[i], instances[instance], player)
		end
	end
end

function RemovePlayerFromInstance(instance, player)
	if instances[instance] then
		TriggerClientEvent('instance:onLeave', player, instances[instance])

		if instances[instance].host == player then
			for i=1, #instances[instance].players do
				if instances[instance].players[i] ~= nil and instances[instance].players[i] ~= player then
					TriggerClientEvent('instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end
			end

			CloseInstance(instance)
		else
			for i=1, #instances[instance].players do
				if instances[instance].players[i] == player then
					SetPlayerRoutingBucket(player, 0)
					instances[instance].players[i] = nil
				end
			end

			for i=1, #instances[instance].players do
				if instances[instance].players[i] ~= player and instances[instance].players[i] ~= nil then
					TriggerClientEvent('instance:onPlayerLeft', instances[instance].players[i], instances[instance], player)
				end

			end
		end
	end
end

function InvitePlayerToInstance(instance, type, player, data)
	TriggerClientEvent('instance:onInvite', player, instance, type, data)
end


RegisterServerEvent('instance:create')
AddEventHandler('instance:create', function(type, data)
	CreateInstance(type, source, data)
end)

RegisterServerEvent('instance:close')
AddEventHandler('instance:close', function()
	CloseInstance(source)
end)

RegisterServerEvent('instance:enter')
AddEventHandler('instance:enter', function(instance)
	AddPlayerToInstance(instance, source)
end)

RegisterServerEvent('instance:leave')
AddEventHandler('instance:leave', function(instance)
	RemovePlayerFromInstance(instance, source)
end)

RegisterServerEvent('instance:invite')
AddEventHandler('instance:invite', function(instance, type, player, data)
	InvitePlayerToInstance(instance, type, player, data)
end)
