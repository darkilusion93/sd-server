Bus = {}
Bus.bus = nil
Bus.plate = nil

function Bus.CreateBus(coords, model, color)
    ESX.Game.SpawnVehicle(model, coords, coords.heading, function(createdBus)
        Bus.bus = createdBus
        Bus.plate = string.format('BUS%04d', math.random(0, 9999))
        SetVehicleNumberPlateText(Bus.bus, Bus.plate)
        SetVehicleColours(Bus.bus, color, color)
        Bus.WaitForFirstEntryAndFillTankIfNeededAsync()

        -- Pequena pausa para o veículo estabilizar antes de teleportar
        Citizen.Wait(300)
        SetPedIntoVehicle(PlayerPedId(), Bus.bus, -1) -- -1 = lugar do condutor

        if Target ~= nil then
            exports["LegacyFuel"]:SetFuel(createdBus, 100)
        end
    end)
end

function Bus.WaitForFirstEntryAndFillTankIfNeededAsync()
    if Config.UseLegacyFuel then
        Bus.DoFillForLegacyFuel()
    elseif Config.UseFrFuel then
        Bus.DoFillForFrFuel()
    end
end

function Bus.DoFillForLegacyFuel()
    wasCallSuccessful, err = pcall(Bus.DoFillForLegacyFuelNewStyle)
    if not wasCallSuccessful then
        Log.debug('Erro ao carregar combustível.')
    end
end

function Bus.DoFillForLegacyFuelNewStyle()
    exports[Config.LegacyFuelFolderName]:SetFuel(Bus.bus, 100)
end

function Bus.DoFillForFrFuel()
    Citizen.CreateThread(function()
        local maxFuel = GetVehicleHandlingFloat(Bus.bus, 'CHandlingData', 'fPetrolTankVolume')
        while true do
            Citizen.Wait(500)
            if GetVehiclePedIsIn(PlayerPedId(), false) == Bus.bus then
                exports.frfuel:setFuel(maxFuel)
                break
            end
        end
    end)
end

function Bus.DeleteBus()
    if DoesEntityExist(Bus.bus) then
        DeleteVehicle(Bus.bus)
    end
    Bus.bus = nil
end

-- Devolve true se o autocarro não tiver danos significativos
-- GetVehicleBodyHealth: 1000.0 = perfeito, abaixo de 950 já tem danos visíveis
function Bus.IsBusUndamaged()
    if Bus.bus == nil or not DoesEntityExist(Bus.bus) then return false end
    local bodyHealth   = GetVehicleBodyHealth(Bus.bus)
    local engineHealth = GetVehicleEngineHealth(Bus.bus)
    return bodyHealth >= 950.0 and engineHealth >= 950.0
end

function Bus.DisplayMessageAndWaitUntilBusStopped(notificationMessage)
    while not IsVehicleStopped(Bus.bus) do
        ESX.ShowNotification(notificationMessage)
        Citizen.Wait(500)
    end
end

function Bus.OpenDoorsAndActivateHazards(doors)
    Bus.ActivateHazards(true)
    Bus.OpenBusDoors(doors)
end

function Bus.OpenBusDoors(doors)
    for i = 1, #doors do
        SetVehicleDoorOpen(Bus.bus, doors[i], false, false)
    end
    Citizen.Wait(Config.DelayBetweenChanges)
end

function Bus.CloseDoorsAndDeactivateHazards()
    Bus.ActivateHazards(false)
    SetVehicleDoorsShut(Bus.bus, false)
end

function Bus.ActivateHazards(isOn)
    SetVehicleIndicatorLights(Bus.bus, 0, isOn)
    SetVehicleIndicatorLights(Bus.bus, 1, isOn)
end

function Bus.FindFreeSeats(firstSeat, lastSeat)
    local freeSeats = {}
    for i = firstSeat, lastSeat do
        if IsVehicleSeatFree(Bus.bus, i) then
            table.insert(freeSeats, i)
        end
    end
    return freeSeats
end

function Bus.MovePedsToFrontSeats(peds, firstSeat, freeSeats)
    for i = 1, #peds do
        local currentSeat = GetSeatPedIsIn(peds[i])
        if currentSeat > firstSeat and #freeSeats > 0 and freeSeats[1] < currentSeat then
            local nextFreeSeat = table.remove(freeSeats, 1)
            SetPedIntoVehicle(peds[i], Bus.bus, nextFreeSeat)
            table.insert(freeSeats, currentSeat)
            table.sort(freeSeats)
        end
    end
end

function GetSeatPedIsIn(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
        if GetPedInVehicleSeat(vehicle, i) == ped then
            return i
        end
    end
    return -2
end