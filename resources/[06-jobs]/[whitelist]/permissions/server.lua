ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
------------TOKEN BOT------------
-- FIX (2026-06-12): token Discord deixou de estar hardcoded/ofuscado no código.
-- Lê do convar `discord_bot_token_perms` (definido em server_secrets.cfg,
-- git-ignored) — valor = token cru, SEM o prefixo "Bot " (o código já o junta).
local discordBotToken = GetConvar("discord_bot_token_perms", "")
---------------------------------

local guildID = "1271128201128841226"
function GetDiscordIdentifier(source)
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if string.find(id, "discord:") then
            return string.gsub(id, "discord:", "")
        end
    end
    return nil
end

--UEPS--
local ativaUEPS = {}
local RoleUEPS = "1271128201158070365"
RegisterCommand('ueps', function(source, args, rawCommand)
    local playerData = ESX.GetPlayerFromId(source)

    if playerData and playerData.job.name == 'sheriff' then
        local playerId = playerData.identifier
        local discordId = GetDiscordIdentifier(source)

        if discordId then
            PerformHttpRequest("https://discord.com/api/guilds/" .. guildID .. "/members/" .. discordId,
                function(err, response, headers)
                    if err == 200 then
                        local memberData = json.decode(response)
                        local hasRole = false

                        for _, roleId in ipairs(memberData.roles) do
                            if roleId == RoleUEPS then
                                hasRole = true
                                break
                            end
                        end

                        if hasRole then
                            ativaUEPS[playerId] = ativaUEPS[playerId] or 0

                            if ativaUEPS[playerId] == 0 then
                                TriggerClientEvent('core_evidence:permissao_ueps', source, true)
                                ativaUEPS[playerId] = 1
                            elseif ativaUEPS[playerId] == 1 then
                                TriggerClientEvent('core_evidence:permissao_ueps', source, false)
                                ativaUEPS[playerId] = 0
                            end
                        else
                            TriggerClientEvent('esx:showNotification', source, 'Não tens permissão para usar o comando!')
                        end
                    else
                        TriggerClientEvent('esx:showNotification', source,
                            'Erro ao verificar permissões no DISCORD! Contacta a DEV TEAM')
                    end
                end, 'GET', '', { ["Authorization"] = "Bot " .. discordBotToken })
        else
            TriggerClientEvent('esx:showNotification', source, 'Erro VCDISCORD | Contacta a DEV TEAM via TICKET')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Não pertences á GNR!')
    end
end, false)


local RoleIC = "1271128201158070367"
local ativaIC = {}
RegisterCommand('ic', function(source, args, rawCommand)
    local playerData = ESX.GetPlayerFromId(source)

    if playerData and (playerData.job.name == 'sheriff' or playerData.job.name == 'police') then
        local playerId = playerData.identifier
        local discordId = GetDiscordIdentifier(source)

        if discordId then
            PerformHttpRequest("https://discord.com/api/guilds/" .. guildID .. "/members/" .. discordId,
                function(err, response, headers)
                    if err == 200 then
                        local memberData = json.decode(response)
                        local hasRole = false

                        for _, roleId in ipairs(memberData.roles) do
                            if roleId == RoleIC then
                                hasRole = true
                                break
                            end
                        end

                        if hasRole then
                            ativaIC[playerId] = ativaIC[playerId] or 0

                            if ativaIC[playerId] == 0 then
                                TriggerClientEvent('core_evidence:permissao_cic', source, true)
                                ativaIC[playerId] = 1
                            elseif ativaIC[playerId] == 1 then
                                TriggerClientEvent('core_evidence:permissao_cic', source, false)
                                ativaIC[playerId] = 0
                            end
                        else
                            TriggerClientEvent('esx:showNotification', source, 'Não tens permissão para usar o comando!')
                        end
                    else
                        TriggerClientEvent('esx:showNotification', source,
                            'Erro ao verificar permissões no DISCORD! Contacta a DEV TEAM')
                    end
                end, 'GET', '', { ["Authorization"] = "Bot " .. discordBotToken })
        else
            TriggerClientEvent('esx:showNotification', source, 'Erro VCDISCORD | Contacta a DEV TEAM via TICKET')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Não pertences á Polícia!')
    end
end, false)



local ativaTRANSITO = {}
local RoleTransito = "1274728354309738629"
RegisterCommand('transito', function(source, args, rawCommand)
    local playerData = ESX.GetPlayerFromId(source)

    if playerData and (playerData.job.name == 'sheriff' or playerData.job.name == 'police') then
        local playerId = playerData.identifier

        local discordId = GetDiscordIdentifier(source)

        if discordId then
            PerformHttpRequest("https://discord.com/api/guilds/" .. guildID .. "/members/" .. discordId,
                function(err, response, headers)
                    if err == 200 then
                        local memberData = json.decode(response)
                        local hasRole = false

                        for _, roleId in ipairs(memberData.roles) do
                            if roleId == RoleTransito then
                                hasRole = true
                                break
                            end
                        end

                        if hasRole then
                            ativaTRANSITO[playerId] = ativaTRANSITO[playerId] or 0

                            if ativaTRANSITO[playerId] == 0 then
                                TriggerClientEvent('core_evidence:permissao_transito', source, true)
                                ativaTRANSITO[playerId] = 1
                            elseif ativaTRANSITO[playerId] == 1 then
                                TriggerClientEvent('core_evidence:permissao_transito', source, false)
                                ativaTRANSITO[playerId] = 0
                            end
                        else
                            TriggerClientEvent('esx:showNotification', source, 'Não tens permissão para usar o comando!')
                        end
                    else
                        TriggerClientEvent('esx:showNotification', source,
                            'Erro ao verificar permissões no DISCORD! Contacta a DEV TEAM')
                    end
                end, 'GET', '', { ["Authorization"] = "Bot " .. discordBotToken })
        else
            TriggerClientEvent('esx:showNotification', source, 'Erro VCDISCORD | Contacta a DEV TEAM via TICKET')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Não pertences á Polícia!')
    end
end, false)

local ativaK9 = {}
local RoleK9 = "1271128201158070368"
RegisterCommand('k9', function(source, args, rawCommand)
    local playerData = ESX.GetPlayerFromId(source)

    if playerData and (playerData.job.name == 'sheriff' or playerData.job.name == 'police') then
        local playerId = playerData.identifier

        local discordId = GetDiscordIdentifier(source)

        if discordId then
            PerformHttpRequest("https://discord.com/api/guilds/" .. guildID .. "/members/" .. discordId,
                function(err, response, headers)
                    if err == 200 then
                        local memberData = json.decode(response)
                        local hasRole = false

                        for _, roleId in ipairs(memberData.roles) do
                            if roleId == RoleK9 then
                                hasRole = true
                                break
                            end
                        end

                        if hasRole then
                            ativaK9[playerId] = ativaK9[playerId] or 0

                            if ativaK9[playerId] == 0 then
                                TriggerClientEvent('core_evidence:permissao_k9', source, true)
                                ativaK9[playerId] = 1
                            elseif ativaK9[playerId] == 1 then
                                TriggerClientEvent('core_evidence:permissao_k9', source, false)
                                ativaK9[playerId] = 0
                            end
                        else
                            TriggerClientEvent('esx:showNotification', source, 'Não tens permissão para usar o comando!')
                        end
                    else
                        TriggerClientEvent('esx:showNotification', source,
                            'Erro ao verificar permissões no DISCORD! Contacta a DEV TEAM')
                    end
                end, 'GET', '', { ["Authorization"] = "Bot " .. discordBotToken })
        else
            TriggerClientEvent('esx:showNotification', source, 'Erro VCDISCORD | Contacta a DEV TEAM via TICKET')
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'Não pertences á Polícia!')
    end
end, false)

          

--CRIAR CANAIS DISCORD ATRAVES DO BOT--
 --local categoryId = "1278827814543429652"                                           
-- function createDiscordChannel(channelName)
--     local url = "https://discord.com/api/v10/guilds/"..guildID.."/channels"        
--     local data = {
--         name = channelName,                                                        
--         type = 0,                                                                  
--         parent_id = categoryId
--     }

--     PerformHttpRequest(url, function(statusCode, response, headers)
--         if statusCode == 201 then
--             print("Canal criado com sucesso!")
--         else
--             print("Erro ao criar o canal. Status Code: " .. statusCode)
--         end
--     end, "POST", json.encode(data), { ["Content-Type"] = "application/json", ["Authorization"] = "Bot " .. discordBotToken })
-- end

-- RegisterCommand("criarCanal", function(source, args, rawCommand)
--     local channelName = args[1]    
--     if channelName then
--         createDiscordChannel(channelName)
--     else
--         print("Nome do canal não especificado.")
--     end
-- end, false)
