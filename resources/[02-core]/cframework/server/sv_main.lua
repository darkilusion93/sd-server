function InitPlayerLoad(source, permission_level, identifier, license, group)
	local _source = source

	local userData = {
		permissionLevel = permission_level,
		identifier 		= identifier,
		license 		= license,
		group 			= group,
		source			= source,
		accounts     	= {},
		inventory    	= {},
		job          	= {},
		vehicles	 	= {},
		bank		 	= 12500,
        coins        	= 2,
		playerName   	= GetPlayerName(_source),
		lastPosition 	= nil
	}

	local samePlayer = ESX.GetPlayerFromIdentifier(identifier)

	if samePlayer ~= nil and not ESX.DEV then
		DropPlayer(samePlayer.source, T("CONNECTING_SOMEONE_JOINED_USING_YOUR_ACCOUNT"))
	end

	if cachedVehicles[identifier] == nil then
		ESX.loadOwnerCars(identifier)
	end
	userData.vehicles = cachedVehicles[identifier]

	if cachedAccounts[identifier] == nil then
		ESX.loadUserAccounts(identifier)
	end
	userData.accounts = cachedAccounts[identifier]

	local result = cachedUsers[identifier]
	local job, grade = result.job, tostring(result.job_grade)

	if not ESX.DoesJobExist(job, grade) then job, grade = 'unemployed', '0' end

	local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

	userData.job = {}

	userData.job.id         = jobObject.id
	userData.job.name       = jobObject.name
	userData.job.label      = jobObject.label
    userData.job.metadata   = jobObject.metadata

	userData.job.grade        = tonumber(grade)
	userData.job.grade_name   = gradeObject.name
	userData.job.grade_label  = gradeObject.label
	userData.job.grade_salary = gradeObject.salary

	userData.job.skin_male    = {}
	userData.job.skin_female  = {}

	if gradeObject.skin_male ~= nil then
		userData.job.skin_male = gradeObject.skin_male
	end

	if gradeObject.skin_female ~= nil then
		userData.job.skin_female = gradeObject.skin_female
	end

	ESX.addSourceToJob(job, _source)

    -- Fetch the player's boost
    local extraSlots = MySQL.Sync.fetchScalar([[
        SELECT extra_slots FROM user_bags
        WHERE identifier = @identifier AND expires_at > NOW()
    ]], {['@identifier'] = identifier})

    userData.extraSlots = tonumber(extraSlots) or 0

	if result.bank ~= nil then
		userData.bank = tonumber(result.bank)
	end

	if result.coins ~= nil then
		userData.coins = tonumber(result.coins)
	end

    if result.boost_coins ~= nil then
		userData.boostCoins = tonumber(result.boost_coins)
	end

	if result.position ~= nil then
		userData.lastPosition = json.decode(result.position)
	end

	if result.phone_number ~= nil then
		userData.phone_number = result.phone_number
	end

	if result.armour ~= nil then
		userData.armour = result.armour
	end

	if result.isDead ~= nil then
		userData.isDead = result.isDead
	else
		userData.isDead = 0
	end

	if result.canReport ~= nil then
		userData.canReport = result.canReport
	end

	if result.experience ~= nil then
		userData.experience = json.decode(result.experience)
	end

    if result.status ~= nil then
		userData.status = json.decode(result.status)
    else
        userData.status = GetDefaultStatus()
	end

	if result.globalPlayTime ~= nil then
		userData.globalPlayTime = result.globalPlayTime
	end

	if result.vip ~= nil then
		userData.vip = result.vip
	end

	if result.firstname ~= nil then
		userData.firstname = result.firstname
	else
		userData.firstname = 'zé'
	end

	if result.lastname ~= nil then
		userData.lastname = result.lastname
	else
		userData.lastname = 'ruca'
	end

	if result.iban ~= nil then
		userData.iban = result.iban
	else
		local myIban = nil
		repeat
			myIban = ESX.getRandomIban()
			local id = ESX.getIdentifierByIban(myIban)
		until id == nil

		userData.iban = myIban
	end

    if result.citizen_id ~= nil then
		userData.citizenId = result.citizen_id
	end

	if result.health ~= nil then
		userData.health = result.health
	else
		userData.health = 200
	end

	if result.skin ~= nil then
		userData.skin = json.decode(result.skin)
	else
		userData.skin = nil
	end

	if result.communityservice ~= nil then
		userData.communityservice = result.communityservice
	else
		userData.communityservice = 0
	end

	if result.deathData ~= nil then
		userData.deathData = json.decode(result.deathData)
	end

	if result.citizen_id ~= nil then
		userData.citizenId = result.citizen_id
	else
        local myCitizenId = nil
		repeat
			myCitizenId = ESX.getRandomCitizenId()
			local id = ESX.getIdentifierByCitizenId(myCitizenId)
		until id == nil
		MySQL.Sync.execute("UPDATE users SET citizen_id = @citizenId WHERE identifier = @identifier", {
			['@citizenId'] = myCitizenId,
			['@identifier'] = identifier
		})
	end

	local xPlayer = CreateExtendedPlayer(userData)

    ESX.Players[_source] = xPlayer

    if xPlayer.getGroup() ~= 'user' then
        ESX.AdminPlayers[_source] = xPlayer
        --ESX.logStaffsIngame()
    end

    local society, societyMoney = GetSociety(xPlayer.getJob().name), 0

    if society then
        societyMoney = GetSharedAccount(society.account).money
    end

    if xPlayer.dead ~= 0 and xPlayer.dead ~= false then
        if xPlayer.deathData.time ~= nil then
            xPlayer.deathData.time = os.time()
        end
    end

    TriggerEvent('esx:playerLoaded', _source, xPlayer)

    TriggerClientEvent('esx:playerLoaded', _source, {
        identifier   = xPlayer.identifier,
        group     	 = xPlayer.getGroup(),
        health		 = userData.health,
        societyMoney = societyMoney,
        inventory    = xPlayer.getInventory(),
        invData      = xPlayer.getInvContainer().getInventory(),
        job          = xPlayer.getJob(),
        lastPosition = xPlayer.getLastPosition(),
        bank         = xPlayer.getBank(),
        armour		 = xPlayer.getArmour(),
        vehicles	 = xPlayer.getVehicles(),
        skin		 = xPlayer.getSkin(),
        isDead		 = xPlayer.isDead(),
        comserv		 = xPlayer.getActionsRemaining(),
        coins		 = xPlayer.getCoins(),
        boostCoins   = xPlayer.getBoostCoins(),
        deathData	 = xPlayer.deathData,
        experience	 = xPlayer.experience,
        status       = xPlayer.status,
    })
end

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer then
		ESX.removeSourceFromJob(xPlayer.job.name, _source)
		ESX.removeSourceFromCasino(_source)

		-- FXServer <3
		ExecuteCommand('remove_principal identifier.' .. xPlayer.identifier .. ' group.' .. xPlayer.group)

		TriggerEvent('esx:playerDropped', _source, reason)

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[_source] = nil
			if ESX.AdminPlayers[_source] ~= nil then
				ESX.AdminPlayers[_source] = nil
				--ESX.logStaffsIngame()
			end
		end)
	end
end)

RegisterServerEvent('cframework:restoreLoadout', function()
	local _source = source								--Request loadout
	local ped = GetPlayerPed(_source)											--Ped do player

	if ESX.isLoadoutLoaded(_source) then
		return
	end

	--RemoveAllPedWeapons(ped, true)												--Limpa armas
	SetPedArmour(ped, ESX.getArmour(_source))									--Devolve colete

	--for k,v in ipairs(loadout) do												--Das armas que tinha quando saiu
	--	local weaponName = v.name
	--	local weaponHash = GetHashKey(weaponName)

	--	GiveWeaponToPed(ped, weaponHash, v.ammo, false, false)					--Devolve arma

	--	for k2,v2 in ipairs(v.components) do
	--		local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash
	--		GiveWeaponComponentToPed(ped, weaponHash, componentHash)
	--	end
	--end

	ESX.setLoadoutLoaded(_source, true)
end)


RegisterServerEvent('cframework:deleteLastProperty', function()
	ESX.setOverrideCoords(source, nil)
end)

RegisterServerEvent('cframework:saveLastProperty', function(coords)
	ESX.setOverrideCoords(source, coords)
end)

RegisterServerEvent('esx:updateLastPosition', function(position)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.setLastPosition(position)
end)

RegisterServerEvent('esx:useItem', function(slot, itemName)
	local source = source
    local inventory = ESX.getInvContainer(source)
    local item = inventory.getItemInSlot(slot)

	if item ~= nil and item.count > 0 then
		ESX.UseItem(source, itemName, slot)
	else
		TriggerClientEvent('esx:showNotification', source, T("GENERIC_IMPOSSIBLE_ACTION"), 'error')
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		lastPosition = xPlayer.getLastPosition(),
		money        = xPlayer.getMoney()
	})
end)


--ESX.StartDBSync()


--[[
AddEventHandler('weaponDamageEvent', function(sender, data)
	local ped = NetworkGetEntityFromNetworkId(data.hitGlobalId)
	local target = NetworkGetEntityOwner(ped)

	if data.hitComponent == 20 or data.hitComponent == 19 then
		--local ped = NetworkGetEntityFromNetworkId(data.hitGlobalId)
		--local target = NetworkGetEntityOwner(ped)

		TriggerClientEvent('autodestruct', target)
	end
end)]]