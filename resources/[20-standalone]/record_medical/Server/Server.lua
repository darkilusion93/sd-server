-- FIX C18 (2026-06-12): este recurso não tinha QUALQUER autorização — qualquer
-- jogador lia/inseria/apagava registos médicos. Adicionado ESX + gate de job médico.
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local medJobs = { ambulance = true, medic = true }
local function isMedic(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer ~= nil and xPlayer.job ~= nil and medJobs[xPlayer.job.name] == true
end

-- This is the command that will open the medical record
RegisterCommand('record', function(source, args)
    local idJ = source
    if not isMedic(idJ) then return end

    MySQL.Async.fetchAll('SELECT COUNT(id) AS consultations FROM medical_record',
    {},
    function(result)
        TriggerClientEvent('lg:openRecord', idJ, result[1])
    end)
end)

-- Create Table
CreateThread(function()
    MySQL.Async.execute('CREATE TABLE IF NOT EXISTS medical_record(id int AUTO_INCREMENT, id_user int, name_user varchar(100), reason varchar(200), description varchar(200), PRIMARY KEY(id))', {}, function()
    end)
end)

RegisterNetEvent("lg:registerConsult")
AddEventHandler("lg:registerConsult", function(data)
    if not isMedic(source) then return end
    MySQL.Async.execute('INSERT INTO medical_record(id_user, name_user, reason, description) VALUES (@id_user, @name_user, @reason, @description)',
    {
        ['@id_user'] = data.id_user,
        ['@name_user'] = data.name_user,
        ['@reason'] = data.reason,
        ['@description'] = data.description
    },
    function()

    end)
end)

RegisterNetEvent("lg:deleteConsult")
AddEventHandler("lg:deleteConsult", function(data)
    if not isMedic(source) then return end
    MySQL.Async.execute('DELETE FROM medical_record WHERE id = @id',
    {
        ['@id'] = data.item.id
    },
    function()

    end)
end)

RegisterNetEvent("lg:getAllConsultations")
AddEventHandler("lg:getAllConsultations", function()
    local idJ = source
    if not isMedic(idJ) then return end

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record GROUP BY id_user',
    {},
    function(result)
        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getIdConsultations")
AddEventHandler("lg:getIdConsultations", function(value)
    local idJ = source
    if not isMedic(idJ) then return end

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record WHERE id_user = @id_user GROUP BY id_user',
    {
        ['@id_user'] = value
    },
    function(result)

        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getNameConsultations")
AddEventHandler("lg:getNameConsultations", function(value)
    local idJ = source
    if not isMedic(idJ) then return end

    MySQL.Async.fetchAll('SELECT *, COUNT(id_user) AS consultations FROM medical_record WHERE name_user = @name_user GROUP BY id_user',
    {
        ['@name_user'] = value
    },
    function(result)
        TriggerClientEvent("lg:getConsultations", idJ, result)
    end)
end)

RegisterNetEvent("lg:getPacient")
AddEventHandler("lg:getPacient", function(data)
    local idJ = source
    if not isMedic(idJ) then return end

    MySQL.Async.fetchAll('SELECT * FROM medical_record WHERE id_user = @id_user',
    {
        ['@id_user'] = data.id_user
    },
    function(result)
        TriggerClientEvent("lg:getPacient", idJ, result)
    end)
end)
