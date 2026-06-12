local validProperties <const> = {
    ["property"] = true,
    ["police_vault"] = true,
    ["storage_unit"] = true,
    ["market_vault"] = true,
    ["market_vault_cayo"] = true,
    ["armazem1"] = true,
    ["armazem2"] = true,
    ["armazem3"] = true,
    ["armazem4"] = true,
}

local propertyNameLog <const> = {
    ["property"] = "MOTEL",
    ["police_vault"] = "CACIFO DA POLÍCIA",
    ["storage_unit"] = "UNIDADE DE ARMAZENAMENTO",
    ["market_vault"] = "ARMAZAZÉM DO MERCADO",
    ["market_vault_cayo"] = "ARMAZAZÉM DO MERCADO ILHA",
    ["armazem1"] = "ARMAZEM 1",
    ["armazem2"] = "ARMAZEM 2",
    ["armazem3"] = "ARMAZEM 3",
    ["armazem4"] = "ARMAZEM 4",
}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM properties', {}, function(properties)

		for i=1, #properties, 1 do
			local entering  = nil
			local exit      = nil
			local inside    = nil
			local outside   = nil
			local isSingle  = nil
			local isRoom    = nil
			local isGateway = nil
			local roomMenu  = nil
			local motelroom	= nil

			if properties[i].entering ~= nil then
				entering = json.decode(properties[i].entering)
			end

			if properties[i].exit ~= nil then
				exit = json.decode(properties[i].exit)
			end

			if properties[i].inside ~= nil then
				inside = json.decode(properties[i].inside)
			end

			if properties[i].outside ~= nil then
				outside = json.decode(properties[i].outside)
			end

			if properties[i].is_single == 0 then
				isSingle = false
			else
				isSingle = true
			end

			if properties[i].is_room == 0 then
				isRoom = false
			else
				isRoom = true
			end

			if properties[i].is_gateway == 0 then
				isGateway = false
			else
				isGateway = true
			end

			if properties[i].room_menu ~= nil then
				roomMenu = json.decode(properties[i].room_menu)
			end

			table.insert(Config.Properties, {
				name      = properties[i].name,
				label     = properties[i].label,
				entering  = entering,
				exit      = exit,
				inside    = inside,
				outside   = outside,
				ipls      = json.decode(properties[i].ipls),
				gateway   = properties[i].gateway,
				isSingle  = isSingle,
				isRoom    = isRoom,
				isGateway = isGateway,
				roomMenu  = roomMenu,
				motelroom = properties[i].type,
				price     = properties[i].price
			})
		end

		TriggerClientEvent('esx_property:sendProperties', -1, Config.Properties)
	end)
end)

ESX.RegisterServerCallback('esx_property:getProperties', function(source, cb)
	cb(Config.Properties)
end)

RegisterServerEvent('cframework:getPropertyItem', function(propertyId, itemSlot, itemCount, toSlot)
    local source <const> = source
    local owner = ESX.getIdentifier(source)

    if validProperties[propertyId] == nil then return end
    if propertyId == "market_vault" or propertyId == "market_vault_cayo" then return end --Prevent market vault from being used as a property

    local sourceInventory, targetInventory = GetInventory(propertyId, owner), ESX.getInvContainer(source)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)

    if not success then return end

    --ESX.logMotelData(source, "RETIRAR", item.name, itemCount, ESX.GetItemLabel(item.name), propertyNameLog[propertyId])
    TriggerClientEvent("cframework:refreshPropertyInventory", source)

    if swappedItem ~= nil then
        --ESX.logMotelData(source, "PÔR", swappedItem.name, swappedItem.count, ESX.GetItemLabel(swappedItem.name), propertyNameLog[propertyId])
    end
end)

RegisterServerEvent('cframework:putPropertyItem', function(propertyId, itemSlot, itemCount)
    local source <const> = source
    local owner = ESX.getIdentifier(source)

    if validProperties[propertyId] == nil then return end

    local sourceInventory, targetInventory = ESX.getInvContainer(source), GetInventory(propertyId, owner)

    local success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    --ESX.logMotelData(source, "PÔR", item.name, itemCount, ESX.GetItemLabel(item.name), propertyNameLog[propertyId])
    TriggerClientEvent("cframework:refreshPropertyInventory", source)

    if swappedItem ~= nil then
        --ESX.logMotelData(source, "RETIRAR", swappedItem.name, swappedItem.count, ESX.GetItemLabel(swappedItem.name), propertyNameLog[propertyId])
    end
end)

RPC.register('cframework:getPropertyInventory', function(propertyId)
    local source <const> = source
	local owner = ESX.getIdentifier(source)

    if validProperties[propertyId] == nil then return end

    local invWeight = MOTEL_INV_WEIGHT

    if propertyId == "police_vault" then
        invWeight = POLICE_VAULT_INV_WEIGHT
    elseif propertyId == "storage_unit" then
        invWeight = 0
    elseif propertyId == "market_vault" or propertyId == "market_vault_cayo" then
        invWeight = MARKET_VAULT_WEIGHT
    elseif propertyId == "armazem1" or propertyId == "armazem2" or propertyId == "armazem3" or propertyId == "armazem4" then
        invWeight = 300000
    end

    local inventory = GetInventory(propertyId, owner, invWeight)

    if inventory == nil then
        return {items = {}}
    end

	return {
		items = inventory.getItems(),
        weight = inventory.getWeight(),
        maxWeight = inventory.getMaxWeight()
	}
end)

local spawnedProps = {}

local vaultPropLoc = {
    ["default"] = {
        coords = vector3(154.9879, -1007.788, -99.2062),
        heading = 269.99996,
    },
    ["cayo"] = {
        coords = vector3(5181.583, -5145.452, -100.520),
        heading = 269.99996,
    },
}

RPC.register("cframework:spawnMotelVault", function(isCayo)
    local source <const> = source

    if spawnedProps[source] and DoesEntityExist(spawnedProps[source]) then
        DeleteEntity(spawnedProps[source])
    end

    local vault <const> = vaultPropLoc[isCayo and "cayo" or "default"]
    local vaultProp <const> = CreateObject(GetHashKey("ch_prop_ch_arcade_safe_door"), vault.coords.x, vault.coords.y, vault.coords.z, true, true, false)

    local curTime <const> = os.time()

    while not DoesEntityExist(vaultProp) do
        Citizen.Wait(20)

        if os.time() - curTime > 20 then return nil end
    end

    FreezeEntityPosition(vaultProp, true)
    SetEntityHeading(vaultProp, vault.heading)

    SetEntityIgnoreRequestControlFilter(vaultProp, true)
    SetEntityRemoteSyncedScenesAllowed(vaultProp, true)
    SetEntityRoutingBucket(vaultProp, GetPlayerRoutingBucket(source))

    spawnedProps[source] = vaultProp

    return NetworkGetNetworkIdFromEntity(vaultProp)
end)

RegisterNetEvent("cframework:deleteMotelVault", function()
    local source <const> = source

    if spawnedProps[source] and DoesEntityExist(spawnedProps[source]) then
        DeleteEntity(spawnedProps[source])
    end
end)

AddEventHandler('playerDropped', function()
    local source <const> = source

    if spawnedProps[source] and DoesEntityExist(spawnedProps[source]) then
        DeleteEntity(spawnedProps[source])
    end
end)