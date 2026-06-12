

local frostData = LoadFrostZones()

local frostLevel = 0
local lastUpdate = GetGameTimer()
local inZone = false
local currentZone = nil
local lastDamageAt = 0

local MAX_FROST <const> = 100
local DEFAULT_CHILL_RATE <const> = 8
local DEFAULT_RECOVER_RATE <const> = 6
local DAMAGE_INTERVAL_MS <const> = 5000
local DAMAGE_AMOUNT <const> = 6

local frostZones = frostData.zones
local protectiveOutfits = frostData.protectiveOutfits

local cachedSkin = nil

local function refreshCachedSkin()
    TriggerEvent('skinchanger:getSkin', function(skin)
        cachedSkin = skin
    end)
end

local function setFrostUI(value)
    SendNUIMessage({
        action = 'setFrost',
        value = value
    })
end

local function valueInArray(val, arr)
    if type(arr) ~= "table" then return false end
    for _, v in ipairs(arr) do
        if tostring(v) == tostring(val) then
            return true
        end
    end
    return false
end

local function isWearingProtectiveOutfit()
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then return false end

    if ESX.inAdminMode() then
        return true
    end

    refreshCachedSkin()
    local skin <const> = cachedSkin
    if not skin or type(protectiveOutfits) ~= "table" then return false end

    local sex <const> = (skin.sex == 0) and "male" or "female"

    if type(protectiveOutfits[sex]) ~= "table" then
        return false
    end

    local firstKey = next(protectiveOutfits[sex])
    if firstKey == nil then return false end

    -- for each configured key (eg 'tshirt_1', 'torso_1'), require at least one allowed value to match
    for key, allowed in pairs(protectiveOutfits[sex]) do
        if type(key) ~= "string" or type(allowed) ~= "table" then
            return false
        end

        local cur = skin[key]
        if cur == nil then
            return false
        end

        if not valueInArray(cur, allowed) then
            return false
        end
    end

    return true
end

local function isInsideZone(coords, zone)
    local dx <const> = coords.x - zone.x
    local dy <const> = coords.y - zone.y
    local dz <const> = coords.z - zone.z
    local dist2 <const> = dx * dx + dy * dy + dz * dz
    return dist2 <= (zone.radius * zone.radius)
end

local function getZoneForCoords(coords)
    -- pick the zone that gives the highest chill rate (if overlapping)
    local best = nil
    local bestRate = 0
    for _, z in ipairs(frostZones) do
        if isInsideZone(coords, z) then
            local rate <const> = z.chillRate or DEFAULT_CHILL_RATE
            if rate > bestRate then
                bestRate = rate
                best = z
            end
        end
    end
    return best
end

local function applyColdDamage(amount)
    local ped <const> = PlayerPedId()
    if not DoesEntityExist(ped) then return end
    if IsEntityDead(ped) then return end

    local health <const> = GetEntityHealth(ped)
    local newHealth <const> = math.max(0, health - amount)

    if newHealth > 0 then
        SetEntityHealth(ped, newHealth)
        --ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.005)
    else
        SetEntityHealth(ped, 0)
    end
end

Citizen.CreateThread(function()
    while true do
        local now <const> = GetGameTimer()
        local dt <const> = math.max(1, now - lastUpdate) / 1000.0 -- seconds
        lastUpdate = now

        local ped <const> = PlayerPedId()
        if not DoesEntityExist(ped) then
            Citizen.Wait(1000)
        else
            local coords <const> = GetEntityCoords(ped)
            local zone <const> = getZoneForCoords(coords)

            if zone then
                inZone = true
                currentZone = zone
            else
                inZone = false
                currentZone = nil
            end

            if inZone and currentZone then
                if isWearingProtectiveOutfit() then
                    local recoverProtected = (DEFAULT_RECOVER_RATE * 1.5) * dt
                    frostLevel = math.max(0, frostLevel - recoverProtected)
                else
                    local chill <const> = (currentZone.chillRate or DEFAULT_CHILL_RATE) * dt
                    frostLevel = math.min(MAX_FROST, frostLevel + chill)
                end
            else
                local recover <const> = DEFAULT_RECOVER_RATE * dt
                frostLevel = math.max(0, frostLevel - recover)
            end

            setFrostUI(frostLevel / MAX_FROST)

            if frostLevel >= MAX_FROST then
                if (now - lastDamageAt) >= DAMAGE_INTERVAL_MS then
                    lastDamageAt = now
                    applyColdDamage(DAMAGE_AMOUNT)
                end
            end

            Citizen.Wait(1000)
        end
    end
end)
