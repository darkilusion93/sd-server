ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Code

Hashtags = {}
Adverts = {}
Tinder = {}
Darkweb = {}

RegisterServerEvent('cphone:server:AddAdvert', function(msg, image, atype)
    local source = source
    local identifier = ESX.getIdentifier(source)
    local name = "@"..ESX.getFirstName(source)..""..ESX.getLastName(source)
    local number = ESX.getPhoneNumber(source)
    local money = ESX.getAccount(source, 'bank').money
    local job = ESX.getJob(source).name

    if atype == 'personal' then
        if money < 2500 then TriggerClientEvent('esx:showNotification', source, 'Dinheiro Insuficiente.', 'error')
            return
        end
        
        ESX.removeAccountMoney(source, 'bank', 2500)

        table.insert(Adverts, {
            message = msg,
            name = name,
            image = image,
            number = number,
            type = atype,
        })

        TriggerClientEvent('cphone:client:UpdateAdverts', -1, msg, image, name, number, 'personal', '', '')
    elseif atype == 'business' then
        if not Config.BusinessAdverts[job] then return end

        table.insert(Adverts, {
            message = msg,
            image = image,
            name = name,
            number = Config.BusinessAdverts[job].header,
            type = atype,
            color = Config.BusinessAdverts[job].color,
            textcolor = Config.BusinessAdverts[job].textcolor
        })

        TriggerClientEvent('cphone:client:UpdateAdverts', -1, msg, image, name, Config.BusinessAdverts[job].header, 'business', Config.BusinessAdverts[job].color, Config.BusinessAdverts[job].textcolor)
    end

    
end)

RegisterServerEvent('cphone:server:AddDarkweb', function(msg)
    local source = source
    local identifier = ESX.getIdentifier(source)
    local name = "@"..ESX.getFirstName(source)..""..ESX.getLastName(source)
    local number = ESX.getPhoneNumber(source)

    --[[if Darkweb[identifier] ~= nil then
        Darkweb[identifier].message = msg
        Darkweb[identifier].name = name
        Darkweb[identifier].number = number
    else
        Darkweb[identifier] = {
            message = msg,
            name = name,
            number = number,
        }
    end]]

    local money = ESX.getAccount(source, 'bank').money

    if money < 10000 then TriggerClientEvent('esx:showNotification', source, 'Dinheiro Insuficiente.', 'error')
        return
    end

    ESX.removeAccountMoney(source, 'bank', 10000)

    table.insert(Darkweb, {
        message = msg,
        name = name,
        number = number,
    })

    TriggerClientEvent('cphone:client:UpdateDarkweb', -1, msg, name, number)
end)

RegisterServerEvent('cphone:server:AddTinder', function(msg, picture)
    local source = source
    local identifier = ESX.getIdentifier(source)
    local name = ESX.getFirstName(source).." "..ESX.getLastName(source)
    local number = ESX.getPhoneNumber(source)

    if Tinder[identifier] ~= nil then
        Tinder[identifier].message = msg
        Tinder[identifier].name = name
        Tinder[identifier].number = number
        Tinder[identifier].picture = picture
    else
        Tinder[identifier] = {
            message = msg,
            name = name,
            number = number,
            picture = picture,
        }
    end

    TriggerClientEvent('cphone:client:UpdateTinder', -1, Tinder, name)
end)

function GetOnlineStatus(number)
    return false--ESX.GetPlayerOnlineFromPhoneNumber(number)
end

--RPC.register('cphone:server:GetPhoneData', function()
function GetPhoneData(source)
    local source = source
    local identifier = ESX.getIdentifier(source)
    local PhoneNumber = ESX.getPhoneNumber(source)

    local bankMoney = ESX.getAccount(source, 'bank').money
    local playerIban = ESX.getIban(source)

    local firstname = ESX.getFirstName(source)
    local lastname = ESX.getLastName(source)

    local PhoneData = {
        Applications = {},
        PlayerContacts = {
           -- {name = 'INEM', number = 'ambulance', status = true}
        },
        RecentCalls = {},
        Chats = {},
        TransactionData = {},
        Hashtags = {},
        Invoices = {},
        Garage = {},
        Mails = {},
        Adverts = {},
        Darkweb = {},
        CryptoTransactions = {},
        InstalledApps = {},
        myPhoneNumber = PhoneNumber,
        identifier = identifier,
        bank = bankMoney,
        iban = playerIban,
        firstName = firstname,
        lastName = lastname,
        source = source,
    }

    PhoneData.Adverts = Adverts
    PhoneData.Darkweb = Darkweb
    PhoneData.Tinder = Tinder

    local contacts = ESX.getContacts(identifier)
    local userContacts = {}
    
    if contacts ~= nil and next(contacts) ~= nil then 
        for k, v in ipairs(contacts) do
            table.insert(userContacts, {
                id = v.id,
                identifier = v.identifier,
                number = v.number,
                iban = v.iban,
                display = v.display,
                name = v.display,
                status = false,
            })
        end
    end

    PhoneData.PlayerContacts = userContacts


    local billing = ESX.getBills(identifier)
    local bills = {}

    for i=1, #billing, 1 do
        table.insert(bills, {
            id         = billing[i].id,
            identifier = billing[i].identifier,
            sender     = billing[i].sender,
            targetType = billing[i].target_type,
            target     = billing[i].target,
            label      = billing[i].label,
            amount     = billing[i].amount,
            time       = billing[i].time,
            type       = 'bill'
        })
    end

    PhoneData.Invoices = bills

    --local messages = .Sync.fetchAll("SELECT * FROM phone_messages_new WHERE `identifier` = '"..identifier.."'")
    
    --if messages ~= nil and next(messages) ~= nil then 
    --TriggerClientEvent('cphone:allMessage', source, (identifier))
    --end

    local transaction = ESX.getTransactions(identifier)
    
    if transaction ~= nil and next(transaction) ~= nil then 
        PhoneData.TransactionData = transaction
    end

    if Hashtags ~= nil and next(Hashtags) ~= nil then
        PhoneData.Hashtags = Hashtags
    end

    local mails = {}--.Sync.fetchAll('SELECT * FROM `player_mails` WHERE `identifier` = "'..identifier..'" ORDER BY `date` ASC')

    if mails[1] ~= nil then
        for k, v in pairs(mails) do
            if mails[k].button ~= nil then
                mails[k].button = json.decode(mails[k].button)
            end
        end
        PhoneData.Mails = {}
    end

    local calls = getHistoriqueCall(PhoneNumber)

    if calls[1] ~= nil then
        PhoneData.RecentCalls = calls
    end

    local boostCoins = ESX.getBoostCoins(source)

    PhoneData.boostCoins = boostCoins

    TriggerClientEvent('cphone:loaded', source, PhoneData)
    --TriggerClientEvent('cphone:loaded', source, PhoneData)
    --return PhoneData
end



RegisterServerEvent('cphone:server:RemoveMail', function(MailId)
    --[[local source = source
    local identifier = ESX.getIdentifier(source)

    .Sync.execute('DELETE FROM `player_mails` WHERE `mailid` = "'..MailId..'" AND `identifier` = "'..identifier..'"')

    SetTimeout(100, function()
        .Async.fetchAll('SELECT * FROM `player_mails` WHERE `identifier` = @identifier ORDER BY `date` ASC', {
            ['@identifier'] = identifier
        }, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('cphone:client:UpdateMails', source, mails)
        end)
    end)]]
end)

function getIdentifierByPhoneNumber(phone_number)
    local identifier = ESX.GetPlayerIdentifierFromPhoneNumber(phone_number)

    if identifier ~= nil then
        return identifier
    end

    return ESX.getIdentifierByPhoneNumberOffline(phone_number)
end

function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1)

	return num
end

RegisterServerEvent('gcPhone:useSimCard', function(source, slot)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local inventory = xPlayer.getInvContainer()
    local myPhoneNumber = nil

    if not inventory.canRemoveItem('simcard', 1, slot) then
        return
    end

    repeat
        myPhoneNumber = getPhoneRandomNumber()
        local id = getIdentifierByPhoneNumber(myPhoneNumber)
    until id == nil

    inventory.removeItem('simcard', 1, slot)
    xPlayer.setPhoneNumber(myPhoneNumber)

    GetPhoneData(_source)
end)


ESX.RegisterUsableItem('simcard', function (source, slot)
    TriggerEvent('gcPhone:useSimCard', source, slot)
end)

function GenerateMailId()
    return math.random(111111, 999999)
end

RegisterServerEvent('qb-phone:server:sendNewMail', function(mailData)
    --[[local source = source
    local identifier = ESX.getIdentifier(source)

    if mailData.button == nil then
        .Sync.execute("INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..identifier.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        .Sync.execute("INSERT INTO `player_mails` (`identifier`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..identifier.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    TriggerClientEvent('cphone:client:NewMailNotify', source, mailData)
    SetTimeout(200, function()
        .Async.fetchAll('SELECT * FROM `player_mails` WHERE `identifier` = @identifier ORDER BY `date` DESC', {
            ['@identifier'] = identifier
        }, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('cphone:client:UpdateMails', source, mails)
        end)
    end)]]
end)

RegisterServerEvent('qb-phone:server:sendNewMailToOffline', function(citizenid, mailData)
    --[[local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)

    if Player ~= nil then
        local src = Player.PlayerData.source

        if mailData.button == nil then
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
            TriggerClientEvent('cphone:client:NewMailNotify', src, mailData)
        else
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..Player.PlayerData.citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
            TriggerClientEvent('cphone:client:NewMailNotify', src, mailData)
        end

        SetTimeout(200, function()
            QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
                if mails[1] ~= nil then
                    for k, v in pairs(mails) do
                        if mails[k].button ~= nil then
                            mails[k].button = json.decode(mails[k].button)
                        end
                    end
                end
        
                TriggerClientEvent('cphone:client:UpdateMails', src, mails)
            end)
        end)
    else
        if mailData.button == nil then
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
        else
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
        end
    end]]
end)

RegisterServerEvent('qb-phone:server:sendNewEventMail', function(citizenid, mailData)
    --[[if mailData.button == nil then
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0')")
    else
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `player_mails` (`citizenid`, `sender`, `subject`, `message`, `mailid`, `read`, `button`) VALUES ('"..citizenid.."', '"..mailData.sender.."', '"..mailData.subject.."', '"..mailData.message.."', '"..GenerateMailId().."', '0', '"..json.encode(mailData.button).."')")
    end
    SetTimeout(200, function()
        QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `player_mails` WHERE `citizenid` = "'..Player.PlayerData.citizenid..'" ORDER BY `date` DESC', function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('cphone:client:UpdateMails', src, mails)
        end)
    end)]]
end)

RegisterServerEvent('cphone:server:ClearButtonData', function(mailId)
    local source = source
    local identifier = ESX.getIdentifier(source)

    --[[.Sync.execute('UPDATE `player_mails` SET `button` = "" WHERE `mailid` = "'..mailId..'" AND `identifier` = "'..identifier..'"')
    
    SetTimeout(200, function()
        .Async.fetchAll('SELECT * FROM `player_mails` WHERE `identifier` = @identifier ORDER BY `date` DESC', {
            ['@identifier'] = identifier
        }, function(mails)
            if mails[1] ~= nil then
                for k, v in pairs(mails) do
                    if mails[k].button ~= nil then
                        mails[k].button = json.decode(mails[k].button)
                    end
                end
            end
    
            TriggerClientEvent('cphone:client:UpdateMails', source, mails)
        end)
    end)]]
end)



RegisterServerEvent('cphone:server:UpdateHashtags', function(Handle, messageData)
    if Hashtags[Handle] ~= nil and next(Hashtags[Handle]) ~= nil then
        table.insert(Hashtags[Handle].messages, messageData)
    else
        Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(Hashtags[Handle].messages, messageData)
    end
    TriggerClientEvent('cphone:client:UpdateHashtags', -1, Handle, messageData)
end)


RPC.register('cphone:server:GetPicture', function(number)
    --local Player = QBCore.Functions.GetPlayerByPhone(number)
    --local Picture = nil

    --QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `charinfo` LIKE '%"..number.."%'", function(result)
    --    if result[1] ~= nil then
    --        local MetaData = json.decode(result[1].metadata)

     --       if MetaData.phone.profilepicture ~= nil then
    --            Picture = MetaData.phone.profilepicture
     --       else
    --            Picture = "default"
     --       end
    --        cb(Picture)
     --   else
     --       cb(nil)
     --   end
    --end)
    return 'default'
end)

RegisterServerEvent('qb-phone:server:SetPhoneAlerts', function(app, alerts)
    local source = source
    local identifier = ESX.getIdentifier(source)
end)


RegisterServerEvent('cphone:server:TransferMoney', function(iban, amount)
    local src = source

end)





RegisterServerEvent('cphone:server:SaveMetaData', function(MData)
    --Metadata do telemovel
end)

function escape_sqli(source)
    local replacements = { ['"'] = '\\"', ["'"] = "\\'" }
    return source:gsub( "['\"]", replacements ) -- or string.gsub( source, "['\"]", replacements )
end

RPC.register('cphone:server:FetchResult', function(search)
    --[[local src = source
    local search = escape_sqli(search)
    local searchData = {}
    local ApaData = {}

    local query = 'SELECT * FROM `players` WHERE `citizenid` = "'..search..'"'
    -- Split on " " and check each var individual
    local searchParameters = SplitStringToArray(search)
    
    -- Construct query dynamicly for individual parm check
    if #searchParameters > 1 then
        query = query .. ' OR `charinfo` LIKE "%'..searchParameters[1]..'%"'
        for i = 2, #searchParameters do
            query = query .. ' AND `charinfo` LIKE  "%' .. searchParameters[i] ..'%"'
        end
    else
        query = query .. ' OR `charinfo` LIKE "%'..search..'%"'
    end
    
    QBCore.Functions.ExecuteSql(false, query, function(result)
        QBCore.Functions.ExecuteSql(false, 'SELECT * FROM `apartments`', function(ApartmentData)
            for k, v in pairs(ApartmentData) do
                ApaData[v.citizenid] = ApartmentData[k]
            end

            if result[1] ~= nil then
                for k, v in pairs(result) do
                    local charinfo = json.decode(v.charinfo)
                    local metadata = json.decode(v.metadata)
                    local appiepappie = {}
                    if ApaData[v.citizenid] ~= nil and next(ApaData[v.citizenid]) ~= nil then
                        appiepappie = ApaData[v.citizenid]
                    end
                    table.insert(searchData, {
                        citizenid = v.citizenid,
                        firstname = charinfo.firstname,
                        lastname = charinfo.lastname,
                        birthdate = charinfo.birthdate,
                        phone = charinfo.phone,
                        nationality = charinfo.nationality,
                        gender = charinfo.gender,
                        warrant = false,
                        driverlicense = metadata["licences"]["driver"],
                        appartmentdata = appiepappie,
                    })
                end
                cb(searchData)
            else
                cb(nil)
            end
        end)
    end)]]
    return nil
end)

function SplitStringToArray(string)
    local retval = {}
    for i in string.gmatch(string, "%S+") do
        table.insert(retval, i)
    end
    return retval
end

--[[QBCore.Functions.CreateCallback('cphone:server:HasPhone', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        local HasPhone = Player.Functions.GetItemByName("phone")
        local retval = false

        if HasPhone ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)]]




RegisterServerEvent('cphone:server:AddTransaction', function(data)
    --Cripto
end)

local function countMembers(job)
    local i = 0

    for _, _ in pairs(ESX.getJobSourceList(job)) do i = i + 1 end

    return i
end

RPC.register('cphone:server:GetCurrentServices', function()
    local Services = {}

    local nPolice = countMembers('police')
    local nAmbulance = countMembers('ambulance')

    local nMechanic = countMembers('oficina2')
    local nMosley = countMembers('oficina3')
    local nHarmony = countMembers('oficina1')
    local nNautica = countMembers('nautica')
    local nTaxi = countMembers('taxi')
    local nIlegal4 = countMembers('ilegal4')

    local nPlay = countMembers('weazelnews')
    local nTribunal = countMembers('tribunal')

    if nPolice > 0 then
        table.insert(Services, {
            name = 'Policia',
            phone = 'police',
        })
    end

    if nAmbulance > 0 then
        table.insert(Services, {
            name = 'EMS',
            phone = 'ambulance',
        })
    end

    --codigo novo
    if nMechanic > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('oficina2')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Benny's",
            phone = 'oficina2',
            numbers = numbersTable
        })
    end

    if nMosley > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('oficina3')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Temper Customs",
            phone = 'oficina3',
            numbers = numbersTable
        })
    end

    if nHarmony > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('oficina1')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "6STR",
            phone = 'oficina1',
            numbers = numbersTable
        })
    end

    if nPlay > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('weazelnews')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Sem Destino Play",
            phone = 'weazelnews',
            numbers = numbersTable
        })
    end

    if nTribunal > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('tribunal')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Tribunal",
            phone = 'tribunal',
            numbers = numbersTable
        })
    end

    if nNautica > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('nautica')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Nautica",
            phone = 'nautica',
            numbers = numbersTable
        })
    end

    if nTaxi > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('taxi')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Sea and Sky Customs",
            phone = 'taxi',
            numbers = numbersTable
        })
    end

    if nIlegal4 > 0 then
        local numbersTable = {}

        for player, _ in pairs(ESX.getJobSourceList('staff')) do
           table.insert(numbersTable, ESX.getPhoneNumber(player))
        end

        table.insert(Services, {
            name = "Abrigo do Pastor",
            phone = 'ilegal4',
            numbers = numbersTable
        })
    end

    return Services
end)

RegisterServerEvent('cphone:server:InstallApplication', function(ApplicationData)

end)

RegisterServerEvent('cphone:server:RemoveInstallation', function(App)

end)

RPC.register('mobileMoneyTransfer', function(iban, rAmount)
    local source = source

    local xPlayer = ESX.GetPlayerFromId(source)
    local zPlayer = nil
    local amount <const> = math.floor(rAmount)

    if tonumber(iban) ~= nil and tonumber(iban) > 0 then
        zPlayer = ESX.GetPlayerFromId(tonumber(iban))

        if zPlayer == nil then return false end
    else
        zPlayer = ESX.GetPlayerFromIban(iban)
    end

    if zPlayer == nil then
        local zUser = MySQL.Sync.fetchAll("SELECT * FROM users WHERE `iban` = @iban", {
            ['@iban'] = iban
        })[1]
        if zUser == nil then
            return false
        end

        local balance = xPlayer.getAccount('bank').money
    
        if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
            return false
        end

        xPlayer.removeAccountMoney('bank', tonumber(amount))
        MySQL.Async.execute("UPDATE `users` SET `bank` = `bank` + '"..tonumber(amount).."' WHERE `identifier` = '"..zUser.identifier.."'")
   
        return true
    end

    if tonumber(source) == tonumber(zPlayer.source) then
        return false
    end
    
    local balance = xPlayer.getAccount('bank').money
    local zbalance = zPlayer.getAccount('bank').money

    if balance <= 0 or balance < tonumber(amount) or tonumber(amount) <= 0 then
        return false
    end

    xPlayer.removeAccountMoney('bank', tonumber(amount))
    zPlayer.addAccountMoney('bank', tonumber(amount))

    ESX.LogTransfers(source, zPlayer.source, "TRANSFERIR", "money", tonumber(amount), "Dinheiro")

    TriggerEvent("gbank:registerTransaction", xPlayer.identifier, "personal", -amount, "transfer", zPlayer.getFirstName() .. ' ' .. zPlayer.getLastName(), "Transferiste pelo telemóvel " .. amount .. " € para a conta de " .. zPlayer.getFirstName() .. ' ' .. zPlayer.getLastName())
    TriggerEvent("gbank:registerTransaction", zPlayer.identifier, "personal", amount, "transfer", xPlayer.getFirstName() .. ' ' .. xPlayer.getLastName(), "Recebeste " .. amount .. " € de " .. xPlayer.getFirstName() .. ' ' .. xPlayer.getLastName())

    TriggerClientEvent('cphone:client:TransferMoney', zPlayer.source, amount)

    return true
end)

RPC.register('getBills', function()
    local identifier = ESX.getIdentifier(source)
    local billing = ESX.getBills(identifier)

    local bills = {}

    for i=1, #billing, 1 do
        table.insert(bills, {
            id         = billing[i].id,
            identifier = billing[i].identifier,
            sender     = billing[i].sender,
            targetType = billing[i].target_type,
            target     = billing[i].target,
            label      = billing[i].label,
            amount     = billing[i].amount,
            time       = billing[i].time,
            type       = 'bill'
        })
    end

    return bills
end)



-------------------------------------------------------
--Messages--
-------------------------------------------------------



-------------------------------------------------------
--Gallery--
-------------------------------------------------------
local cachedGallery = {}

Citizen.CreateThread(function()
    if not DEVELOPER_MODE then
        Citizen.Wait(2000)
    end

    MySQL.Async.fetchAll('SELECT * FROM `phone_gallery`', {}, function(data)
        for i = #data, 1, -1 do
            local v = data[i]

            if cachedGallery[v.identifier] == nil then cachedGallery[v.identifier] = {} end

			table.insert(cachedGallery[v.identifier],{
                link = v.link,
                type = v.type
            })
        end

		print('[DATA] Cached all user gallery')
	end)

end)

RegisterNetEvent('cphone:addItemGallery', function(pLink, pType)
    local source = source
    local identifier = ESX.getIdentifier(source)

    if cachedGallery[identifier] == nil then cachedGallery[identifier] = {} end

    table.insert(cachedGallery[identifier], 1,{
        link = pLink,
        type = pType
    })

    MySQL.Async.insert("INSERT INTO phone_gallery (`identifier`, `link`, `type`) VALUES(@identifier, @link, @type)", {
        ['@identifier'] = identifier,
        ['@link'] = pLink,
        ['@type'] = pType
    })
end)

RegisterNetEvent('cphone:deleteGalleryElement', function(pLink)
    local source = source
    local identifier = ESX.getIdentifier(source)

    for k,v in ipairs(cachedGallery[identifier]) do
        if v.link == pLink then
            table.remove(cachedGallery[identifier], k)
        end
    end

    MySQL.Async.insert("DELETE FROM phone_gallery WHERE identifier = @identifier AND link = @link", {
        ['@identifier'] = identifier,
        ['@link'] = pLink,
    })
end)

local itemsPerPageInGallery = 40

RPC.register('cframework:cphone:getGallery', function(page)
    local source = source
    local identifier = ESX.getIdentifier(source)

    return cachedGallery[identifier] or {}
    --return {table.unpack(cachedGallery[identifier], page * itemsPerPageInGallery - itemsPerPageInGallery + 1, page * itemsPerPageInGallery)}
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('esx:playerLoaded',function(playerId, xPlayer)
    local sourcePlayer = playerId

    if not ESX.isPlayerOnline(sourcePlayer) then return end

    TriggerClientEvent('cphone:recentTweets', sourcePlayer, getTweets())

    GetPhoneData(sourcePlayer)
end)

if DEVELOPER_MODE then
    RegisterNetEvent('forceLoad',function()
        local sourcePlayer = source
        local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

        Citizen.Wait(2000)

        TriggerClientEvent('cphone:recentTweets', sourcePlayer, getTweets())

        GetPhoneData(sourcePlayer)
    end)
end
