local function setLeaderboardFocus(focus)
    local availableActions = GetMobileAvailableMobilActions()
    availableActions["fishingLeaderboard"] = focus == "fishing"
    availableActions["huntingLeaderboard"] = focus == "hunting"

    TriggerEvent("cframework:setAvailableActions", availableActions)

    if focus ~= "none" then
        TriggerServerEvent("chud:requestActivityLeaderboard", focus)
        SendNUIMessage({
            action = "setType",
            type = "normal"
        })
    end

    SendNUIMessage({
        action = "setActivityLeaderboardFocus",
        focus = focus
    })
end

RegisterNetEvent("chud:resetActivityLeaderboardFocus", function()
    setLeaderboardFocus("none")
end)

RegisterNetEvent("chud:updateActivityLeaderboard", function(leaderboard)
    if leaderboard == nil then
        return
    end

    SendNUIMessage({
        action = "setActivityLeaderboard",
        leaderboard = leaderboard
    })
end)

RegisterNetEvent("cframework:chooseActionOption", function(id)
    if id == "fishingLeaderboard" then
        setLeaderboardFocus("fishing")
        return
    end

    if id == "huntingLeaderboard" then
        setLeaderboardFocus("hunting")
        return
    end
end)
