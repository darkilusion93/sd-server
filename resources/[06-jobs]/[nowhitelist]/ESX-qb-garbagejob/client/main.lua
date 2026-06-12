local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}
isLoggedIn = false
local aleatoriedade123 = 1

PlayerJob = {}

local GarbageVehicle = nil
local hasVuilniswagen = false
local hasZak = false
local GarbageLocation = 0
local DeliveryBlip = nil
local IsWorking = false
local AmountOfBags = 0
local GarbageObject = nil
local EndBlip = nil
local GarbageBlip = nil
local Earnings = 0
local CanTakeBag = true
local spamtest = false 
local terminado = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    isLoggedIn = true
    GarbageVehicle = nil
    hasVuilniswagen = false
    hasZak = false
    GarbageLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    GarbageObject = nil
    EndBlip = nil
    
    while PlayerData == nil do
        Citizen.Wait(5000)
    end
    while PlayerData.job == nil do
        Citizen.Wait(5000)
    end
    isLoggedIn = true
    
    if PlayerData.job.name == "garbage" then
        GarbageBlip = AddBlipForCoord(Config.Locations["garbagemain"].coords.x, Config.Locations["garbagemain"].coords.y, Config.Locations["garbagemain"].coords.z)
        SetBlipSprite(GarbageBlip, 318)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 39)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Lixeiro")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "seguranca" then
        GarbageBlip = AddBlipForCoord(Config.Locations["segurancamain"].coords.x, Config.Locations["segurancamain"].coords.y, Config.Locations["segurancamain"].coords.z)
        SetBlipSprite(GarbageBlip, 137)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 66)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Securitas")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "meo" then
        GarbageBlip = AddBlipForCoord(Config.Locations["meomain"].coords.x, Config.Locations["meomain"].coords.y, Config.Locations["meomain"].coords.z)
        SetBlipSprite(GarbageBlip, 590)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Telecomunicações")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "gopostal" then
        GarbageBlip = AddBlipForCoord(Config.Locations["cttmain"].coords.x, Config.Locations["cttmain"].coords.y, Config.Locations["cttmain"].coords.z)
        SetBlipSprite(GarbageBlip, 256)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip,0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Correios")
        EndTextCommandSetBlipName(GarbageBlip)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    isLoggedIn = true
    GarbageVehicle = nil
    hasVuilniswagen = false
    hasZak = false
    GarbageLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    GarbageObject = nil
    EndBlip = nil
    Earnings = 0
    
    if PlayerData.job.name == "garbage" then
        GarbageBlip = AddBlipForCoord(Config.Locations["garbagemain"].coords.x, Config.Locations["garbagemain"].coords.y, Config.Locations["garbagemain"].coords.z)
        SetBlipSprite(GarbageBlip, 318)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 39)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Lixeiro")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "seguranca" then
        GarbageBlip = AddBlipForCoord(Config.Locations["segurancamain"].coords.x, Config.Locations["segurancamain"].coords.y, Config.Locations["segurancamain"].coords.z)
        SetBlipSprite(GarbageBlip, 137)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 66)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Securitas")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "meo" then
        GarbageBlip = AddBlipForCoord(Config.Locations["meomain"].coords.x, Config.Locations["meomain"].coords.y, Config.Locations["meomain"].coords.z)
        SetBlipSprite(GarbageBlip, 590)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 3)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Telecomunicações")
        EndTextCommandSetBlipName(GarbageBlip)
    elseif PlayerData.job.name == "gopostal" then
        GarbageBlip = AddBlipForCoord(Config.Locations["cttmain"].coords.x, Config.Locations["cttmain"].coords.y, Config.Locations["cttmain"].coords.z)
        SetBlipSprite(GarbageBlip, 256)
        SetBlipDisplay(GarbageBlip, 4)
        SetBlipScale(GarbageBlip, 0.8)
        SetBlipAsShortRange(GarbageBlip, true)
        SetBlipColour(GarbageBlip, 1)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Correios")
        EndTextCommandSetBlipName(GarbageBlip)
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function DrawText3D2(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function LoadModel(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
end

function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
end

function BringBackCar()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    DeleteVehicle(veh)
    if EndBlip ~= nil then
        RemoveBlip(EndBlip)
    end
    if DeliveryBlip ~= nil then
        RemoveBlip(DeliveryBlip)
    end
    GarbageVehicle = nil
    hasVuilniswagen = false
    hasZak = false
    GarbageLocation = 0
    DeliveryBlip = nil
    IsWorking = false
    AmountOfBags = 0
    if GarbageObject ~= nil then
        DeleteObject(GarbageObject)
    end
    GarbageObject = nil
    EndBlip = nil
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local InVehicle = IsPedInAnyVehicle(ped, false)
        local otim = 1500

        if isLoggedIn and PlayerData ~= nil and PlayerData.job ~= nil then
            -- Definição dos dados de cada emprego para evitar repetição
            local jobData = {
                ["garbage"] = { 
                    loc = Config.Locations["garbageVehicle"], 
                    loc2 = Config.Locations["garbageVehicle2"], 
                    model = "trash", 
                    plate = "LIXO" 
                },
                ["seguranca"] = { 
                    loc = Config.Locations["segurancaVehicle"], 
                    loc2 = Config.Locations["segurancaVehicle2"], 
                    model = "stockade", 
                    plate = "SEGU" 
                },
                ["gopostal"] = { 
                    loc = Config.Locations["cttVehicle"], 
                    loc2 = Config.Locations["cttVehicle2"], 
                    model = "boxville2", 
                    plate = "CTT" 
                },
                ["meo"] = { 
                    loc = Config.Locations["meoVehicle"], 
                    loc2 = Config.Locations["meoVehicle2"], 
                    model = "vwcaddy", 
                    plate = "MEO" 
                }
            }

            local currentJob = jobData[PlayerData.job.name]

            if currentJob then
                local dist = #(pos - vector3(currentJob.loc.coords.x, currentJob.loc.coords.y, currentJob.loc.coords.z))
                
                if dist < 20.0 then
                    otim = 0
                    DrawMarker(2, currentJob.loc.coords.x, currentJob.loc.coords.y, currentJob.loc.coords.z + 0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.4, 0.3, 233, 55, 22, 222, false, false, false, true, false, false, false)

                    if dist < 1.5 then
                        if InVehicle then
                            DrawText3D(currentJob.loc.coords.x, currentJob.loc.coords.y, currentJob.loc.coords.z, "~g~E~w~ - Guardar Veículo")
                            if IsControlJustPressed(0, Keys["E"]) then
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) TriggerEvent('skinchanger:loadSkin', skin) end)
                                
                                if GetVehiclePedIsIn(ped, false) == GarbageVehicle then
                                    BringBackCar()
                                    if Earnings > 0 then
                                        TriggerServerEvent('qb-garbagejob:server:PayShitpt', (terminado or false), Earnings)
                                        terminado = false
                                    else
                                        ESX.ShowNotification('Não cumpriste o número mínimo de etapas!', 'inform')
                                    end
                                    Earnings = 0
                                else
                                    BringBackCar()
                                    ESX.ShowNotification('Esse não é o veículo correto!', 'inform')
                                end
                            end
                        else
                            DrawText3D(currentJob.loc.coords.x, currentJob.loc.coords.y, currentJob.loc.coords.z, "~g~E~w~ - Levantar Veículo")
                            if IsControlJustPressed(0, Keys["E"]) and not spamtest then
                                TriggerEvent('qb-garbage:antispam')
                                ESX.TriggerServerCallback('qb-garbagejob:server:HasMoney', function(HasMoney)
                                    if HasMoney then
                                        local coords = currentJob.loc2.coords
                                        ESX.Game.SpawnLocalVehicle(currentJob.model, coords, coords.h, function(vehicle)
                                            GarbageVehicle = vehicle
                                            SetVehicleNumberPlateText(vehicle, currentJob.plate .. tostring(math.random(1000, 9999)))
                                            TaskWarpPedIntoVehicle(ped, vehicle, -1)
                                            SetEntityAsMissionEntity(vehicle, true, true)
                                            SetVehicleEngineOn(vehicle, true, true)
                                            exports["LegacyFuel"]:SetFuel(vehicle, 100)
                                            hasVuilniswagen = true
                                            GarbageLocation = 1
                                            IsWorking = true
                                            SetGarbageRoute()
                                            
                                            -- Uniformes
                                            if Config.Uniforms and Config.Uniforms[PlayerData.job.name] then
                                                TriggerEvent('skinchanger:getSkin', function(skin)
                                                    local clothes = (skin.sex == 0) and Config.Uniforms[PlayerData.job.name].male or Config.Uniforms[PlayerData.job.name].female
                                                    TriggerEvent('skinchanger:loadClothes', skin, clothes)
                                                end)
                                            end
                                            
                                            ESX.ShowNotification('Pagaste 3000€ de caução. Rota iniciada!', 'success')
                                        end)
                                    else
                                        ESX.ShowNotification('Não tens dinheiro suficiente (3000€).', 'inform')
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(otim)
    end
end)

RegisterNetEvent('qb-garbage:antispam')
AddEventHandler('qb-garbage:antispam', function()
    spamtest = true
    Citizen.Wait(60 * 1000)
    spamtest = false
end)

function spawnVehicle(model, cb, coords, isnetworked)
    local model = (type(model) == "number" and model or GetHashKey(model))
    local coords = coords ~= nil and coords or Config.Locations[PlayerData.job.name.."Vehicle2"].coords
    local isnetworked = isnetworked ~= nil and isnetworked or true

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.a, isnetworked, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)

    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, "OFF")

    SetModelAsNoLongerNeeded(model)
    exports["LegacyFuel"]:SetFuel(veh, 100)

    if cb ~= nil then
        cb(veh)
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local otim = 1500

        if isLoggedIn then
            if PlayerData ~= nil and PlayerData.job ~= nil then
                
                -- ETAPAS: GARBAGE
                if PlayerData.job.name == "garbage" then
                    otim = 5
                    if IsWorking and GarbageLocation ~= 0 and DeliveryBlip ~= nil then
                        local DeliveryData = Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation]
                        local Distance = GetDistanceBetweenCoords(pos, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, true)

                        if Distance < 20 or hasZak then
                            LoadAnimation('missfbi4prepp1')
                            DrawMarker(2, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 55, 22, 255, false, false, false, false, false, false, false)
                            if not hasZak then
                                if CanTakeBag then
                                    if Distance < 1.5 then
                                        DrawText3D2(DeliveryData.coords, "~g~E~w~ - Pega um saco do lixo")
                                        if IsControlJustPressed(0, 51) then
                                            if AmountOfBags == 0 then
                                                AmountOfBags = math.random(3, 5)
                                            end 
                                            hasZak = true
                                            TakeAnim()
                                        end
                                    elseif Distance < 10 then
                                        DrawText3D2(DeliveryData.coords, "Pega um saco do lixo.")
                                    end
                                end
                            else
                                if DoesEntityExist(GarbageVehicle) then
                                    if Distance < 10 then
                                        DrawText3D2(DeliveryData.coords, "Coloca o saco no camião")
                                    end

                                    local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -4.5, 0.0)
                                    local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)

                                    if TruckDist < 2 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "~g~E~w~ - Coloca o saco no camião")
                                        if IsControlJustPressed(0, 51) then
                                            hasZak = false
                                            local AmountOfLocations = #Config.Locations[PlayerData.job.name..aleatoriedade123]
                                            if (AmountOfBags - 1) == 0 then
                                                Earnings = Earnings + math.random(400, 600)
                                                if (GarbageLocation + 1) <= AmountOfLocations then
                                                    GarbageLocation = GarbageLocation + 1
                                                    SetGarbageRoute()
                                                    ESX.ShowNotification('Caixote vazio, podes prosseguir até à próxima paragem!', 'inform')
                                                else
                                                    ESX.ShowNotification('Serviço Terminado, podes voltar à base!', 'inform')
                                                    IsWorking = false
                                                    terminado = true
                                                    RemoveBlip(DeliveryBlip)
                                                    SetRouteBack()
                                                end
                                                AmountOfBags = 0
                                                hasZak = false
                                            else
                                                AmountOfBags = AmountOfBags - 1
                                                if AmountOfBags > 1 then
                                                    ESX.ShowNotification('Ainda faltam '..AmountOfBags..' sacos!', 'inform')
                                                else
                                                    ESX.ShowNotification('Ainda falta '..AmountOfBags..' saco!', 'inform')
                                                end
                                                hasZak = false
                                            end
                                            DeliverAnim()
                                        end
                                    elseif TruckDist < 10 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "Coloca o saco no camião")
                                    end
                                else
                                    DrawText3D2(DeliveryData.coords, "Não tens nenhum camião")
                                end
                            end
                        end
                    end

                -- ETAPAS: SEGURANCA
                elseif PlayerData.job.name == "seguranca" then
                    otim = 5
                    if IsWorking and GarbageLocation ~= 0 and DeliveryBlip ~= nil then
                        local DeliveryData = Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation]
                        local Distance = GetDistanceBetweenCoords(pos, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, true)

                        if Distance < 20 or hasZak then
                            LoadAnimation('missfbi4prepp1')
                            DrawMarker(2, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 55, 22, 255, false, false, false, false, false, false, false)
                            if not hasZak then
                                if CanTakeBag then
                                    if Distance < 1.25 then
                                        DrawText3D2(DeliveryData.coords, "~g~E~w~ - Pega um saco de dinheiro.")
                                        if IsControlJustPressed(0, 51) then
                                            if AmountOfBags == 0 then
                                                AmountOfBags = math.random(3, 5)
                                            end 
                                            hasZak = true
                                            TakeAnim1()
                                        end
                                    elseif Distance < 10 then
                                        DrawText3D2(DeliveryData.coords, "Pega um saco de dinheiro.")
                                    end
                                end
                            else
                                if DoesEntityExist(GarbageVehicle) then
                                    if Distance < 10 then
                                        DrawText3D2(DeliveryData.coords, "Coloca o saco no Carrinha")
                                    end

                                    local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -4.5, 0.0)
                                    local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)

                                    if TruckDist < 2 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "~g~E~w~ - Coloca o saco no Carrinha")
                                        if IsControlJustPressed(0, 51) then
                                            hasZak = false
                                            local AmountOfLocations = #Config.Locations[PlayerData.job.name..aleatoriedade123]
                                            if (AmountOfBags - 1) == 0 then
                                                Earnings = Earnings + math.random(400, 600)
                                                if (GarbageLocation + 1) <= AmountOfLocations then
                                                    GarbageLocation = GarbageLocation + 1
                                                    SetGarbageRoute()
                                                    ESX.ShowNotification('Dinheiro Recolhido, podes prosseguir até à próxima paragem!', 'inform')
                                                else
                                                    ESX.ShowNotification('Serviço Terminado, podes voltar à base!', 'inform')
                                                    IsWorking = false
                                                    terminado = true
                                                    RemoveBlip(DeliveryBlip)
                                                    SetRouteBack()
                                                end
                                                AmountOfBags = 0
                                                hasZak = false
                                            else
                                                AmountOfBags = AmountOfBags - 1
                                                if AmountOfBags > 1 then
                                                    ESX.ShowNotification('Ainda faltam '..AmountOfBags..' sacos!', 'inform')
                                                else
                                                    ESX.ShowNotification('Ainda falta '..AmountOfBags..' saco!', 'inform')
                                                end
                                                hasZak = false
                                            end
                                            SetVehicleDoorOpen(GarbageVehicle, 2, false)
                                            SetVehicleDoorOpen(GarbageVehicle, 3, false)
                                            Citizen.Wait(100)
                                            DeliverAnim1()
                                            Citizen.Wait(2000)
                                            SetVehicleDoorShut(GarbageVehicle, 2, false)
                                            SetVehicleDoorShut(GarbageVehicle, 3, false)
                                        end
                                    elseif TruckDist < 10 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "Coloca o saco no Carrinha")
                                    end
                                else
                                    DrawText3D2(DeliveryData.coords, "Não tens nenhum Carrinha")
                                end
                            end
                        end
                    end

                -- ETAPAS: GOPOSTAL
                elseif PlayerData.job.name == "gopostal" then
                    otim = 5
                    if IsWorking and GarbageLocation ~= 0 and DeliveryBlip ~= nil then
                        local DeliveryData = Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation]
                        local Distance = GetDistanceBetweenCoords(pos, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, true)
                
                        if Distance < 30 or hasZak then
                            LoadAnimation('missfbi4prepp1')
                            DrawMarker(2, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 55, 22, 255, false, false, false, false, false, false, false)
                            if not hasZak then
                                if CanTakeBag then
                                    if DoesEntityExist(GarbageVehicle) then
                                        if Distance < 10 then
                                            DrawText3D2(DeliveryData.coords, "Pega uma encomenda da carrinha")
                                        end
                                        local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -4.5, 0.0)
                                        local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)                
                                        
                                        if TruckDist < 2 then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "~g~E~w~ - Pega uma encomenda")
                                            if IsControlJustPressed(0, 51) then
                                                if AmountOfBags == 0 then
                                                    AmountOfBags = math.random(1, 2)
                                                end 
                                                hasZak = true
                                                TaskGoStraightToCoord(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z, 6.2, 2000, GetEntityHeading(GarbageVehicle), 1.0)
                                                Citizen.Wait(2000)
                                                SetVehicleDoorOpen(GarbageVehicle, 4, false)
                                                SetVehicleDoorOpen(GarbageVehicle, 5, false)
                                                SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GarbageVehicle))
                                                Citizen.Wait(1000)
                                                TakeAnim2()
                                                Citizen.Wait(1000)
                                                SetVehicleDoorShut(GarbageVehicle, 4, false)
                                                SetVehicleDoorShut(GarbageVehicle, 5, false)
                                            end
                                        elseif TruckDist < 10 and not IsPedInAnyVehicle(PlayerPedId(), false) then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "Pega uma encomenda")
                                        end
                                    else
                                        DrawText3D2(DeliveryData.coords, "Não tens nenhum Carrinha")
                                    end
                                end
                            else
                                if Distance < 1.5 then
                                    local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -4.5, 0.0)
                                    local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)
                                    DrawText3D2(DeliveryData.coords, "~g~E~w~ - Entrega a encomenda")
                                    if IsControlJustPressed(0, 51) then
                                        hasZak = false
                                        local AmountOfLocations = #Config.Locations[PlayerData.job.name..aleatoriedade123]
                                        if (AmountOfBags - 1) == 0 then
                                            Earnings = Earnings + math.random(400, 600)
                                            if (GarbageLocation + 1) <= AmountOfLocations then
                                                GarbageLocation = GarbageLocation + 1
                                                SetGarbageRoute()
                                                ESX.ShowNotification('Encomenda Entregue, podes prosseguir até à próxima paragem!', 'inform')
                                            else
                                                ESX.ShowNotification('Serviço Terminado, podes voltar à base!', 'inform')
                                                IsWorking = false
                                                terminado = true
                                                RemoveBlip(DeliveryBlip)
                                                SetRouteBack()
                                            end
                                            AmountOfBags = 0
                                            hasZak = false
                                        else
                                            AmountOfBags = AmountOfBags - 1
                                            if AmountOfBags > 1 then
                                                ESX.ShowNotification('Ainda faltam '..AmountOfBags..'encomendas!', 'inform')
                                            else
                                                ESX.ShowNotification('Ainda falta '..AmountOfBags..' encomenda!', 'inform')
                                            end
                                            hasZak = false
                                        end
                                        SetEntityHeading(GetPlayerPed(-1), DeliveryData.coords.h)
                                        DeliverAnim2()
                                    end
                                    if TruckDist < 10 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "Entrega a encomenda na porta")
                                    end
                                elseif Distance < 10 then
                                    DrawText3D2(DeliveryData.coords, "Entrega a encomenda")
                                end
                            end
                        end
                    end

                -- ETAPAS: MEO
                elseif PlayerData.job.name == "meo" then
                    otim = 5
                    if IsWorking and GarbageLocation ~= 0 and DeliveryBlip ~= nil then
                        local DeliveryData = Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation]
                        local Distance = GetDistanceBetweenCoords(pos, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, true)
                
                        if Distance < 30 or hasZak then
                            LoadAnimation('missfbi4prepp1')
                            DrawMarker(2, DeliveryData.coords.x, DeliveryData.coords.y, DeliveryData.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 55, 22, 255, false, false, false, false, false, false, false)
                            if not hasZak then
                                if CanTakeBag then
                                    if DoesEntityExist(GarbageVehicle) then
                                        if Distance < 10 then
                                            DrawText3D2(DeliveryData.coords, "Pega o equipamento na carrinha")
                                        end
                                        local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -2.5, 0.0)
                                        local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)                
                                        
                                        if TruckDist < 2 then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "~g~E~w~ - Pega o equipamento")
                                            if IsControlJustPressed(0, 51) then
                                                if AmountOfBags == 0 then
                                                    AmountOfBags = 1
                                                end 
                                                hasZak = true
                                                SetVehicleDoorOpen(GarbageVehicle, 5, false)
                                                Citizen.Wait(100)
                                                TaskGoStraightToCoord(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z, 6.2, 2000, GetEntityHeading(GarbageVehicle), 1.0)
                                                Citizen.Wait(2000)
                                                SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GarbageVehicle))
                                                TakeAnim3()
                                                Citizen.Wait(1000)
                                                SetVehicleDoorShut(GarbageVehicle, 5, false)
                                            end
                                        elseif TruckDist < 10 and not IsPedInAnyVehicle(PlayerPedId(), false) then
                                            DrawText3D(Coords.x, Coords.y, Coords.z, "Pega o equipamento")
                                        else
                                            DeleteObject(GarbageObject)
                                            GarbageObject = nil
                                        end
                                    else
                                        DrawText3D2(DeliveryData.coords, "Não tens nenhum Carrinha")
                                    end
                                end
                            else
                                if Distance < 1.5 then
                                    local Coords = GetOffsetFromEntityInWorldCoords(GarbageVehicle, 0.0, -2.5, 0.0)
                                    local TruckDist = GetDistanceBetweenCoords(pos, Coords.x, Coords.y, Coords.z, true)
                                    DrawText3D2(DeliveryData.coords, "~g~E~w~ - Realiza a Manutenção")
                                    if IsControlJustPressed(0, 51) then
                                        hasZak = false
                                        local AmountOfLocations = #Config.Locations[PlayerData.job.name..aleatoriedade123]
                                        if (AmountOfBags - 1) == 0 then
                                            Earnings = Earnings + math.random(400, 600)
                                            if (GarbageLocation + 1) <= AmountOfLocations then
                                                GarbageLocation = GarbageLocation + 1
                                                SetGarbageRoute()
                                            else
                                                ESX.ShowNotification('Serviço Terminado, podes voltar à base!', 'inform')
                                                IsWorking = false
                                                terminado = true
                                                RemoveBlip(DeliveryBlip)
                                                SetRouteBack()
                                            end
                                            AmountOfBags = 0
                                            hasZak = false
                                        else
                                            AmountOfBags = AmountOfBags - 1
                                            if AmountOfBags > 1 then
                                                ESX.ShowNotification('Ainda faltam '..AmountOfBags..' passos!', 'inform')
                                            else
                                                ESX.ShowNotification('Ainda falta '..AmountOfBags..' algo!', 'inform')
                                            end
                                            hasZak = false
                                        end
                                        SetEntityHeading(GetPlayerPed(-1), DeliveryData.coords.h)
                                        DeliverAnim3()
                                    end
                                    if TruckDist < 10 then
                                        DrawText3D(Coords.x, Coords.y, Coords.z, "Realiza a Manutenção na Caixa")
                                    end
                                elseif Distance < 10 then
                                    DrawText3D2(DeliveryData.coords, "Realiza a Manutenção")
                                end
                            end
                        end
                    end
                end

            end
        end
        Citizen.Wait(otim)
    end
end)

function SetGarbageRoute()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local CurrentLocation = Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation]

    if DeliveryBlip ~= nil then
        RemoveBlip(DeliveryBlip)
    end

    DeliveryBlip = AddBlipForCoord(CurrentLocation.coords.x, CurrentLocation.coords.y, CurrentLocation.coords.z)
    SetBlipSprite(DeliveryBlip, 1)
    SetBlipDisplay(DeliveryBlip, 2)
    SetBlipScale(DeliveryBlip, 0.8)
    SetBlipAsShortRange(DeliveryBlip, false)
    SetBlipColour(DeliveryBlip, 27)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Locations[PlayerData.job.name..aleatoriedade123][GarbageLocation].name)
    EndTextCommandSetBlipName(DeliveryBlip)
    SetBlipRoute(DeliveryBlip, true)
end

function SetRouteBack()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local PlayerData = ESX.GetPlayerData()

    if PlayerData.job and PlayerData.job.name then
        local inleverpunt = Config.Locations[PlayerData.job.name .. "Vehicle2"]

        if inleverpunt then
            EndBlip = AddBlipForCoord(inleverpunt.coords.x, inleverpunt.coords.y, inleverpunt.coords.z)
            SetBlipSprite(EndBlip, 1)
            SetBlipDisplay(EndBlip, 2)
            SetBlipScale(EndBlip, 0.8)
            SetBlipAsShortRange(EndBlip, false)
            SetBlipColour(EndBlip, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName('Garagem')
            EndTextCommandSetBlipName(EndBlip)
            SetBlipRoute(EndBlip, true)
        else
            print("Localização de entrega não encontrada para o trabalho atual. ERRO 1")
        end
    else
        print("O jogador não possui trabalho definido. ERRO 2")
    end
end

function TakeAnim1()
    local ped = GetPlayerPed(-1)
    GarbageObject = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(GarbageObject, ped, GetPedBoneIndex(ped, 57005), 0.55, 0.0, 0, 0.0, 270.0, 0.0, true, true, false, true, 1, true)
end

function TakeAnim2()
    local ped = GetPlayerPed(-1)
    LoadAnimation('anim@heists@box_carry@')
    TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    GarbageObject = CreateObject(GetHashKey("hei_prop_heist_box"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(GarbageObject, ped, GetPedBoneIndex(ped, 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
    AnimCheck2()
end

function TakeAnim3()
    local ped = GetPlayerPed(-1)
    GarbageObject = CreateObject(GetHashKey("gr_prop_gr_tool_box_01a"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(GarbageObject, ped, GetPedBoneIndex(ped, 57005), 0.46, 0.0, 0.0, 0.0, 270.0, 60.0, true, true, false, true, 1, true)
end

function AnimCheck2()
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)
            if hasZak then
                if not IsEntityPlayingAnim(ped, 'anim@heists@box_carry@', 'idle', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('anim@heists@box_carry@')
                    TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                break
            end
            Citizen.Wait(200)
        end
    end)
end

function DeliverAnim1()
    local ped = GetPlayerPed(-1)
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(ped, GetEntityHeading(GarbageVehicle))
    CanTakeBag = false

    SetTimeout(1250, function()
        DetachEntity(GarbageObject, 1, false)
        DeleteObject(GarbageObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        GarbageObject = nil
        CanTakeBag = true
    end)
end

function DeliverAnim2()
    local ped = GetPlayerPed(-1)
    FreezeEntityPosition(ped, true)
    LoadAnimation('mp_common')
    DetachEntity(GarbageObject, 1, false)
    DeleteObject(GarbageObject)
    TaskPlayAnim(ped, 'mp_common', 'givetake1_a', 8.0, 1.0, 1100, 48, 0.0, 0, 0, 0)
    CanTakeBag = false
    SetTimeout(1250, function()
        FreezeEntityPosition(ped, false)
        GarbageObject = nil
        CanTakeBag = true
    end)
end

function DeliverAnim3()
    local ped = PlayerPedId()

    FreezeEntityPosition(ped, true)
    DetachEntity(GarbageObject, 1, false)

    Wait(100)

    CanTakeBag = false

    exports['progressbar']:Progress({
        name = "repair_garbage",
        duration = 20000,
        label = "A REPARAR",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@world_human_bum_wash@male@low@base",
            anim = "base",
            flags = 49,
        },
    }, function(cancelled)

        ClearPedTasks(ped)

        if not cancelled then
            AttachEntityToEntity(
                GarbageObject,
                ped,
                GetPedBoneIndex(ped, 57005),
                0.46,
                0.0,
                0.0,
                0.0,
                270.0,
                60.0,
                true,
                true,
                false,
                true,
                1,
                true
            )

            FreezeEntityPosition(ped, false)
            CanTakeBag = true

            exports['okokNotify']:Alert(
                'Lixo',
                'Está feito, podes prosseguir até à próxima paragem!',
                5000,
                'success'
            )
        else
            FreezeEntityPosition(ped, false)
            CanTakeBag = true
        end
    end)
end

function TakeAnim()
    local ped = GetPlayerPed(-1)
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
    GarbageObject = CreateObject(GetHashKey("prop_cs_rub_binbag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(GarbageObject, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.0, -0.05, 220.0, 120.0, 0.0, true, true, false, true, 1, true)
    AnimCheck()
end

function AnimCheck()
    Citizen.CreateThread(function()
        while true do
            local ped = GetPlayerPed(-1)
            if hasZak then
                if not IsEntityPlayingAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 3) then
                    ClearPedTasksImmediately(ped)
                    LoadAnimation('missfbi4prepp1')
                    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_walk_garbage_man', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
                end
            else
                break
            end
            Citizen.Wait(200)
        end
    end)
end

function DeliverAnim()
    local ped = GetPlayerPed(-1)
    LoadAnimation('missfbi4prepp1')
    TaskPlayAnim(ped, 'missfbi4prepp1', '_bag_throw_garbage_man', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
    FreezeEntityPosition(ped, true)
    SetEntityHeading(GetPlayerPed(-1), GetEntityHeading(GarbageVehicle))
    CanTakeBag = false

    SetTimeout(1250, function()
        DetachEntity(GarbageObject, 1, false)
        DeleteObject(GarbageObject)
        TaskPlayAnim(ped, 'missfbi4prepp1', 'exit', 8.0, 8.0, 1100, 48, 0.0, 0, 0, 0)
        FreezeEntityPosition(ped, false)
        GarbageObject = nil
        CanTakeBag = true
    end)
end

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        if GarbageObject ~= nil then
            DeleteEntity(GarbageObject)
            GarbageObject = nil
        end
    end
end)
