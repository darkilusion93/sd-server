

local rubberData = LoadRubber()
local createdMarkers = {}
local PlayerData = {}
local created = false
local CurrentAction = nil

local canWorkRubber = false
local collectActive = false

local vulcanizationActive = false
local vulcanizationMaterial = ""
local vulcanizationTime = 1500

local extractionLocations <const> = rubberData.extractionLocations
local cloakRoomLocation <const> = rubberData.cloakRoomLocation
local vulcanizationLocation <const> = rubberData.vulcanizationLocation
local sellLocation <const> = rubberData.sellLocation
local rubberBlips <const> = rubberData.rubberBlips

-- Enter / Exit marker events
local function createRubberMarkers()
    if PlayerData.job == nil or PlayerData.job.name ~= rubberData.jobName then
        return
    end

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("rubber_cloakroom" .. i, {type = 50, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("rubber_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "rubberEnteredMarker"}, exit = {eventClient = "rubberExitedMarker"}, data = 'cloakroom', active = {}})
        table.insert(createdMarkers, "rubber_cloakroom" .. i)
    end

    for i=1, #vulcanizationLocation, 1 do
        exports.ft_libs:AddMarker("rubber_vulcanization" .. i, {type = 50, x = vulcanizationLocation[i].x, y = vulcanizationLocation[i].y, z = vulcanizationLocation[i].z, weight = 2.5, height = 1, red = 255, green = 123, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("rubber_vulcanization" .. i, {x = vulcanizationLocation[i].x, y = vulcanizationLocation[i].y, z = vulcanizationLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "rubberEnteredMarker"}, exit = {eventClient = "rubberExitedMarker"}, data = 'vulcanization', active = {}})
        table.insert(createdMarkers, "rubber_vulcanization" .. i)
    end

    for i=1, #sellLocation, 1 do
        exports.ft_libs:AddMarker("rubber_selling" .. i, {type = 50, x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, weight = 2.5, height = 1, red = 105, green = 255, blue = 105, showDistance = 25})
        exports.ft_libs:AddTrigger("rubber_selling" .. i, {x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "rubberEnteredMarker"}, exit = {eventClient = "rubberExitedMarker"}, data = 'selling', active = {}})
        table.insert(createdMarkers, "rubber_selling" .. i)
    end

    for i=1, #extractionLocations, 1 do
        exports.ft_libs:AddMarker("rubber_extraction" .. i, {type = 50, x = extractionLocations[i].x, y = extractionLocations[i].y, z = extractionLocations[i].z, weight = 1, height = 1, red = 255, green = 123, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("rubber_extraction" .. i, {x = extractionLocations[i].x, y = extractionLocations[i].y, z = extractionLocations[i].z, weight = 2, height = 2,
        enter = {eventClient = "rubberEnteredMarker"}, exit = {eventClient = "rubberExitedMarker"}, data = 'extracting', active = {}})
        table.insert(createdMarkers, "rubber_extraction" .. i)
    end

    for _, info in pairs(rubberBlips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(info.title)
        EndTextCommandSetBlipName(info.blip)
    end

    created = true
end

local function removeRubberMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end
    createdMarkers = {}

    if not created then
        return
    end

    for i, blip in pairs(rubberBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end

local function startVulcanization()
    Citizen.CreateThread(function()

        if vulcanizationActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        TriggerServerEvent("cframework:startVulcanization", vulcanizationMaterial)

        while vulcanizationActive do
            Citizen.Wait(vulcanizationTime)
        end

        TriggerServerEvent("cframework:stopVulcanization", vulcanizationMaterial)
    end)

    Citizen.CreateThread(function()
        while vulcanizationActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification(T("RUBBERJOB_PRESS_TO_CANCEL_REFINING"))

            if IsControlJustReleased(1, 51) then
                TriggerEvent('cframework:rubberFail')
            end
        end
    end)
end


local function vulcanizationMenu()
    local elements = {}

    for item, recipe in pairs(rubberData.vulcanization) do
        table.insert(elements, {
            label = ESX.GetItemLabel(recipe.output.item),
            value = item
        })
    end

    TriggerEvent('chud:itemselector', elements, T("RUBBERJOB_VULCANIZATION"), T("RUBBERJOB_VULCANIZE"), function(material)
        local recipe = rubberData.vulcanization[material]
        if not recipe then return end

        vulcanizationMaterial = material
        vulcanizationTime = recipe.time
        vulcanizationActive = true

        TriggerEvent('esx_inventoryhud:doClose')
        startVulcanization()
    end)
end


local function rubberCloakroom()
    local elements = {
        {label = ("🧥 %s"):format(T("GENERIC_CLOTHING_CITIZEN")),     value = 'cloakroom1'},
        {label = ("👔 %s"):format(T("GENERIC_CLOTHING_JOB")),         value = 'cloakroom2'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, T("RUBBERJOB_NAME"), function(value)
        if value == 'cloakroom1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent('cframework:exitRubberService')
            canWorkRubber = false
        end

        if value == 'cloakroom2' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
            TriggerServerEvent('cframework:enterRubberService')
            canWorkRubber = true
        end
    end)
end


local function rubberSelling()
    local elements = {}

    for item, data in pairs(rubberData.selling) do
        table.insert(elements, {
            label = ('%s (%s€)'):format(ESX.GetItemLabel(data.item), data.price),
            value = item
        })
    end

    TriggerEvent('chud:itemselector', elements, T("RUBBERJOB_SALE_MENU_TITLE"), T("GENERIC_SELL"), function(value)
        TriggerServerEvent("cframework:rubberSelling", value)
    end)
end


local function startExtractingRubber()
    collectActive = true

    Citizen.CreateThread(function()
        local tool = 'treetap'--RPC.execute('getMiningTool')

        if tool == 'none' then 
            collectActive = false
            ESX.ShowNotification(T("RUBBERJOB_NO_TOOLS_TO_WORK"), 'error')
            return
        end

        FreezeEntityPosition(PlayerPedId(), true)

        if tool == 'treetap' then
            RequestAnimDict("creatures@rottweiler@tricks@")
            Citizen.Wait(100)

            TaskPlayAnim(PlayerPedId(), 'creatures@rottweiler@tricks@', 'petting_franklin', 8.0, 8.0, -1, 1, 0, true, true, true)


            TriggerServerEvent("cframework:startExtraction")

            while collectActive do
                Citizen.Wait(2500)

            end

            TriggerServerEvent("cframework:stopExtraction")
        end

    end)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while collectActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification(T("RUBBERJOB_PRESS_TO_CANCEL_COLLECTING"))

            if IsControlJustReleased(1, 51) then
                local playerPed = PlayerPedId()
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                collectActive = false
            end
        end
    end)
end

RegisterNetEvent("cframework:rubberFail", function()
    local ped = PlayerPedId()
    vulcanizationActive = false
    collectActive = false
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    removeRubberMarkers()
    createRubberMarkers()
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeRubberMarkers()
    createRubberMarkers()
end)

RegisterNetEvent('rubberEnteredMarker', function(action)
    CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                goto final
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'cloakroom' then
                CurrentAction = nil
                rubberCloakroom()
            end

            if CurrentAction == 'vulcanization' and canWorkRubber then
                CurrentAction = nil
                if not vulcanizationActive then
                    vulcanizationMenu()
                end
            end

            if CurrentAction == 'selling' then
                CurrentAction = nil
                rubberSelling()
            end

            if CurrentAction == 'extracting' and canWorkRubber then
                CurrentAction = nil
                if not collectActive then
                    startExtractingRubber()
                end
            end

            ::final::

            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent('rubberExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

local function ceninhassparatebanir2()
    local item = 'rubber'
    TriggerServerEvent("gborracheiro:giveLatex")
    TriggerServerEvent("gborracheiro:giveBorracha")
    TriggerServerEvent("esx_borracheiro:giveitem", item)
end