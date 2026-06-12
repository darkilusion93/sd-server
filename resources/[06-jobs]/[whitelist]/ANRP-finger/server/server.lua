ESX          = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("ANRP-finger:fetchData", function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local responseData = {}

    if xPlayer then
        local identifier = xPlayer.identifier

        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, id FROM users WHERE identifier = @identifier', {
            ['@identifier'] = identifier
        }, function(result)
            if result and #result > 0 then
                responseData.firstname = result[1].firstname
                responseData.lastname = result[1].lastname
                responseData.dob = result[1].dateofbirth
                responseData.account = result[1].sex
                responseData.phone = result[1].id
                cb(responseData)
            else
                print('Data not found for identifier: ' .. identifier)
            end
        end)
    end
end)



-- RegisterServerEvent('ANRP-finger:server:showComputer')
-- AddEventHandler('ANRP-finger:server:showComputer', function(data, id)
-- 	TriggerClientEvent("ANRP-finger:client:showComputer", -1, data, id)
-- end)

RegisterServerEvent('ANRP-finger:server:showComputer')
AddEventHandler('ANRP-finger:server:showComputer', function(data, id)
    local source = source
    local players = GetPlayers()
    local playerCoords = GetEntityCoords(GetPlayerPed(source))

    for _, playerId in ipairs(players) do
        if playerId ~= source then
            local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
            local distance = #(playerCoords - targetCoords)

            if distance <= 2.0 then
                TriggerClientEvent("ANRP-finger:client:showComputer", playerId, data, id)
            end
        end
    end
end)
