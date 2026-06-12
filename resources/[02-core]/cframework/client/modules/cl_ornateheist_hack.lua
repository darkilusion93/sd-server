

local heist = LoadOrnateHeist()
local hackableDoors <const> = heist.hackableDoors
local animDict = "anim@heists@ornate_bank@hack"

local function loadHackAnimDict()
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
end

local function togglePedBagVisibility(ped, visible)
    if visible then
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        return
    end

    SetPedComponentVariation(ped, 5, 0, 0, 0)
end

local function startHackingDoor(currentDoor)
    local loc = hackableDoors[currentDoor]
    local ped = PlayerPedId()

    loadHackAnimDict()

    local animPos = GetAnimInitialOffsetPosition(animDict, "hack_enter", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)
    local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", loc.x, loc.y, loc.z, loc.x, loc.y, loc.z, 0, 2)

    FreezeEntityPosition(ped, true)

    local bagNetId <const>, laptopNetId <const>, cardNetId <const> = RPC.execute("cframework:spawnHackProps", currentDoor)
    local bag <const>, laptop <const>, card <const> = NetworkGetEntityFromNetworkId(bagNetId), NetworkGetEntityFromNetworkId(laptopNetId), NetworkGetEntityFromNetworkId(cardNetId)

    SetEntityCollision(bag, false, true)
    SetEntityCollision(laptop, false, true)
    SetEntityCollision(card, false, true)

    local hackEnterScene <const> = NetworkCreateSynchronisedScene(animPos.x, animPos.y, animPos.z, 0, 0, loc.w, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, hackEnterScene, animDict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, hackEnterScene, animDict, "hack_enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, hackEnterScene, animDict, "hack_enter_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, hackEnterScene, animDict, "hack_enter_card", 4.0, -8.0, 1)

    local hackLoopScene <const> = NetworkCreateSynchronisedScene(animPos2.x, animPos2.y, animPos2.z, 0, 0, loc.w, 2, false, true, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, hackLoopScene, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, hackLoopScene, animDict, "hack_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, hackLoopScene, animDict, "hack_loop_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, hackLoopScene, animDict, "hack_loop_card", 4.0, -8.0, 1)

    local hackOutroScene <const> = NetworkCreateSynchronisedScene(animPos3.x, animPos3.y, animPos3.z, 0, 0, loc.w, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(ped, hackOutroScene, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, hackOutroScene, animDict, "hack_exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(laptop, hackOutroScene, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(card, hackOutroScene, animDict, "hack_exit_card", 4.0, -8.0, 1)

    Citizen.Wait(200)
    togglePedBagVisibility(ped, false)
    NetworkStartSynchronisedScene(hackEnterScene)
    Citizen.Wait(6300)
    NetworkStartSynchronisedScene(hackLoopScene)
    Citizen.Wait(2000)

    ESX.ShowNotification("Open My Computer and navigate to HackConnect.exe", "success")

    local success = ESX.BruteMinigame()
    TriggerServerEvent("cframework:finishHackingDoor", currentDoor, success)

    Citizen.Wait(1500)
    NetworkStartSynchronisedScene(hackOutroScene)
    Citizen.Wait(4600)

    togglePedBagVisibility(ped, true)
    NetworkStopSynchronisedScene(hackOutroScene)

    DeleteObject(bag)
    DeleteObject(laptop)
    DeleteObject(card)

    FreezeEntityPosition(ped, false)
end

RegisterNetEvent("cframework:tryToHackDoor", function(currentDoor)
    startHackingDoor(currentDoor)
end)
