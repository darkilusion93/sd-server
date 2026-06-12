local PlayerData = {}
ESX              = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

local inScanner = false

local computerData = {}

RegisterCommand("fechar_ui", function(source, args)
    SetNuiFocus(false, false)
end, false)


function openScanner(bool)
    inScanner = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "scanner",
        toggle = bool,
        details = data
    })
end

RegisterNUICallback('scanner-exit', function()
    openScanner(false)
    SetNuiFocus(false, false)
    inScanner = false
end)

RegisterNUICallback('details', function(data, cb)
    ESX.TriggerServerCallback('ANRP-finger:fetchData', function(computerData)
        PlaySound()
        cb(computerData)
        local id = PlayerId()
        TriggerServerEvent("ANRP-finger:server:showComputer", computerData, id)
    end)

    PlaySound()
    local id = PlayerId()

    local player, distance = ESX.Game.GetClosestPlayer()
    if distance ~= -1 and distance <= 5.0 then
        TriggerServerEvent("ANRP-finger:server:showComputer", id, GetPlayerServerId(player))
    else
        TriggerServerEvent("ANRP-finger:server:showComputer", id, id)
    end

    Citizen.Wait(3000)
    cb(computerData)
end)


function PlaySound(data)
    local coords = GetEntityCoords(PlayerPedId())
    local sid = GetSoundId()

    PlaySoundFromCoord(sid, "Beep_Green", coords.x, coords.y, coords.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1, 10, 0)
    Citizen.Wait(100)
    PlaySoundFromCoord(sid, "Beep_Red", coords.x, coords.y, coords.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1, 10, 0)
    Citizen.Wait(100)
    PlaySoundFromCoord(sid, "Beep_Green", coords.x, coords.y, coords.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1, 10, 0)
    Citizen.Wait(100)
    PlaySoundFromCoord(sid, "Beep_Red", coords.x, coords.y, coords.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1, 10, 0)
    Citizen.Wait(100)
    ReleaseSoundId(sid)
end

RegisterNetEvent('ANRP-finger:client:showComputer')
AddEventHandler('ANRP-finger:client:showComputer', function(data, id)
    computerData = data
    SetNuiFocus(true, true)
    if id ~= PlayerPedId() then
        SendNUIMessage({
            action = "computer",
            details = data
        })
    end
end)

RegisterNUICallback('computer-exit', function()
    SetNuiFocus(false, false)
end)

Citizen.CreateThread(function()
    local wait1 = 1
    while true do
        Citizen.Wait(wait1)
        if not inScanner then
            local PedCoords = GetEntityCoords(PlayerPedId())
            wait1 = 1000
            for k, v in pairs(Config.Zones) do
                local dist = GetDistanceBetweenCoords(PedCoords, v.Scanner.x, v.Scanner.y, v.Scanner.z, true)
                if dist < 2 then
                    DrawText3D(v.Scanner.x, v.Scanner.y, v.Scanner.z, '~b~[~w~E~b~]~w~ Usar o Scanner')
                    wait1 = 1
                    if IsControlJustPressed(0, Keys["E"]) then
                        openScanner(true)
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
