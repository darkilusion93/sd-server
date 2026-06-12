


local teleportData = LoadTeleporters()
local CurrentAction = nil

local function teleport(table, location)
    if location == 'Enter' then
        DoScreenFadeOut(100)
        Citizen.Wait(750)
        ESX.Game.Teleport(PlayerPedId(), table['Exit'])
        DoScreenFadeIn(100)
    else
        DoScreenFadeOut(100)
        Citizen.Wait(750)
        ESX.Game.Teleport(PlayerPedId(), table['Enter'])
        DoScreenFadeIn(100)
    end
end

Citizen.CreateThread(function ()
    for location, val in pairs(teleportData.Teleporters) do
        local enter = val['Enter']
        local exit = val['Exit']

        exports.ft_libs:AddMarker("teleporter_enter_" .. location, {type = 50, x = enter.x, y = enter.y, z = enter.z, weight = 1, height = 1, red = 255, green = 253, blue = 255, showDistance = 10})
        exports.ft_libs:AddTrigger("teleporter_enter_" .. location, {x = enter.x, y = enter.y, z = enter.z, weight = 1, height = 2,
        enter = {eventClient = "teleporterEnteredMarker"}, exit = {eventClient = "teleporterExitedMarker"}, data = {"Enter", location}, active = {}})

        exports.ft_libs:AddMarker("teleporter_exit_" .. location, {type = 50, x = exit.x, y = exit.y, z = exit.z, weight = 1, height = 1, red = 255, green = 253, blue = 255, showDistance = 10})
        exports.ft_libs:AddTrigger("teleporter_exit_" .. location, {x = exit.x, y = exit.y, z = exit.z, weight = 1, height = 2,
        enter = {eventClient = "teleporterEnteredMarker"}, exit = {eventClient = "teleporterExitedMarker"}, data = {"Exit", location}, active = {}})
    end
end)


RegisterNetEvent("teleporterEnteredMarker", function(action)
    CurrentAction = action[1]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            local teleportInfo <const> = teleportData.Teleporters[action[2]]

            if teleportInfo.Job ~= "none" and ESX.PlayerData.job.name ~= teleportInfo.Job then
                CurrentAction = nil
                break
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if not IsControlPressed(0, 38) then
                goto final
            end

            teleport(teleportInfo, CurrentAction)
            CurrentAction = nil

            ::final::

            Citizen.Wait(0)
        end
    end)

end)

RegisterNetEvent("teleporterExitedMarker", function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)
