ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local default = {
    matchInProgress = false,
    currentPlayers = {},
    queue = {timer = false},
    matchEnds = false,
    prizePool = 0,
    score_red = 0,
    score_blue = 0
}

local defaultDefault = {
    matchInProgress = false,
    currentPlayers = {},
    queue = {timer = false},
    matchEnds = false,
    prizePool = 0,
    score_red = 0,
    score_blue = 0
}

isplayerActive = function(id)
    local playerTable = GetPlayers()
    for k, v in pairs(playerTable) do
        if tonumber(v) == id then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        for i = 1, #default.currentPlayers do
            if default.currentPlayers[i] then
                if not isplayerActive(default.currentPlayers[i].id) then
                    print(default.currentPlayers[i].id) 
                    table.remove(default.currentPlayers, i)
                end
            end
        end
        if default.matchInProgress then
            if #default.currentPlayers < Config.RequiredPlayers then
                for i = 1, #default.currentPlayers do
                    TriggerClientEvent('loaf_paintball:stop', default.currentPlayers[i].id)
                    default = json.decode(json.encode(defaultDefault))
                end
                default.currentPlayers = {}
            end
        end
        Wait(2500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if not default.matchInProgress then
            if #default.currentPlayers >= Config.RequiredPlayers then
                if not default.queue.timer then
                    local queuetime = 60 * Config.QueueTime
                    default.queue.timer = os.time() + queuetime
                end
                if default.queue.timer - os.time() <= 0 then
                    default.queue.timer = false
                    default.matchInProgress = true
                    local matchends = 60 * Config.MatchLength
                    default.matchEnds = os.time() + matchends

                    -- 1. GERAR O NÚMERO AQUI (FORA DO LOOP)
                    local mapaSorteado = math.random(1, 5)

                    for i = 1, #default.currentPlayers do
                        local xPlayer = ESX.GetPlayerFromId(default.currentPlayers[i].id)
                        if xPlayer then
                            xPlayer.removeMoney(Config.Price)
                            default.prizePool = default.prizePool + Config.Price
                        
                            -- GUARDAR A EQUIPA NO ESTADO DO JOGADOR (Para os Blips)
                            -- Isso permite que outros jogadores saibam a equipa deste jogador
                            local playerTeam = default.currentPlayers[i].team

-- Esta linha é CRUCIAL para os blips aparecerem
                            Player(default.currentPlayers[i].id).state:set('paintball_team', playerTeam, true)
                        
                            TriggerClientEvent('loaf_paintball:start', default.currentPlayers[i].id, mapaSorteado)
                        end
                    end
                end
            end
        end
        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        local text = ''
        local other = ''
        if not default.matchInProgress then
            if #default.currentPlayers >= 1 then
                text = #default.currentPlayers .. Config.Translations['in_queue']
                if default.queue.timer then
                    text = text .. Config.Translations['seconds_starts'] .. default.queue.timer - os.time()
                end
            end
            if #default.currentPlayers < Config.RequiredPlayers then
                default.queue.timer = false
            end
        else
            text = Config.Translations['match_progress']
            other = default.matchEnds - os.time()
            
            
            if default.matchEnds - os.time() <= 0 then

                local winnerTeam = 'tie'
                if (default.score_red or 0) > (default.score_blue or 0) then
                    winnerTeam = 'red'
                elseif (default.score_blue or 0) > (default.score_red or 0) then
                    winnerTeam = 'blue'
                end

                
                local killsTable = {}
                for i = 1, #default.currentPlayers do
                    killsTable[tostring(default.currentPlayers[i].id)] = default.currentPlayers[i].kills
                end
                local mvpId = tonumber(getMax(killsTable))
                
                if mvpId then
                    local xPlayer = ESX.GetPlayerFromId(mvpId)
                    if xPlayer then xPlayer.addMoney(default.prizePool) end
                end

                
                for i = 1, #default.currentPlayers do
                    local player = default.currentPlayers[i]
                    local status = 0
                
                    if winnerTeam == 'tie' then
                        status = -1
                    elseif player.team == winnerTeam then
                        status = 1
                    end
                
                    TriggerClientEvent('loaf_paintball:matchOver', 
                        player.id, 
                        json.encode(player), 
                        winnerTeam, 
                        (default.score_blue or 0), 
                        (default.score_red or 0), 
                        status
                    )
                end

                
                default = json.decode(json.encode(defaultDefault))
                Wait(Config.DisplayWinner * 1000)
                default.matchInProgress = false
            end
        end
        TriggerClientEvent('loaf_paintball:queueInfo', -1, text, other)
        Wait(500)
    end
end)

RegisterServerEvent('loaf_paintball:join')
AddEventHandler('loaf_paintball:join', function(playerTeam)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if xPlayer.getMoney() >= Config.Price then
        if not default.matchInProgress then
            local init = false
            for i = 1, #default.currentPlayers do
                if default.currentPlayers[i] and default.currentPlayers[i].id == src then
                    init = true
                    table.remove(default.currentPlayers, i)
                    xPlayer.addMoney(Config.Price)
                end
            end
            if not init then
                xPlayer.removeMoney(Config.Price)
                table.insert(default.currentPlayers, {id = src, kills = 0, deaths = 0, team = playerTeam})
            end
        end
    else
        TriggerClientEvent('loaf_paintball:hudNotify', src, Config.Translations['no_money'])
    end
end)

-- devolve a entrada do jogador em jogo (ou nil se não estiver na partida)
local function getMatchEntry(id)
    for i = 1, #default.currentPlayers do
        local p = default.currentPlayers[i]
        if p and p.id == id then return p end
    end
    return nil
end

local DEATH_COOLDOWN = Config.DeathCooldown or 2 -- segundos mín. entre mortes do mesmo jogador

RegisterServerEvent('loaf_paintball:kill')
AddEventHandler('loaf_paintball:kill', function(killerId)
    -- só a própria vítima (source) reporta a sua morte; o killer é validado contra o estado server-side
    local victim = source
    local killer = tonumber(killerId)

    if not default.matchInProgress then return end
    if not killer then return end
    if killer == victim then return end -- sem auto-kill (matava o farm de MVP/prizePool)

    -- ambos têm de estar realmente na partida
    local victimEntry = getMatchEntry(victim)
    local killerEntry = getMatchEntry(killer)
    if not victimEntry or not killerEntry then return end

    -- sem team-kill a contar pontos
    if killerEntry.team == victimEntry.team then return end

    -- cooldown de respawn: impede spam de mortes do mesmo cliente p/ farmar kills alheios
    local now = os.time()
    if (now - (victimEntry.lastDeath or 0)) < DEATH_COOLDOWN then return end
    victimEntry.lastDeath = now

    local victimName = GetPlayerName(victim) or "Alguém"
    local killerName = GetPlayerName(killer) or "Alguém"

    killerEntry.kills = killerEntry.kills + 1
    TriggerClientEvent('loaf_paintball:hudNotify', killerEntry.id, (Config.Translations['you_killed'] or "Mataste") .. ': ~r~' .. victimName)
    TriggerClientEvent("loaf_paintball:mataste", killerEntry.id, killerEntry.kills)
    TriggerClientEvent('esx_basicneeds:healPlayer', killerEntry.id)

    victimEntry.deaths = victimEntry.deaths + 1
    TriggerClientEvent('loaf_paintball:hudNotify', victimEntry.id, (Config.Translations['you_got_killed'] or "Foste morto por") .. ': ~r~' .. killerName)
    TriggerClientEvent('loaf_paintball:died', victimEntry.id, killer)

    if killerEntry.team == 'blue' then
        default.score_blue = (default.score_blue or 0) + 1
    elseif killerEntry.team == 'red' then
        default.score_red = (default.score_red or 0) + 1
    end

    TriggerClientEvent('loaf_paintball:scoregeral', -1, default.score_red, default.score_blue)
end)
getMax = function(data)
    local max_val, key = -math.huge
    for k, v in pairs(data) do
        if v > max_val then
            max_val, key = v, k
        end
    end
    return key
end