ESX = exports['cframework']:getSharedObject()

local emServico = false
local cooldowns = {}
local trashProps = {}
local aVasculhar = false
local lojaMenuAberto = false
local estouareciclar = false

-- ==================== FUNÇÕES ====================

local function abrirUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        status = true,
        catalogo = Config.LojaItems
    })
end

local function colocarUniformeAuto()
    print("[sd-reciclagem] Iniciando colocarUniformeAuto...")
    TriggerEvent('skinchanger:getSkin', function(skin)
            print("[sd-reciclagem] Callback skinchanger:getSkin executado com sucesso!")
            local uniforme

            if skin.sex == 0 then
                uniforme = Config.Uniformes.Trabalhador.male
            else
                uniforme = Config.Uniformes.Trabalhador.female
            end

            TriggerEvent('skinchanger:loadClothes', skin, uniforme)

        emServico = true

        ESX.ShowNotification('Começaste a trabalhar na reciclagem!')
    end)
end

local function colocarUniforme()
    colocarUniformeAuto()
end

local function tirarUniforme()
    print("[sd-reciclagem] Iniciando tirarUniforme...")
    emServico = false
    exports['okokTextUI']:Close()

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        print("[sd-reciclagem] Callback esx_skin:getPlayerSkin executado!")
        if skin then
            TriggerEvent('skinchanger:loadSkin', skin)
            ESX.ShowNotification("Tiraste o uniforme de trabalho.")
        else
            ESX.ShowNotification("Não foi possível restaurar a tua roupa.")
        end
    end)
end

local controlpressed = false

local function colocarLixo(pos)
    if estouareciclar then return end

    local playerPed = PlayerPedId()
    local propName = `prop_cs_rub_binbag_01`
    local bagObj = nil

    estouareciclar = true
    FreezeEntityPosition(playerPed, true)

    RequestModel(propName)
    while not HasModelLoaded(propName) do Wait(10) end

    RequestAnimDict('anim@heists@box_carry@')
    while not HasAnimDictLoaded('anim@heists@box_carry@') do Wait(10) end

    TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 51, 0.0, false, false, false)

    bagObj = CreateObject(propName, 0.0, 0.0, 0.0, false, true, false)
    AttachEntityToEntity(
        bagObj,
        playerPed,
        GetPedBoneIndex(playerPed, 60309),
        -0.05, 0.35, 0.15,
        0.0, 0.0, 0.0,
        true, false, false, false, 2, true
    )

    local success = lib.progressBar({
        duration = 2000,
        label = 'A colocar o saco do lixo...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            sprint = true,
            mouse = false
        },
        anim = {
            dict = 'anim@heists@box_carry@',
            clip = 'idle',
            flags = 51
        }
    })

    if DoesEntityExist(bagObj) then
        DeleteEntity(bagObj)
    end

    ClearPedTasksImmediately(playerPed)
    FreezeEntityPosition(playerPed, false)
    estouareciclar = false
    controlpressed = false

    if not success then return end

    local trashProp = CreateObject(`prop_cs_rub_binbag_01`, pos.x, pos.y, pos.z - 1.0, false, true, true)
    PlaceObjectOnGroundProperly(trashProp)
    FreezeEntityPosition(trashProp, true)
    table.insert(trashProps, trashProp)


    Citizen.SetTimeout(30000, function()
        if DoesEntityExist(trashProp) then
            DeleteEntity(trashProp)
        end

        for i, prop in ipairs(trashProps) do
            if prop == trashProp then
                table.remove(trashProps, i)
                break
            end
        end

        RPC.execute('reciclagem:recompensaSacosLixo')
    end)
end



CreateThread(function()
    local currentTarget = 1
    local textUIActive = false

    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if emServico then
            sleep = 0
            local pos = Config.PosicoesLixo[currentTarget]

            DrawMarker(20, pos.x, pos.y, pos.z + 0.3, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 0, 154, 255, 200, false, true, 2, true, false, false, false)

            local shouldShowUI = #(playerCoords - pos) < 2.5

            if shouldShowUI and not textUIActive then
                exports['okokTextUI']:Open('[E] Colocar Lixo', 'darkblue', 'left', true)
                textUIActive = true
            elseif not shouldShowUI and textUIActive then
                exports['okokTextUI']:Close()
                textUIActive = false
            end

            if shouldShowUI and IsControlJustReleased(0, 38) and not controlpressed then
                exports['okokTextUI']:Close()
                textUIActive = true
                controlpressed = true
                shouldShowUI = false

                ESX.TriggerServerCallback('reciclagem:temQuantidadeItem', function(hasItem)
                    if hasItem then
                        colocarLixo(pos)
                        RPC.execute('reciclagem:removerSacosLixo')
                        ESX.ShowNotification("Lixos pousados, aguarda para receberes os items.")

                        currentTarget = currentTarget + 1
                        if currentTarget > #Config.PosicoesLixo then
                            currentTarget = 1
                        end
                        shouldShowUI = true
                        false
                    else
                        ESX.ShowNotification("Não tens sacos de lixo")
                        shouldShowUI = true
                        textUIActive = false
                    end
                end, 'sacolixo', 1)
            end
        else
            if textUIActive then
                exports['okokTextUI']:Close()
                textUIActive = false
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    local chicoPed = nil
    local chicoCriado = false
    local textUIActive = false

    local function criarChico()
        if not chicoCriado then
            local modelHash = joaat(Config.NPCModels.Chico)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(100)
                RequestModel(modelHash)
            end

            chicoPed = CreatePed(
                4,
                modelHash,
                Config.ChicoCoordenadas.x,
                Config.ChicoCoordenadas.y,
                Config.ChicoCoordenadas.z,
                Config.ChicoCoordenadas.h,
                false,
                true
            )

            --SetEntityHeading(chicoPed, Config.ChicoCoordenadas.h or 210.0)
            SetPedDiesWhenInjured(chicoPed, false)
            SetEntityCanBeDamaged(chicoPed, false)
            SetBlockingOfNonTemporaryEvents(chicoPed, true)
            FreezeEntityPosition(chicoPed, true)
            SetEntityInvincible(chicoPed, true)
            chicoCriado = true
        end
    end

    local function removerChico()
        if chicoCriado and DoesEntityExist(chicoPed) then
            DeleteEntity(chicoPed)
            chicoCriado = false
            chicoPed = nil
        end
    end

    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = #(coords - vector3(Config.ChicoCoordenadas.x, Config.ChicoCoordenadas.y, Config.ChicoCoordenadas.z))

        if distance < 50 then
            criarChico()
        else
            removerChico()
            if textUIActive then
                exports['okokTextUI']:Close()
                textUIActive = false
            end
        end

        local shouldShowUI = distance < 2.5

        if shouldShowUI then
            sleep = 0
            if not textUIActive then
                exports['okokTextUI']:Open('[E] Falar com o Chico', 'darkblue', 'left', true)
                textUIActive = true
            end
        elseif not shouldShowUI and textUIActive then
            exports['okokTextUI']:Close()
            textUIActive = false
        end

        if shouldShowUI and IsControlJustReleased(0, 38) then
            exports['okokTextUI']:Close()
            textUIActive = false

            if not IsPedSittingInAnyVehicle(playerPed) then
                if emServico then
                    tirarUniforme()
                else
                    colocarUniformeAuto()
                end
            end
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    local lojaNPC = nil
    local lojaNPCCriado = false
    local textUIActive = false
    local podeAbrirLoja = false

    local function criarLojaNPC()
        if not lojaNPCCriado then
            local modelHash = joaat(Config.NPCModels.Loja)
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do Wait(100) end

            lojaNPC = CreatePed(4, modelHash, Config.LojaCoordenadas.x, Config.LojaCoordenadas.y, Config.LojaCoordenadas.z, Config.LojaCoordenadas.h, false, true)
            --SetEntityHeading(lojaNPC, Config.LojaCoordenadas.h)
            SetPedDiesWhenInjured(lojaNPC, false)
            SetEntityCanBeDamaged(lojaNPC, false)
            SetBlockingOfNonTemporaryEvents(lojaNPC, true)
            FreezeEntityPosition(lojaNPC, true)
            SetEntityInvincible(lojaNPC, true)

            RequestAnimDict("anim@heists@box_carry@")
            while not HasAnimDictLoaded("anim@heists@box_carry@") do Wait(10) end
            TaskPlayAnim(lojaNPC, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 1, 0.0, false, false, false)

            lojaNPCCriado = true
        end
    end

    local function removerLojaNPC()
        if lojaNPCCriado and DoesEntityExist(lojaNPC) then
            DeleteEntity(lojaNPC)
            lojaNPCCriado = false
            lojaNPC = nil
        end
    end

    exports.ft_libs:RemoveMarker("LojaReciclagem")

    exports.ft_libs:AddMarker("LojaReciclagem", {type = 50, x = 168.1019, y = 6392.7661, z = 30.4792+1,red = 145, green = 187, blue = 255, showDistance = 25})

    while true do
        local sleep = 1000
        local coords = GetEntityCoords(PlayerPedId())
        local distance = #(coords - vector3(Config.LojaCoordenadas.x, Config.LojaCoordenadas.y, Config.LojaCoordenadas.z))

        if distance < 30 then
            criarLojaNPC()
        else
            removerLojaNPC()
        end

        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        Wait(1000)

        if lojaMenuAberto then
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - vector3(Config.LojaCoordenadas.x, Config.LojaCoordenadas.y, Config.LojaCoordenadas.z))

            if distance > 5 then
                SetNuiFocus(false, false)
                SendNUIMessage({ status = false })
                lojaMenuAberto = false
                ESX.ShowNotification("Loja fechada por estar muito longe.")
            end
        end
    end
end)

CreateThread(function()
    local recycleBlip = AddBlipForCoord(Config.Reciclagem.x, Config.Reciclagem.y, Config.Reciclagem.z)
    SetBlipSprite(recycleBlip, 365)
    SetBlipColour(recycleBlip, 2)
    SetBlipScale(recycleBlip, 1.2)
    SetBlipAsShortRange(recycleBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Reciclagem')
    EndTextCommandSetBlipName(recycleBlip)

    -- local lojaBlip = AddBlipForCoord(Config.LojaCoordenadas.x, Config.LojaCoordenadas.y, Config.LojaCoordenadas.z)
    -- SetBlipSprite(lojaBlip, 52)
    -- SetBlipColour(lojaBlip, 2)
    -- SetBlipScale(lojaBlip, 0.8)
    -- SetBlipAsShortRange(lojaBlip, true)
    -- BeginTextCommandSetBlipName('STRING')
    -- AddTextComponentSubstringPlayerName('Loja de Reciclagem')
    -- EndTextCommandSetBlipName(lojaBlip)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        exports['okokTextUI']:Close()

        for _, prop in ipairs(trashProps) do
            if DoesEntityExist(prop) then
                DeleteEntity(prop)
            end
        end

        trashProps = {}
    end
end)

-- ==================== EVENTOS ====================

RegisterNetEvent('reciclagem:reciclarAnim')
AddEventHandler('reciclagem:reciclarAnim', function()
    local ped = PlayerPedId()
    estouareciclar = true
    FreezeEntityPosition(ped, true)

    RequestAnimDict("anim@am_hold_up@male")
    while not HasAnimDictLoaded("anim@am_hold_up@male") do Wait(100) end

    lib.progressBar({
        duration = 1700,
        label = 'A reciclar...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            sprint = true,
            mouse = false
        },
        anim = {
            dict = "anim@am_hold_up@male",
            clip = "shoplift_mid",
            flags = 0
        }
    })

    estouareciclar = false
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
end)

-- ==================== NUI CALLBACKS ====================

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ status = false })
    lojaMenuAberto = false
    cb({})
end)

RegisterNUICallback('reciclar', function(data, cb)
    TriggerServerEvent('reciclagem:reciclar', data.itemData)
    TriggerEvent('reciclagem:reciclarAnim')
    SetNuiFocus(false, false)
    SendNUIMessage({ status = false })
    lojaMenuAberto = false
    cb({})
end)

