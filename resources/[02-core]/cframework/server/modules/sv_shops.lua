

local function getItemPrice(zone, item)
    for _, shopItem in ipairs(ESX.Shops[zone].items) do
        if shopItem.name == item then
            return shopItem.price
        end
    end
    return 0
end

local function getItemCount(zone, item)
    for _, shopItem in ipairs(ESX.Shops[zone].items) do
        if shopItem.name == item and shopItem.count ~= nil then
            return shopItem.count
        end
    end
    return 1
end

local function hasEnoughMoney(source, moneyType, price)
    if moneyType == "black_money" then
        return ESX.getInvContainer(source).canRemoveItem('black_money', price)
    elseif moneyType == "coins" then
        return ESX.getCoins(source) >= price
    elseif moneyType == "cash" then
        return ESX.getInvContainer(source).canRemoveItem('cash', price)
    end
    return false
end

local function deductMoney(source, moneyType, price)
    if moneyType == "black_money" then
        ESX.getInvContainer(source).removeItem('black_money', price)
    elseif moneyType == "coins" then
        ESX.removeCoins(source, price)
    elseif moneyType == "cash" then
        ESX.getInvContainer(source).removeItem('cash', price)
    end
end

local function addSocietyMoney(society, amount)
    GetSharedAccount(society).addMoney(amount)
end

RPC.register("cframework:getPlayersInJob", function(job)
    local i = 0

    for _, _ in pairs(ESX.getJobSourceList(job)) do i = i + 1 end

    return i
end)

RegisterServerEvent("cframework:buyItem", function(itemName, amount, zone, slot)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    amount = ESX.Math.Round(amount)

    if amount <= 0 or inventory == nil then return end

    local price <const> = getItemPrice(zone, itemName) * amount
    local itemCount <const> = getItemCount(zone, itemName)

    if price == 0 then
        TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Shop Exploit', nil, false)
        return
    end

    local moneyType <const> = ESX.Shops[zone].moneyType
    local locations <const> = ESX.Shops[zone].Pos
    local society <const>   = ESX.Shops[zone].society

    if not ESX.playerInsideLocation(source, locations, 10.0) then
        return
    end

    if not hasEnoughMoney(source, moneyType, price) then
        TriggerClientEvent('esx:showNotification', source, T("GENERIC_NOT_ENOUGH_MONEY"), 'error')
        return
    end

    if inventory.addItem(itemName, amount * itemCount, slot) then
        deductMoney(source, moneyType, price)

        --ESX.logShopsData(source, "comprar", zone, itemName, amount, ESX.GetItemLabel(itemName))
    end

    if society ~= nil then
        addSocietyMoney("society_" .. society, price)
    end
end)

