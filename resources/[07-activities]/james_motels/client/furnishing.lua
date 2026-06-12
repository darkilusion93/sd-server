Citizen.CreateThread(function()
    Citizen.Wait(500)

    local UseFurnishing = function(furnishId, furnishData)
        local allFurnishings = Config.FurnishingPurchasables[GetCategory(furnishData["name"])]

        if allFurnishings[furnishData["name"]] then
            if allFurnishings[furnishData["name"]]["func"] then
                allFurnishings[furnishData["name"]]["func"](furnishId)
            end
        end
    end

    local IsUsable = function(furnishData)
        local allFurnishings = Config.FurnishingPurchasables[GetCategory(furnishData["name"])]

        if allFurnishings[furnishData["name"]] then
            if allFurnishings[furnishData["name"]]["func"] then
                return true
            end
        end

        return false
    end

    local hasOpenedTextUI = false

    while true do
        local sleepThread = 5

        if cachedData["currentMotel"] then
            local allowed = cachedData["currentMotel"]["displayLabel"] == ESX.PlayerData["character"]["firstname"] .. " " .. ESX.PlayerData["character"]["lastname"]

            if cachedData["props"] then
                local pedCoords = GetEntityCoords(PlayerPedId())

                for furnishId, furnishData in pairs(cachedData["props"]) do
                    if IsUsable(furnishData["data"]) then
                        local dimension, _ = GetModelDimensions(GetEntityModel(furnishData["handle"]))
                        local usableSpot = GetOffsetFromEntityInWorldCoords(furnishData["handle"], 0.0, dimension["y"], 0.4)

                        local dstCheck = #(pedCoords - usableSpot)

                        if dstCheck <= 1.2 then
                            sleepThread = 0
        
                            local displayText = "[G] " .. furnishData["data"]["label"]
        
                            if not hasOpenedTextUI then
                                exports['okokTextUI']:Open(displayText, 'info', 'left')
                                hasOpenedTextUI = "furnishing_" .. furnishId
                            end

                            if IsControlJustPressed(0, 47) then
                                UseFurnishing(furnishId, furnishData["data"])
                            end

                            DrawScriptText(usableSpot, displayText)
                        end
                    end
                end
            end

            if hasOpenedTextUI and sleepThread == 5 then
                exports['okokTextUI']:Close()
                hasOpenedTextUI = false
            end

            if allowed then
                if not cachedData["furnishing"] then
                    sleepThread = 0

                    if IsControlJustPressed(0, 57) then
                        StartFurnishing()
                    end
                end
            end
        end

        Citizen.Wait(sleepThread)
    end
end)

--[[Citizen.CreateThread(function()
    Citizen.Wait(500)

    local UseAction = function(action)
        if action == "entrance" then
            ESX.Game.Teleport(PlayerPedId(), Config.MegaMall["exit"]["pos"], function()
                PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", false)
            end)
        elseif action == "exit" then
            ESX.Game.Teleport(PlayerPedId(), Config.MegaMall["entrance"]["pos"], function()
                PlaySoundFrontend(-1, "BACK", "HUD_AMMO_SHOP_SOUNDSET", false)
            end)
        elseif action == "computer" then
            OpenFurnishingComputer()
        end
    end

    local hasOpenedTextUI_Mall = false

    while true do
        local sleepThread = 5

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)

        for action, actionData in pairs(Config.MegaMall) do
            if actionData["label"] then
                local dstCheck = #(pedCoords - actionData["pos"])

                if dstCheck <= 2.0 then
                    sleepThread = 0

                    local displayText = actionData["label"]

                    if dstCheck <= 0.9 then
                        displayText = "[E] " .. displayText

                        if not hasOpenedTextUI_Mall then
                            exports['okokTextUI']:Open(displayText, 'info', 'left')
                            hasOpenedTextUI_Mall = action
                        end

                        if IsControlJustPressed(0, 38) then
                            UseAction(action)
                        end
                    end

                    DrawScriptText(actionData["pos"], displayText)
                end
            end
        end

        if hasOpenedTextUI_Mall and sleepThread == 5 then
            exports['okokTextUI']:Close()
            hasOpenedTextUI_Mall = false
        end

        Citizen.Wait(sleepThread)
    end
end)--]]