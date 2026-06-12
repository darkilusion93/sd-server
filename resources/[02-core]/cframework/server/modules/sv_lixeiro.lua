local trashModel = `trash`
local trashSellLocation = {
   -- vector3(109.52, -1594.95, 29.89),  
}

local reciclingLocation = {
    vector3(-618.18, -1628.71, 33.03),
}

local vehicleSpawnLocation = {
    {x = -316.2, y = -1537.27, z = 27.66, h = 339.69},
}

local trashVehicles = {}
local usersWithTrash = {}
local trashCooldowns = {}

RegisterNetEvent("cframework:getTrashVehicle", function()
    local source = source

    if not ESX.passedCooldown(source, 5000) then
        return
    end

    local v = CreateVehicle(trashModel, vehicleSpawnLocation[1].x, vehicleSpawnLocation[1].y, vehicleSpawnLocation[1].z, vehicleSpawnLocation[1].h, true, true)

    local plate = ESX.generateRandomString()

	SetVehicleNumberPlateText(v, plate)
	ESX.setVehiclePlate(v, plate)

    TaskWarpPedIntoVehicle(GetPlayerPed(source), v, -1)

    table.insert(trashVehicles, v)
end)

RegisterNetEvent("cframework:pickupTrash", function(binCoords)
    local source <const> = source

    if not ESX.passedCooldown(source, 5000) then
        return
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - binCoords) > 4.0 then
        return
    end

    if trashCooldowns[source] == nil then
        trashCooldowns[source] = {}
    end

    local currentTime, inCooldown = os.time(), false

    for k,v in pairs(trashCooldowns[source]) do
        if #(v.pos - binCoords) < 0.1 then
            if v.cooldown >= currentTime then
                inCooldown = true
            end
        end

        if v.cooldown < currentTime then table.remove(trashCooldowns[source], k) end
    end

    if inCooldown then
        return
    end

    table.insert(trashCooldowns[source], {pos = binCoords, cooldown = os.time() + 360})
    usersWithTrash[source] = true
end)

function CollectTrash(source)
    local inventory <const> = ESX.getInvContainer(source)
    local itemType <const> = math.random(1, 100)

    -- De 1 a 94 = 94% de chance (Sai quase sempre)
    if itemType <= 94 then
        inventory.addItem("sacolixo", math.random(2, 4))
        
    -- De 95 a 97 = 3% de chance (Muito raro)
    elseif itemType <= 97 then
        inventory.addItem("broken_weapon_part", math.random(1, 3))
        
    -- De 98 a 100 = 3% de chance (Muito raro)
    elseif itemType <= 100 then
        inventory.addItem("componenteseletronicos", math.random(1, 2))
    end
end

function GenerateRandomTrash()
    local itemType = math.random(1, 100)

    -- De 1 a 94 = 94% de chance (Sai quase sempre)
    if itemType <= 94 then
        return "sacolixo", math.random(2, 4)
        
    -- De 95 a 97 = 3% de chance (Muito raro)
    elseif itemType <= 97 then
        return "broken_weapon_part", math.random(1, 3)
        
    -- De 98 a 100 = 3% de chance (Muito raro)
    elseif itemType <= 100 then
        return "componenteseletronicos", math.random(1, 2)
    end
end

RegisterNetEvent("cframework:colectTrash", function()
    local source <const>, nearVehicle = source, false

    if ESX.getJob(source).name ~= 'lixeiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba novamente', nil, false) 
        return
    end

    if not usersWithTrash[source] then
        return
    end

    local playerCoords <const> = GetEntityCoords(GetPlayerPed(source))

    for _, v in pairs(trashVehicles) do
        if DoesEntityExist(v) then
            local vehicleCoords = GetEntityCoords(v)

            if #(playerCoords - vehicleCoords) < 14.0 then
                nearVehicle = true
                break
            end
        end
    end

    if not nearVehicle then
        return
    end

    usersWithTrash[source] = nil

    CollectTrash(source)
    CollectTrash(source)
    CollectTrash(source)
    CollectTrash(source)
    CollectTrash(source)
end)

RPC.register("sellGarbage", function()
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local scrap <const> = inventory.getItemAmount('scrap')
    local btel <const> = inventory.getItemAmount('btel')
    local bradio <const> = inventory.getItemAmount('bradio')
    local plasticoReciclado <const> = inventory.getItemAmount('recicled_plastic')
    local totalEarnings <const> = (scrap * 15) + (btel * 10) + (bradio * 10) + (plasticoReciclado * 15)

    if not ESX.playerInsideLocation(source, trashSellLocation, 10.0) then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba', nil, false) 
        return
    end

    if ESX.getJob(source).name ~= 'lixeiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba novamente', nil, false) 
        return
    end

    if totalEarnings == 0 then
        TriggerClientEvent('esx:showNotification', source, 'Não tens nada para vender.', 'error')
        return
    end

    if not inventory.canAddItem("cash", totalEarnings) then
        TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais dinheiro.', 'error')
        return
    end

    inventory.removeItem("scrap", scrap)
    inventory.removeItem("btel", btel)
    inventory.removeItem("bradio", bradio)
    inventory.removeItem("recicled_plastic", plasticoReciclado)
    inventory.addItem("cash", totalEarnings)
end)

RPC.register("garbageRecicling", function(type)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if not ESX.playerInsideLocation(source, reciclingLocation, 10.0) then 
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba', nil, false) 
        return 
    end

    if ESX.getJob(source).name ~= 'lixeiro' then
        --TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Não sejas pogba novamente', nil, false) 
        return 
    end

    if type == 'old_plastic' then
        if not inventory.canRemoveItem("old_plastic", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens materiais suficientes.', 'error')
            return false
        end

        if not inventory.canAddItem("recicled_plastic", 1) then TriggerClientEvent('esx:showNotification', source, 'Não tens capacidade para levar mais Plástico.', 'error')
            return false
        end

        inventory.removeItem('old_plastic', 1)
        inventory.addItem('recicled_plastic', 1)
        return true
    end
end)