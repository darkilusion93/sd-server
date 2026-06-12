-- Função auxiliar para formatar os dados de cada período
local function getPeriodData(period, identifier)
    local timeFilter = ""
    if period == "daily" then
        timeFilter = "AND timestamp >= CURDATE()"
    elseif period == "weekly" then
        timeFilter = "AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)"
    elseif period == "monthly" then
        timeFilter = "AND timestamp >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)"
    end

    local activities = {"fishing", "hunting"}
    local data = {
        fishing = {},
        hunting = {},
        personal = {},
        personal_items = {}
    }

    for _, activity in ipairs(activities) do
        -- 1. Buscar TOP 10 (Chaves: player_name, amount)
        local top = MySQL.query.await([[
            SELECT char_name AS player_name, SUM(amount) AS amount 
            FROM activity_leaderboards 
            WHERE activity_type = ? ]] .. timeFilter .. [[ 
            GROUP BY identifier 
            ORDER BY amount DESC LIMIT 10
        ]], {activity})
        data[activity] = top or {}

        -- 2. Buscar Stats Pessoais (Total e Rank)
        local pAmount = MySQL.scalar.await([[
            SELECT COALESCE(SUM(amount), 0) FROM activity_leaderboards 
            WHERE activity_type = ? AND identifier = ? ]] .. timeFilter, 
        {activity, identifier})
        pAmount = tonumber(pAmount) or 0

        local pRank = 0
        if pAmount > 0 then
            pRank = MySQL.scalar.await([[
                SELECT COUNT(*) + 1 FROM (
                    SELECT SUM(amount) as total FROM activity_leaderboards 
                    WHERE activity_type = ? ]] .. timeFilter .. [[ GROUP BY identifier
                ) as t WHERE total > ?
            ]], {activity, pAmount})
        end

        data.personal[activity] = {
            amount = pAmount,
            rank = tonumber(pRank) or 0
        }

        -- 3. Buscar Detalhes Pessoais (Chaves: item_name, amount)
        -- Aqui simulamos a lista de "Meus Detalhes"
        local items = {}
        if pAmount > 0 then
            table.insert(items, {
                item_name = (activity == "fishing" and "Peixes Totais" or "Animais Totais"),
                amount = pAmount
            })
        end
        data.personal_items[activity] = items
    end

    return data
end

RegisterNetEvent("chud:requestActivityLeaderboard", function(focus)
    local src = source
    local identifier = ESX.getIdentifier(src)

    -- O teu JS espera um objeto que contenha as chaves "daily", "weekly" e "monthly"
    -- porque a função getSelectedActivityLeaderboardData() faz:
    -- currentActivityLeaderboard[currentActivityLeaderboardPeriod]
    local payload = {
        daily = getPeriodData("daily", identifier),
        weekly = getPeriodData("weekly", identifier),
        monthly = getPeriodData("monthly", identifier)
    }

    TriggerClientEvent("chud:updateActivityLeaderboard", src, payload)
end)