ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
RegisteredSprays = {}
local Framework

-- ─────────────────────────────────────────
--  Persistência JSON
-- ─────────────────────────────────────────
local SAVE_FILE = "posters_data.json"

local function SavePosters()
    local data = json.encode(RegisteredSprays, { indent = true })
    SaveResourceFile(GetCurrentResourceName(), SAVE_FILE, data, -1)
end

local function LoadPosters()
    local raw = LoadResourceFile(GetCurrentResourceName(), SAVE_FILE)
    if raw and raw ~= "" then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == "table" then
            RegisteredSprays = decoded
            print(string.format("^2[Posters]^7 Loaded %d poster(s) from %s", #RegisteredSprays, SAVE_FILE))
        else
            print("^1[Posters]^7 Failed to parse " .. SAVE_FILE .. " – starting fresh.")
        end
    else
        print("^3[Posters]^7 No save file found – starting fresh.")
    end
end

-- Carrega os posters assim que o recurso arranca
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        LoadPosters()
    end
end)

-- ─────────────────────────────────────────
--  Framework
-- ─────────────────────────────────────────
if Config.Framework == "qb-core" then
    Framework = exports['qb-core']:GetCoreObject()
    Framework.Functions.CreateUseableItem('poster', function(source, item)
        TriggerClientEvent("posters:placeImage", source)
    end)
elseif Config.Framework == "ESX" then
    Framework = exports["cframework"]:getSharedObject()
    Framework.RegisterUsableItem('poster', function(source)
        TriggerClientEvent("posters:placeImage", source)
    end)
end

-- ─────────────────────────────────────────
--  Eventos de rede
-- ─────────────────────────────────────────
RegisterNetEvent("posters:addNewImage", function(data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or type(data) ~= "table" then return end
    -- FIX C21 (2026-06-12): id/cid gerados SERVER-SIDE (dono real); url validada;
    -- exige possuir o item antes de colar. Antes o cliente controlava cid/id/url
    -- e o item nem sempre era consumido → dupe + impersonação + content-injection.
    if type(data.url) ~= "string" or not data.url:match("^https?://") or #data.url > 512 then return end
    local item = xPlayer.getInventoryItem("poster")
    if not item or item.count < 1 then return end

    data.id = ("%d-%d"):format(GetGameTimer(), math.random(100000, 999999))
    data.cid = xPlayer.identifier

    RegisteredSprays[#RegisteredSprays+1] = data
    SavePosters()
    TriggerClientEvent("posters:sendAddedImage", -1, data)
    xPlayer.removeInventoryItem("poster", 1)
end)

lib.callback.register('posters:getImages', function(source)
    return RegisteredSprays
end)

RegisterNetEvent("posters:deleteImage", function(id)
    -- FIX C21 (2026-06-12): `isOwner` deixou de vir do cliente (dava poster grátis
    -- a cada delete). A posse é calculada server-side (cid == identifier) e só o
    -- dono pode apagar + receber o refund.
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    for k, v in pairs(RegisteredSprays) do
        if v.id == id then
            if v.cid ~= xPlayer.identifier then return end
            table.remove(RegisteredSprays, k)
            SavePosters()
            TriggerClientEvent("posters:deleteClientImage", -1, id)
            xPlayer.addInventoryItem("poster", 1)
            return
        end
    end
end)

RegisterCommand("removeposter", function(source, args, raw)
    TriggerClientEvent("posters:removePoster", source)
end)