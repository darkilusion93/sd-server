

local marketData = LoadMarket()
local runningShops = {}
local receivingUpdates = {}
local shopIndex = 1

local function hasPolicePrivileges(source)
    local job <const> = ESX.getJob(source)

    return job.name == marketData.policeJob and job.grade >= marketData.policeGrade
end

RegisterNetEvent("cframework:openMarketShopMenu", function(locationId)
    local source <const> = source
    local isFree, isOwner, isPolice, isLocked, ownerName = true, false, false, false, ""

    if runningShops[locationId] == nil then
        isFree = true
        isOwner = false
    else
        isFree = false
        isOwner = runningShops[locationId].owner == ESX.getIdentifier(source)
        ownerName = "<br>" .. runningShops[locationId].ownerName
        isLocked = runningShops[locationId].locked
        isPolice = hasPolicePrivileges(source)
    end

    TriggerClientEvent("cframework:openMarketShopMenu", source, isFree, isOwner, isPolice, isLocked, ownerName)
end)

RegisterNetEvent("cframework:rentMarketShop", function(locationId)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    if runningShops[locationId] ~= nil then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_ALREADY_RENTED"), 'error')
        return
    end

    for k, v in pairs(runningShops) do
        if v.owner == identifier then
            TriggerClientEvent('esx:showNotification', source, T("MARKET_HAS_RENTED_ALREADY"), 'error')
            return
        end
    end

    if ESX.getAccount(source, 'bank').money < marketData.rentPrice then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NO_MONEY"), 'error')
        return
    end
    ESX.removeAccountMoney(source, 'bank', marketData.rentPrice)

    local vaultId, illegal = "", false

    for _,shop in ipairs(marketData.marketShops) do
        if shop.id == locationId then
            vaultId = shop.vaultId
            illegal = shop.illegal
            break
        end
    end

    if vaultId == "" then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_VAULT_NOT_FOUND"), 'error')
        return
    end

    runningShops[locationId] = {}
    runningShops[locationId].owner = identifier
    runningShops[locationId].ownerName = ESX.getFullname(source)
    runningShops[locationId].time = os.time() + marketData.rentTime
    runningShops[locationId].items = {}
    runningShops[locationId].locked = false
    runningShops[locationId].vaultId = vaultId
    runningShops[locationId].illegal = illegal

    TriggerClientEvent('esx:showNotification', source, T("MARKET_RENTED"), 'success')
end)

RegisterNetEvent("cframework:stopMarketShop", function(locationId)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    if runningShops[locationId] == nil then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_NOT_RENTED"), 'error')
        return
    end

    if runningShops[locationId].owner ~= identifier then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_NOT_OWNER"), 'error')
        return
    end

    if runningShops[locationId].locked then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_SHOP_LOCKED_CANT_CLOSE"), 'error')
        return
    end

    runningShops[locationId] = nil

    TriggerClientEvent('esx:showNotification', source, T("MARKET_CLOSED"), 'success')
end)

RegisterNetEvent("cframework:toggleLockMarketShop", function(locationId)
    local source <const> = source

    if runningShops[locationId] == nil then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_NOT_RENTED"), 'error')
        return
    end

    if not hasPolicePrivileges(source) then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_NO_POLICE_PRIVILEGES"), 'error')
        return
    end

    if runningShops[locationId].locked then
        runningShops[locationId].locked = false
        TriggerClientEvent('esx:showNotification', source, T("MARKET_SHOP_UNLOCKED"), 'success')
    else
        runningShops[locationId].locked = true
        TriggerClientEvent('esx:showNotification', source, T("MARKET_SHOP_LOCKED"), 'success')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)

        for k, v in pairs(runningShops) do
            local ownerSource = ESX.GetPlayerFromIdentifier(v.owner)
            local itemsInSale = 0

            for k2, v2 in pairs(runningShops[k].items) do
                if v2.item ~= nil then
                    itemsInSale += 1
                end
            end

            if ownerSource == nil or not ESX.playerInsideLocation(ownerSource.source, marketData.marketCenter, marketData.centerRadius) then
                if runningShops[k].closeTimer ~= nil and os.time() > runningShops[k].closeTimer then
                    if ownerSource ~= nil then
                        TriggerClientEvent('esx:showNotification', ownerSource.source, T("MARKET_SHOP_WAS_CLOSED"), 'error')
                    end

                    runningShops[k] = nil
                elseif runningShops[k].closeTimer == nil then
                    if ownerSource ~= nil then
                        TriggerClientEvent('esx:showNotification', ownerSource.source, T("MARKET_SHOP_WILL_CLOSE"), 'error')
                    end
                    runningShops[k].closeTimer = os.time() + marketData.closeTimer
                end
            elseif runningShops[k].closeTimer ~= nil and itemsInSale > 0 then
                runningShops[k].closeTimer = nil
            elseif runningShops[k].closeTimer ~= nil and itemsInSale <= 0 then
                if ownerSource ~= nil then
                    TriggerClientEvent('esx:showNotification', ownerSource.source, T("MARKET_SHOP_WILL_CLOSE"), 'error')
                end
                runningShops[k].closeTimer = os.time() + marketData.closeTimer
            end

            if os.time() > v.time then
                if ownerSource ~= nil then
                    TriggerClientEvent('esx:showNotification', ownerSource.source, T("MARKET_SHOP_WAS_CLOSED"), 'error')
                end

                runningShops[k] = nil
            end
        end
    end
end)

RPC.register('cframework:openMarketInventory', function(locationId)
    if runningShops[locationId] == nil then
        return {}
    end

    local itemList = runningShops[locationId].items
    local shopInventory = GetInventory(runningShops[locationId].vaultId, runningShops[locationId].owner)
    local items = {}

    for k, v in pairs(itemList) do
        local item = shopInventory.getItemInSlot(v.slot)
        if item ~= nil and v.item == item.name then
            table.insert(items, {
                id = k,
                slot = item.slot,
                item = item.name,
                price = v.price,
                label = ESX.GetItemLabel(item.name),
                quantity = item.count,
                metadata = item.metadata,
            })
        end
    end

    return items
end)

RPC.register('cframework:getMarketManagement', function(locationId)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    if runningShops[locationId] == nil then
        return {}
    end

    if runningShops[locationId].owner ~= identifier then
        return {}
    end

    local inventory = GetInventory(runningShops[locationId].vaultId, identifier)

    return {items = inventory.getItems(), onSale = runningShops[locationId].items}
end)

RegisterNetEvent("cframework:marketShopBuy", function(locationId, id, count, slot)
    local source <const> = source
    local inventory = ESX.getInvContainer(source)

    if inventory == nil then return end

    if runningShops[locationId] == nil then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_SHOP_NOT_RENTED"), 'error')
        return
    end

    if runningShops[locationId].locked and not hasPolicePrivileges(source) then
        TriggerClientEvent('esx:showNotification', source, T("MARKET_SHOP_IS_LOCKED"), 'error')
        return
    end

    local shopInventory = GetInventory(runningShops[locationId].vaultId, runningShops[locationId].owner)
    local itemInfo = runningShops[locationId].items[id]
    local moneyToUse = runningShops[locationId].illegal and "black_money" or "cash"

    -- if id is defined and player has money on their hand/bank
    if itemInfo == nil then TriggerClientEvent('esx:showNotification', source, T("MARKET_ITEM_ALREADY_BOUGHT"), 'error') return end

    if count == nil or count <= 0 then return end
    if itemInfo.price <= 0 then return end

    if runningShops[locationId].owner == ESX.getIdentifier(source) then
        if not inventory.canAddItem(itemInfo.item, count, slot, itemInfo.metadata) or not shopInventory.canRemoveItem(itemInfo.item, count, itemInfo.slot) then
            return
        end

        shopInventory.removeItem(itemInfo.item, count, itemInfo.slot)
        inventory.addItem(itemInfo.item, count, slot, itemInfo.metadata)

        --ESX.logShopsData(source, "comprar", "Market - " .. runningShops[locationId].owner, itemInfo.item, count, ESX.GetItemLabel(itemInfo.item))

        local itemList = runningShops[locationId].items
        local items = {}

        for k, v in pairs(itemList) do
            local item = shopInventory.getItemInSlot(v.slot)
            if item ~= nil then
                table.insert(items, {
                    id = k,
                    slot = item.slot,
                    item = item.name,
                    price = v.price,
                    label = ESX.GetItemLabel(item.name),
                    quantity = item.count,
                    metadata = item.metadata,
                })
            end
        end

        for k, v in pairs(receivingUpdates) do
            if v == locationId then
                TriggerClientEvent('cframework:updateMarket', k, itemList)
            end
        end
        return
    end

    if not runningShops[locationId].locked then
        if not inventory.canRemoveItem(moneyToUse, itemInfo.price * count) then return end
    end

    if not inventory.canAddItem(itemInfo.item, count, slot, itemInfo.metadata) or not shopInventory.canRemoveItem(itemInfo.item, count, itemInfo.slot) then
        return
    end

    if not runningShops[locationId].locked then
        inventory.removeItem(moneyToUse, itemInfo.price * count)
    end

    shopInventory.removeItem(itemInfo.item, count, itemInfo.slot)
    inventory.addItem(itemInfo.item, count, slot, itemInfo.metadata)

    --ESX.logShopsData(source, "comprar", "Market - " .. runningShops[locationId].owner, itemInfo.item, count, ESX.GetItemLabel(itemInfo.item))

    local targetPlayer = ESX.GetPlayerFromIdentifier(runningShops[locationId].owner)

    if not runningShops[locationId].locked then
        if targetPlayer ~= nil then
            targetPlayer.addAccountMoney('bank', itemInfo.price * count)
        else
            if cachedUsers[runningShops[locationId].owner] ~= nil then
                cachedUsers[runningShops[locationId].owner].bank = cachedUsers[runningShops[locationId].owner].bank + (itemInfo.price * count)
            end
        end
    end

    local itemList = runningShops[locationId].items
    local items = {}

    for k, v in pairs(itemList) do
        local item = shopInventory.getItemInSlot(v.slot)
        if item ~= nil and item.name == v.item then
            table.insert(items, {
                id = k,
                slot = item.slot,
                item = item.name,
                price = v.price,
                label = ESX.GetItemLabel(item.name),
                quantity = item.count,
                metadata = item.metadata,
            })
        end
    end

    for k, v in pairs(receivingUpdates) do
        if v == locationId then
            TriggerClientEvent('cframework:updateMarket', k, items)
        end
    end
end)

RegisterNetEvent("cframework:addMarketShopItem", function(locationId, slot, price)
    local source <const> = source
    local identifier = ESX.getIdentifier(source)
    -- if id is defined and player has money on their hand/bank
    if slot == nil or price == nil or tonumber(price) <= 0 then return end

    if runningShops[locationId] == nil then return end
    if runningShops[locationId].owner ~= identifier then return end

    local inventory = GetInventory(runningShops[locationId].vaultId, identifier)

    if inventory == nil then return end

    if tonumber(price) > marketData.maxSalePrice then TriggerClientEvent('esx:showNotification', source, string.format(T("MARKET_ITEM_INVALID_PRICE"), ESX.formatAsCurrency(marketData.maxSalePrice)), 'error') return end

    local invItem = inventory.getItemInSlot(slot)

    if invItem == nil then return end

    if marketData.minPrices[invItem.name] ~= nil and tonumber(price) < marketData.minPrices[invItem.name] then
        TriggerClientEvent('esx:showNotification', source, string.format(T("MARKET_ITEM_MIN_INVALID_PRICE"), ESX.formatAsCurrency(marketData.minPrices[invItem.name])), 'error')
        return
    end

    if marketData.maxPrices[invItem.name] ~= nil and tonumber(price) > marketData.maxPrices[invItem.name] then
        TriggerClientEvent('esx:showNotification', source, string.format(T("MARKET_ITEM_INVALID_PRICE"), ESX.formatAsCurrency(marketData.maxPrices[invItem.name])), 'error')
        return
    end

    for k, v in pairs(runningShops[locationId].items) do
        if v.slot == invItem.slot then
            TriggerClientEvent('esx:showNotification', source, T("MARKET_ITEM_ALREADY_ANNOUNCED"), 'error')
            return
        end
    end

    runningShops[locationId].items[shopIndex .. ""] = {
        slot = invItem.slot,
        item = invItem.name,
        metadata = invItem.metadata,
        label = ESX.GetItemLabel(invItem.name),
        price = tonumber(price),
    }
    shopIndex += 1

    local itemList = runningShops[locationId].items
    local shopInventory = GetInventory(runningShops[locationId].vaultId, identifier)
    local items = {}

    for k, v in pairs(itemList) do
        local item = shopInventory.getItemInSlot(v.slot)
        if item ~= nil and item.name == v.item then
            table.insert(items, {
                id = k,
                slot = item.slot,
                item = item.name,
                price = v.price,
                label = ESX.GetItemLabel(item.name),
                quantity = item.count,
                metadata = item.metadata,
            })
        end
    end

    for k, v in pairs(receivingUpdates) do
        if v == locationId then
            TriggerClientEvent('cframework:updateMarket', k, items)
        end
    end
end)

RegisterNetEvent('cframework:requestMarketUpdates', function(locationId)
    local source <const> = source
    receivingUpdates[source] = locationId
end)

RegisterNetEvent('cframework:dismissMarketUpdates', function()
    local source <const> = source
    receivingUpdates[source] = nil
end)

