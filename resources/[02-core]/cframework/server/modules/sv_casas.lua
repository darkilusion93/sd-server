local houseInstances = {}
local houseOwners = {}
local houseInfo = {}
local currentUniverse = 4

local sharedHouses = {}
local ownedHouses = {}

local propertiesForSale = {}

local validProperties <const> = {
    ["casa"] = true,
    ["garage"] = true,
}

local function getHouseWeight(propertyId, houseId)
    local weight = MOTEL_INV_WEIGHT --Default to something

    if propertyId == "casa" then
        weight = HOUSE_WEIGHTS[Config.properties[houseId].interior]

		if Config.properties[houseId].garage == nil then -- For houses without garages
			weight = HOUSE_WITHOUT_GARAGE_WEIGHTS[Config.properties[houseId].interior]
		end
    elseif propertyId == "garage" then
        weight = GARAGE_WEIGHTS[Config.properties[houseId].garage.interior]
    end

    return weight
end

local function changeVehiclesFromHouseToDefaultLocation(owner, houseId)
    local xPlayer = ESX.GetPlayerFromIdentifier(owner)

    if xPlayer ~= nil then
        local vehicles = cachedVehicles[owner]

        for i=1, #vehicles, 1 do
			if vehicles[i].zone == houseId then
				vehicles[i].zone = "los_santos"

                xPlayer.setVehiclePoundState(vehicles[i].plate, false, "los_santos")
			end
		end

        return
    end

    local vehicles = cachedVehicles[owner]

    if vehicles ~= nil then
        for i=1, #vehicles, 1 do
			if vehicles[i].zone == houseId then
				vehicles[i].zone = "los_santos"
			end
		end
    end

    MySQL.Async.execute('UPDATE owned_vehicles SET zone = @zone, stored = @stored WHERE zone = @prevzone',
    {
        ['@zone']  = "los_santos",
        ['@stored'] = false,
        ['@prevzone'] = houseId,
    })
end

local function clearHouse(propertyId)
    if propertyId == nil then
        return
    end

    if Config.properties[propertyId] == nil then
		return
	end

    if Config.properties[propertyId].owner == nil then
		return
	end

    local previousOwner = Config.properties[propertyId].owner
    Config.properties[propertyId].owner = nil
    Config.properties[propertyId].access = {}
    Config.properties[propertyId].vehicles = {}
    Config.properties[propertyId].invite = nil

    MySQL.Async.execute('DELETE FROM casas WHERE id = @id',
    {
        ['@id'] = propertyId
    })

    if ownedHouses[previousOwner] ~= nil then
        for pos,id in ipairs(ownedHouses[previousOwner]) do
            if id == propertyId then
                table.remove(ownedHouses[previousOwner], pos)
                break
            end
        end
    end

    for player,_ in pairs(Config.properties[propertyId].access) do
        if sharedHouses[player] ~= nil then
            for pos,id in ipairs(sharedHouses[player]) do
                if id == propertyId then
                    table.remove(sharedHouses[player], pos)
                    break
                end
            end

            local ySource = ESX.GetPlayerIdFromIdentifier(player)

            if ySource ~= nil then
                TriggerClientEvent('cframework:sendCasasAndSales', ySource, ownedHouses[player], sharedHouses[player], propertiesForSale)
            end
        end
    end

    table.insert(propertiesForSale, propertyId)

    --Transfer all items from house to storage unit
    local storageUnitInv <const> = GetInventory("storage_unit", previousOwner, 0)

    local weightCasa <const> = getHouseWeight("casa", propertyId)
    local inventoryCasa <const> = GetInventory("casa", propertyId, weightCasa)

    inventoryCasa.transferAllItemsTo(storageUnitInv)

    if Config.properties[propertyId].garage ~= nil then
        local weightGarage <const> = getHouseWeight("garage", propertyId)
        local inventoryGarage <const> = GetInventory("garage", propertyId, weightGarage)

        inventoryGarage.transferAllItemsTo(storageUnitInv)
    end

    changeVehiclesFromHouseToDefaultLocation(previousOwner, propertyId)

    TriggerClientEvent('cframework:sendCasa', -1, propertyId, nil)
end

local function buyHouse(source, moneyType)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory <const> = ESX.getInvContainer(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local propertyId = nil

    if not inventory.canRemoveItem("house_deed", 1) then
        TriggerClientEvent('esx:showNotification', source, 'Não tens escrituras!', 'error')
        return
    end

	for k,v in pairs(Config.properties) do
		if #(vector3(v.entrance.x, v.entrance.y, v.entrance.z) - coords) < 1.5 then
			propertyId = k
			break
		end
	end

	if Config.properties[propertyId] == nil then
		TriggerClientEvent('esx:showNotification', source, 'Não estás perto de nenhuma casa!', 'error')
		return
	end

	if Config.properties[propertyId].owner ~= nil then TriggerClientEvent('esx:showNotification', source, 'Esta casa já tem dono!', 'error')
		return
	end

	local ownedProperties = 0

	for _,v in pairs(Config.properties) do
		if v.owner == xPlayer.identifier then
			ownedProperties += 1
		end
	end

	if ownedProperties >= 3 then TriggerClientEvent('esx:showNotification', source, 'Não podes ter mais propriedades!', 'error')
		return
	end

    if Config.properties[propertyId].price ~= nil and Config.properties[propertyId].coins ~= nil and moneyType == "none" then -- Has options but no money type
        TriggerClientEvent('cframework:choosePaymentOnHousePurchase', source)
        return
    elseif moneyType == "none" then
        moneyType = "cash"
    end

	if moneyType == "cash" and not inventory.canRemoveItem("cash", Config.properties[propertyId].price) then TriggerClientEvent('esx:showNotification', source, 'Não tens dinheiro suficiente!', 'error')
		return
	end

    if moneyType == "coins" and xPlayer.getCoins() < Config.properties[propertyId].coins then TriggerClientEvent('esx:showNotification', source, 'Não tens coins suficientes!', 'error')
        return
    end

    if moneyType == "cash" then
        inventory.removeItem("cash", Config.properties[propertyId].price)
    elseif moneyType == "coins" then
        xPlayer.removeCoins(Config.properties[propertyId].coins)
    end

    inventory.removeItem("house_deed", 1)

	Config.properties[propertyId].owner = xPlayer.identifier

	MySQL.Async.execute('INSERT INTO casas (id, owner) VALUES (@id, @owner)',
	{
		['@id'] = propertyId,
		['@owner'] = xPlayer.identifier,
	})

	if ownedHouses[xPlayer.identifier] == nil then ownedHouses[xPlayer.identifier] = {} end

	table.insert(ownedHouses[xPlayer.identifier], propertyId)

	propertiesForSale = {}
	for k,p in pairs(Config.properties) do
		if p.owner == nil then
			table.insert(propertiesForSale, k)
		end
	end

	TriggerClientEvent('esx:showNotification', source, 'Casa comprada!', 'success')
	TriggerClientEvent('cframework:sendCasa', -1, propertyId, xPlayer.identifier)
end

function ESX.getOwnerOfHousePlayerIsIn(source)
    local houseId <const> = houseInfo[source]

    if houseId == nil then return nil end

	local house = Config.properties[houseId]

	if house == nil then return nil end

	return house.owner
end

function ESX.getHouseIdPlayerIsIn(source)
    local houseId <const> = houseInfo[source]

    if houseId == nil then return nil end

	local house = Config.properties[houseId]

	if house == nil then return nil end

	return houseId
end

MySQL.ready(function()
	for k,_ in pairs(Config.properties) do
		Config.properties[k].owner = nil
		Config.properties[k].access = {}
		Config.properties[k].vehicles = {}
		Config.properties[k].invite = nil
    end

	MySQL.Async.fetchAll('SELECT * FROM casas', {}, function(properties)
		for i=1, #properties, 1 do
			local property = properties[i]
			local access = {}

			for _,v in ipairs(json.decode(property.access)) do
				access[v] = true
			end

			if Config.properties[property.id] == nil then goto jump_final end

			Config.properties[property.id].owner = property.owner
			Config.properties[property.id].access = access
			Config.properties[property.id].vehicles = json.decode(property.vehicles)
			Config.properties[property.id].invite = nil
            Config.properties[property.id].last_entered = property.last_entered

			if ownedHouses[property.owner] == nil then ownedHouses[property.owner] = {} end

			table.insert(ownedHouses[property.owner], property.id)

			for k,player in ipairs(json.decode(property.access)) do
				if sharedHouses[player] == nil then sharedHouses[player] = {} end

				table.insert(sharedHouses[player], property.id)
			end

			::jump_final::
		end

		for k,p in pairs(Config.properties) do
			if p.owner == nil then
				table.insert(propertiesForSale, k)
			end
		end

        for k,p in pairs(Config.properties) do
            if p.last_entered ~= nil then --last_entered is a mysql timestamp
                local lastEntered = os.time() - (p.last_entered/1000)

                if lastEntered >= 45 * 24 * 60 * 60 then -- 45 days
                    clearHouse(k)
                end
            end
		end
	end)
end)


AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    local sourcePlayer = playerId
	local identifier = xPlayer.identifier

	if ownedHouses[identifier] == nil then ownedHouses[identifier] = {} end
	if sharedHouses[identifier] == nil then sharedHouses[identifier] = {} end

	TriggerClientEvent('cframework:sendCasasAndSales', sourcePlayer, ownedHouses[identifier], sharedHouses[identifier], propertiesForSale)
end)

RPC.register('cframework:getVehicleGarageFreeSlot', function(houseId)
    local source <const> = source

    if Config.properties[houseId] == nil then return nil end

    local garageInterior, maxSlots = Config.properties[houseId].garage.interior, 0

    if garageInterior == "small" then
        maxSlots = 2
    elseif garageInterior == "medium" then
        maxSlots = 6
    elseif garageInterior == "big" then
        maxSlots = 10
    end

    for i = 1, maxSlots do
        if Config.properties[houseId].vehicles[i] == nil then
            return i
        end
    end

    return nil
end)

RegisterNetEvent("cframework:setVehicleInsideProperty", function(vehicleNetId, houseId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    if Config.properties[houseId] == nil or Config.properties[houseId].garage == nil then return end

    local garageInterior, maxSlots = Config.properties[houseId].garage.interior, 0

    if garageInterior == "small" then
        maxSlots = 2
    elseif garageInterior == "medium" then
        maxSlots = 6
    elseif garageInterior == "big" then
        maxSlots = 10
    end

    for i = 1, maxSlots do
        if Config.properties[houseId].vehicles[i] == nil then
            Config.properties[houseId].vehicles[i] = vehicle
            return
        end
    end
end)

RegisterNetEvent("cframework:removeVehicleFromProperty", function(vehicleNetId, houseId)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    if Config.properties[houseId] == nil then return end

    local garageInterior, maxSlots = Config.properties[houseId].garage.interior, 0

    if garageInterior == "small" then
        maxSlots = 2
    elseif garageInterior == "medium" then
        maxSlots = 6
    elseif garageInterior == "big" then
        maxSlots = 10
    end

    for i = 1, maxSlots do
        if Config.properties[houseId].vehicles[i] == vehicle then
            Config.properties[houseId].vehicles[i] = nil
            return
        end
    end
end)

RegisterNetEvent("cframework:enterProperty", function(houseId, alternateEntry, isGarage, withVehicle)
	local source = source
	local identifier = ESX.getIdentifier(source)

	local house = Config.properties[houseId]

	if house == nil then return end

	local coords = GetEntityCoords(GetPlayerPed(source))

	if houseOwners[source] == nil then
		if #(coords - vector3(Config.properties[houseId].entrance.x, Config.properties[houseId].entrance.y, Config.properties[houseId].entrance.z)) > 10.0 then
			if Config.properties[houseId].garage == nil then
				return
			end

			if #(coords - vector3(Config.properties[houseId].garage.entrance.x, Config.properties[houseId].garage.entrance.y, Config.properties[houseId].garage.entrance.z)) > 10.0 then
				return
			end
		end
	end

	if Config.properties[houseId].owner == nil then
		TriggerClientEvent("cframework:houseForSale", source, houseId)
		return
	end

	if houseOwners[source] == nil then
		if identifier ~= Config.properties[houseId].owner and not Config.properties[houseId].access[identifier] and Config.properties[houseId].invite ~= identifier then return end
	else
		if houseOwners[source] ~= Config.properties[houseId].owner then return end
	end


	if isGarage and withVehicle then
		if GetVehiclePedIsIn(GetPlayerPed(source), false) == 0 then return end
		if GetPlayerPed(source) ~= GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(source), false), -1) then return end

		for k,v in pairs(Config.properties[houseId].vehicles) do
			if not DoesEntityExist(v) then
				Config.properties[houseId].vehicles[k] = nil
				break
			end
		end

		local vehiclesInGarage = 0

		for _,_ in pairs(Config.properties[houseId].vehicles) do
			vehiclesInGarage += 1
		end

		if Config.properties[houseId].garage.interior == "small" and vehiclesInGarage >= 2 then
			TriggerClientEvent('esx:showNotification', source, 'A garagem está cheia.', 'error')
			return
		elseif Config.properties[houseId].garage.interior == "medium" and vehiclesInGarage >= 6 then
			TriggerClientEvent('esx:showNotification', source, 'A garagem está cheia.', 'error')
			return
		elseif Config.properties[houseId].garage.interior == "big" and vehiclesInGarage >= 10 then
			TriggerClientEvent('esx:showNotification', source, 'A garagem está cheia.', 'error')
			return
		end
	end

	if houseInstances[houseId] == nil then
		houseInstances[houseId] = currentUniverse
		currentUniverse = currentUniverse + 1
	end

	houseOwners[source] = Config.properties[houseId].owner
    houseInfo[source] = houseId

	local garageSlot = 1
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)

	if vehicle ~= 0 and withVehicle then
		SetEntityRoutingBucket(vehicle, houseInstances[houseId])

		local garageInterior, maxSlots = Config.properties[houseId].garage.interior, 0

		if garageInterior == "small" then
			maxSlots = 2
		elseif garageInterior == "medium" then
			maxSlots = 6
		elseif garageInterior == "big" then
			maxSlots = 10
		end

		for i = 1, maxSlots do
			if Config.properties[houseId].vehicles[i] == nil then
				garageSlot = i
				break
			end
		end

		Config.properties[houseId].vehicles[garageSlot] = vehicle
	end

	SetPlayerRoutingBucket(source, houseInstances[houseId])

	for i=0, 6, 1 do
		local ped = GetPedInVehicleSeat(vehicle, i)

		if DoesEntityExist(ped) then
			local target = NetworkGetEntityOwner(ped)

			---@diagnostic disable-next-line: param-type-mismatch
			SetPlayerRoutingBucket(target, houseInstances[houseId])
			houseOwners[target] = Config.properties[houseId].owner
            houseInfo[target] = houseId

			TriggerClientEvent("cframework:inHouse", target, houseId, Config.properties[houseId].owner, alternateEntry, isGarage, withVehicle, garageSlot, i)
		end
	end

	TriggerClientEvent("cframework:inHouse", source, houseId, Config.properties[houseId].owner, alternateEntry, isGarage, withVehicle, garageSlot, -1)

    if Config.properties[houseId].owner == identifier then
        MySQL.Async.execute('UPDATE casas SET last_entered = NOW() WHERE id = @id', {['@id'] = houseId})
    end
end)

RegisterNetEvent("cframework:exitProperty", function(houseId, isGarage, withVehicle)
	local source = source

	if GetVehiclePedIsIn(GetPlayerPed(source), false) ~= 0 and withVehicle then
		if GetPlayerPed(source) ~= GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(source), false), -1) then return end

		local vehicle = GetVehiclePedIsIn(GetPlayerPed(source), false)
		SetEntityRoutingBucket(vehicle, 0)

		for i=0, 6, 1 do
			local ped = GetPedInVehicleSeat(vehicle, i)

			if DoesEntityExist(ped) then
				local target = NetworkGetEntityOwner(ped)

				---@diagnostic disable-next-line: param-type-mismatch
				SetPlayerRoutingBucket(target, 0)
				houseOwners[target] = nil
                houseInfo[target] = nil

				TriggerClientEvent("cframework:outHouse", target, isGarage, withVehicle, i)
			end
		end

		for k,v in pairs(Config.properties[houseId].vehicles) do
			if v == vehicle then
				Config.properties[houseId].vehicles[k] = nil
				break
			end
		end
	end

	houseOwners[source] = nil
    houseInfo[source] = nil

	SetPlayerRoutingBucket(source, 0)

	TriggerClientEvent("cframework:outHouse", source, isGarage, withVehicle, -1)
end)

RPC.register('cframework:getPlayerDressing', function()
	local source = source
	local identifier = houseOwners[source]
	local store = GetDataStore('property', identifier)

    if store == nil then return {} end

	local count  = store.count('dressing')
	local labels = {}

	for i=1, count, 1 do
		local entry = store.get('dressing', i)
		table.insert(labels, entry.label)
	end

	return labels
end)

RegisterNetEvent('cframework:invitePlayer', function(player, houseId)
	local source = source
	local house = Config.properties[houseId]

	if house == nil then return end

	local owner = houseOwners[source]

	if owner == nil then return end

	if Config.properties[houseId].owner ~= owner then return end

	Config.properties[houseId].invite = ESX.getIdentifier(player)
	TriggerClientEvent("cframework:receiveInvite", player, houseId)

	Citizen.Wait(5000)

	Config.properties[houseId].invite = nil
	TriggerClientEvent('cframework:inviteExpired', player, houseId)
end)

RegisterNetEvent('cframework:changeKeys', function(houseId)
	local source = source
	local identifier = ESX.getIdentifier(source)
	local house = Config.properties[houseId]

	if house == nil then return end

	if identifier ~= Config.properties[houseId].owner then return end

	for player,_ in pairs(Config.properties[houseId].access) do
		local ySource = ESX.GetPlayerIdFromIdentifier(player)

		if sharedHouses[player] == nil then sharedHouses[player] = {} end
		if ownedHouses[player] == nil then ownedHouses[player] = {} end

		for pos,id in ipairs(sharedHouses[player]) do
			if id == houseId then
				table.remove(sharedHouses[player], pos)
			end
		end

		if ySource ~= nil then
			TriggerClientEvent('cframework:sendCasasAndSales', ySource, ownedHouses[player], sharedHouses[player], propertiesForSale)
		end
	end

	Config.properties[houseId].access = {}

	MySQL.Async.execute('UPDATE casas SET access = @access WHERE id = @id',
	{
		['@access'] = json.encode({}),
		['@id'] = houseId
	})

	TriggerClientEvent('esx:showNotification', source, 'Chaves da casa alteradas! Todos os que tinham accesso perderam!', 'inform')

	--ESX.logHouseData(source, "TROCAR", "keys", 1, identifier, "Fechadura | CASA " .. houseId)
end)

ESX.RegisterServerCallback('esx_casa:getPlayersInArea', function(source, cb, coords, area)
	local players       = GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))

		if distance <= area then
			local player = {}
			player.id = players[i]
			player.name = ESX.getFirstName(players[i]) .. ' ' .. ESX.getLastName(players[i])
			table.insert(playersInArea, player)
		end
	end

	cb(playersInArea)
end)

ESX.RegisterServerCallback('esx_casa:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)

    local store = GetDataStore('property', houseOwners[source])

    if store == nil then cb(nil) return end

	local outfit = store.get('dressing', num)

    if outfit == nil then cb(nil) return end

    cb(outfit.skin)
end)

RegisterNetEvent('cframework:getCasaItem', function(propertyId, itemSlot, itemCount, toSlot)
    local source <const> = source
	local houseId <const> = houseInfo[source]

    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, 'Estás morto não podes usar o baú', 'error') return end

    if validProperties[propertyId] == nil or houseId == nil then return end

    local sourceInventory, targetInventory = GetInventory(propertyId, houseId), ESX.getInvContainer(source)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)

    if not success then return end

    --ESX.logHouseData(source, 'retirar', item.name, itemCount, houseId, ESX.GetItemLabel(item.name))
    TriggerClientEvent("cframework:refreshCasaInventory", source)

    if swappedItem ~= nil then
        --ESX.logHouseData(source, 'pôr', swappedItem.name, swappedItem.count, houseId, ESX.GetItemLabel(swappedItem.name))
    end
end)

RegisterNetEvent('cframework:putCasaItem', function(propertyId, itemSlot, itemCount)
	local source <const> = source
	local houseId <const> = houseInfo[source]

    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, 'Estás morto não podes usar o baú', 'error') return end

    if validProperties[propertyId] == nil or houseId == nil then return end

    local sourceInventory, targetInventory = ESX.getInvContainer(source), GetInventory(propertyId, houseId)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    --ESX.logHouseData(source, 'pôr', item.name, itemCount, houseId, ESX.GetItemLabel(item.name))
    TriggerClientEvent("cframework:refreshCasaInventory", source)

    if swappedItem ~= nil then
        --ESX.logHouseData(source, 'retirar', swappedItem.name, swappedItem.count, houseId, ESX.GetItemLabel(swappedItem.name))
    end
end)



RPC.register('cframework:getCasaInventory', function(propertyId)
    local source <const> = source
	local houseId <const> = houseInfo[source]

    if validProperties[propertyId] == nil then return end

    local weight <const> = getHouseWeight(propertyId, houseId)
    local inventory = GetInventory(propertyId, houseId, weight)

    if inventory == nil then
        return {items = {}}
    end

	return {
		items = inventory.getItems(),
        weight = inventory.getWeight(),
        maxWeight = inventory.getMaxWeight()
	}
end)

RegisterNetEvent("cframework:transferToStorageUnit", function(propertyId)
    local source <const> = source
    local houseId <const> = houseInfo[source]
    local identifier <const> = ESX.getIdentifier(source)

    if houseId == nil then return end

	local house = Config.properties[houseId]

	if house == nil then return end

	if identifier ~= Config.properties[houseId].owner then return end

    if ESX.getBank(source) < 5000000 then
        TriggerClientEvent('esx:showNotification', source, 'Não tens dinheiro suficiente para transferir para o armazém!', 'error')
        return
    end

    ESX.removeAccountMoney(source, "bank", 5000000)

    local weight <const> = getHouseWeight(propertyId, houseId)

    local inventory = GetInventory(propertyId, houseId, weight)
    local storageUnitInv = GetInventory("storage_unit", identifier, 0)

    inventory.transferAllItemsTo(storageUnitInv)
    TriggerClientEvent('esx:showNotification', source, 'Items transferidos para a unidade de armazenamento', 'success')
end)

TriggerEvent('es:addGroupCommand', 'clearhouse', 'superadmin', function(source, args, user)
    local propertyId = args[1]

    if propertyId == nil then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid property ID.' } })
        return
    end

    if Config.properties[propertyId] == nil then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid property ID.' } })
		return
	end

    if Config.properties[propertyId].owner == nil then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'This property has no owner.' } })
		return
	end

    clearHouse(propertyId)

    TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', 'Property cleared successfully.' } })

end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})


RegisterNetEvent('cframework:buyHouse', function(moneyType)
    local source <const> = source

    buyHouse(source, moneyType)
end)

ESX.RegisterUsableItem('house_deed', function(source)
    buyHouse(source, "none")
end)

ESX.RegisterUsableItem('house_ownership_transfer', function(source, slot)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory <const> = ESX.getInvContainer(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local propertyId = nil

	for k,v in pairs(Config.properties) do
		if #(vector3(v.entrance.x, v.entrance.y, v.entrance.z) - coords) < 1.5 then
			propertyId = k
			break
		end
	end

	if propertyId == nil then TriggerClientEvent('esx:showNotification', source, 'Não estás perto de nenhuma casa!', 'error')
		return
	end

	if Config.properties[propertyId].owner ~= xPlayer.identifier then TriggerClientEvent('esx:showNotification', source, 'Esta casa não é tua!', 'error')
		return
	end

	local closestPlayer, closestDistance = ESX.GetClosestPlayer(source)

	if closestPlayer == -1 or closestDistance > 4.0 then TriggerClientEvent('esx:showNotification', source, 'Sem pessoas por perto!', 'error')
		return
	end

	local ownedProperties = 0
	local yPlayer = ESX.GetPlayerFromId(closestPlayer)

	for _,v in pairs(Config.properties) do
		if v.owner == yPlayer.identifier then
			ownedProperties += 1
		end
	end

	if ownedProperties >= 3 then TriggerClientEvent('esx:showNotification', source, 'Não podes vender a essa pessoa, limite máximo de propriedades atingido!', 'error')
		return
	end

	inventory.removeItem('house_ownership_transfer', 1, slot)

	Config.properties[propertyId].owner = yPlayer.identifier

	MySQL.Async.execute('UPDATE casas SET owner = @owner WHERE id = @id',
	{
		['@owner'] = yPlayer.identifier,
		['@id'] = propertyId
	})

	for pos,id in ipairs(ownedHouses[xPlayer.identifier]) do
		if id == propertyId then
			table.remove(ownedHouses[xPlayer.identifier], pos)
		end
	end

	table.insert(ownedHouses[yPlayer.identifier], propertyId)

	TriggerClientEvent('esx:showNotification', source, 'Posse da casa passada para ' .. yPlayer.firstName .. ' ' .. yPlayer.lastName .. '!', 'success')
	TriggerClientEvent('esx:showNotification', yPlayer.source, 'Posse da casa recebida!', 'success')
	TriggerClientEvent('cframework:sendCasa', -1, propertyId, yPlayer.identifier)

	--ESX.logTransfers(source, yPlayer.source, "TRANSFERIR", "casa", 1, "CASA " .. propertyId)

    changeVehiclesFromHouseToDefaultLocation(xPlayer.identifier, propertyId)
end)

ESX.RegisterUsableItem('keys', function(source, slot)
	local xPlayer = ESX.GetPlayerFromId(source)
    local inventory <const> = ESX.getInvContainer(source)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local propertyId = nil

	for k,v in pairs(Config.properties) do
		if #(vector3(v.entrance.x, v.entrance.y, v.entrance.z) - coords) < 3.0 then
			propertyId = k
			break
		end
	end

	if propertyId == nil then TriggerClientEvent('esx:showNotification', source, 'Não estás perto de nenhuma casa!', 'error')
		return
	end

	if Config.properties[propertyId] == nil then TriggerClientEvent('esx:showNotification', source, 'Não estás perto de nenhuma casa!', 'error')
		return
	end

	if Config.properties[propertyId].owner ~= xPlayer.identifier then TriggerClientEvent('esx:showNotification', source, 'Esta casa não é tua!', 'error')
		return
	end

	local closestPlayer, closestDistance = ESX.GetClosestPlayer(source)

	if closestPlayer == -1 or closestDistance > 4.0 then TriggerClientEvent('esx:showNotification', source, 'Sem pessoas por perto!', 'error')
		return
	end

	local auxtable2 = {}

	for k,v in pairs(Config.properties[propertyId].access) do
		table.insert(auxtable2, k)
	end

	if #auxtable2 >= 30 then TriggerClientEvent('esx:showNotification', source, 'Limite de partilhas atingido (30 pessoas)!', 'error')
		return
	end

	local yPlayer = ESX.GetPlayerFromId(closestPlayer)

	for k,v in ipairs(sharedHouses[yPlayer.identifier]) do
		if v == propertyId then TriggerClientEvent('esx:showNotification', source, 'Esta pessoa já partilha casa contigo.', 'error')
			return
		end
	end

	inventory.removeItem('keys', 1, slot)

	Config.properties[propertyId].access[yPlayer.identifier] = true

	local auxtable = {}

	for k,v in pairs(Config.properties[propertyId].access) do
		table.insert(auxtable, k)
	end

	table.insert(sharedHouses[yPlayer.identifier], propertyId)

	MySQL.Async.execute('UPDATE casas SET access = @access WHERE id = @id',
	{
		['@access'] = json.encode(auxtable),
		['@id'] = propertyId
	})

	TriggerClientEvent('esx:showNotification', source, 'Chaves entregues a ' .. yPlayer.firstName .. ' ' .. yPlayer.lastName .. '!', 'success')
	TriggerClientEvent('esx:showNotification', yPlayer.source, 'Chaves da casa recebidas!', 'success')
	TriggerClientEvent('cframework:sendCasasAndSales', yPlayer.source, ownedHouses[yPlayer.identifier], sharedHouses[yPlayer.identifier], propertiesForSale)
end)


--[[
function PayRent(d, h, m)
	MySQL.Async.fetchAll('SELECT * FROM owned_Casas WHERE rented = 1', {}, function (result)
		for i=1, #result, 1 do
			local xPlayer = ESX.GetPlayerFromIdentifier(result[i].owner)

			-- message player if connected
			if xPlayer then
				xPlayer.removeAccountMoney('bank', result[i].price)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('paid_rent', ESX.Math.GroupDigits(result[i].price)))
			else -- pay rent either way
				MySQL.Sync.execute('UPDATE users SET bank = bank - @bank WHERE identifier = @identifier',
				{
					['@bank']       = result[i].price,
					['@identifier'] = result[i].owner
				})
			end

			TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
				account.addMoney(result[i].price)
			end)
		end
	end)
end

TriggerEvent('cron:runAt', 22, 0, PayRent)]]
