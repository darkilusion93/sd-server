

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

RegisterCommand(T("COMMANDS_SURRENDER"), function()
    local playerPed = PlayerPedId()

    if not DoesEntityExist(playerPed) or IsEntityDead(playerPed) then
        return
    end

    loadAnimDict("random@arrests")
    loadAnimDict("random@arrests@busted")

    if IsEntityPlayingAnim(playerPed, "random@arrests@busted", "idle_a", 3) then
        TaskPlayAnim(playerPed, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, false, false, false)
        Citizen.Wait(3000)
        TaskPlayAnim(playerPed, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, false, false, false)
    else
        TaskPlayAnim(playerPed, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, false, false, false)
        Citizen.Wait(4000)
        TaskPlayAnim(playerPed, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, false, false, false)
        Citizen.Wait(500)
        TaskPlayAnim(playerPed, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, false, false, false)
        Citizen.Wait(1000)
        TaskPlayAnim(playerPed, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, false, false, false)
        Citizen.Wait(200)

        Citizen.CreateThread(function()
            while IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests@busted", "idle_a", 3) do
                Citizen.Wait(0)
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
                DisableControlAction(0,21,true)
            end
        end)
    end
end, false)
