

local levels <const> = {0, 800, 2100, 3800, 6100, 9500, 12500, 16000, 19800, 24000, 28500, 33400, 38700, 44200, 50200, 56400, 63000,
69900, 77100, 84700, 92500, 100700, 109200, 118000, 127100, 136500, 146200, 156200, 166500, 177100, 188000, 199200, 210700, 222400,
234500, 246800, 259400, 272300, 285500, 299000, 312700, 326800, 341000, 355600, 370500, 385600, 401000, 416600, 432600, 448800, 465200,
482000, 499000, 516300, 533800, 551600, 569600, 588000, 606500, 625400, 644500, 663800, 683400, 703300, 723400, 743800, 764500, 785400,
806500, 827900, 849600, 871500, 893600, 961600, 984700, 1008100, 1031800, 1055700, 1079800, 1104200, 1128800, 1153700, 1178800, 1204200,
1229800, 1255600, 1281700, 1308100, 1334600, 1361400, 1388500, 1415800, 1443300, 1471100, 1499100, 1527300, 1555800, 1584350, 1612950,
1641600, 1670300, 1699050, 1727850, 1785600, 1814550, 1843550, 1872600, 1901700, 1930850, 1960050, 1989300, 2018600, 2047950, 2077350,
2106800, 2136300, 2165850, 2195450, 2225100, 2254800, 2284550, 2314350, 2344200, 2374100, 2404050, 2434050, 2464100}

local currentCrafting, receivingUpdates = {}, {}
local currentCops = 0
local XP_TYPES <const> = {
    NONE = 0,
    PERSONAL = 1,
    ORG = 2
}

AddEventHandler('esx:onlineCops', function(amount)
    currentCops = amount
end)

local function processAndCheckCraftXp(source, pJob, item)
    if item.xpToUse == XP_TYPES.NONE then
        return true
    end

	if item.xpToUse == XP_TYPES.PERSONAL then
		if ESX.getExperience(source, item.typer) < levels[item.level] then
            TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_EXPERIENCE"), 'error')
			return false
        end

        if ESX.getExperience(source, item.typer) < levels[item.level + 1] then
            ESX.addExperience(source, item.typer, item.increment)
        end

        return true
	elseif item.xpToUse == XP_TYPES.ORG then
		if ESX.getJobExperience(pJob, item.typer) < levels[item.level] then
            TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_EXPERIENCE_ORG"), 'error')
			return false
		end

        if ESX.getJobExperience(pJob, item.typer) < levels[item.level + 1] then
            ESX.addJobExperience(pJob, item.typer, item.increment, source)
        end

        return true
	end

    return true
end

local function finishCraftAndNotify(source, inventory, item)
    local label = ""

	if item.count == nil then item.count = 1 end

    if item.name ~= nil then
        label = ESX.GetItemLabel(item.name)

        if item.influencePerks and item.influenceCount ~= nil then
            inventory.addItem(item.name, item.influenceCount)

            TriggerClientEvent('esx:showNotification', source, string.format(T("CRAFTS_YOU_BUILT"), item.influenceCount, label), 'success')
        else
            inventory.addItem(item.name, item.count)

            TriggerClientEvent('esx:showNotification', source, string.format(T("CRAFTS_YOU_BUILT"), item.count, label), 'success')
        end

        --ESX.logCraftData(source, "CRAFT", item.name, item.count, item.partNum, label)
    elseif item.vehicle ~= nil then
        label = item.vehicle

        StartVehicleChallenge(source, item)

        TriggerClientEvent('esx:showNotification', source, string.format(T("CRAFTS_YOU_BUILT"), 1, label), 'success')

        --ESX.logCraftData(source, "CRAFT", item.vehicle, 1, item.partNum, label)
    end
end

local function consumeCraftItems(inventory, items, influencePerks)
	for _, v in pairs(items) do
        if v.consume ~= nil and not v.consume then
            goto continue
        end

        if influencePerks and v.influenceCount ~= nil then
            inventory.removeItem(v.name, v.influenceCount)
        else
            inventory.removeItem(v.name, v.count)
        end

        ::continue::
	end
end

local function craftNeedsAreAvailable(inventory, items, influencePerks)
	for _, v in pairs(items) do
        if influencePerks and v.influenceCount ~= nil then
            if not inventory.canRemoveItem(v.name, v.influenceCount) then
                return false
            end
        else
            if not inventory.canRemoveItem(v.name, v.count) then
                return false
            end
        end
	end

    return true
end

local function logWrongBucketCrafting(source)
    local routingBucket <const> = GetPlayerRoutingBucket(source)
    if routingBucket ~= 0 then
        TriggerEvent('semdestino:log', 'Crafts', 'Craftar na dimensão errada', 'superadmin', ESX.getIdentifier(source) .."", 'azul', ESX.getName(source) .. ' [' .. source .. ']')
    end
end

-- Success server event
RegisterNetEvent('cframework:craft', function()
    local source <const> = source
    local pJob <const> = ESX.getJob(source).name
    local inventory <const> = ESX.getInvContainer(source)
	local item <const> = currentCrafting[source]

    if item == nil then return end

    currentCrafting[source] = nil

	if not ESX.playerInsideLocation(source, item.pos, 10.0) then
		TriggerClientEvent('esx:showNotification', source, T("CRAFTS_LEFT_POS"), 'error')
        return
    end

    if not processAndCheckCraftXp(source, pJob, item) then return end

    finishCraftAndNotify(source, inventory, item)

    if item.enableInfluence then
        ESX.proccessInfluence(pJob, item.partNum, item.influenceVariation)

        for k, v in pairs(receivingUpdates) do
            if v == item.partNum then
                local targetSource <const> = k

                TriggerClientEvent("cframework:updateCraftingInfoSimple", targetSource, ESX.getInfluence(item.partNum), item.partNum)
            end
        end
    end

    logWrongBucketCrafting(source)
end)

-- Success server event
RegisterNetEvent('cframework:craftMobile', function()
    local source <const> = source
	local item <const> = currentCrafting[source]
    local inventory <const> = ESX.getInvContainer(source)

    if item == nil then return end

    currentCrafting[source] = nil

    if not processAndCheckCraftXp(source, nil, item) then return end

    finishCraftAndNotify(source, inventory, item)
end)


RPC.register('cframework:isAuthorizedToCraft', function(partNum)
	local source = source
	local craftableItems <const> = ESX.craftItems[partNum]
    local pJob <const> = ESX.getJob(source).name

    if craftableItems == nil then return false end

    for i,v in ipairs(craftableItems.jobs) do
		if v == "none" or v == pJob then
			return true
		end

        if string.find(v, "tag:") then
            local role,_ = string.gsub(v, "tag:", "")

            if IsRolePresent(source, tonumber(role)) then
                return true
            end
        end
	end

    return false
end)

-- Check if you have the items
RPC.register('cframework:canCraft', function(partNum, index)
	local source = source
	local craftableItems <const> = ESX.craftItems[partNum]
    local inventory <const> = ESX.getInvContainer(source)
	local pJob <const> = ESX.getJob(source).name

    local item = craftableItems.items[index]
	local canCraft = false

	if not ESX.playerInsideLocation(source, craftableItems.pos, 10.0) then
        return false
    end

    if craftableItems.minCops ~= nil and currentCops < craftableItems.minCops then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_COPS"), 'error')
        return false
    end

	for i,v in ipairs(craftableItems.jobs) do
		if v == "none" or v == pJob then
			canCraft = true
			break
		end

        if string.find(v, "tag:") then
            local role,_ = string.gsub(v, "tag:", "")

            if IsRolePresent(source, tonumber(role)) then
                canCraft = true
                break
            end
        end
	end

	if not canCraft then return false end

    local hasOrgXp, hasPersonalXp = false, false

    item.xpToUse = XP_TYPES.NONE
    item.pos = craftableItems.pos
    item.partNum = partNum
    item.influencePerks = false
    item.enableInfluence = false
    item.influenceVariation = 0

    if item.needOrgXp and ESX.getJobExperience(pJob, item.typer) >= levels[item.level] then
        hasOrgXp = true
	end

	if item.needXp and ESX.getExperience(source, item.typer) >= levels[item.level] then
        hasPersonalXp = true
	end

	if item.needOrgXp and not hasOrgXp then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_EXPERIENCE_ORG") .. item.level, 'error')
		return false
	end

    if item.needXp and not hasPersonalXp then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_EXPERIENCE_PERSONAL") .. item.level, 'error')
		return false
	end

    if hasOrgXp then
        item.xpToUse = XP_TYPES.ORG
    elseif hasPersonalXp then
        item.xpToUse = XP_TYPES.PERSONAL
    end

    if craftableItems.enableInfluence ~= nil and craftableItems.enableInfluence then
        local influence <const> = ESX.getInfluence(partNum)

        if influence.level ~= nil and influence.identifier == pJob and influence.level >= 1000 then
            item.influencePerks = true
        end

        item.enableInfluence = true
        item.influenceVariation = craftableItems.influenceVariation or 0
    end

	if not craftNeedsAreAvailable(inventory, item.needs, item.influencePerks) then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_ITEMS"), 'error')
		return false
	end

    if item.count == nil then item.count = 1 end

    if item.name ~= nil then
        if not item.influencePerks then
            if not inventory.canAddItem(item.name, item.count) then
                TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_SPACE"), 'error')
                return false
            end
        elseif item.influenceCount ~= nil then
            if not inventory.canAddItem(item.name, item.influenceCount) then
                TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_SPACE"), 'error')
                return false
            end
        end
    end

    consumeCraftItems(inventory, item.needs, item.influencePerks)

    currentCrafting[source] = item

	return true
end)

-- Check if you have the items
RPC.register('cframework:canCraftMobile', function(index)
	local source = source
	local item <const> = ESX.mobileCrafts[index]
    local inventory <const> = ESX.getInvContainer(source)

    if item == nil then
        return false
    end

	if item.needXp and ESX.getExperience(source, item.typer) < levels[item.level] then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_EXPERIENCE_PERSONAL") .. item.level, 'error')
		return false
	end

    if item.needXp then
        item.xpToUse = XP_TYPES.PERSONAL
    else
        item.xpToUse = XP_TYPES.NONE
    end

    item.partNum = "mobile"
    item.influencePerks = false
    item.enableInfluence = false

	if not craftNeedsAreAvailable(inventory, item.needs, item.influencePerks) then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_ITEMS"), 'error')
		return false
	end

    if item.count == nil then item.count = 1 end

    if not inventory.canAddItem(item.name, item.count) then
        TriggerClientEvent('esx:showNotification', source, T("CRAFTS_NOT_ENOUGH_SPACE"), 'error')
        return false
    end

    consumeCraftItems(inventory, item.needs, item.influencePerks)

    currentCrafting[source] = item

	return true
end)

RegisterNetEvent('cframework:requestCraftUpdates', function(partNum)
    local source <const> = source

    receivingUpdates[source] = partNum
end)

RegisterNetEvent('cframework:stopCraftUpdates', function()
    local source <const> = source

    receivingUpdates[source] = nil
end)