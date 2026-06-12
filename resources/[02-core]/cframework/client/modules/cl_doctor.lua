-- Title	:	cl_doctor.lua
-- Author   :   Peter
-- Started  :   19/01/25

local doctorData = LoadDoctor()

local isDrawingBar, barFull, isPressing = false, false, false
local currentLocIndex = nil

local function createCamera(dist, left, up, lookOffset, fov)
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local ped = PlayerPedId()
    local forward = GetEntityForwardVector(ped)
    local right = vector3(forward.y, -forward.x, forward.z)
    local head = GetPedBoneCoords(ped, GetEntityBoneIndexByName(ped, 'SKEL_HEAD'), 0.0, 0.0, 0.0)
    local camPos = GetEntityCoords(ped) + forward * dist

    SetCamCoord(cam, camPos.x, camPos.y, camPos.z + up)
    PointCamAtCoord(cam, head.x + right.x * left, head.y + right.y * left, head.z + lookOffset)
    SetCamFov(cam, fov)
    SetCamDofFocalLengthMultiplier(cam, 100.0)
    return cam
end

local function drawProgressUI(progress)
    local correction = ((1.0 - Round(GetSafeZoneSize(), 2)) * 100) * 0.005
    local x, y = 0.9255 - correction, 0.92 - correction

    DrawSprite('timerbars', 'all_black_bg', x, y, 0.20, 0.0325, 0.0, 255, 255, 255, 180)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 0, 100, 100, 180)
    DrawRect(x - 0.015 + (progress / 2), y, progress, 0.0125, 0, 150, 150, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(T("RESPAWN_TREAT"))
    EndTextCommandDisplayText(x - 0.06, y - 0.012)
end

local function startRespawnTimer()
    local doctorPed = exports.ft_libs:GetPedHandle(("hospital_doctor_%d"):format(currentLocIndex or 1))

    Citizen.CreateThread(function()
        local timer = GetGameTimer()
        local progress = 0.0

        if not HasStreamedTextureDictLoaded('timerbars') then
            RequestStreamedTextureDict('timerbars', false)
            while not HasStreamedTextureDictLoaded('timerbars') do Wait(0) end
        end

        local scaleform = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")
        repeat Citizen.Wait(0) until HasScaleformMovieLoaded(scaleform)

        BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(1)
        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, VK_KEY_E, false))
        ScaleformMovieMethodAddParamPlayerNameString("Respawn")
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        EndScaleformMovieMethod()

        while isDrawingBar and not barFull do
            local pressing = IsControlPressed(0, VK_KEY_E)

            if pressing and not isPressing and doctorPed then
                TaskStartScenarioInPlace(doctorPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
                isPressing = true
            elseif not pressing and isPressing and doctorPed then
                ClearPedTasks(doctorPed)
                ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
                ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 10.0, 0)
                isPressing = false
            end

            if pressing then
                progress = math.min((GetGameTimer() - timer) / doctorData.holdTime * 0.085, 0.085)
            else
                progress = math.max(progress - 0.0005, 0.0)
                timer = GetGameTimer() - progress / 0.085 * doctorData.holdTime
            end

            if progress >= 0.084 then
                isDrawingBar, barFull = false, true
                TriggerServerEvent("cframework:payHospitalDoctor", currentLocIndex)
                break
            end

            drawProgressUI(progress)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    for i, loc in ipairs(doctorData.locations) do
        local tag = ("hospital_doctor_%d"):format(i)

        exports.ft_libs:AddPed(tag, {
            model = doctorData.doctorModel,
            x = loc.doctor.x, y = loc.doctor.y, z = loc.doctor.z, w = loc.doctor.w
        })

        exports.ft_libs:AddTrigger(tag, {
            x = loc.doctor.x, y = loc.doctor.y, z = loc.doctor.z,
            weight = 4.5, height = 2,
            enter = { eventClient = "doctor:enter" }, data = i,
            exit = { eventClient = "doctor:exit" }
        })
    end
end)


RegisterNetEvent("doctor:enter", function(idx)
    currentLocIndex = idx
    isDrawingBar, barFull, isPressing = true, false, false
    startRespawnTimer()
end)

RegisterNetEvent("doctor:exit", function()
    isDrawingBar, barFull, isPressing, currentLocIndex = false, false, false, nil
end)

RegisterNetEvent("cframework:startRevive", function(idx)
    local loc <const> = doctorData.locations[idx]
    if not loc then return end

    local bed <const> = loc.bed or loc.doctor
    local ped <const> = PlayerPedId()
    local isPlayingAnim = true

    isDrawingBar, barFull = false, false
    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do Wait(0) end

    local doctorPed <const> = exports.ft_libs:GetPedHandle(("hospital_doctor_%d"):format(idx))
    if doctorPed then ClearPedTasks(doctorPed) end

    TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
    AnimpostfxStop('DeathFailOut')

    ESX.SetPlayerData('lastPosition', {x = bed.x, y = bed.y, z = bed.z + 0.5})
    TriggerServerEvent('esx:updateLastPosition', {x = bed.x, y = bed.y, z = bed.z + 0.5})

    RespawnPed(PlayerPedId(), {x = bed.x, y = bed.y, z = bed.z + 0.5})
    SetEntityHeading(ped, bed.w)

    RequestAnimDict('anim@gangops@morgue@table@')
    while not HasAnimDictLoaded('anim@gangops@morgue@table@') do Citizen.Wait(0) end

    RequestAnimDict('mini@repair')
    while not HasAnimDictLoaded('mini@repair') do Citizen.Wait(0) end

    RequestModel(doctorData.nurseModel)
    while not HasModelLoaded(doctorData.nurseModel) do Citizen.Wait(0) end

    RequestModel(doctorData.doctorModel)
    while not HasModelLoaded(doctorData.doctorModel) do Citizen.Wait(0) end

    local cam1 <const> = createCamera(2.0, 0.0, 0.45, -2.0, 40.0)
    local cam2 <const> = createCamera(2.0, 0.0, 1.45, -3.0, 80.0)

    TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1, -1, 1, 0, false, false, false)

    -- Control disable thread like old code
    Citizen.CreateThread(function()
        while isPlayingAnim do
            local playerPed <const> = PlayerPedId()
            for _, player in ipairs(GetActivePlayers()) do
                local otherPlayerPed <const> = GetPlayerPed(player)
                if playerPed ~= otherPlayerPed then
                    SetEntityLocallyInvisible(otherPlayerPed)
                    SetEntityVisible(otherPlayerPed, false, false)
                    SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
                end
            end
            DisableAllControlActions(0)
            Citizen.Wait(0)
        end
    end)

    SetCamActive(cam1, true)
    RenderScriptCams(true, true, 0, true, true)
    SetCamActiveWithInterp(cam1, cam2, 12000, 10, 1)

    local nursePed1 <const> = CreatePed(0, doctorData.nurseModel, loc.nursePed.x, loc.nursePed.y, loc.nursePed.z, loc.nursePed.w, false, false)
    local nursePed2 <const> = CreatePed(0, doctorData.nurseModel, loc.nursePed2.x, loc.nursePed2.y, loc.nursePed2.z, loc.nursePed2.w, false, false)
    local doctorPed2 <const> = CreatePed(0, doctorData.doctorModel, loc.medicPed.x, loc.medicPed.y, loc.medicPed.z, loc.medicPed.w, false, false)

    for _, npc in ipairs({nursePed1, nursePed2, doctorPed2}) do
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
    end

    local timeout <const> = GetGameTimer() + 10000

    while not IsEntityPlayingAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 3) do
        if GetGameTimer() > timeout then break end
        Citizen.Wait(0)
    end

    DoScreenFadeIn(800)

    TaskPlayAnim(doctorPed2, 'mini@repair', 'fixing_a_ped', 8.0, -8.0, -1, 1, 0, false, false, false)
    TaskStartScenarioInPlace(nursePed1, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
    TaskStartScenarioInPlace(nursePed2, "PROP_HUMAN_STAND_IMPATIENT", 0, true)

    Citizen.Wait(15000)

    isPlayingAnim = false
    barFull = false

    SetCamActive(cam1, false)
    RenderScriptCams(false, true, 0, true, true)

    if DoesCamExist(cam1) then DestroyCam(cam1, false) end
    if DoesCamExist(cam2) then DestroyCam(cam2, false) end
    if DoesEntityExist(doctorPed2) then DeleteEntity(doctorPed2) end
    if DoesEntityExist(nursePed1) then DeleteEntity(nursePed1) end
    if DoesEntityExist(nursePed2) then DeleteEntity(nursePed2) end

    SetModelAsNoLongerNeeded(doctorData.nurseModel)
    SetModelAsNoLongerNeeded(doctorData.doctorModel)

    startDoctorReviveRoutine()
end)

RegisterNetEvent("cframework:playerIsDead", function()
    ESX.ShowNotification(T("RESPAWN_CANT_BE_TREATED"), "error")

    isDrawingBar = false
    barFull = false
end)

Citizen.CreateThread(function()
    TriggerServerEvent('cframework:getOnlineEms')
end)
