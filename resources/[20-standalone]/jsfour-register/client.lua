-- jsfour-register (base limpa Sem Destino RP) — criação de personagem (NUI completa)
-- Fase 1: identidade (NUI). Fase 2: aparência (NUI a conduzir a API skinchanger do cframework).
-- Disparado por [02-core]/cframework/client/cl_spawnmanager.lua -> TriggerEvent('jsfour-register:open')

local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local registering = false
local cam = nil
local baseHeading = 0.0
local camDist, camZ = 0.9, 1.6   -- z = altura ACIMA dos pés (cabeça ~1.6); preset "rosto"

local function dbg(_) end   -- instrumentação de debug desativada (produção)

-- cena de criação: Aeroporto Internacional de Los Santos (LSIA)
local SCENE = { x = -1050.0, y = -2700.0, z = 13.0, h = 330.0 }
local spawned = false
local spawnCoords = nil
local currentMale = true
local curDict, curName = nil, nil   -- anim atualmente a tocar (p/ verificação/replay)

AddEventHandler('playerSpawned', function(s)
    spawned = true
    if type(s) == 'table' and s.x then
        spawnCoords = { x = s.x + 0.0, y = s.y + 0.0, z = s.z + 0.0 }
    end
end)

-- ── Câmara ──────────────────────────────────────────────────────────────────
local function placeCam()
    if not cam then return end
    local rad = math.rad(baseHeading)
    local fx, fy = -math.sin(rad), math.cos(rad)
    SetCamCoord(cam, SCENE.x + fx * camDist, SCENE.y + fy * camDist, SCENE.z + camZ)
    PointCamAtCoord(cam, SCENE.x, SCENE.y, SCENE.z + camZ)
end

local function startCam()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    placeCam()
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
end

local function stopCam()
    if cam then
        RenderScriptCams(false, true, 400, true, true)
        DestroyCam(cam, false)
        cam = nil
    end
end

-- ── Animação de chegada / idle — via SCENARIO (fiável, não precisa de dict) ───
local ARRIVAL_SCENARIO = 'WORLD_HUMAN_STAND_IMPATIENT'
local function playArrival(ped)
    ped = ped or PlayerPedId()
    ClearPedTasksImmediately(ped)
    TaskStartScenarioInPlace(ped, ARRIVAL_SCENARIO, 0, true)
    dbg('scenario: ' .. ARRIVAL_SCENARIO .. ' active=' .. tostring(IsPedUsingScenario(ped, ARRIVAL_SCENARIO)))
end

-- ── Cena (sem freeze: anti-ragdoll + controlos off + reposição mantêm quieto) ─
local function placePed(ped)
    ped = ped or PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityCoordsNoOffset(ped, SCENE.x, SCENE.y, SCENE.z, false, false, false)
    SetEntityHeading(ped, SCENE.h)
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, true, false)
    SetPedCanRagdoll(ped, false)
    ClearPedTasksImmediately(ped)
end

local function poseScene(ped)
    ped = ped or PlayerPedId()
    placePed(ped)
    Wait(50)
    playArrival(ped)
end

local function setupScene()
    local ped = PlayerPedId()
    -- colocar acima e congelar SÓ para sondar o chão (z dado pode estar enterrado)
    SetEntityCoordsNoOffset(ped, SCENE.x, SCENE.y, SCENE.z + 30.0, false, false, false)
    FreezeEntityPosition(ped, true)
    local found, gz = false, nil
    local t = GetGameTimer()
    while (GetGameTimer() - t) < 6000 do
        RequestCollisionAtCoord(SCENE.x, SCENE.y, SCENE.z + 30.0)
        if HasCollisionLoadedAroundEntity(ped) then
            found, gz = GetGroundZFor_3dCoord(SCENE.x, SCENE.y, SCENE.z + 30.0, false)
            if found and gz and gz > 0.0 then break end
        end
        Wait(50)
    end
    if found and gz and gz > 0.0 then SCENE.z = gz end
    dbg(('setupScene: groundFound=%s z=%.2f'):format(tostring(found), SCENE.z))
    baseHeading = SCENE.h
end

local function restoreScene()
    local ped = PlayerPedId()
    local s = spawnCoords or { x = -269.4, y = -955.3, z = 31.2 }
    RequestCollisionAtCoord(s.x, s.y, s.z)
    SetEntityCoordsNoOffset(ped, s.x, s.y, s.z, false, false, false)
end

-- ── Cutscene nativa "chegada de avião" (MP_INTRO_CONCAT) — porte fiel do BX-Intro ─
-- Componentes de roupa dos 7 passageiros de fundo (a cutscene EXIGE estes atores;
-- sem eles renderiza ecrã preto). Dados extraídos de BX-Intro (sub_b747).
local PASSENGERS = {
    [0] = 'MP_Plane_Passenger_1', [1] = 'MP_Plane_Passenger_2', [2] = 'MP_Plane_Passenger_3',
    [3] = 'MP_Plane_Passenger_4', [4] = 'MP_Plane_Passenger_5', [5] = 'MP_Plane_Passenger_6',
    [6] = 'MP_Plane_Passenger_7'
}
-- por passageiro: { [componentId] = { drawable, texture } }
local PASSENGER_COMPS = {
    [0] = {[0]={21,0},[1]={0,0},[2]={9,0},[3]={1,0},[4]={9,0},[5]={0,0},[6]={4,8},[7]={0,0},[8]={15,0},[9]={0,0},[10]={0,0},[11]={10,0}},
    [1] = {[0]={13,0},[1]={0,0},[2]={5,4},[3]={1,0},[4]={10,0},[5]={0,0},[6]={10,0},[7]={11,2},[8]={13,6},[9]={0,0},[10]={0,0},[11]={10,0}},
    [2] = {[0]={15,0},[1]={0,0},[2]={1,4},[3]={1,0},[4]={0,1},[5]={0,0},[6]={1,7},[7]={0,0},[8]={2,9},[9]={0,0},[10]={0,0},[11]={6,0}},
    [3] = {[0]={14,0},[1]={0,0},[2]={5,3},[3]={3,0},[4]={1,6},[5]={0,0},[6]={11,5},[7]={0,0},[8]={2,0},[9]={0,0},[10]={0,0},[11]={3,12}},
    [4] = {[0]={18,0},[1]={0,0},[2]={15,3},[3]={15,0},[4]={2,5},[5]={0,0},[6]={4,6},[7]={4,0},[8]={3,0},[9]={0,0},[10]={0,0},[11]={4,0}},
    [5] = {[0]={27,0},[1]={0,0},[2]={7,3},[3]={11,0},[4]={4,8},[5]={0,0},[6]={13,14},[7]={5,3},[8]={3,0},[9]={0,0},[10]={0,0},[11]={2,7}},
    [6] = {[0]={16,0},[1]={0,0},[2]={15,1},[3]={3,0},[4]={5,6},[5]={0,0},[6]={2,8},[7]={0,0},[8]={2,0},[9]={0,0},[10]={0,0},[11]={3,7}}
}
local function dressPassenger(ped, i)
    local c = PASSENGER_COMPS[i]
    if c then
        for comp, dt in pairs(c) do SetPedComponentVariation(ped, comp, dt[1], dt[2], 0) end
    end
    for p = 0, 8 do ClearPedProp(ped, p) end
end

local function playPlaneCutscene(isMale)
    local ped = PlayerPedId()
    -- soltar o ped do estado da cena de criação (congelado/invisível/scenario)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, false)
    SetPedCanRagdoll(ped, true)
    SetEntityInvincible(ped, false)

    TriggerServerEvent('jsreg:setBucket', 1)   -- isolar p/ a cena não ter interferência
    Wait(150)

    dbg('cutscene: request (' .. (isMale and 'M' or 'F') .. ')')
    RequestCutsceneWithPlaybackList('MP_INTRO_CONCAT', isMale and 31 or 103, 8)
    local t = GetGameTimer()
    while not HasCutsceneLoaded() and (GetGameTimer() - t) < 15000 do Wait(10) end
    if not HasCutsceneLoaded() then
        dbg('cutscene: FALHOU load (15s) -> salta p/ spawn')
        TriggerServerEvent('jsreg:setBucket', 0)
        return false
    end
    dbg('cutscene: loaded em ' .. (GetGameTimer() - t) .. 'ms')

    local myName    = isMale and 'MP_Male_Character' or 'MP_Female_Character'
    local otherName = isMale and 'MP_Female_Character' or 'MP_Male_Character'
    RegisterEntityForCutscene(0, myName, 3, GetEntityModel(ped), 0)
    RegisterEntityForCutscene(ped, myName, 0, 0, 0)
    SetCutsceneEntityStreamingFlags(myName, 0, 1)
    local other = RegisterEntityForCutscene(0, otherName, 3, 0, 64)
    if other then NetworkSetEntityInvisibleToNetwork(other, true) end

    -- 7 passageiros de fundo (sem eles a cutscene fica preta)
    local mF, fF = GetHashKey('mp_m_freemode_01'), GetHashKey('mp_f_freemode_01')
    RequestModel(mF); RequestModel(fF)
    local mt = GetGameTimer()
    while (not HasModelLoaded(mF) or not HasModelLoaded(fF)) and (GetGameTimer() - mt) < 5000 do
        RequestModel(mF); RequestModel(fF); Wait(0)
    end
    local npcs = {}
    for i = 0, 6 do
        local female = (i == 1 or i == 2 or i == 4 or i == 6)
        npcs[i] = CreatePed(26, female and fF or mF, -1117.778, -1557.625, 3.3819, 0.0, false, false)
        if npcs[i] and not IsEntityDead(npcs[i]) then
            dressPassenger(npcs[i], i)
            FinalizeHeadBlend(npcs[i])
            RegisterEntityForCutscene(npcs[i], PASSENGERS[i], 0, 0, 64)
        end
    end
    dbg('cutscene: NPCs registados')

    SetWeatherTypeNow('EXTRASUNNY')
    SetCutsceneCanBeSkipped(true)
    StartCutscene(4)

    -- esperar que a cutscene assuma o render, depois revelar (evita ficar no nosso preto)
    local s0 = GetGameTimer()
    while not IsCutsceneActive() and (GetGameTimer() - s0) < 5000 do Wait(0) end
    dbg('cutscene: pos-start active=' .. tostring(IsCutsceneActive()))
    Wait(200)
    DoScreenFadeIn(500)

    local started = GetGameTimer()
    local lastLog = 0
    while IsCutsceneActive() and not IsCutsceneFinished() and (GetGameTimer() - started) < 42000 do
        local el = GetGameTimer() - started
        if el - lastLog >= 3000 then
            lastLog = el
            dbg(('cutscene: a correr %ds (playing=%s)'):format(math.floor(el / 1000), tostring(IsCutscenePlaying())))
        end
        Wait(0)
    end
    if IsCutsceneActive() then StopCutsceneImmediately() end
    dbg('cutscene: terminou apos ' .. (GetGameTimer() - started) .. 'ms')

    for i = 0, 6 do if npcs[i] and DoesEntityExist(npcs[i]) then DeleteEntity(npcs[i]) end end
    SetModelAsNoLongerNeeded(mF); SetModelAsNoLongerNeeded(fF)
    ClearPedWetness(ped)
    TriggerServerEvent('jsreg:setBucket', 0)
    dbg('cutscene: fim')
    return true
end

-- thread: controlos off + sem radar/HUD + manter no sítio + manter animação
local function startLockThread()
    CreateThread(function()
        while registering do
            DisableAllControlActions(0)
            DisplayRadar(false)
            HideHudAndRadarThisFrame()
            -- só repõe a posição se fugir MUITO (não limpa tarefas -> não mata a animação)
            local ped = PlayerPedId()
            local c = GetEntityCoords(ped)
            local dx, dy, dz = c.x - SCENE.x, c.y - SCENE.y, c.z - SCENE.z
            if (dx * dx + dy * dy + dz * dz) > 9.0 then
                SetEntityCoordsNoOffset(ped, SCENE.x, SCENE.y, SCENE.z, false, false, false)
                SetEntityHeading(ped, SCENE.h)
            end
            Wait(0)
        end
        DisplayRadar(true)
    end)
end

local function finish()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    registering = false        -- pára o lock thread ANTES da cutscene
    stopCam()
    DoScreenFadeOut(500)
    Wait(550)

    -- CUTSCENE NATIVA DE CHEGADA DE AVIÃO (mostra o personagem JÁ criado)
    playPlaneCutscene(currentMale)

    -- SPAWN no aeroporto (chão já calibrado) + entregar controlo
    DoScreenFadeOut(300)
    Wait(350)
    local p = PlayerPedId()
    ClearPedTasksImmediately(p)
    SetPedCanRagdoll(p, true)
    SetEntityCoordsNoOffset(p, SCENE.x, SCENE.y, SCENE.z, false, false, false)
    SetEntityHeading(p, SCENE.h)
    FreezeEntityPosition(p, false)
    SetEntityInvincible(p, false)
    local tt = GetGameTimer()
    while not HasCollisionLoadedAroundEntity(p) and (GetGameTimer() - tt) < 5000 do
        RequestCollisionAtCoord(SCENE.x, SCENE.y, SCENE.z); Wait(10)
    end
    DoScreenFadeIn(700)
    ESX.ShowNotification('~g~Bem-vindo(a) a Sem Destino RP!')
end

-- carrega o modelo (M/F), ESPERA que fique mesmo aplicado, e posa + aponta a câmara.
-- (o load do cframework é assíncrono; sem esperar, o ped só renderiza segundos depois)
local function loadModelAndPose(male)
    local want = male and GetHashKey('mp_m_freemode_01') or GetHashKey('mp_f_freemode_01')
    TriggerEvent('skinchanger:loadDefaultModel', male)
    local t = GetGameTimer()
    while GetEntityModel(PlayerPedId()) ~= want and (GetGameTimer() - t) < 6000 do Wait(20) end
    Wait(120)   -- margem para o modelo renderizar
    poseScene(PlayerPedId())
    baseHeading = SCENE.h
    placeCam()
    dbg('modelo aplicado: ' .. (male and 'M' or 'F') .. ' em ' .. (GetGameTimer() - t) .. 'ms')
end

-- ── Entrada ─────────────────────────────────────────────────────────────────
AddEventHandler('jsfour-register:open', function()
    if registering then return end
    registering = true
    spawned = false
    CreateThread(function()
        dbg('open: a iniciar')
        while ESX == nil do Wait(100) end
        DoScreenFadeOut(0)
        local t = GetGameTimer()
        while not spawned and (GetGameTimer() - t) < 6000 do Wait(50) end
        Wait(300)
        DoScreenFadeOut(0)

        -- montar a cena de criação (a cutscene de chegada corre no FIM, ao finalizar)
        startLockThread()
        setupScene()
        currentMale = true
        camDist, camZ = 0.9, 1.6
        startCam()                  -- montar a câmara primeiro
        loadModelAndPose(true)      -- carrega o modelo e espera estar VISÍVEL antes do fade-in
        Wait(120)
        DoScreenFadeIn(600)
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open' })
        dbg('NUI aberta')
    end)
end)

-- === FASE 1 — Identidade ===
RegisterNUICallback('setSex', function(data, cb)
    cb('ok')
    local male = (data.sex ~= 'f')
    currentMale = male
    CreateThread(function()
        loadModelAndPose(male)   -- troca o modelo e mostra-o já no preview de identidade
    end)
end)

RegisterNUICallback('register', function(data, cb)
    cb('ok')
    local sex = (data.sex == 'f') and 'f' or 'm'
    currentMale = (sex == 'm')
    CreateThread(function()
        loadModelAndPose(sex == 'm')

        TriggerServerEvent('jsfour-register:save', {
            firstname   = tostring(data.firstname or ''),
            lastname    = tostring(data.lastname or ''),
            dateofbirth = tostring(data.dob or ''),
            sex         = sex,
            height      = tostring(data.height or '')
        })

        TriggerEvent('skinchanger:getData', function(components, maxVals)
            SendNUIMessage({ action = 'appearance', components = components, maxVals = maxVals, sex = sex })
        end)
    end)
end)

-- === FASE 2 — Aparência ===
-- Overlays faciais (barba, sobrancelhas, maquilhagem...) só são VISÍVEIS com
-- opacidade > 0. O cframework guarda o tipo em `*_1` e a opacidade em `*_2`
-- (default 0 = invisível). Ao escolher um tipo, subimos a opacidade a 100%.
local OVERLAY_OPACITY = {
    beard_1 = 'beard_2', eyebrows_1 = 'eyebrows_2', makeup_1 = 'makeup_2',
    blush_1 = 'blush_2', lipstick_1 = 'lipstick_2', age_1 = 'age_2',
    chest_1 = 'chest_2', complexion_1 = 'complexion_2', sun_1 = 'sun_2',
    moles_1 = 'moles_2', blemishes_1 = 'blemishes_2', bodyb_1 = 'bodyb_2'
}

RegisterNUICallback('skinChange', function(data, cb)
    local name  = data.name
    local value = tonumber(data.value) or 0
    if name then
        TriggerEvent('skinchanger:change', name, value)
        -- garantir que o overlay fica visível (ou invisível se tipo 0)
        local opa = OVERLAY_OPACITY[name]
        if opa then
            TriggerEvent('skinchanger:change', opa, value > 0 and 10 or 0)
        end
        TriggerEvent('skinchanger:getData', function(_, maxVals)
            cb({ maxVals = maxVals })
        end)
    else
        cb({})
    end
end)

RegisterNUICallback('skinRotate', function(data, cb)
    local delta = tonumber(data.delta) or 0
    baseHeading = (baseHeading + delta) % 360.0   -- orbita a câmara à volta do ped
    placeCam()
    cb('ok')
end)

RegisterNUICallback('skinZoom', function(data, cb)
    camDist = tonumber(data.dist) or camDist
    camZ    = tonumber(data.z) or camZ
    placeCam()
    cb('ok')
end)

RegisterNUICallback('skinSave', function(data, cb)
    cb('ok')
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
    CreateThread(finish)
end)
