local createdMarkers = {}
local PlayerData = {}
local created = false
local CurrentAction = nil

local canWorkLumberjack = false

local cuttingActive = false
local sawingActive = false
local dryingActive = false

local sawing = 1000
local drying = 1000

local material = nil

local cuttingLocations = {
    { x = -701.96, y = 5462.54, z = 44.56 },
    { x = -704.70, y = 5486.26, z = 44.90 },
    { x = -699.25, y = 5489.37, z = 45.60 },
    { x = -677.08, y = 5488.14, z = 48.89 },
    { x = -667.44, y = 5496.61, z = 48.06 },
    { x = -663.53, y = 5494.77, z = 48.84 },
    { x = -660.53, y = 5490.35, z = 49.67 },
    { x = -664.24, y = 5463.02, z = 51.06 },
    { x = -652.31, y = 5455.47, z = 51.79 },
    { x = -643.06, y = 5461.82, z = 53.24 },
    { x = -638.76, y = 5503.00, z = 51.32 },
    { x = -649.63, y = 5510.29, z = 48.91 },
    { x = -633.14, y = 5505.52, z = 51.27 },
    { x = -619.50, y = 5498.73, z = 51.24 },
    { x = -604.23, y = 5500.94, z = 51.67 },
    { x = -586.61, y = 5509.86, z = 52.50 },
}

local cloakRoomLocation = {
    { x = -552.73, y = 5348.56, z = 74.74 },
    { x = -841.12, y = 5401.33, z = 34.62 },
}

local sawingLocation = {
    { x = -494.37, y = 5289.57, z = 79.61 },
}

local dryingLocation = {
    { x = -554.16, y = 5325.24, z = 72.60 },
}

local sellLocation = {
   -- { x = 87.59, y = -1601.75, z = 31.08, w = 255.13 },
}

local lumberjackBlips = {
    { title="Floresta",                 colour = 25, id = 210, x = -664.24, y =  5463.02, z = 51.06, scale = 0.5},
    { title="Secagem de Madeira",       colour = 28, id = 648, x = -554.16, y =  5325.24, z = 72.60, scale = 0.5},
    { title="Corte de Madeira",         colour = 43, id = 761, x = -494.37, y =  5289.57, z = 79.61, scale = 0.7},
    { title="Vestuario Lenhador",       colour = 43, id = 280, x = -552.73, y =  5348.56, z = 74.74, scale = 0.5},
    { title="Vestuario Lenhador",       colour = 43, id = 280, x = -841.12, y =  5401.33, z = 34.62, scale = 0.5},
    { title="Venda de Madeira",         colour = 25, id = 500, x =   64.49, y = -1590.37, z = 29.60, scale = 0.8},
}     

-- Enter / Exit marker events
local function createLumberjackMarkers()
    if PlayerData.job == nil or PlayerData.job.name ~= 'lumberjack' then
        return
    end

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("lumberjack_cloakroom" .. i, {type = 50, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("lumberjack_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "lumberjackEnteredMarker"}, exit = {eventClient = "lumberjackExitedMarker"}, data = {'cloakroom'}, active = {}})
        table.insert(createdMarkers, "lumberjack_cloakroom" .. i)
    end

    for i=1, #sawingLocation, 1 do
        exports.ft_libs:AddMarker("lumberjack_washing" .. i, {type = 1, x = sawingLocation[i].x, y = sawingLocation[i].y, z = sawingLocation[i].z, weight = 2.5, height = 1, red = 138, green = 255, blue = 170, showDistance = 25})
        exports.ft_libs:AddTrigger("lumberjack_washing" .. i, {x = sawingLocation[i].x, y = sawingLocation[i].y, z = sawingLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "lumberjackEnteredMarker"}, exit = {eventClient = "lumberjackExitedMarker"}, data = {'sawing'}, active = {}})
        table.insert(createdMarkers, "lumberjack_washing" .. i)
    end

    for i=1, #dryingLocation, 1 do
        exports.ft_libs:AddMarker("lumberjack_remelting" .. i, {type = 1, x = dryingLocation[i].x, y = dryingLocation[i].y, z = dryingLocation[i].z, weight = 2.5, height = 1, red = 232, green = 206, blue = 35, showDistance = 25})
        exports.ft_libs:AddTrigger("lumberjack_remelting" .. i, {x = dryingLocation[i].x, y = dryingLocation[i].y, z = dryingLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "lumberjackEnteredMarker"}, exit = {eventClient = "lumberjackExitedMarker"}, data = {'drying'}, active = {}})
        table.insert(createdMarkers, "lumberjack_remelting" .. i)
    end

    for i=1, #sellLocation, 1 do
        exports.ft_libs:AddPed("lumberjack_selling" .. i, {model = `a_m_m_farmer_01`, x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, w = sellLocation[i].w})
        exports.ft_libs:AddTrigger("lumberjack_selling" .. i, {x = sellLocation[i].x, y = sellLocation[i].y, z = sellLocation[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "lumberjackEnteredMarker"}, exit = {eventClient = "lumberjackExitedMarker"}, data = {'selling'}, active = {}})
        table.insert(createdMarkers, "lumberjack_selling" .. i)
    end

    for i=1, #cuttingLocations, 1 do
        exports.ft_libs:AddMarker("lumberjack_cutting" .. i, {type = 50, x = cuttingLocations[i].x, y = cuttingLocations[i].y, z = cuttingLocations[i].z, weight = 1, height = 1, red = 50, green = 168, blue = 82, showDistance = 25})
        exports.ft_libs:AddTrigger("lumberjack_cutting" .. i, {x = cuttingLocations[i].x, y = cuttingLocations[i].y, z = cuttingLocations[i].z, weight = 2, height = 2,
        enter = {eventClient = "lumberjackEnteredMarker"}, exit = {eventClient = "lumberjackExitedMarker"}, data = {'cutting'}, active = {}})
        table.insert(createdMarkers, "lumberjack_cutting" .. i)
    end

    for _, info in pairs(lumberjackBlips) do
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


local function removeLumberjackMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
        exports.ft_libs:RemovePed(createdMarkers[i])
    end
    createdMarkers = {}

    if not created then
        return
    end

    for i, blip in pairs(lumberjackBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end


RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    removeLumberjackMarkers()
    createLumberjackMarkers()
end)


RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeLumberjackMarkers()
    createLumberjackMarkers()
end)


local function startSawing()
    Citizen.CreateThread(function()
        if sawingActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        while sawingActive do
            if material == "cerejeira" then
                TriggerServerEvent("cframework:lumberjackSawing", "cerejeira")
            end

            if material == "carvalho" then
                TriggerServerEvent("cframework:lumberjackSawing", "carvalho")
            end

            if material == "pinho" then
                TriggerServerEvent("cframework:lumberjackSawing", "pinho")
            end

            if material == "ebano" then
                TriggerServerEvent("cframework:lumberjackSawing", "ebano")
            end

            Citizen.Wait(sawing)
        end
    end)

    Citizen.CreateThread(function()
        while sawingActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para parar de serrar.")

            if IsControlJustReleased(1, 51) then
                Citizen.Wait(sawing)
                TriggerEvent('lumberjackFail')
            end
        end
    end)
end


local function sawingWood()
    local elements = {
        { label = 'Tábua de Cerejeira (Húmida)', value = 'wet_wood_plank_cherry' },
        { label = 'Tábua de Carvalho (Húmida)', value = 'wet_wood_plank_oak' },
        { label = 'Tábua de Pinho (Húmida)', value = 'wet_wood_plank_pine' },
        { label = 'Tábua de Ébano (Húmida)', value = 'wet_wood_plank_ebony' },
    }

    TriggerEvent('chud:itemselector', elements, 'Serragem', 'Serrar', function(value)
        if value == 'wet_wood_plank_cherry' then
            material = 'cerejeira'
            sawing = 850
            sawingActive = true
        end

        if value == 'wet_wood_plank_oak' then
            material = 'carvalho'
            sawing = 850
            sawingActive = true
        end

        if value == 'wet_wood_plank_pine' then
            material = 'pinho'
            sawing = 850
            sawingActive = true
        end

        if value == 'wet_wood_plank_ebony' then
            material = 'ebano'
            sawing = 850
            sawingActive = true
        end

        if sawingActive then
            TriggerEvent('esx_inventoryhud:doClose')
            startSawing()
        end
    end)
end


local function startDrying()
    Citizen.CreateThread(function()
        if dryingActive then
            FreezeEntityPosition(PlayerPedId(), true)
        end

        while dryingActive do
            TriggerServerEvent("cframework:lumberjackDrying", material)

            Citizen.Wait(drying)
        end
    end)

    Citizen.CreateThread(function()
        while dryingActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para parar de secar.")

            if IsControlJustReleased(1, 51) then
                Citizen.Wait(drying)
                TriggerEvent('lumberjackFail')
            end
        end
    end)
end


local function dryingWood()
    local elements = {
        { label = 'Tábua de Cerejeira', value = 'wood_plank_cherry' },
        { label = 'Tábua de Carvalho', value = 'wood_plank_oak' },
        { label = 'Tábua de Pinho', value = 'wood_plank_pine' },
        { label = 'Tábua de Ébano', value = 'wood_plank_ebony' },
    }
    local actionName, actionAction = 'Secagem', 'Secar'

    TriggerEvent('chud:itemselector', elements, actionName, actionAction, function(value)
        if value == 'wood_plank_cherry' then
            material = 'cerejeira'
            drying = 1500
            dryingActive = true
        end

        if value == 'wood_plank_oak' then
            material = 'carvalho'
            drying = 1500
            dryingActive = true
        end

        if value == 'wood_plank_pine' then
            material = 'pinho'
            drying = 1500
            dryingActive = true
        end

        if value == 'wood_plank_ebony' then
            material = 'ebano'
            drying = 1500
            dryingActive = true
        end

        if dryingActive then
            TriggerEvent('esx_inventoryhud:doClose')
            startDrying()
        end
    end)
end


local function lumberjackCloakroom()
    local elements = {
        {label = '🧥 Roupas de civil',         value = 'cloakroom1'},
        {label = '👔 Roupa de trabalho',       value = 'cloakroom2'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, 'Lenhador', function(value)
        if value == 'cloakroom1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent('cframework:exitLumberjackService')
            canWorkLumberjack = false
        end

        if value == 'cloakroom2' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
            TriggerServerEvent('cframework:enterLumberjackService')
            canWorkLumberjack = true
        end
    end)
end


local function woodSelling(secret)
    local elements = {
        {label = 'Serradura (8€)',      value = 'wood_dust'},
        {label = 'Pinho (15€)',         value = 'wood_plank_pine'},
        {label = 'Carvalho (20€)',      value = 'wood_plank_oak'},
        {label = 'Cerejeira (25€)',     value = 'wood_plank_cherry'},
        {label = 'Ébano (70€)',         value = 'wood_plank_ebony'},
    }

    if secret then
        elements = {
            {label = 'Ébano (100€)',         value = 'wood_plank_ebony'},
        }
    end

    TriggerEvent('chud:itemselector', elements, 'Venda - Lenhador', 'Vender', function(value)
        if value == 'wood_dust' then
            TriggerServerEvent("cframework:sellWoodDust")
        end

        if value == 'wood_plank_pine' then
            TriggerServerEvent("cframework:sellPinho")
        end

        if value == 'wood_plank_oak' then
            TriggerServerEvent("cframework:sellCarvalho")
        end

        if value == 'wood_plank_cherry' then
            TriggerServerEvent("cframework:sellCerejeira")
        end

        if value == 'wood_plank_ebony' then
            TriggerServerEvent("cframework:sellEbano", secret)
        end
    end)
end


local function startCutting()
    Citizen.CreateThread(function()
        local tool = RPC.execute('getCuttingTool')

        if tool == "none" then
            cuttingActive = false
            ESX.ShowNotification("Não tens ferramentas de trabalho.", "error")
            return
        end

        FreezeEntityPosition(PlayerPedId(), true)

        if tool == "axe" then
            TriggerEvent("attachItem", "axe")

            RequestAnimDict("melee@large_wpn@streamed_core")
            Citizen.Wait(100)

            while cuttingActive do
                local playerPed = PlayerPedId()

                TaskPlayAnim(playerPed, "melee@large_wpn@streamed_core", "short_0_attack", 8.0, 8.0, -1, 0, 0, true, true, true)
                TriggerEvent("InteractSound_CL:PlayOnOne", "axe", 0.5)
                Citizen.Wait(2000)
                TriggerServerEvent("cframework:getCuttedItem")
            end
        end

        if tool == "chainsaw" then
            TriggerEvent("attachItem", "chainsaw")

            while cuttingActive do
                TriggerEvent("InteractSound_CL:PlayOnOne", "chainsaw", 0.3)
                Citizen.Wait(1000)
                TriggerServerEvent("cframework:getCuttedItem")
            end
        end

    end)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        while cuttingActive do
            Citizen.Wait(0)
		    ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para parar de cortar.")

            if IsControlJustReleased(1, 51) then
                Citizen.Wait(2000)
                local playerPed = PlayerPedId()
                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)
                TriggerEvent("destroyProp")
                cuttingActive = false
            end
        end
    end)
end

RegisterNetEvent("lumberjackEnteredMarker", function(action)
    CurrentAction = action[1]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == "cloakroom" then
                CurrentAction = nil
                lumberjackCloakroom()
            end

            if CurrentAction == "sawing" and canWorkLumberjack then
                CurrentAction = nil
                if not sawingActive then
                    sawingWood()
                end
            end

            if CurrentAction == "drying" and canWorkLumberjack then
                CurrentAction = nil
                if not dryingActive then
                    dryingWood()
                end
            end

            if CurrentAction == "selling" then
                CurrentAction = nil
                woodSelling(false)
            end

            if CurrentAction == "extraselling" then
                CurrentAction = nil
                woodSelling(true)
            end

            if CurrentAction == "cutting" and canWorkLumberjack then
                CurrentAction = nil
                if not cuttingActive then
                    cuttingActive = true
                    startCutting()
                end
            end

            ::final::
        end
    end)

end)

RegisterNetEvent("lumberjackExitedMarker", function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)


RegisterNetEvent("lumberjackFail", function()
    local ped = PlayerPedId()
    dryingActive = false
    sawingActive = false
    ClearPedTasks(ped)
    FreezeEntityPosition(ped, false)
end)
