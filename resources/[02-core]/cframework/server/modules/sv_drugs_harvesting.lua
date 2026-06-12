

local drugData = LoadDrugs()
local spawnedWeedPlants = {}
local harvesting = {}
local currentlyPlanting = {}

Citizen.CreateThread(function()
    for _, loc in ipairs(drugData.harvest) do
        table.insert(harvesting, vector3(loc.x, loc.y, loc.z))
    end
end)


local function getHarvestLocationRadius(type)
    for _, loc in ipairs(drugData.harvest) do
        if loc.type == type then
            return loc.r
        end
    end

    return 0.0
end

local function logWrongBucketHarvesting(source)
    local routingBucket <const> = GetPlayerRoutingBucket(source)
    if routingBucket ~= 0 then
        TriggerEvent('semdestino:log', 'Drugs', 'Apanhar na dimensão errada', 'superadmin', ESX.getIdentifier(source) .."", 'azul', ESX.getName(source) .. ' [' .. source .. ']')
    end
end

local function getHarvestedAmount(hasFertilizer, hasScissors)
    local amounts <const> = drugData.harvestAmounts

    if hasFertilizer and hasScissors then
        return math.random(amounts.withScissorAndFertilizer.min, amounts.withScissorAndFertilizer.max)
    end

    if hasFertilizer then
        return math.random(amounts.withFertilizer.min, amounts.withFertilizer.max)
    end

    return math.random(amounts.without.min, amounts.without.max)
end

RPC.register('cframework:useSeed', function(type)
	local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
	local harvestableDrugs <const> = drugData.harvestableDrugs

    if spawnedWeedPlants[source] ~= nil then
        return false
	end

    if currentlyPlanting[source] then
        return false
    end

    currentlyPlanting[source] = true

    if harvestableDrugs[type] == nil then return end

    if not ESX.playerInsideLocation(source, harvesting, getHarvestLocationRadius(type)) then
        return false
    end

	if not inventory.removeItem(harvestableDrugs[type].seedItem, 1) then
        TriggerClientEvent('esx:showNotification', source, T("DRUGS_DONT_HAVE_SEEDS"), 'error')
		return false
	end

	Citizen.CreateThread(function()
        local source2 <const> = source
		Citizen.Wait(10000)

		if spawnedWeedPlants[source2] ~= nil and DoesEntityExist(spawnedWeedPlants[source2]) then
			DeleteEntity(spawnedWeedPlants[source2])
		end

		local coords <const> = GetEntityCoords(GetPlayerPed(source2))
		local propEntity <const> = CreateObject(harvestableDrugs[type].plantObject, coords.x, coords.y, coords.z - 1.0, true, true, false)

        spawnedWeedPlants[source2] = propEntity
        currentlyPlanting[source2] = nil

		while not DoesEntityExist(propEntity) do
			Citizen.Wait(0)
		end

		FreezeEntityPosition(propEntity, true)
	end)

	return true
end)

RPC.register('cframework:harvestDrug', function(type)
	local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
	local harvestableDrugs <const> = drugData.harvestableDrugs

    if spawnedWeedPlants[source] == nil then return end

    if harvestableDrugs[type] == nil then return end

    if not ESX.playerInsideLocation(source, harvesting, getHarvestLocationRadius(type)) then
        return false
    end

    if not ESX.passedCooldown(source, 19900) then
        return false
    end

	local hasFertilizer = inventory.canRemoveItem(harvestableDrugs[type].fertilizerItem, 1)
	local hasScissors = inventory.canRemoveItem(harvestableDrugs[type].scissorsItem, 1)
    local harvestCount = getHarvestedAmount(hasFertilizer, hasScissors)

	if not inventory.canAddItem(harvestableDrugs[type].harvestedItem, harvestCount) then TriggerClientEvent('esx:showNotification', source, T("INVENTORY_NOT_ENOUGH_SPACE"), 'error')
		return
	end

	DeleteEntity(spawnedWeedPlants[source])
	spawnedWeedPlants[source] = nil

    if hasFertilizer then
        inventory.removeItem(harvestableDrugs[type].fertilizerItem, 1)
    end

	inventory.addItem(harvestableDrugs[type].harvestedItem, harvestCount)

    logWrongBucketHarvesting(source)
end)