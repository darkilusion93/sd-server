ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

-- Valores FIXOS por nivel
local ChipData = {
    [1] = { boost = 0.28, inertia = 1.4, power = 14, brakeforce = 1.5, antilag = false },
    [2] = { boost = 0.32, inertia = 1.6, power = 22, brakeforce = 1.6, antilag = false },
    [3] = { boost = 0.37, inertia = 1.8, power = 32, brakeforce = 1.7, antilag = false },
    [4] = { boost = 0.43, inertia = 2.0, power = 44, brakeforce = 1.8, antilag = false },
    [5] = { boost = 0.50, inertia = 2.2, power = 58, brakeforce = 1.9, antilag = true  },
}

local antilagActive = false
local currentVeh    = nil
local PTFX_ASSET    = "core"
p_flame_location = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4"	
}
p_flame_particle = "veh_backfire"
p_flame_size = 2.4

-- ============================================================
--  APLICAR CHIP
-- ============================================================
function ApplyChip(veh, level)
    if not DoesEntityExist(veh) then return end
    if not ChipData[level] then return end

    local c   = ChipData[level]
    local cap = GetVehicleClass(veh) == 8 and 0.80 or 1.0

    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", c.boost * cap)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia",      c.inertia * cap)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeForce",        c.brakeforce)
    SetVehicleEnginePowerMultiplier(veh, c.power * cap)

    if c.antilag then
        StartAntilag(veh)
    else
        StopAntilag()
    end
end

-- ============================================================
--  ANTI-LAG (logica do bbv-antilag adaptada)
--  Dispara na mudanca de marcha com RPM alto
-- ============================================================
function SyncFlames(enable, vehicle)
    if not vehicle then return end
    local netVeh = VehToNet(vehicle)
    if not netVeh or netVeh == 0 then return end
    TriggerServerEvent("tunerchip:syncflames", netVeh, enable)
end

-- Recebe sincronizacao do servidor (visivel para todos os jogadores)
RegisterNetEvent("tunerchip:syncflames:client")
AddEventHandler("tunerchip:syncflames:client", function(netVeh, enable)
    local veh = NetToVeh(netVeh)
    if not veh or veh == 0 then return end
	for _,bones in pairs(p_flame_location) do
		UseParticleFxAssetNextCall(p_flame_particle_asset)
		createdPart = StartParticleFxLoopedOnEntityBone(p_flame_particle, veh, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(veh, bones), p_flame_size, 0.0, 0.0, 0.0)
		StopParticleFxLooped(createdPart, 1)
	end
end)

function StartAntilag(veh)
    if antilagActive then return end
    antilagActive = true
    currentVeh = veh
    local ped = GetPlayerPed(-1)
    local pedVehicle = GetVehiclePedIsIn(ped)

    Citizen.CreateThread(function()
        local lastGear = 0

        while antilagActive and DoesEntityExist(veh) do

            if not IsPedInAnyVehicle(ped, false) or GetVehiclePedIsIn(ped, false) ~= veh then
                break
            end

            local gear  = GetVehicleCurrentGear(veh)
            local rpm   = GetVehicleCurrentRpm(veh)
            local inAir = IsEntityInAir(veh)
            local accel = IsControlPressed(1, 71)
            local brake = IsControlPressed(1, 72)
            local vehiclePos = GetEntityCoords(pedVehicle)
			

            -- Dispara ao mudar de marcha, RPM > 40%, sem acelerador nem travao, no chao
            if gear ~= lastGear and rpm > 0.4 and not inAir and not accel and not brake then
                local delay = math.random(25, 350)
                SyncFlames(true, pedVehicle)
                AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
                SetVehicleTurboPressure(veh, 25.0)
                Citizen.Wait(delay)
                SyncFlames(false, pedVehicle)
            end

            lastGear = gear
            Citizen.Wait(0)
        end

        SyncFlames(false, pedVehicle)
        antilagActive = false
        currentVeh = nil
    end)
end

function StopAntilag()
    if antilagActive then
        SyncFlames(false)
    end
    antilagActive = false
    currentVeh = nil
end

-- ============================================================
--  EVENTOS
-- ============================================================
RegisterNetEvent("tunerchip:apply")
AddEventHandler("tunerchip:apply", function(level)
    StopAntilag()
    if not level or level == 0 then return end
    Citizen.CreateThread(function()
        local timeout = 0
        while not IsPedInAnyVehicle(GetPlayerPed(-1), false) and timeout < 50 do
            Citizen.Wait(200)
            timeout = timeout + 1
        end
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped then
                Citizen.Wait(500)
                ApplyChip(veh, level)
            end
        end
    end)
end)

-- Para anti-lag ao sair do veiculo
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if antilagActive and not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            StopAntilag()
        end
    end
end)

-- Servidor pede placa para guardar
RegisterNetEvent("tunerchip:requestSave")
AddEventHandler("tunerchip:requestSave", function(level)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if not IsPedInAnyVehicle(ped, false) then return end
    TriggerServerEvent("tunerchip:save", GetVehicleNumberPlateText(veh), level)
end)

-- Ao entrar num veiculo reaplica chip guardado
Citizen.CreateThread(function()
    local lastVeh = 0
    while true do
        Citizen.Wait(500)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh ~= lastVeh and GetPedInVehicleSeat(veh, -1) == ped then
                lastVeh = veh
                local plate = GetVehicleNumberPlateText(veh)
                ESX.TriggerServerCallback("tunerchip:getLevel", function(level)
                    if level and level > 0 then
                        Citizen.Wait(1000)
                        ApplyChip(veh, level)
                    end
                end, plate)
            end
        else
            lastVeh = 0
        end
    end
end)