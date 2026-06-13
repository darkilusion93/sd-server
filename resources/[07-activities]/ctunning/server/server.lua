ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)


RegisterServerEvent('ctunning:applyMods', function(price, id, vehprops)
    local source = source
    -- FIX C15 (2026-06-12): os guards estavam TODOS comentados e price/vehprops
    -- vinham do cliente → price=0 dava mods grátis, negativo creditava a sociedade.
    -- Agora: price inteiro>0, vehprops tem de ser tabela, e exige job (gasta da
    -- conta da sociedade do próprio). TODO: preço por mod server-side +
    -- validar dono do veículo + proximidade à oficina.
    price = math.floor(tonumber(price) or 0)
    if price <= 0 or type(vehprops) ~= "table" then
        TriggerClientEvent("ctunning:modSuccess", source, false)
        return
    end
    local job = ESX.getJob(source)
    if not job or job.name == 'unemployed' then
        TriggerClientEvent("ctunning:modSuccess", source, false)
        return
    end

    -- FIX (2026-06-13): a matrícula tem de ser de um veículo real (owned_vehicles).
    -- Antes, vehprops vinha do cliente e ESX.updateVehicleProps gravava em QUALQUER
    -- matrícula → permitia injetar props (sabotar/alterar) o veículo guardado de
    -- terceiros pela placa, ou cobrar por um veículo fantasma.
    -- TODO: preço por mod server-side (de Config.TunningPrices) + proximidade à oficina.
    local plate = type(vehprops.plate) == "string" and vehprops.plate or nil
    if not plate or plate == "" then
        TriggerClientEvent("ctunning:modSuccess", source, false)
        return
    end

    local owned = MySQL.Sync.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate LIMIT 1', { ['@plate'] = plate })
    if not owned or owned[1] == nil then
        TriggerClientEvent("ctunning:modSuccess", source, false)
        return
    end

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..job.name, function(account)
            if account.money < price then TriggerClientEvent("ctunning:modSuccess", source, false) return end

            account.removeMoney(price)
            ESX.updateVehicleProps(vehprops)

            TriggerClientEvent("ctunning:modSuccess", source, true)
        end)
    --else
    --    if ESX.getAccount(source, "bank").money < price then TriggerClientEvent("gtunning:modSuccess", source, false) return end

    --    ESX.removeAccountMoney(source, "bank", price)
    --    ESX.updateVehicleProps(vehprops)

     --   TriggerClientEvent("gtunning:modSuccess", source, true)
    --end
end)
