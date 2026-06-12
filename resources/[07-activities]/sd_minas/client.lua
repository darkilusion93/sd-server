local ESX = exports['cframework']:getSharedObject()

local estaMinerando = false
local emPausa = false
local ultimoUsoBritadeira = 0
local tempoEsperaBritadeira = Config.MiningDelay
local listaPedsFuncoes = {}
local npcFuncionarioExiste = false
local menuAberto = false

-- ==========================================
-- FUNÇÕES DE MINERAÇÃO
-- ==========================================

function PararMineracao()
    TriggerServerEvent("sd_minas:pararEntrega")
    estaMinerando = false
    ClearPedTasksImmediately(PlayerPedId())
    ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 3.0, 0)
    FreezeEntityPosition(PlayerPedId(), false)
end

function IniciarMineracao()
    local jogador = PlayerPedId()
    
    if IsPedOnFoot(jogador) then
        estaMinerando = true
        
        -- Inicia animação
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)
        FreezeEntityPosition(PlayerPedId(), true)
        
        Citizen.CreateThread(function()
            local tempoInicio = GetGameTimer()
            local duracao = 5000
            emPausa = true
            
            -- Primeira perfuração
            TriggerServerEvent("sd_minas:iniciarMineracao")
            
            while true do
                if not estaMinerando then break end
                
                ESX.ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para cancelar.")
                
                if IsControlJustReleased(0, 38) or IsControlJustReleased(0, 73) then
                    if estaMinerando then
                        PararMineracao()
                        Citizen.Wait(3000)
                        emPausa = false
                    end
                end
                
                -- Se o tempo esgotou, recompensa e começa de novo
                if GetGameTimer() - tempoInicio >= duracao then
                    tempoInicio = GetGameTimer()
                    ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 3.0, 0)
                    TriggerServerEvent("sd_minas:iniciarMineracao")
                end
                
                Citizen.Wait(0)
            end
        end)
    else
        ESX.ShowNotification("Tens de estar em pé.", "error")
        estaMinerando = false
    end
end

-- ==========================================
-- THREAD DOS MARCADORES DE MINA
-- ==========================================
Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local coordsJogador = GetEntityCoords(PlayerPedId())
        
        for i, ponto in ipairs(Config.BlipsMinerar) do
            local distancia = #(coordsJogador - ponto.Coordenada)
            
            if distancia < 20 then
                sleep = 0
                DrawMarker(20, ponto.Coordenada, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 0, 154, 255, 200, false, true, 2, true, false, false, false)
            end
            
            if distancia < 1.5 then
                if not estaMinerando then
                    ESX.ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para minerar.")
                    
                    if IsControlJustReleased(0, 38) then
                        if not emPausa then
                            emPausa = true
                            if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                if VerificarUniformeMineracao() then
                                    if GetGameTimer() - ultimoUsoBritadeira >= tempoEsperaBritadeira then
                                        IniciarMineracao()
                                        ultimoUsoBritadeira = GetGameTimer()
                                        Citizen.Wait(4500)
                                        emPausa = false
                                    else
                                        ESX.ShowNotification("A britadeira está a aquecer. Aguarda!")
                                        Citizen.Wait(5000)
                                        emPausa = false
                                    end
                                else
                                    ESX.ShowNotification("Precisas de usar o uniforme de mineração. Fala com o Richard.", "error")
                                    Citizen.Wait(4500)
                                    emPausa = false
                                end
                            end
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- ==========================================
-- EVENTOS
-- ==========================================
RegisterNetEvent("sd_minas:acabarMinar")
AddEventHandler("sd_minas:acabarMinar", function()
    PararMineracao()
    emPausa = false
end)

-- ==========================================
-- NPC E LOJA
-- ==========================================
function VerificarUniformeMineracao()
    local jogador = PlayerPedId()
    local modeloJogador = GetEntityModel(jogador)
    local modeloFeminino = GetHashKey("mp_f_freemode_01")
    
    local genero = "male"
    if modeloJogador == modeloFeminino then genero = "female" end
    
    local componentePeito = GetPedDrawableVariation(jogador, 8)
    local texturaPeito = GetPedTextureVariation(jogador, 8)
    local componenteTorso = GetPedDrawableVariation(jogador, 11)
    local texturaTorso = GetPedTextureVariation(jogador, 11)
    local capacete = GetPedPropIndex(jogador, 0)
    local calcas = GetPedDrawableVariation(jogador, 4)
    local texturaCalcas = GetPedTextureVariation(jogador, 4)
    
    local uniformeCorreto = false
    
    if genero == "male" then
        if componentePeito == 59 and texturaPeito == 0 and
           componenteTorso == 273 and texturaTorso == 1 and
           capacete == 145 and
           calcas == 97 and texturaCalcas == 0 then
            uniformeCorreto = true
        end
    elseif genero == "female" then
        if componentePeito == 36 and texturaPeito == 0 and
           componenteTorso == 49 and texturaTorso == 1 and
           capacete == 144 and
           calcas == 100 and texturaCalcas == 0 then
            uniformeCorreto = true
        end
    end
    
    return uniformeCorreto
end

function AbrirMenuNPC()
    local opcoes = {
        { label = "👕 Uniforme de Mineração", value = "uniforme_mina" },
        { label = "⛏️ Drogaria da Mina", value = "loja_mina" }
    }

    TriggerEvent('chud:menu', opcoes, "Mina", function(value)
        if value == 'uniforme_mina' then
            if not VerificarUniformeMineracao() then
                TriggerEvent("skinchanger:getSkin", function(skin)
                    if skin.sex == 0 then
                        TriggerEvent("skinchanger:loadClothes", skin, Config.Uniformes.Trabalhador.male)
                    else
                        TriggerEvent("skinchanger:loadClothes", skin, Config.Uniformes.Trabalhador.female)
                    end
                end)
            else
                ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
                    TriggerEvent("skinchanger:loadSkin", skin)
                end)
            end
        end

        if value == 'loja_mina' then
            TriggerEvent("esx_inventoryhud:openShop", "Mina", Config.BuyMenu, "cash")
        end
    end)
end

function CriarPedFuncoes(x, y, z, heading)
    if not npcFuncionarioExiste then
        npcFuncionarioExiste = true
        
        RequestModel("ig_joeminuteman")
        while not HasModelLoaded("ig_joeminuteman") do
            Citizen.Wait(500)
        end
        
        local ped = CreatePed(4, "ig_joeminuteman", x, y, z, 0.0, false, false)
        SetEntityHeading(ped, heading)
        SetPedDiesWhenInjured(ped, false)
        SetEntityCanBeDamaged(ped, false)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        
        table.insert(listaPedsFuncoes, { pedSalvo = ped })
    end
end

function RemoverPedsFuncoes()
    for i = #listaPedsFuncoes, 1, -1 do
        if DoesEntityExist(listaPedsFuncoes[i].pedSalvo) then
            DeleteEntity(listaPedsFuncoes[i].pedSalvo)
            DeletePed(listaPedsFuncoes[i].pedSalvo)
            npcFuncionarioExiste = false
        end
    end
end

AddEventHandler("onResourceStop", function(nomeRecurso)
    if GetCurrentResourceName() == nomeRecurso then
        RemoverPedsFuncoes()
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local coordsJogador = GetEntityCoords(PlayerPedId())
        local coordsNPC = vector3(Config.NPC_Funcoes.x, Config.NPC_Funcoes.y, Config.NPC_Funcoes.z)
        local distancia = #(coordsJogador - coordsNPC)
        
        if distancia < 15 then
            sleep = 0
            CriarPedFuncoes(Config.NPC_Funcoes.x, Config.NPC_Funcoes.y, Config.NPC_Funcoes.z, Config.NPC_Funcoes.h)
        else
            if npcFuncionarioExiste then
                RemoverPedsFuncoes()
            end
        end
        
        if distancia < 2 then
            if not estaMinerando then
                ESX.ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para falar com o Richard.")
                if IsControlJustReleased(0, 38) then
                    if not menuAberto then
                        menuAberto = true
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            AbrirMenuNPC()
                            Citizen.Wait(3000)
                            menuAberto = false
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)
