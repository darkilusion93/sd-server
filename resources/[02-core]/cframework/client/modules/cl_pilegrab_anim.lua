

local function loadGrabAnimDict()
    RequestAnimDict("anim@scripted@player@mission@tun_table_grab@cash@")

    while not HasAnimDictLoaded("anim@scripted@player@mission@tun_table_grab@cash@") do
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

local function prepareStackGrabIntro(ped, stack)
    local tCoords <const>, tRotation <const> = GetEntityCoords(stack), GetEntityRotation(stack)
    local grabSceneIntro <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, true, false, 1065353216, 0, 1.3)
    local bagNetId <const> = RPC.execute("cframework:spawnOrnateheistBag")
    local bag <const> = NetworkGetEntityFromNetworkId(bagNetId)

    SetEntityCollision(bag, false, true)
	NetworkAddPedToSynchronisedScene(ped, grabSceneIntro, "anim@scripted@player@mission@tun_table_grab@cash@", "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneIntro, "anim@scripted@player@mission@tun_table_grab@cash@", "enter_bag", 4.0, -8.0, 1)

    return grabSceneIntro, bag
end

local function prepareStackGrabLoop(ped, stack, bag)
    local tCoords <const>, tRotation <const> = GetEntityCoords(stack), GetEntityRotation(stack)
    local grabSceneLoop <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, true, false, 1065353216, 0, 1.3)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, grabSceneLoop, "anim@scripted@player@mission@tun_table_grab@cash@", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneLoop, "anim@scripted@player@mission@tun_table_grab@cash@", "grab_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(stack, grabSceneLoop, "anim@scripted@player@mission@tun_table_grab@cash@", "grab_cash", 4.0, -8.0, 1)

    return grabSceneLoop
end

local function prepareStackGrabOutro(ped, stack, bag)
    local tCoords <const>, tRotation <const> = GetEntityCoords(stack), GetEntityRotation(stack)
    local grabSceneOutro <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, true, false, 1065353216, 0, 1.3)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, grabSceneOutro, "anim@scripted@player@mission@tun_table_grab@cash@", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneOutro, "anim@scripted@player@mission@tun_table_grab@cash@", "exit_bag", 4.0, -8.0, 1)

    return grabSceneOutro
end

--h4_prop_h4_coke_stack_01a
function ESX.StartGrabbingItemsFromStack(stack)
    local ped <const> = PlayerPedId()

    loadGrabAnimDict()

    NetworkRequestControlOfEntity(stack)
    while not NetworkHasControlOfEntity(stack) do
		Citizen.Wait(0)
	end

    local grabSceneIntro <const>, bag <const> = prepareStackGrabIntro(ped, stack)
    local grabSceneLoop <const> = prepareStackGrabLoop(ped, stack, bag)
    local grabSceneOutro <const> = prepareStackGrabOutro(ped, stack, bag)

    togglePedBagVisibility(ped, false)
	NetworkStartSynchronisedScene(grabSceneIntro)

    Citizen.Wait(1350)

    NetworkStartSynchronisedScene(grabSceneLoop)

    Citizen.Wait(10000)

    NetworkStartSynchronisedScene(grabSceneOutro)

    Citizen.Wait(1350)

    if DoesEntityExist(bag) then
        DeleteEntity(bag)
    end

    togglePedBagVisibility(ped, true)
	RemoveAnimDict("anim@scripted@player@mission@tun_table_grab@cash@")
end