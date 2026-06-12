

local heist = LoadOrnateHeist()
local rouletteWords = heist.rouletteWords
local programEvent, lives = 0, 5
local UsingComputer, Hacking, SorF, Ipfinished = false, false, false, false

local function disableControlForHacking()
    DisableControlAction(0, 73, false)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 32, true)
    DisableControlAction(0, 34, true)
    DisableControlAction(0, 31, true)
    DisableControlAction(0, 30, true)
    DisableControlAction(0, 45, true)
    DisableControlAction(0, 22, true)
    DisableControlAction(0, 44, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 23, true)
    DisableControlAction(0, 288, true)
    DisableControlAction(0, 289, true)
    DisableControlAction(0, 170, true)
    DisableControlAction(0, 167, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(2, 199, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
end

local function scaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end

local function prepareBruteScaleform(scaleformName)
    local bruteScaleform = RequestScaleformMovieInteractive(scaleformName)

    while not HasScaleformMovieLoaded(bruteScaleform) do
        Citizen.Wait(0)
    end

    local CAT = 'hack'
    local CurrentSlot = 0
    while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
        Citizen.Wait(0)
        CurrentSlot = CurrentSlot + 1
    end

    if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
        ClearAdditionalText(CurrentSlot, true)
        RequestAdditionalText(CAT, CurrentSlot)
        while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Citizen.Wait(0)
        end
    end

    PushScaleformMovieFunction(bruteScaleform, "SET_LABELS")
    scaleformLabel("H_ICON_1")
    scaleformLabel("H_ICON_2")
    scaleformLabel("H_ICON_3")
    scaleformLabel("H_ICON_4")
    scaleformLabel("H_ICON_5")
    scaleformLabel("H_ICON_6")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_BACKGROUND")
    PushScaleformMovieFunctionParameterInt(1)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(1.0)
    PushScaleformMovieFunctionParameterFloat(4.0)
    PushScaleformMovieFunctionParameterString("My Computer")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "ADD_PROGRAM")
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterFloat(6.0)
    PushScaleformMovieFunctionParameterString("Power Off")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_LIVES")
    PushScaleformMovieFunctionParameterInt(lives)
    PushScaleformMovieFunctionParameterInt(5)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(math.random(150,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterInt(math.random(160,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(2)
    PushScaleformMovieFunctionParameterInt(math.random(170,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(3)
    PushScaleformMovieFunctionParameterInt(math.random(190,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(4)
    PushScaleformMovieFunctionParameterInt(math.random(200,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(5)
    PushScaleformMovieFunctionParameterInt(math.random(210,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(6)
    PushScaleformMovieFunctionParameterInt(math.random(220,255))
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(bruteScaleform, "SET_COLUMN_SPEED")
    PushScaleformMovieFunctionParameterInt(7)
    PushScaleformMovieFunctionParameterInt(255)
    PopScaleformMovieFunctionVoid()
    return bruteScaleform
end

local function drawBruteOnScreen(scaleform)
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    PushScaleformMovieFunction(scaleform, "SET_CURSOR")
    PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
    PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
    PopScaleformMovieFunctionVoid()

    if IsDisabledControlJustPressed(0,24) and not SorF then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
        programEvent = PopScaleformMovieFunction()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 176) and Hacking then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
        programEvent = PopScaleformMovieFunction()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
        PopScaleformMovieFunctionVoid()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 172) and Hacking then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
        PushScaleformMovieFunctionParameterInt(8)
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 173) and Hacking then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
        PushScaleformMovieFunctionParameterInt(9)
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 174) and Hacking then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
        PushScaleformMovieFunctionParameterInt(10)
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    elseif IsDisabledControlJustPressed(0, 175) and Hacking then
        PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT")
        PushScaleformMovieFunctionParameterInt(11)
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    end
end

function ESX.BruteMinigame()
    local scaleform <const> = prepareBruteScaleform("HACKING_PC")
    UsingComputer, Hacking, SorF, Ipfinished = true, false, false, false

    Citizen.CreateThread(function()
        while UsingComputer do
            Citizen.Wait(0)
            drawBruteOnScreen(scaleform)
        end
    end)

    while UsingComputer do
        Citizen.Wait(0)
        if HasScaleformMovieLoaded(scaleform) and UsingComputer then
            disableControlForHacking()
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)

            if IsScaleformMovieMethodReturnValueReady(programEvent) then
                local program = GetScaleformMovieFunctionReturnInt(programEvent)
                if program == 82 and not Hacking then
                    lives = 5
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(0.0)
                    PopScaleformMovieFunctionVoid()
                    Hacking = true
                    ESX.ShowNotification("Find the IP adress...", "success")
                elseif program == 83 and not Hacking and Ipfinished then

                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(rouletteWords[math.random(#rouletteWords)])
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                    ESX.ShowNotification("Find the password...", "success")
                elseif Hacking and program == 87 then
                    lives = lives - 1
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and program == 84 then
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_IP_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    scaleformLabel(0x18EBB648)
                    PopScaleformMovieFunctionVoid()
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    Ipfinished = true
                    ESX.ShowNotification("Run BruteForce.exe", "success")
                elseif Hacking and program == 85 then
                    PlaySoundFrontend(-1, "HACKING_FAILURE", "", false)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false
                elseif Hacking and program == 86 then
                    SorF = true
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    scaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(0)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    ESX.ShowNotification("Hacked!", "success")

                    UsingComputer = false
                    Ipfinished = false
                    return true
                elseif program == 6 then
                    UsingComputer = false
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    return false
                end

                if Hacking then
                    PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
                    if lives <= 0 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        scaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Citizen.Wait(1000)
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        Hacking = false
                        SorF = false
                    end
                end
            end
        end
    end

    return false
end
