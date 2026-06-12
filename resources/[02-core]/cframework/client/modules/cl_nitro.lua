

--Trails
local vehiclesTrails = {}
local particles = {}

function IsVehicleLightTrailEnabled(vehicle)
  return vehiclesTrails[vehicle] == true
end

function SetVehicleLightTrailEnabled(vehicle, enabled)
  if IsVehicleLightTrailEnabled(vehicle) == enabled then
    return
  end

  if enabled then
    local ptfxs = {}

    local leftTrail = CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"), 1.0)
    local rightTrail = CreateVehicleLightTrail(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"), 1.0)

    table.insert(ptfxs, leftTrail)
    table.insert(ptfxs, rightTrail)

    vehiclesTrails[vehicle] = true
    particles[vehicle] = ptfxs
  else
    if particles[vehicle] and #particles[vehicle] > 0 then
      for _, particleId in ipairs(particles[vehicle]) do
        StopVehicleLightTrail(particleId, 500)
      end
    end

    vehiclesTrails[vehicle] = nil
    particles[vehicle] = nil
  end
end

--Boost
local vehiclesBoost = {}

function SetNitroBoostScreenEffectsEnabled(enabled)
  if enabled then
    StopScreenEffect('RaceTurbo')
    StartScreenEffect('RaceTurbo', 0, false)
    SetTimecycleModifier('rply_motionblur')
    ShakeGameplayCam('SKY_DIVING_SHAKE', 0.25)
  else
    StopGameplayCamShaking(true)
    SetTransitionTimecycleModifier('default', 0.35)
  end
end

function IsVehicleNitroBoostEnabled(vehicle)
    local nitroEnabled = Entity(vehicle).state.nitroEnabled or false

    return nitroEnabled
end

function SetVehicleNitroBoostEnabled(vehicle, enabled)
  if (vehiclesBoost[vehicle] or false) == enabled then
    return
  end

  if IsPedInVehicle(PlayerPedId(), vehicle, false) or not enabled then
    SetNitroBoostScreenEffectsEnabled(enabled)
  end

  SetVehicleBoostActive(vehicle, enabled)
  vehiclesBoost[vehicle] = enabled or nil

  TriggerServerEvent("cframework:toggleNitro", NetworkGetNetworkIdFromEntity(vehicle), enabled)
  TriggerEvent("cframework:usingNitro", enabled)
end

Citizen.CreateThread(function ()
  local function BackfireLoop()
  RequestNamedPtfxAsset("veh_xs_vehicle_mods")
  -- TODO: Only do this for nearby vehicles.
    for vehicle in pairs(vehiclesBoost) do
      --CreateVehicleExhaustBackfire(vehicle, 1.25)
      DrainNitroFuel(vehicle, false)
      --SetVehicleNitroEnabled(vehicle, true, 0.0, 0.0, 0.0, true)
    end
  end

  while true do
    Citizen.Wait(250)
    BackfireLoop()    
  end
end)

Citizen.CreateThread(function ()
  local function BoostLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local enabled = IsVehicleNitroBoostEnabled(vehicle)

    if vehicle == 0 or driver ~= player or not enabled then
      return
    end

    -- TODO: Use better math. The effect of nitro is quite extreme for cars with
    -- custom handling, while slow cars have almost no effect from this at all.
    -- Also, maybe torque is not the correct setting to change.
    if not IsVehicleStopped(vehicle) then
      local vehicleModel = GetEntityModel(vehicle)
      local currentSpeed = GetEntitySpeed(vehicle)
      local maximumSpeed = GetVehicleModelMaxSpeed(vehicleModel)
      local multiplier = 2.0 * maximumSpeed / currentSpeed

      SetVehicleCheatPowerIncrease(vehicle, multiplier)
    end
  end

  while true do
    Citizen.Wait(0)
    BoostLoop()
  end
end)

--Fuel
local lastNitro = 0
local nitroCooldown = 2500 -- TODO: per-vehicle cooldown?

local nitroFuelSize = 15000.0
local nitroFuelDrainRate = 350.0
local nitroPurgeFuelDrainRate = nitroFuelDrainRate * 2.0
local nitroRechargeRate = nitroFuelDrainRate / 2.0

function InitNitroFuel(vehicle)
    TriggerServerEvent("cframework:syncNitro", NetworkGetNetworkIdFromEntity(vehicle), nitroFuelSize)
end

function DrainNitroFuel(vehicle, purge)
    if not purge then
        purge = false
    end

    local nitroLevel = Entity(vehicle).state.nitroLevel or 0.0

    if nitroLevel > 0 then
        if purge then
            nitroLevel = nitroLevel - nitroPurgeFuelDrainRate
        else
            nitroLevel = nitroLevel - nitroFuelDrainRate
        end

        TriggerServerEvent("cframework:syncNitro", NetworkGetNetworkIdFromEntity(vehicle), nitroLevel)

        lastNitro = GetGameTimer()
    end
end

function RechargeNitroFuel(vehicle)
    local nitroLevel = Entity(vehicle).state.nitroLevel or 0.0

    if nitroLevel < nitroFuelSize then
        nitroLevel = nitroLevel + nitroRechargeRate

        TriggerServerEvent("cframework:syncNitro", NetworkGetNetworkIdFromEntity(vehicle), nitroLevel)
    end
end

function GetNitroFuelLevel(vehicle)
    local nitroLevel = Entity(vehicle).state.nitroLevel or 0.0

    return nitroLevel / nitroFuelSize * 100.0
end

exports('GetNitroFuelLevel', GetNitroFuelLevel)

function SetNitroFuelLevel(vehicle, level)
    TriggerServerEvent("cframework:syncNitro", NetworkGetNetworkIdFromEntity(vehicle), level)
end

Citizen.CreateThread(function ()
  local function FuelLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local isRunning = GetIsVehicleEngineRunning(vehicle)
    local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
    local isPurging = IsVehicleNitroPurgeEnabled(vehicle)

    if vehicle == 0 or driver ~= player or not isRunning then
      return
    end

    if isRunning then
      if isBoosting == false and isPurging == false and GetGameTimer() > lastNitro + nitroCooldown then
        --RechargeNitroFuel(vehicle)
      end
    end
  end

  while true do
    Citizen.Wait(0)
    FuelLoop()
  end
end)

--Particles
function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
  UseParticleFxAssetNextCall('core')
  return StartParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
end

function CreateVehicleLightTrail(vehicle, bone, scale)
  UseParticleFxAssetNextCall('core')
  local ptfx = StartParticleFxLoopedOnEntityBone('veh_light_red_trail', vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, bone, scale, false, false, false)
  SetParticleFxLoopedEvolution(ptfx, "speed", 1.0, false)
  return ptfx
end

function StopVehicleLightTrail(ptfx, duration)
  Citizen.CreateThread(function()
    local startTime = GetGameTimer()
    local endTime = GetGameTimer() + duration
    while GetGameTimer() < endTime do 
      Citizen.Wait(0)
      local now = GetGameTimer()
      local scale = (endTime - now) / duration
      SetParticleFxLoopedScale(ptfx, scale)
      SetParticleFxLoopedAlpha(ptfx, scale)
    end
    StopParticleFxLooped(ptfx)
  end)
end

--Purge

local vehiclesPurge = {}
local particles = {}

function IsVehicleNitroPurgeEnabled(vehicle)
  return vehiclesPurge[vehicle] == true
end

function SetVehicleNitroPurgeEnabled(vehicle, enabled)
  if IsVehicleNitroPurgeEnabled(vehicle) == enabled then
    return
  end

  if enabled then
    local bone = GetEntityBoneIndexByName(vehicle, 'bonnet')
    local pos = GetWorldPositionOfEntityBone(vehicle, bone)
    local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
    local ptfxs = {}

    for i=0,3 do
      local leftPurge = CreateVehiclePurgeSpray(vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, 0.5)
      local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, 0.5)

      table.insert(ptfxs, leftPurge)
      table.insert(ptfxs, rightPurge)
    end

    vehiclesPurge[vehicle] = true
    particles[vehicle] = ptfxs
  else
    if particles[vehicle] and #particles[vehicle] > 0 then
      for _, particleId in ipairs(particles[vehicle]) do
        StopParticleFxLooped(particleId)
      end
    end

    vehiclesPurge[vehicle] = nil
    particles[vehicle] = nil
  end
end

--Main

local INPUT_VEH_ACCELERATE = 71
local enableNitro = false

local function IsNitroControlPressed()
    return enableNitro
end

local function IsDrivingControlPressed()
    return IsControlPressed(0, INPUT_VEH_ACCELERATE)
end

local function NitroLoop(lastVehicle)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    local driver = GetPedInVehicleSeat(vehicle, -1)

    if lastVehicle ~= 0 and lastVehicle ~= vehicle then
        SetVehicleNitroBoostEnabled(lastVehicle, false)
        SetVehicleLightTrailEnabled(lastVehicle, false)
        SetVehicleNitroPurgeEnabled(lastVehicle, false)
    end

    if vehicle == 0 or driver ~= player then
        return 0
    end

    local model = GetEntityModel(vehicle)

    if not IsThisModelACar(model) --[[or IsVehicleElectric(vehicle)]] then
        return 0
    end

    local isEnabled = IsNitroControlPressed()
    local isDriving = IsDrivingControlPressed()
    local isRunning = GetIsVehicleEngineRunning(vehicle)
    local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
    local isPurging = IsVehicleNitroPurgeEnabled(vehicle)
    local isFueled = GetNitroFuelLevel(vehicle) > 0

    if isEnabled and exports["gracing"]:inRaceWithDisabledNitro() then
        isEnabled = false
    end

    if isRunning and isEnabled and isFueled then
        if isDriving then
            if not isBoosting then
                SetVehicleNitroBoostEnabled(vehicle, true)
                SetVehicleLightTrailEnabled(vehicle, true)
                SetVehicleNitroPurgeEnabled(vehicle, false)
            end
        else
            if not isPurging then
                SetVehicleNitroBoostEnabled(vehicle, false)
                SetVehicleLightTrailEnabled(vehicle, false)
                SetVehicleNitroPurgeEnabled(vehicle, true)
            end
        end
    elseif isBoosting or isPurging then
        SetVehicleNitroBoostEnabled(vehicle, false)
        SetVehicleLightTrailEnabled(vehicle, false)
        SetVehicleNitroPurgeEnabled(vehicle, false)
        SetVehicleNitroEnabled(vehicle, false)
    end

    return vehicle
end

Citizen.CreateThread(function ()
  local lastVehicle = 0

  while true do
    Citizen.Wait(0)
    lastVehicle = NitroLoop(lastVehicle)
  end
end)

RegisterCommand('+nitro', function() enableNitro = true end, false)
RegisterCommand('-nitro', function() enableNitro = false end, false)
RegisterKeyMapping('+nitro', 'Nitro', 'keyboard', 'e')

RegisterNetEvent('cframework:nitro', function()
  local player = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(player)
  local driver = GetPedInVehicleSeat(vehicle, -1)

  if vehicle == 0 or driver ~= player then
    ESX.ShowNotification('Usaste um nitro fora do carro...', 'error')
    return
  end

  InitNitroFuel(vehicle)
end)
