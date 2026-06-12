

local createdMarkers = {}
local PlayerData = {}
local created = false
local CurrentAction = nil

local canWorkCostureiro = false

local collectActive = false

local processActive = false
local processTime = 3000
local processMaterial = 'fabric'

local cloakRoomLocation <const> = {
    { x = 707.12, y = -966.53, z = 30.41 },
    { x = 405.59, y = 6526.21, z = 27.70 },
}

local cottonLocation <const> = {
    { x = 364.67, y = 6462.29, z = 30.24 },
    { x = 364.87, y = 6464.12, z = 30.20 },
    { x = 364.85, y = 6466.77, z = 30.14 },
    { x = 365.10, y = 6469.88, z = 30.00 },
    { x = 364.91, y = 6475.91, z = 29.63 },
    { x = 365.05, y = 6478.03, z = 29.52 },
    { x = 364.87, y = 6481.89, z = 29.20 },
    { x = 357.79, y = 6483.20, z = 29.11 },
    { x = 357.70, y = 6480.34, z = 29.32 },
    { x = 357.89, y = 6477.77, z = 29.47 },
    { x = 357.66, y = 6472.39, z = 29.83 },
    { x = 357.64, y = 6467.36, z = 30.12 },
    { x = 357.96, y = 6464.54, z = 30.22 },
}

local cottonProccess <const> = {
    { x = 713.87, y = -959.94, z = 30.4 },
    { x = 716.77, y = -960.09, z = 30.4 },
    { x = 718.75, y = -960.00, z = 30.4 },
    { x = 718.87, y = -962.44, z = 30.4 },
    { x = 716.49, y = -962.46, z = 30.4 },
    { x = 714.88, y = -967.59, z = 30.4 },
    { x = 714.98, y = -969.66, z = 30.4 },
    { x = 714.91, y = -971.79, z = 30.4 },
}

local sellLocation <const> = {
  --  { x = 89.73, y = -1592.95, z = 29.89 },
}

local costureiroBlips <const> = {
    { title = T("STITCHER_JOB"), colour = 29, id = 366, x = 718.87, y = -962.44, z = 30.4, scale = 0.5},
    { title = T("STITCHER_COTTON_FIELD"), colour = 2, id = 761, x = 357.89, y = 6477.77, z = 29.47, scale = 0.5},
    { title = T("STITCHER_CLOAKROOM"), colour = 26, id = 280, x = 707.12, y = -966.53, z = 30.41, scale = 0.5},
    { title = T("STITCHER_CLOAKROOM"), colour = 26, id = 280, x = 405.59, y = 6526.21, z = 27.70, scale = 0.5},
    { title = T("STITCHER_SELLING_LOCATION"),  colour = 25, id = 500, x =   64.49, y = -1590.37, z = 29.60, scale = 0.8},
}

-- Enter / Exit marker events
local function createCostureiroMarkers()
    if PlayerData.job == nil or PlayerData.job.name ~= 'costureiro' then
        return
    end

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("costureiro_cloakroom" .. i, {type = 50, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("costureiro_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "costureiroEnteredMarker"}, exit = {eventClient = "costureiroExitedMarker"}, data = 'cloakroom', active = {}})
        table.insert(createdMarkers, "costureiro_cloakroom" .. i)
    end

    for i=1, #cottonLocation, 1 do
        exports.ft_libs:AddMarker("costureiro_harvest" .. i, {type = 50, x = cottonLocation[i].x, y = cottonLocation[i].y, z = cottonLocation[i].z, weight = 1, height = 1, red = 0, green = 0, blue = 255, showDistance = 25})
        exports.ft_libs:AddTrigger("costureiro_harvest" .. i, {x = cottonLocation[i].x, y = cottonLocation[i].y, z = cottonLocation[i].z, weight = 2, height = 2,
        enter = {eventClient = "costureiroEnteredMarker"}, exit = {eventClient = "costureiroExitedMarker"}, data = 'harvesting', active = {}})
        table.insert(createdMarkers, "costureiro_harvest" .. i)
    end

    for i=1, #cottonProccess, 1 do
        exports.ft_libs:AddMarker("costureiro_process" .. i, {type = 50, x = cottonProccess[i].x, y = cottonProccess[i].y, z = cottonProccess[i].z, weight = 1, height = 1, red = 156, green = 63, blue = 33, showDistance = 25})
        exports.ft_libs:AddTrigger("costureiro_process" .. i, {x = cottonProccess[i].x, y = cottonProccess[i].y, z = cottonProccess[i].z, weight = 1, height = 2,
        enter = {eventClient = "costureiroEnteredMarker"}, exit = {eventClient = "costureiroExitedMarker"}, data = 'processing', active = {}})
        table.insert(createdMarkers, "costureiro_process" .. i)
    end

    for i=1, #sellLocation, 1 do
        exports.ft_libs:AddMarker("costureiro_selling" .. i, {type = 50, x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, weight = 1, height = 1, red = 0, green = 255, blue = 128, showDistance = 25})
        exports.ft_libs:AddTrigger("costureiro_selling" .. i, {x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "costureiroEnteredMarker"}, exit = {eventClient = "costureiroExitedMarker"}, data = 'selling', active = {}})
        table.insert(createdMarkers, "costureiro_selling" .. i)
    end

    for _, info in pairs(costureiroBlips) do
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


local function removeCostureiroMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end
    createdMarkers = {}

    if not created then
        return
    end

    for i, blip in pairs(costureiroBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end


RegisterNetEvent("costureiroFail", function()
    local ped = PlayerPedId()
    collectActive = false
    processActive = false
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end)


local function startProccessing()
    Citizen.CreateThread(function()
        if processActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        while processActive do
            TriggerServerEvent("cframework:costureiroProcessing", processMaterial) 

            Citizen.Wait(processTime)
        end
    end)

    Citizen.CreateThread(function()
        while processActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification(T("STITCHER_PRESS_TO_STOP_STITCHING"))

            if IsControlJustReleased(1, 51) then
                TriggerEvent('costureiroFail')
            end
        end
    end)
end


local function cottonProccessing()
    local elements = {
        {label = ESX.GetItemLabel("fabric"),         value = 'fabric'},
      --  {label = ESX.GetItemLabel("kevlar"),         value = 'kevlar'},
    }

    TriggerEvent('chud:itemselector', elements, T("STITCHER_JOB"), T("STITCHER_STITCHING"), function(value)
        if value == 'fabric' then
            processMaterial = 'fabric'
            processTime = 1500
            processActive = true
        end

        if value == 'kevlar' then
            processMaterial = 'kevlar'
            processTime = 3500
            processActive = true
        end

        if processActive then
            TriggerEvent('esx_inventoryhud:doClose')

            RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
            Citizen.Wait(100)
            TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 8.0, -1, 81, 0, true, true, true)

            startProccessing()
        end
    end)
end


local function costureiroSelling()
    local elements = {
        {label = ('%s (%s€)'):format(ESX.GetItemLabel("fabric"), 20),       value = 'fabric'},
        {label = ('%s (%s€)'):format(ESX.GetItemLabel("kevlar"), 70),       value = 'kevlar'},
    }

    TriggerEvent('chud:itemselector', elements, T("STITCHER_SALE_MENU_TITLE"), T("GENERIC_SELL"), function(value)
        if value == 'fabric' then
            TriggerServerEvent("cframework:sellTecido")
        end

        if value == 'kevlar' then
            TriggerServerEvent("cframework:sellKevlar")
        end
    end)
end


local function costureiroCloakroom()
    local elements = {
        {label = ("🧥 %s"):format(T("GENERIC_CLOTHING_CITIZEN")),     value = 'cloakroom1'},
        {label = ("👔 %s"):format(T("GENERIC_CLOTHING_JOB")),         value = 'cloakroom2'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, T("STITCHER_JOB"), function(value)
        if value == 'cloakroom1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent('cframework:exitCostureiroService')
            canWorkCostureiro = false
        end

        if value == 'cloakroom2' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
            TriggerServerEvent('cframework:enterCostureiroService')
            canWorkCostureiro = true
        end
    end)
end


local function startHarvestingCotton()
    collectActive = true

    Citizen.CreateThread(function()
        local tool = 'scissors'--RPC.execute('getMiningTool')

        if tool == 'none' then
            collectActive = false
            ESX.ShowNotification(T("STITCHER_NO_TOOLS_TO_WORK"), 'error')
            return
        end

        FreezeEntityPosition(PlayerPedId(), true)

        if tool == 'scissors' then
            RequestAnimDict("amb@prop_human_movie_bulb@base")
            Citizen.Wait(100)

            TaskPlayAnim(PlayerPedId(), 'amb@prop_human_movie_bulb@base', 'base', 8.0, 8.0, -1, 1, 0, true, true, true)

            while collectActive do
                Citizen.Wait(2000)
                TriggerServerEvent("cframework:getHarvestedItem", 'scissors')
            end
        end

    end)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while collectActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification(T("STITCHER_PRESS_TO_CANCEL_COLLECTING"))

            if IsControlJustReleased(1, 51) then
                local playerPed <const> = PlayerPedId()
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                collectActive = false
            end
        end
    end)
end


RegisterNetEvent('costureiroEnteredMarker', function(action)
    CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'cloakroom' then
                CurrentAction = nil
                costureiroCloakroom()
            end

            if CurrentAction == 'processing' and canWorkCostureiro then
                CurrentAction = nil
                if not processActive then
                    cottonProccessing()
                end
            end

            if CurrentAction == 'selling' then
                CurrentAction = nil
                costureiroSelling()
            end

            if CurrentAction == 'harvesting' and canWorkCostureiro then
                CurrentAction = nil
                if not collectActive then
                    startHarvestingCotton()
                end
            end

            ::final::
        end
    end)
end)


RegisterNetEvent('costureiroExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)


RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    removeCostureiroMarkers()
    createCostureiroMarkers()
end)


RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeCostureiroMarkers()
    createCostureiroMarkers()
end)


local function ceninhassparatebanir()
    local item = 0
    TriggerServerEvent("gcostureiro:giveKevlar")
    TriggerServerEvent("gcostureiro:giveTecido")
    TriggerServerEvent("esx_costureiro:giveitem", item)
end