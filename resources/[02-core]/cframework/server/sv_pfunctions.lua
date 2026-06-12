ESX.getBoostCoins = function(source)
    return ESX.Players[tonumber(source)].getBoostCoins()
end

ESX.setBoostCoins = function(source, boostCoins)
    ESX.Players[tonumber(source)].setBoostCoins(boostCoins)
end

ESX.getExtraSlots = function(source)
	return ESX.Players[tonumber(source)].getExtraSlots()
end

ESX.setExtraSlots = function(source, extraSlots)
	return ESX.Players[tonumber(source)].setExtraSlots(extraSlots)
end

ESX.getActionsRemaining = function(source)
	return ESX.Players[tonumber(source)].getActionsRemaining()
end

ESX.setActionsRemaining = function(source, actions)
	ESX.Players[tonumber(source)].setActionsRemaining(actions)
end

ESX.isLoadoutLoaded = function(source)
	return ESX.Players[tonumber(source)].isLoadoutLoaded()
end

ESX.setLoadoutLoaded = function(source, loaded)
	ESX.Players[tonumber(source)].setLoadoutLoaded(loaded)
end

ESX.isDead = function(source)
	return ESX.Players[tonumber(source)].isDead()
end

ESX.setDead = function(source, dead, deathData)
	ESX.Players[tonumber(source)].setDead(dead, deathData)
end

ESX.isLoadoutFlaged = function(source)
	return ESX.Players[tonumber(source)].isLoadoutFlaged()
end

ESX.setLoadoutFlaged = function(source, flaged)
	ESX.Players[tonumber(source)].setLoadoutFlaged(flaged)
end

ESX.setOverrideCoords = function(source, coords)
    TriggerEvent("cframework:playerSetOverrideCoords", source, coords)

	ESX.Players[tonumber(source)].setOverrideCoords(coords)
end

ESX.getOverrideCoords = function(source)
	return ESX.Players[tonumber(source)].getOverrideCoords()
end

ESX.passedCooldown = function(source, cooldown)
	return ESX.Players[tonumber(source)].passedCooldown(cooldown)
end

ESX.inService = function(source)
	return ESX.Players[tonumber(source)].inService()
end

ESX.setService = function(source, state)
	return ESX.Players[tonumber(source)].setService(state)
end

ESX.isTaxEvading = function(source)
	return ESX.Players[tonumber(source)].isTaxEvading()
end

ESX.setTaxEvading = function(source, state)
	ESX.Players[tonumber(source)].setTaxEvading(state)
end

ESX.inAdmin = function(source)
	return ESX.Players[tonumber(source)].inAdmin()
end

ESX.setAdmin = function(source, state)
	return ESX.Players[tonumber(source)].setAdmin(state)
end

ESX.getPlayTime = function(source)
	return ESX.Players[tonumber(source)].getPlayTime()
end

ESX.getFirstName = function(source)
	return ESX.Players[tonumber(source)].getFirstName()
end

ESX.getLastName = function(source)
	return ESX.Players[tonumber(source)].getLastName()
end

ESX.setFirstName = function(source, name)
	ESX.Players[tonumber(source)].setFirstName(name)
end

ESX.setLastName = function(source, name)
	ESX.Players[tonumber(source)].setLastName(name)
end

ESX.getSkin = function(source)
	return ESX.Players[tonumber(source)].getSkin()
end

ESX.setSkin = function(source, skin)
	ESX.Players[tonumber(source)].setSkin(skin)
end

ESX.getIban = function(source)
	return ESX.Players[tonumber(source)].getIban()
end

ESX.setMoney = function(source, money)
	ESX.Players[tonumber(source)].setMoney(money)
end		

ESX.getMoney = function(source)
	return ESX.Players[tonumber(source)].getMoney()
end

ESX.setBankBalance = function(source, money)
	ESX.Players[tonumber(source)].setBankBalance(money)
end

ESX.getBank = function(source)
	return ESX.Players[tonumber(source)].getBank()
end

ESX.addMoney = function(source, money)
	ESX.Players[tonumber(source)].addMoney(money)
end

ESX.removeMoney = function(source, money)
	ESX.Players[tonumber(source)].removeMoney(money)
end

ESX.getCoins = function(source)
	return ESX.Players[tonumber(source)].getCoins()
end

ESX.addCoins = function(source, coins)
	ESX.Players[tonumber(source)].addCoins(coins)
end

ESX.removeCoins = function(source, coins)
	ESX.Players[tonumber(source)].removeCoins(coins)
end

ESX.addBank = function(source, money)
	ESX.Players[tonumber(source)].addBank(money)
end

ESX.removeBank = function(source, money)
	ESX.Players[tonumber(source)].removeBank(money)
end

ESX.getIdentifier = function(source)
	return ESX.Players[tonumber(source)].getIdentifier()
end

ESX.getPhoneNumber = function(source)
	return ESX.Players[tonumber(source)].getPhoneNumber()
end

ESX.setPhoneNumber = function(source, phoneNumber)
	ESX.Players[tonumber(source)].setPhoneNumber(phoneNumber)
end

ESX.getInventory = function(source)
	return ESX.Players[tonumber(source)].getInventory()
end

ESX.getInvContainer = function(source)
    if ESX.Players[tonumber(source)] then
	    return ESX.Players[tonumber(source)].getInvContainer()
    end
end

ESX.getJob = function(source)
	return ESX.Players[tonumber(source)].getJob()
end

ESX.getName = function(source)
	return ESX.Players[tonumber(source)].getName()
end

ESX.canReport = function(source)
	return ESX.Players[tonumber(source)].canReport()
end

ESX.setName = function(source, newName)
	ESX.Players[tonumber(source)].setName(newName)
end

ESX.getLastPosition = function(source)
	return ESX.Players[tonumber(source)].getLastPosition()
end

ESX.setLastPosition = function(source, position)
	ESX.Players[tonumber(source)].setLastPosition(position)
end

ESX.getAccount = function(source, acc)
	return ESX.Players[tonumber(source)].getAccount(acc)
end

ESX.getAccounts2 = function(source)
	return ESX.Players[tonumber(source)].getAccounts2()
end

ESX.setAccountMoney = function(source, acc, money)
	ESX.Players[tonumber(source)].setAccountMoney(acc, money)
end

ESX.addAccountMoney = function(source, acc, money)
	ESX.Players[tonumber(source)].addAccountMoney(acc, money)
end

ESX.removeAccountMoney = function(source, a, m)
	ESX.Players[tonumber(source)].removeAccountMoney(a, m)
end

ESX.getInventoryItem = function(source, name)
	return ESX.Players[tonumber(source)].getInventoryItem(name)
end

ESX.addInventoryItem = function(source, name, count)
	ESX.Players[tonumber(source)].addInventoryItem(name, count)
end

ESX.addInventoryItemLimited = function(source, name, count)
	local xPlayer  = ESX.Players[tonumber(source)]
	local item = xPlayer.getInventoryItem(name)

	if item.count + count <= item.limit then
		xPlayer.addInventoryItem(name, count)
		return true
	else
		return false
	end
end

ESX.removeInventoryItem = function(source, name, count)
	ESX.Players[tonumber(source)].removeInventoryItem(name, count)
end

ESX.removeInventoryItemLimited = function(source, name, count)
	local xPlayer  = ESX.Players[tonumber(source)]
	local item = xPlayer.getInventoryItem(name)

	if item.count - count >= 0 then
		xPlayer.removeInventoryItem(name, count)
		return true
	else
		return false
	end
end

ESX.setJob = function(source, job, grade)
	ESX.Players[tonumber(source)].setJob(job, grade)
end

ESX.setArmour = function(source, value)
	ESX.Players[tonumber(source)].setArmour(value)
end

ESX.getArmour = function(source)
	return ESX.Players[tonumber(source)].getArmour()
end

ESX.doesPlayerExist = function(source)
	return ESX.Players[tonumber(source)] ~= nil
end

ESX.getVehicle = function(source, plate)
	return ESX.Players[tonumber(source)].getVehicle(plate)
end

ESX.getPoundedVehicles = function(source, type)
	return ESX.Players[tonumber(source)].getPoundedVehicles(type)
end

ESX.getGarageVehicles = function(source, type)
	return ESX.Players[tonumber(source)].getGarageVehicles(type)
end

ESX.getVehicles = function(source)
	return ESX.Players[tonumber(source)].getVehicles()
end

ESX.deleteVehicle = function(source, plate, updateSql)
	return ESX.Players[tonumber(source)].deleteVehicle(plate, updateSql)
end

ESX.addVehicle = function(source, vehicle, updateSql)
	return ESX.Players[tonumber(source)].addVehicle(vehicle, updateSql)
end

ESX.isVehiclePounded = function(source, plate)
	return ESX.Players[tonumber(source)].isVehiclePounded(plate)
end

ESX.setVehiclePoundState = function(source, plate, state, zone)
	ESX.Players[tonumber(source)].setVehiclePoundState(plate, state, zone)
end

ESX.updateVehiclePoundStateAndProps = function(source, vehicle, state, zone)
	return ESX.Players[tonumber(source)].updateVehiclePoundStateAndProps(vehicle, state, zone)
end

ESX.getGroup = function(source)
	return ESX.Players[tonumber(source)].getGroup()
end

ESX.getFullname = function(source)
	return ESX.Players[tonumber(source)].getFullname()
end

ESX.addExperience = function(source, type, amount)
	ESX.Players[tonumber(source)].addExperience(type, amount)
end

ESX.setExperience = function(source, type, value)
	ESX.Players[tonumber(source)].setExperience(type, value)
end

ESX.getExperience = function(source, type)
	return ESX.Players[tonumber(source)].getExperience(type)
end