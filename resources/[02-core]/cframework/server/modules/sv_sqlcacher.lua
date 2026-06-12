local messageCacher = {}
local trunkCacher = {}

local function processMessageCacher()
    if #messageCacher == 0 then return end

    local query = 'INSERT INTO `phone_messages` (`transmitter`, `receiver`, `message`, `isRead`, `owner`, `type`) VALUES '

    for k, v in ipairs(messageCacher) do
        if v.transmitter == nil or v.receiver == nil then goto jump end
        
        query = query .. '("'.. v.transmitter ..'", "'.. v.receiver ..'", \''.. string.gsub(v.message, "'", "") ..'\', '.. v.isRead ..', '.. v.owner ..', "'.. v.type ..'")'

        if k == #messageCacher then query = query .. ';' else query = query .. ',' end

        ::jump::
    end

    messageCacher = {}

    MySQL.Async.insert(query, {}) 
end

local function processTrunkCacher()
    local updated = false

    local query = 'UPDATE `trunk_inventory` SET `data` = CASE '
    local where = '('

    for k, v in pairs(trunkCacher) do
        query = query .. 'WHEN plate = "'.. k ..'" THEN \''..v..'\' '

        where = where .. '"' .. k .. '",'

        updated = true
    end

    if not updated then return end

    where = string.sub(where, 1, -2)

    query = query .. 'END WHERE plate IN '..where..')'

    trunkCacher = {}

    MySQL.Async.execute(query, {}) 
end

ESX.sqlInsertMessage = function(tr, r, m, i, o, t)
    if #messageCacher >= 750 then processMessageCacher() end

    table.insert(messageCacher, {transmitter = tr, receiver = r, message = m, isRead = i, owner = o, type = t})
end

ESX.sqlUpdateTrunk = function(plate, data)
    trunkCacher[plate] = data
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- 1 Minuto
        processMessageCacher()
        Citizen.Wait(5000)
        --processTrunkCacher()
    end
end)

AddEventHandler('cframework:serverAboutToClose', function()
    processMessageCacher()
    --processTrunkCacher()
end)