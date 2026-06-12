

local isEquiping = {}
local isUsingBandage = {}

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
    local inventory <const> = ESX.getInvContainer(source)
    local qtty <const> = inventory.getItemAmount(item)

    cb(qtty)
end)

RegisterServerEvent('cframework:heal', function(target, type)
    TriggerClientEvent('cframework:heal', target, type)
end)

RegisterServerEvent('cframework:revive', function(target)
	local source <const> = source
	local job <const> = ESX.getJob(source)
    local inventory <const> = ESX.getInvContainer(source)

	if job.name ~= 'ambulance' then
		return
	end

	if not inventory.canRemoveItem("medikit", 1) then
		return
	end

    if not inventory.canAddItem("cash", Config.ReviveReward) then
		return
	end

	inventory.removeItem("medikit", 1)
    inventory.addItem("cash", Config.ReviveReward)
	TriggerClientEvent('esx_ambulancejob:revive', target)

	--ESX.logRevives(source, target, "REVIVE", "EMS")
end)

RegisterServerEvent('esx_ambulancejob:removeItem', function(item)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if item ~= 'medikit' and item ~= 'bandage' then
        return
    end

    if not inventory.canRemoveItem(item, 1) then
        return
    end

    inventory.removeItem(item, 1)

    if item == 'bandage' then
        TriggerClientEvent('esx:showNotification', source, _U('used_bandage'))
    elseif item == 'medikit' then
        TriggerClientEvent('esx:showNotification', source, _U('used_medikit'))
    end
end)


ESX.RegisterUsableItem('medikit', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("medikit", 1, slot) then return end

    inventory.removeItem("medikit", 1, slot)

  	TriggerClientEvent('cframework:heal', source, 'big')
end)

ESX.RegisterUsableItem('bandage', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("bandage", 1, slot) then return end
	if isUsingBandage[source] then return end

	if GetEntityHealth(GetPlayerPed(source)) < 100 then return end

	isUsingBandage[source] = true
	inventory.removeItem("bandage", 1, slot)
	TriggerClientEvent("cframework:applyingBandage", source)

	Citizen.SetTimeout(3000, function()
		TriggerClientEvent('cframework:heal', source, 'small')
		isUsingBandage[source] = false
	end)
end)

ESX.RegisterUsableItem('armor', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("armor", 1, slot) then return end

    if not isEquiping[source] then
        isEquiping[source] = true

        inventory.removeItem("armor", 1, slot)

        TriggerClientEvent("cframework:applyingArmor", source)
        Citizen.SetTimeout(5000, function()
            TriggerClientEvent('cframework:applyArmour', source)
            isEquiping[source] = false
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Ainda estás a equipar o colete.', "error")
    end
end)

ESX.RegisterUsableItem('armor2', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("armor2", 1, slot) then return end

    if not isEquiping[source] then
        isEquiping[source] = true

        inventory.removeItem("armor2", 1, slot)

        TriggerClientEvent("cframework:applyingArmor2", source)
        Citizen.SetTimeout(10000, function()
            TriggerClientEvent('cframework:applyArmour2', source)
            isEquiping[source] = false
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Ainda estás a equipar o colete.', "error")
    end
end)

ESX.RegisterUsableItem('armor3', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("armor3", 1, slot) then return end

    if not isEquiping[source] then
        isEquiping[source] = true

        inventory.removeItem("armor3", 1, slot)

        TriggerClientEvent("cframework:applyingArmor3", source)
        Citizen.SetTimeout(15000, function()
            TriggerClientEvent('cframework:applyArmour3', source)
            isEquiping[source] = false
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Ainda estás a equipar o colete.', "error")
    end
end)

ESX.RegisterUsableItem('synthetic_armor', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

    if not inventory.canRemoveItem("synthetic_armor", 1, slot) then return end

    if not isEquiping[source] then
        isEquiping[source] = true

        inventory.removeItem("synthetic_armor", 1, slot)

        TriggerClientEvent('esx:showNotification', source, 'Estás a equipar o colete.', "inform")
        Citizen.SetTimeout(20000, function()
            TriggerClientEvent('cframework:applyArmour2', source)
            isEquiping[source] = false
        end)
    else
        TriggerClientEvent('esx:showNotification', source, 'Ainda estás a equipar o colete.', "error")
    end
end)

TriggerEvent('es:addGroupCommand', 'revive', 'mod', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	if args[1] ~= nil then
		if GetPlayerName(args[1]) ~= nil then
			TriggerClientEvent('esx_ambulancejob:revive', args[1])
			--ESX.logRevives(source, tonumber(args[1]), "REVIVE", "STAFF")
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive', source)
		--ESX.logRevives(source, source, "REVIVE", "STAFF")
	end
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficient Permissions.")
end, {help = _U('revive_help'), params = {{name = 'id'}}})


RegisterServerEvent('esx_ambulancejob:setDeathStatus', function()
	ESX.setDead(source, 0, {})
end)

RegisterServerEvent('cframework:setDeathStatus', function(isDead, bleeding, area)
	ESX.setDead(source, isDead, {
		bleeding = bleeding,
		area = area,
		time = os.time()
	})
end)

--/med
RegisterServerEvent('medSystem:print', function(req, pulse, area, blood, x, y, z, bleeding, playerTable)
	local source = source

	for player, _ in pairs(playerTable) do
		TriggerClientEvent('3dme:shareDisplay', player, '* ' .. pulse .. ' BPM, Sangue - ' .. blood .. ', Zona Afetada - ' .. area .. ', Sangrar - ' .. bleeding .. ' *', source)
	end
end)

RegisterCommand('med', function(source, args)
	if args[1] ~= nil and tonumber(args[1]) ~= -1 then
		if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(args[1]))) < 5.0 then
			TriggerClientEvent('3dme:forceDisplay', source, {'Medir', 'pulsação', 'do', 'indivíduo'})
			TriggerClientEvent('medSystem:send', args[1], source)
		else
			TriggerClientEvent('esx:showNotification', source, 'Aproxima-te da pessoa.', 'error')
		end
	else
		TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Incorrect player ID!")
	end	
end, false)

RPC.register('esx_ambulancejob:removeItemsAfterRPDeath', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.getInvContainer().empty()

	TriggerClientEvent('esx:showNotification', xPlayer.source, _U('respawn_fine', Config.RespawnFineAmount), 'inform')
	xPlayer.removeAccountMoney('bank', Config.RespawnFineAmount)
end)