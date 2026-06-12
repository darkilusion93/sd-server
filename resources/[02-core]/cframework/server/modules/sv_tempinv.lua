local tempInv = {}

local function getTrashCoordsFormId(invId)
	local markerX = "X"
	local markerY = "Y"

	-- Find the positions of the markers
	local indexX = string.find(invId, markerX)
	local indexY = string.find(invId, markerY)

	if indexX and indexY then
		-- Extract substring from X until Y
		local substring1 = string.sub(invId, indexX + #markerX, indexY - 1)

		-- Extract substring from Y till the end
		local substring2 = string.sub(invId, indexY + #markerY)

		return tonumber(substring1), tonumber(substring2)
	else
		return nil, nil
	end
end

RegisterServerEvent('cframework:getTempInvItem', function(invId, itemSlot, itemCount, toSlot)
	local source = source

	if tempInv[invId] == nil then return end
    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_FUNCTION_DISABLED_WHILE_DEAD"), 'error') return end

	if tempInv[invId].type == "trash" then
		if string.sub(invId, 1, 8) ~= "GARBAGE-" then
			return
		end

		local x, y = getTrashCoordsFormId(invId)

		if x == nil or y == nil then return end

		local coords = GetEntityCoords(GetPlayerPed(source))

		if not ESX.playerInsideLocation(source, {vector3(x, y, coords.z)}, 5.0) then
			--TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba', nil, false) 
			return
		end

		tempInv[invId].lastUsed = os.time()
	end

    local sourceInventory, targetInventory = tempInv[invId].inventory, ESX.getInvContainer(source)

    local success <const>, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount, toSlot)

    if not success then return end

    --ESX.logTempInvData(source, "retirar", item.name, itemCount, invId)

    if swappedItem ~= nil then
        --ESX.logTempInvData(source, "pôr", swappedItem.name, swappedItem.count, invId)
    end
end)


RegisterServerEvent('cframework:putTempInvItem', function(invId, itemSlot, itemCount)
	local source = source

	if tempInv[invId] == nil then return end
    if GetEntityHealth(GetPlayerPed(source)) <= 99 then TriggerClientEvent('esx:showNotification', source, T("GENERIC_FUNCTION_DISABLED_WHILE_DEAD"), 'error') return end

	if tempInv[invId].type == "trash" then
		if string.sub(invId, 1, 8) ~= "GARBAGE-" then
			return
		end

		local x, y = getTrashCoordsFormId(invId)

		if x == nil or y == nil then return end

		local coords = GetEntityCoords(GetPlayerPed(source))

		if not ESX.playerInsideLocation(source, {vector3(x, y, coords.z)}, 5.0) then
			--TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba', nil, false) 
			return
		end

		tempInv[invId].lastUsed = os.time()
	end

    local sourceInventory, targetInventory = ESX.getInvContainer(source), tempInv[invId].inventory

    local success <const>, item, swappedItem = sourceInventory.transferItemFromSlotTo(targetInventory, itemSlot, itemCount)

    if not success then return end

    --ESX.logTempInvData(source, "pôr", item.name, itemCount, invId)

    if swappedItem ~= nil then
        --ESX.logTempInvData(source, "retirar", swappedItem.name, swappedItem.count, invId)
    end
end)


RPC.register('cframework:getTempInventory', function(invId, invType)
	local source = source

	if tempInv[invId] == nil then
		if invType == "trash" then
			tempInv[invId] = {
				lastUsed = os.time(),
				type = invType,
				inventory = CreateInventory(invType, invId, -1)
			}

			--for _ = 1, 3, 1 do
				local item, count = GenerateRandomTrash()

                tempInv[invId].inventory.addItem(item, count)
			--end
		end
	end

	if invType == "trash" then
		if string.sub(invId, 1, 8) ~= "GARBAGE-" then
			return
		end

		local x, y = getTrashCoordsFormId(invId)

		if x == nil or y == nil then return end

		local coords = GetEntityCoords(GetPlayerPed(source))

		if not ESX.playerInsideLocation(source, {vector3(x, y, coords.z)}, 5.0) then
			--TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba', nil, false) 
			return
		end

		if os.time() - tempInv[invId].lastUsed > 900 then
			tempInv[invId] = {
				lastUsed = os.time(),
				type = invType,
				inventory = CreateInventory(invType, invId, -1)
			}

			--for _ = 1, 3, 1 do
				local item, count = GenerateRandomTrash()

                tempInv[invId].inventory.addItem(item, count)
			--end
		end
	end


	return {items = tempInv[invId].inventory.getItems()}
end)
