local avatar = "" -- bot's avatar
local https = ""

local function discordMessage(message)
    local temp = os.date("*t")

    local connect = {
        {
            ["color"] = 15158332,
            ["title"] = "**Top 3 players semanais** (".. temp.day .."/".. temp.month .."/".. temp.year ..")",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Sem Destino",
            },
        }
    }

    PerformHttpRequest(https, function(err, text, headers) end, 'POST', json.encode({username = "Assistente do Cerealitos", embeds = connect, avatar_url = avatar}), { ['Content-Type'] = 'application/json' })
end

local function secondsToClock(rSeconds)
    local seconds = tonumber(rSeconds)

    if seconds <= 0 then
        return "00:00:00";
    end

    local hours = string.format("%02.f", math.floor(seconds/3600));
    local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));

    return hours.."h"..mins.."m"..secs.."s"
end

local function deliverCoins(steam, coins)
    local aPlayer = ESX.GetPlayerFromIdentifier(steam)

    if aPlayer ~= nil then
        aPlayer.addCoins(coins)
        return true
    end

    if cachedUsers[steam] ~= nil then
        cachedUsers[steam].coins = cachedUsers[steam].coins + coins
    end

    MySQL.Async.execute("UPDATE users SET coins = coins + " .. coins .. " WHERE identifier = @identifier", {
        identifier = steam
    })
end

local function weekleaderboard(d, h, m)
    if d ~= 7 or ESX.DEV then
        return false
    end

    local result = MySQL.Sync.fetchAll("SELECT * FROM users ORDER BY playtime DESC LIMIT 3")

    if result == nil then return false end

    discordMessage("```Top 1 -> ".. result[1].name .." ["..secondsToClock(result[1].playtime)..
                    "]\nTop 2 -> ".. result[2].name .." ["..secondsToClock(result[2].playtime)..
                    "]\nTop 3 -> ".. result[3].name .." ["..secondsToClock(result[3].playtime)..
    "]```\n\nParabéns aos vencedores, receberam as Coins automaticamente.")

    deliverCoins(result[1].identifier, 15)
    deliverCoins(result[2].identifier, 10)
    deliverCoins(result[3].identifier, 5)

    MySQL.Sync.fetchAll("UPDATE users SET playtime = 0")
end

TriggerEvent('cron:runAt', 22, 0, weekleaderboard)