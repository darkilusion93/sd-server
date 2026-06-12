

local heist = LoadOrnateHeist()
local thermalChargeDoors <const> = heist.thermalChargeDoors

local function resquestAnimAndPtfx()
    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestNamedPtfxAsset("scr_ornate_heist")

    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(50)
    end
end

local function prepareThermalChargeScene(ped, loc, rotplus, currentplant)
    local bagscene <const> = NetworkCreateSynchronisedScene(loc.x, loc.y, loc.z, 0, 0, rotplus, 2, false, false, 1065353216, 0, 1.3)
    local bagNetId <const> = RPC.execute("cframework:spawnOrnateheistBag")
    local bag <const> = NetworkGetEntityFromNetworkId(bagNetId)

    SetEntityCollision(bag, false, true)
    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)

    return bagscene, bag
end

local function prepareThermalChargeEntity(ped)
    local thermiteNetId = RPC.execute("cframework:spawnOrnateheistThermalCharge")
    local thermite = NetworkGetEntityFromNetworkId(thermiteNetId)

    SetEntityCollision(thermite, false, true)
    AttachEntityToEntity(thermite, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)

    return thermite
end

local function togglePedBagVisibility(ped, visible)
    if visible then
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        return
    end

    SetPedComponentVariation(ped, 5, 0, 0, 0)
end

local function useThermalCharge(currentplant)
    local door <const> = thermalChargeDoors[currentplant]
    local loc, rotplus = door.loc, door.rotplus
    local ped <const> = PlayerPedId()

    resquestAnimAndPtfx()

    SetEntityHeading(ped, loc.w)
    Citizen.Wait(100)

    local bagscene <const>, bag <const> = prepareThermalChargeScene(ped, loc, rotplus, currentplant)

    togglePedBagVisibility(ped, false)
    NetworkStartSynchronisedScene(bagscene)

    Citizen.Wait(1500)

    local thermite <const> = prepareThermalChargeEntity(ped)

    Citizen.Wait(2800)

    DetachEntity(thermite, true, true)
    FreezeEntityPosition(thermite, true)

    Citizen.Wait(1200)

    togglePedBagVisibility(ped, true)
    DeleteObject(bag)

    TriggerServerEvent("cframework:playPtfxThermiteOnClosePlayers", currentplant)
    NetworkStopSynchronisedScene(bagscene)

    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, false, false, false)
    TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 3000, 49, 1, false, false, false)
    Citizen.Wait(4000)

    ClearPedTasks(ped)
    DeleteObject(thermite)

    TriggerServerEvent("cframework:replaceThermalChargeDoorClosePlayers", currentplant)
    Citizen.Wait(8000)
    ESX.ShowNotification("Fechadura derretida", "success")
end

RegisterNetEvent("cframework:playPtfxThermite", function(currentplant)
    local door <const> = thermalChargeDoors[currentplant]
    local ptfx <const> = door.ptfx

    RequestNamedPtfxAsset("scr_ornate_heist")
    while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
        Citizen.Wait(1)
    end

    SetPtfxAssetNextCall("scr_ornate_heist")
    local effect <const> = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", ptfx.x, ptfx.y, ptfx.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    Citizen.Wait(13000)
    StopParticleFxLooped(effect, false)
end)

RegisterNetEvent("cframework:replaceThermalChargeDoor", function(currentplant, reset)
    local door <const> = thermalChargeDoors[currentplant]
    local loc <const>, oldmodel <const>, newmodel <const> = door.loc, door.oldmodel, door.newmodel

    if reset then
        CreateModelSwap(loc.x, loc.y, loc.z, 5.0, GetHashKey(newmodel), GetHashKey(oldmodel), true)
        return
    end

    CreateModelSwap(loc.x, loc.y, loc.z, 5.0, GetHashKey(oldmodel), GetHashKey(newmodel), true)
end)

RegisterNetEvent("cframework:useThermalCharge", function (currentplant)
    useThermalCharge(currentplant)
end)
