


local animDict <const> = "anim_heist@hs3f@ig11_steal_painting@male@"
-- selection = 1 is the anim with no climbing on the cabinet (which makes cabinet almost irrelavent)
-- selection = 2 is the anim with climbing on the cabinet

local function getAnimList(animVersion)
    local animList <const> = {
        enter = {
            player = "ver_0"..animVersion.."_top_left_enter",
            cabinet = "ver_0"..animVersion.."_top_left_enter_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_top_left_enter_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_top_left_enter_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_top_left_enter_w_me_switchblade",
            cam = "ver_0"..animVersion.."_top_left_enter_cam_re"
        },
        idle = {
            player = "ver_0"..animVersion.."_cutting_top_left_idle",
            cabinet = "ver_0"..animVersion.."_cutting_top_left_idle_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_top_left_idle_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_top_left_idle_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_top_left_idle_w_me_switchblade"
        },
        topleft_right = {
            player = "ver_0"..animVersion.."_cutting_top_left_to_right",
            cabinet = "ver_0"..animVersion.."_cutting_top_left_to_right_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_top_left_to_right_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_top_left_to_right_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_top_left_to_right_w_me_switchblade",
            cam = "ver_0"..animVersion.."_cutting_top_left_to_right_cam"
        },
        topleft_right_idle = {
            player = "ver_0"..animVersion.."_cutting_top_right_idle",
            cabinet = "ver_0"..animVersion.."_cutting_top_right_idle_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_top_right_idle_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_top_right_idle_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_top_right_idle_w_me_switchblade"
        },
        righttop_bottom = {
            player = "ver_0"..animVersion.."_cutting_right_top_to_bottom",
            cabinet = "ver_0"..animVersion.."_cutting_right_top_to_bottom_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_right_top_to_bottom_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_right_top_to_bottom_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_right_top_to_bottom_w_me_switchblade",
            cam = "ver_0"..animVersion.."_cutting_right_top_to_bottom_cam"
        },
        righttop_bottom_idle = {
            player = "ver_0"..animVersion.."_cutting_bottom_right_idle",
            cabinet = "ver_0"..animVersion.."_cutting_bottom_right_idle_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_bottom_right_idle_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_bottom_right_idle_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_bottom_right_idle_w_me_switchblade"
        },
        bottomright_left = {
            player = "ver_0"..animVersion.."_cutting_bottom_right_to_left",
            cabinet = "ver_0"..animVersion.."_cutting_bottom_right_to_left_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_bottom_right_to_left_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_bottom_right_to_left_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_bottom_right_to_left_w_me_switchblade",
            cam = "ver_0"..animVersion.."_cutting_bottom_right_to_left_cam"
        },
        bottomright_left_idle = {
            player = "ver_0"..animVersion.."_cutting_bottom_left_idle",
            cabinet = "ver_0"..animVersion.."_cutting_bottom_left_idle_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_bottom_left_idle_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_bottom_left_idle_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_bottom_left_idle_w_me_switchblade"
        },
        lefttop_bottom = {
            player = "ver_0"..animVersion.."_cutting_left_top_to_bottom",
            cabinet = "ver_0"..animVersion.."_cutting_left_top_to_bottom_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_cutting_left_top_to_bottom_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_cutting_left_top_to_bottom_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_cutting_left_top_to_bottom_w_me_switchblade",
            cam = "ver_0"..animVersion.."_cutting_left_top_to_bottom_cam"

        },
        exit_with_painting = {
            player = "ver_0"..animVersion.."_with_painting_exit",
            cabinet = "ver_0"..animVersion.."_with_painting_exit_ch_prop_ch_sec_cabinet_02a",
            painting = "ver_0"..animVersion.."_with_painting_exit_ch_prop_vault_painting_01a",
            bag = "ver_0"..animVersion.."_with_painting_exit_hei_p_m_bag_var22_arm_s",
            knife = "ver_0"..animVersion.."_with_painting_exit_w_me_switchblade",
            cam = "ver_02_with_painting_exit_cam",
        }
    }
    return animList
end

local function createAndPlayScene(coords, rot, anim, cam, painting, bag, knife)
    local scene <const> = CreateSynchronizedScene(coords.x, coords.y, coords.z, 0.0, 0.0, rot[3], 2)--, true, false, 1065353216, 0, 1065353216)

    if anim.player then
        TaskSynchronizedScene(PlayerPedId(), scene, animDict, anim.player, 4.0, -4.0, 1033, 0, 1000.0, 0)
    end

    if anim.painting then
        PlaySynchronizedEntityAnim(painting, scene, anim.painting, animDict, 1000.0, 0, 0, 1000.0)
    end

    if anim.bag then
        PlaySynchronizedEntityAnim(bag, scene, anim.bag, animDict, 1000.0, 0, 0, 1000.0)
    end

    if anim.knife then
        PlaySynchronizedEntityAnim(knife, scene, anim.knife, animDict, 1000.0, 0, 0, 1000.0)
    end

    if anim.cam then
        PlaySynchronizedCamAnim(cam, scene, anim.cam, animDict)
    end

    return scene
end

local function togglePedBagVisibility(ped, visible)
    if visible then
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        return
    end

    SetPedComponentVariation(ped, 5, 0, 0, 0)
end

local function createAnimProps(paintingCoords, paintingRotation)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end

    RequestModel("hei_p_m_bag_var22_arm_s")
    while not HasModelLoaded("hei_p_m_bag_var22_arm_s") do Citizen.Wait(1) end

    RequestModel("w_me_switchblade")
    while not HasModelLoaded("w_me_switchblade") do Citizen.Wait(1) end

    local bag <const> = CreateObject(`hei_p_m_bag_var22_arm_s`, paintingCoords[1], paintingCoords[2], paintingCoords[3] - 0.9754, false, true, false)
    SetEntityRotation(bag, 0.0, 0.0, (paintingRotation[3] - 180), 2, true)
    FreezeEntityPosition(bag, true)
    SetEntityCollision(bag, false, true)
    SetEntityInvincible(bag, true)

    local knife <const> = CreateObject(`w_me_switchblade`, paintingCoords[1], paintingCoords[2], paintingCoords[3] - 0.9754, false, true, false)
    SetEntityRotation(knife, 0.0, 0.0, (paintingRotation[3] - 180), 2, true)
    FreezeEntityPosition(knife, true)
    SetEntityCollision(knife, false, true)
    SetEntityInvincible(knife, true)

    SetModelAsNoLongerNeeded(`w_me_switchblade`)
    SetModelAsNoLongerNeeded(`hei_p_m_bag_var22_arm_s`)

    return bag, knife
end

function ESX.StartStealPaintingAnim(painting)
    if not DoesEntityExist(painting) then
        return
    end

    local anims <const> = getAnimList(1)
    local playerPed <const> = PlayerPedId()
    local paintIndex, scene = 0, -1
    local paintingCoordsAux <const>, paintingRotation <const> = GetEntityCoords(painting), GetEntityRotation(painting)
    local paintingCoords <const> = vector3(paintingCoordsAux.x + (0.428*math.sin(math.rad(paintingRotation.z))), paintingCoordsAux.y + (-0.428*math.cos(math.rad(paintingRotation.z))), paintingCoordsAux.z-1.164)
    local bag <const>, knife <const> = createAnimProps(paintingCoords, paintingRotation)

    local auxScene <const> = CreateSynchronizedScene(paintingCoords.x, paintingCoords.y, paintingCoords.z, 0.0, 0.0, paintingRotation[3], 2)
    PlaySynchronizedEntityAnim(painting, auxScene, anims.enter.painting, animDict, 1.0, -1.0, 0, 1000.0)
    SetSynchronizedSceneRate(auxScene, 0.0)
    SetSynchronizedScenePhase(auxScene, 0.0)

    togglePedBagVisibility(playerPed, true)

    local cam <const> = CreateCam("DEFAULT_ANIMATED_CAMERA", true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 3000, true, false)

    SetFollowPedCamViewMode(0)

    while true do
        Citizen.Wait(0)

        if paintIndex == 10 then
            ESX.ShowHelpNotification(string.format("~INPUT_MOVE_RIGHT_ONLY~ %s.", T("ARTWORK_CUTTING_RIGHT")))
        elseif paintIndex == 30 or paintIndex == 70 then
            ESX.ShowHelpNotification(string.format("~INPUT_MOVE_DOWN_ONLY~ %s.", T("ARTWORK_CUTTING_DOWN")))
        elseif paintIndex == 50 then
            ESX.ShowHelpNotification(string.format("~INPUT_MOVE_LEFT_ONLY~ %s.", T("ARTWORK_CUTTING_LEFT")))
        end

        if paintIndex == 0 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.enter, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 10
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 10 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.idle, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            end
            if IsControlJustReleased(2, 35) then -- D button
                paintIndex = 20
                scene = -1
                togglePedBagVisibility(playerPed, true)
            end
        elseif paintIndex == 20 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.topleft_right, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 30
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 30 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.topleft_right_idle, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            end
            if IsControlJustReleased(2, 33) then -- S button
                paintIndex = 40
                scene = -1
                togglePedBagVisibility(playerPed, true)
            end
        elseif paintIndex == 40 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.righttop_bottom, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 50
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 50 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.righttop_bottom_idle, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            end
            if IsControlJustReleased(2, 34) then -- A button
                paintIndex = 60
                scene = -1

                togglePedBagVisibility(playerPed, true)
            end
        elseif paintIndex == 60 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.bottomright_left, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 70
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 70 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.idle, cam, painting, bag, knife)

                local scene2 = CreateSynchronizedScene(paintingCoords.x, paintingCoords.y, paintingCoords.z, 0.0, 0.0, paintingRotation[3], 2)
                PlaySynchronizedEntityAnim(painting, scene, anims.bottomright_left.painting, animDict, 1.0, -1.0, 0, 1000.0)
                SetSynchronizedSceneRate(scene2, 0.0)
                SetSynchronizedScenePhase(scene2, 0.99)

                togglePedBagVisibility(playerPed, false)
            end
            if IsControlJustReleased(2, 33) then -- S button again
                paintIndex = 80
                scene = -1
                togglePedBagVisibility(playerPed, true)
            end
        elseif paintIndex == 80 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.lefttop_bottom, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 100
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 100 then
            if not IsSynchronizedSceneRunning(scene) then
                scene = createAndPlayScene(paintingCoords, paintingRotation, anims.exit_with_painting, cam, painting, bag, knife)

                togglePedBagVisibility(playerPed, false)
            elseif IsSynchronizedSceneRunning(scene) then
                if GetSynchronizedScenePhase(scene) >= 0.99 then
                    paintIndex = 110
                    scene = -1
                    togglePedBagVisibility(playerPed, true)
                end
            end
        elseif paintIndex == 110 then
            DeleteEntity(bag)
            DeleteEntity(knife)
            ClearPedTasks(playerPed)

            scene = CreateSynchronizedScene(paintingCoords.x, paintingCoords.y, paintingCoords.z, 0.0, 0.0, paintingRotation[3], 2)
            PlaySynchronizedEntityAnim(painting, scene, anims.exit_with_painting.painting, animDict, 1.0, -1.0, 0, 1000.0)

            SetSynchronizedSceneRate(scene, 0.0)
            SetSynchronizedScenePhase(scene, 0.99)

            if DoesCamExist(cam) then
                SetCamActive(cam, false)
                DestroyCam(cam, false)
            end

            StopRenderingScriptCamsUsingCatchUp(false, 0.0, 3)
            return
        end
    end
end

--[[
local paintingObj = 0

RegisterCommand("createPainting", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerRot = GetEntityRotation(playerPed)
    local startcartpos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
    local paintingHash = GetHashKey("ch_prop_vault_painting_01"..(args[1] or "a"))

    RequestModel(paintingHash) -- you can try other props too, they are in the stream folder
    while not HasModelLoaded(paintingHash) do Citizen.Wait(1) end

    paintingObj = CreateObject(paintingHash, startcartpos[1], startcartpos[2], startcartpos[3] - 0.9754, false, true, false)
    SetEntityRotation(paintingObj,  0.0, 0.0, (playerRot[3] + 180), 2, true)
    FreezeEntityPosition(paintingObj, true)
    SetEntityCollision(paintingObj, false, false)
    SetEntityInvincible(paintingObj, true)

    SetModelAsNoLongerNeeded(paintingHash)
end)

RegisterCommand("startStealing", function(source, args, rawCommand)
    print("start stealing painting")
    ESX.StartStealPaintingAnim(paintingObj)
    print("finished stealing painting")
end)
]]