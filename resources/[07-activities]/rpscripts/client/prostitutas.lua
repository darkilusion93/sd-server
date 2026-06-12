local isHookerThreadActive = false
local isUsingHooker = false
local disableVehicleControls = false
local hookerModels = Config.HookerPedModels
local hasPayed = nil

local PLAYER_ID <const> = PlayerId()

-- Vehicle controls that will get disabled while interacting with a hooker in your car
local VEHICLE_CONTROLS <const> = {
    [59] = true, -- INPUT_VEH_MOVE_LR
    [60] = true, -- INPUT_VEH_MOVE_UD
    [61] = true, -- INPUT_VEH_MOVE_UP_ONLY
    [62] = true, -- INPUT_VEH_MOVE_DOWN_ONLY
    [63] = true, -- INPUT_VEH_MOVE_LEFT_ONLY
    [64] = true, -- INPUT_VEH_MOVE_RIGHT_ONLY
    [71] = true, -- INPUT_VEH_ACCELERATE
    [72] = true, -- INPUT_VEH_BRAKE
    [73] = true, -- INPUT_VEH_DUCK
    [86] = true  -- INPUT_VEH_HORN
}


-- Utils --
local function DisplayHelpText(msg)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(0, false, true, 50)
end

local function DisplayHint(msg, time)
	CreateThread(function()
        local endTime = GetGameTimer() + time
        while GetGameTimer() < endTime do
            DisplayHelpText(msg)
            Wait(0)
        end
        ClearHelp(true)
    end)
end

local function DisplayNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, true)
end

local function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function GetPedGender(ped)
    if GetEntityModel(ped) == `mp_f_freemode_01` then
        return "female"
    else
        return "male"
    end
end


-- Checkers/Getters Functions --
local function GetNearbyPeds()
	local handle, ped = FindFirstPed()
	local success = false
	local peds = {}
	repeat
		peds[#peds+1] = ped
		success, ped = FindNextPed(handle)
	until not success
	EndFindPed(handle)
	return peds
end

local function IsPedEligibleHooker(ped)
    local pedModel = GetEntityModel(ped)
    if not hookerModels[pedModel] then
        return false
    end

    if IsPedInjured(ped) then
        return false
    end

    if IsPedInAnyVehicle(ped, true) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    return true
end

local function CanVehiclePickUpHookers(vehicle)
    if not IsVehicleDriveable(vehicle, false) then
        return false
    end

    local class = GetVehicleClass(vehicle)
    if Config.BlackListedVehicleClasses[class] then
        return false
    end

    local model = GetEntityModel(vehicle)
    if Config.BlackListedVehicles[model] then
        return false
    end

    return true
end


-- Audio --
local function PlayHookerSpeach(hooker, speechName, speechParam)
    if not IsAnySpeechPlaying(hooker) then
        PlayPedAmbientSpeechNative(hooker, speechName, speechParam)
    end
end


-- AI Behavior --
local function MakeHookerCalm(hooker)
    local _void, groupHash = AddRelationshipGroup("ProstituteInPlay")
    SetRelationshipBetweenGroups(1, groupHash, `PLAYER`)
    SetPedRelationshipGroupHash(hooker, groupHash)

    SetPedConfigFlag(hooker, 26, true)            -- CPED_CONFIG_FLAG_DontDragMeOutCar
    SetPedConfigFlag(hooker, 115, true)           -- CPED_CONFIG_FLAG_FallOutOfVehicleWhenKilled
    SetPedConfigFlag(hooker, 229, true)           -- CPED_CONFIG_FLAG_DisablePanicInVehicle 
    SetBlockingOfNonTemporaryEvents(hooker, true) -- Makes the hooker not react to everything around them
end

local function ResetHookerCalm(hooker)
    SetPedConfigFlag(hooker, 26, false)            -- CPED_CONFIG_FLAG_DontDragMeOutCar
    SetPedConfigFlag(hooker, 115, false)           -- CPED_CONFIG_FLAG_FallOutOfVehicleWhenKilled
    SetPedConfigFlag(hooker, 229, false)           -- CPED_CONFIG_FLAG_DisablePanicInVehicle 
    SetBlockingOfNonTemporaryEvents(hooker, false) -- Makes the hooker not react to everything around them
end


-- Other Functions --
local function IsInSecludedArea(hooker, vehicle)
    local vehicleSpeed = GetEntitySpeed(vehicle)
    if vehicleSpeed >= Config.MaxVehicleSpeed then
        return false
    end

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    local hasLineOfSight = false
    for _index, ped in pairs(GetNearbyPeds()) do
        if ped ~= playerPed and ped ~= hooker and GetPedType(ped) ~= 28 then
            if HasEntityClearLosToEntity(ped, vehicle, 17) then
                if #(coords - GetEntityCoords(ped)) < 75.0 then
                    hasLineOfSight = true
                end
            end
        end
    end

    if hasLineOfSight then
        return false
    end

    return true
end

local function PlaySexSceneAnim(hooker, playerPed, hookerAnim, playerAnim, flag, wait)
    local animTime = GetAnimDuration("mini@prostitutes@sexnorm_veh", hookerAnim) * 1000
    TaskPlayAnim(hooker, "mini@prostitutes@sexnorm_veh", hookerAnim, 2.0, 2.0, animTime, flag, 0.0, false, false, false)
    TaskPlayAnim(playerPed, "mini@prostitutes@sexnorm_veh", playerAnim, 2.0, 2.0, animTime, flag, 0.0, false, false, false)

    if wait then
        Wait(animTime)
    end
end

local function PlaySexScene(scene, hooker, vehicle)
    local playerPed = PlayerPedId()
    local playerGender = GetPedGender(playerPed)
    local timer = 8
    local speach = {}
    local animation = {
        hooker = {},
        player = {}
    }

    speach.param = "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR"

    if scene == "SERVICE_BLOWJOB" then
        if playerGender == "male" then
            speach.name = "SEX_ORAL"
        else
            speach.name = "SEX_ORAL_FEM"
        end

        timer = 4

        -- Hooker anims
        animation.hooker.enter1 = "proposition_to_BJ_p1_prostitute"
        animation.hooker.enter2 = "proposition_to_BJ_p2_prostitute"
        animation.hooker.loop = "BJ_loop_prostitute"
        animation.hooker.exit1 = "BJ_to_proposition_p1_prostitute"
        animation.hooker.exit2 = "BJ_to_proposition_p2_prostitute"

        -- Player anims
        animation.player.enter1 = "proposition_to_BJ_p1_male"
        animation.player.enter2 = "proposition_to_BJ_p2_male"
        animation.player.loop = "BJ_loop_male"
        animation.player.exit1 = "BJ_to_proposition_p1_male"
        animation.player.exit2 = "BJ_to_proposition_p2_male"
    else
        if playerGender == "male" then
            speach.name = "SEX_GENERIC"
        else
            speach.name = "SEX_GENERIC_FEM"
        end

        -- Hooker anims
        animation.hooker.enter1 = "proposition_to_sex_p1_prostitute"
        animation.hooker.enter2 = "proposition_to_sex_p2_prostitute"
        animation.hooker.loop = "sex_loop_prostitute"
        animation.hooker.exit1 = "sex_to_proposition_p1_prostitute"
        animation.hooker.exit2 = "sex_to_proposition_p2_prostitute"

        -- Player anims
        animation.player.enter1 = "proposition_to_sex_p1_male"
        animation.player.enter2 = "proposition_to_sex_p2_male"
        animation.player.loop = "sex_loop_male"
        animation.player.exit1 = "sex_to_proposition_p1_male"
        animation.player.exit2 = "sex_to_proposition_p2_male"
    end

    PlaySexSceneAnim(hooker, playerPed, animation.hooker.enter1, animation.player.enter1, 2, true)
    PlaySexSceneAnim(hooker, playerPed, animation.hooker.enter2, animation.player.enter2, 2, true)

    local loopWait = GetAnimDuration("mini@prostitutes@sexnorm_veh", animation.hooker.loop) * 1000 / 2
    PlaySexSceneAnim(hooker, playerPed, animation.hooker.loop, animation.player.loop, 1, false)

    if scene == "SERVICE_SEX" then
        CreateThread(function()
            Wait(250)

            while timer > 0 do
                ApplyForceToEntity(vehicle, 1, 0.0, 0.0, -0.5, 0.0, 0.0, 0.0, 0, true, true, true, true, false)
                Wait(780)
            end
        end)
    end

    while timer > 0 do
        if not DoesEntityExist(hooker) then return end

        PlayHookerSpeach(hooker, speach.name, speach.param)
        Wait(loopWait)

        timer = timer - 1
    end

    PlaySexSceneAnim(hooker, playerPed, animation.hooker.exit1, animation.player.exit1, 2, true)
    PlaySexSceneAnim(hooker, playerPed, animation.hooker.exit2, animation.player.exit2, 2, true)
    PlaySexSceneAnim(hooker, playerPed, "proposition_loop_prostitute", "proposition_loop_male", 1, false)
end

local function DisableVehicleControlsLoop()
    while disableVehicleControls do
        for control, state in pairs(VEHICLE_CONTROLS) do
            DisableControlAction(0, control, state)
        end

        Wait(0)
    end
end

local function DisableVehicleControls(state)
    disableVehicleControls = state
    if disableVehicleControls then
        CreateThread(DisableVehicleControlsLoop)
    end
end


-- Threads/Loops --
local function HookerLoop(hooker)
    CreateThread(function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        
        -- NOVO: Guardar a posição e rotação originais antes de ela entrar no carro[cite: 1]
        local originalCoords = GetEntityCoords(hooker)
        local originalHeading = GetEntityHeading(hooker)

        while true do
            vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 and #(GetEntityCoords(vehicle) - GetEntityCoords(hooker)) < Config.MaxDistance and GetEntitySpeed(vehicle) <= Config.MaxVehicleSpeed then
                DisplayHelpText(Config.Localization.InviteHooker)
                if IsPlayerPressingHorn(PLAYER_ID) then
                    break
                end
            else
                HookerInteractionCanceled()
                return
            end

            Wait(0)
        end

        isUsingHooker = true

        MakeHookerCalm(hooker)

        TaskEnterVehicle(hooker, vehicle, 10000, 0, 1.0, 1, 0)

        while true do
            local taskState = GetScriptTaskStatus(hooker, "SCRIPT_TASK_ENTER_VEHICLE")
            if taskState == 7 then
                if GetPedInVehicleSeat(vehicle, 0) == hooker then
                    break
                else
                    HookerInteractionCanceled()
                    return
                end
            elseif taskState == 2 then
                HookerInteractionCanceled()
                return
            end

            if not DoesEntityExist(hooker) or IsPedInjured(hooker) or GetVehiclePedIsIn(PlayerPedId(), false) ~= vehicle then
                HookerInteractionCanceled()
                return
            end

            Wait(100)
        end

        PlayHookerSpeach(hooker, "HOOKER_SECLUDED", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")

        while IsAnySpeechPlaying(hooker) do
            Wait(100)
        end

        local timeToFindArea = 120 * 1000
        local startTimer = GetGameTimer()
        local endTime = startTimer + timeToFindArea
        local isShowingHint = false
        local shouldAsyncThreadsBreak = false

        while true do
            Wait(500)

            if not DoesEntityExist(hooker) then
                shouldAsyncThreadsBreak = true
                HookerInteractionCanceled()
                return
            end

            if IsPedInjured(hooker) or GetVehiclePedIsIn(PlayerPedId(), false) ~= vehicle then
                shouldAsyncThreadsBreak = true
                ResetHookerCalm(hooker)
                HookerInteractionCanceled()
                return
            end

            local isAreaSecluded = IsInSecludedArea(hooker, vehicle)
            if isAreaSecluded then
                shouldAsyncThreadsBreak = true
                break
            end

            local gameTimer = GetGameTimer()
            if gameTimer > endTime then
                shouldAsyncThreadsBreak = true
                PlayHookerSpeach(hooker, "HOOKER_LEAVES_ANGRY", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
                TaskLeaveVehicle(hooker, vehicle, 0)

                while IsAnySpeechPlaying(hooker) do
                    Wait(100)
                end

                DisplayHint(Config.Localization.FindSecludedAreaFailed, 5000)
                Wait(5000)

                ResetHookerCalm(hooker)
                HookerInteractionCanceled()
                return
            end

            local vehicleSpeed = GetEntitySpeed(vehicle)
            if not isShowingHint and vehicleSpeed <= Config.MaxVehicleSpeed then
                isShowingHint = true

                Wait(500)

                CreateThread(function()
                    while true do
                        vehicleSpeed = GetEntitySpeed(vehicle)
                        if vehicleSpeed > Config.MaxVehicleSpeed then
                            shouldAsyncThreadsBreak = true
                            isShowingHint = false
                            break
                        end
                        Wait(500)
                    end
                end)

                CreateThread(function()
                    while not shouldAsyncThreadsBreak do
                        DisplayHelpText(Config.Localization.FindSecludedArea)
                        Wait(0)
                    end
                end)
            end
        end

        SetVehicleLights(vehicle, 1)
        DisableVehicleControls(true)
        LoadAnimDict("mini@prostitutes@sexnorm_veh")

        Wait(500)
        PlayHookerSpeach(hooker, "HOOKER_OFFER_SERVICE", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
        PlaySexSceneAnim(hooker, PlayerPedId(), "proposition_loop_prostitute", "proposition_loop_male", 1, false)

        while IsAnySpeechPlaying(hooker) do
            Wait(100)
        end

        local servicesCompleted = 0
        while true do
            if not DoesEntityExist(hooker) then
                HookerInteractionCanceled()
                DisableVehicleControls(false)
                return
            end

            if IsPedInjured(hooker) or GetVehiclePedIsIn(PlayerPedId(), false) ~= vehicle then
                break
            end

            if servicesCompleted >= Config.MaxServices then
                break
            end

            if servicesCompleted > 0 then
                PlayHookerSpeach(hooker, "HOOKER_OFFER_AGAIN", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
            end

            local service = OfferServices()
            if service == "SERVICE_DECLINE" then
                break
            else
                if Config.PaymentEnabled then
                    TriggerServerEvent('hookers:moneyCheck', service)
                    while hasPayed == nil do
                        Wait(100)
                    end

                    if not hasPayed then
                        hasPayed = nil
                        DisplayNotification(Config.Localization.NotEnoughMoney)
                        break
                    end

                    hasPayed = nil
                    PlaySexScene(service, hooker, vehicle)
                    servicesCompleted = servicesCompleted + 1
                else
                    PlaySexScene(service, hooker, vehicle)
                    servicesCompleted = servicesCompleted + 1
                end
            end

            Wait(100)
        end

        if servicesCompleted >= Config.MaxServices then
            PlayHookerSpeach(hooker, "HOOKER_HAD_ENOUGH", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
        elseif servicesCompleted == 0 then
            PlayHookerSpeach(hooker, "HOOKER_LEAVES_ANGRY", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
        else
            PlayHookerSpeach(hooker, "HOOKER_DECLINED", "SPEECH_PARAMS_FORCE_SHOUTED_CLEAR")
        end

        ClearPedTasks(hooker)
        ClearPedTasks(PlayerPedId())
        RemoveAnimDict("mini@prostitutes@sexnorm_veh")

        TaskLeaveVehicle(hooker, vehicle, 0)
        DisableVehicleControls(false)

        Wait(2000)
        SetVehicleLights(vehicle, 0)

        -- NOVO: Aguarda que ela saia fisicamente do carro antes de aplicar a rota de retorno[cite: 1]
        while IsPedInAnyVehicle(hooker, true) do
            Wait(200)
        end

        -- NOVO: Força a NPC a caminhar de volta para as coordenadas iniciais[cite: 1]
        TaskGoToCoordAnyMeans(hooker, originalCoords.x, originalCoords.y, originalCoords.z, 1.0, 0, 0, 786432, 0xbf800000)

        -- NOVO: Thread paralela para gerir o retorno sem travar a jogabilidade do utilizador[cite: 1]
        CreateThread(function()
            local chegou = false
            local tempoLimite = GetGameTimer() + 45000 -- Dá 45 segundos para ela caminhar de volta

            while GetGameTimer() < tempoLimite and not chegou do
                Wait(1000)
                if DoesEntityExist(hooker) and not IsPedInjured(hooker) then
                    local coordsAtuais = GetEntityCoords(hooker)
                    -- Se estiver a menos de 2 metros do sítio antigo, chegou![cite: 1]
                    if #(coordsAtuais - originalCoords) < 2.0 then
                        chegou = true
                    end
                else
                    break
                end
            end

            -- Quando chegar, redefine a rotação original e ativa o cenário de fumar[cite: 1]
            if chegou and DoesEntityExist(hooker) and not IsPedInjured(hooker) then
                ClearPedTasks(hooker)
                SetEntityHeading(hooker, originalHeading)
                Wait(500)
                TaskStartScenarioInPlace(hooker, "WORLD_HUMAN_SMOKING", 0, false)
            end

            -- Só remove a imunidade/calma quando terminar a caminhada[cite: 1]
            if DoesEntityExist(hooker) and not IsPedInjured(hooker) then
                ResetHookerCalm(hooker)
                SetBlockingOfNonTemporaryEvents(hooker, true) -- Mantém protegida contra sustos na rua[cite: 1]
            end
        end)

        HookerInteractionCanceled()
    end)
end

local function LookingForHookerThread()
    CreateThread(function()
        if isUsingHooker then
            return
        end

        isHookerThreadActive = true
        while true do
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if not vehicle or vehicle == 0 then
                break
            end

            local vehicleSpeed = GetEntitySpeed(vehicle)
            if vehicleSpeed <= Config.MaxVehicleSpeed then
                local vehicleCoords = GetEntityCoords(vehicle)

                for _index, ped in pairs(GetNearbyPeds()) do
                    if ped == playerPed then
                        goto nextPed
                    end

                    local dist = #(GetEntityCoords(ped) - vehicleCoords)
                    if dist > Config.MaxDistance then
                        goto nextPed
                    end

                    if not IsPedEligibleHooker(ped) then
                        goto nextPed
                    end

                    if not CanVehiclePickUpHookers(vehicle) then
                        while dist < Config.MaxDistance do
                            dist = #(GetEntityCoords(ped) - GetEntityCoords(vehicle))
                            DisplayHelpText(Config.Localization.VehicleUnsuitable)
                            Wait(0)
                        end
                    end

                    if not IsVehicleSeatFree(vehicle, 0) then
                        while dist < Config.MaxDistance do
                            dist = #(GetEntityCoords(ped) - GetEntityCoords(vehicle))
                            DisplayHelpText(Config.Localization.FrontSeatOccupied)
                            Wait(0)
                        end
                    else
                        isHookerThreadActive = false
                        HookerLoop(ped)
                        return
                    end

                    ::nextPed::
                end
            end

            Wait(500)
        end
        isHookerThreadActive = false
    end)
end

function HookerInteractionCanceled()
    isUsingHooker = false
    LookingForHookerThread()
end


-- Events --
AddEventHandler('gameEventTriggered', function(event, args)
    if event == "CEventNetworkPlayerEnteredVehicle" then
        if args[1] == PLAYER_ID then
            if isHookerThreadActive then
                return
            end

            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
                return
            end

            LookingForHookerThread()
        end
    end
end)

RegisterNetEvent('hookser:paymentReturn')
AddEventHandler('hookser:paymentReturn', function(state)
    hasPayed = state
end)

-- Garante tráfego zero a cada frame[cite: 1]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        SetGarbageTrucks(false)
        SetRandomBoats(false)

        SetPedDensityMultiplierThisFrame(0.2)          
        SetScenarioPedDensityMultiplierThisFrame(0.2, 0.2)  
        
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
    end
end)

Hookers = {
	{id = 1, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 87.3634, y = -1284.9731, z = 29.20, heading = 43.87}, 
	{id = 1, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 95.3634, y = -1278.0731, z = 29.20, heading = 43.87}, 
	{id = 1, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 85.7395, y = -1298.7465, z = 29.2576, heading = 134.3358}, 
	{id = 1, VoiceName = "HOOKER_LEAVES_ANGRY", modelHash = "s_f_y_hooker_01", x = 94.1306, y = -1311.7598, z = 29.2929, heading = 119.8313}, 
}

local spawnedpeds = {}
local ModelSpawned = false

-- Loop de Spawn Noturno corrigido (OneSync / Client compatible)[cite: 1]
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) -- Verifica a cada 2 segundos em vez de 0ms para poupar CPU[cite: 1]
        local hora = GetClockHours()
        
        if hora >= 21 or hora <= 5 then
            if not ModelSpawned then
                for i=1, #Hookers do
                    RequestModel(GetHashKey(Hookers[i].modelHash))
                    while not HasModelLoaded(GetHashKey(Hookers[i].modelHash)) do
                        Citizen.Wait(10)
                    end
                    
                    local SpawnedPed = CreatePed(2, Hookers[i].modelHash, Hookers[i].x, Hookers[i].y, Hookers[i].z, Hookers[i].heading, true, true)
                    
                    -- CORREÇÃO: Função nativa corrigida de TaskSetBlocking... para SetBlocking...[cite: 1]
                    SetBlockingOfNonTemporaryEvents(SpawnedPed, true)
                    
                    Wait(200)
                    TaskStartScenarioInPlace(SpawnedPed, "WORLD_HUMAN_SMOKING", 0, false)
                    table.insert(spawnedpeds, SpawnedPed)
                end
                -- CORREÇÃO: Movido para fora do loop "for" para permitir criar as 4 prostitutas[cite: 1]
                ModelSpawned = true
            end
        else
            if ModelSpawned and #spawnedpeds > 0 then
                for i=1, #spawnedpeds do
                    local ped = spawnedpeds[i]
                    if DoesEntityExist(ped) then
                        DeleteEntity(ped)
                    end
                end
                spawnedpeds = {}
                ModelSpawned = false
            end
        end
    end
end)