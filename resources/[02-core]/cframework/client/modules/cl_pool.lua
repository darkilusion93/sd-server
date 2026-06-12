
-- ball rotation ?
local CurrentInstance = {id = ""}

local PoolGames = {}
local NearestTable
local InPoolAction = false
local HandCueEntity = nil
local CurrentTeam = nil
local Instructions = nil
local PlayingPool = false
local isPlayerSpawned = false
local GameThreadRunning = false

local firstImpactTeam = ""
local firstImpact = false

local SyncDistance = 100.0
local DampingFactor = 0.99

local TableModels = {
    `prop_pooltable_02`,
    `prop_pooltable_3b`,
}

local ModelsToClean = {
    `prop_pool_ball_01`,
    `prop_pool_tri`,
    `prop_poolball_cue`,
    `prop_pool_cue`,
    `prop_poolball_1`,
    `prop_poolball_2`,
    `prop_poolball_3`,
    `prop_poolball_4`,
    `prop_poolball_5`,
    `prop_poolball_6`,
    `prop_poolball_7`,
    `prop_poolball_8`,
    `prop_poolball_9`,
    `prop_poolball_10`,
    `prop_poolball_11`,
    `prop_poolball_12`,
    `prop_poolball_13`,
    `prop_poolball_14`,
    `prop_poolball_15`,
}

local BallLabels = {
    [`prop_poolball_cue`] = 'Branca',
    [`prop_poolball_1`]   = 'Lisa 1',
    [`prop_poolball_2`]   = 'Lisa 2',
    [`prop_poolball_3`]   = 'Lisa 3',
    [`prop_poolball_4`]   = 'Lisa 4',
    [`prop_poolball_5`]   = 'Lisa 5',
    [`prop_poolball_6`]   = 'Lisa 6',
    [`prop_poolball_7`]   = 'Lisa 7',
    [`prop_poolball_8`]   = 'Preta',
    [`prop_poolball_9`]   = 'Listrada 9' ,
    [`prop_poolball_10`]  = 'Listrada 10',
    [`prop_poolball_11`]  = 'Listrada 11',
    [`prop_poolball_12`]  = 'Listrada 12',
    [`prop_poolball_13`]  = 'Listrada 13',
    [`prop_poolball_14`]  = 'Listrada 14',
    [`prop_poolball_15`]  = 'Listrada 15',
}

local TableSize = {
    [`prop_pooltable_02`] = {
        YMax = 1.435,
        YMin = -1.18,
        XMax = 0.65,
        XMin = -0.80,
    },
    [`prop_pooltable_3b`] = {
        YMax = 1.3,
        YMin = -1.3,
        XMax = 0.72,
        XMin = -0.72,
    }
}

local LineY = {
    [`prop_pooltable_02`] = 0.83,
    [`prop_pooltable_3b`] = 0.7,
}

local MinHoleDistance = 0.21
local AngleTolerance = 45.0 -- 45 means 45 on each side so 90°
local Holes = {
    [`prop_pooltable_02`] = {
        vector2(-0.86, 1.5),
        vector2( 0.72, 1.5),
        vector2(-0.90,  0.13),
        vector2( 0.76,  0.13),
        vector2(-0.86, -1.25),
        vector2( 0.72, -1.25),
    },
    [`prop_pooltable_3b`] = {
        vector2(-0.80, 1.38),
        vector2( 0.80, 1.38),
        vector2(-0.84,  0.0),
        vector2( 0.84,  0.0),
        vector2(-0.80, -1.38),
        vector2( 0.80, -1.38),
    }
}

local BallsTeams = {
    [`prop_poolball_cue`] = 'white',
    [`prop_poolball_1`]   = 'solid',
    [`prop_poolball_2`]   = 'solid',
    [`prop_poolball_3`]   = 'solid',
    [`prop_poolball_4`]   = 'solid',
    [`prop_poolball_5`]   = 'solid',
    [`prop_poolball_6`]   = 'solid',
    [`prop_poolball_7`]   = 'solid',
    [`prop_poolball_8`]   = 'black',
    [`prop_poolball_9`]   = 'stripe',
    [`prop_poolball_10`]  = 'stripe',
    [`prop_poolball_11`]  = 'stripe',
    [`prop_poolball_12`]  = 'stripe',
    [`prop_poolball_13`]  = 'stripe',
    [`prop_poolball_14`]  = 'stripe',
    [`prop_poolball_15`]  = 'stripe',
}


function IsPlayingPool()
    return PlayingPool
end

local function ArrayHasValue(array, value, field)
	if field then
		for k, v in pairs(array) do
			if value == v[field] then
				return k
			end
		end
	else
		for k, v in pairs(array) do
			if value == v then
				return k
			end
		end
	end
end

local function ApplyRotationMatrix(vector, heading)
	local headingSin = math.sin(heading * math.pi/180.0)
	local headingCos = math.cos(heading * math.pi/180.0)
    if type(vector) == 'vector3' then
        return vector3(
            ((vector.x * headingCos) - (vector.y * headingSin)),
            ((vector.x * headingSin) + (vector.y * headingCos)),
            vector.z)
    else
        return vector2(
            ((vector.x * headingCos) - (vector.y * headingSin)),
            ((vector.x * headingSin) + (vector.y * headingCos)))
    end
end

local function DotProduct2D(a, b)
    return a.x * b.x + a.y * b.y
end

RegisterNetEvent('cframework:joinedInstance', function(instance)
	CurrentInstance = instance
end)

RegisterNetEvent('cframework:leftInstance', function(instance)
	CurrentInstance = nil
end)

RegisterNetEvent('cframework:syncPoolGames', function(poolGames)
    PoolGames = poolGames
end)

AddEventHandler('playerSpawned', function()
	isPlayerSpawned = true
end)

RegisterNetEvent('cframework:startPoolGame', function(tableId, tableConfig)
    PoolGames[tableId] = tableConfig
    if IsInPoolGameSyncRadius(tableId) then
        PoolGames[tableId].Initialized = true
        ResetPoolGameBalls(tableId)
    end
    -- while true do
    --     -- Debug : Draw holes
    --     for _, holeCoords in pairs(Holes[tableConfig.TableModel]) do
    --         local rotHoleCoords = ApplyRotationMatrix(holeCoords, PoolGames[tableId].TableHeading)
    --         local coords = PoolGames[tableId].TableCoords + vector3(rotHoleCoords.x, rotHoleCoords.y, 0.93)
    --         DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, MinHoleDistance, MinHoleDistance, 0.1, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
    --     end
    --     Citizen.Wait(0)
    -- end
end)

RegisterNetEvent('cframework:endPoolGame', function(tableId)
    PoolGames[tableId] = nil
    if PlayingPool and GetEntityCoords(NearestTable) == tableId then
        PlayingPool = false
        TriggerServerEvent("cframework:destroyPoolCue")
        Instructions = SetupInstructionalButtons({ {key = 23,  label = "Jogar Bilhar (bolas lisas)"}, {key = 38,  label = "Jogar Bilhar (bolas listradas)"} })
    end
end)

RegisterNetEvent('cframework:shootPool', function(playerId, tableId, velocity, effect)
    if PoolGames[tableId] and IsInPoolGameSyncRadius(tableId) and GetPlayerServerId(PlayerId()) ~= playerId then
        PoolGames[tableId].Balls[1].Velocity = velocity
        PoolGames[tableId].Balls[1].Effect = effect
        StartPoolGameThread(tableId, false)
    end
end)

RegisterNetEvent('cframework:syncPoolBalls', function(tableId, balls)
    if PoolGames[tableId] then
        if IsInPoolGameSyncRadius(tableId) then
            CleanPoolTable(PoolGames[tableId].TableCoords)
            PoolGames[tableId].Balls = balls
            SpawnPoolBalls(tableId)
        else
            PoolGames[tableId].Balls = balls
        end
    end
end)

function IsInPoolGameSyncRadius(tableId)
    local instanceId = CurrentInstance and CurrentInstance.id or ''

    if #(GetEntityCoords(PlayerPedId()) - PoolGames[tableId].TableCoords) < SyncDistance and instanceId == PoolGames[tableId].InstanceId then
        return true
    end
end

-- Find nearest table object
Citizen.CreateThread(function()
    while not isPlayerSpawned do Citizen.Wait(0) end

    while true do
        local playerPed <const> = PlayerPedId()
        local playerCoords <const> = GetEntityCoords(playerPed)
        local instanceId <const> = CurrentInstance and CurrentInstance.id or ''

        local table = nil
        for _, model in pairs(TableModels) do
            table = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 10.0, model, false, false, false)
            table = (table ~= 0 and DoesEntityExist(table)) and table or nil
            if table then
                break
            end
        end

        -- Going near table
        if table and not IsPlayingDarts() and #(GetEntityCoords(table) - playerCoords) < 3.0 then
            if not PlayingPool then
                Instructions = SetupInstructionalButtons({ {key = 23,  label = "Jogar Bilhar (bolas lisas)"}, {key = 38,  label = "Jogar Bilhar (bolas listradas)"} })
            elseif not InPoolAction then
                Instructions = SetupInstructionalButtons({ {key = 38,  label = "Jogar"}, {key = 177,  label = "Sair"}, {key = 182,  label = "Recomeçar o jogo"} })
            end
        end

        NearestTable = table

        for tableId, poolGame in pairs(PoolGames) do
            if #(playerCoords - poolGame.TableCoords) < SyncDistance and poolGame.InstanceId == instanceId then
                if not poolGame.Initialized then
                    poolGame.Initialized = true
                    ResetPoolGameBalls(tableId)
                end
            elseif poolGame.Initialized then
                poolGame.Initialized = false
                CleanPoolTable(poolGame.TableCoords)
            end
        end

        Citizen.Wait(2000)
    end
end)

-- Interact with nearest table to start game
Citizen.CreateThread(function()
    TriggerServerEvent('cframework:syncPoolGames')

    while true do
        local sleepTime = 1000
        if DoesEntityExist(NearestTable) and not IsPlayingDarts() then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local tableCoords = GetEntityCoords(NearestTable)
            local tableHeading = GetEntityHeading(NearestTable)
            local instanceId = CurrentInstance and CurrentInstance.id or ''
            local tableId = tostring(tableCoords)..instanceId

            if PlayingPool and #(playerCoords-tableCoords) > 5.0 then
                LeavePoolGame()
            elseif #(playerCoords-tableCoords) < 3.0 and not InPoolAction then
                sleepTime = 0
                DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)

                if PoolGames[tableId] and PlayingPool then -- Near existing game and playing
                    DisableControlAction(0, 140, true) -- Block R Melee
                    if IsControlJustPressed(0, 38) then
                        local canPlay, placeCueBall, placeCueBallStart = RPC.execute("cframework:canPlayPool", tableId)

                        if canPlay then
                            if placeCueBall or placeCueBallStart then
                                StartWhiteBallPlacementThread(tableId, placeCueBallStart)
                            else
                                StartThreadShootingWithCue(tableId)
                            end
                        end
                    elseif IsControlJustPressed(0, 177) then -- Backspace
                        LeavePoolGame()
                        Instructions = SetupInstructionalButtons({ {key = 23,  label = "Jogar Bilhar (bolas lisas)"}, {key = 38,  label = "Jogar Bilhar (bolas listradas)"} })
                    elseif IsControlJustPressed(0, 182) then -- L
                        TriggerServerEvent('cframework:cancelPoolGame', tableId)
                        LeavePoolGame()
                    end
                else -- Near existing game but not playing OR No game
                    if IsControlJustPressed(0, 23) or IsControlJustPressed(0, 38) then -- Solid balls team
                        PlayingPool = true
                        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)

                        CurrentTeam = IsControlJustPressed(0, 23) and 'solid' or 'stripe'
                        Instructions = SetupInstructionalButtons({ {key = 38,  label = "Jogar"}, {key = 177,  label = "Sair"}, {key = 182,  label = "Recomeçar o jogo"} })
                        if not PoolGames[tableId] then
                            TriggerServerEvent('cframework:startPoolGame', tableId, tableCoords, tableHeading, GetEntityModel(NearestTable), CurrentTeam, instanceId)
                        else
                            TriggerServerEvent('cframework:joinPoolGame', tableId, CurrentTeam)
                        end
                    end
                end
            end
        end

        Citizen.Wait(sleepTime)
    end
end)

function LeavePoolGame()
    if GameThreadRunning then ESX.ShowNotification('Ainda não podes sair do jogo', 'error') return end
    TriggerServerEvent('cframework:leavePoolGame')
    PlayingPool = false
    ESX.ShowNotification('Saíste do jogo de Bilhar', 'inform')
    TriggerServerEvent("cframework:destroyPoolCue")
end

function ResetPoolGameBalls(tableId)
    CleanPoolTable(PoolGames[tableId].TableCoords)
    SpawnPoolBalls(tableId)
end

function SpawnPoolBalls(tableId)
    if PoolGames[tableId] then
        -- Clean if balls already exist
        for _, ball in pairs(PoolGames[tableId].Balls) do
            ESX.Game.DeleteEntity(ball.Entity)
        end
        -- Spawn balls
        for _, ball in pairs(PoolGames[tableId].Balls) do
            ESX.Streaming.RequestModel(ball.Model)
            local ballCoords = PoolGames[tableId].TableCoords + ApplyRotationMatrix(ball.RelativeCoords, PoolGames[tableId].TableHeading)
            ball.Entity = CreateObjectNoOffset(ball.Model, ballCoords.x, ballCoords.y, ballCoords.z, false, false, false)
            ball.Velocity = vector2(0.0, 0.0)
        end
    end
end

RegisterNetEvent("cframework:receivePoolCueEntity", function(netId)
    while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
        Citizen.Wait(0)
    end

    local playerPed = PlayerPedId()

	HandCueEntity = NetworkGetEntityFromNetworkId(netId)

    AttachEntityToEntity(HandCueEntity, playerPed, GetPedBoneIndex(playerPed, 0xDEAD), 0.13, 0.1, 0.014, 290.0, 60.0, 5.0, true, true, false, true, 1, true)
end)

RegisterNetEvent("cframework:doesntHavePoolCue", function()
    ESX.ShowNotification("Precisas de um taco para jogar", "error")
end)

function CleanPoolTable(coords)
    local objects = ESX.Game.GetObjetsInArea(coords, 3.0)
    for _, entity in pairs(objects) do
        if DoesEntityExist(entity) and ArrayHasValue(ModelsToClean, GetEntityModel(entity)) and not NetworkGetEntityIsNetworked(entity) then
            ESX.Game.DeleteEntity(entity)
        end
    end
end

function StartPoolGameThread(tableId, isShooter)
    local collision = false
    local stopThread = false

    if isShooter then
        firstImpactTeam = ""
        firstImpact = true
    end

    Citizen.CreateThread(function()
        while not stopThread do
            local stepCollision = false
            stopThread, stepCollision = PoolGameStep(tableId)
            if stepCollision then
                collision = true
            end
            Citizen.Wait(0)
        end
        if isShooter then
            TriggerServerEvent('cframework:syncPoolBalls', tableId, PoolGames[tableId].Balls, collision, firstImpactTeam)
            GameThreadRunning = false
        end
    end)
end

function StartWhiteBallPlacementThread(tableId, firstStart)
    local x = 0.0
    local lineY = LineY[PoolGames[tableId].TableModel]
    local y = firstStart and lineY or 0.0
    local coords = vector3(PoolGames[tableId].TableCoords.x, PoolGames[tableId].TableCoords.y, 0.93)
    local cueBall = CreateObjectNoOffset(`prop_poolball_cue`, coords.x, coords.y, coords.z, false, false, false)
    Instructions = SetupInstructionalButtons({{key = 32,  label = "Cima"},{key = 33,  label = "Baixo"},{key = 34,  label = "Esquerda"},{key = 35,  label = "Direita"},{key = 191,  label = "Aceitar"} })
    local speed = 0.005
    local poolCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(poolCam, coords.x, coords.y, coords.z+0.30)
    SetCamActive(poolCam, true)
    SetCamRot(poolCam, 270.0, 0.0, PoolGames[tableId].TableHeading+180.0, 2)
    RenderScriptCams(true, true, 500, true, true)
    for _,ball in ipairs(PoolGames[tableId].Balls) do
        if ball.Model == `prop_poolball_cue` then
            ESX.Game.DeleteEntity(ball.Entity)
        end
    end
    local tableSize = TableSize[PoolGames[tableId].TableModel]

    local animDict = 'anim@weapons@first_person@aim_idle@generic@melee@large_wpn@pool_cue@'
    local anim = 'aim_low_loop'
    ESX.Streaming.RequestAnimDict(animDict)

    ---@diagnostic disable-next-line: missing-parameter
    TaskPlayAnim(PlayerPedId(), animDict, anim, 1.0, 1.0, -1, 1)

    InPoolAction = true
    Citizen.CreateThread(function()
        while InPoolAction do
            DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            if IsControlPressed(0, 33) and y < tableSize.YMax then -- DOWN
                y += speed
            end
            if IsControlPressed(0, 32) and y > tableSize.YMin and not (firstStart and y < lineY) then -- UP
                y -= speed
            end
            if IsControlPressed(0, 35) and x > tableSize.XMin then -- RIGHT
                x -= speed
            end
            if IsControlPressed(0, 34) and x < tableSize.XMax then -- LEFT
                x += speed
            end
            if IsControlJustPressed(0, 191) then -- Enter
                if IsCueBallNearOtherBall(vector2(x,y), PoolGames[tableId].Balls) then
                    ESX.ShowNotification('A bola não pode ser colocada aqui', 'error')
                else
                    ESX.Game.DeleteEntity(cueBall)
                    TriggerServerEvent('cframework:placeCueBall', tableId, vector3(x,y,0.93))
                    SetCamActive(poolCam, false)
                    DestroyCam(poolCam, false)
                    RenderScriptCams(false, true, 1500, true, true)
                    ClearPedTasks(PlayerPedId())
                    Instructions = SetupInstructionalButtons({ {key = 38,  label = "Jogar"}, {key = 177,  label = "Sair"}, {key = 182,  label = "Recomeçar o jogo"} })
                    InPoolAction = false
                    return
                end
            end

            local newCoords = PoolGames[tableId].TableCoords + ApplyRotationMatrix(vector3(x,y,0.93), PoolGames[tableId].TableHeading)
            SetCamCoord(poolCam, newCoords.x, newCoords.y, newCoords.z+1.0)

            ---@diagnostic disable-next-line: missing-parameter
            SetEntityCoordsNoOffset(cueBall, newCoords)
            Citizen.Wait(0)
        end
    end)
end

function IsCueBallNearOtherBall(cueBallCoords, balls)
    for _, ball in pairs(balls) do
        if ball.Model ~= `prop_poolball_cue` and #(ball.RelativeCoords.xy - cueBallCoords.xy) < 0.08 then
            return true
        end
    end
    return false
end

function StartThreadShootingWithCue(tableId)
    -- Spawn cue with at proper position
    local cueBall = PoolGames[tableId].Balls[1].Entity
    local cueBallCoords = GetEntityCoords(cueBall)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords-cueBallCoords) > 2.0 then
        ESX.ShowNotification('Estás muito longe da bola branca', 'error')
        TriggerServerEvent('cframework:stopPlayingPool', tableId)
        return
    end

    local direction = (cueBallCoords - playerCoords)
    local directionNormalized = direction/(#direction)
    ---@diagnostic disable-next-line: cast-local-type
    directionNormalized = ApplyRotationMatrix(directionNormalized, 20.0) -- Rotate a bit so that camera is to the right of the player

    local cueCoords = cueBallCoords - (0.8 * directionNormalized) - (0.5*0.4*directionNormalized)
    local startHeading = math.atan(directionNormalized.y, directionNormalized.x) * 180.0 / math.pi
    startHeading = startHeading > 0.0 and startHeading or startHeading + 360.0
    local heading = startHeading
    local rotation = vector3(0.0, 91.0, heading)
    local effect = 0.0

    -- Set camera at proper prosition
    local poolCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(poolCam, cueCoords.x+0.2*directionNormalized.x, cueCoords.y+0.2*directionNormalized.y, cueCoords.z+0.2)
    SetCamActive(poolCam, true)
    RenderScriptCams(true, true, 500, true, true)
    PointCamAtCoord(poolCam, cueBallCoords.x, cueBallCoords.y, cueBallCoords.z)
    Citizen.Wait(500)

    Instructions = SetupInstructionalButtons({{key = 240,  label = "Puxar"},{key = 32,  label = "Cima"},{key = 33,  label = "Baixo"},{key = 35,  label = "Rodar camara"},{key = 34,  label = "Rodar camara"},{key = 177,  label = "Cancelar"} })

    local cueEntity = CreateObjectNoOffset(`prop_pool_cue`, cueCoords.x, cueCoords.y, cueBallCoords.z, false, false, false)
    SetEntityRotation(cueEntity, rotation.x, rotation.y, rotation.z, 2, false)
    SetEntityCollision(cueEntity, false, false)
    FreezeEntityPosition(cueEntity, true)

    local previousPositions = {}
    local previousPositionsCount = 1
    local deltaCount = 5

    -- Animation
    local animDict = 'anim@weapons@first_person@aim_idle@generic@melee@large_wpn@pool_cue@'
    local anim = 'aim_low_loop'
    ESX.Streaming.RequestAnimDict(animDict)
    SetEntityHeading(playerPed, startHeading+230.0)

    ---@diagnostic disable-next-line: missing-parameter
    TaskPlayAnim(PlayerPedId(), animDict, anim, 1.0, 1.0, -1, 1)
    InPoolAction = true

    Citizen.CreateThread(function()
        while InPoolAction do
            DrawScaleformMovieFullscreen(Instructions, 255, 255, 255, 255, 0)
            DisableAllControlActions(0)
            EnableControlAction(0, 249, true) -- PTT
            SetEntityLocallyInvisible(playerPed)
            SetEntityLocallyInvisible(HandCueEntity)
            Citizen.Wait(0)
        end
    end)

    SetCursorLocation(0.5,0.5) -- Set mouse in the middle of the screen

    Citizen.CreateThread(function()
        while InPoolAction do
            -- Mouse control and shot
            EnableControlAction(2, 240, true)
            local mouseY = GetControlNormal(2, 240)
            cueCoords = cueBallCoords - (0.8 * directionNormalized) - (mouseY*0.4*directionNormalized)
            previousPositions[previousPositionsCount] = cueCoords

            ---@diagnostic disable-next-line: missing-parameter
            SetEntityCoordsNoOffset(cueEntity, cueCoords.x, cueCoords.y, cueBallCoords.z+effect)
            SetEntityRotation(cueEntity, rotation.x, rotation.y+(effect*30.0), rotation.z, 2, false)
            SetCamCoord(poolCam, cueCoords.x+0.2*directionNormalized.x, cueCoords.y+0.2*directionNormalized.y, cueCoords.z+0.2)
            PointCamAtCoord(poolCam, cueBallCoords.x, cueBallCoords.y, cueBallCoords.z)

            if IsDisabledControlJustPressed(0, 202) or IsDisabledControlJustPressed(0, 177) then
                ESX.Game.DeleteEntity(cueEntity)
                SetCamActive(poolCam, false)
                DestroyCam(poolCam, false)
                RenderScriptCams(false, true, 1500, true, true)
                TriggerServerEvent('cframework:stopPlayingPool', tableId)
                Instructions = SetupInstructionalButtons({ {key = 38,  label = "Jogar"}, {key = 177,  label = "Sair"}, {key = 182,  label = "Recomeçar o jogo"} })
                ClearPedTasks(playerPed)
                InPoolAction = false
                return
            end

            -- EnableControlAction(2, 239, true)
            -- local mouseX = GetControlNormal(2, 239)
            -- local newHeading = startHeading + (mouseX-0.5) * 35.0
            -- directionNormalized = vector3(math.cos(newHeading*math.pi/180.0), math.sin(newHeading*math.pi/180.0), directionNormalized.z)
            -- rotation = vector3(0.0, 91.0, newHeading)
            if IsDisabledControlPressed(0, 35) and heading < startHeading + 45.0 then -- LEFT
                heading += 0.1
                directionNormalized = vector3(math.cos(heading*math.pi/180.0), math.sin(heading*math.pi/180.0), directionNormalized.z)
                rotation = vector3(0.0, 91.0, heading)
            elseif IsDisabledControlPressed(0, 34) and heading > startHeading - 45.0 then -- RIGHT
                heading -= 0.1
                directionNormalized = vector3(math.cos(heading*math.pi/180.0), math.sin(heading*math.pi/180.0), directionNormalized.z)
                rotation = vector3(0.0, 91.0, heading)
            elseif IsDisabledControlPressed(0, 32) and effect <= 0.01 then -- UP
                effect += 0.0001
            elseif IsDisabledControlPressed(0, 33) and effect >= -0.01 then -- DOWN
                effect -= 0.0001
            end

            if mouseY <= 0.01 then
                local delta = 0.0
                -- Force is based on delta distance (speed of movement of the cue)
                if #previousPositions < deltaCount then
                    delta = math.abs(#(previousPositions[#previousPositions] - previousPositions[1]))
                else
                    delta = math.abs( #(previousPositions[previousPositionsCount] - previousPositions[(previousPositionsCount < deltaCount) and (previousPositionsCount + 1) or 1]) )
                end
                local force = 0.20 * delta

                PoolGames[tableId].Balls[1].Velocity = ApplyRotationMatrix(force * directionNormalized.xy, - PoolGames[tableId].TableHeading)
                PoolGames[tableId].Balls[1].Effect = ApplyRotationMatrix(effect * directionNormalized.xy, - PoolGames[tableId].TableHeading)

                ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                PlaySoundFromCoord(-1, 'dlc_baylife_pool_shootcue', cueBallCoords, 0, false, 15.0, false)
                TriggerServerEvent('cframework:poolShoot', tableId, PoolGames[tableId].Balls[1].Velocity, PoolGames[tableId].Balls[1].Effect)
                GameThreadRunning = true
                StartPoolGameThread(tableId, true)
                Citizen.Wait(500)
                ESX.Game.DeleteEntity(cueEntity)
                SetCamActive(poolCam, false)
                DestroyCam(poolCam, false)
                RenderScriptCams(false, true, 1500, true, true)
                Citizen.Wait(1500)
                Instructions = SetupInstructionalButtons({ {key = 38,  label = "Jogar"}, {key = 177,  label = "Sair"}, {key = 182,  label = "Recomeçar o jogo"} })
                ClearPedTasks(playerPed)
                InPoolAction = false
                return
            end

            previousPositionsCount = (previousPositionsCount < deltaCount) and (previousPositionsCount + 1) or 1

            Citizen.Wait(0)
        end
    end)
end


function PoolGameStep(tableId)
    local collision = false
    local stopThread = true
    local balls = PoolGames[tableId].Balls

    -- -- Update all ball coords
    -- for _, ball in pairs(balls) do
    --     local ballCoords = GetEntityCoords(ball.Entity)
    --     local ballOffset = ballCoords - PoolGames[tableId].TableCoords
    --     ball.RelativeCoords = ApplyRotationMatrix(ballOffset, -PoolGames[tableId].TableHeading)
    -- end

    -- Compute next step position
    for _, ball in pairs(balls) do
        if #ball.Velocity > 0.0 or ball.GoingInHole then
            stopThread = false
            local newCoords2D = vector2(ball.RelativeCoords.x, ball.RelativeCoords.y) + ball.Velocity
            ball.RelativeCoords = vector3(newCoords2D.x, newCoords2D.y, ball.RelativeCoords.z)

            -- Calculate the rotation based on the velocity direction
            --print(ball.Velocity.x, ball.Velocity.y)
            --local velocityRotation = vector3(ball.Velocity.x, ball.Velocity.y, 0)

            -- Apply the rotation to the ball's entity
            --SetEntityRotation(ball.Entity, velocityRotation.x, velocityRotation.y, velocityRotation.z, 2, true)

            ---@diagnostic disable-next-line: missing-parameter
            SetEntityCoordsNoOffset(ball.Entity, PoolGames[tableId].TableCoords + ApplyRotationMatrix(ball.RelativeCoords, PoolGames[tableId].TableHeading))
        end
    end

    local collisions = {}
    -- Collision between balls
    for id, ball in pairs(balls) do
        if not collisions[id] then
            for otherId, otherBall in pairs(balls) do
                if id ~= otherId and (#ball.Velocity > 0.0 or #otherBall.Velocity > 0.0) and ball.RelativeCoords ~= otherBall.RelativeCoords then
                    local distanceVector = (ball.RelativeCoords - otherBall.RelativeCoords).xy
                    local distanceNorm = #distanceVector
                    if distanceNorm <= 0.08 then
                        -- mark collision
                        collisions[otherId] = true
                        collision = true

                        if firstImpact and BallsTeams[otherBall.Model] ~= "white" then
                            firstImpact = false
                            firstImpactTeam = BallsTeams[otherBall.Model]
                        end

                        ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
                        PlaySoundFromCoord(-1, 'dlc_baylife_pool_collision', GetEntityCoords(ball.Entity), 0, false, 15.0, false)
                        ball.GoingTowardsHole = false

                        -- scale distance so that it's always 0.08 (2*radius)
                        distanceVector = 0.08*distanceVector/#distanceVector
                        distanceNorm = #distanceVector

                        local x1_x2 = distanceVector
                        local x2_x1 = -distanceVector

                        local v1_v2 = ball.Velocity - otherBall.Velocity
                        local v2_v1 = otherBall.Velocity - ball.Velocity

                        local newBallVelocity      = ball.Velocity      - DotProduct2D(v1_v2, x1_x2) / (distanceNorm*distanceNorm) * x1_x2
                        local newOtherBallVelocity = otherBall.Velocity - DotProduct2D(v2_v1, x2_x1) / (distanceNorm*distanceNorm) * x2_x1

                        if ball.Effect ~= nil then
                            newBallVelocity = newBallVelocity + ball.Effect
                            balls[id].Effect = nil
                        end

                        local nextBallPosition     = ball.RelativeCoords.xy + newBallVelocity
                        local newOtherBallPosition = otherBall.RelativeCoords.xy + newOtherBallVelocity

                        -- Apply new velocity only if the collision makes the balls go further from each other (to avoid spring problem)
                        if #(nextBallPosition-newOtherBallPosition) > #((ball.RelativeCoords - otherBall.RelativeCoords).xy) then
                            ball.Velocity      = newBallVelocity
                            otherBall.Velocity = newOtherBallVelocity
                        end

                        break
                    end
                end
            end
        end
    end

    -- Collisions with borders
    local ballsInHole = {}
    for ballId, ball in pairs(balls) do
        if ball.GoingTowardsHole then
            if #(ball.RelativeCoords.xy) > #(ball.HoleCoords.xy) then
                ball.GoingInHole = true
                ball.Velocity = vector2(0.0, 0.0)
                ball.RelativeCoords = vector3(ball.RelativeCoords.x, ball.RelativeCoords.y, ball.RelativeCoords.z-0.01)
            end
            if ball.RelativeCoords.z < 0.5 then
                table.insert(ballsInHole, ballId)
                if PlayingPool and DoesEntityExist(NearestTable) and GetEntityCoords(NearestTable) == PoolGames[tableId].TableCoords then
                    ESX.ShowNotification('A bola ' .. BallLabels[ball.Model] .. ' entrou', 'success')
                end
            end
        else
            for _, holeCoords in pairs(Holes[PoolGames[tableId].TableModel]) do
                if not ball.GoingTowardsHole and #ball.Velocity > 0.0 and #(ball.RelativeCoords.xy - holeCoords) < MinHoleDistance then
                    if IsPoolBallGoingTowardsHole(ball.RelativeCoords, holeCoords, ball.Velocity) then
                        ball.GoingTowardsHole = true
                        ball.HoleCoords = holeCoords
                        local holeDirection = vector2(holeCoords.x, holeCoords.y) - ball.RelativeCoords.xy
                        ball.Velocity = #ball.Velocity * (holeDirection/#holeDirection)
                    end
                end
            end
        end

        if not ball.GoingTowardsHole then
            -- X Collisions
            local xCollision = false
            local yCollision = false
            if ball.RelativeCoords.x >= TableSize[PoolGames[tableId].TableModel].XMax then
                if ball.RelativeCoords.x - ball.Velocity.x < ball.RelativeCoords.x then
                    xCollision = true
                end
            elseif ball.RelativeCoords.x <= TableSize[PoolGames[tableId].TableModel].XMin then
                if ball.RelativeCoords.x - ball.Velocity.x > ball.RelativeCoords.x then
                    xCollision = true
                end
            end
            -- Y Collisions
            if ball.RelativeCoords.y >= TableSize[PoolGames[tableId].TableModel].YMax then
                if ball.RelativeCoords.y - ball.Velocity.y < ball.RelativeCoords.y then
                    yCollision = true
                end
            elseif ball.RelativeCoords.y <= TableSize[PoolGames[tableId].TableModel].YMin then
                if ball.RelativeCoords.y - ball.Velocity.y > ball.RelativeCoords.y then
                    yCollision = true
                end
            end

            if xCollision then
                ball.Velocity = vector2(-ball.Velocity.x, ball.Velocity.y)
            end
            if yCollision then
                ball.Velocity = vector2(ball.Velocity.x, -ball.Velocity.y)
            end
        end
    end

    -- Remove balls in hole
    for _, ballId in pairs(ballsInHole) do
        table.remove(PoolGames[tableId].Balls, ballId)
    end

    -- Damping
    for _, ball in pairs(balls) do
        ball.Velocity = DampingFactor * ball.Velocity
        if #ball.Velocity <= 0.0001 then
            ball.Velocity = vector2(0.0,0.0)
        end
    end

    if stopThread then
        for _, ball in pairs(balls) do
            ball.GoingTowardsHole = false
        end
    end

    return stopThread, collision
end

function IsPoolBallGoingTowardsHole(relativeCoords, holeCoords, veloticy)
    local newCoords = relativeCoords.xy + veloticy
    if #(relativeCoords.xy - holeCoords.xy) > #(newCoords - holeCoords) then -- ball is going towards coords
        local velocityAngle = math.atan(veloticy.y, veloticy.x) * 180.0 / math.pi
        velocityAngle = velocityAngle > 0 and velocityAngle or velocityAngle + 360.0
        local holeAngle = math.atan(holeCoords.y, holeCoords.x) * 180.0 / math.pi
        holeAngle = holeAngle > 0 and holeAngle or holeAngle + 360.0
        return velocityAngle > holeAngle - AngleTolerance and velocityAngle < holeAngle + AngleTolerance
    end
    return false
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, table in pairs(PoolGames) do
            for _, ball in pairs(table.Balls) do
                ESX.Game.DeleteEntity(ball.Entity)
            end
        end
        TriggerServerEvent("cframework:destroyPoolCue")
    end
end)
