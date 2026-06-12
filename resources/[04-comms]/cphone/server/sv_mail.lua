-------------------------------------------------------
--Mail--
-------------------------------------------------------
local cachedMailUsernames = {} --index is username
local cachedMails = {}

Citizen.CreateThread(function()
    if not DEVELOPER_MODE then
        Citizen.Wait(2000)
    end

	MySQL.Async.fetchAll('SELECT * FROM `mail_accounts`', {}, function(data)
		for _,v in pairs(data) do
            cachedMailUsernames[v.username] = v
		end

		print('[DATA] Cached all mail accounts')
	end)

    MySQL.Async.fetchAll('SELECT * FROM `mail_mails`', {}, function(data)
		for _,v in pairs(data) do
			if cachedMails[v.receiver] == nil then cachedMails[v.receiver] = {} end

            table.insert(cachedMails[v.receiver], {
                email = v.sender,
                sender_name = v.sender_name,
                time = v.timestamp/1000,
                subject = v.subject,
                message = v.message,
                unread = v.unread,
                attachments = json.decode(v.attachments),
                id = v.id
            })
		end

		print('[DATA] Cached all mails')
    end)
end)

RPC.register('cframework:send_mail', function(sender, password, to, subject, message, attachments)
    local source = source
    local destAcc = cachedMailUsernames[to]

    if #subject < 1 or #message < 1 then return false end

    if destAcc == nil then return false end

    local account = cachedMailUsernames[sender]

    if account == nil or account.password ~= password then return false end

    if cachedMails[to] == nil then cachedMails[to] = {} end

    local id = MySQL.Sync.insert("INSERT INTO mail_mails (`receiver`, `sender`, `sender_name`, `subject`, `message`, `attachments`) VALUES(@receiver, @sender, @sender_name, @subject, @message, @attachments)", {
        ['@receiver'] = to,
        ['@sender'] = sender,
        ['@sender_name'] = account.name,
        ['@subject'] = subject,
        ['@message'] = message,
        ['@attachments'] = json.encode(attachments),
    })

    table.insert(cachedMails[to], {
        email = sender,
        sender_name = account.name,
        time = os.time(),
        subject = subject,
        message = message,
        unread = 1,
        attachments = attachments,
        id = id
    })

    for player, v in pairs(destAcc.sources) do
        if player ~= source then
            TriggerClientEvent('cframework:mail_newmail', player, sender, account.name)
        end
    end

    return true
end)

RegisterNetEvent('cframework:mail_read', function(username, password, id)
    local account = cachedMailUsernames[username]

    if account == nil or account.password ~= password then return end

    for k, v in pairs(cachedMails[username]) do
        if v.id == id then
            cachedMails[username][k].unread = 0
        end
    end

    MySQL.Async.fetchAll('UPDATE mail_mails SET unread = 0 WHERE id = ?', {id})
end)

RegisterNetEvent('cframework:mail_logout', function(username, password)
    local source = source
    local account = cachedMailUsernames[username]

    if account == nil or account.password ~= password then return end

    cachedMailUsernames[username].sources[source] = nil
end)

RPC.register('cframework:mail_login', function(username, password)
    local source = source
    local account = cachedMailUsernames[username]

    if account ~= nil and account.password == password then
        local mails = cachedMails[username]

        if cachedMailUsernames[username].sources == nil then
            cachedMailUsernames[username].sources = {}
        end

        cachedMailUsernames[username].sources[source] = true

        return true, account.name, mails and mails or {}
    end

    return false, '', {}
end)

RPC.register('cframework:mail_getmails', function(username, password)
    local account = cachedMailUsernames[username]

    if account ~= nil and account.password == password then
        local mails = cachedMails[username]

        return mails and mails or {}
    end

    return {}
end)

RPC.register('cframework:mail_register', function(username, password, name)
    local account = cachedMailUsernames[username]

    if account ~= nil then return false end

    if type(username) ~= 'string' or type(password) ~= 'string' or type(name) ~= 'string' then
        return false
    end

    if #username < 4 or #name < 4 or #password < 6 then
        return false
    end

    local insertId = MySQL.Sync.insert("INSERT INTO mail_accounts (`username`, `name`,`password`) VALUES(@username, @name, @password)", {
        ['@username'] = username,
        ['@name'] = name,
        ['@password'] = password,
    })

    if insertId == 0 then return false end

    local account = {
        id = insertId,
        username = username,
        name = name,
        password = password
    }

    cachedMailUsernames[account.username] = account

    return true
end)
