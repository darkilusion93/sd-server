local E_KEY = 38

local playerPosition = nil
local playerPed = nil

local isBusDriver = false
local isOnDuty = false
local isRouteFinished = false

local activeRoute = nil
local activeRouteLine = nil
local stopNumber = 1
local totalMoneyPaidThisRoute = 0

local pedsOnBus = {}
local pedsAtNextStop = {}
local pedsToDelete = {}
local numberDepartingPedsNextStop = 0

local hasShownHelpNotification = false

-- Debounce: impede que o E seja processado múltiplas vezes seguidas
local eKeyLocked = false
local function lockEKey(ms)
    eKeyLocked = true
    Citizen.CreateThread(function()
        Citizen.Wait(ms or 1000)
        eKeyLocked = false
    end)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    if xPlayer.job.name == Config.JobName then
        waitForEsxInitialization()
        waitForPlayerJobInitialization()
        registerJobChangeListener()
        
        Overlay.Init()
        Blips.StartBlips()
        Markers.StartMarkers()
        startInputThread()       -- thread dedicado ao E key (Wait 0, nunca perde input)
        startAbortRouteThread()  -- stub vazio, mantido por compatibilidade
        startPedCleanupThread()
        startMainLoop()
    end
end)

-- ─── ARRANQUE ────────────────────────────────────────────────────────────────

Citizen.CreateThread(function()
        waitForEsxInitialization()
        waitForPlayerJobInitialization()
        registerJobChangeListener()
end)

function waitForEsxInitialization()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end

function waitForPlayerJobInitialization()
    while true do
        local playerData = ESX.GetPlayerData()
        if playerData.job ~= nil then
            handleJobChange(playerData.job)
            break
        end
        Citizen.Wait(10)
    end
end

function registerJobChangeListener()
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        handleJobChange(job)
    end)
end

function handleJobChange(job)
    isBusDriver = job.name == Config.JobName
    if not isBusDriver and isOnDuty then
        immediatelyEndRoute(false) -- sem refund se foi despedido
    end
end

-- ─── THREADS ─────────────────────────────────────────────────────────────────

-- Thread dedicado APENAS ao input: Wait(0) garante que nunca perde um keypress
function startInputThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)

            if not isBusDriver then
                Citizen.Wait(500)
            elseif IsControlJustPressed(1, E_KEY) and not eKeyLocked then
                if not isOnDuty then
                    handleEKeyNotOnDuty()
                elseif isRouteFinished then
                    handleEKeyRouteFinished()
                elseif activeRoute ~= nil and not isRouteFinished then
                    handleEKeyAbort()
                end
            end
        end
    end)
end

-- mantido por compatibilidade mas a lógica E foi para startInputThread
function startAbortRouteThread()
end

function startPedCleanupThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            if #pedsToDelete > 0 then
                handlePedCleanup()
            end
        end
    end)
end

function handlePedCleanup()
    local pedsStillToDelete = {}
    for _, ped in pairs(pedsToDelete) do
        if playerDistanceFromCoords(GetEntityCoords(ped)) < Config.PedCleanupDistance then
            table.insert(pedsStillToDelete, ped)
        else
            Peds.DeletePed(ped)
        end
    end
    pedsToDelete = pedsStillToDelete
end

function startMainLoop()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)

            if isBusDriver then
                updateCachedPlayerProperties()

                if not isOnDuty then
                    handleNotOnDutyState()
                elseif isRouteFinished then
                    handleRouteFinishedState()
                else
                    handleOnDutyState()
                    if activeRoute ~= nil then
                        handleAbortRoute() -- mostra notificação se perto do spawn
                    end
                end
            else
                Citizen.Wait(2000)
            end
        end
    end)
end

function updateCachedPlayerProperties()
    playerPed = PlayerPedId()
    playerPosition = GetEntityCoords(playerPed)
end

-- ─── ESTADO: FORA DE SERVIÇO ──────────────────────────────────────────────────

function handleNotOnDutyState()
    local isInMarker = false

    for _, route in pairs(Config.Routes) do
        if playerDistanceFromCoords(route.SpawnPoint) < Config.Markers.TriggerSize then
            isInMarker = true

            if not hasShownHelpNotification then
                ESX.ShowHelpNotification(_U('start_route_help', _U(route.Name)))
                hasShownHelpNotification = true
            end
            break
        end
    end

    if not isInMarker and hasShownHelpNotification then
        hasShownHelpNotification = false
    end
end

-- Chamado pelo input thread quando E é pressionado fora de serviço
function handleEKeyNotOnDuty()
    for _, route in pairs(Config.Routes) do
        if playerDistanceFromCoords(route.SpawnPoint) < Config.Markers.TriggerSize then
            lockEKey(2000)
            ESX.TriggerServerCallback('blarglebus:payBail', function(hasEnoughMoney)
                if hasEnoughMoney then
                    hasShownHelpNotification = false

                    activeRoute = route
                    activeRouteLine = activeRoute.RouteLines[math.random(#activeRoute.RouteLines)]
                    stopNumber = 1
                    totalMoneyPaidThisRoute = 0

                    Bus.CreateBus(activeRoute.SpawnPoint, activeRouteLine.BusModel, activeRouteLine.BusColor)

                    isOnDuty = true
                    isRouteFinished = false

                    Blips.StopBlips()
                    Blips.StartAbortBlip(activeRoute.Name, activeRoute.SpawnPoint)
                    Markers.StartAbortMarker(activeRoute.SpawnPoint)
                    Overlay.Start()

                    setUpNextStop()
                    Events.RouteStarted(activeRoute.Name)
                else
                    ESX.ShowNotification(_U('not_enough_money_bail'))
                end
            end)
            break
        end
    end
end

-- ─── ESTADO: ROTA TERMINADA ───────────────────────────────────────────────────

function handleRouteFinishedState()
    ESX.ShowHelpNotification(_U('route_finished_help'))
    -- Input tratado por handleEKeyRouteFinished no input thread
end

-- Chamado pelo input thread quando E é pressionado com rota terminada
function handleEKeyRouteFinished()
    lockEKey(2000)

    local busUndamaged = Bus.IsBusUndamaged()

    -- Sair do autocarro antes de o apagar
    if Bus.bus ~= nil and GetVehiclePedIsIn(PlayerPedId(), false) == Bus.bus then
        TaskLeaveVehicle(PlayerPedId(), Bus.bus, 0)
        Citizen.Wait(800) -- aguardar animação de saída
    end

    Bus.DeleteBus()

    -- Envia o ganho + flag de danos; servidor decide se devolve caução
    TriggerServerEvent('blarglebus:finishRoute', totalMoneyPaidThisRoute, busUndamaged)

    isOnDuty = false
    isRouteFinished = false

    Blips.StopAbortBlip()
    Blips.StartBlips()
    Markers.ResetMarkers()
    Overlay.Stop()
end

-- ─── ESTADO: EM SERVIÇO ───────────────────────────────────────────────────────

function handleOnDutyState()
    if activeRouteLine == nil then return end
    local nextStop = activeRouteLine[stopNumber]

    if nextStop == nil then
        handleEndofLineReached()
        return
    end

    if playerDistanceFromCoords(nextStop.Coords) < Config.Markers.TriggerSize
    and Bus.bus ~= nil
    and Bus.bus == GetVehiclePedIsIn(playerPed, false) then

        local nextStopNameKey = 'end_of_line'
        if stopNumber < #activeRouteLine then
            nextStopNameKey = activeRouteLine[stopNumber + 1].Name
        end
        Events.ArrivedAtStop(nextStop.Name, nextStopNameKey)

        Bus.DisplayMessageAndWaitUntilBusStopped(_U('stop_the_bus'))
        Bus.OpenDoorsAndActivateHazards(nextStop.Doors)

        handleDepartingPassengers(nextStop.Coords)
        handleArrivingPassengers(nextStop)

        Bus.CloseDoorsAndDeactivateHazards()

        Events.DepartingStop(nextStop.Name, nextStopNameKey)

        stopNumber = stopNumber + 1

        if stopNumber > #activeRouteLine then
            handleEndofLineReached()
        else
            setUpNextStop()
        end
    end
end

-- ─── ABORT ────────────────────────────────────────────────────────────────────

function handleAbortRoute()
    -- apenas mostra a notificação; input tratado por handleEKeyAbort
    if playerDistanceFromCoords(activeRoute.SpawnPoint) < Config.Markers.TriggerSize then
        ESX.ShowHelpNotification(_U('abort_route_help', totalMoneyPaidThisRoute))
    end
end

-- Chamado pelo input thread quando E é pressionado em serviço (para abort)
function handleEKeyAbort()
    if playerDistanceFromCoords(activeRoute.SpawnPoint) < Config.Markers.TriggerSize then
        lockEKey(2000)
        TriggerServerEvent('blarglebus:abortRoute', totalMoneyPaidThisRoute)
        immediatelyEndRoute(true)
    end
end

-- ─── FIM DE LINHA ─────────────────────────────────────────────────────────────

function handleEndofLineReached()
    Peds.DeletePeds(pedsOnBus)
    pedsOnBus = {}

    Markers.SetMarkers({activeRoute.SpawnPoint})

    -- FIX: blip volta para o spawn point sem piscar (não recria, só move)
    Blips.SetBlipCoords(activeRoute.Name, activeRoute.SpawnPoint.x, activeRoute.SpawnPoint.y, activeRoute.SpawnPoint.z)
    SetNewWaypoint(activeRoute.SpawnPoint.x, activeRoute.SpawnPoint.y)

    Overlay.Update(_U(activeRoute.Name), _U('end_of_line'), 0, totalMoneyPaidThisRoute)

    isRouteFinished = true
    Events.RouteEnded()
end

-- ─── PRÓXIMA PARAGEM ──────────────────────────────────────────────────────────

function setUpNextStop()
    local nextStop = activeRouteLine[stopNumber]
    if nextStop == nil then return end

    local freeSeats = Bus.FindFreeSeats(1, Config.MaxPassengers)

    numberDepartingPedsNextStop = 0
    if #pedsOnBus > 0 then
        numberDepartingPedsNextStop = math.random(0, #pedsOnBus)
    end

    local availableSeats = math.max(0, #freeSeats - numberDepartingPedsNextStop)
    local numberArrivingPedsNextStop = 0

    if availableSeats > 0 then
        if nextStop.Type == 'BusStop' then
            numberArrivingPedsNextStop = setUpBusStop(availableSeats)
        elseif nextStop.Type == 'None' then
            numberArrivingPedsNextStop, numberDepartingPedsNextStop = setUpNoneStop(availableSeats)
        end
    end

    pedsAtNextStop = {}
    for i = 1, numberArrivingPedsNextStop do
        table.insert(pedsAtNextStop, Peds.CreateRandomPedInArea(nextStop.Coords))
    end

    Markers.SetMarkers({nextStop.Coords})

    -- FIX: mover blip sem recriar (evita piscar)
    Blips.SetBlipCoords(activeRoute.Name, nextStop.Coords.x, nextStop.Coords.y, nextStop.Coords.z)
    SetNewWaypoint(nextStop.Coords.x, nextStop.Coords.y)

    Overlay.Update(_U(activeRoute.Name), _U(nextStop.Name), #activeRouteLine - stopNumber + 1, totalMoneyPaidThisRoute)
end

function setUpBusStop(freeSeats)
    local minPeds = math.min(Config.BusStopMinPassengers, freeSeats)
    local maxPeds = math.min(Config.BusStopMaxPassengers, freeSeats)
    if minPeds > maxPeds then minPeds = maxPeds end
    return math.random(minPeds, maxPeds)
end

function setUpNoneStop(freeSeats)
    if freeSeats <= 0 then return 0, 0 end
    return math.random(1, freeSeats), 0
end

-- ─── PASSAGEIROS ─────────────────────────────────────────────────────────────

function handleDepartingPassengers(stopCoords)
    local departingPeds = {}
    for i = 1, numberDepartingPedsNextStop do
        if #pedsOnBus > 0 then
            table.insert(departingPeds, table.remove(pedsOnBus, math.random(#pedsOnBus)))
        end
    end

    for _, ped in pairs(departingPeds) do
        Peds.LeaveVehicle(ped, Bus.bus)
        Peds.WalkAwayAfterLeaving(ped, stopCoords)
        table.insert(pedsToDelete, ped)
    end

    Bus.MovePedsToFrontSeats(pedsOnBus, 1, Bus.FindFreeSeats(1, Config.MaxPassengers))

    if #departingPeds > 0 then
        Citizen.Wait(Config.DelayBetweenChanges * 3)
    end
end

function handleArrivingPassengers(nextStop)
    local seats = Bus.FindFreeSeats(1, Config.MaxPassengers)

    for i = 1, #pedsAtNextStop do
        if #seats == 0 then break end
        local ped = pedsAtNextStop[i]
        local seat = table.remove(seats, 1)

        Peds.EnterVehicle(ped, Bus.bus, seat)
        table.insert(pedsOnBus, ped)

        totalMoneyPaidThisRoute = totalMoneyPaidThisRoute + math.random(nextStop.MinFare, nextStop.MaxFare)
    end

    pedsAtNextStop = {}

    if #pedsOnBus > 0 then
        Citizen.Wait(Config.DelayBetweenChanges * 3)
    end
end

-- ─── UTILITÁRIOS ─────────────────────────────────────────────────────────────

function immediatelyEndRoute(refundBail)
    isOnDuty = false
    isRouteFinished = false
    activeRoute = nil
    activeRouteLine = nil

    Peds.DeletePeds(pedsToDelete)
    Peds.DeletePeds(pedsAtNextStop)
    Peds.DeletePeds(pedsOnBus)
    pedsOnBus = {}
    pedsAtNextStop = {}
    pedsToDelete = {}

    Bus.DeleteBus()
    Overlay.Stop()

    -- FIX: restaurar blips de arranque
    Blips.StopAbortBlip()
    Blips.StartBlips()
    Markers.ResetMarkers()

    if refundBail then
        TriggerServerEvent('blarglebus:refundBail')
    end
end

function playerDistanceFromCoords(coords)
    if playerPosition == nil then return 99999.0 end
    return #(playerPosition - vec3(coords.x, coords.y, coords.z))
end