

local vehicleList = {}

RPC.register('getLockData', function()
    local source = source
    local data = vehicleList[ESX.getIdentifier(source)]

    if data == nil then return {} end

    return data
end)

RegisterNetEvent("cframework:sendLockData", function(data)
    local source = source
    local identifier <const> = ESX.getIdentifier(source)

    vehicleList[identifier] = data
end)

RegisterNetEvent("cframework:setLockStatus", function(netId, lock)
    local vehicle <const> = NetworkGetEntityFromNetworkId(netId)

    if not DoesEntityExist(vehicle) then
        return
    end

    if lock ~= 1 and lock ~= 2 then
        return
    end

    SetVehicleDoorsLocked(vehicle, lock)
end)
