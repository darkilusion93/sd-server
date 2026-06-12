


TriggerEvent('es:addGroupCommand', 'giveweapon', 'admin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	local xPlayer    = ESX.GetPlayerFromId(args[1])
    local inventory  = xPlayer.getInvContainer()
	local weaponName = string.upper(args[2])

	local weaponLabel = ESX.GetWeaponLabel(weaponName)

	if weaponLabel == nil then TriggerClientEvent('esx:showNotification', source, 'Arma não existe.', 'error') return end

	inventory.addItem(weaponName, 1, nil, {ammo = tonumber(args[3]) or 0})
	--ESX.logAdminItems(source, "WEAPON", tonumber(args[1]), weaponName, weaponLabel, tonumber(args[3]))
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveweapon'), params = {{name = "id", help = _U('id_param')}, {name = "weapon", help = _U('weapon')}, {name = "ammo", help = _U('amountammo')}}})
