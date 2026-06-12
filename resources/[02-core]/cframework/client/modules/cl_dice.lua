-- Title	:	cl_dice.lua
-- Author	:	ZacFierce and MrFunBeard
-- Started	:	14/06/19

RegisterCommand('roll', function()
    local max <const>, min <const> = 12, 1
    local playerPed <const> = PlayerPedId()

    -- Roll and add up rolls
    local result = 0
    for _ = min, 1, -1 do
        result = result + math.random(1, max)
    end

    while not HasAnimDictLoaded("anim@mp_player_intcelebrationmale@wank") do
        RequestAnimDict("anim@mp_player_intcelebrationmale@wank")
        Citizen.Wait(0)
    end

    TaskPlayAnim(playerPed, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, false, false, false)
    Citizen.Wait(1500)
    ClearPedTasks(playerPed)

    local players = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 50)
    local serverSources = {}

    for _, playerId in ipairs(players) do
        serverSources[GetPlayerServerId(playerId)] = true
    end

    TriggerServerEvent('esx_orgs:3dme', string.format(T("DICE_RESULT"), max, min, result), GetPlayerServerId(PlayerId()), serverSources)
end, false)
