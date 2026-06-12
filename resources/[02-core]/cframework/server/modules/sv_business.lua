local salaryTotal = {}

local function addBusinessMoney(identifier, money)
    if not identifier then return end

    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    local amount = tonumber(money)

    if xPlayer == nil then return end

    xPlayer.addAccountMoney("bank", amount)

    if salaryTotal[xPlayer.source] == nil then
        salaryTotal[xPlayer.source] = amount
    else
        salaryTotal[xPlayer.source] += amount
    end
end

local function runMoneyCoroutines(d,h,m)
    Citizen.CreateThread(function()
        print("[^1"..GetCurrentResourceName().."^7] Running money coroutines "..h..":"..m)

        MySQL.Async.fetchAll('DELETE FROM businesses WHERE expire < current_timestamp()')

        MySQL.Async.fetchAll('SELECT * FROM businesses',{},function(data)
            for _,business in ipairs(data) do
                addBusinessMoney(business["owner"], business["earnings"])
            end

            for player, amount in pairs(salaryTotal) do
                TriggerClientEvent('esx:showNotification', player, string.format(T("GENERIC_VIP_SALARY"), amount), 'inform')
            end

            salaryTotal = {}
        end)
    end)
end

Citizen.CreateThread(function()
    for i=0,23 do
        TriggerEvent("cron:runAt",i,0,runMoneyCoroutines)
    end
end)
