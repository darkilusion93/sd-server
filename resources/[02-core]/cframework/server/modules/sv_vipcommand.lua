-- Title  : sv_vipcommand.lua
-- Author : Gonçalo Costa
-- Started: 18/01/24

local packagesDelivered = {}
local packages <const> = {
  --  ['10'] = {coins = 12}, 
  --  ['20'] = {coins = 24},
  --  ['30'] = {coins = 36}, 
    ['40'] = {coins = 13,     name = "Pack VIP 10"},                      -- Pack vip 10
    ['50'] = {coins = 26,     name = "Pack VIP 20"},       -- Pack vip 20 
    ['60'] = {coins = 52,     name = "Pack VIP 40"},       -- Pack vip 40 
    ['70'] = {coins = 65,     name = "Pack VIP 50"},       -- Pack vip 50
    ['80'] = {coins = 130,    name = "Pack VIP 100"},       -- Pack vip 100
    ['90'] = {coins = 195,    name = "Pack VIP 150"},      -- Pack vip 150 2500 salario
    ['100'] = {coins = 260,   name = "Pack VIP 200"},      -- Pack vip 200 3000 salario
   -- ['110'] = {coins = 132},
   -- ['120'] = {coins = 144},
   -- ['130'] = {coins = 156}, 
   -- ['140'] = {coins = 168},
   -- ['150'] = {coins = 180, business = {earnings = 1500}}, 
   -- ['160'] = {coins = 192, business = {earnings = 2000}},
   -- ['170'] = {coins = 204, business = {earnings = 2500}},
   -- ['180'] = {coins = 216, business = {earnings = 3000}},
   -- ['190'] = {coins = 228, business = {earnings = 3500}},
   -- ['200'] = {coins = 240, business = {earnings = 4000}},
    ['s5'] =   {business = {earnings =   4000, expire = true}, name = "Salário VIP 5"},
    ['s10'] =  {business = {earnings =   8000, expire = true}, name = "Salário VIP 10"},
    ['s15'] =  {business = {earnings =  12000, expire = true}, name = "Salário VIP 15"},
    ['s20'] =  {business = {earnings =  16000, expire = true}, name = "Salário VIP 20"},
    ['s25'] =  {business = {earnings =  20000, expire = true}, name = "Salário VIP 25"},
    ['s50'] =  {business = {earnings =  40000, expire = true}, name = "Salário VIP 50"},
    ['s75'] =  {business = {earnings =  60000, expire = true}, name = "Salário VIP 75"},
    ['s100'] = {business = {earnings =  80000, expire = true}, name = "Salário VIP 100"},
    ['s150'] = {business = {earnings = 120000, expire = true}, name = "Salário VIP 150"},
    ['s200'] = {business = {earnings = 160000, expire = true}, name = "Salário VIP 200"}
}

local function updateUserVIPStatus(identifier)
    MySQL.Async.execute("UPDATE users SET vip = 1 WHERE identifier = @identifier", {["@identifier"] = identifier})
end

local function addTickets(identifier, tickets)
    MySQL.Async.execute("INSERT INTO `giveaway` (`identifier`,`tickets`) VALUES (@steam, @count) ON DUPLICATE KEY UPDATE tickets = tickets + @count",{["@steam"]=identifier, ["@count"]=tickets})
end

local function addBusiness(identifier, playerName, earnings, expire)
    local query = 'INSERT INTO `businesses` (`name`, `address`, `description`, `owner`, `price`, `earnings`, `stock`, `stock_price`' .. (expire and ', `expire`' or '') .. ') VALUES ("Loja Vip", @address, @description, @owner, 1000000, @earnings, 100000, 100' .. (expire and ', TIMESTAMPADD(MONTH,1,CURRENT_TIMESTAMP())' or '') .. ')'
    MySQL.Async.execute(query, {
        address = playerName,
        description = 'Loja ' .. playerName,
        owner = identifier,
        earnings = earnings,
    })
end

local function checkIfCanDeliver(transactionId, package, purchaseAmount)
    if packagesDelivered[transactionId .. package] == nil then
        packagesDelivered[transactionId .. package] = 0
    end

    if packagesDelivered[transactionId .. package] >= tonumber(purchaseAmount) then
        return false
    end

    packagesDelivered[transactionId .. package] = packagesDelivered[transactionId .. package] + 1

    return true
end

local function tebexDeliverProduct(_, args)
    local source <const>, package <const>, transactionId <const>, purchaseAmount <const> = args[1], args[2], args[3], args[4]
    local identifier <const>, playerName <const> = GetPlayerIdentifierByType(source, "steam"), GetPlayerName(source) or "Unkown"

    local packageDetails <const> = packages[package]
    if packageDetails == nil then
        return
    end

    if not checkIfCanDeliver(transactionId, package, purchaseAmount) then
        return
    end

    updateUserVIPStatus(identifier)

    if packageDetails.coins then
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer == nil then
            MySQL.Async.execute("UPDATE users SET coins = coins + @coins WHERE identifier = @identifier", {["@coins"] = packageDetails.coins, ["@identifier"] = identifier})

            if cachedUsers[identifier] ~= nil then
                cachedUsers[identifier].coins = (cachedUsers[identifier].coins or 0) + packageDetails.coins
            end
        else
            xPlayer.addCoins(packageDetails.coins)
        end
    end

    if packageDetails.business then
        addBusiness(identifier, playerName, packageDetails.business.earnings, packageDetails.business.expire)
    end

    if packageDetails.tickets then
        addTickets(identifier, packageDetails.tickets)
    end

    TriggerEvent("cframework:vipLog", "VIP ENTREGUE", "STEAM: " .. identifier .. "\nTRANSACTION: " .. transactionId .. "\nPACKAGE: " .. packageDetails.name, 15158332)

    if GetPlayerName(source) ~= nil then
        TriggerClientEvent('esx:showNotification', source, T("VIP_DELIVERED"), "inform")
        TriggerClientEvent("cframework:vipDelivery", source, packageDetails.name)
    end
end

RegisterCommand("tebex", tebexDeliverProduct, true)
