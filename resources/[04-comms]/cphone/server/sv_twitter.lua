-------------------------------------------------------
--Twitter--
-------------------------------------------------------
local cachedTwitterAccounts = {} --index is account id
local cachedTwitterUsernames = {} --index is username
local cachedTweets = {}

local function isValidUsername(username)
    return username:match("^[A-Za-z][A-Za-z0-9_]*$") and #username >= 3 and #username <= 16
end

Citizen.CreateThread(function()
	if not DEVELOPER_MODE then
        Citizen.Wait(2000)
    end

	MySQL.Async.fetchAll('SELECT * FROM `twitter_accounts`', {}, function(data)
		for _,v in pairs(data) do

            cachedTwitterAccounts[v.id] = v
            cachedTwitterUsernames[v.username] = v
		end

		print('[DATA] Cached all twitter accounts')
	end)
end)

RegisterNetEvent('cframework:twitter_logout', function(username, password)
    local account = cachedTwitterUsernames[username]

    if account ~= nil and account.password == password then
        cachedTwitterUsernames[username].source = nil
    end
end)

RPC.register('cframework:twitter_login', function(username, password)
    local source = source
    local account = cachedTwitterUsernames[username]

    if account ~= nil and account.password == password then
        cachedTwitterUsernames[username].source = source

        return true, account.avatar_url, account.name
    end

    return false, nil, ''
end)

RPC.register('cframework:twitter_register', function(username, password, name)
    local accounts = MySQL.Sync.fetchAll("SELECT * FROM twitter_accounts WHERE `username` = @username", {
        ['@username'] = username,
    })

    if accounts ~= nil and accounts[1] ~= nil then
        return false, "Nome de utilizador já existente"
    end

    if not isValidUsername(username) then
        return false, "Nome de utilizador inválido"
    end

    if type(username) ~= 'string' or type(password) ~= 'string' or type(name) ~= 'string' then
        return false, "Nome de utilizador, nome ou palavra-passe inválidos"
    end

    if #username < 4 then
        return false, "Nome de utilizador inválido, mínimo 4 caracteres"
    end

    if #name < 4 then
        return false, "Nome inválido, mínimo 4 caracteres"
    end

    if #password < 6 then
        return false, "Password inválida, mínimo 6 caracteres"
    end

    local insertId = MySQL.Sync.insert("INSERT INTO twitter_accounts (`username`, `name`,`password`) VALUES(@username, @name, @password)", {
        ['@username'] = username,
        ['@name'] = name,
        ['@password'] = password,
    })

    if insertId == 0 then
        return false, "Erro ao criar conta"
    end

    local account = {
        id = insertId,
        username = username,
        name = name,
        password = password,
        bio = nil,
        date_joined = os.time()*1000,
        follower_count = 0,
        following_count = 0,
        avatar_url = nil
    }

    cachedTwitterAccounts[account.id] = account
    cachedTwitterUsernames[account.username] = account

    return true
end)

RPC.register('cframework:twitter_updateaccount', function(username, password, newpassword, newname, newavatar, newbio)
    local account = cachedTwitterUsernames[username]

    if account == nil then return false end
    if account.password ~= password then return false end

    if type(newpassword) ~= 'string' or type(newname) ~= 'string' or type(newavatar) ~= 'string' then
        return false
    end

    if newpassword ~= '' and #newpassword < 6 then
        return false
    end

    if newname ~= '' and #newname < 4 then
        return false
    end

    if newname ~= '' then
        MySQL.Async.execute("UPDATE twitter_accounts SET name = @name WHERE username = @username", {
            ['@username'] = username,
            ['@name'] = newname
        })

        cachedTwitterAccounts[account.id].name = newname
        cachedTwitterUsernames[account.username].name = newname
    end

    if newpassword ~= '' then
        MySQL.Async.execute("UPDATE twitter_accounts SET password = @password WHERE username = @username", {
            ['@username'] = username,
            ['@password'] = newpassword
        })

        cachedTwitterAccounts[account.id].password = newpassword
        cachedTwitterUsernames[account.username].password = newpassword
    end

    if newbio ~= '' then
        MySQL.Async.execute("UPDATE twitter_accounts SET bio = @bio WHERE username = @username", {
            ['@username'] = username,
            ['@bio'] = newbio
        })

        cachedTwitterAccounts[account.id].bio = newbio
        cachedTwitterUsernames[account.username].bio = newbio
    end

    if newavatar ~= '' then
        local prefix = "https://cdn.Sem Destinorp.net/files/"
        if string.sub(newavatar, 1, #prefix) ~= prefix then
            newavatar = ""
        end

        MySQL.Async.execute("UPDATE twitter_accounts SET avatar_url = @avatar_url WHERE username = @username", {
            ['@username'] = username,
            ['@avatar_url'] = newavatar
        })

        cachedTwitterAccounts[account.id].avatar_url = newavatar
        cachedTwitterUsernames[account.username].avatar_url = newavatar
    end

    return true
end)

RPC.register('cframework:twitter_getprofile', function(myUsername, username)
    local account = cachedTwitterUsernames[username]

    if account == nil then return {} end

    local isFollowing = MySQL.Sync.fetchAll("SELECT * FROM twitter_follows WHERE followed = @followed AND follower = @follower", {
        ['@followed'] = username,
        ['@follower'] = myUsername,
    })[1]

    local profile = {
        username = account.username,
        name = account.name,
        bio = account.bio,
        date_joined = account.date_joined,
        follower_count = account.follower_count,
        following_count = account.following_count,
        avatar_url = account.avatar_url,
        is_following = isFollowing ~= nil,
        tweets = getTweetsFromAccount(username),
    }

    return profile
end)

RPC.register('cframework:twitter_searchuser', function(username)
    local users = MySQL.Sync.fetchAll("SELECT username, name, avatar_url FROM twitter_accounts WHERE MATCH(username) AGAINST(@username IN BOOLEAN MODE) LIMIT 50", {
        ['@username'] = username .. "*",
    })

    return users
end)

RPC.register('cframework:twitter_getfollowfeed', function(username, password)
    local account = cachedTwitterUsernames[username]
    if account == nil or account.password ~= password then
        return {}
    end

    -- Fetch list of followed usernames
    local follows = MySQL.Sync.fetchAll("SELECT followed FROM twitter_follows WHERE follower = @follower", {
        ['@follower'] = username,
    })

    if not follows or #follows == 0 then return {} end

    -- Build a list of account IDs for followed users
    local followedUsernames = {}
    for _, row in ipairs(follows) do
        if cachedTwitterUsernames[row.followed] then
            table.insert(followedUsernames, cachedTwitterUsernames[row.followed].id)
        end
    end

    if #followedUsernames == 0 then return {} end

    -- Prepare placeholders for IN clause
    local placeholders = {}
    local params = {}
    for i, id in ipairs(followedUsernames) do
        local key = '@id' .. i
        placeholders[#placeholders + 1] = key
        params[key] = id
    end

    -- Single query to fetch up to 120 tweets across followed users
    local query = string.format([[
        SELECT * FROM twitter_tweets
        WHERE authorId IN (%s)
        ORDER BY time DESC
        LIMIT 120
    ]], table.concat(placeholders, ","))

    local data = MySQL.Sync.fetchAll(query, params)
    if data == nil then return {} end

    -- Build final tweet objects
    local tweets = {}
    for _, v in ipairs(data) do
        local author = cachedTwitterAccounts[v.authorId]
        if author then
            table.insert(tweets, {
                username = author.username,
                name = author.name,
                avatar_url = author.avatar_url,
                message = {text = v.message, image = v.picture or ''},
                time = v.time,
            })
        end
    end

    return tweets
end)

RegisterNetEvent('cframework:twitter_follow', function(username, password, target)
    local source = source
    local account = cachedTwitterUsernames[username]

    if account == nil or account.password ~= password then
        return
    end

    local targetAccount = cachedTwitterUsernames[target]

    if targetAccount == nil then
        return
    end

    MySQL.Async.insert("INSERT INTO twitter_follows (`follower`, `followed`, `notifications`) VALUES(@follower, @followed, @notifications)", {
        ['@follower'] = username,
        ['@followed'] = target,
        ['@notifications'] = 1,
    })

    MySQL.Async.execute("UPDATE twitter_accounts SET following_count = following_count + 1 WHERE username = @username", {
        ['@username'] = username,
    })

    MySQL.Async.execute("UPDATE twitter_accounts SET follower_count = follower_count + 1 WHERE username = @username", {
        ['@username'] = target,
    })

    cachedTwitterUsernames[target].follower_count = cachedTwitterUsernames[target].follower_count + 1
    cachedTwitterUsernames[username].following_count = cachedTwitterUsernames[username].following_count + 1

    if cachedTwitterUsernames[target].source ~= nil then
        TriggerClientEvent('cframework:twitter_newfollower', cachedTwitterUsernames[target].source, cachedTwitterUsernames[username].name)
    end
end)

RegisterNetEvent('cframework:twitter_unfollow', function(username, password, target)
    local source = source
    local account = cachedTwitterUsernames[username]

    if account == nil or account.password ~= password then
        return
    end

    local targetAccount = cachedTwitterUsernames[target]

    if targetAccount == nil then
        return
    end

    MySQL.Async.execute("DELETE FROM twitter_follows WHERE `follower` = @follower AND `followed` = @followed", {
        ['@follower'] = username,
        ['@followed'] = target,
    })

    MySQL.Async.execute("UPDATE twitter_accounts SET following_count = following_count - 1 WHERE username = @username", {
        ['@username'] = username,
    })

    MySQL.Async.execute("UPDATE twitter_accounts SET follower_count = follower_count - 1 WHERE username = @username", {
        ['@username'] = target,
    })

    cachedTwitterUsernames[target].follower_count = cachedTwitterUsernames[target].follower_count - 1
    cachedTwitterUsernames[username].following_count = cachedTwitterUsernames[username].following_count - 1
end)

RegisterNetEvent('cframework:twitter_post', function(message, picture, username, password)
    local source = source
    local account = cachedTwitterUsernames[username]

    if account == nil or account.password ~= password then
        return
    end

    local tweet = {
        username = account.username,
        name = account.name,
        avatar_url = account.avatar_url,
        message = {text = message, image = picture},
        time = os.time()*1000,
    }

    MySQL.Async.insert("INSERT INTO twitter_tweets (`authorId`, `realUser`, `message`, `picture`) VALUES(@authorId, @realUser, @message, @picture)", {
        ['@authorId'] = account.id,
        ['@realUser'] = ESX.getIdentifier(source),
        ['@message'] = message,
        ['@picture'] = picture,
    })

    TriggerClientEvent('cframework:twitter_newpost', -1, tweet)
end)

RegisterNetEvent('cframework:twitter_send_message', function(username, password, target, message, attachments)
    local source = source
    local account = cachedTwitterUsernames[username]

    if account == nil or account.password ~= password then
        return
    end

    local targetAccount = cachedTwitterUsernames[target]

    if targetAccount == nil then
        return
    end

    MySQL.Async.insert("INSERT INTO twitter_messages (`sender`, `recipient`, `content`, `attachments`) VALUES(@sender, @recipient, @content, @attachments)", {
        ['@sender'] = account.username,
        ['@recipient'] = targetAccount.username,
        ['@content'] = message,
        ['@attachments'] = json.encode(attachments),
    })

    local messageData = {
        sender = account.username,
        recipient = targetAccount.username,
        senderLabel = cachedTwitterUsernames[account.username]?.name or account.username,
        recipientLabel = cachedTwitterUsernames[targetAccount.username]?.name or targetAccount.username,
        senderAvatar = cachedTwitterUsernames[account.username]?.avatar_url or nil,
        recipientAvatar = cachedTwitterUsernames[targetAccount.username]?.avatar_url or nil,
        content = message,
        attachments = attachments,
        timestamp = os.time()*1000,
    }

    TriggerClientEvent('cframework:twitter_newmessage', source, messageData, false)

    if targetAccount.source ~= nil then
        TriggerClientEvent('cframework:twitter_newmessage', targetAccount.source, messageData, true)
    end
end)

RPC.register('cframework:twitter_getmessages', function(username, password)
    local account = cachedTwitterUsernames[username]

    if account == nil or account.password ~= password then
        return {}
    end

    local messages = MySQL.Sync.fetchAll("SELECT * FROM twitter_messages WHERE `recipient` = @recipient OR `sender` = @sender ORDER BY `timestamp` DESC ", {
        ['@recipient'] = username,
        ['@sender'] = username,
    })

    if messages == nil then return {} end

    local result = {}

    for k,v in ipairs(messages) do
        local message = {
            sender = v.sender,
            recipient = v.recipient,
            senderLabel = cachedTwitterUsernames[v.sender]?.name or v.sender,
            recipientLabel = cachedTwitterUsernames[v.recipient]?.name or v.recipient,
            senderAvatar = cachedTwitterUsernames[v.sender]?.avatar_url or nil,
            recipientAvatar = cachedTwitterUsernames[v.recipient]?.avatar_url or nil,
            content = v.content,
            attachments = json.decode(v.attachments),
            timestamp = v.timestamp,
        }

        table.insert(result, message)
    end

    return result
end)


function getTweets()
    local tweets = {}

    local data = MySQL.Sync.fetchAll('SELECT * FROM `twitter_tweets` ORDER BY `time` DESC LIMIT 120', {})

    if data == nil then return tweets end

    for k,v in ipairs(data) do
        local author = cachedTwitterAccounts[v.authorId]

        local tweet = {
            username = author.username,
            name = author.name,
            avatar_url = author.avatar_url,
            message = {text = v.message, image = v.picture ~= nil and v.picture or ''},
            time = v.time,
        }

        table.insert(tweets, tweet)
    end

    return tweets
end


function getTweetsFromAccount(username)
    local tweets = {}
    local account = cachedTwitterUsernames[username]

    if account == nil then return tweets end

    local data = MySQL.Sync.fetchAll('SELECT * FROM `twitter_tweets` WHERE authorId = @accountId ORDER BY `time` DESC LIMIT 120', {
        ['@accountId'] = account.id,
    })

    if data == nil then return tweets end

    for k,v in ipairs(data) do
        local author = cachedTwitterAccounts[v.authorId]

        local tweet = {
            username = author.username,
            name = author.name,
            avatar_url = author.avatar_url,
            message = {text = v.message, image = v.picture ~= nil and v.picture or ''},
            time = v.time,
        }

        table.insert(tweets, tweet)
    end

    return tweets
end