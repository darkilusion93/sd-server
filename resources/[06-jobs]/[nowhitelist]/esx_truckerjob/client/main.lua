ESX = nil
local PlayerData              = {}
local alldeliveries           = {}
local randomdelivery          = 1
local isTaken                 = 0
local isDelivered             = 0
local currentZone             = ''
local LastZone                = ''
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local actualZone              = '' 
local truck                   = 0
local trailer                 = 0
local recebermoney            = false
local deliveryblip
local blackmode               = false
local bailPrice               = 5000 -- Definido numa variável para ser mais fácil alterar no futuro

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:job-blackmode3')
AddEventHandler('esx:job-blackmode3', function(mode)
	blackmode = mode
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function SpawnTruck()
    -- CORRIGIDO: Estava a chamar um callback do qb-garbagejob
    ESX.TriggerServerCallback('esx_truckerjob:hasMoney', function(HasMoney)
        if HasMoney then
            SetEntityAsNoLongerNeeded(trailer)
            ESX.Game.DeleteVehicle(trailer)
            DeleteVehicle(trailer)
            SetEntityAsNoLongerNeeded(truck)
            DeleteVehicle(truck)
            ESX.Game.DeleteVehicle(truck)
            RemoveBlip(deliveryblip)
            
            recebermoney = false
            blackmode = false
            
            local vehiclehash = GetHashKey(Config.Truck)
            RequestModel(vehiclehash)
            while not HasModelLoaded(vehiclehash) do
                RequestModel(vehiclehash)
                Citizen.Wait(0)
            end

            local ped = PlayerPedId()

            if ESX.Game.IsSpawnPointClear(Config.VehicleSpawnPoint0.Pos, 8.0) then
                truck = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint0.Pos.x, Config.VehicleSpawnPoint0.Pos.y, Config.VehicleSpawnPoint0.Pos.z, 0.0, true, false)
                SetEntityAsMissionEntity(truck, true, true) 
                
                local trailerhash = GetHashKey(Config.Trailer)
                RequestModel(trailerhash)
                while not HasModelLoaded(trailerhash) do
                    RequestModel(trailerhash)
                    Citizen.Wait(0)
                end
                
                trailer = CreateVehicle(trailerhash, Config.TrailerSpawnPoint0.Pos.x, Config.TrailerSpawnPoint0.Pos.y, Config.TrailerSpawnPoint0.Pos.z, 0.0, true, false)
                SetEntityAsMissionEntity(trailer, true, true) 
                SetVehicleFuelLevel(trailer, math.random(50, 100)) 
                
                AttachVehicleToTrailer(truck, trailer, 1.1) 
                TaskWarpPedIntoVehicle(ped, truck, -1) 
                
            elseif ESX.Game.IsSpawnPointClear(Config.VehicleSpawnPoint1.Pos, 8.0) then
                truck = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint1.Pos.x, Config.VehicleSpawnPoint1.Pos.y, Config.VehicleSpawnPoint1.Pos.z, 228.0, true, false)
                SetEntityAsMissionEntity(truck, true, true) 
                
                local trailerhash = GetHashKey(Config.Trailer)
                RequestModel(trailerhash)
                while not HasModelLoaded(trailerhash) do
                    RequestModel(trailerhash)
                    Citizen.Wait(0)
                end
                
                trailer = CreateVehicle(trailerhash, Config.TrailerSpawnPoint1.Pos.x, Config.TrailerSpawnPoint1.Pos.y, Config.TrailerSpawnPoint1.Pos.z, 180.0, true, false)
                SetEntityAsMissionEntity(trailer, true, true) 
                SetVehicleFuelLevel(trailer, math.random(50, 100)) 
                
                AttachVehicleToTrailer(truck, trailer, 1.1) 
                TaskWarpPedIntoVehicle(ped, truck, -1) 
                
            elseif ESX.Game.IsSpawnPointClear(Config.VehicleSpawnPoint2.Pos, 8.0) then
                truck = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint2.Pos.x, Config.VehicleSpawnPoint2.Pos.y, Config.VehicleSpawnPoint2.Pos.z, 127.0, true, false)
                SetEntityAsMissionEntity(truck, true, true) 
                
                local trailerhash = GetHashKey(Config.Trailer)
                RequestModel(trailerhash)
                while not HasModelLoaded(trailerhash) do
                    RequestModel(trailerhash)
                    Citizen.Wait(0)
                end
                
                trailer = CreateVehicle(trailerhash, Config.TrailerSpawnPoint2.Pos.x, Config.TrailerSpawnPoint2.Pos.y, Config.TrailerSpawnPoint2.Pos.z, 0.0, true, false)
                SetEntityAsMissionEntity(trailer, true, true) 
                SetVehicleFuelLevel(trailer, math.random(50, 100))
                
                AttachVehicleToTrailer(truck, trailer, 1.1) 
                TaskWarpPedIntoVehicle(ped, truck, -1) 
                
            elseif ESX.Game.IsSpawnPointClear(Config.VehicleSpawnPoint3.Pos, 8.0) then
                truck = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint3.Pos.x, Config.VehicleSpawnPoint3.Pos.y, Config.VehicleSpawnPoint3.Pos.z, 243.0, true, false)
                SetEntityAsMissionEntity(truck, true, true) 
                
                local trailerhash = GetHashKey(Config.Trailer)
                RequestModel(trailerhash)
                while not HasModelLoaded(trailerhash) do
                    RequestModel(trailerhash)
                    Citizen.Wait(0)
                end
                
                trailer = CreateVehicle(trailerhash, Config.TrailerSpawnPoint3.Pos.x, Config.TrailerSpawnPoint3.Pos.y, Config.TrailerSpawnPoint3.Pos.z, 243.0, true, false)
                SetEntityAsMissionEntity(trailer, true, true) 
                SetVehicleFuelLevel(trailer, math.random(50, 100))
                
                AttachVehicleToTrailer(truck, trailer, 1.1) 
                TaskWarpPedIntoVehicle(ped, truck, -1) 
            else
                ESX.ShowNotification('~r~Os pontos de spawn estão bloqueados. Chama um staff.')
                return
            end
            
            ESX.ShowNotification('~s~Foi retirada uma caução de ~g~€'..bailPrice..'. ~s~Será devolvida se o veículo retomar em condições!')
            
            local deliveryids = 1
            for k,v in pairs(Config.Delivery) do
                table.insert(alldeliveries, {
                    id = deliveryids,
                    posx = v.Pos.x,
                    posy = v.Pos.y,
                    posz = v.Pos.z,
                    payment = v.Payment,
                })
                deliveryids = deliveryids + 1  
            end
            randomdelivery = math.random(1, #alldeliveries)
            
            deliveryblip = AddBlipForCoord(alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz)
            SetBlipSprite(deliveryblip, 304)
            SetBlipDisplay(deliveryblip, 4)
            SetBlipScale(deliveryblip, 0.5)
            SetBlipColour(deliveryblip, 5)
            SetBlipAsShortRange(deliveryblip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Ponto de entrega")
            EndTextCommandSetBlipName(deliveryblip)
            SetBlipRoute(deliveryblip, true) 
            
            isTaken = 1
            isDelivered = 0
        else
            -- NOTA: Se usas mythic_notify, isto fica igual
            exports['mythic_notify']:SendAlert('Inform', 'Não tens dinheiro suficiente para pagar a caução de '..bailPrice..'€')    
        end
    end)                              
end

function FinishDelivery()
    local ped = PlayerPedId()
    if IsVehicleAttachedToTrailer(truck) and (GetVehiclePedIsIn(ped, false) == truck) then
        DeleteVehicle(trailer)
        RemoveBlip(deliveryblip)

        TriggerServerEvent('esx_truckerjob:pay', alldeliveries[randomdelivery].payment)

        isTaken = 0
        isDelivered = 1
        recebermoney = true

        if blackmode == true then
            blackmode = false
            TriggerServerEvent('qb-garbagejob:server:PayShitpt', true)											
        end
    else
        TriggerEvent('esx:showNotification', "Tens de utilizar o trailer fornecido")
    end
end

function AbortDelivery()
    -- Calcula a devolução da caução antes de apagar o veículo
    local vehicleMaxHealthInCaseofDrop = GetEntityMaxHealth(truck)
    local vehicleHealth = GetEntityHealth(truck)
    local cautionValue = 0
    
    -- Verifica o dano para devolver a caução justa
    if vehicleHealth >= vehicleMaxHealthInCaseofDrop then
        cautionValue = bailPrice
        ESX.ShowNotification('~y~Serviço cancelado. ~g~O veículo está impecável. Foi devolvida a caução na totalidade (€'..cautionValue..')')
    else
        local healthPct = (vehicleHealth * 100) / vehicleMaxHealthInCaseofDrop
        local damagePct = 100 - healthPct
        
        cautionValue = math.ceil(bailPrice - (bailPrice * (damagePct * 2.5) / 100))
        
        if cautionValue < 0 then
            cautionValue = 0
        end
        ESX.ShowNotification('~y~Serviço cancelado. ~r~O veículo tem danos. Apenas foi devolvido da caução ~g~€'..cautionValue)
    end
    
    -- Paga a caução calculada
    if cautionValue > 0 then
        TriggerServerEvent('esx_truckerjob:pay', cautionValue)
    end

    -- Apagar atrelado
    SetEntityAsNoLongerNeeded(trailer)
    DeleteVehicle(trailer)
    ESX.Game.DeleteVehicle(trailer)
    trailer = 0
    
    -- Apagar camião
    SetEntityAsNoLongerNeeded(truck)
    DeleteVehicle(truck)
    ESX.Game.DeleteVehicle(truck)
    truck = 0

    -- Limpar blips e variáveis
    RemoveBlip(deliveryblip)
    isTaken = 0
    isDelivered = 1
    recebermoney = false
    blackmode = false
end

function DeleteVehi()
    local vehicleMaxHealthInCaseofDrop = GetEntityMaxHealth(truck)
    local vehicleHealth = GetEntityHealth(truck)
    local cautionValue = 0
    
    if recebermoney == true then
        recebermoney = false
        
        -- CORRIGIDO: A matemática estava feita para devolver no máximo 100€ e não os 5000€
        if vehicleHealth >= vehicleMaxHealthInCaseofDrop then
            cautionValue = bailPrice
            ESX.ShowNotification('~g~O veículo está impecável. Foi devolvida a caução na totalidade (€'..cautionValue..')')
        else
            local healthPct = (vehicleHealth * 100) / vehicleMaxHealthInCaseofDrop
            local damagePct = 100 - healthPct
            
            -- Desconta uma percentagem sobre o valor da caução (bailPrice)
            cautionValue = math.ceil(bailPrice - (bailPrice * (damagePct * 2.5) / 100))
            
            if cautionValue < 0 then
                cautionValue = 0
            end
            ESX.ShowNotification('~r~O veículo não está em condições. Apenas foi devolvido da caução ~g~€'..cautionValue)
        end
        
        if cautionValue > 0 then
            TriggerServerEvent('esx_truckerjob:pay', cautionValue)
        end
    end					
    
    SetEntityAsNoLongerNeeded(truck)
    ESX.Game.DeleteVehicle(truck)
    truck = 0 -- Reseta a variável do camião
end

AddEventHandler('esx_truckerjob:hasEnteredMarker', function(zone)
    if zone == 'menutrucker' then
        CurrentAction     = 'trucker_menu'
        CurrentActionMsg  = 'Pressiona ~INPUT_CONTEXT~ para realizar um serviço'
        CurrentActionData = {zone = zone}
    elseif zone == 'delivered' then
        CurrentAction     = 'delivered_menu'
        CurrentActionMsg  = 'Pressiona ~INPUT_CONTEXT~ para entregar'
        CurrentActionData = {zone = zone}
    elseif zone == 'abort' then
        CurrentAction     = 'abort_menu'
        CurrentActionMsg  = 'Pressiona ~INPUT_CONTEXT~ para cancelar o serviço'
        CurrentActionData = {zone = zone}
    elseif zone == 'deletev' then
        CurrentAction     = 'deletev_menu'
        CurrentActionMsg  = 'Pressiona ~INPUT_CONTEXT~ para devolver o veículo'
        CurrentActionData = {zone = zone}
    end
end)

AddEventHandler('esx_truckerjob:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords      = GetEntityCoords(PlayerPedId())
        local isInMarker  = false
        local currentZone = nil
      
        if(GetDistanceBetweenCoords(coords, Config.Zones.VehicleSpawner.Pos.x, Config.Zones.VehicleSpawner.Pos.y, Config.Zones.VehicleSpawner.Pos.z, true) < 3) and PlayerData.job ~= nil and PlayerData.job.name == 'trucker' then
            isInMarker  = true
            currentZone = 'menutrucker'
            LastZone    = 'menutrucker'
        end
      
        if isTaken == 1 and (GetDistanceBetweenCoords(coords, alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz, true) < 3) then
            isInMarker  = true
            currentZone = 'delivered'
            LastZone    = 'delivered'
        end
        
        if isTaken == 1 and (GetDistanceBetweenCoords(coords, Config.Zones.MissionAbort.Pos.x, Config.Zones.MissionAbort.Pos.y, Config.Zones.MissionAbort.Pos.z, true) < 3) then
            isInMarker  = true
            currentZone = 'abort'
            LastZone    = 'abort'
        end
        
        if isTaken == 0 and (GetDistanceBetweenCoords(coords, Config.Zones.MissionAbort.Pos.x, Config.Zones.MissionAbort.Pos.y, Config.Zones.MissionAbort.Pos.z, true) < 3) then
            isInMarker  = true
            currentZone = 'deletev'
            LastZone    = 'deletev'
        end
        
        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('esx_truckerjob:hasEnteredMarker', currentZone)
        end
        
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('esx_truckerjob:hasExitedMarker', LastZone)
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            
            if IsControlJustReleased(0, 38) then
                if CurrentAction == 'trucker_menu' then
                    SpawnTruck()
                elseif CurrentAction == 'delivered_menu' then
                    FinishDelivery()
                elseif CurrentAction == 'abort_menu' then
                    AbortDelivery()
                elseif CurrentAction == 'deletev_menu' then
                    DeleteVehi()
                end
                CurrentAction = nil
            end
        end
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Zones) do
            if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) and PlayerData.job ~= nil and PlayerData.job.name == 'trucker' then
                DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
            end
        end
    end
end)

-- Display markers for delivery place
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isTaken == 1 and isDelivered == 0 then
            local coords = GetEntityCoords(PlayerPedId())
            local v = alldeliveries[randomdelivery]
            if (GetDistanceBetweenCoords(coords, v.posx, v.posy, v.posz, true) < Config.DrawDistance) then
                DrawMarker(1, v.posx, v.posy, v.posz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 204, 204, 0, 100, false, false, 2, false, false, false, false)
            end
        end
    end
end)

-- Create Blips for Truck Spawner
Citizen.CreateThread(function()
    local info = Config.Zones.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 0.8)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.Title)
    EndTextCommandSetBlipName(info.blip)
end)
