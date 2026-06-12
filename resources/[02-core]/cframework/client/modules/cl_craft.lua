


local isCrafting = false
local canceledCraft = false
local canceledCraftRepeat = false
local currentCraftingLocation = nil
local currentCraftItem = nil

local function showCurrentCraftButtons()
    Citizen.CreateThread(function()
        local scaleform <const> = RequestScaleformMovie_2("INSTRUCTIONAL_BUTTONS")

        repeat Wait(0) until HasScaleformMovieLoaded(scaleform)

        BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(0)
        ScaleformMovieMethodAddParamInt(55)
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(1)
        ScaleformMovieMethodAddParamPlayerNameString(GetControlInstructionalButton(1, 73, false))
        ScaleformMovieMethodAddParamPlayerNameString(T("GENERIC_CANCEL"))
        EndScaleformMovieMethod()

        BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        EndScaleformMovieMethod()

        while isCrafting do
            Citizen.Wait(0)

            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            if IsControlJustPressed(0, 73) then
                ESX.ShowNotification(T("CRAFTS_CANCELED_CRAFT"), "inform")

                ClearPedTasks(PlayerPedId())

                ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
                ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 5.0, 0)
                FreezeEntityPosition(PlayerPedId(),false)
                canceledCraft = true
            end
        end
    end)
end

local function updateSimpleCraftInfo()
    if currentCraftingLocation == nil then
        return
    end

    if ESX.craftItems[currentCraftingLocation].enableInfluence then
        local influence <const> = ESX.requestInfluence(currentCraftingLocation)

        if influence.identifier == nil then
            ESX.craftItems[currentCraftingLocation].influencerLabel = "Nenhum"
            ESX.craftItems[currentCraftingLocation].influencerLevel = 0
        else
            ESX.craftItems[currentCraftingLocation].influencerLabel = influence.label
            ESX.craftItems[currentCraftingLocation].influencerLevel = influence.level

            if influence.level >= 1000 and influence.identifier == ESX.PlayerData.job.name then
                ESX.craftItems[currentCraftingLocation].isInfluencer = true
            else
                ESX.craftItems[currentCraftingLocation].isInfluencer = false
            end
        end
    end

    for k, v in pairs(ESX.craftItems[currentCraftingLocation].items) do
        local craftableItem <const> = ESX.craftItems[currentCraftingLocation].items[k]

        if craftableItem.needXp then
            ESX.craftItems[currentCraftingLocation].items[k].currentLevel = ESX.GetCurrentExperienceLevel(craftableItem.typer)
        elseif craftableItem.needOrgXp then
            ESX.craftItems[currentCraftingLocation].items[k].currentLevel = ESX.GetCurrentLevelFromExperience(ESX.GetJobMetadataKey(craftableItem.typer) or 0)
        end
    end

    TriggerEvent("cframework:updateCraftingInfo", ESX.craftItems[currentCraftingLocation], currentCraftingLocation)
end

RegisterNetEvent("cframework:startCraft", function(partNum, index, count)
    local item <const> = ESX.craftItems[partNum].items[index]

    if isCrafting then
        return
    end

    isCrafting = true
    canceledCraft = false
    canceledCraftRepeat = false
    currentCraftItem = item.name

    updateSimpleCraftInfo()

    while not canceledCraftRepeat and not canceledCraft do
        local canCraft <const> = RPC.execute("cframework:canCraft", partNum, index)

        if not canCraft then
            isCrafting = false
            updateSimpleCraftInfo()
            return
        end

        FreezeEntityPosition(PlayerPedId(),true)

        PlayCraftAnim(item)

        showCurrentCraftButtons()

        if ESX.craftItems[partNum].isInfluencer and item.influenceTime then
            Citizen.Wait(item.influenceTime)
        else
            Citizen.Wait(item.time)
        end

        if not canceledCraft then
            TriggerServerEvent("cframework:craft")
            ClearPedTasks(PlayerPedId())

            ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
            ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 5.0, 0)
            FreezeEntityPosition(PlayerPedId(),false)
        end
    end

    isCrafting = false
    currentCraftItem = nil
end)

RegisterNetEvent("cframework:startMobileCraft", function(index)
    local item <const> = ESX.mobileCrafts[index]

    if isCrafting then
        return
    end

    isCrafting = true
    canceledCraft = false
    canceledCraftRepeat = false
    currentCraftItem = item.name

    TriggerEvent("cframework:updateMobileCraftUi")

    while not canceledCraftRepeat and not canceledCraft do
        local canCraft <const> = RPC.execute("cframework:canCraftMobile", index)

        if not canCraft then
            isCrafting = false
            TriggerEvent("cframework:updateMobileCraftUi")
            return
        end

        FreezeEntityPosition(PlayerPedId(),true)

        PlayCraftAnim(item)

        showCurrentCraftButtons()

        Citizen.Wait(item.time)

        if not canceledCraft then
            TriggerServerEvent("cframework:craftMobile")
            ClearPedTasks(PlayerPedId())

            ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
            ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 5.0, 0)
            FreezeEntityPosition(PlayerPedId(),false)
        end
    end

    isCrafting = false
    currentCraftItem = nil

    TriggerEvent("cframework:updateMobileCraftUi")
end)


RegisterNetEvent("cframework:forceCancelCraft", function()
    canceledCraftRepeat = true

    updateSimpleCraftInfo()
end)

ESX.isCraftingAndNotCanceled = function()
    return isCrafting and not canceledCraftRepeat
end

ESX.getCurrentCraftItem = function()
    return currentCraftItem
end

ESX.getAvailableMobileCrafts = function()
    return ESX.mobileCrafts
end


local function getCraftItemLabel(item)
    return ESX.GetItemLabel(item)
end

local function isAuthorizedToCraft(index, station)
	if not ESX or not ESX.PlayerData.job then
		return false
	end

    for _,job in pairs(station.jobs) do
        if job == "none" or job == ESX.PlayerData.job.name then
            return true
		end

        if string.find(job, "tag:") then
            return RPC.execute("cframework:isAuthorizedToCraft", index)
        end
	end

	return false
end

Citizen.CreateThread(function()
    for i, v in pairs(ESX.craftItems) do
        for i2, v2 in pairs(ESX.craftItems[i].items) do
            local craftableItem <const> = ESX.craftItems[i].items[i2]

            ESX.craftItems[i].items[i2].label = getCraftItemLabel(craftableItem.name)

            for i3=1, #craftableItem.needs, 1 do
                ESX.craftItems[i].items[i2].needs[i3].label = getCraftItemLabel(craftableItem.needs[i3].name)
            end
        end
    end

    for i, v in pairs(ESX.mobileCrafts) do
        local craftableItem <const> = ESX.mobileCrafts[i]

        ESX.mobileCrafts[i].label = getCraftItemLabel(craftableItem.name)

        for i3=1, #craftableItem.needs, 1 do
            ESX.mobileCrafts[i].needs[i3].label = getCraftItemLabel(craftableItem.needs[i3].name)
        end
    end

    for i, v in pairs(ESX.craftItems) do
        for j, x in pairs(ESX.craftItems[i].pos) do
            exports.ft_libs:AddTrigger("cframework:craft_" .. i .. "_" .. j, {x = ESX.craftItems[i].pos[j].x, y = ESX.craftItems[i].pos[j].y, z = ESX.craftItems[i].pos[j].z, weight = 2, height = 2,
            enter = {eventClient = "cframework:enteredCraftMarker"}, exit = { eventClient = "cframework:exitedCraftMarker"}, data = i})
        end
    end
end)


AddEventHandler("cframework:enteredCraftMarker", function(data)
    currentCraftingLocation = data

    while currentCraftingLocation ~= nil do
        if ESX.isHandcuffed() or ESX.isPlayerDead() or IsPedInAnyVehicle(PlayerPedId(), false) then
            currentCraftingLocation = nil
            return
        end

        ESX.ShowHelpNotification("Pressione ~INPUT_CONTEXT~ para abrir o menu")

        if IsControlJustReleased(0,  VK_KEY_E) then
            if ESX.isPlayerDead() then ESX.ShowNotification("Estás morto, não podes usar este menu.", "error")
                return
            end

            if isAuthorizedToCraft(currentCraftingLocation, ESX.craftItems[currentCraftingLocation]) then
                if ESX.craftItems[currentCraftingLocation].enableInfluence then
                    local influence <const> = ESX.requestInfluence(currentCraftingLocation)

                    if influence.identifier == nil then
                        ESX.craftItems[currentCraftingLocation].influencerLabel = "Nenhum"
                        ESX.craftItems[currentCraftingLocation].influencerLevel = 0
                    else
                        ESX.craftItems[currentCraftingLocation].influencerLabel = influence.label
                        ESX.craftItems[currentCraftingLocation].influencerLevel = influence.level

                        if influence.level >= 1000 and influence.identifier == ESX.PlayerData.job.name then
                            ESX.craftItems[currentCraftingLocation].isInfluencer = true
                        else
                            ESX.craftItems[currentCraftingLocation].isInfluencer = false
                        end
                    end
                end

                for k, v in pairs(ESX.craftItems[currentCraftingLocation].items) do
                    local craftableItem <const> = ESX.craftItems[currentCraftingLocation].items[k]

                    if craftableItem.needXp then
                        ESX.craftItems[currentCraftingLocation].items[k].currentLevel = ESX.GetCurrentExperienceLevel(craftableItem.typer)
                    elseif craftableItem.needOrgXp then
                        ESX.craftItems[currentCraftingLocation].items[k].currentLevel = ESX.GetCurrentLevelFromExperience(ESX.GetJobMetadataKey(craftableItem.typer) or 0)
                    end
                end

                TriggerEvent("esx_inventoryhud:openCraft", ESX.craftItems[currentCraftingLocation], currentCraftingLocation)
            end
        end

        Citizen.Wait(0)
    end
end)

AddEventHandler("cframework:exitedCraftMarker", function()
    currentCraftingLocation = nil
end)

RegisterNetEvent("cframework:updateCraftingInfoSimple", function(influence, partNum)
    if ESX.craftItems[partNum].enableInfluence then
        if influence.identifier == nil then
            ESX.craftItems[partNum].influencerLabel = "Nenhum"
            ESX.craftItems[partNum].influencerLevel = 0
        else
            ESX.craftItems[partNum].influencerLabel = influence.label
            ESX.craftItems[partNum].influencerLevel = influence.level

            if influence.level >= 1000 and influence.identifier == ESX.PlayerData.job.name then
                ESX.craftItems[partNum].isInfluencer = true
            else
                ESX.craftItems[partNum].isInfluencer = false
            end
        end
    end

    for k, v in pairs(ESX.craftItems[partNum].items) do
        local craftableItem <const> = ESX.craftItems[partNum].items[k]

        if craftableItem.needXp then
            ESX.craftItems[partNum].items[k].currentLevel = ESX.GetCurrentExperienceLevel(craftableItem.typer)
        elseif craftableItem.needOrgXp then
            ESX.craftItems[partNum].items[k].currentLevel = ESX.GetCurrentLevelFromExperience(ESX.GetJobMetadataKey(craftableItem.typer) or 0)
        end
    end

    TriggerEvent("cframework:updateCraftingInfo", ESX.craftItems[partNum], partNum)
end)