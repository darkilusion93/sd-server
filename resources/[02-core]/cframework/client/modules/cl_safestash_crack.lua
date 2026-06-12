

local scaleform, renderTargetId, syncedScene = -1, -1, 0

--	AUDIO::PLAY_SOUND_FRONTEND(-1, "Input_Code_Up", "Safe_Minigame_Sounds", true);
--	AUDIO::PLAY_SOUND_FRONTEND(-1, "Input_Code_Down", "Safe_Minigame_Sounds", true);

local function setScaleformDigits(cursorPos, numberInDigit)--Position - 0x1F3361
	BeginScaleformMovieMethod(scaleform, "SET_VALUE")
	ScaleformMovieMethodAddParamInt(cursorPos)
	ScaleformMovieMethodAddParamInt(numberInDigit)
	EndScaleformMovieMethod()
end

local function setScaleformCursorAndDigits(updateDigits, cursorPos, numberInDigit)--cursorPos(0, 1, 2), numberInDigit(0 .. 99)
	BeginScaleformMovieMethod(scaleform, "SET_CURSOR_POSITION")
	ScaleformMovieMethodAddParamInt(cursorPos)
	EndScaleformMovieMethod()
	if updateDigits then
		setScaleformDigits(cursorPos, numberInDigit)
    end
end

local function setScaleformState(state) -- 0:disabled, 1:digits, 2:error, 3:open
	BeginScaleformMovieMethod(scaleform, "SET_STATE")
	ScaleformMovieMethodAddParamInt(state)
	EndScaleformMovieMethod()
end

local function registerRenderTarget(entityToRender)--Position - 0x1F3314
	if not IsNamedRendertargetRegistered("xm3_safe_01a") then
		RegisterNamedRendertarget("xm3_safe_01a", false)
	else
		LinkNamedRendertarget(GetEntityModel(entityToRender))
		if IsNamedRendertargetLinked(GetEntityModel(entityToRender)) then
			renderTargetId = GetNamedRendertargetRenderId("xm3_safe_01a")
        end
	end
end

local function loadScaleformMovie()--Position - 0x1F3435
	scaleform = RequestScaleformMovie("DIGITAL_SAFE_DISPLAY")
	if HasScaleformMovieLoaded(scaleform) then
		return true
    end
	return false
end


local function drawOnSafe(entityToRender)--Position - func_6879
	if scaleform == -1 and not loadScaleformMovie() then
		return
    end

	if not DoesEntityExist(entityToRender) then
		return
    end

	if renderTargetId == -1 then
		registerRenderTarget(entityToRender)
		return
    end

	SetTextRenderId(renderTargetId)
	SetScriptGfxDrawOrder(4)
	SetScriptGfxDrawBehindPausemenu(true)
	DrawScaleformMovie(scaleform, 0.205, 0.17, 0.4, 0.4, 255, 255, 255, 255, 0)
	SetTextRenderId(GetDefaultScriptRendertargetRenderId())
end

local function getSafeAnimDict()
	return "ANIM@SCRIPTED@PLAYER@FREEMODE@IG5_SAFE_CRACK@MALE@"
end

local function getStashAnimBasedOnPhase(animPhase, playerAnim, safeAnim, camAnim, cashAnim)--Position - 0x1F3F53
	if animPhase == 0 then
        if playerAnim then
            return "enter_player"
        end
        if safeAnim then
            return "enter_safe"
        end
        if camAnim then
            return "enter_cam"
        end
    elseif animPhase == 1 then
        if playerAnim then
            return "idle_player"
        end
        if safeAnim then
            return "idle_safe"
        end
        if camAnim then
            return "idle_cam"
        end
	elseif animPhase == 2 then
        if playerAnim then
            return "input_safe_code_left_player"
        end
        if safeAnim then
            return "input_safe_code_left_safe"
        end
        if camAnim then
            return "input_safe_code_left_cam"
        end
	elseif animPhase == 3 then
        if playerAnim then
            return "input_safe_code_right_player"
        end
        if safeAnim then
            return "input_safe_code_right_safe"
        end
        if camAnim then
            return "input_safe_code_right_cam"
        end
	elseif animPhase == 4 then
        if playerAnim then
            return "exit_player"
        end
        if camAnim then
            return "exit_cam"
        end
        if safeAnim then
            return "exit_safe"
        end
	elseif animPhase == 5 then
        if playerAnim then
            return "door_open_player"
        end
        if safeAnim then
            return "door_open_safe"
        end
        if camAnim then
            return "door_open_cam"
        end
        if cashAnim then
            return "door_open_cash_bond"
        end
	elseif animPhase == 6 then
        if playerAnim then
            return "fail_player"
        end
        if safeAnim then
            return "fail_safe"
        end
        if camAnim then
            return "fail_cam"
        end
	elseif animPhase == 7 then
        if playerAnim then
            return "success_with_stack_bonds_player"
        end
        if safeAnim then
            return "success_with_stack_bonds_safe"
        end
        if camAnim then
            return "success_with_stack_bonds_cam"
        end
        if cashAnim then
            return "success_with_stack_bonds_cash_bond"
        end
    end

	return ""
end

local function createAndStartSyncedScene(safe, animDict, scenePhase, hold, loop)--Position - 0x1F463F
    local coords, rot = GetEntityCoords(safe), GetEntityRotation(safe)

	syncedScene = NetworkCreateSynchronisedScene(coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, 2, hold, loop, 1.0, 0.0, 1.0)
	NetworkAddPedToSynchronisedScene(PlayerPedId(), syncedScene, animDict, getStashAnimBasedOnPhase(scenePhase, true, false, false, false), 2.0, -4.0, 134149, 16, 1000.0, 8192)
	NetworkAddEntityToSynchronisedScene(safe, syncedScene, animDict, getStashAnimBasedOnPhase(scenePhase, false, true, false, false), 2.0, -4.0, 134149)
	NetworkStartSynchronisedScene(syncedScene)
end

function ESX.StartSafeStashCrack(safe, passcode) --{10, 20, 30} xm3_prop_xm3_safe_01a
    local currentPasscode, selectedDigits, cracked = {0, 0, 0}, 2, false

    if not DoesEntityExist(safe) then
        return
    end

    local animDict <const> = getSafeAnimDict()
    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end

    createAndStartSyncedScene(safe, animDict, 0, true, false)

    Citizen.Wait(1000)

    createAndStartSyncedScene(safe, animDict, 1, true, false)

    setScaleformState(1)

    while true do
        drawOnSafe(safe)

        if IsControlJustReleased(0, 174) then --ARROW LEFT
            selectedDigits = (selectedDigits - 1) % 3
            setScaleformCursorAndDigits(false, selectedDigits, currentPasscode[selectedDigits+1])
        end

        if IsControlJustReleased(0, 175) then --ARROW RIGHT
            selectedDigits = (selectedDigits + 1) % 3
            setScaleformCursorAndDigits(false, selectedDigits, currentPasscode[selectedDigits+1])
        end

        if IsControlJustReleased(0, 172) then --ARROW UP
            currentPasscode[selectedDigits+1] = (currentPasscode[selectedDigits+1] + 1) % 100
            setScaleformCursorAndDigits(true, selectedDigits, currentPasscode[selectedDigits+1])

            if not IsEntityPlayingAnim(PlayerPedId(), animDict, getStashAnimBasedOnPhase(3, true, false, false, false), 3) then
                Citizen.CreateThread(function()
                    createAndStartSyncedScene(safe, animDict, 3, false, true)
                    Citizen.Wait(1000)
                    createAndStartSyncedScene(safe, animDict, 1, true, false)
                end)
            end
        end

        if IsControlJustReleased(0, 173) then --ARROW DOWN
            currentPasscode[selectedDigits+1] = (currentPasscode[selectedDigits+1] - 1) % 100
            setScaleformCursorAndDigits(true, selectedDigits, currentPasscode[selectedDigits+1])

            if not IsEntityPlayingAnim(PlayerPedId(), animDict, getStashAnimBasedOnPhase(2, true, false, false, false), 3) then
                Citizen.CreateThread(function()
                    createAndStartSyncedScene(safe, animDict, 2, false, true)
                    Citizen.Wait(1000)
                    createAndStartSyncedScene(safe, animDict, 1, true, false)
                end)
            end
        end

        if IsControlJustReleased(0, 201) then --ENTER
            if currentPasscode[1] == passcode[1] and currentPasscode[2] == passcode[2] and currentPasscode[3] == passcode[3] then
                setScaleformState(3)
                cracked = true
                Citizen.CreateThread(function()
                    createAndStartSyncedScene(safe, animDict, 5, false, true)
                    Citizen.Wait(2300)
                    createAndStartSyncedScene(safe, animDict, 7, true, false)
                    Citizen.Wait(2000)
                    ClearPedTasks(PlayerPedId())
                end)
                break
            else
                setScaleformState(2)
                cracked = false
                Citizen.CreateThread(function()
                    createAndStartSyncedScene(safe, animDict, 6, true, false)
                    Citizen.Wait(2000)
                    setScaleformState(1)
                end)
            end
        end

        if IsControlJustReleased(0, 202) or IsControlJustReleased(0, VK_ESCAPE) then --BACKSPACE or ESC
            setScaleformState(0)
            cracked = false
            Citizen.CreateThread(function()
                createAndStartSyncedScene(safe, animDict, 4, true, false)
                Citizen.Wait(1000)
                ClearPedTasks(PlayerPedId())
            end)
            break
        end

        Citizen.Wait(0)
    end

    return cracked
end