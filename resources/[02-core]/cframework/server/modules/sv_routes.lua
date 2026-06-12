

local playerInRoutes = {}

RegisterNetEvent("cframework:startRouteRoutine", function()
    local source <const> = source

    if playerInRoutes[source] then
        TriggerClientEvent("cframework:endRoute", source)

        playerInRoutes[source] = nil
    else
        TriggerClientEvent("cframework:startRoute", source)

        playerInRoutes[source] = true
    end
end)