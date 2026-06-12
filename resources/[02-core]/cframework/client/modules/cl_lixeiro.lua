local PlayerData = {}
local createdMarkers = {}
local created = false
local CurrentAction = nil

local cachedBins = {}
local cachedEntityBins = {}
local canWorkGarbage = false
local truckTaken = false
local reciclingActive = false
local recicling = 1000

local cloakRoomLocation = {
    {x = -321.70, y = -1545.94, z = 31.02},
}

local vehicleSpawnLocation = {
    {x = -316.2, y = -1537.27, z = 27.66, h = 339.69},
}

local vehicleDeleteLocation = {
    {x = -330.43, y = -1522.88, z = 27.54},
}

local trashSellLocation = {
   -- {x = 109.52, y = -1594.95, z = 29.89},
}

local reciclingLocation = {
    {x = -618.18, y = -1628.71, z = 33.03},
}

local garbageBlips = {
    {title = "Vestuário Lixeiro", colour = 5, id = 280, x = -321.70, y = -1545.94, z = 31.02, scale = 0.5},
    {title = "Venda de lixo",  colour = 25, id = 500, x =   64.49, y = -1590.37, z = 29.60, scale = 0.8},
    {title = "Reciclagem", colour = 69, id = 171, x = -616.83, y = -1620.58, z = 33.01, scale = 0.5},  
}

local dumpsters = {
    `prop_bin_01a`,
    `prop_bin_02a`,
    `prop_bin_03a`,
    `prop_bin_04a`,
    `prop_bin_05a`,
    `prop_bin_06a`,
    `prop_bin_07a`,
    `prop_bin_07b`,
    `prop_bin_07c`,
    `prop_bin_07d`,
    `prop_bin_08a`,
    `prop_bin_09a`,
    `prop_bin_08open`,
    `zprop_bin_01a_old`,
    `prop_dumpster_01a`,
    `prop_dumpster_02a`,
    `prop_dumpster_02b`,
    `prop_dumpster_03a`,
    `prop_dumpster_04a`,
    `prop_dumpster_04b`,
    `prop_skip_01a`,
    `prop_skip_02a`,
    `prop_skip_06a`,
    `prop_skip_05a`,
    `prop_skip_03`,
    `prop_skip_10a`,
}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    removeGarbageMarkers()
    createGarbageMarkers()
end)


RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeGarbageMarkers()
    createGarbageMarkers()
end)


RegisterNetEvent('garbageEnteredMarker', function(action)
    CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'cloakroom' then
                CurrentAction = nil
                garbageCloakroom()
            end

            if CurrentAction == 'selling' then
                CurrentAction = nil
                RPC.execute('sellGarbage')
            end

            if CurrentAction == 'spawner' and canWorkGarbage then
                CurrentAction = nil
                garbageSpawner()
            end

            if CurrentAction == 'deleter' and canWorkGarbage then
                CurrentAction = nil
                garbageDeleter()
            end

            if CurrentAction == 'recicling' and canWorkGarbage then
                CurrentAction = nil
                reciclingActive = true
                garbageRecicling()
            end

            ::final::
        end
    end)
end)

RegisterNetEvent("garbageFail", function()
    local ped = PlayerPedId()
    reciclingActive = false
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end)


RegisterNetEvent('garbageExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Enter / Exit marker events
function createGarbageMarkers()
    if PlayerData.job == nil or PlayerData.job.name ~= 'lixeiro' then 
        return 
    end

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("garbage_cloakroom" .. i, {type = 50, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("garbage_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "garbageEnteredMarker"}, exit = {eventClient = "garbageExitedMarker"}, data = 'cloakroom'})
        table.insert(createdMarkers, "garbage_cloakroom" .. i)
    end

    for i=1, #vehicleSpawnLocation, 1 do
        exports.ft_libs:AddMarker("garbage_spawner" .. i, {type = 50, x = vehicleSpawnLocation[i].x, y = vehicleSpawnLocation[i].y, z = vehicleSpawnLocation[i].z, red = 0, green = 255, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("garbage_spawner" .. i, {x = vehicleSpawnLocation[i].x, y = vehicleSpawnLocation[i].y, z = vehicleSpawnLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "garbageEnteredMarker"}, exit = {eventClient = "garbageExitedMarker"}, data = 'spawner'})
        table.insert(createdMarkers, "garbage_spawner" .. i)
    end

    for i=1, #vehicleDeleteLocation, 1 do
        exports.ft_libs:AddMarker("garbage_deleter" .. i, {type = 50, x = vehicleDeleteLocation[i].x, y = vehicleDeleteLocation[i].y, z = vehicleDeleteLocation[i].z, red = 255, green = 0, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("garbage_deleter" .. i, {x = vehicleDeleteLocation[i].x, y = vehicleDeleteLocation[i].y, z = vehicleDeleteLocation[i].z, weight = 2, height = 5,
        enter = {eventClient = "garbageEnteredMarker"}, exit = {eventClient = "garbageExitedMarker"}, data = 'deleter'})
        table.insert(createdMarkers, "garbage_deleter" .. i)
    end

    for i=1, #trashSellLocation, 1 do
        exports.ft_libs:AddMarker("garbage_selling" .. i, {type = 50, x = trashSellLocation[i].x, y = trashSellLocation[i].y, z = trashSellLocation[i].z, red = 255, green = 128, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("garbage_selling" .. i, {x = trashSellLocation[i].x, y = trashSellLocation[i].y, z = trashSellLocation[i].z, weight = 2, height = 5,
        enter = {eventClient = "garbageEnteredMarker"}, exit = {eventClient = "garbageExitedMarker"}, data = 'selling'})
        table.insert(createdMarkers, "garbage_selling" .. i)
    end

    for i=1, #reciclingLocation, 1 do
        exports.ft_libs:AddMarker("garbage_recicling" .. i, {type = 50, x = reciclingLocation[i].x, y = reciclingLocation[i].y, z = reciclingLocation[i].z, red = 255, green = 128, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("garbage_recicling" .. i, {x = reciclingLocation[i].x, y = reciclingLocation[i].y, z = reciclingLocation[i].z, weight = 2, height = 5,
        enter = {eventClient = "garbageEnteredMarker"}, exit = {eventClient = "garbageExitedMarker"}, data = 'recicling'})
        table.insert(createdMarkers, "garbage_recicling" .. i)
    end


    for _, info in pairs(garbageBlips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(info.title)
        EndTextCommandSetBlipName(info.blip)
    end

    created = true
end


function removeGarbageMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end
    createdMarkers = {}

    if not created then
        return
    end

    for i, blip in pairs(garbageBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end


function garbageCloakroom()
    local elements = {
        {label = '🧥 Roupas de civil',         value = 'cloakroom1'},
        {label = '👔 Roupa de trabalho',       value = 'cloakroom2'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, 'Lixeiro', function(value)
        if value == 'cloakroom1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            canWorkGarbage = false
            TriggerEvent('cframework:enableSearchTrash')
        end

        if value == 'cloakroom2' and not canWorkGarbage then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
            canWorkGarbage = true
            TriggerEvent('cframework:disableSearchTrash')

            ESX.ShowNotification('Podes usar o F6 para procurar novamente o caixote mais perto.', 'inform')

            findClosestTrashbin()
            isCollectingTrash = false
        end
    end)
end


function garbageSpawner()
    if not ESX.Game.IsSpawnPointClear(vehicleSpawnLocation[1], 5) then ESX.ShowNotification('Já há veículos na área.', 'error')
        return
    end

    if truckTaken then ESX.ShowNotification('Já tiraste um camião.', 'error')
        return
    end

    truckTaken = true

    TriggerServerEvent("cframework:getTrashVehicle")
end


function garbageDeleter()
    if not truckTaken then ESX.ShowNotification('Não tiraste nenhum camião.', 'error')
        return
    end

    TriggerEvent('esx:deleteVehicle')

    truckTaken = false
end

function garbageRecicling()
    Citizen.CreateThread(function()
        local success = false
        if reciclingActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        while reciclingActive do
            success = RPC.execute("garbageRecicling", 'old_plastic')

            if not success then
                TriggerEvent("garbageFail")
            end

            Citizen.Wait(recicling)
        end
    end)
    Citizen.CreateThread(function()
        Citizen.Wait(500)
        while reciclingActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para parar de reciclar.")

            if IsControlJustReleased(1, 51) then
                TriggerEvent('garbageFail')
            end
        end
    end)
end

local isCollectingTrash = false

function findClosestTrashbin()
    if isCollectingTrash then return end

    isCollectingTrash = true

    local playerPed = PlayerPedId()
    local entity, entityDst = ESX.Game.GetClosestObject(dumpsters)

    local inCooldown = true

    while entityDst > 50.0 or entityDst < 0 or inCooldown or cachedEntityBins[entity] do
        local currentTime, trashPos = GetGameTimer(), GetEntityCoords(entity)

        inCooldown = false

        for k,v in pairs(cachedBins) do
            if #(v.pos - trashPos) < 0.1 then
                if v.cooldown >= currentTime then
                    inCooldown = true
                end
            end

            if v.cooldown < currentTime then table.remove(cachedBins, k) end
        end

        if not canWorkGarbage then return end
        Citizen.Wait(500)
        entity, entityDst = ESX.Game.GetClosestObject(dumpsters)
    end

    if not HasAnimDictLoaded("anim@heists@narcotics@trash") then
        RequestAnimDict("anim@heists@narcotics@trash")
    end

    while not HasAnimDictLoaded("anim@heists@narcotics@trash") do
        Citizen.Wait(0)
    end

    local dumpCoords = GetEntityCoords(entity)
    local jobBlip = AddBlipForCoord(dumpCoords)
    SetBlipSprite(jobBlip, 420)
    SetBlipScale (jobBlip, 0.5)
    SetBlipColour(jobBlip, 25)

    while canWorkGarbage do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local userDist = #(dumpCoords - GetEntityCoords(playerPed))

        if IsControlJustReleased(1,167) then
            RemoveBlip(jobBlip)

            entity, entityDst = ESX.Game.GetClosestObject(dumpsters)

            inCooldown = true

            while entityDst > 50.0 or entityDst < 0 or inCooldown or cachedEntityBins[entity] do
                local currentTime, trashPos = GetGameTimer(), GetEntityCoords(entity)

                inCooldown = false

                for k,v in pairs(cachedBins) do
                    if #(v.pos - trashPos) < 0.1 then
                        if v.cooldown >= currentTime then
                            inCooldown = true
                        end
                    end

                    if v.cooldown < currentTime then table.remove(cachedBins, k) end
                end

                if not canWorkGarbage then return end
                Citizen.Wait(500)
                entity, entityDst = ESX.Game.GetClosestObject(dumpsters)
            end

            dumpCoords = GetEntityCoords(entity)
            jobBlip = AddBlipForCoord(dumpCoords)
            SetBlipSprite(jobBlip, 420)
            SetBlipScale (jobBlip, 0.5)
            SetBlipColour(jobBlip, 25)
        end

        if userDist > 20.0 then
            goto jump
        end

        DrawMarker(2, dumpCoords + vector3(0.0, 0.0, 2.5), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)

        if userDist > 3.0 then
            goto jump
        end

        ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para apanhar lixo", true, true, 5000)

        if IsControlJustReleased(1,46) then
            local closestVehicle, closestDistance = ESX.Game.GetClosestEntity(ESX.Game.GetVehicles(), false, GetEntityCoords(playerPed), {[GetHashKey('trash')] = true})

            if closestVehicle == -1 or closestDistance > 20.0 then ESX.ShowNotification('Precisas de estar perto de um camião do lixo.', 'error')
                goto jump
            end

            table.insert(cachedBins, {pos = GetEntityCoords(entity), cooldown = GetGameTimer() + 3600000})
            cachedEntityBins[entity] = true

            TriggerServerEvent("cframework:pickupTrash", GetEntityCoords(entity))
            TriggerEvent("attachItem", "trashbag1")
            TaskPlayAnim(playerPed, 'anim@heists@narcotics@trash', 'walk', 1.0, -1.0,-1,49,0,0, 0,0)
            RemoveBlip(jobBlip)
            return colectTrash(closestVehicle)
        end

        ::jump::
    end

    RemoveBlip(jobBlip)
end


function colectTrash(vehicle)
    while true do
        local trunkcoord = vector3(0.0, 0.0, 0.0)
        local tdistance = 10000.0

        if not DoesEntityExist(vehicle) then
            isCollectingTrash = false
            ClearPedTasksImmediately(PlayerPedId())
            TriggerEvent("destroyProp")
            ESX.ShowNotification('O camião foi destruído ou perdido.', 'error')
            return findClosestTrashbin()
        end

        trunkcoord = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "platelight"))
        tdistance = #(GetEntityCoords(PlayerPedId()) - trunkcoord)

        if not canWorkGarbage then return end

        if tdistance > 20.0 then
            goto jump_colect
        end

        DrawMarker(20, trunkcoord + vector3(0.0,0.0,0.5), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 120, 0, 200, false, true, 2, false, false, false, false)

        if tdistance > 2.0 then
            goto jump_colect
        end

        ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para despejar o lixo", true, true, 5000)
        if IsControlJustReleased(1, 46) then
            ClearPedTasksImmediately(PlayerPedId())
            TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', 'throw_b', 1.0, -1.0, -1, 2, 0, false, false, false)
            Citizen.Wait(700)
            TriggerEvent("destroyProp")
            Citizen.Wait(2300)
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent("cframework:colectTrash")
            isCollectingTrash = false
            return findClosestTrashbin()
        end

        ::jump_colect::

        Citizen.Wait(0)
    end
end
