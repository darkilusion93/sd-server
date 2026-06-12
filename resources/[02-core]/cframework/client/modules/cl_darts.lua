local DartGames = {}
local Instructions = nil
local ClosestTarget = nil
local ClosestGameId = nil
local Dart = nil
local ScoreBoard = nil
local DartCam = nil
local PlayingDart = false

local OnlyRestricted = false
local RestrictedCoords = {
    {coords = vector3(1993.46, 3050.0, 47.22), radius = 10.0},
    {coords = vector3(-1512.41, 109.44, 55.67), radius = 10.0}
}

function IsPlayingDarts()
    return PlayingDart
end
--[[ TODO: Make darts like GTA:O
-- Sync current Dart games when connecting
TriggerServerEvent('cframework:syncDartGames')


RegisterNetEvent('cframework:syncDartGames', function(games)
    --print('sync all games')
    DartGames = games
end)

RegisterNetEvent('cframework:createDartGame', function(id, game)
--   print('createGame ' .. id .. ' ' .. game.coords)

    -- Remove game at coords if there was one
    for gameId, gameInfo in pairs(DartGames) do
        if gameInfo.coords == game.coords then
            if ClosestGameId == gameId then
                CleanDartBoard()
            end
            --print('remove game ' .. gameId)
            DartGames[gameId] = nil
            break
        end
    end

    DartGames[id] = game
end)

RegisterNetEvent('cframework:addDartScore', function(id, score, soundName, finished)
    --print('addScore ' .. id .. ' ' .. score)
    table.insert(DartGames[id].playersScores, {value = score, drawn = false})

    if finished then
        DartGames[id].finished = finished
    end

    if ClosestGameId == id and soundName then -- Check if we are next to target to play sound
        PlaySoundFromEntity(-1, soundName, ClosestTarget, 0, 0, 0)
    end
end)



Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local target = GetClosestObjectOfType(playerCoords, 15.0, `prop_dart_bd_cab_01`, false, false, false)
        local targetExists = target ~= 0 and DoesEntityExist(target)

        --Player went near target
        if targetExists and (not ClosestTarget or not ScoreBoard) then
            --print('in')
            ClosestTarget = target
            RequestScoreBoard()
            SetPlayerName('Jogador 1', 'Jogador 2')
            StartDartThread()
        end

        if not targetExists and ClosestTarget then
            --print('out')
            ClosestTarget = nil
            CleanDartBoard()
        end

        ClosestGameId = GetClosestGameId()

        if targetExists then
            -- Check closest game to draw if necessary
            DrawNewScores(ClosestGameId)
        end

        Citizen.Wait(1000)
    end
end)

function GetClosestGameId()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestDistance = 15.0
    for id, gameInfo in pairs(DartGames) do
        local distance = #(playerCoords - gameInfo.coords)
        if distance < closestDistance then
            return id
        end
    end
end

function DrawNewScores(id)
    if not id then return end

    local dartGameScores = DartGames[id].playersScores
    for scoreId, playerScore in ipairs(dartGameScores) do
        if not playerScore.drawn then
            local player = scoreId-1 < 2 and scoreId-1 or (scoreId-3)%6 >= 3 and 1 or 0
            local otherPlayer = player == 1 and 0 or 1

            SetScoreOnScoreBoard(player, playerScore.value)
            dartGameScores[scoreId].drawn = true

            if not DartGames[id].won and playerScore.value == 0 then
                SetPlayerName(player == 0 and 'WINNER' or 'Jogador 1', player == 1 and 'WINNER' or 'Jogador 2')
                DartGames[id].won = true
            else
                local nextPlayer = scoreId-1 < 2 and 0 or (scoreId-3)%3 < 2 and player or otherPlayer
                SetPlayerName(nextPlayer == 0 and '> Jogador 1' or 'Jogador 1', nextPlayer == 1 and '> Jogador 2' or 'Jogador 2')
            end
        end
    end
end

-- Clean score board points and remove scaleform
function CleanDartBoard()
    -- print('CleanDartBoard')
    -- Clear all drawn scores
    for id, gameInfo in pairs(DartGames) do
        for scoreId, _ in pairs(gameInfo.playersScores) do
            DartGames[id].playersScores[scoreId].drawn = false
        end
    end

    -- Clean scaleform
    ClearScoreBoard()

    -- Unload scaleform
    SetScaleformMovieAsNoLongerNeeded(ScoreBoard)
    ReleaseNamedScriptAudioBank('SCRIPT\\DARTS')

    ScoreBoard = nil
end

local function RotationToDirection(rotation)
    local oneDegInRad = math.pi / 180
    local adjustedRotation = vector3(oneDegInRad * rotation.x, oneDegInRad * rotation.y, oneDegInRad * rotation.z)
    return vector3(
      -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
      math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
      math.sin(adjustedRotation.x))
end

-- Get entity's ID and coords from where player is targeting
function DartTarget(distance)
    local camCoords = GetGameplayCamCoord()
    local camRot    = GetGameplayCamRot()

    distance = distance + #(camCoords - GetEntityCoords(PlayerPedId())) -- To account for different view mode (when camera is far from player)

    local direction = RotationToDirection(camRot)
    local destination = vector3(
    camCoords.x + direction.x * distance,
    camCoords.y + direction.y * distance,
    camCoords.z + direction.z * distance)


    -- DrawMarker(27, destination.x, destination.y, destination.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 100, 255, 0, 100, false, true, 2, false, false, false, false)
    -- DrawLine(camCoords.x, camCoords.y, camCoords.z, destination.x, destination.y, destination.z, 255, 0, 0, 255)

    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(camCoords.x, camCoords.y, camCoords.z, destination.x, destination.y, destination.z, 497, PlayerPedId(), 0)
    local a, hit, hitCoords, surfaceNormal, entity = GetShapeTestResult(rayHandle)

    -- DrawMarker(27, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 100, 255, 0, 100, false, true, 2, false, false, false, false)

    return hit, hitCoords, surfaceNormal, entity
end



function StartDartThread()
    local scoreCoords = GetOffsetFromEntityInWorldCoords(ClosestTarget, vector3(-0.687645, -0.350352, 0.343273))
    local rot         = vector3(180.0, 0.0, GetEntityHeading(ClosestTarget)+30.0)
    local scale       = vector3(1.82, 1.328, 1)

    local throwCoords = GetOffsetFromEntityInWorldCoords(ClosestTarget, vector3(0.085, -3.3, -0.774))
    local cleanCoords = GetOffsetFromEntityInWorldCoords(ClosestTarget, vector3(0.04, -0.7, -0.7))

    -- Draw scoreboard thread
    Citizen.CreateThread(function()
        while ClosestTarget do
            DrawScaleformMovie_3d(ScoreBoard, scoreCoords, rot, scale, scale, 2)
            Citizen.Wait(0)
        end
    end)

    -- Throw dart
    Citizen.CreateThread(function()
        while ClosestTarget do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(throwCoords - playerCoords)

            if ClosestGameId and DartGames[ClosestGameId] and not PlayingDart and not IsPlayingPool() and not DartGames[ClosestGameId].finished and distance < 1.5 then
                ESX.ShowHelpNotification('Pressione ~INPUT_PICKUP~ para atirar')
                if IsControlJustPressed(0, 38) then
                    local success = RPC.execute("cframework:canPlayDart", ClosestGameId)

                    if success then
                        -- Walk to throw spot
                        PlayingDart = true
                        TaskGoStraightToCoord(playerPed, throwCoords.x, throwCoords.y, throwCoords.z, 1.0, 3000, GetEntityHeading(ClosestTarget))
                        Citizen.Wait(1000)
                        SetEntityCoords(playerPed, vector3(throwCoords.x, throwCoords.y, throwCoords.z-1.0))
                        TaskTurnPedToFaceEntity(playerPed, ClosestTarget, 1000)
                        Citizen.Wait(500)
                        PlayDart(3)
                        TriggerServerEvent('cframework:stoppedPlayDart', ClosestGameId)
                        PlayingDart = false
                    else
                        ESX.ShowNotification('Alguém já está a jogar', 'error')
                    end
                end
            end
        end
    end)

    -- Start new game
    Citizen.CreateThread(function()
        local closeToTarget = nil

        while ClosestTarget do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(cleanCoords - playerCoords)

            if not PlayingDart and not IsPlayingPool() and distance < 0.5 then
                if not closeToTarget then
                    closeToTarget = true
                    Instructions = SetupInstructionalButtons({{key = 23,  label = "Iniciar um jogo de dardos"} })
                end

                if IsAllowedToPlay() and (ClosestGameId and DartGames[ClosestGameId].finished or not ClosestGameId) then
                    DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
                    if IsControlJustPressed(0, 23) then
                        if GetCloseDartsCount() > 0 then
                            RetreiveDart()
                        end

                        local success = RPC.execute("cframework:createDartGame", GetEntityCoords(ClosestTarget))

                        if success then
                            -- Walk to throw spot
                            PlayingDart = true
                            TaskGoStraightToCoord(playerPed, throwCoords.x, throwCoords.y, throwCoords.z, 1.0, 3000, GetEntityHeading(ClosestTarget))
                            Citizen.Wait(3000)
                            SetEntityCoords(playerPed, vector3(throwCoords.x, throwCoords.y, throwCoords.z-1.0))
                            TaskTurnPedToFaceEntity(playerPed, ClosestTarget, 500)
                            Citizen.Wait(500)

                            PlayDart(3)
                            PlayingDart = false
                        else
                            ESX.ShowNotification('Já existe um jogo em andamento neste alvo', 'error')
                        end
                    end
                end
            else
                closeToTarget = false
            end
        end
  end)
end

function PlayingDartThread()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local targetCoords = GetEntityCoords(ClosestTarget)
        local targetHeading = GetEntityHeading(ClosestTarget)
        SetEntityHeading(playerPed, targetHeading)
        SetCamRot(playerPed, targetHeading)

        DartCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        local camCoords = GetOffsetFromEntityInWorldCoords(playerPed, vector3(0.45, -0.30, 0.5))

        SetCamCoord(DartCam, camCoords)
        SetCamActive(DartCam, true)
        RenderScriptCams(true, true, 1500, true, true)

        while PlayingDart do
            Citizen.Wait(0)

            local gameplayCamRot = GetGameplayCamRot() -- pitch roll yaw
            SetEntityHeading(playerPed, gameplayCamRot.z)
            SetCamRot(DartCam, gameplayCamRot)

            -- Disable movement
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 30, true) -- D

            DisableControlAction(0, 24, true) -- Left click

            if Instructions then
                DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            end
        end

        SetCamActive(DartCam, false)
        DestroyCam(DartCam, false)
        RenderScriptCams(false, true, 1500, true, true)
    end)
end



function PlayDart(throwCount)
    PlayingDartThread()

    -- Check first if player must retreive darts (usefull to not have to many darts which cause Target function to return darts entities too often)
    if GetCloseDartsCount() >= 6 then
        ESX.ShowNotification('Há muitos dardos para jogar...', 'error')
        return
    end

    -- Setup instructions
    Instructions = SetupInstructionalButtons({{key = 24,  label = "Puxar"} })

    -- Unarm player
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)

    local count = 0
    local mustStop = false

    while count < throwCount and not mustStop do

        -- Check if player is still around start coordinates
        if mustStop or #(GetEntityCoords(playerPed) - playerCoords) > 5.0 then
          return
        end

        -- Wait in idle anim until key pressed (blocking)
        ThrowIdle()

        -- Find target coords
        local hit, hitCoords, surfaceNormal, entity
        count = count + 1

        -- Search for target
        while not hit do
            Citizen.Wait(0)
            hit, hitCoords, surfaceNormal, entity = DartTarget(8.0)
        end

        -- Throw anim
        DoAnimNonBlocking('mini@darts', 'throw_overlay')

        -- Throw sound
        PlaySoundFromEntity(-1, "DARTS_THROW_DART_MASTER", PlayerPedId(), 0, 0, 0)

        -- Dart traveling (blocking)
        TravelDart(Dart, hitCoords, true)

        local relativeHitCoords = GetOffsetFromEntityGivenWorldCoords(ClosestTarget, hitCoords)
        TriggerServerEvent('cframework:addDartPoints', ClosestGameId, relativeHitCoords)

        mustStop = RPC.execute("cframework:mustStopDarts", ClosestGameId)

        Citizen.Wait(2000)
    end

    -- Game finished, walk to target to remove darts
    local cleanCoords = GetOffsetFromEntityInWorldCoords(ClosestTarget, vector3(0.04, -0.7, -0.7))
    Instructions = SetupInstructionalButtons({{key = 23,  label = "Pegar de volta os dardos"} })
    TaskGoStraightToCoord(PlayerPedId(), cleanCoords.x, cleanCoords.y, cleanCoords.z, 1.0, 3000, GetEntityHeading(ClosestTarget), 0)
    while not IsControlJustPressed(0, 23) do
        Citizen.Wait(0)
    end
    RetreiveDart()
end



function ThrowIdle()
    local playerPed = PlayerPedId()
    local startCoords = GetEntityCoords(playerPed)

    local animDict = 'anim@amb@clubhouse@mini@darts@'
    local anim = 'throw_idle_a'
    ESX.Streaming.RequestAnimDict(animDict)
    ESX.Streaming.RequestModel(`prop_dart_1`)
    Dart = CreateObject(`prop_dart_1`, startCoords.x, startCoords.y, startCoords.z, true, true, true)
	SetEntityAsNoLongerNeeded(Dart)
    -- print('Dart created ' .. Dart)
    local boneIndex = GetPedBoneIndex(playerPed, 0xDEAD)

    AttachEntityToEntity(Dart, playerPed, boneIndex, 0.145, 0.043, 0.001, 220.0, 190.0, 0.0, true, true, false, true, 1, true)

    while not IsControlJustPressed(0, 69) do
        Citizen.Wait(0)
        if not IsEntityPlayingAnim(playerPed, animDict, anim, 3) then
            TaskPlayAnim(playerPed, animDict, anim, 8.0, -8, -1, 120, 0, false, false, false)
            -- Check distance if player isn't leaving with an arrow in his hand
            if #(GetEntityCoords(playerPed) - startCoords) > 5.0 then
                return
            end
        end
    end
end

function DoAnimNonBlocking(animDict, anim)
    Citizen.CreateThread(function()
        DoAnim(animDict, anim)
    end)
end

function DoAnim(animDict, anim)
    ESX.Streaming.RequestAnimDict(animDict)
    local duration = GetAnimDuration(animDict, anim) * 1000
    TaskPlayAnim(PlayerPedId(), animDict, anim, 8.0, -8, duration, 120, 0, false, false, false)
    Citizen.Wait(duration)
end


function TravelDart(entity, destCoords, travelCam)
    local sourceCoords = GetEntityCoords(entity)
    local distance = #(destCoords - sourceCoords)
    local dirNormalized = (destCoords - sourceCoords)/distance

    -- print('Traval ' .. entity .. ' from ' .. sourceCoords .. ' to ' .. destCoords)

    local nbSteps = 25
    local i = 0
    local previousCoords = sourceCoords
    local startCamCoords = GetCamCoord(DartCam)

    local distIncr = distance/nbSteps * dirNormalized

    RequestNetworkControlOfEntity(Dart, 2000, function()
        while i < nbSteps do
            i = i + 1

            DetachEntity(Dart, true, false) -- Detach Dart every frame (Once is not enough even with IsEntityAttached)
            -- Adjust dart rotation based on found target
            local rot = GetEntityRotation(ClosestTarget)
            SetEntityRotation(Dart, rot.x+90.0, rot.y+90.0, rot.z)

            local newCoords = previousCoords + distIncr

            if travelCam and i > 3 and i < nbSteps * 0.8 then
                SetCamCoord(DartCam, previousCoords - 2*distIncr)
            end

            SetEntityCoords(entity, newCoords)
            -- print('step ' .. i .. ' ' .. newCoords .. ' real coords ' .. GetEntityCoords(entity))
            previousCoords = newCoords
            Citizen.Wait(0)
        end
    end)

    if travelCam then
        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            SetCamCoord(DartCam, startCamCoords)
        end)
    end
end


function RetreiveDart()
    DoAnimNonBlocking('mini@darts', 'retrieve_to_wait')
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())

    local continue = true
    while continue do
        Citizen.Wait(100)
        local dart = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `prop_dart_1`)
        if DoesEntityExist(dart) then
            ESX.Game.DeleteEntity(dart)
        else
            continue = false
        end
    end
end

function GetCloseDartsCount()
    local dartCount = 0
    for _, object in pairs(ESX.Game.GetObjects()) do
        if GetEntityModel(object) == `prop_dart_1` then
            dartCount = dartCount + 1
        end
    end

    return dartCount
end





function RequestScoreBoard()
    -- Request sounds
    while not RequestScriptAudioBank('SCRIPT\\DARTS', 0) do Citizen.Wait(0) end

    ESX.Streaming.RequestStreamedTextureDict("Darts")
    ESX.Streaming.RequestStreamedTextureDict("ShopUI_Title_Darts")
    ScoreBoard = RequestScaleformMovie_2("darts_scoreboard")

    while not HasScaleformMovieLoaded(ScoreBoard) do
        Citizen.Wait(0)
    end

    RequestAdditionalText("DARTS", 3)
end

function SetScoreOnScoreBoard(player, score) -- Player is 0 or 1
    BeginScaleformMovieMethod(ScoreBoard, "ADD_DARTS_SCORE")
    ScaleformMovieMethodAddParamInt(player)
    ScaleformMovieMethodAddParamInt(score)
    EndScaleformMovieMethod()
end

function SetPlayerName(playerOne, playerTwo)
    BeginScaleformMovieMethod(ScoreBoard, "SET_DARTS_PLAYER_NAMES")
    ScaleformMovieMethodAddParamPlayerNameString(playerOne)
    ScaleformMovieMethodAddParamPlayerNameString(playerTwo)
    EndScaleformMovieMethod()
end

function ClearScoreBoard()
    BeginScaleformMovieMethod(ScoreBoard, "CLEAR_SCORES")
    ScaleformMovieMethodAddParamInt(1)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(ScoreBoard, "CLEAR_SCORES")
    ScaleformMovieMethodAddParamInt(2)
    EndScaleformMovieMethod()
end

function SetTitle()
    BeginScaleformMovieMethod(ScoreBoard, "SET_DISPLAY_TYPE")
    ScaleformMovieMethodAddParamInt(1)
    EndScaleformMovieMethod()
end


function RequestNetworkControlOfEntity(entity, timeout, cb)
    timeout = GetGameTimer() + timeout

    while DoesEntityExist(entity) and not NetworkHasControlOfEntity(entity) and GetGameTimer() < timeout do
        Citizen.Wait(0)
        NetworkRequestControlOfEntity(entity)
    end

    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
        cb(true)
    else
        cb(false)
    end
end


function IsAllowedToPlay()
    if not OnlyRestricted then
        return true
    else
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for _, zone in pairs(RestrictedCoords) do
            if #(zone.coords - playerCoords) < zone.radius then
                return true
            end
        end
        return false
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        local continue = true
        while continue do
            Citizen.Wait(100)
            local dart = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `prop_dart_1`)
            if DoesEntityExist(dart) then
                ESX.Game.DeleteEntity(dart)
            else
                continue = false
            end
        end
    end
end)



-- -- debug thread
-- Citizen.CreateThread(function()

--   while true do
--     Citizen.Wait(0)

--     -- print(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), vector3(1995.83, 3049.48, 47.22)))

--     local camCoords = GetGameplayCamCoord()


--     -- Find target coords
--     local hit, hitCoords, surfaceNormal, entity = DartTarget(4.0)

--     DrawLine(camCoords.x, camCoords.y, camCoords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 0, 0, 255)
--   end
-- end)
]]