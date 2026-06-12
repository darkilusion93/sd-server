ESX = nil
local bancache,namecache = {},{}
local open_assists, active_assists, reportOrder = {}, {}, {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local cachedBans = {}
local loadingBans = true

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	
    MySQL.Async.fetchAll('SELECT * FROM bwh_bans', {}, function(result)
        for k, ban in ipairs(result) do
            local length = nil

            if ban.length ~= 0.0 then length = ban.length/1000 end

            if (length == nil or length > os.time()) and ban.unbanned == 0 then
                local identifierTable = {}

                for k,v in pairs(json.decode(ban.receiver)) do
                    local id = json.decode(v)

                    if id == nil then
                        identifierTable[v] = true
                    else
                        if type(id) == 'table' then
                            for k2,v2 in pairs(id) do
                                identifierTable[v2] = true
                            end
                        end
                    end
                end


                cachedBans[ban.id] = {
                    identifiers = identifierTable,
                    reason = ban.reason,
                    length = length,
                    id = ban.id
                }
            end
        end

		print('[DATA] Cached all bans')
        loadingBans = false
	end)
end)

function split(s, delimiter)result = {};for match in (s..delimiter):gmatch("(.-)"..delimiter) do table.insert(result, match) end return result end

ESX.RegisterServerCallback("el_bwh:ban", function(source,cb,target,reason,length,offline)
    if not target or not reason then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if not xPlayer or (not xTarget and not offline) then cb(nil); return end
    if isAdmin(xPlayer) then
        local success, reason = banPlayer(xPlayer,offline and target or xTarget,reason,length,offline)
        cb(success, reason)
    else logUnfairUse(xPlayer); cb(false) end
end)

ESX.RegisterServerCallback("el_bwh:warn",function(source,cb,target,message,anon)
    if not target or not message then return end
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    if not xPlayer or not xTarget then cb(nil); return end
    if isAdmin(xPlayer) then
        warnPlayer(xPlayer,xTarget,message,anon)
        cb(true)
    else logUnfairUse(xPlayer); cb(false) end
end)

ESX.RegisterServerCallback("el_bwh:getWarnList",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
        local warnlist = {}
        for k,v in ipairs(MySQL.Sync.fetchAll("SELECT * FROM bwh_warnings LIMIT @limit",{["@limit"]=Config.page_element_limit})) do
            v.receiver_name=namecache[v.receiver]
            v.sender_name=namecache[v.sender]
            table.insert(warnlist,v)
        end
        cb(json.encode(warnlist),MySQL.Sync.fetchScalar("SELECT CEIL(COUNT(id)/@limit) FROM bwh_warnings",{["@limit"]=Config.page_element_limit}))
    else logUnfairUse(xPlayer); cb(false) end
end)

ESX.RegisterServerCallback("el_bwh:getBanList",function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
        local data = MySQL.Sync.fetchAll("SELECT * FROM bwh_bans LIMIT @limit",{["@limit"]=Config.page_element_limit})
        local banlist = {}
        for k,v in ipairs(data) do
            v.receiver_name = namecache[json.decode(v.receiver)[1]]
            v.sender_name = namecache[v.sender]
            table.insert(banlist,v)
        end
        cb(json.encode(banlist),MySQL.Sync.fetchScalar("SELECT CEIL(COUNT(id)/@limit) FROM bwh_bans",{["@limit"]=Config.page_element_limit}))
    else logUnfairUse(xPlayer); cb(false) end
end)

ESX.RegisterServerCallback("el_bwh:getListData",function(source, cb, list, page, search)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
        if list=="banlist" then
            local banlist = {}
            local query = "SELECT * FROM bwh_bans"
            local params = {
                ["@limit"]=Config.page_element_limit,
                ["@offset"]=Config.page_element_limit*(page-1)
            }

            if search and search ~= "" then
                query = query .. " WHERE id = @search"
                params["@search"] = tonumber(search)
            end

            query = query .. " LIMIT @limit OFFSET @offset"

            local data = MySQL.Sync.fetchAll(query, params)

            if data == nil then cb(nil) return end

            for k,v in ipairs(data) do
                v.receiver_name = namecache[json.decode(v.receiver)[1]]
                v.sender_name = namecache[v.sender]
                table.insert(banlist,v)
            end

            cb(json.encode(banlist))
        else
            local warnlist = {}
            for k,v in ipairs(MySQL.Sync.fetchAll("SELECT * FROM bwh_warnings LIMIT @limit OFFSET @offset",{["@limit"]=Config.page_element_limit,["@offset"]=Config.page_element_limit*(page-1)})) do
                v.sender_name=namecache[v.sender]
                v.receiver_name=namecache[v.receiver]
                table.insert(warnlist,v)
            end
            cb(json.encode(warnlist))
        end
    else logUnfairUse(xPlayer); cb(nil) end
end)

ESX.RegisterServerCallback("el_bwh:unban",function(source,cb,id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
        if not cachedBans[id] then cb(false); return end

        local banData = cachedBans[id]

        if banData.reason and string.find(banData.reason, "Sem Destino Anti-Cheat", 1, true) and xPlayer.group ~= "superadmin" then
            TriggerClientEvent('esx:showNotification', xPlayer.source, "Não podes desbanir um jogador banido pelo sistema Anti-Cheat.")
            cb(false)
            return
        end

        MySQL.Async.execute("UPDATE bwh_bans SET unbanned=1 WHERE id=@id",{["@id"]=id},function(rc)
            local bannedidentifier = "N/A"

            local steamTarget = ""

            for k, _ in pairs(cachedBans[id].identifiers) do
                if type(k) == "string" and k:sub(1, 5) == "steam" then
                    steamTarget = k
                    break
                end
            end

            local expires = cachedBans[id].length == nil and -1 or cachedBans[id].length
            ESX.LogBanData(xPlayer.source, "RETIRAR", steamTarget, cachedBans[id].reason .. " [".. id .."]", expires)

            cachedBans[id] = nil

            logAdmin(("Admin ^1%s^7 unbanned ^1%s^7 (%s)"):format(xPlayer.getName(),(bannedidentifier~="N/A" and namecache[bannedidentifier]) and namecache[bannedidentifier] or "N/A",bannedidentifier))
            cb(rc>0)
        end)
    else logUnfairUse(xPlayer); cb(false) end
end)



RegisterServerEvent('el_bwh:backupcheck')
AddEventHandler('el_bwh:backupcheck', function()
    local identifiers = GetPlayerIdentifiers(source)
    local banned = isBanned(source)
    if banned then
        DropPlayer(source, "Ban bypass detected, don’t join back!")
    end
end)

local steamNotFound = [[
	<div style="background-color: rgba(9, 23, 43, 1.0); color: white; padding: 20px; border: solid 2px var(--color-modal-border); border-radius: var(--border-radius-normal); margin-top: -17%; margin-bottom: -6%; position: relative;">
		<h2 style="color: white;">Não conseguiste agitar os oceanos.</h2>
		<p style="font-size: 1.25rem; padding: 0px; max-width: 80%">
			A tua conta <strong>steam</strong> não foi encontrada.
		</p>
		<br>Para jogares inicia a steam e entra no nosso discord <span style="font-style: italic;">http://discord.gg/y22GtTT6FT</span>.
		<img src="https://cdn.discordapp.com/attachments/1434675901362208860/1509639610828067016/logo_7.png?ex=6a1be332&is=6a1a91b2&hm=0dde62d16954bedda14e58ae1075a7666d781e164df34e6628a54834e4d0f59c&" style="position: absolute; right: 15px; bottom: 15px; max-height: 50%">
	</div>
]]

AddEventHandler("playerConnecting",function(name, setKick, def)
    local src = source

    def.defer()

    local identifiers = GetPlayerIdentifiers(src)

    local tokens = {}
    for i = 0, GetNumPlayerTokens(src) - 1 do 
        table.insert(tokens, GetPlayerToken(src, i))
    end

    if #tokens == 0 then
        def.done('Ocorreu um problema a entrar no servidor. \nCódigo: NTKNS')
        return
    end

    if #tokens == 3 then
        -- check if each element starts with "4:"
        --if string.sub(tokens[1], 1, 2) == "4:" and string.sub(tokens[2], 1, 2) == "4:" and string.sub(tokens[3], 1, 2) == "4:" then
        --    def.done('Ocorreu um problema a entrar no servidor. \nCódigo: ELNSPF')
        --    return
        --end
    end

    if loadingBans then
        def.done('Servidor a iniciar aguarda um pouco. \nCódigo: BNLDING')
        return
    end

    if #identifiers>0 and identifiers[1]~=nil then
        local banned, data = isBanned(identifiers, src)
        namecache[identifiers[1]]=GetPlayerName(src)
        if banned then
            --print(("[^1"..GetCurrentResourceName().."^7] Banned player (%s) tried to join, their ban expires on %s (Ban ID: #%s)"):format(GetPlayerName(src),data.length and os.date("%Y-%m-%d %H:%M",data.length) or "PERMANENT",data.id))
            --print(data.length)
            --local kickmsg = Config.banformat:format(data.reason,data.length and os.date("%Y-%m-%d %H:%M",tonumber(data.length)) or "PERMANENT",data.sender_name,data.id)
            local length = nil
            
            if data.length ~= nil then
                length = os.date("%d/%m/%Y, %H:%M", data.length)
            end
            
            local kickmsg = Config.banformat:format(data.reason,length and length or "PERMANENT",data.sender_name,data.id)
            --if Config.backup_kick_method then DropPlayer(src,kickmsg) else 
            def.done(--[[html]][[
                <div style="background-color: rgba(9, 23, 43, 1.0); color: white; padding: 20px; border: solid 2px var(--color-modal-border); border-radius: var(--border-radius-normal); margin-top: -17%; margin-bottom: -6%; position: relative;">
                    <h2 style="color: white;">Agitaste demasiado os oceanos, estás banido deste servidor.</h2>
                    <p style="font-size: 1.25rem; padding: 0px; max-width: 80%">
                        <strong>Expira em: </strong>]]..(length and length or "PERMANENTE")..--[[html]][[ 
                        <strong>Razão: </strong>]]..data.reason..--[[html]][[ 
                        <strong>Ban ID: <code style="letter-spacing: 2px; background-color: #0d2442; padding: 2px 4px; border-radius: 6px;">]]..data.id..--[[html]][[</code></strong>
                    </p>
                    <br>Para contestar o ban abre ticket em <span style="font-style: italic;">http://discord.gg/y22GtTT6FT</span>.
                    <img src="https://cdn.discordapp.com/attachments/1434675901362208860/1509639610828067016/logo_7.png?ex=6a1be332&is=6a1a91b2&hm=0dde62d16954bedda14e58ae1075a7666d781e164df34e6628a54834e4d0f59c&" style="position: absolute; right: 15px; bottom: 15px; max-height: 50%">
                </div>
            ]])
           -- end
        else
            local playername = GetPlayerName(src)
            local saneplayername = playername

            local data = {["@name"]=saneplayername}
            for k,v in ipairs(identifiers) do
                data["@"..split(v,":")[1]]=v
            end

            data["@hardware"] = json.encode(tokens)

            if not data["@steam"] then
	            if Config.kick_without_steam then
		            --print("[^1"..GetCurrentResourceName().."^7] Player connecting without steamid, removing player from server.")
		            def.done(steamNotFound)
		        else
                   -- print("[^1"..GetCurrentResourceName().."^7] Player connecting without steamid, skipping identifier storage.")
		        end
            else
                MySQL.Sync.execute("INSERT INTO `bwh_identifiers` (`steam`, `license`, `ip`, `name`, `xbl`, `live`, `discord`, `fivem`, `hardware`) VALUES (@steam, @license, @ip, @name, @xbl, @live, @discord, @fivem, @hardware) ON DUPLICATE KEY UPDATE `license`=@license, `ip`=@ip, `name`=@name, `xbl`=@xbl, `live`=@live, `discord`=@discord, `fivem`=@fivem, `hardware`=@hardware, `lastplayed` = current_timestamp()",data)
                def.done()
            end
        end
    else
        if Config.backup_kick_method then DropPlayer(src,"[BWH] No identifiers were found when connecting, please reconnect") else def.done("[BWH] No identifiers were found when connecting, please reconnect") end
    end
end)

AddEventHandler("playerDropped",function(reason)
    local source = source

    if open_assists[source] then open_assists[source]=nil end

    for k,v in ipairs(reportOrder) do
        if v == source then
            table.remove(reportOrder, k)
        end
    end

    ESX.updatePendingReports(#reportOrder)

    for k,v in ipairs(active_assists) do
        if v==source then
            active_assists[k]=nil
            return
        elseif k==source then
            TriggerClientEvent("el_bwh:assistDone",v)
            active_assists[k]=nil
            return
        end
    end
end)

function refreshNameCache()
    namecache={}
    for k,v in ipairs(MySQL.Sync.fetchAll("SELECT steam,name FROM bwh_identifiers")) do
        namecache[v.steam]=v.name
    end
end

function refreshBanCache()
    bancache={}
    for k,v in ipairs(MySQL.Sync.fetchAll("SELECT id,receiver,sender,reason,UNIX_TIMESTAMP(length) AS length,unbanned FROM bwh_bans")) do
        table.insert(bancache,{id=v.id,sender=v.sender,sender_name=namecache[v.sender]~=nil and namecache[v.sender] or "N/A",receiver=json.decode(v.receiver),reason=v.reason,length=v.length,unbanned=v.unbanned==1})
    end
end

function logAdmin(msg)
    for k,v in ipairs(ESX.GetAdminPlayers()) do
        TriggerClientEvent("chat:addMessage",v,{color={255,0,0},multiline=false,args={"BWH",msg}})
    end
end

function isBanned(identifiers, src)
    local tokens = {}
    local identifiable = {}

    for i = 0, GetNumPlayerTokens(src) - 1 do
        local token = GetPlayerToken(src, i)

        table.insert(tokens, token)
    end

    for k,v in ipairs(identifiers)do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            table.insert(identifiable, v)
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            table.insert(identifiable, v)
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            table.insert(identifiable, v)
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            table.insert(identifiable, v)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            table.insert(identifiable, v)
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            --table.insert(identifiable, v)
        end
    end

    for banKey, banValue in pairs(cachedBans) do
        local banIdentifiers = banValue.identifiers

        for k,v in ipairs(identifiable) do
            if banIdentifiers[v] then
                if banValue.length==nil or banValue.length>os.time() then
                    return true, banValue
                end
            end
        end

        for k,v in ipairs(tokens) do
            if banIdentifiers[v] then
                if banValue.length==nil or banValue.length>os.time() then
                    return true, banValue
                end
            end
        end
    end

    return false, nil
end

function isAdmin(xPlayer)
    for k,v in ipairs(Config.admin_groups) do
        if xPlayer.getGroup()==v then return true end
    end
    return false
end

function execOnAdmins(func)
    local ac = 0
    for k,v in ipairs(ESX.GetAdminPlayers()) do
        ac = ac + 1
        func(v)
    end
    return ac
end

function logUnfairUse(xPlayer)
    if not xPlayer then return end
    --print(("[^1"..GetCurrentResourceName().."^7] Player %s (%s) tried to use an admin feature"):format(xPlayer.getName(),xPlayer.identifier))
    logAdmin(("Player %s (%s) tried to use an admin feature"):format(xPlayer.getName(),xPlayer.identifier))
end

function banPlayer(xPlayer,xTarget,reason,length,offline)
    local targetidentifiers,offlinename,timestring,data = {},nil,nil,nil
    local tokens = {}
    if offline then
        data = MySQL.Sync.fetchAll("SELECT * FROM bwh_identifiers WHERE steam=@identifier",{["@identifier"]=xTarget})
        if #data<1 then
            return false, "~r~Identifier is not in identifiers database!"
        end
        offlinename = data[1].name
        for k,v in pairs(data[1]) do
            if k~="name" then table.insert(targetidentifiers,v) end
        end
    else
        if not xTarget or not xTarget.getName then
            return false, "~r~Invalid target player!"
        end

        targetidentifiers = GetPlayerIdentifiers(xTarget.source)

        for i = 0, GetNumPlayerTokens(xTarget.source) - 1 do 
            table.insert(tokens, GetPlayerToken(xTarget.source, i))
        end
        table.insert(targetidentifiers, json.encode(tokens))

        if xTarget.group and xTarget.group == "superadmin" then
            return false, "~r~You can't ban a superadmin!"
        end
    end
    if length=="" then length = nil end
    MySQL.Async.execute("INSERT INTO bwh_bans(id,receiver,sender,length,reason) VALUES(NULL,@receiver,@sender,@length,@reason)",{["@receiver"]=json.encode(targetidentifiers),["@sender"]=xPlayer.identifier,["@length"]=length,["@reason"]=reason},function(_)
        local banid = MySQL.Sync.fetchScalar("SELECT MAX(id) FROM bwh_bans")
        logAdmin(("Player ^1%s^7 (%s) got banned by ^1%s^7, expiration: %s, reason: '%s'"..(offline and " (OFFLINE BAN)" or "")):format(offline and offlinename or xTarget.getName(),offline and data[1].steam or xTarget.identifier,xPlayer.getName(),length~=nil and length or "PERMANENT",reason))
        if length~=nil then
            timestring=length
            local year,month,day,hour,minute = string.match(length,"(%d+)/(%d+)/(%d+) (%d+):(%d+)")
            length = tonumber(os.time({year=year,month=month,day=day,hour=hour,min=minute}))
        end

        local identifierTable = {}

        for k,v in pairs(targetidentifiers) do
            local id = json.decode(v)

            if id == nil then
                identifierTable[v] = true
            else
                if type(id) == 'table' then
                    for k2,v2 in pairs(id) do
                        identifierTable[v2] = true
                    end
                end
            end
        end

        if offline then
            local expires = length == nil and -1 or length
            ESX.LogBanData(xPlayer.source, "APLICAR OFFLINE", xTarget, reason .. " [".. banid .."]", expires)
        else
            local expires = length == nil and -1 or length
            ESX.LogBanData(xPlayer.source, "APLICAR", xTarget.source, reason .. " [".. banid .."]", expires)
        end

        cachedBans[banid] = {
            identifiers = identifierTable,
            reason = reason,
            length = length,
            id = banid
        }

        if offline then xTarget = ESX.GetPlayerFromIdentifier(xTarget) end -- just in case the player is on the server, you never know
        if xTarget then
            TriggerClientEvent("el_bwh:gotBanned",xTarget.source, reason)
            Citizen.SetTimeout(5000, function()
                DropPlayer(xTarget.source,Config.banformat:format(reason,length~=nil and timestring or "PERMANENT",xPlayer.getName(),banid==nil and "1" or banid))
            end)
        else return false, "~r~Unknown error (MySQL?)" end
        return true, ""
    end)
end

function warnPlayer(xPlayer,xTarget,message,anon)
    MySQL.Async.execute("INSERT INTO bwh_warnings(id,receiver,sender,message) VALUES(NULL,@receiver,@sender,@message)",{["@receiver"]=xTarget.identifier,["@sender"]=xPlayer.identifier,["@message"]=message})
    TriggerClientEvent("el_bwh:receiveWarn",xTarget.source,anon and "" or xPlayer.getName(),message)
    logAdmin(("Admin ^1%s^7 warned ^1%s^7 (%s), Message: '%s'"):format(xPlayer.getName(),xTarget.getName(),xTarget.identifier,message))
end

AddEventHandler("el_bwh:ban",function(sender,target,reason,length,offline)
    if source=="" then -- if it's from server only
        banPlayer(sender,target,reason,length,offline)
    end
end)

AddEventHandler("el_bwh:warn",function(sender,target,message,anon)
    if source=="" then -- if it's from server only
        warnPlayer(sender,target,message,anon)
    end
end)

RegisterCommand("report", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local reason = table.concat(args," ")

    if xPlayer.canReport() == 0 then
        TriggerClientEvent("chat:addMessage",source,{
            template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(255, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Estás temporariamente proibido de fazer reports.</font></div>',
            args={source}}) 
        return 
    end
    if reason=="" or not reason then             TriggerClientEvent("chat:addMessage",source,{
        template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Escreve um breve texto a explicar o que aconteceu.</font></div>',
        args={source}}) ; return end
    if not open_assists[source] and not active_assists[source] then
        local ac = execOnAdmins(function(admin)
            if ESX.inAdmin(admin) then
                TriggerClientEvent("el_bwh:requestedAssist",admin,source, GetPlayerName(source))
                TriggerClientEvent("chat:addMessage",admin,{
                    template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORT <font color="white">| {2} [{0}] Razão: {1}</font></div>',
                    args={source, reason, GetPlayerName(source)}
                })
            end
        end)
        if ac>0 then
            open_assists[source]=reason

            table.insert(reportOrder, source)
            ESX.updatePendingReports(#reportOrder)

            TriggerClientEvent("chat:addMessage",source,{
                template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Report enviado, escreve /cancelar para cancelar o pedido.</font></div>',
                args={}
            })

            MySQL.Async.execute("UPDATE users SET reports = reports + 1 WHERE identifier = @steam",{["@steam"]=xPlayer.identifier})

            --TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=false,args={"REPORT","Report enviado (expira em 120s), escreve ^1/cassist^7 para cancelar o pedido"}})
        else
            TriggerClientEvent("chat:addMessage",source,{
                template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Não há admins no server.</font></div>',
                args={}
            })
            --TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","Não há admins no server"}})
        end
    else
        TriggerClientEvent("chat:addMessage",source,{
            template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Já fizeste um report.</font></div>',
            args={}
        })
        --TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","Someone is already helping your or you already have a pending assist request"}})
    end
end, false)

RegisterCommand("cancelar", function(source, args, rawCommand)
    if open_assists[source] then
        open_assists[source]=nil

        for k,v in ipairs(reportOrder) do
            if v == source then
                table.remove(reportOrder, k)
            end
        end

        ESX.updatePendingReports(#reportOrder)

        TriggerClientEvent("chat:addMessage",source,{
            template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Cancelaste o teu pedido.</font></div>',
            args={}
        })
    else
        TriggerClientEvent("chat:addMessage",source,{
            template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Não tens reports pendentes.</font></div>',
            args={}
        })
    end
end, false)

RegisterCommand("fechar", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
    if isAdmin(xPlayer) then
        local found = false
        for k,v in pairs(active_assists) do
            if v==source then
                found = true
                active_assists[k]=nil
                TriggerClientEvent("chat:addMessage",source,{
                    template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Report fechado.</font></div>',
                    args={}
                })
                --TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=false,args={"BWH","Assist closed, teleporting back"}})
                TriggerClientEvent("el_bwh:assistDone",source)
            end
        end
        if not found then TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You're not helping anyone"}}) end
    else
        TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You don't have permissions to use this command!"}})
    end
end, false)

RegisterCommand("bwh", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
        if args[1]=="ban" or args[1]=="warn" or args[1]=="warnlist" or args[1]=="banlist" then
            TriggerClientEvent("el_bwh:showWindow",source,args[1])
        elseif args[1]=="refresh" then
            TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=false,args={"BWH","Refreshing ban & name cache..."}})
            refreshNameCache()
            refreshBanCache()
        elseif args[1]=="assists" then
            local openassistsmsg,activeassistsmsg = "",""
            for k,v in pairs(open_assists) do
                openassistsmsg=openassistsmsg.."^5ID "..k.." ("..GetPlayerName(k)..")^7 - "..v.."\n"
            end
            for k,v in pairs(active_assists) do
                activeassistsmsg=activeassistsmsg.."^5ID "..k.." ("..GetPlayerName(k)..")^7 - "..v.." ("..GetPlayerName(v)..")\n"
            end
            TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=true,args={"BWH","Pending assists:\n"..(openassistsmsg~="" and openassistsmsg or "^1No pending assists")}})
            TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=true,args={"BWH","Active assists:\n"..(activeassistsmsg~="" and activeassistsmsg or "^1No active assists")}})
        else
            TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","Invalid sub-command! (^4ban^7,^4warn^7,^4banlist^7,^4warnlist^7,^4refresh^7)"}})
        end
    else
        TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You don't have permissions to use this command!"}})
    end
end, false)

RegisterCommand("reports", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if isAdmin(xPlayer) then
            local openassistsmsg,activeassistsmsg = "",""
            for k,v in pairs(open_assists) do
                --if k ~= nil and v ~= nil then
                    openassistsmsg=openassistsmsg.."^5ID "..k.." ("..GetPlayerName(k)..")^7 - "..v.."\n"
                --end
            end
            for k,v in pairs(active_assists) do
                if GetPlayerName(k) ~= nil and GetPlayerName(v) ~= nil then
                    activeassistsmsg=activeassistsmsg.."^5ID "..k.." ("..GetPlayerName(k)..")^7 - "..v.." ("..GetPlayerName(v)..")\n"
                end
            end
            TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=true,args={"BWH","Pending assists:\n"..(openassistsmsg~="" and openassistsmsg or "^1No pending assists")}})
            TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=true,args={"BWH","Active assists:\n"..(activeassistsmsg~="" and activeassistsmsg or "^1No active assists")}})
    else
        TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You don't have permissions to use this command!"}})
    end
end, false)

local function acceptAssist(xPlayer)
    local target = nil
    if isAdmin(xPlayer) then
        local source = xPlayer.source
        for k,v in pairs(active_assists) do
            if v==source then
                TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You're already helping someone"}})
                return
            end
        end

        target = reportOrder[1]
        table.remove(reportOrder, 1)
        ESX.updatePendingReports(#reportOrder)

        if open_assists[target] and not active_assists[target] then
            ESX.LogAdminItems(source, "ACEITAR", target, "report", open_assists[target], 1)

            TriggerClientEvent("chat:addMessage",source,{
                template = [[<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000" style="font-weight: bold;">REPORTS <font color="white" style="
                font-weight: normal;
            ">| A teleportar para o jogador ]].. target ..[[.</font></font><div style="
                margin-top: 0.4vh;
            "><font color="#ff0" style="font-weight: bolder;">RAZÃO <font color="white" style="
                font-weight: normal;
            ">-&gt; ]].. open_assists[target] ..[[</font></font></div></div>]],
                args={}
            })

            open_assists[target]=nil
            active_assists[target]=source

            local coords = GetEntityCoords(GetPlayerPed(target))
            local localPed = GetPlayerPed(source)

            SetEntityCoords(localPed, coords.x, coords.y, coords.z, true, false, false, true)

            TriggerClientEvent("el_bwh:acceptedAssist",source,target)
            TriggerClientEvent("el_bwh:hideAssistPopup",source)

            --TriggerClientEvent("chat:addMessage",source,{color={0,255,0},multiline=false,args={"BWH","Teleporting to player..."}})
        elseif not open_assists[target] and active_assists[target] and active_assists[target]~=source then
            TriggerClientEvent("chat:addMessage",source,{
                template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Alguém já aceitou este pedido.</font></div>',
                args={}
            })
            --TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","Someone is already helping this player"}})
        else
            TriggerClientEvent("chat:addMessage",source,{
                template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(0, 0, 0, 0.7); color: white; border-radius: 21px;"><font color="#ff0000">REPORTS <font color="white">| Este jogador não fez nenhum pedido.</font></div>',
                args={}
            })
            --TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","Player with that id did not request help"}})
        end
    else
        TriggerClientEvent("chat:addMessage",source,{color={255,0,0},multiline=false,args={"BWH","You don't have permissions to use this command!"}})
    end
end

RegisterCommand("aceitar", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
    acceptAssist(xPlayer)
end, false)

RegisterServerEvent("el_bwh:acceptAssistKey",function()
    local _source = source
    if not ESX.inAdmin(_source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
    acceptAssist(ESX.GetPlayerFromId(_source))
end)
