local ClosestDistance = 20.0
local Chair = nil
local Pliers = nil
local Wrench = nil
local Syringe = nil
local ScaleformTeethPulling = nil
local DefaultRender = nil
local IsTorturing = false
local IsBeingTortured = false
local ChairProps = `prop_torture_ch_01`
local TortureAnimDIct = 'MISSFBI3_TOOTHPULL'

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local tortureChair = nil
        local closestDistance = nil


        local closestChair = GetClosestObjectOfType(playerCoords, 20.0, ChairProps, false)
        if DoesEntityExist(closestChair) then
            tortureChair = GetEntityCoords(closestChair)
            local distance = #(playerCoords - tortureChair)
            if not closestDistance or distance <= closestDistance then
                closestDistance = distance
            end
        end
        Chair = closestChair
        ClosestDistance = closestDistance
        Citizen.Wait(2000)
    end
end)

function HasPedHandsUp(ped)
    return true
end


Citizen.CreateThread(function()
    while true do
        if ESX and ClosestDistance and ClosestDistance <= 1.5 and not IsTorturing and not IsBeingTortured --[[and not HasPedHandsUp(PlayerPedId())]] and not IsPedRagdoll(PlayerPedId()) then
            ESX.ShowHelpNotification('Pressione ~INPUT_PICKUP~ para torturar')
            if IsControlJustPressed(1, 38) then
				StartTorture()
            end
        end
        Citizen.Wait(ClosestDistance and 0 or 1000)
    end
end)


function StartTorture()
    local chairCoords = GetEntityCoords(Chair)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer <= 0 or closestDistance > 4.0 then
        ESX.ShowNotification('Sem pessoas nas próximidades', 'error')
        return
    end
    local closestPlayerPed = GetPlayerPed(closestPlayer)
    local closestPlayerServerId = GetPlayerServerId(closestPlayer)

    if not HasPedHandsUp(closestPlayerPed) then
		ESX.ShowNotification('Quem vais torturar não tem as mãos levantadas', 'error')
		return
	end
	
    --Remove weapon from hand

	IsTorturing = true

    --RPC can use chair chairCoords, closestPlayerServerId)
    local canUse = true

    TriggerServerEvent('cframework:torture:enter', closestPlayerServerId)

    if canUse then
        CreateMenuTorture(closestPlayerServerId)
    else
        IsTorturing = false
    end
end


function CreateMenuTorture(closestPlayerServerId)
    local elements = {
        {label = '🦷 Arrancar um dente',         value = 'tooth'},
        {label = '🦴 Partir braço',             value = 'knee' },
        {label = '💉 Injetar tranquilizante',    value = 'tranq'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, 'Tortura', function(value)
        if value == 'tooth' then
            TriggerEvent('esx_inventoryhud:doClose')
            StartTortureToothAnims(closestPlayerServerId)
        end

        if value == 'knee' then
            TriggerEvent('esx_inventoryhud:doClose')
            StartTortureWrenchAnims(closestPlayerServerId)
        end

        if value == 'tranq' then
            local success = true --RPC use serynge

            if success then
                TriggerEvent('esx_inventoryhud:doClose')
                StartTortureSyringeAnims(closestPlayerServerId)
            else
                ESX.ShowNotification('Não tens tranquilizantes...', 'error')
                LeaveTorture()
            end
        end

        if value ~= 'tooth' and value ~= 'knee' and value ~= 'tranq' then
            IsTorturing = false
        end
    end)
end

---TeethPulling---

function StartTortureToothAnims(hostageId)
    local animDict = 'MISSFBI3_TOOTHPULL'
    local playerPed = PlayerPedId()

    local chairCoords = GetEntityCoords(Chair)
    local chairHeading = vector3(0.0,0.0,GetEntityHeading(Chair) + 180.0)

    ScaleFormScreenInitTeethPulling()
    ESX.Streaming.RequestAnimDict(animDict)

    Pliers = CreateObject(`p_pliers_01_s`, chairCoords.x, chairCoords.y, chairCoords.z, true, false, false)
    FreezeEntityPosition(Pliers, true)
    AttachEntityToEntity(Pliers, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)


    DefaultRender = GetDefaultScriptRendertargetRenderId()
    Citizen.CreateThread(function()
        while DoesEntityExist(Pliers) do
            SetScriptGfxDrawOrder(4)
            SetScriptGfxDrawBehindPausemenu(true);
            DrawScaleformMovie(ScaleformTeethPulling, 0.5, 0.825, 0.2, 0.35, 255, 255, 255, 0)
            SetTextRenderId(DefaultRender)
            Citizen.Wait(0)
        end
    end)

    Instructions = SetupInstructionalButtons({ {key = 201, label = "Torturar"}, {key = 194,  label = "Sair"} })

    Citizen.CreateThread(function()
        TriggerEvent('dpemotes:setCanDoAnimations', false)
        while IsTorturing do
            DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            DisableAllControlActions(0)
            -- Enable camera movements
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 201, true)
            EnableControlAction(0, 194, true)
            -- Enable push to talk
            EnableControlAction(0, 249, true)

            if IsControlJustPressed(0,194) then
                LeaveTorture()
            end
            Citizen.Wait(0)
        end
        TriggerEvent('dpemotes:setCanDoAnimations', true)
    end)

    TaskPlayAnimAdvanced(playerPed, animDict, 'Pull_Tooth_Ready_Loop_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
    TriggerServerEvent('cframework:torture:playVictimAnim', hostageId, chairCoords, chairHeading.z, 1)
    PlayEntityAnim(Pliers, 'Pull_Tooth_Intro_Pliers', animDict, 1000.0, true, true, false, 0.0, 0)

    Citizen.CreateThread(function()
        local timeout = 0

        Citizen.CreateThread(function()
            while IsTorturing do
                if GetGameTimer() < timeout then
                    TaskPlayAnimAdvanced(playerPed, animDict, 'Pull_Tooth_Ready_Loop_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                    TriggerServerEvent('cframework:torture:playVictimAnim', hostageId, chairCoords, chairHeading.z, 1)
                    PlayEntityAnim(Pliers, 'Pull_Tooth_Intro_Pliers', animDict, 1000.0, true, true, false, 0.0, 0)
                end
                Citizen.Wait(5000)
            end
        end)

        while IsTorturing do
            if IsControlJustPressed(0,201) then
                TaskPlayAnimAdvanced(playerPed, animDict, 'Pull_Tooth_Loop_Weak_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                TriggerServerEvent('cframework:torture:playVictimAnim', hostageId, chairCoords, chairHeading.z, 2)
                PlayEntityAnim(Pliers, 'Pull_Tooth_Loop_Weak_Pliers', animDict, 1000.0, true, true, false, 0.0, 0)
                --TriggerEvent('cframework:PlaySoundFromCoordsClient', 'FBI_03_TORTURE_Teeth_Pulling', 0, chairCoords, 10.0, 'FBI_03_TORTURE_Teeth')
                Citizen.Wait(500)
                DepthTeeth(math.random(10.0, 25.0))
                AngleTeeth(math.random(0.0, 60.0))
                BrittleTeeth(50.0)
                Citizen.Wait(500)
                DepthTeeth(0.0)
                AngleTeeth(30.0)
                BrittleTeeth(0.0)
                Citizen.Wait(500)

                timeout = GetGameTimer() + 5000

                if (math.random(1,10)>9) then
                    TaskPlayAnimAdvanced(playerPed, animDict, 'Pull_Tooth_Outro_B_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                    TriggerServerEvent('cframework:torture:playVictimAnim', hostageId, chairCoords, chairHeading.z, 3)
                    PlayEntityAnim(Pliers, 'Pull_Tooth_Outro_B_Pliers', animDict, 1000.0, true, true, false, 0.0, 0)
                    TriggerEvent('cframework:PlaySoundFromCoordsClient', 'FBI_03_TORTURE_Teeth_Tooth_Out', 0, chairCoords, 10.0, 'FBI_03_TORTURE_Teeth')
                    Citizen.Wait(200)
                    DepthTeeth(100.0)
                    BrittleTeeth(80.0)
                    Citizen.Wait(1800)
                    SetScaleformMovieAsNoLongerNeeded(ScaleformTeethPulling)
                    Citizen.Wait(4000)
                    TriggerServerEvent('cframework:torture:giveTooth', hostageId)
                    LeaveTorture()
                    return
                end
            end
            Citizen.Wait(0)
        end
    end)
end

-- WRENCH Anim --
function StartTortureWrenchAnims(hostageId)
    local animDict = 'MISSFBI3_WRENCH'
    local playerPed = PlayerPedId()

    local chairCoords = GetEntityCoords(Chair)
    local chairHeading = vector3(0.0,0.0,GetEntityHeading(Chair) + 180.0)

    ESX.Streaming.RequestAnimDict(animDict)

    Wrench = CreateObject(`prop_cs_wrench`, chairCoords.x, chairCoords.y, chairCoords.z, true, false, false)
    FreezeEntityPosition(Wrench, true)
    AttachEntityToEntity(Wrench, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    Instructions = SetupInstructionalButtons({ {key = 201, label = "Partir o braço"}, {key = 194,  label = "Parar"} })

    Citizen.CreateThread(function()
        TriggerEvent('dpemotes:setCanDoAnimations', false)
        while IsTorturing do
            DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            DisableAllControlActions(0)
            -- Enable camera movements
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 201, true)
            EnableControlAction(0, 194, true)
            -- Enable push to talk
            EnableControlAction(0, 249, true)

            if IsControlJustPressed(0,194) then
                LeaveTorture()
            end
            Citizen.Wait(0)
        end
        TriggerEvent('dpemotes:setCanDoAnimations', true)
    end)

    TaskPlayAnimAdvanced(playerPed, animDict, 'Wrench_Idle_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
    TriggerServerEvent('cframework:torture:playWrenchVictimAnim', hostageId, chairCoords, chairHeading.z, 1)
    PlayEntityAnim(Wrench, 'Wrench_Idle_Wrench', animDict, 1000.0, true, true, false, 0.0, 0)

    Citizen.CreateThread(function()
        while IsTorturing do
            if IsControlJustPressed(0,201) then
                while GetEntityAnimCurrentTime(PlayerPedId(), "MISSFBI3_WRENCH", "Wrench_Idle_Player") < 0.99 do
                    Citizen.Wait(0)
                end
                PlayEntityAnim(Wrench, 'Wrench_Attack_Left_Wrench', animDict, 1000.0, true, true, false, 0.0, 0)
                TaskPlayAnimAdvanced(playerPed, animDict, 'Wrench_Attack_Left_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                TriggerServerEvent('cframework:torture:playWrenchVictimAnim', hostageId, chairCoords, chairHeading.z, 2)
                Citizen.Wait(2800)
                TriggerEvent('cframework:PlaySoundFromCoordsClient', 'FBI_03_TORTURE_Wrench_Hit_Shin', 0, chairCoords, 10.0, 'FBI_03_TORTURE_Wrench')
                Citizen.Wait(2500)

                TaskPlayAnimAdvanced(playerPed, animDict, 'Wrench_Idle_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                --TriggerServerEvent('cframework:torture:playWrenchVictimAnim', hostageId, chairCoords, chairHeading.z, 1)
                PlayEntityAnim(Wrench, 'Wrench_Idle_Wrench', animDict, 1000.0, true, true, false, 0.0, 0)
            end
            Citizen.Wait(0)
        end
    end)
end


-- Syringe Anim --
function StartTortureSyringeAnims(hostageId)
    local animDict = 'MISSFBI3_SYRINGE'
    local playerPed = PlayerPedId()

    local chairCoords = GetEntityCoords(Chair)
    local chairHeading = vector3(0.0,0.0,GetEntityHeading(Chair) + 180.0)

    ESX.Streaming.RequestAnimDict(animDict)

    Syringe = CreateObject(`prop_syringe_01`, chairCoords.x, chairCoords.y, chairCoords.z, true, false, false)
    FreezeEntityPosition(Syringe, true)
    AttachEntityToEntity(Syringe, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)

    Instructions = SetupInstructionalButtons({ {key = 201, label = "Injetar tranquilizante"}, {key = 194,  label = "Parar"} })

    Citizen.CreateThread(function()
        TriggerEvent('dpemotes:setCanDoAnimations', false)
        while IsTorturing do
            DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            DisableAllControlActions(0)
            -- Enable camera movements
            EnableControlAction(0, 1, true)
            EnableControlAction(0, 2, true)
            EnableControlAction(0, 201, true)
            EnableControlAction(0, 194, true)
            -- Enable push to talk
            EnableControlAction(0, 249, true)

            if IsControlJustPressed(0,194) then
                LeaveTorture()
            end
            Citizen.Wait(0)
        end
        TriggerEvent('dpemotes:setCanDoAnimations', true)
    end)

    TaskPlayAnimAdvanced(playerPed, animDict, 'Syringe_Idle_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
    TriggerServerEvent('cframework:torture:playSyringeVictimAnim', hostageId, chairCoords, chairHeading.z, 1)

    Citizen.CreateThread(function()
        while IsTorturing do
            if IsControlJustPressed(0,201) then
                TaskPlayAnimAdvanced(playerPed, animDict, 'Syringe_Use_Player', chairCoords, 0.0, 0.0, chairHeading.z, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
                TriggerServerEvent('cframework:torture:playSyringeVictimAnim', hostageId, chairCoords, chairHeading.z, 2)
                Citizen.Wait(16000)
                LeaveTorture()
                return
            end
            Citizen.Wait(0)
        end
    end)
end

AddEventHandler('esx:onPlayerDeath', function()
	if IsTorturing then
        LeaveTorture()
    end
end)

function LeaveTorture()
    local playerPed = PlayerPedId()

    SetScaleformMovieAsNoLongerNeeded(ScaleformTeethPulling)
    DeleteEntity(Pliers)
    DeleteEntity(Wrench)
    DeleteEntity(Syringe)
    IsTorturing = false
    ClearPedTasks(playerPed)
    TriggerServerEvent('cframework:torture:leave')
end

RegisterNetEvent('cframework:torture:leaveTorture', function()
    local playerPed = PlayerPedId()

    if IsBeingTortured then
        IsBeingTortured = false
        ClearPedTasks(playerPed)
    end
end)

RegisterNetEvent('cframework:torture:playVictimAnim', function(animCoords, animRot, animPhase)

    --Remove weapons from hand

	local playerPed = PlayerPedId()

	ESX.Streaming.RequestAnimDict(TortureAnimDIct)
	if animPhase == 1 then
		IsBeingTortured = true
		ClearPedTasks(playerPed)
		TriggerEvent('dpemotes:setCanDoAnimations', false)

		Citizen.CreateThread(function()
			while IsBeingTortured do
				Citizen.Wait(0)
				DisableAllControlActions(0)
				-- Enable camera movements
				EnableControlAction(0, 1, true)
				EnableControlAction(0, 2, true)
				-- Enable push to talk
				EnableControlAction(0, 249, true)
				DisableCamCollisionForEntity(Chair)
			end
			TriggerEvent('dpemotes:setCanDoAnimations', true)
		end)

		TaskPlayAnimAdvanced(playerPed, TortureAnimDIct, 'Pull_Tooth_Ready_Loop_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
	elseif animPhase == 2 then 
		TaskPlayAnimAdvanced(playerPed, TortureAnimDIct, 'Pull_Tooth_Loop_Weak_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
	else
		TaskPlayAnimAdvanced(playerPed, TortureAnimDIct, 'Pull_Tooth_Outro_B_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
		Citizen.Wait(5800)
		IsBeingTortured = false
		ClearPedTasks(playerPed)
	end
end)


RegisterNetEvent('cframework:torture:playWrenchVictimAnim', function(animCoords, animRot, animPhase)

    --Remove weapons from hand

	local playerPed = PlayerPedId()

	ESX.Streaming.RequestAnimDict('MISSFBI3_WRENCH')
	if animPhase == 1 then
		IsBeingTortured = true
		ClearPedTasks(playerPed)
		TriggerEvent('dpemotes:setCanDoAnimations', false)

		Citizen.CreateThread(function()
			while IsBeingTortured do
				Citizen.Wait(0)
				DisableAllControlActions(0)
				-- Enable camera movements
				EnableControlAction(0, 1, true)
				EnableControlAction(0, 2, true)
				-- Enable push to talk
				EnableControlAction(0, 249, true)
				DisableCamCollisionForEntity(Chair)
			end
			TriggerEvent('dpemotes:setCanDoAnimations', true)
		end)

		TaskPlayAnimAdvanced(playerPed, 'MISSFBI3_WRENCH', 'Wrench_Idle_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
    else
		TaskPlayAnimAdvanced(playerPed, 'MISSFBI3_WRENCH', 'Wrench_Attack_Left_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
		Citizen.Wait(8000)
		TaskPlayAnimAdvanced(playerPed, 'MISSFBI3_WRENCH', 'Wrench_Idle_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
	end
end)


RegisterNetEvent('cframework:torture:playSyringeVictimAnim', function(animCoords, animRot, animPhase)

    --Remove weapons from hand

	local playerPed = PlayerPedId()

	ESX.Streaming.RequestAnimDict('MISSFBI3_SYRINGE')
	if animPhase == 1 then
		IsBeingTortured = true
		ClearPedTasks(playerPed)
		TriggerEvent('dpemotes:setCanDoAnimations', false)

		Citizen.CreateThread(function()
			while IsBeingTortured do
				Citizen.Wait(0)
				DisableAllControlActions(0)
				-- Enable camera movements
				EnableControlAction(0, 1, true)
				EnableControlAction(0, 2, true)
				-- Enable push to talk
				EnableControlAction(0, 249, true)
				DisableCamCollisionForEntity(Chair)
			end
			TriggerEvent('dpemotes:setCanDoAnimations', true)
		end)

		TaskPlayAnimAdvanced(playerPed, 'MISSFBI3_SYRINGE', 'flatline_loop_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
    else
		TaskPlayAnimAdvanced(playerPed, 'MISSFBI3_SYRINGE', 'Syringe_Use_Victim', animCoords, 0.0, 0.0, animRot, 4.0, -1.0, -1, 7689, 0.0, 2, 0)
        --after use
		Citizen.Wait(13000)
        --effect drug
        Citizen.Wait(3000)
		IsBeingTortured = false
		ClearPedTasks(playerPed)
	end
end)

function ScaleFormScreenInitTeethPulling()
    ScaleformTeethPulling = RequestScaleformMovieInteractive('TEETH_PULLING')
    while not HasScaleformMovieLoaded(ScaleformTeethPulling) do
        Citizen.Wait(0)
    end
end

function DepthTeeth(depth)
    BeginScaleformMovieMethod(ScaleformTeethPulling, "SET_TEETH_DEPTH");
    ScaleformMovieMethodAddParamFloat(depth)
    EndScaleformMovieMethod()
end

function AngleTeeth(angle)
    BeginScaleformMovieMethod(ScaleformTeethPulling, "SET_TEETH_ANGLE");
    ScaleformMovieMethodAddParamFloat(angle)
    EndScaleformMovieMethod()
end

function BrittleTeeth(brittle)
    BeginScaleformMovieMethod(ScaleformTeethPulling, "SET_TEETH_BRITTLE");
    ScaleformMovieMethodAddParamFloat(brittle)
    EndScaleformMovieMethod()
end
