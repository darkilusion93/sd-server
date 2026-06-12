local ESX = nil
local login = false
local PlayerData = {}
local dentro = false
local popupativo = false
local popupativo2 = false
local estadochamada = false
local owner = 0
local cambiopin = false
local selfblock = {}
local garagem_entrada = false
local tentativa = 0
local id_armazem = 0

-- Tabela de mapeamento de teclas
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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- THREAD PRINCIPAL (Única necessária para os marcadores e interações)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distancia = #(coords - Config.Porta.loc)
        local distancia_g = #(coords - Config.PortaGaragem.loc)
        local maisperto = false
        
        if dentro == true then
            for k,v in pairs(Config.Armario) do 
                DrawMarker(20, v, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 255, 128, 0, 200, false, true, 2, true, false, false, false)
                if #(coords - v) < 1.0 then
                    maisperto = k
                end
            end
            
            DrawMarker(20, Config.Saida.loc, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 255, 0, 0, 200, false, true, 2, true, false, false, false)
            
            if maisperto == false then
                if #(coords - Config.Saida.loc) < 2.5 then
                    maisperto = 'sair'
                end
            end
            
            if maisperto ~= false then
                if popupativo2 == false then
                    if maisperto == 'sair' then
                        exports['okokTextUI']:Open('[E] Sair do Armazém', 'darkblue', 'left')
                        popupativo2 = true
                        popupativo = false          
                    else
                        exports['okokTextUI']:Open('[E] Abrir Armário', 'darkblue', 'left') 
                        popupativo2 = true
                        popupativo = false
                    end
                end

                if IsControlJustPressed(0, 38) then
                    if maisperto == 'sair' then
                        TriggerEvent('armazem:sair')                    
                    else
						print('armazem'..tostring(maisperto))
						TriggerEvent("cframework:removeWeaponsFromHandInstant")
						Citizen.Wait(150)
						TriggerEvent("cframework:openPropertyInventory", 'armazem'..tostring(maisperto))            
                    end             
                end
            elseif popupativo == true or popupativo2 == true then
                popupativo = false
                popupativo2 = false
                exports['okokTextUI']:Close()
            end
                    
        elseif distancia < 50 then
            DrawMarker(20, Config.Porta.loc, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 102, 0, 204, 200, false, true, 2, true, false, false, false)
            DrawMarker(36, Config.PortaGaragem.loc, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.3, 102, 0, 204, 200, false, true, 2, true, false, false, false)
            
            if distancia < 3 then
                if popupativo == false then
                    exports['okokTextUI']:Open('[E] Armazém', 'darkblue', 'left') 
                    popupativo = true
                    popupativo2 = false
                end
                
                if IsControlJustPressed(0, 38) then
                    armazem_opcoes(1)
                end
            elseif distancia_g < 5 then 
                if popupativo == false then
                    exports['okokTextUI']:Open('[E] Armazém | Acesso Veículos', 'darkblue', 'left') 
                    popupativo = true
                    popupativo2 = false
                end
                
                if IsControlJustPressed(0, 38) then
                    armazem_opcoes(2)
                end
            elseif popupativo == true then
                popupativo = false
                popupativo2 = false
                exports['okokTextUI']:Close()
            end

        elseif popupativo == true or popupativo2 == true then
            popupativo = false
            popupativo2 = false
            exports['okokTextUI']:Close()
        else
            Citizen.Wait(2000)
        end
    end
end)

RegisterNetEvent('esx_voice:call1')
AddEventHandler('esx_voice:call1', function(estado)
    estadochamada = estado
end)

RegisterNetEvent('armazem:safezone_carros')
AddEventHandler('armazem:safezone_carros', function()
    local safezone_carros = true
    local distance_carro = 0
    
    while safezone_carros == true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local veh = GetVehiclePedIsIn(playerPed)
        local coords = GetEntityCoords(playerPed)
        local distancia = #(coords - Config.PortaSaidaGaragem.loc)      
        
        if distancia > 8 then distance_carro = distance_carro + 1 end
        
        if veh == 0 or distance_carro > 30 then 
            safezone_carros = false
        else    
            local vehList = GetGamePool('CVehicle')
            for k,v in pairs(vehList) do
                local distance = #(Config.PortaSaidaGaragem.loc - GetEntityCoords(v)) 
                if distance < 10 and veh ~= v then
                    SetEntityNoCollisionEntity(v, veh, true)
                end
            end
        end
    end
end)

RegisterNetEvent('armazem:sair')
AddEventHandler('armazem:sair', function(id)
    DoScreenFadeOut(1000)   
    Citizen.Wait(1000)
    
    if garagem_entrada ~= false then
        if GetVehiclePedIsIn(GetPlayerPed(-1), false) == 0 then
            TriggerServerEvent('armazem:forcedelete', NetworkGetNetworkIdFromEntity(garagem_entrada))
            TriggerServerEvent('armazem:bucket', false, false, false)
            garagem_entrada = false
        end
        TriggerServerEvent('armazem:bucket', false, false, NetworkGetNetworkIdFromEntity(garagem_entrada))
    else
        TriggerServerEvent('armazem:bucket', false, false, false)
    end
    
    if garagem_entrada ~= false then
        TriggerServerEvent('armazem:setdimension', 0)
        NetworkFadeOutEntity(garagem_entrada, 1)
        SetPedCoordsKeepVehicle(PlayerPedId(),Config.PortaSaidaGaragem.loc)
        SetEntityHeading(garagem_entrada, Config.PortaSaidaGaragem.h)
        TriggerEvent('armazem:safezone_carros')
    else        
        TriggerServerEvent('armazem:setdimension', 0)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityCoords(PlayerPedId(), Config.Porta.loc)
        SetEntityHeading(PlayerPedId(), Config.Porta.h)
        FreezeEntityPosition(PlayerPedId(), false)
    end
    
    if estadochamada ~= true then
        TriggerEvent('esx_voice:call', false)
        NetworkClearVoiceChannel()
    end
    dentro = false
    id_armazem = 0          
    if garagem_entrada ~= false then
        Citizen.Wait(1000)
        NetworkFadeInEntity(garagem_entrada, 1, true)
        garagem_entrada = false
        Citizen.Wait(1000)
    end
    Citizen.Wait(1000)  
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('armazem:entrar')
AddEventHandler('armazem:entrar', function(id)
    DoScreenFadeOut(1000)   
    Citizen.Wait(1000)
    
    if garagem_entrada ~= false then
        TriggerServerEvent('armazem:bucket', true, id_armazem, NetworkGetNetworkIdFromEntity(garagem_entrada))
    else
        TriggerServerEvent('armazem:bucket', true, id_armazem, false)
    end
    
    TriggerEvent('armazem:create', id_armazem)
    
    if garagem_entrada ~= false then
        TriggerServerEvent('armazem:setdimension', source)
        NetworkFadeOutEntity(garagem_entrada, 1)
        SetPedCoordsKeepVehicle(PlayerPedId(),Config.SaidaCarro.loc)
        SetEntityHeading(garagem_entrada, Config.Saida.h)
        NetworkFadeInEntity(garagem_entrada, 1, true)
    else
        TriggerServerEvent('armazem:setdimension', source)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityCoords(PlayerPedId(), Config.Saida.loc)
        SetEntityHeading(PlayerPedId(), Config.Saida.h)
        FreezeEntityPosition(PlayerPedId(), false)
    end
    
    if estadochamada ~= true then
        TriggerEvent('esx_voice:call', true)
        Citizen.Wait(10)
        NetworkSetVoiceChannel(id_armazem + 60000)
        MumbleClearVoiceTarget(2)
        MumbleClearVoiceTargetChannels(2)
        MumbleClearVoiceTargetPlayers(2)
        MumbleAddVoiceTargetChannel(2, id_armazem + 60000)
        MumbleSetVoiceTarget(2)
    end
    dentro = true
    Citizen.Wait(1000)  
    DoScreenFadeIn(1000)
    TriggerEvent('armazem:safeguard')
end)

function armazem_opcoes(status_tech)
    if login == false then
        login = true
        exports['okokNotify']:Alert('ARMAZÉM', 'A carregar o armazem, aguarda...', 3000, 'info')
        TriggerServerEvent('armazem:login')
        Citizen.Wait(3000)
    end
    
    ESX.UI.Menu.CloseAll()
    local elements = {}
    if status_tech == 1 then
        if owner == 0 then
            elements = {
                {label = 'Comprar Armazém (400000€)',    value = 'comprar'},
                {label = 'Entrar em Armazém',           value = 'entrar'},
            }   
        else
            elements = {
                {label = 'Entrar no teu Armazém',       value = 'self'},
                {label = 'Entrar em Armazém',           value = 'entrar'},
                {label = 'Mudar o PIN do teu Armazém',  value = 'pin'},
            }   
        end
    elseif status_tech == 2 then
        if owner == 0 then
            elements = {
                {label = 'Comprar Armazém (400000€)',    value = 'comprar'},
            }   
        else
            elements = {
                {label = 'Entrar no teu Armazém com Carro',   value = 'self_garagem'},
                {label = 'Mudar o PIN do teu Armazém',  value = 'pin'},
            }   
        end 
    end
    cambiopin = false
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'paleto',
    {
        title    = 'Armazém',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        
        if data.current.value == 'self' or data.current.value == 'self_garagem' or data.current.value == 'entrar' then
            local coordsEXP = GetEntityCoords(PlayerPedId())
            local distancia_blips_exploit_a = #(coordsEXP - Config.Porta.loc)
            local distancia_blips_exploit_b = #(coordsEXP - Config.PortaGaragem.loc)        
            
            if distancia_blips_exploit_a > 10 and distancia_blips_exploit_b > 10 then
                ESX.UI.Menu.CloseAll()
                return
            end
        end
        
        if data.current.value == 'self' then 
                tentativa = owner
                TriggerEvent('armazem:toggleField', true)
                ESX.UI.Menu.CloseAll()
                
        elseif data.current.value == 'self_garagem' then 
                if GetVehiclePedIsIn(GetPlayerPed(-1), false) ~= 0 then
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                    local freeSeat = nil
                    local vehicleplate = GetVehicleNumberPlateText(vehicle)
                    local blacklist = GetHashKey('mbhome')
                    
                    if string.sub(vehicleplate, 4, 4) == ' ' and not IsVehicleModel(vehicle, blacklist) then
                        for i=maxSeats - 1, 0, -1 do
                            if not IsVehicleSeatFree(vehicle, i) then
                                freeSeat = i
                            end
                        end
                        
                        if freeSeat == nil and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
                            tentativa = owner
                            TriggerEvent('armazem:toggleField', true, vehicle)
                            ESX.UI.Menu.CloseAll()
                        else
                            exports['okokNotify']:Alert("ARMAZÉM", "O veículo não pode ter passageiros!", 3000, 'error')
                            ESX.UI.Menu.CloseAll()
                        end
                    else
                        exports['okokNotify']:Alert("ARMAZÉM", "Este veículo não pode entrar aqui!", 3000, 'error')
                        ESX.UI.Menu.CloseAll()
                    end
                else
                    exports['okokNotify']:Alert("ARMAZÉM", "Entrada exclusiva de viaturas", 3000, 'error')
                    ESX.UI.Menu.CloseAll()
                end
                
        elseif data.current.value == 'entrar' then 
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                title = 'NIF do Proprietário'
            }, function(data, menu)
                local amount = tonumber(data.value)
                if amount == nil or amount < 0 or amount > 1000000000 then
                    exports['okokNotify']:Alert("ARMAZÉM", "NIF Inválido", 3000, 'error')
                else
                    tentativa = tostring(tonumber(data.value))
                    if selfblock[tentativa] ~= nil then
                        if selfblock[tentativa] > 2 then
                            exports['okokNotify']:Alert("ARMAZÉM", "Acesso bloqueado devido a várias tentativas", 3000, 'error')
                            ESX.UI.Menu.CloseAll()
                            return
                        end
                    end                 
                    TriggerEvent('armazem:toggleField', true)
                    ESX.UI.Menu.CloseAll()
                end
            end, function(data, menu)
                menu.close()
            end)
        
        elseif data.current.value == 'comprar' then
            TriggerServerEvent('armazem:comprar')
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == 'pin' then
            cambiopin = true
            tentativa = owner
            TriggerEvent('armazem:toggleField', true)
            ESX.UI.Menu.CloseAll()
        end
    end, function(data, menu)
        menu.close()
    end)    
end

RegisterNetEvent('armazem:safeguard')
AddEventHandler('armazem:safeguard', function()
    Citizen.Wait(3000)
    while dentro == true do
        Citizen.Wait(3000)
        if #(GetEntityCoords(PlayerPedId()) - Config.Armario[1]) > 25 and dentro == true then
            Citizen.Wait(1000)
            if dentro == true then
                exports['okokNotify']:Alert("ARMAZÉM", "Algo de errado aconteceu!", 5000, 'error')
                TriggerEvent('armazem:sair')
            end
        end
    end
end)

RegisterNetEvent('armazem:resultado')
AddEventHandler('armazem:resultado', function(dados, valor, valorb)
    if dados == 'pin' then
        exports['okokNotify']:Alert("ARMAZÉM", "PIN do Armazém alterado para: "..valor, 3000, 'success')
    elseif dados == 'comprado' then
        exports['okokNotify']:Alert("ARMAZÉM", "Armazém Comprado! O teu PIN de acesso é: "..valor..'. Tal pode ser alterado a qualquer momento.', 10000, 'success')
        owner = valorb
    elseif dados == 'spawn' then
        owner = owner
        login = true
        if #(GetEntityCoords(PlayerPedId()) - Config.Armario[2]) < 22 and dentro == false then
            if dentro == false then
                SetEntityCoords(PlayerPedId(), Config.Porta.loc)
                exports['okokNotify']:Alert("ARMAZÉM", "Saiste do servidor dentro do armazém! Para evitar problemas, sai sempre do armazém antes de sair do servidor!", 10000, 'error')
            end
        else
            id_armazem = valorb
            print(id_armazem)
            TriggerServerEvent('armazem:setdimension', id_armazem)
            SetEntityCoords(PlayerPedId(), Config.Saida.loc)
            dentro = true
        end
    elseif dados == 'sucesso' then
        id_armazem = valorb
        TriggerEvent('armazem:entrar',valorb)
    elseif dados == 'embargo' then
        exports['okokNotify']:Alert("ARMAZÉM", "Este armazém está embargado visto que o dono está banido.", 3000, 'error')
    elseif dados == 'errado' then
        exports['okokNotify']:Alert("ARMAZÉM", "PIN ERRADO!", 3000, 'error')
        if selfblock[valor] == nil then
            selfblock[valor] = 0
        end
        selfblock[valor] = selfblock[valor] + 1
        PlaySoundFrontend(-1, "DLC_VW_ERROR_MAX", "dlc_vw_table_games_frontend_sounds", true)
        Citizen.Wait(400)
        PlaySoundFrontend(-1, "DLC_VW_ERROR_MAX", "dlc_vw_table_games_frontend_sounds", true)
    elseif dados == "reload" then
        owner = valor
    end
end)

RegisterNetEvent('armazem:toggleField')
AddEventHandler('armazem:toggleField', function(enable, modotipo)
  if modotipo ~= nil then
    garagem_entrada = modotipo
  else
    garagem_entrada = false
  end
  SetNuiFocus(enable, enable)
  SendNUIMessage({
    type = "enableui",
    enable = enable
  })
end)

RegisterNUICallback('escape', function(data, cb)  
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('try', function(data, cb)
    SetNuiFocus(false, false)
    local code = tostring(data.code)
    if #code < 4 then
        exports['okokNotify']:Alert("ARMAZÉM", "PIN Inválido - Tem de ter pelo menos 4 dígitos!", 3000, 'error')
    else
        if cambiopin == true and tentativa == owner then
            TriggerServerEvent('armazem:alterarpin', owner, code)
        else
            TriggerServerEvent('armazem:check', owner, code)
        end
    end
    cb('ok')
end)

RegisterNetEvent('armazem:notificacao')
AddEventHandler('armazem:notificacao', function(pin)
    exports['okokNotify']:Alert("ARMAZÉM", "Alteraste o PIN do teu armazem para: "..pin, 3000, 'success')
end)

RegisterNetEvent('dimensaoDoJogador')
AddEventHandler('dimensaoDoJogador', function(dimension)
    print("A dimensão do jogador é: " .. dimension)
end)
