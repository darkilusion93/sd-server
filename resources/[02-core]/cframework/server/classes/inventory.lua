function CreateInventory(invType, identifier, slots)
    local self = {}

	self.type = invType -- player, vehicle, etc
	self.identifier = identifier -- steam, plate, etc
    self.items = {}
    self.slots = slots -- this is weight for types trunk, storage
    self.invId = 1
    self.updateListeners = {}

    self.lock = nil     -- this is promise lock

    local totalItemCount = 0

    local function acquireLock()
        local oldLock = self.lock
        if oldLock then
            -- someone is already inside → wait for them to resolve
            Citizen.Await(oldLock)
        end

        -- take the lock
        self.lock = promise.new()
    end

    local function releaseLock()
        local p = self.lock
        self.lock = nil
        p:resolve()
    end


    local function getTotalItemCount()
        return totalItemCount
    end

    local function saveAddItem(item, count, insert)
        if insert then
            local query = "INSERT INTO inventory_data (identifier, name, count, metadata, slot) VALUES (?, ?, ?, ?, ?)"
            ESX.MySqlQueueQuery(query, {self.identifier, item.name, item.count, json.encode(item.metadata), item.slot})
            return
        end

        local query = "UPDATE inventory_data SET count = ? WHERE identifier = ? AND slot = ? AND name = ?"
        ESX.MySqlQueueQuery(query, {item.count, self.identifier, item.slot, item.name})
    end

    local function saveRemoveItem(item, count, remove)
        if remove then
            local query = "DELETE FROM inventory_data WHERE identifier = ? AND slot = ? AND name = ?"
            ESX.MySqlQueueQuery(query, {self.identifier, item.slot, item.name})
            return
        end

        local query = "UPDATE inventory_data SET count = ? WHERE identifier = ? AND slot = ? AND name = ?"
        ESX.MySqlQueueQuery(query, {item.count, self.identifier, item.slot, item.name})
    end

    local function saveChangeSlot(item, fromSlot, remove, targetItem)
        if remove then
            local query2 <const> = "DELETE FROM inventory_data WHERE identifier = ? AND slot = ? AND name = ?"

            ESX.MySqlQueueQuery(query2, {self.identifier, fromSlot, item.name})
            saveAddItem(item, 0, false)

            return
        end

        local query <const> = "UPDATE inventory_data SET slot = ? WHERE identifier = ? AND slot = ? AND name = ?"
        local query3 <const> = "UPDATE inventory_data SET slot = ? WHERE identifier = ? AND slot = ? AND name = ?"

        ESX.MySqlQueueQuery(query, {item.slot, self.identifier, fromSlot, item.name})

        if targetItem ~= nil then
            ESX.MySqlQueueQuery(query3, {targetItem.slot, self.identifier, item.slot, targetItem.name})
        end
    end

    local function saveItemMetadata(item)
        local query <const> = "UPDATE inventory_data SET metadata = ? WHERE identifier = ? AND slot = ?"

        ESX.MySqlQueueQuery(query, {json.encode(item.metadata), self.identifier, item.slot})
    end

    local function getSqlLoadQuery()
        local queries <const> = {
            player = "SELECT * FROM inventory_data WHERE identifier = @identifier",
            vehicle = "SELECT * FROM inventory_data WHERE identifier = @identifier",
            storage = "SELECT * FROM inventory_data WHERE identifier = @identifier",
        }

        --[[local queries <const> = {
            player = "SELECT inventory FROM users WHERE identifier = @identifier",
            vehicle = "SELECT inventory FROM trunk_inventory WHERE plate = @identifier",
            storage = "SELECT inventory FROM inventories WHERE identifier = @identifier",
        }]]

        return queries[self.type]
    end

    local function performSqlLoad(query)
        if query == nil then
            return nil
        end

        return MySQL.Sync.fetchAll(query, {["@type"] = self.type, ["@identifier"] = self.identifier})
    end

    local function loadInventory()
        local result = performSqlLoad(getSqlLoadQuery())

        if result ~= nil then
            local inventory = result

            for k,invItem in pairs(inventory) do
                local item = ESX.Items[invItem.name]

                if item then
                    table.insert(self.items, {
                        name = invItem.name,
                        count = invItem.count,
                        metadata = json.decode(invItem.metadata),
                        slot = invItem.slot,
                        label = item.label,
                        limit = item.limit,
                        type = item.type,
                        usable = ESX.UsableItemsCallbacks[invItem.name] ~= nil,
                        canRemove = item.canRemove
                    })

                    if item.type ~= "money" then --only count items, not money
                        totalItemCount += invItem.count
                    end
                end
            end
        end
    end

    local function deepCompare(t1, t2)
        if t1 == t2 then return true end
        if type(t1) ~= "table" or type(t2) ~= "table" then return false end
        for k, v in pairs(t1) do
            if not deepCompare(v, t2[k]) then return false end
        end
        for k, v in pairs(t2) do
            if not deepCompare(v, t1[k]) then return false end
        end
        return true
    end

    local function length(t)
        local c = 0
        for _ in pairs(t) do c += 1 end
        return c
    end

    local function handleAddItem(item, count, insert)
        if item.type ~= "money" then --only count items, not money
            totalItemCount += count
        end

        if self.type == "player" then
            for player, _ in pairs(self.updateListeners) do
                TriggerEvent('esx:onAddInventoryItem', player, item, count)
		        TriggerClientEvent('esx:addInventoryItem', player, item, count, item.count, insert)
            end
        end

        if self.type == "vehicle" then
            self.incrementInvId()

            for player, _ in pairs(self.updateListeners) do
                TriggerClientEvent('cframework:addTrunkInventoryItem', player, item, count, item.count, insert, self.invId, getTotalItemCount())
            end
        end

        if self.type == "storage" then
            self.incrementInvId()

            for player, _ in pairs(self.updateListeners) do
                TriggerClientEvent('cframework:addSecondInventoryItem', player, item, count, item.count, insert, self.invId)
            end
        end

        if self.type == "trash" then
            self.incrementInvId()
            return
        end

        saveAddItem(item, count, insert)
    end

    local function handleRemoveItem(item, count, remove)
        if item.type ~= "money" then --only count items, not money
            totalItemCount -= count
        end

        if self.type == "player" then
            for player, _ in pairs(self.updateListeners) do
                TriggerEvent('esx:onRemoveInventoryItem', player, item, count)
		        TriggerClientEvent('esx:removeInventoryItem', player, item, count, item.count, remove)
            end
        end

        if self.type == "vehicle" then
            self.incrementInvId()

            for player, _ in pairs(self.updateListeners) do
                TriggerClientEvent('cframework:removeTrunkInventoryItem', player, item, count, item.count, remove, self.invId, getTotalItemCount())
            end
        end

        if self.type == "storage" then
            self.incrementInvId()

            for player, _ in pairs(self.updateListeners) do
                TriggerClientEvent('cframework:removeSecondInventoryItem', player, item, count, item.count, remove, self.invId)
            end
        end

        if self.type == "trash" then
            self.incrementInvId()
            return
        end

        saveRemoveItem(item, count, remove)
    end

    local function handleChangeSlot(item, fromSlot, remove, targetItem)
        if self.type == "player" then
            for player, _ in pairs(self.updateListeners) do
                TriggerEvent('esx:onChangeSlotItem', player, item, fromSlot)
                TriggerClientEvent('esx:changeSlotItem', player, item, fromSlot, remove)
            end
        end

        if self.type == "vehicle" then
            self.incrementInvId()
        end

        if self.type == "storage" then
            self.incrementInvId()
        end

        if self.type == "trash" then
            self.incrementInvId()
            return
        end

        saveChangeSlot(item, fromSlot, remove, targetItem)
    end

    local function handleUpdateSlots(newSlots)
        if self.type == "player" then
            for player, _ in pairs(self.updateListeners) do
                TriggerEvent('esx:updateSlots', player, newSlots)
                TriggerClientEvent('esx:updateSlots', player, newSlots)
            end
        end

        if self.type == "vehicle" then
            self.incrementInvId()
        end

        if self.type == "storage" then
            self.incrementInvId()
        end

        if self.type == "trash" then
            self.incrementInvId()
            return
        end

        --saveInventory()
    end

    local function handleUpdateMetadata(item, metadataKey, metadataValue)
        if self.type == "player" then
            for player, _ in pairs(self.updateListeners) do
                TriggerEvent('esx:onUpdateMetadata', player, item, metadataKey, metadataValue)
                TriggerClientEvent('esx:updateMetadata', player, item, metadataKey, metadataValue)
            end
        end

        if self.type == "vehicle" then
            self.incrementInvId()
        end

        if self.type == "storage" then
            self.incrementInvId()
        end

        if self.type == "trash" then
            self.incrementInvId()
            return
        end

        saveItemMetadata(item)
    end

    local function insertInventoryItem(item)
        table.insert(self.items, item)
    end

    local function findNextFreeSlot()
        -- Create a fast lookup table for occupied slots
        local occupiedSlots = {}
        for _, item in ipairs(self.items) do
            occupiedSlots[item.slot] = true
        end

        -- Find the first available slot
        local maxSlot = self.type == "player" and self.slots or math.huge

        if self.slots == -1 then
            maxSlot = math.huge
        end

        local freeSlot = nil
        for i = 1, maxSlot do
            if not occupiedSlots[i] then
                freeSlot = i
                break
            end
        end

        return freeSlot -- return slot or nil
    end

    local function doesSlotExist(slot)
        if slot <= self.slots or self.slots == -1 then
            return true
        end

        return false
    end

    local function isSlotFree(slot)
        for i=1, #self.items, 1 do
            if self.items[i] and self.items[i].slot == slot then
                return false
            end
        end
        return true
    end

    local function getItemTotalAmount(name)
        local count = 0

        for i=1, #self.items, 1 do
            if self.items[i].name == name then
                count += self.items[i].count
            end
        end

        return count
    end

    local function canItemStack(item)
        return length(item.metadata) == 0
    end

    --Only apply stack limit if its the player inventory
    local function canItemBeAdded(item, count)
        if self.type == "player" then
            return (item.limit == -1) or (item.count + count <= item.limit)
        end

        if self.type == "vehicle" then
            local itemCount <const> = getTotalItemCount()

            if item.type == "money" then
                return true
            end

            return itemCount + count <= self.slots
        end

        if self.type == "storage" then
            local itemCount <const> = getTotalItemCount()

            if self.slots == -1 then
                return true
            end

            if item.type == "money" then
                return true
            end

            return itemCount + count <= self.slots
        end

        return true
    end

    local function addNewInventoryItemAtSlot(name, count, slot, metadata)
        local itemData, item = ESX.Items[name], {}

        if itemData == nil then
            return false
        end

        if metadata == nil then
            metadata = {}
        end

        item.name = name
        item.count = count
        item.slot = slot
        item.metadata = metadata
        item.label = itemData.label
        item.limit = itemData.limit
        item.type = itemData.type
        item.usable = ESX.UsableItemsCallbacks[name] ~= nil
        item.canRemove = itemData.canRemove

        if self.type == "player" and itemData.limit ~= -1 and count > itemData.limit then
            return false
        end

        insertInventoryItem(item)
        handleAddItem(item, count, true)
        return true
    end

    local function canAddNewInventoryItemAtSlot(name, count, slot, metadata)
        local itemData = ESX.Items[name]

        if itemData == nil then
            return false
        end

        if self.type == "player" and itemData.limit ~= -1 and count > itemData.limit then
            return false
        end

        return true
    end

    local function addCountToExistingInventoryItemAtSlot(name, count, slot, metadata)
        local item = self.getItemInSlot(slot)

        --Item is not stackable
        if not canItemStack(item) then
            return false
        end

        --Item is stackable, but has metadata
        if metadata ~= nil and length(metadata) ~= 0 then
            return false
        end

        --Item is stackable, but slot is full
        if not canItemBeAdded(item, count) then
            return false
        end

        --Item is stackable, and is the same
        if item.name == name then
            item.count += count
            handleAddItem(item, count, false)
            return true
        end

        --Item is stackable, but is not the same
        return false
    end

    local function canAddCountToExistingInventoryItemAtSlot(name, count, slot, metadata)
        local item = self.getItemInSlot(slot)

        --Item is not stackable
        if not canItemStack(item) then
            return false
        end

        --Item is stackable, but has metadata
        if metadata ~= nil and length(metadata) ~= 0 then
            return false
        end

        --Item is stackable, but slot is full
        if not canItemBeAdded(item, count) then
            return false
        end

        --Item is stackable, and is the same
        if item.name == name then
            return true
        end

        --Item is stackable, but is not the same
        return false
    end

    local function removeCountFromExistingInventoryItemAtSlot(name, count, slot)
        local item = self.getItemInSlot(slot)

        if item.count < count then
            return false
        end

        if item.name == name and item.count > count then
            item.count -= count
            handleRemoveItem(item, count, false)
            return true
        end

        if item.name == name and item.count == count then
            for i=1, #self.items, 1 do
                if self.items[i].slot == slot then
                    local auxItem = self.items[i]
                    table.remove(self.items, i)
                    handleRemoveItem(auxItem, count, true)
                    break
                end
            end
            return true
        end

        return false
    end

    local function canRemoveCountFromExistingInventoryItemAtSlot(name, count, slot)
        local item = self.getItemInSlot(slot)

        if item.count < count then
            return false
        end

        if item.name == name and item.count > count then
            return true
        end

        if item.name == name and item.count == count then
            return true
        end

        return false
    end

    local function removeCountFromInventoryItem(name, count)
        if getItemTotalAmount(name) < count then
            return false
        end

        for i=1, #self.items, 1 do -- Count is less than a single stack
            if self.items[i].name == name and self.items[i].count >= count then
                if self.items[i].count == count then
                    local auxItem = self.items[i]
                    table.remove(self.items, i)
                    handleRemoveItem(auxItem, count, true)
                    return true
                end

                self.items[i].count -= count
                handleRemoveItem(self.items[i], count, false)
                return true
            end
        end

        -- handle when count is more than a single stack (remove multiple stacks)
        local remainingCount = count
        local i = 1

        while i <= #self.items do
            if self.items[i].name == name then
                if self.items[i].count <= remainingCount then
                    remainingCount -= self.items[i].count
                    local auxItem = self.items[i]
                    table.remove(self.items, i) -- Remove the item, but don't increment `i`
                    handleRemoveItem(auxItem, auxItem.count, true)
                else
                    self.items[i].count -= remainingCount
                    handleRemoveItem(self.items[i], remainingCount, false)
                    return true
                end
            else
                i = i + 1 -- Only increment if no item is removed
            end
        end

        return false
    end

    local function canRemoveCountFromInventoryItem(name, count)
        return getItemTotalAmount(name) >= count
    end

    local function findSlotThatFitsItem(name, count, metadata)
        if metadata ~= nil and length(metadata) ~= 0 then
            return nil
        end

        for i=1, #self.items, 1 do
            if self.items[i].name == name and canItemBeAdded(self.items[i], count) and canItemStack(self.items[i]) then
                return self.items[i].slot
            end
        end
        return nil
    end

    self.setSlots = function(newSlots)
        self.slots = newSlots

        handleUpdateSlots(newSlots)
    end

    self.getWeight = function()
        return getTotalItemCount()
    end

    self.getMaxWeight = function()
        return self.slots
    end

    self.addUpdateListener = function(player)
        self.updateListeners[player] = true
    end

    self.removeUpdateListener = function(player)
        self.updateListeners[player] = nil
    end

    self.getInvId = function()
        return self.invId
    end

    self.incrementInvId = function()
        self.invId += 1
    end

    self.hasItemOfType = function(iType)
		for i=1, #self.items, 1 do
			if self.items[i].type == iType then
				return true
			end
		end

        return false
	end

    self.getInventory = function()
        local inventory = {
            type = self.type,
            items = self.items,
            slots = self.slots
        }

		return inventory
	end

    self.getItems = function()
		return self.items
	end

    self.getItemByMetadata = function(metadataKey, metadataValue)
		for i=1, #self.items, 1 do
			if self.items[i].metadata ~= nil and self.items[i].metadata[metadataKey] == metadataValue then
				return self.items[i]
			end
		end
		return nil
	end

    self.getTotalItemCount = function()
        return getTotalItemCount()
    end

	self.getItem = function(name)
		for i=1, #self.items, 1 do
			if self.items[i].name == name then
				return self.items[i]
			end
		end
	end

    self.getItemAmount = function(name)
        return getItemTotalAmount(name)
	end

    self.getItemInSlot = function(slot)
		for i=1, #self.items, 1 do
			if self.items[i].slot == slot then
				return self.items[i]
			end
		end
	end

    self.updateMetadata = function(slot, metadataKey, metadataValue)
        local item = self.getItemInSlot(slot)

        if item == nil then
            return false
        end

        item.metadata[metadataKey] = metadataValue

        handleUpdateMetadata(item, metadataKey, metadataValue)
        return true
    end

    self.addItem = function(name, count, slot, metadata)
        local itemData = ESX.Items[name]

        if itemData == nil then
            return false
        end

        -- FIX (2026-06-12): count tem de ser inteiro >= 1. Antes só verificava
        -- count<1, deixando passar fracionários (1.5) e não-números → dupes.
        count = tonumber(count)
        if not count or count ~= math.floor(count) or count < 1 then
            return false
        end

        acquireLock()

        if self.type ~= "player" and not canItemBeAdded({count = count, limit = itemData.limit, type = itemData.type}, count) then -- Prevent exceeding limit
            releaseLock()
            return false
        end

        if metadata == nil and itemData.type == "weapon" then
            metadata = {ammo = 0}
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) == "table" and metadata.ammo == nil then
            metadata.ammo = 0
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) ~= "table" then
            metadata = {ammo = 0}
        end

        --Slot defined, but not free
        if slot ~= nil and not isSlotFree(slot) then
            local added = addCountToExistingInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return added
        end

        --Slot defined, and free
        if slot ~= nil and isSlotFree(slot) then
            local added = addNewInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return added
        end

        --Slot not defined, find valid slot
        if slot == nil then
            local freeSlot = findSlotThatFitsItem(name, count, metadata)

            if freeSlot ~= nil then
                local added = addCountToExistingInventoryItemAtSlot(name, count, freeSlot, metadata)

                releaseLock()

                return added
            end

            freeSlot = findNextFreeSlot()

            if freeSlot == nil then
                releaseLock()


                return false
            end

            local isItemAdded = addNewInventoryItemAtSlot(name, count, freeSlot, metadata)

            releaseLock()

            return isItemAdded
        end

        releaseLock()

        return false
	end

    self.forceAddItem = function(name, count, slot, metadata)
        local itemData = ESX.Items[name]

        if itemData == nil then
            return false
        end

        if count < 1 then
            return false
        end

        if metadata == nil and itemData.type == "weapon" then
            metadata = {ammo = 0}
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) == "table" and metadata.ammo == nil then
            metadata.ammo = 0
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) ~= "table" then
            metadata = {ammo = 0}
        end

        acquireLock()

        --Slot defined, but not free
        if slot ~= nil and not isSlotFree(slot) then
            local added = addCountToExistingInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return added
        end

        --Slot defined, and free
        if slot ~= nil and isSlotFree(slot) then
            local added = addNewInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return added
        end

        --Slot not defined, find valid slot
        if slot == nil then
            local freeSlot = findSlotThatFitsItem(name, count, metadata)

            if freeSlot ~= nil then
                local added = addCountToExistingInventoryItemAtSlot(name, count, freeSlot, metadata)

                releaseLock()

                return added
            end

            freeSlot = findNextFreeSlot()

            if freeSlot == nil then
                releaseLock()
                return false
            end

            local wasAdded = addNewInventoryItemAtSlot(name, count, freeSlot, metadata)

            releaseLock()

            return wasAdded
        end

        releaseLock()

        return false
	end

    self.removeItem = function(name, count, slot)
        count = tonumber(count)
        if not count or count ~= math.floor(count) or count < 1 then
            return false
        end

        acquireLock()

        --Slot defined, but not free
        if slot ~= nil and not isSlotFree(slot) then
            local removed = removeCountFromExistingInventoryItemAtSlot(name, count, slot)

            releaseLock()

            return removed
        end

        --Slot defined, and free
        if slot ~= nil and isSlotFree(slot) then
            releaseLock()

            return false
        end

        --Slot not defined
        if slot == nil then
            local removed = removeCountFromInventoryItem(name, count)

            releaseLock()

            return removed
        end

        releaseLock()

        return false
	end

    self.canAddItem = function(name, count, slot, metadata)
        local itemData = ESX.Items[name]

        if itemData == nil then
            return false
        end

        count = tonumber(count)
        if not count or count ~= math.floor(count) or count < 1 then
            return false
        end

        acquireLock()

        if self.type ~= "player" and not canItemBeAdded({count = count, limit = itemData.limit, type = itemData.type}, count) then -- Prevent exceeding limit
            releaseLock()
            return false
        end

        if metadata == nil and itemData.type == "weapon" then
            metadata = {ammo = 0}
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) == "table" and metadata.ammo == nil then
            metadata.ammo = 0
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) ~= "table" then
            metadata = {ammo = 0}
        end

        --Slot defined, but not free
        if slot ~= nil and not isSlotFree(slot) then
            local canAdd = canAddCountToExistingInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return canAdd
        end

        --Slot defined, and free
        if slot ~= nil and isSlotFree(slot) then
            local canAdd = canAddNewInventoryItemAtSlot(name, count, slot, metadata)

            releaseLock()

            return canAdd
        end

        --Slot not defined, find valid slot
        if slot == nil then
            local freeSlot = findSlotThatFitsItem(name, count, metadata)

            if freeSlot ~= nil then
                local canAdd = canAddCountToExistingInventoryItemAtSlot(name, count, freeSlot, metadata)

                releaseLock()

                return canAdd
            end

            freeSlot = findNextFreeSlot()

            if freeSlot == nil then
                releaseLock()
                return false
            end

            local canAdd = canAddNewInventoryItemAtSlot(name, count, freeSlot, metadata)

            releaseLock()

            return canAdd
        end

        releaseLock()

        return false
	end

    self.canAddItemIfSlotIsEmpty = function(name, count, slot, metadata)
        local itemData = ESX.Items[name]

        if itemData == nil then
            return false
        end

        if count < 1 then
            return false
        end

        acquireLock()

        if self.type ~= "player" and not canItemBeAdded({count = count, limit = itemData.limit, type = itemData.type}, count) then -- Prevent exceeding limit
            releaseLock()
            return false
        end

        if metadata == nil and itemData.type == "weapon" then
            metadata = {ammo = 0}
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) == "table" and metadata.ammo == nil then
            metadata.ammo = 0
        end

        if metadata ~= nil and itemData.type == "weapon" and type(metadata) ~= "table" then
            metadata = {ammo = 0}
        end

        if self.type == "player" and itemData.limit ~= -1 and count > itemData.limit then
            releaseLock()
            return false
        end

        --Slot defined
        if slot ~= nil and doesSlotExist(slot) then
            releaseLock()
            return true
        end

        if slot == nil and findNextFreeSlot() ~= nil then
            releaseLock()
            return true
        end

        releaseLock()
        return false
	end

    self.canRemoveItem = function(name, count, slot)
        count = tonumber(count)
        if not count or count ~= math.floor(count) or count < 1 then
            return false
        end

        acquireLock()

        --Slot defined, but not free
        if slot ~= nil and not isSlotFree(slot) then
            local canRemove = canRemoveCountFromExistingInventoryItemAtSlot(name, count, slot)

            releaseLock()

            return canRemove
        end

        --Slot defined, and free
        if slot ~= nil and isSlotFree(slot) then
            releaseLock()
            return false
        end

        --Slot not defined
        if slot == nil then
            local canRemove = canRemoveCountFromInventoryItem(name, count)

            releaseLock()

            return canRemove
        end

        releaseLock()

        return false
	end

    self.transferToSlot = function(fromSlot, toSlot)
        acquireLock()

        local item = self.getItemInSlot(fromSlot)
        local targetItemSlot = self.getItemInSlot(toSlot)

        if toSlot == nil or fromSlot == nil then
            releaseLock()
            return false
        end

        if fromSlot < 1 or toSlot < 1 then
            releaseLock()
            return false
        end

        if toSlot > self.slots then
            releaseLock()
            return false
        end

        if item == nil then
            releaseLock()
            return false
        end

        if item.slot == toSlot then
            releaseLock()
            return false
        end

        if targetItemSlot ~= nil and item.name ~= targetItemSlot.name then
            item.slot = toSlot
            targetItemSlot.slot = fromSlot

            handleChangeSlot(item, fromSlot, false, targetItemSlot)
            releaseLock()
            return true
        end

        if targetItemSlot ~= nil and targetItemSlot.name == item.name and canItemBeAdded(targetItemSlot, item.count) and canItemStack(targetItemSlot) then
            targetItemSlot.count += item.count

            for i=1, #self.items, 1 do
                if self.items[i].slot == fromSlot then
                    table.remove(self.items, i)
                    break
                end
            end

            handleChangeSlot(targetItemSlot, fromSlot, true, nil)
            releaseLock()
            return true
        end

        if targetItemSlot ~= nil and item.name == targetItemSlot.name and (not canItemBeAdded(targetItemSlot, item.count) or not canItemStack(targetItemSlot)) then
            item.slot = toSlot
            targetItemSlot.slot = fromSlot

            handleChangeSlot(item, fromSlot, false, targetItemSlot)
            releaseLock()
            return true
        end

        if targetItemSlot == nil then
            item.slot = toSlot
            handleChangeSlot(item, fromSlot, false, nil)
            releaseLock()
            return true
        end

        releaseLock()
        return false
    end

	self.serialize = function()
		local serializedData = {}
		for _, item in ipairs(self.items) do
			table.insert(serializedData, {name = item.name, count = item.count, metadata = item.metadata, slot = item.slot})
		end
		return serializedData
	end

	self.transferItemTo = function(targetInventory, name, count)
        local item = self.getItem(name)

        if item == nil or item.count < count then
            return false
        end

        if not item.canRemove then
            return false
        end

        if targetInventory.addItem(name, count, nil, item.metadata) then
            self.removeItem(name, count)
        end

        return true
    end

    self.transferItemFromSlotTo = function(targetInventory, slot, count, toSlot)
        local item = self.getItemInSlot(slot)

        if item == nil or count == nil or item.count < count then
            return false
        end

        if not item.canRemove then
            return false
        end

        if self.type == targetInventory.type and self.identifier == targetInventory.identifier and slot == toSlot then
            return false
        end

        if targetInventory.canAddItem(item.name, count, toSlot, item.metadata) and self.canRemoveItem(item.name, count, slot) then
            self.removeItem(item.name, count, slot)
            targetInventory.addItem(item.name, count, toSlot, item.metadata)

            return true, item
        end

        --Trying to swap items
        if toSlot ~= nil then
            local targetItem = targetInventory.getItemInSlot(toSlot)

            if targetItem == nil then
                return false
            end

            if not targetItem.canRemove then
                return false
            end

            local amountToRemove = targetItem.count

            if targetItem.limit ~= -1 then
                amountToRemove = math.min(targetItem.limit, targetItem.count)
            end

            local removedMain = self.canRemoveItem(item.name, count, slot)
            local removedTarget = targetInventory.canRemoveItem(targetItem.name, amountToRemove, targetItem.slot)

            local addedMain = self.canAddItemIfSlotIsEmpty(targetItem.name, amountToRemove, nil, targetItem.metadata)
            local addedTarget = targetInventory.canAddItemIfSlotIsEmpty(item.name, count, toSlot, item.metadata)

            if removedMain and removedTarget and addedMain and addedTarget then
                self.removeItem(item.name, count, slot)
                targetInventory.removeItem(targetItem.name, amountToRemove, targetItem.slot)

                self.addItem(targetItem.name, amountToRemove, nil, targetItem.metadata)
                targetInventory.addItem(item.name, count, toSlot, item.metadata)

                return true, item, targetItem
            end

            return false
        end

        return false
    end

    self.splitItems = function(targetInventory, slot, count, toSlot)
        local item = self.getItemInSlot(slot)

        if item == nil or count == nil or item.count < count then
            return false
        end

        if not item.canRemove then
            return false
        end

        if self.type == targetInventory.type and self.identifier == targetInventory.identifier and slot == toSlot then
            return false
        end

        if targetInventory.canAddItem(item.name, count, toSlot, item.metadata) and self.canRemoveItem(item.name, count, slot) then
            self.removeItem(item.name, count, slot)
            targetInventory.addItem(item.name, count, toSlot, item.metadata)

            return true, item
        end

        return false
    end

    self.transferAllItemsTo = function(targetInventory)
        for j = #self.items, 1, -1 do -- reverse order to avoid index issues
            local item = self.items[j]
            self.removeItem(item.name, item.count, item.slot)
            targetInventory.forceAddItem(item.name, item.count, nil, item.metadata)
        end
    end

    self.empty = function()
        for j = #self.items, 1, -1 do -- reverse order to avoid index issues
            local item = self.items[j]

            if item.canRemove then
                self.removeItem(item.name, item.count, item.slot)
            end
        end
    end

    self.clear = function()
        for j = #self.items, 1, -1 do -- reverse order to avoid index issues
            local item = self.items[j]

            self.removeItem(item.name, item.count, item.slot)
        end
    end

    loadInventory()

    return self
end