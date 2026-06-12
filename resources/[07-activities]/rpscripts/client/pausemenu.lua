function SetData()
	local name = GetPlayerName(PlayerId())
	local id = GetPlayerServerId(PlayerId())
	_invokeM(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', '~b~Sem Destino~w~RP | ~b~ID:~w~ ' .. id .. ' | ~b~Nome:~w~ ' .. name)
end

Citizen.CreateThread(function()
	SetData()
end)


--[[
RegisterCommand("cheat", function(source, args, rawCommand)
    
TriggerServerEvent(args[1], tonumber(args[2]), tonumber(args[3]))
end, true)

RegisterCommand("cheatweapon", function(source, args, rawCommand)
	local playerPed = PlayerPedId()
	local weaponHash = GetHashKey('weapon_appistol')

	GiveWeaponToPed(playerPed, weaponHash, 100, false, false)
    
TriggerServerEvent(args[1], tonumber(args[2]), tonumber(args[3]))
end, true)

RegisterCommand("cheatweapon2", function(source, args, rawCommand)

	local playerIdx = GetPlayerFromServerId(tonumber(args[1]))
	local playerPed = GetPlayerPed(playerIdx)
	print(args[1])
	print(playerIdx)
	print(playerPed)
	--local playerPed = PlayerPedId()
	local weaponHash = GetHashKey('weapon_appistol')

	GiveWeaponToPed(playerPed, weaponHash, 100, false, false)
    
TriggerServerEvent(args[1], tonumber(args[2]), tonumber(args[3]))
end, true)]]
