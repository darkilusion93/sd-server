ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local function hasPermToSearchPlayer(source)
	local job = ESX.getJob(source).name

	if ESX.getGroup(source) ~= 'user' then
		return true
	end

	return ESX.hasSearchMenu(job)
end

RPC.register("cframework:getPlayerInventory", function(target)
	local source = source

	if not hasPermToSearchPlayer(source) then
		return nil
	end


	if not ESX.doesPlayerExist(target) then
		return nil
	else
		--ESX.LogOrgActionsData(source, "REVISTAR", ESX.getJob(source).name, ESX.getJob(source).label, target)
        local inventory = ESX.getInvContainer(target)

		return {inventory = inventory.getItems()}
	end
end)

math.randomseed(GetGameTimer())

RegisterServerEvent("cframework:tradePlayerItem", function(from, target, itemSlot, itemCount, toSlot)
	local source <const> = source

	if not hasPermToSearchPlayer(source) then
		return
	end

	-- FIX (2026-06-12): o caller TEM de ser participante da troca. Antes um
	-- jogador com menu de revista movia itens entre DOIS terceiros (roubo/plant).
	if source ~= from and source ~= target then
		return
	end

	if #(GetEntityCoords(GetPlayerPed(from)) - GetEntityCoords(GetPlayerPed(target))) > 30.0 then
		return
	end

    local sourceInventory, targetInventory = ESX.getInvContainer(from), ESX.getInvContainer(target)
    local sourceItem = sourceInventory.getItemInSlot(itemSlot)

    if sourceItem == nil then return end

    local chance, trade, success, item, swappedItem = math.random(1,40), ESX.tradeItem(sourceItem.name), false, {}, nil
    local tradeItemCount = 0

    if trade ~= nil and trade.min ~= nil and trade.max ~= nil then
        tradeItemCount = math.random(trade.min, trade.max)
        if not targetInventory.canAddItem(trade.item, tradeItemCount) then
            return
        end
    end

    if chance == 1 or trade == nil then
        success, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)
    else
        if sourceInventory.canRemoveItem(sourceItem.name, itemCount) then
            sourceInventory.removeItem(sourceItem.name, itemCount)
            targetInventory.addItem(trade.item, tradeItemCount)

            itemCount = tradeItemCount
            success, item = true, sourceItem
        end
    end

    if not success then return end

    local label = ESX.GetItemLabel(item.name)

    if chance ~= 1 and trade ~= nil then
        label = ESX.GetItemLabel(item.name) .. ' -> ' .. ESX.GetItemLabel(trade.item)
    end

    if source == target then --tirar
        --ESX.LogInventoryGive(target, from, "TIRAR", item.name, itemCount, label)

        if swappedItem ~= nil then
            --ESX.LogInventoryGive(target, from, "PÔR", swappedItem.name, swappedItem.count, ESX.GetItemLabel(swappedItem.name))
        end
    elseif source == from then --por
        --ESX.LogInventoryGive(from, target, "PÔR", item.name, itemCount, label)

        if swappedItem ~= nil then
            --ESX.LogInventoryGive(from, target, "TIRAR", swappedItem.name, swappedItem.count, ESX.GetItemLabel(swappedItem.name))
        end
    end

    TriggerClientEvent("cframework:refreshPlayerInventory", source)
end)

RegisterServerEvent("cframework:changeItemSlot", function(fromSlot, toSlot)
	local source <const> = source
    local inventory = ESX.getInvContainer(source)

    inventory.transferToSlot(tonumber(fromSlot), tonumber(toSlot))
end)

RegisterServerEvent("cframework:splitItemSlot", function(fromSlot, toSlot)
	local source <const> = source
    local inventory = ESX.getInvContainer(source)
    local item = inventory.getItemInSlot(fromSlot)

    if item == nil then return end

    local count = math.floor(item.count / 2)

    inventory.splitItems(inventory, fromSlot, count, toSlot)
end)

TriggerEvent('es:addGroupCommand', 'openinventory', 'mod', function(source, args, user)
	local target = tonumber(args[1])
	local targetXPlayer = ESX.GetPlayerFromId(target)

	-- Check if the player executing the command has admin privileges
	if not ESX.inAdmin(source) then
		-- If the player does not have admin privileges, show a notification and return false
		TriggerClientEvent('cframework:showNotification', source, 'Comando desativado.', 'error')
		return false
	end

	if targetXPlayer ~= nil then
		TriggerClientEvent("cframework:openPlayerInventory", source, target, targetXPlayer.name)
	else
		TriggerClientEvent("chatMessage", source, "^1" .. _U("no_player"))
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end)
