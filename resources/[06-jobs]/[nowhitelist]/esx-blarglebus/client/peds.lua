Peds = {}
Peds.modelsHashUsedByPedCount = {}

function Peds.CreateRandomPedInArea(coords)
    local modelName = Peds.LoadModel(Peds.RandomlySelectModel())

    local x = coords.x + math.random() * 4 - 2
    local y = coords.y + math.random() * 4 - 2
    local heading = math.random() * 360
    
    local ped = CreatePed(4, modelName, x, y, coords.z, heading, true, false)
    Peds.WanderInArea(ped, coords)
    Peds.incrementModelsHashUsedByPedCount(modelName)
    return ped
end

function Peds.LeaveVehicle(ped, vehicle)
    if IsPedDeadOrDying(ped) then
        RemovePedElegantly(ped)
    else
        ClearPedTasksImmediately(ped, true)
        TaskLeaveVehicle(ped, vehicle, 0) -- flag 0: sai e fica livre para novas tasks
    end
end

-- Após sair do autocarro, manda o ped andar para o passeio/zona da paragem
-- Espera até ter saído do veículo (ou timeout) e depois dá-lhe destino aleatório
function Peds.WalkAwayAfterLeaving(ped, stopCoords)
    Citizen.CreateThread(function()
        -- Aguardar até sair do veículo (máx ~3s)
        local waited = 0
        while IsPedInAnyVehicle(ped, false) and waited < 3000 do
            Citizen.Wait(100)
            waited = waited + 100
        end

        if not DoesEntityExist(ped) or IsPedDeadOrDying(ped) then return end

        -- Escolher ponto aleatório num raio de 15-30m à volta da paragem
        -- para simular passageiro a afastar-se para o passeio
        local angle  = math.random() * 2 * math.pi
        local radius = 15.0 + math.random() * 15.0
        local tx = stopCoords.x + math.cos(angle) * radius
        local ty = stopCoords.y + math.sin(angle) * radius

        TaskGoStraightToCoord(ped, tx, ty, stopCoords.z, 1.0, -1, 0.0, 0.1)
    end)
end

function Peds.WanderInArea(ped, stopCoords)
    TaskWanderInArea(ped, 
        stopCoords.x,
        stopCoords.y,
        stopCoords.z,
        Config.Markers.Size / 2.0, -- radius
        Config.Markers.Size / 2.0, -- minimalLength
        5000                       -- timeBetweenWalks
    )
end

function Peds.EnterVehicle(ped, vehicle, seatNumber)
    Citizen.Wait(10)
    TaskEnterVehicle(ped, 
        vehicle, 
        Config.EnterVehicleTimeout, -- timeout
        seatNumber,                 -- seat
        1.0,                        -- speed (walk)
        1,                          -- flag, normal
        0                           -- p6? lol
    )
end

function Peds.IsPedInVehicleOrDead(ped, position)
    return GetVehiclePedIsIn(ped, false) or IsPedDeadOrDying(ped, 1)
end

function Peds.IsPedInVehicleDeadOrTooFarAway(ped, position)
    if IsPedInAnyVehicle(ped, false) or IsPedDeadOrDying(ped, 1) then
        return true
    end

    return GetDistanceBetweenCoords(GetEntityCoords(ped), position.x, position.y, position.z) > 15
end

function Peds.LoadModel(modelName)
    local loadAttempts = 0
    local hashKey = GetHashKey(modelName)

    RequestModel(hashKey)
    while not HasModelLoaded(hashKey) and loadAttempts < 10 do
        loadAttempts = loadAttempts + 1
        Citizen.Wait(50)
    end

    if loadAttempts == 10 then
        Log.debug('MODEL NOT LOADED AFTER TEN ATTEMPTS: ' .. modelName)
        return Peds.LoadModel(Peds.RandomlySelectModel())
    end

    Log.debug('Successfully loaded model: ' .. modelName)
    return modelName
end

function Peds.DeletePeds(pedList)
    while #pedList > 0 do
        Peds.DeletePed(table.remove(pedList))
        Citizen.Wait(10)
    end
end

function Peds.DeletePed(ped)
    Peds.HandleUnloadingModelIfNeeded(ped)
    SetEntityAsNoLongerNeeded(ped)
    DeletePed(ped)
end

function Peds.RandomlySelectModel()
    return Config.PedModels[math.random(#Config.PedModels)]
end

function Peds.WalkPedsToLocation(peds, coords)
    for i = 1, #peds do
        TaskGoToCoordAnyMeans(peds[i], coords.x, coords.y, coords.z, 1.0, 0, 0, 786603, 0.0);
    end
end

function Peds.incrementModelsHashUsedByPedCount(modelName)
    local hashKey = GetHashKey(modelName)

    local value = Peds.modelsHashUsedByPedCount[hashKey]
    if value == nil then value = 0 end

    Peds.modelsHashUsedByPedCount[hashKey] = value + 1
end

function Peds.decrementModelsHashUsedByPedCount(hashKey)
    local value = Peds.modelsHashUsedByPedCount[hashKey]
    if value == nil then value = 1 end

    Peds.modelsHashUsedByPedCount[hashKey] = value - 1
end

function Peds.HandleUnloadingModelIfNeeded(pedToDelete)
    local hashKey = GetEntityModel(pedToDelete)
    Peds.decrementModelsHashUsedByPedCount(hashKey)
    if Peds.modelsHashUsedByPedCount[hashKey] <= 0 then
        SetModelAsNoLongerNeeded(hashKey)
    end
end