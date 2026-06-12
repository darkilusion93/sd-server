local votingPeds = {}

local function getVotingCoords(data)
    if type(data) == "vector4" then
        return vector3(data.x, data.y, data.z), data.w
    end

    if type(data) == "vector3" then
        return data, 0.0
    end

    return vector3(data.x, data.y, data.z), data.heading or data.h or data.w or 0.0
end

local function openVotingInventory()
    if ESX.isPlayerDead() or IsPlayerInInventory() then
        return
    end

    loadPlayerInventory()
    isInInventory = true
    ESX.UI.Menu.CloseAll()

    SendNUIMessage({
        action = "setType",
        type = "voting"
    })

    SendNUIMessage({
        action = "setInfoText",
        text = Config.Voting.InfoText or ("<strong>" .. _U("voting_booth") .. "</strong><br>" .. _U("voting_info"))
    })

    SendNUIMessage({
        action = "setVotingData",
        voting = RPC.execute("chud:getVotingData")
    })

    SendNUIMessage({
        action = "display",
        type = "voting"
    })

    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent("inventoryOpened")
end

local function spawnVotingPed(coordsData)
    local coords, heading = getVotingCoords(coordsData)
    local model = joaat(Config.Voting.PedModel or "a_m_m_business_01")

    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, heading, false, true)

    SetEntityHeading(ped, heading)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    if Config.Voting.Scenario ~= nil and Config.Voting.Scenario ~= "" then
        TaskStartScenarioInPlace(ped, Config.Voting.Scenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)
    votingPeds[#votingPeds + 1] = ped
end

CreateThread(function()
    if Config.Voting == nil or not Config.Voting.Enabled then
        return
    end

    while ESX == nil do
        Wait(100)
    end

    for _, coordsData in ipairs(Config.Voting.Npcs or {}) do
        spawnVotingPed(coordsData)
    end

    while true do
        local waitTime = 750
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, coordsData in ipairs(Config.Voting.Npcs or {}) do
            local coords = getVotingCoords(coordsData)
            local distance = #(playerCoords - coords)

            if distance <= (Config.Voting.InteractionDistance or 2.0) then
                waitTime = 0

                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(_U("voting_press_to_vote"))
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, 38) then
                    openVotingInventory()
                    Wait(500)
                end

                break
            end
        end

        Wait(waitTime)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, ped in ipairs(votingPeds) do
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end)

RegisterNUICallback("VoteParty", function(data, cb)
    if data ~= nil then
        local partyName = data.party

        if partyName == nil and data.item ~= nil then
            partyName = data.item.name
        end

        if partyName ~= nil then
            TriggerServerEvent("chud:submitVote", partyName)
        end
    end

    cb("ok")
end)

RegisterNetEvent("chud:votingSubmitted", function(votingData)
    if votingData ~= nil then
        SendNUIMessage({
            action = "setVotingData",
            voting = votingData
        })
    end
end)
