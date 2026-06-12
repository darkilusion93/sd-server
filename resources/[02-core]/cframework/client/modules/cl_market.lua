

local marketData = LoadMarket()
local CurrentAction, CurrentLocation = nil, nil
local inCenter = false
local vaultLocation <const> = marketData.vaultLocation
local marketShops <const> = marketData.marketShops
local marketCenter <const>, marketCenterRadius <const> = marketData.marketCenter, marketData.centerRadius

local function marketShopMenu(isFree, isOwner, isPolice, isLocked, ownerName)
    local elements = {}

    if isFree then
        table.insert(elements, { label = '💵 ' .. string.format(T("MARKET_RENT"), ESX.formatAsCurrency(marketData.rentPrice)), value = 'rent_shop' })
    elseif isOwner then
        table.insert(elements, { label = string.format('📦 %s', T("MARKET_SHOP")), value = 'shop_inventory' })
        table.insert(elements, { label = string.format('📃 %s', T("MARKET_MANAGEMENT")), value = 'shop_management' })
        table.insert(elements, { label = string.format('❌ %s', T("MARKET_CLOSE")), value = 'sell_shop' })
    else
        table.insert(elements, { label = string.format('📦 %s', T("MARKET_SHOP")), value = 'shop_inventory' })
    end

    if not isFree and isPolice then
        if isLocked then
            table.insert(elements, { label = string.format('🔓 %s', T("MARKET_UNLOCK")), value = 'toggle_lock_shop' })
        else
            table.insert(elements, { label = string.format('🔒 %s', T("MARKET_LOCK")), value = 'toggle_lock_shop' })
        end
    end

    TriggerEvent('chud:menu', elements, T("MARKET_SHOP") .. ownerName, function(value)
        if value == 'rent_shop' then
            TriggerEvent('esx_inventoryhud:doClose')
            TriggerServerEvent("cframework:rentMarketShop", CurrentLocation)
        end

        if value == 'shop_inventory' then
            TriggerEvent("cframework:openMarketInventory", CurrentLocation)
        end

        if value == 'shop_management' then
            TriggerServerEvent('cframework:dismissMarketUpdates')
            TriggerEvent("cframework:openMarketManagement", CurrentLocation)
        end

        if value == 'toggle_lock_shop' then
            TriggerEvent('esx_inventoryhud:doClose')
            TriggerServerEvent("cframework:toggleLockMarketShop", CurrentLocation)
        end

        if value == 'sell_shop' then
            TriggerEvent('esx_inventoryhud:doClose')
            TriggerServerEvent("cframework:stopMarketShop", CurrentLocation)
        end
    end)
end

Citizen.CreateThread(function()
    for i=1, #vaultLocation, 1 do
        exports.ft_libs:AddMarker("market_vault" .. i, {type = 50, x = vaultLocation[i].x, y = vaultLocation[i].y, z = vaultLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("market_vault" .. i, {x = vaultLocation[i].x, y = vaultLocation[i].y, z = vaultLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "marketEnteredMarker"}, exit = {eventClient = "marketExitedMarker"}, data = {'vault', vaultLocation[i].vaultId}, active = {}})
    end

    for i=1, #marketShops, 1 do
        exports.ft_libs:AddMarker("market_shop" .. i, {type = 50, x = marketShops[i].x, y = marketShops[i].y, z = marketShops[i].z, weight = 1, height = 1, red = 255, green = 0, blue = 100, showDistance = 25})
        exports.ft_libs:AddTrigger("market_shop" .. i, {x = marketShops[i].x, y = marketShops[i].y, z = marketShops[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "marketEnteredMarker"}, exit = {eventClient = "marketExitedMarker"}, data = {'shop', marketShops[i].id}, active = {}})
    end

    for i=1, #marketCenter, 1 do
        exports.ft_libs:AddTrigger("market_center" .. i, {x = marketCenter[i].x, y = marketCenter[i].y, z = marketCenter[i].z, weight = marketCenterRadius, height = 20,
        enter = {eventClient = "marketEnteredCenter"}, exit = {eventClient = "marketExitedCenter"}, data = {}, active = {}})
    end
end)

RegisterNetEvent("cframework:openMarketShopMenu", function(isFree, isOwner, isPolice, isLocked, ownerName)
    marketShopMenu(isFree, isOwner, isPolice, isLocked, ownerName)
end)

RegisterNetEvent('marketEnteredCenter', function()
    if inCenter then
        return
    end

    inCenter = true

    while inCenter do
        DisableControlAction(0, VK_SPACE, true)
        DisableControlAction(0, VK_LSHIFT, true)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('marketExitedCenter', function()
    inCenter = false
end)


RegisterNetEvent('marketEnteredMarker', function(action)
    CurrentAction = action[1]
    CurrentLocation = action[2]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            if ESX.isHandcuffed() then
                goto final
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'vault' then
                CurrentAction = nil
                TriggerEvent("cframework:openPropertyInventory", CurrentLocation)
            end

            if CurrentAction == 'shop' then
                CurrentAction = nil
                TriggerServerEvent("cframework:openMarketShopMenu", CurrentLocation)
            end

            ::final::

            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('marketExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)