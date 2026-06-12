ESX = nil

local shots = {}
local blood = {}

TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

-- FIX (2026-06-12): só polícia pode gerir/apagar provas. Antes qualquer
-- jogador limpava a cena de crime ou apagava o storage de provas.
local policeJobs = { police=true, sheriff=true, state=true, municipal=true, ranger=true, pj=true }
local function isCop(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    return xPlayer ~= nil and xPlayer.job ~= nil and policeJobs[xPlayer.job.name] == true
end

ESX.RegisterServerCallback(
    "core_evidence:getData",
    function(source, cb)
        cb({shots = shots, blood = blood, time = os.time()})
    end
)

ESX.RegisterServerCallback(
    "core_evidence:getStorageData",
    function(source, cb)
        MySQL.Async.fetchAll(
            "SELECT * FROM `evidence_storage` WHERE 1",
            {},
            function(reports)
                cb(reports)
            end
        )
    end
)

RegisterServerEvent("core_evidence:deleteEvidenceFromStorage")
AddEventHandler(
    "core_evidence:deleteEvidenceFromStorage",
    function(id)
        if not isCop(source) then return end
        MySQL.Sync.execute(
            "DELETE FROM `evidence_storage` WHERE id = @id",
            {
                ["@id"] = id
            }
        )
    end
)

RegisterServerEvent("core_evidence:addEvidenceToStorage")
AddEventHandler(
    "core_evidence:addEvidenceToStorage",
    function(evidence)
        if not isCop(source) then return end
        MySQL.Sync.execute(
            "INSERT INTO `evidence_storage`(`data`) VALUES (@evidence)",
            {
                ["@evidence"] = evidence
            }
        )
    end
)

RegisterServerEvent("core_evidence:removeEverything")
AddEventHandler(
    "core_evidence:removeEverything",
    function()
        if not isCop(source) then return end
        for k, v in pairs(blood) do
            if v.interior == 0 then
                blood[k] = nil
            end
        end
        for k, v in pairs(shots) do
            if v.interior == 0 then
                shots[k] = nil
            end
        end
    end
)

RegisterServerEvent("core_evidence:removeBlood")
AddEventHandler(
    "core_evidence:removeBlood",
    function(identifier)
        if not isCop(source) then return end
        blood[identifier] = nil
    end
)

RegisterServerEvent("core_evidence:removeShot")
AddEventHandler(
    "core_evidence:removeShot",
    function(identifier)
        if not isCop(source) then return end
        shots[identifier] = nil
    end
)

RegisterServerEvent("core_evidence:LastInCar")
AddEventHandler(
    "core_evidence:LastInCar",
    function(id)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(id)
        local xPlayer = ESX.GetPlayerFromId(NetworkGetEntityOwner(entity))

        if xPlayer ~= nil then
            if NetworkGetEntityOwner(entity) ~= src then
                MySQL.Async.fetchAll(
                    "SELECT " ..
                        Config.EvidenceReportInformationFingerprint .. " FROM `users` WHERE identifier = @owner LIMIT 1",
                    {
                        ["@owner"] = xPlayer.identifier
                    },
                    function(reportInfo)
                        TriggerClientEvent("core_evidence:addFingerPrint", src, reportInfo[1])
                    end
                )
            else
                TriggerClientEvent("core_evidence:SendTextMessage", src, Config.Text["no_fingerprints_found"])
            end
        else
            TriggerClientEvent("core_evidence:SendTextMessage", src, Config.Text["no_fingerprints_found"])
        end
    end
)

RegisterServerEvent("core_evidence:saveBlood")
AddEventHandler(
    "core_evidence:saveBlood",
    function(coords, interior)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        MySQL.Async.fetchAll(
            "SELECT " .. Config.EvidenceReportInformationBlood .. " FROM `users` WHERE identifier = @owner LIMIT 1",
            {
                ["@owner"] = xPlayer.identifier
            },
            function(reportInfo)
                local time = os.time()
                blood[time] = {coords = coords, reportInfo = reportInfo[1], interior = interior}
            end
        )
    end
)

ESX.RegisterUsableItem(
    "uvlight",
    function(playerId)
        TriggerClientEvent("core_evidence:checkForFingerprints", playerId)
    end
)

RegisterServerEvent("core_evidence:saveShot")
AddEventHandler(
    "core_evidence:saveShot",
    function(coords, bullet, interior)
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        MySQL.Async.fetchAll(
            "SELECT " .. Config.EvidenceReportInformationBullet .. " FROM `users` WHERE identifier = @owner LIMIT 1",
            {
                ["@owner"] = xPlayer.identifier
            },
            function(reportInfo)
                local time = os.time()
                shots[time] = {coords = coords, bullet = bullet, reportInfo = reportInfo[1], interior = interior}
            end
        )
    end
)
