-- Title	:	sv_messages.lua
-- Author	:	Gonçalo Costa
-- Started	:	22/12/25

local function getMessagesFromPhoneNumber(myPhoneNumber, phone_number)
    local messages = MySQL.Sync.fetchAll('SELECT * FROM `phone_messages` WHERE receiver = @mePhoneNumber AND transmitter = @phone_number ORDER BY time DESC LIMIT 60', {
        ["@mePhoneNumber"] = myPhoneNumber,
        ["@phone_number"] = phone_number
    })

    return messages
end

local function getLatestMessages(phoneNumber)
    local messages = MySQL.Sync.fetchAll([[
        SELECT pm.*
        FROM phone_messages pm
        INNER JOIN (
            SELECT transmitter, MAX(id) AS last_id
            FROM phone_messages
            WHERE receiver = @receiver
            GROUP BY transmitter
            ORDER BY MAX(id) DESC
            LIMIT 30
        ) t ON pm.id = t.last_id
        ORDER BY pm.time DESC
    ]], {
        ["@receiver"] = phoneNumber
    })

    return messages
end

local function _internalAddMessage(transmitter, receiver, message, owner, btype)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`, `type`) VALUES(@transmitter, @receiver, @message, @isRead, @owner, @type);"
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner,
        ['@type'] = btype,
    }
    MySQL.Sync.insert(Query, Parameters)

    local mess = {
        transmitter = transmitter,
        receiver = receiver,
        message = message,
        isRead = owner,
        owner = owner,
        type = btype,
        time = os.time()*1000.0
    }

    return mess
end

local function deleteAllMessageFromPhoneNumber(myPhoneNumber, phone_number)
    MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = myPhoneNumber,['@phone_number'] = phone_number})
end

local function addMessage(sourcePlayer, myPhoneNumber, phone_number, message, type)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)

    if otherIdentifier ~= nil then
        local tomess = _internalAddMessage(myPhoneNumber, phone_number, message, 0, type)
        local ySource = ESX.GetPlayerIdFromIdentifier(otherIdentifier)

        if ySource ~= nil then
            TriggerClientEvent("cphone:receiveMessage", ySource, tomess)
        end
    end

    local memess = _internalAddMessage(phone_number, myPhoneNumber, message, 1, type)
    TriggerClientEvent("cphone:receiveMessage", sourcePlayer, memess)
end

RegisterServerEvent('cphone:sendMessage', function(message, phoneNumber, type)
    local source = source
	local myPhoneNumber = ESX.getPhoneNumber(source)

    if myPhoneNumber == nil then
        TriggerClientEvent('esx:showNotification', source, 'Sem número de telémovel. Usa um cartão SIM para te ser atribuído um número.', 'error')
        return
    end

    if type == 'location' then
        message = json.encode(GetEntityCoords(GetPlayerPed(source)))
    end

    if type == 'image' or type == 'audio' or type == 'video' then
        local prefix = "https://cdn.Sem Destinorp.net/files/"
        if string.sub(message, 1, #prefix) ~= prefix then
            return
        end
    end

    addMessage(source, myPhoneNumber, phoneNumber, message, type)
end)

RegisterServerEvent('cphone:setReadMessageNumber', function(num)
    local source <const> = source
	local myPhoneNumber = ESX.getPhoneNumber(source)

    MySQL.Async.execute("UPDATE phone_messages SET isRead = 1 WHERE receiver = @mePhoneNumber AND transmitter = @num AND isRead = 0", {
        ['@mePhoneNumber'] = myPhoneNumber,
        ['@num'] = num
    })
end)

RegisterServerEvent('cphone:deleteMessageNumber', function(number)
    local source = source
	local myPhoneNumber = ESX.getPhoneNumber(source)
    local identifier = ESX.getIdentifier(source)

    deleteAllMessageFromPhoneNumber(myPhoneNumber, number)
end)

RegisterNetEvent("cphone:getLatestMessages", function()
    local source = source
    local myPhoneNumber = ESX.getPhoneNumber(source)

    if myPhoneNumber == nil then
        TriggerClientEvent('esx:showNotification', source, 'Sem número de telémovel. Usa um cartão SIM para te ser atribuído um número.', 'error')
        return
    end

    local messages = getLatestMessages(myPhoneNumber)
    TriggerClientEvent("cphone:loadLatestMessages", source, messages)
end)

RegisterNetEvent("cphone:getMessagesFromPhoneNumber", function(phone_number)
    local source = source
    local myPhoneNumber = ESX.getPhoneNumber(source)

    if myPhoneNumber == nil then
        TriggerClientEvent('esx:showNotification', source, 'Sem número de telémovel. Usa um cartão SIM para te ser atribuído um número.', 'error')
        return
    end

    local messages = getMessagesFromPhoneNumber(myPhoneNumber, phone_number)
    TriggerClientEvent("cphone:loadMessagesFromPhoneNumber", source, phone_number, messages)
end)

AddEventHandler("cphone:addMessagePhoneArtificial", function(sourcePlayer, phone_number, myPhone, message)
    if myPhone == nil then
        TriggerClientEvent('esx:showNotification', source, 'Sem número de telémovel. Usa um cartão SIM para te ser atribuído um número.', 'error')
        return
    end

    local memess = _internalAddMessage(phone_number, myPhone, message, 0, 'message')
    TriggerClientEvent("cphone:receiveMessage", sourcePlayer, memess)
end)