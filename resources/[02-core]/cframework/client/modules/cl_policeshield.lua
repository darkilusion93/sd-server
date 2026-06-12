

local shieldActive = false
--local shieldEntity = 0

local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

--local prop = `prop_ballistic_shield`
--local pistol = GetHashKey("WEAPON_PISTOL")
--local hadPistol = false

local function tryToLoadAnim()
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end
    end
end

local function createShieldAnimLoop()
    Citizen.CreateThread(function()
        while shieldActive do
            local ped <const> = PlayerPedId()

            if not IsEntityPlayingAnim(ped, animDict, animName, 1) then
                tryToLoadAnim()

                TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, false, false, false)
            end
            Citizen.Wait(500)
        end
    end)
end

local function enableShield()
    local ped <const> = PlayerPedId()

    shieldActive = true

    tryToLoadAnim()

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, false, false, false)

    TriggerEvent("attachItem", "shield")
    --SetWeaponAnimationOverride(ped, `Gang1H`)

    --[[if HasPedGotWeapon(ped, pistol, false) or GetSelectedPedWeapon(ped) == pistol then
        SetCurrentPedWeapon(ped, pistol, true)
        hadPistol = true
    else
        GiveWeaponToPed(ped, pistol, 300, 0, 1)
        SetCurrentPedWeapon(ped, pistol, 1)
        hadPistol = false
    end]]
    SetEnableHandcuffs(ped, true)
    createShieldAnimLoop()
end

local function disableShield()
    local ped = GetPlayerPed(-1)
    TriggerEvent("destroyProp")
    ClearPedTasksImmediately(ped)
    --SetWeaponAnimationOverride(ped, GetHashKey("Default"))

    --[[if not hadPistol then
        RemoveWeaponFromPed(ped, pistol)
    end]]
    SetEnableHandcuffs(ped, false)
    --hadPistol = false
    shieldActive = false
end

--[[
RegisterCommand("shield", function()
    if shieldActive then
        disableShield()
    else
        enableShield()
    end
end, false)
]]