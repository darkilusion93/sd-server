
RegisterServerEvent('esx_clotheshop:saveOutfit', function(label, skin)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    local store = GetDataStore('property', xPlayer.identifier)

    if store == nil then
        return
    end

    local dressing = store.get('dressing')

    if dressing == nil then
        dressing = {}
    end

    table.insert(dressing, {
        label = label,
        skin  = skin
    })

    store.set('dressing', dressing)
end)

ESX.RegisterServerCallback('esx_clotheshop:buyClothes', function(source, cb)
	local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        cb(false)
        return
    end

	if inventory.removeItem("cash", 25) then
		TriggerClientEvent('esx:showNotification', source, _U('you_paid', 25), 'inform')
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false
    local store = GetDataStore('property', xPlayer.identifier)
    if store ~= nil then
		foundStore = true
	end

	cb(foundStore)
end)

ESX.RegisterServerCallback('esx_property:getPlayerDressing', function(source, cb)
	local xPlayer  = ESX.GetPlayerFromId(source)

    local store = GetDataStore('property', xPlayer.identifier)

    if store == nil then
        cb({})
        return
    end

    local count  = store.count('dressing')
    local labels = {}

    for i=1, count, 1 do
        local entry = store.get('dressing', i)
        table.insert(labels, entry.label)
    end

    cb(labels)
end)

ESX.RegisterServerCallback('esx_property:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = ESX.GetPlayerFromId(source)
    local store = GetDataStore('property', xPlayer.identifier) or {}
    local outfit = store.get('dressing', num)
    cb(outfit.skin)
end)

RegisterNetEvent('esx_property:removeOutfit')
AddEventHandler('esx_property:removeOutfit', function(label)
	local xPlayer = ESX.GetPlayerFromId(source)
    local store = GetDataStore('property', xPlayer.identifier) or {}
	local dressing = store.get('dressing') or {}

	table.remove(dressing, label)
	store.set('dressing', dressing)
end)

RegisterServerEvent('esx_barbershop:pay', function()
	local source = source
    local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        return
    end

	inventory.removeItem("cash", 25)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(25)), 'inform')
end)

ESX.RegisterServerCallback('esx_barbershop:checkMoney', function(source, cb)
    local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        cb(false)
        return
    end

	cb(inventory.canRemoveItem("cash", 25))
end)


RegisterServerEvent('esx_np_skinshop:saveOutfit')
AddEventHandler('esx_np_skinshop:saveOutfit', function(label, skin)
    local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

    local store = GetDataStore('property', xPlayer.identifier) or {}
    local dressing = store.get('dressing')

    if dressing == nil then
        dressing = {}
    end

    table.insert(dressing, {
        label = label,
        skin  = skin
    })

    store.set('dressing', dressing)
end)

ESX.RegisterServerCallback('esx_np_skinshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

    local store = GetDataStore('property', xPlayer.identifier)
    if store ~= nil then
		foundStore = true
	end

	cb(foundStore)
end)

ESX.RegisterServerCallback('esx_tattooshop:requestPlayerTattoos', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer == nil then
        cb()
        return
    end

	if cachedUsers[xPlayer.identifier].tattoos ~= nil then
		cb(json.decode(cachedUsers[xPlayer.identifier].tattoos))
	else
		cb()
	end
end)

ESX.RegisterServerCallback('esx_tattooshop:purchaseTattoo', function(source, cb, tattooList, price, tattoo)
    local xPlayer = ESX.GetPlayerFromId(source)
	local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        cb(false)
        return
    end

	-- FIX (2026-06-12): não confiar no cliente.
	-- (1) price tem de ser inteiro > 0 (idealmente vir de uma tabela de preços
	--     server-side — TODO: Config.TattooPrices[tattoo.id]).
	-- (2) NÃO usar a `tattooList` do cliente (permitia reescrever/inflar a lista
	--     guardada); reconstruir a partir da lista server-side em cache.
	-- (3) `tattoo` tem de ser uma tabela.
	price = tonumber(price)
	if not price or price ~= math.floor(price) or price <= 0 or type(tattoo) ~= "table" then
		cb(false)
		return
	end

	local serverList = {}
	if cachedUsers[xPlayer.identifier] and cachedUsers[xPlayer.identifier].tattoos then
		serverList = json.decode(cachedUsers[xPlayer.identifier].tattoos) or {}
	end

	if inventory.removeItem("cash", price) then
		table.insert(serverList, tattoo)

		MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
			['@tattoos'] = json.encode(serverList),
			['@identifier'] = xPlayer.identifier
		})

		cachedUsers[xPlayer.identifier].tattoos = json.encode(serverList)

		TriggerClientEvent('esx:showNotification', source, _U('bought_tattoo', ESX.Math.GroupDigits(price)))
		cb(true)
	else
		local missingMoney = price - inventory.getItemAmount("cash")
		TriggerClientEvent('esx:showNotification', source, _U('not_enough_money', ESX.Math.GroupDigits(missingMoney)))
		cb(false)
	end
end)


RegisterServerEvent('esx_accessories:pay')
AddEventHandler('esx_accessories:pay', function()
    local source = source
    local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        return
    end

	inventory.removeItem("cash", 25)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid', ESX.Math.GroupDigits(25)), 'inform')
end)

RegisterServerEvent('esx_accessories:save')
AddEventHandler('esx_accessories:save', function(skin, accessory)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    local store = GetDataStore('user_' .. string.lower(accessory), xPlayer.identifier) or {}

    store.set('has' .. accessory, true)

    local itemSkin = {}
    local item1 = string.lower(accessory) .. '_1'
    local item2 = string.lower(accessory) .. '_2'
    itemSkin[item1] = skin[item1]
    itemSkin[item2] = skin[item2]

    store.set('skin', itemSkin)
end)

ESX.RegisterServerCallback('esx_accessories:get', function(source, cb, accessory)
	local xPlayer = ESX.GetPlayerFromId(source)
    local store = GetDataStore('user_' .. string.lower(accessory), xPlayer.identifier) or {}
    local hasAccessory = (store.get('has' .. accessory) and store.get('has' .. accessory) or false)
    local skin = (store.get('skin') and store.get('skin') or {})

    cb(hasAccessory, skin)
end)

ESX.RegisterServerCallback('esx_accessories:checkMoney', function(source, cb)
    local inventory = ESX.getInvContainer(source)

    if inventory == nil then
        cb(false)
        return
    end

	cb(inventory.canRemoveItem("cash", 25))
end)

TriggerEvent('es:addGroupCommand', 'removetattoo', 'admin', function(source, args, user)
	if args[1] == nil then
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Parametros insuficientes.' } })
		return
	end
	MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
		['@tattoos'] = nil,
		['@identifier'] = args[1]
	})

	if cachedUsers[args[1]] ~= nil then
		cachedUsers[args[1]].tattoos = nil
	end

	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Remoção de tatuagens com sucesso.' } })
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('skin')})