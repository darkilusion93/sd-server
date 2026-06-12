ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Regista os 5 itens: tuning_chip_1 ate tuning_chip_5
-- SQL para criar os itens:
-- INSERT INTO items (name, label, weight) VALUES
--   ('tuning_chip_1','Chip Tuning N1',1),
--   ('tuning_chip_2','Chip Tuning N2',1),
--   ('tuning_chip_3','Chip Tuning N3',1),
--   ('tuning_chip_4','Chip Tuning N4',1),
--   ('tuning_chip_5','Chip Tuning N5 Anti-Lag',1);

for level = 1, 5 do
    local lvl = level
    ESX.RegisterUsableItem("tuning_chip_" .. lvl, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        xPlayer.removeInventoryItem("tuning_chip_" .. lvl, 1)
        TriggerClientEvent("tunerchip:apply", source, lvl)
        -- Guarda na DB — precisamos da placa, pedimos ao cliente
        TriggerClientEvent("tunerchip:requestSave", source, lvl)
    end)
end

-- Guarda o nivel na coluna tunerdata  (formato: {"chip":3})
RegisterNetEvent("tunerchip:save")
AddEventHandler("tunerchip:save", function(plate, level)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if type(plate) ~= "string" or plate == "" then return end
    -- FIX (2026-06-12): só o DONO do veículo (owner=identifier). Antes qualquer
    -- jogador punha chip nível máx em QUALQUER matrícula.
    local lvl = tonumber(level)
    local encoded = (lvl and lvl > 0 and lvl <= 5) and json.encode({ chip = lvl }) or ""
    MySQL.Async.execute(
        "UPDATE owned_vehicles SET tunerdata = @data WHERE plate = @plate AND owner = @owner",
        { ["@data"] = encoded, ["@plate"] = plate, ["@owner"] = xPlayer.identifier }
    )
end)

-- Callback: devolve o nivel guardado para um veiculo
ESX.RegisterServerCallback("tunerchip:getLevel", function(source, cb, plate)
    if not plate then cb(0); return end
    MySQL.Async.fetchAll(
        "SELECT tunerdata FROM owned_vehicles WHERE plate = @plate",
        { ["@plate"] = plate },
        function(rows)
            if rows and rows[1] and rows[1].tunerdata and rows[1].tunerdata ~= "" then
                local ok, data = pcall(json.decode, rows[1].tunerdata)
                if ok and data and data.chip and data.chip > 0 then
                    cb(data.chip); return
                end
            end
            cb(0)
        end
    )
end)

-- Sincroniza chamas do anti-lag para todos os clientes (igual ao bbv-antilag)
RegisterNetEvent("tunerchip:syncflames")
AddEventHandler("tunerchip:syncflames", function(netVeh, enable)
    local source = source
    if type(netVeh) ~= "number" then return end
    TriggerClientEvent("tunerchip:syncflames:client", -1, netVeh, enable)
    TriggerClientEvent("InteractSound_CL:PlayWithinDistance", -1, source, 25.0,tostring(math.random(1, 6)),0.9)
end)