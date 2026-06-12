local lastCallId = 10
local fixedPhonesCalls = {}
local fixedPhones = {
    ['800'] = {doesExist = true, caller = nil},
    ['801'] = {doesExist = true, caller = nil},
    ['112'] = {doesExist = true, caller = nil},
}
local cachedPhoneCalls = {}
local Calls = {}


RegisterServerEvent('cframework:cphone:EditContact', function(newName, newNumber, newIban, oldName, oldNumber, oldIban)
    local source = source
    local identifier = ESX.getIdentifier(source)

    ESX.editContact(identifier, newName, newNumber, newIban, oldName, oldNumber, oldIban)

    MySQL.Async.execute("UPDATE `phone_users_contacts` SET `display` = @display, `number` = @number, `iban` = @iban WHERE `identifier` = @identifier AND `display` = @oldDisplay AND `number` = @oldNumber", {
        ['@display'] = newName,
        ['@number'] = newNumber,
        ['@iban'] = newIban,
        ['@identifier'] = identifier,
        ['@oldDisplay'] = oldName,
        ['@oldNumber'] = oldNumber
    })
end)

RegisterServerEvent('cframework:cphone:AddNewContact', function(name, number, iban)
    local source = source
    local identifier = ESX.getIdentifier(source)

    ESX.addContact(identifier, tostring(name), tostring(number), tostring(iban))

    MySQL.Async.execute("INSERT INTO `phone_users_contacts` (`identifier`, `display`, `number`, `iban`) VALUES (@identifier, @display, @number, @iban)", {
        ['@identifier'] = identifier,
        ['@display'] = tostring(name),
        ['@number'] = tostring(number),
        ['@iban'] = tostring(iban)
    })
end)

RegisterServerEvent('cframework:cphone:RemoveContact', function(Name, Number)
    local source = source
    local identifier = ESX.getIdentifier(source)

    ESX.deleteContact(identifier, Name, Number)

    MySQL.Async.execute("DELETE FROM `phone_users_contacts` WHERE `display` = @display AND `number` = @number AND `identifier` = @identifier", {
        ['@display'] = Name,
        ['@number'] = Number,
        ['@identifier'] = identifier
    })
end)


RPC.register('cframework:cphone:GetCallState', function(ContactData)
    local xPlayer = ESX.GetPlayerFromPhoneNumber(ContactData.number)

    if xPlayer ~= nil then
        if Calls[xPlayer.identifier] ~= nil then
            if Calls[xPlayer.identifier].inCall then
                return false, true, false --Está em chamada
            else
                return true, true, false --Pode ligar
            end
        else
            return true, true, false --Pode ligar
        end
    else
        if fixedPhones[ContactData.number] and fixedPhones[ContactData.number].doesExist then
            if fixedPhonesCalls[ContactData.number] then
                return false, true, true -- Fixo está ocupado
            else
                return true, true, true --Pode ligar para o fixo
            end
        else
            return true, false, false --Pode ligar mas ninguem vai atender
        end
    end
end)

RPC.register('generateCallId', function()
    local indexCall = lastCallId
    lastCallId = lastCallId + 1

    return indexCall
end)

RegisterServerEvent('cphone:server:CancelCall', function(ContactData)
    local Ply = ESX.GetPlayerFromPhoneNumber(ContactData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('cphone:client:CancelCall', Ply.source)
    elseif fixedPhones[ContactData.TargetData.number] and fixedPhones[ContactData.TargetData.number].doesExist then
        TriggerClientEvent('cphone:client:CancelCallFixed', -1, ContactData.TargetData.number)
    end
end)

RegisterServerEvent('cframework:cphone:AddRecentCall', function(accepted, receiverNumber, anonymous)
    local source = source
    local transmiterNumber = ESX.getPhoneNumber(source)

    if transmiterNumber == nil or receiverNumber == nil then return end

    MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`, `anonymous`) VALUES(@owner, @num, @incoming, @accepts, @anonymous)", {
        ['@owner'] = transmiterNumber,
        ['@num'] = receiverNumber,
        ['@incoming'] = 0,
        ['@accepts'] = accepted,
        ['@anonymous'] = anonymous
    })

    if cachedPhoneCalls[transmiterNumber] == nil then loadHistoriqueCall(transmiterNumber) end

    table.insert(cachedPhoneCalls[transmiterNumber], {
        owner = transmiterNumber,
        num = receiverNumber,
        incoming = 0,
        accepts = accepted,
        tempo = os.time()
    })

    TriggerClientEvent('cframework:cphone:notifyNewRecentCall', source, receiverNumber, 0, accepted, anonymous, os.time())

    local num = transmiterNumber
    if anonymous then
        num = "###-####"
    end

    MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`, `anonymous`) VALUES(@owner, @num, @incoming, @accepts, @anonymous)", {
        ['@owner'] = receiverNumber,
        ['@num'] = num,
        ['@incoming'] = 1,
        ['@accepts'] = accepted,
        ['@anonymous'] = anonymous
    })

    if cachedPhoneCalls[receiverNumber] == nil then loadHistoriqueCall(receiverNumber) end

    table.insert(cachedPhoneCalls[receiverNumber], {
        owner = receiverNumber,
        num = num,
        incoming = 1,
        accepts = accepted,
        tempo = os.time()
    })

    local ySource = ESX.GetSourceFromPhoneNumber(receiverNumber)
    if ySource ~= nil then
        TriggerClientEvent('cframework:cphone:notifyNewRecentCall', ySource, num, 1, accepted, anonymous, os.time())
    end
end)

RegisterServerEvent('cphone:server:SetCallState', function(bool)
    local source = source
    local identifier = ESX.getIdentifier(source)

    if Calls[identifier] ~= nil then
        Calls[identifier].inCall = bool
    else
        Calls[identifier] = {}
        Calls[identifier].inCall = bool
    end
end)

RegisterServerEvent('cphone:server:SetCallStateFixed', function(number, bool)
    fixedPhonesCalls[number] = bool
end)

RegisterServerEvent('cphone:server:CallContact', function(TargetData, CallId, AnonymousCall, isVideo)
    local source = source
    local sourcePhone = ESX.getPhoneNumber(source)
    local xTarget = ESX.GetPlayerFromPhoneNumber(TargetData.number)

    if xTarget ~= nil then
        TriggerClientEvent('cphone:client:GetCalled', xTarget.source, sourcePhone, CallId, AnonymousCall, isVideo)
    end
end)

RegisterServerEvent('cphone:server:CallContactFixed', function(TargetData, CallId, AnonymousCall)
    local source = source
    local sourcePhone = ESX.getPhoneNumber(source)

    fixedPhones[TargetData.number].caller = source

    TriggerClientEvent('cphone:client:GetCalledFixed', -1, TargetData.number,sourcePhone, CallId, AnonymousCall)
end)


function loadHistoriqueCall(num)
    if num == nil then return end

    local calls = MySQL.Sync.fetchAll('SELECT id, owner, num, incoming, UNIX_TIMESTAMP(time) AS tempo, accepts, anonymous FROM phone_calls WHERE owner = @owner ORDER BY time', {
        ["@owner"] = num
    })

    if cachedPhoneCalls[num] == nil then cachedPhoneCalls[num] = {} end

    if calls == nil or calls[1] == nil then return end

    cachedPhoneCalls[num] = calls
end

function getHistoriqueCall(num)
    if num == nil then return {} end
    if cachedPhoneCalls[num] == nil then loadHistoriqueCall(num) end

    if #cachedPhoneCalls[num] < 120 then return cachedPhoneCalls[num] end

    local new_table = {}

    for i = #cachedPhoneCalls[num] - 119, #cachedPhoneCalls[num] do
        -- Use the table.insert function to add the element at index i to the new table
        table.insert(new_table, cachedPhoneCalls[num][i])
    end

    return new_table
end

RegisterServerEvent('cphone:server:FixedCancelCall', function(number)
    if fixedPhones[number] then
        TriggerClientEvent('cphone:client:CancelCall', fixedPhones[number].caller)
    end
end)

RegisterServerEvent('cphone:server:AnswerCall', function(CallData)
    local Ply = ESX.GetPlayerFromPhoneNumber(CallData.TargetData.number)

    if Ply ~= nil then
        TriggerClientEvent('cphone:client:AnswerCall', Ply.source)
    end
end)

RegisterServerEvent('cphone:server:AnswerCallFixed', function(number)
    local Ply = ESX.GetPlayerFromPhoneNumber(number)

    if Ply ~= nil then
        TriggerClientEvent('cphone:client:AnswerCall', Ply.source)
    end
end)
