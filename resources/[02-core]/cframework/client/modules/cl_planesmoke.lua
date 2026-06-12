

local PARTICLE_DICTIONARY <const> = "scr_ar_planes"
local PARTICLE_NAME <const> = "scr_ar_trail_smoke"

local DefaultSmokeSettings = {
    size = 1.0,
    r = 255 / 255,
    g = 255 / 255,
    b = 255 / 255,
    position = "Center"
}

Citizen.CreateThread(function()
    RequestNamedPtfxAsset(PARTICLE_DICTIONARY)
    while not HasNamedPtfxAssetLoaded(PARTICLE_DICTIONARY) do
        Wait(0)
    end
end)

local function Notify(message, type)
    ESX.ShowNotification(message, type)
end

local SMOKE_DATA = {}
local ShouldDrawSmoke = false

local function StopSmoke(player)
    if not SMOKE_DATA[player] then
        return
    end

    StopParticleFxLooped(SMOKE_DATA[player].handle, false)
    SMOKE_DATA[player] = nil

    if #SMOKE_DATA == 0 then
        ShouldDrawSmoke = false
    end
end

local function GetBoneFromName(VEHICLE, name)
    if name == "Center" then
        return -1
    elseif name == "Right Wing" then
        local RightBone = GetEntityBoneIndexByName(VEHICLE, "wingtip_2")
        return RightBone ~= -1 and RightBone or GetEntityBoneIndexByName(VEHICLE, "aileron_r")
    elseif name == "Left Wing" then
        local LeftBone = GetEntityBoneIndexByName(VEHICLE, "wingtip_1")
        return LeftBone ~= -1 and LeftBone or GetEntityBoneIndexByName(VEHICLE, "aileron_l")
    end
end

local function DrawSmoke()
    Citizen.CreateThread(function()
        while ShouldDrawSmoke do
            for player, data in pairs(SMOKE_DATA) do
                local PLAYER_ID = GetPlayerFromServerId(player)
                local PED = GetPlayerPed(PLAYER_ID)
                local VEHICLE = GetVehiclePedIsIn(PED, false)
                if DoesEntityExist(VEHICLE) and PED ~= 0 and PLAYER_ID ~= -1 then
                    if data.handle then
                        SetParticleFxLoopedScale(data.handle, data.size + 0.0)
                        SetParticleFxLoopedColour(data.handle, data.r + 0.0, data.g + 0.0, data.b + 0.0, false)
                    else
                        local BONE = GetBoneFromName(VEHICLE, data.position or "Center")
                        UseParticleFxAssetNextCall(PARTICLE_DICTIONARY)
                        SMOKE_DATA[player].handle =
                            StartNetworkedParticleFxLoopedOnEntityBone(
                            PARTICLE_NAME,
                            VEHICLE,
                            0.0,
                            BONE == -1 and -8.5 or 0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            BONE,
                            data.size + 0.0,
                            false,
                            false,
                            false
                        )
                        SetParticleFxLoopedScale(SMOKE_DATA[player].handle, data.size + 0.0)
                        SetParticleFxLoopedColour(
                            SMOKE_DATA[player].handle,
                            data.r + 0.0,
                            data.g + 0.0,
                            data.b + 0.0,
                            false
                        )
                    end
                end
            end

            Citizen.Wait(750)
        end
    end)
end

local function StartSmoke(player, data)
    if SMOKE_DATA[player] then
        StopSmoke(player)
        SMOKE_DATA[player] = data
    else
        SMOKE_DATA[player] = data
    end

    if not ShouldDrawSmoke then
        ShouldDrawSmoke = true
        DrawSmoke()
    end
end

---@diagnostic disable-next-line: param-type-mismatch
AddStateBagChangeHandler("vehdata:planesmoke", nil, function(bagName, _, value)
    local player = GetPlayerFromStateBagName(bagName)
    if player == 0 then
        return
    end

    local player_id = GetPlayerServerId(player)

    if value then
        StartSmoke(player_id, value)
    else
        StopSmoke(player_id)
    end
end)

local SmokeSettings = DefaultSmokeSettings
local SmokeEnabled = false

RegisterCommand("smoke", function()
    if SmokeEnabled then
        -- disable
        SmokeEnabled = false
        LocalPlayer.state:set("vehdata:planesmoke", nil, true)
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local pedInSeat = GetPedInVehicleSeat(vehicle, -1)

    if not IsPedInAnyPlane(ped) then
        return Notify("You must be in an aircraft to enable smoke!", "error")
    end
    if pedInSeat ~= ped then
        return Notify("You must be the pilot to enable smoke!", "error")
    end

    SmokeEnabled = true
    LocalPlayer.state:set("vehdata:planesmoke", SmokeSettings, true)

    Citizen.CreateThread(function()
        while SmokeEnabled do
            if not GetIsVehicleEngineRunning(vehicle) or IsEntityDead(vehicle) then
                LocalPlayer.state:set("vehdata:planesmoke", nil, true)
                SmokeEnabled = false
                break
            end
            Wait(2000)
        end
    end)
end, false)

RegisterCommand("smokecolor", function(source, args, raw)
    local r, g, b = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

    if not r or not g or not b then
        return Notify("Invalid color!", "error")
    end

    SmokeSettings.r = r / 255
    SmokeSettings.g = g / 255
    SmokeSettings.b = b / 255
end, false)