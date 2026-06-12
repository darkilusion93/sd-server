

RegisterNetEvent("cframework:packingAnimation", function()
    RequestAnimDict("amb@world_human_bum_standing@twitchy@base")
    while not HasAnimDictLoaded("amb@world_human_bum_standing@twitchy@base") do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "amb@world_human_bum_standing@twitchy@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)

    Citizen.Wait(500)

    ClearPedTasks(PlayerPedId())
end)