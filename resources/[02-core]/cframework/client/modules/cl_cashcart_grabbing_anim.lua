

local function cashGrabbingLoop(ped, grabItem, cb)
    local pedCoords <const> = GetEntityCoords(ped)
    local cashPile <const> = CreateObject(grabItem, pedCoords.x, pedCoords.y, pedCoords.z, false, false, false)

    FreezeEntityPosition(cashPile, true)
    SetEntityInvincible(cashPile, true)
    SetEntityNoCollisionEntity(cashPile, ped, false)
    SetEntityVisible(cashPile, false, false)
    AttachEntityToEntity(cashPile, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)

    local startedGrabbing = GetGameTimer()

    Citizen.CreateThread(function()
        while GetGameTimer() - startedGrabbing < 37000 do
            Citizen.Wait(0)
            DisableControlAction(0, 73, true)

            if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                if not IsEntityVisible(cashPile) then
                    SetEntityVisible(cashPile, true, false)
                end
            end

            if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                if IsEntityVisible(cashPile) then
                    SetEntityVisible(cashPile, false, false)
                    cb()
                end
            end
        end

        if DoesEntityExist(cashPile) then
            DeleteObject(cashPile)
        end
    end)
end

local function loadGrabAnimDictAndCashPile(grabItem)
    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(grabItem)

    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(grabItem) do
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

local function prepareCashGrabIntro(ped, trolley)
    local tCoords <const>, tRotation <const> = GetEntityCoords(trolley), GetEntityRotation(trolley)
    local grabSceneIntro <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, false, false, 1065353216, 0, 1.3)
    local bagNetId <const> = RPC.execute("cframework:spawnOrnateheistBag")
    local bag <const> = NetworkGetEntityFromNetworkId(bagNetId)

    SetEntityCollision(bag, false, true)
	NetworkAddPedToSynchronisedScene(ped, grabSceneIntro, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneIntro, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)

    return grabSceneIntro, bag
end

local function prepareCashGrabLoop(ped, trolley, bag)
    local tCoords <const>, tRotation <const> = GetEntityCoords(trolley), GetEntityRotation(trolley)
    local grabSceneLoop <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, true, false, 1065353216, 0, 1.3)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, grabSceneLoop, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneLoop, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(trolley, grabSceneLoop, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)

    return grabSceneLoop
end

local function prepareCashGrabOutro(ped, trolley, bag)
    local tCoords <const>, tRotation <const> = GetEntityCoords(trolley), GetEntityRotation(trolley)
    local grabSceneOutro <const> = NetworkCreateSynchronisedScene(tCoords.x, tCoords.y, tCoords.z, tRotation.x, tRotation.y, tRotation.z, 2, false, false, 1065353216, 0, 1.3)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, grabSceneOutro, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, grabSceneOutro, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)

    return grabSceneOutro
end

function ESX.StartGrabbingCashFromTrolley(trolley, grabItemHash, cb)
    local ped <const> = PlayerPedId()

    loadGrabAnimDictAndCashPile(grabItemHash)

    NetworkRequestControlOfEntity(trolley)
    while not NetworkHasControlOfEntity(trolley) do
		Citizen.Wait(0)
	end

    local grabSceneIntro <const>, bag <const> = prepareCashGrabIntro(ped, trolley)
    local grabSceneLoop <const> = prepareCashGrabLoop(ped, trolley, bag)
    local grabSceneOutro <const> = prepareCashGrabOutro(ped, trolley, bag)

    togglePedBagVisibility(ped, false)
	NetworkStartSynchronisedScene(grabSceneIntro)
	Citizen.Wait(1500)

	cashGrabbingLoop(ped, grabItemHash, cb)

    NetworkStartSynchronisedScene(grabSceneLoop)
    Citizen.Wait(37000)

    NetworkStartSynchronisedScene(grabSceneOutro)

	Citizen.Wait(1800)

    if DoesEntityExist(bag) then
        DeleteEntity(bag)
    end

    togglePedBagVisibility(ped, true)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
end
