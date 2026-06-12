local poolGames = {}
local syncedSources = {}

local BallsModel = {
    { Model = `prop_poolball_1`,  Team = 'solid',  },
    { Model = `prop_poolball_2`,  Team = 'solid',  },
    { Model = `prop_poolball_3`,  Team = 'solid',  },
    { Model = `prop_poolball_8`,  Team = 'black',  },
    { Model = `prop_poolball_4`,  Team = 'solid',  },
    { Model = `prop_poolball_5`,  Team = 'solid',  },
    { Model = `prop_poolball_6`,  Team = 'solid',  },
    { Model = `prop_poolball_7`,  Team = 'solid',  },

    { Model = `prop_poolball_9`,  Team = 'stripe', },
    { Model = `prop_poolball_10`, Team = 'stripe', },
    { Model = `prop_poolball_11`, Team = 'stripe', },
    { Model = `prop_poolball_12`, Team = 'stripe', },
    { Model = `prop_poolball_13`, Team = 'stripe', },
    { Model = `prop_poolball_14`, Team = 'stripe', },
    { Model = `prop_poolball_15`, Team = 'stripe', },
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

local BallsLocation = {
    [`prop_pooltable_02`] = {
        { RelativeCoords = vector3(  0.0-0.07,   0.83, 0.93), Model = `prop_poolball_cue`},

        { RelativeCoords = vector3(  0.0-0.07, -0.70+0.2, 0.93) },

        { RelativeCoords = vector3( 0.04-0.07, -0.78+0.2, 0.93) },
        { RelativeCoords = vector3(-0.04-0.07, -0.78+0.2, 0.93) },

        { RelativeCoords = vector3( 0.00-0.07, -0.86+0.2, 0.93) },
        { RelativeCoords = vector3( 0.08-0.07, -0.86+0.2, 0.93) },
        { RelativeCoords = vector3(-0.08-0.07, -0.86+0.2, 0.93) },

        { RelativeCoords = vector3( 0.04-0.07, -0.94+0.2, 0.93) },
        { RelativeCoords = vector3(-0.04-0.07, -0.94+0.2, 0.93) },
        { RelativeCoords = vector3( 0.12-0.07, -0.94+0.2, 0.93) },
        { RelativeCoords = vector3(-0.12-0.07, -0.94+0.2, 0.93) },

        { RelativeCoords = vector3( 0.00-0.07, -1.02+0.2, 0.93) },
        { RelativeCoords = vector3( 0.08-0.07, -1.02+0.2, 0.93) },
        { RelativeCoords = vector3(-0.08-0.07, -1.02+0.2, 0.93) },
        { RelativeCoords = vector3( 0.16-0.07, -1.02+0.2, 0.93) },
        { RelativeCoords = vector3(-0.16-0.07, -1.02+0.2, 0.93) },
    },
    [`prop_pooltable_3b`] = {
        { RelativeCoords = vector3(  0.0, 0.7, 0.93), Model = `prop_poolball_cue`},

        { RelativeCoords = vector3(  0.0, -0.70, 0.93) },

        { RelativeCoords = vector3( 0.04, -0.78, 0.93) },
        { RelativeCoords = vector3(-0.04, -0.78, 0.93) },

        { RelativeCoords = vector3( 0.00, -0.86, 0.93) },
        { RelativeCoords = vector3( 0.08, -0.86, 0.93) },
        { RelativeCoords = vector3(-0.08, -0.86, 0.93) },

        { RelativeCoords = vector3( 0.04, -0.94, 0.93) },
        { RelativeCoords = vector3(-0.04, -0.94, 0.93) },
        { RelativeCoords = vector3( 0.12, -0.94, 0.93) },
        { RelativeCoords = vector3(-0.12, -0.94, 0.93) },

        { RelativeCoords = vector3( 0.00, -1.02, 0.93) },
        { RelativeCoords = vector3( 0.08, -1.02, 0.93) },
        { RelativeCoords = vector3(-0.08, -1.02, 0.93) },
        { RelativeCoords = vector3( 0.16, -1.02, 0.93) },
        { RelativeCoords = vector3(-0.16, -1.02, 0.93) },
    }
}

RegisterNetEvent('cframework:syncPoolGames', function()
    local source = source

    if syncedSources[source] ~= nil then return end

    syncedSources[source] = true

    TriggerClientEvent('cframework:syncPoolGames', source, poolGames)
end)

RegisterNetEvent('cframework:cancelPoolGame', function(tableId)
    local source = source
    local hasPerm = false

    if poolGames[tableId] == nil then return end

    for currentTeam, team in pairs(poolGames[tableId].Players) do
        for _, player in ipairs(team) do
            if player == source and currentTeam == poolGames[tableId].PlayingTeam then
                hasPerm = true
            end
        end
    end

    if not hasPerm then return end

    for _, player in ipairs(ESX.GetPlayersInArea(poolGames[tableId].TableCoords, 50.0)) do
        TriggerClientEvent('cframework:endPoolGame', player, tableId)
    end

    poolGames[tableId] = nil
end)

RegisterNetEvent('cframework:startPoolGame', function(tableId, tableCoords, tableHeading, tableModel, CurrentTeam, instanceId)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)

    if poolGames[tableId] ~= nil then
        TriggerClientEvent('cframework:startPoolGame', source, tableId, poolGames[tableId])
        return
    end

    if inventory.getItemAmount("WEAPON_POOLCUE") > 0 then
        TriggerEvent("cframework:createPoolCue", source)
    else
        TriggerClientEvent("cframework:doesntHavePoolCue", source)
        return
    end

    local playersPlaying = { solid = {}, stripe = {} }
    playersPlaying[CurrentTeam] = {source}

    -- shuffle the BallsModel table randomly except for the fifth element
    math.randomseed(os.time())
    for i = 1, #BallsModel do
        if i ~= 4 then
            local j = math.random(#BallsModel)
            if j ~= 4 then
                BallsModel[i], BallsModel[j] = BallsModel[j], BallsModel[i]
            end
        end
    end

    local balls = BallsLocation[tableModel]

    for i=1, #balls, 1 do
        if balls[i].Model == nil then
            balls[i].Model = BallsModel[i-1].Model
        end
    end

    poolGames[tableId] = {
        PlaceCueBall = false,
        Players = playersPlaying,
        TableHeading = tableHeading,
        PlayingTeam = CurrentTeam,
        PlaceCueBallStart = true,
        FirstSync = true,
        CanPlay = true,
        Balls = balls,
        TableModel = tableModel,
        InstanceId = instanceId,
        TableCoords = tableCoords
    }

    for _, player in ipairs(ESX.GetPlayersInArea(poolGames[tableId].TableCoords, 50.0)) do
        TriggerClientEvent('cframework:startPoolGame', player, tableId, poolGames[tableId])
    end
end)

RegisterNetEvent('cframework:joinPoolGame', function(tableId, CurrentTeam)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)

    if poolGames[tableId] == nil then return end

    if inventory.getItemAmount("WEAPON_POOLCUE") > 0 then
        TriggerEvent("cframework:createPoolCue", source)
    else
        TriggerClientEvent("cframework:doesntHavePoolCue", source)
        return
    end

    table.insert(poolGames[tableId].Players[CurrentTeam], source)

    TriggerClientEvent('cframework:syncPoolBalls', source, tableId, poolGames[tableId].Balls)
end)

RegisterNetEvent('cframework:leavePoolGame', function()
    local source = source

    for tableId, game in pairs(poolGames) do
        for currentTeam, team in pairs(game.Players) do
            for pIndex, player in ipairs(team) do
                if player == source then
                    table.remove(poolGames[tableId].Players[currentTeam], pIndex)
                end
            end
        end
    end
end)

RegisterNetEvent('cframework:syncPoolBalls', function(tableId, balls, collision, firstImpactTeam)
    local source = source
    local cueBallFound, blackBallFound, hasPerm, firstHitValid = true, true, false, true

    if poolGames[tableId] == nil then return end

    for currentTeam, team in pairs(poolGames[tableId].Players) do
        for _, player in ipairs(team) do
            if player == source and currentTeam == poolGames[tableId].PlayingTeam then
                hasPerm = true
            end
        end
    end

    if not hasPerm then return end

    local ballsInHoles, ballEnterCount, playingTeamBalls = {}, 0, 0

    for _, ball in pairs(poolGames[tableId].Balls) do
        ballsInHoles[ball.Model] = BallsTeams[ball.Model]
        ballEnterCount = ballEnterCount + 1

        if BallsTeams[ball.Model] == poolGames[tableId].PlayingTeam then
            playingTeamBalls = playingTeamBalls + 1
        end
    end

    for _, ball in pairs(balls) do
        ballsInHoles[ball.Model] = nil
        ballEnterCount = ballEnterCount - 1
    end

    --print(collision, firstImpactTeam, poolGames[tableId].PlayingTeam, playingTeamBalls)
    if not poolGames[tableId].FirstSync and collision and (firstImpactTeam ~= poolGames[tableId].PlayingTeam and playingTeamBalls ~= 0) then
        firstHitValid = false
        --print("hit não foi valido")
    end

    if poolGames[tableId].FirstSync then
        poolGames[tableId].FirstSync = false
    end

    poolGames[tableId].Balls = balls

    if ballEnterCount == 0 or ballsInHoles[`prop_poolball_cue`] ~= nil or not firstHitValid then
        --print("troca de equipa porque não entrou bola ou entrou a branca")
        if poolGames[tableId].PlayingTeam == "solid" then
            poolGames[tableId].PlayingTeam = "stripe"
        else
            poolGames[tableId].PlayingTeam = "solid"
        end
    else
        local changeTeam = true

        for _, team in pairs(ballsInHoles) do
            if poolGames[tableId].PlayingTeam == team then
                changeTeam = false
            end
        end

        --print(changeTeam, json.encode(ballsInHoles))

        if changeTeam then
            --print("troca de equipa porque so entraram bolas da equipa contraria")

            if poolGames[tableId].PlayingTeam == "solid" then
                poolGames[tableId].PlayingTeam = "stripe"
            else
                poolGames[tableId].PlayingTeam = "solid"
            end
        end
    end

    --print("playing team", poolGames[tableId].PlayingTeam)

    if ballsInHoles[`prop_poolball_cue`] then
        cueBallFound = false
    end

    if ballsInHoles[`prop_poolball_8`] then
        blackBallFound = false
    end

    if not collision or not cueBallFound or not firstHitValid then
        --print("force place white ball")
        poolGames[tableId].PlaceCueBall = true
    end

    if not blackBallFound then
        local newGameBalls = BallsLocation[poolGames[tableId].TableModel]

        -- shuffle the BallsModel table randomly except for the fifth element
        math.randomseed(os.time())
        for i = 1, #BallsModel do
            if i ~= 4 then
                local j = math.random(#BallsModel)
                if j ~= 4 then
                    BallsModel[i], BallsModel[j] = BallsModel[j], BallsModel[i]
                end
            end
        end

        for i=1, #newGameBalls, 1 do
            if newGameBalls[i].Model == nil then
                newGameBalls[i].Model = BallsModel[i-1].Model
            end
        end

        poolGames[tableId].PlaceCueBall = false
        poolGames[tableId].PlaceCueBallStart = true
        poolGames[tableId].FirstSync = true
        poolGames[tableId].CanPlay = true
        poolGames[tableId].Balls = newGameBalls

        balls = newGameBalls
    end

    for _, player in ipairs(ESX.GetPlayersInArea(poolGames[tableId].TableCoords, 50.0)) do
        TriggerClientEvent('cframework:syncPoolBalls', player, tableId, balls)
    end

    poolGames[tableId].CanPlay = true
end)

RegisterNetEvent('cframework:placeCueBall', function(tableId, coords)
    local source = source
    local cueBallFound, hasPerm = false, false

    if poolGames[tableId] == nil then return end

    for _, team in pairs(poolGames[tableId].Players) do
        for _, player in ipairs(team) do
            if player == source then
                hasPerm = true
            end
        end
    end

    if not hasPerm then return end

    poolGames[tableId].PlaceCueBall = false
    poolGames[tableId].PlaceCueBallStart = false

    for k, ball in pairs(poolGames[tableId].Balls) do
        if ball.Model == `prop_poolball_cue` then
            poolGames[tableId].Balls[k].RelativeCoords = coords
            cueBallFound = true
        end
    end

    if not cueBallFound then
        table.insert(poolGames[tableId].Balls, 1, { RelativeCoords = coords, Model = `prop_poolball_cue` })
    end

    for _, player in ipairs(ESX.GetPlayersInArea(poolGames[tableId].TableCoords, 50.0)) do
        TriggerClientEvent('cframework:syncPoolBalls', player, tableId, poolGames[tableId].Balls)
    end

    poolGames[tableId].CanPlay = true
end)

RegisterNetEvent('cframework:stopPlayingPool', function(tableId)
    local hasPerm = false

    if poolGames[tableId] == nil then return end

    for _, team in pairs(poolGames[tableId].Players) do
        for _, player in ipairs(team) do
            if player == source then
                hasPerm = true
            end
        end
    end

    if not hasPerm then return end

    poolGames[tableId].CanPlay = true
end)

RegisterNetEvent('cframework:poolShoot', function(tableId, velocity, effect)
    local source = source

    for _, player in ipairs(ESX.GetPlayersInArea(poolGames[tableId].TableCoords, 50.0)) do
        TriggerClientEvent('cframework:shootPool', player, source, tableId, velocity, effect)
    end
end)

RPC.register("cframework:canPlayPool", function(tableId)
    local source = source
    local inventory <const> = ESX.getInvContainer(source)
    local canPlay = false

    for currentTeam, team in pairs(poolGames[tableId].Players) do
        for _, player in ipairs(team) do
            if player == source and currentTeam == poolGames[tableId].PlayingTeam then
                canPlay = true
            end
        end
    end

    if inventory.getItemAmount("WEAPON_POOLCUE") <= 0 then
        canPlay = false
        TriggerClientEvent("cframework:doesntHavePoolCue", source)
    end

    if not poolGames[tableId].CanPlay then
        canPlay = false
    end

    if canPlay then
        poolGames[tableId].CanPlay = false
    end

    return canPlay, poolGames[tableId].PlaceCueBall, poolGames[tableId].PlaceCueBallStart
end)
