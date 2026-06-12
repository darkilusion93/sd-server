

local drugData = LoadDrugs()

local createdMarkers = {}
local created = false
local CurrentAction = nil

local currentPed = nil

local plantouWeed = false
local isPlantingWeed = false
local ondePlantouWeed = vector3(0, 0, 0)

local harvest <const> = drugData.harvest
local processing <const> = drugData.processing
local pedSelling <const> = drugData.pedSelling
local dealerSelling <const> = drugData.dealerSelling

local pedList = {}

for k, v in pairs(pedSelling) do
    for i, loc in ipairs(v.locations) do
        table.insert(pedList, {x = loc.x, y = loc.y, z = loc.z, h = loc.h, model = loc.model, scenario = loc.scenario, type = k})
    end
end

Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for i, pedTable in ipairs(pedList) do
            if #(coords - vector3(pedTable.x, pedTable.y, pedTable.z)) < 50.0 then
                if not pedTable.ped or not DoesEntityExist(pedTable.ped) then
                    local pedModel = GetHashKey(pedTable.model)

                    if not IsModelValid(pedModel) then goto skip_loop end

                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Citizen.Wait(0)
                    end

                    pedList[i].ped = CreatePed(4, pedModel, pedTable.x, pedTable.y, pedTable.z, 0.0, false, true)

                    if pedTable.h then
                        SetEntityHeading(pedList[i].ped, pedTable.h)
                    end

                    if pedList[i].scenario == nil then
                        TaskWanderStandard(pedList[i].ped, 10.0, 10)
                    elseif pedList[i].scenario then
                        TaskStartScenarioInPlace(pedList[i].ped, pedList[i].scenario, 0, false)

                        --PlaceObjectOnGroundProperly(pedList[i].ped)
                        --FreezeEntityPosition(pedList[i].ped, true)

                        SetEntityCanBeDamaged(pedList[i].ped, false)
                        SetBlockingOfNonTemporaryEvents(pedList[i].ped, true)
                        SetPedCanRagdollFromPlayerImpact(pedList[i].ped, false)

                        SetPedResetFlag(pedList[i].ped, 249, true)
                        SetPedConfigFlag(pedList[i].ped, 185, true)
                        SetPedConfigFlag(pedList[i].ped, 108, true)
                        SetPedConfigFlag(pedList[i].ped, 208, true)
                    end

                    SetModelAsNoLongerNeeded(pedModel)
                else
                    if DoesEntityExist(pedTable.ped) and IsEntityDead(pedTable.ped) then
                        Citizen.Wait(10000)
                        DeleteEntity(pedTable.ped)
                    end
                end

                ::skip_loop::
            end
        end

        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
    while true do
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local ped, distance = ESX.Game.GetClosestPed(coords, {GetPlayerPed(-1)})
        local auxPed = nil

        if distance < 1.6 and distance >= 0.0 then
            for i, pedTable in ipairs(pedList) do if pedTable.ped == ped then auxPed = pedTable break end end

            if IsControlJustPressed(0, 38) and not ESX.isPlayerDead() and not ESX.isHandcuffed() and not IsPedInAnyVehicle(PlayerPedId(), false) then
                currentPed = auxPed

                if currentPed ~= nil then
                    TriggerServerEvent("cframework:sellPedDrug", currentPed.type)
                end

                Citizen.Wait(3000)
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(5)
    end
end)


RegisterNetEvent('tradeDrugWithPed', function()
    if currentPed == nil then
        return
    end

    local ped = currentPed.ped
    if not ped or not DoesEntityExist(ped) then
        return
    end

    ESX.MakeEntityFaceEntity(PlayerPedId(), ped)
    ESX.MakeEntityFaceEntity(ped, PlayerPedId())
    SetPedTalk(ped)
    PlayAmbientSpeech1(ped, 'GENERIC_HI', 'SPEECH_PARAMS_STANDARD')

    local obj = CreateObject(GetHashKey('prop_meth_bag_01'), 0.0, 0.0, 0.0, false, true, false)
    AttachEntityToEntity(obj, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)

    local obj2 = CreateObject(GetHashKey('hei_prop_heist_cash_pile'), 0.0, 0.0, 0.0, false, true, false)
    AttachEntityToEntity(obj2, ped, GetPedBoneIndex(ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)

    ESX.PlayAnim('mp_common', 'givetake1_a', 8.0, -1, 0)
    ESX.PlayAnimOnPed(ped, 'mp_common', 'givetake1_a', 8.0, -1, 0)
    Citizen.Wait(1000)

    AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped,  57005), 0.13, 0.02, 0.0, -90.0, 0, 0, true, true, false, true, 0, true)
    Citizen.Wait(1000)

    DeleteEntity(obj)
    DeleteEntity(obj2)
    PlayAmbientSpeech1(ped, 'GENERIC_THANKS', 'SPEECH_PARAMS_STANDARD')

    ClearPedTasks(PlayerPedId())
    if not currentPed.isDealer and currentPed.scenario == nil then
        TaskWanderStandard(ped, 10.0, 10)
    elseif not currentPed.isDealer and currentPed.scenario then
        TaskStartScenarioInPlace(ped, currentPed.scenario, 0, false)
    end
end)


RegisterNetEvent("cframework:enableDealer", function(k, selectedLocation, timeLeft)
    local coords <const> = vector4(dealerSelling[k].locations[selectedLocation].x, dealerSelling[k].locations[selectedLocation].y, dealerSelling[k].locations[selectedLocation].z, dealerSelling[k].locations[selectedLocation].h)
    local pedModel <const> = dealerSelling[k].locations[selectedLocation].model

    dealerSelling[k].dealerBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    --SetBlipRoute(dealerBlip, true)
    BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(T("DRUGS_DEALER"))
	EndTextCommandSetBlipName(dealerSelling[k].dealerBlip)

    exports.ft_libs:AddTrigger("drugs_harvest" .. k, {x = coords.x, y = coords.y, z = coords.z, weight = 5.0, height = 2,
    enter = {eventClient = "drugsEnteredMarker"}, exit = {eventClient = "drugsExitedMarker"}, data = {'dealer', k}, active = {callback = activeDrugMarkers}})

    exports.ft_libs:AddPed("drugs_harvest" .. k, {model = pedModel, x = coords.x, y = coords.y, z = coords.z, w = coords.w})

    Citizen.Wait(timeLeft * 1000)

    if DoesBlipExist(dealerSelling[k].dealerBlip) then
        RemoveBlip(dealerSelling[k].dealerBlip)
    end

    if CurrentAction == 'dealer' then
        CurrentAction = nil
    end

    exports.ft_libs:RemoveTrigger("drugs_harvest" .. k)
    exports.ft_libs:RemovePed("drugs_harvest" .. k)
end)


-- Enter / Exit marker events
function createDrugMarkers()

    for i=1, #harvest, 1 do
        exports.ft_libs:AddTrigger("drugs_harvest" .. i, {x = harvest[i].x, y = harvest[i].y, z = harvest[i].z, weight = harvest[i].w, height = 2,
        enter = {eventClient = "drugsEnteredMarker"}, exit = {eventClient = "drugsExitedMarker"}, data = {'harvest', harvest[i].type}, active = {callback = activeDrugMarkers}})
        table.insert(createdMarkers, "drugs_harvest" .. i)

        if not created and harvest[i].onMap then
            local blip = AddBlipForRadius(harvest[i].x, harvest[i].y, harvest[i].z , harvest[i].r)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, 1)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 2)

            local blip3 = AddBlipForCoord(harvest[i].x, harvest[i].y, harvest[i].z)
            SetBlipSprite (blip3, harvest[i].sprite)
            SetBlipDisplay(blip3, 2)
            SetBlipScale  (blip3, 0.5)
            SetBlipColour (blip3, harvest[i].color)
            SetBlipAsShortRange(blip3, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(harvest[i].name)
            EndTextCommandSetBlipName(blip3)
        end
    end

    for i=1, #processing, 1 do
        exports.ft_libs:AddMarker("drugs_processing" .. i, {type = 50, x = processing[i].x, y = processing[i].y, z = processing[i].z+1.0, weight = 2.5, height = 1, red = 0, green = 255, blue = 210, showDistance = 25})
        exports.ft_libs:AddTrigger("drugs_processing" .. i, {x = processing[i].x, y = processing[i].y, z = processing[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "drugsEnteredMarker"}, exit = {eventClient = "drugsExitedMarker"}, data = {'processing', processing[i].type}, active = {callback = activeDrugMarkers}})
        table.insert(createdMarkers, "drugs_processing" .. i)

        if not created and processing[i].onMap then
            local blip = AddBlipForRadius(processing[i].x, processing[i].y, processing[i].z , processing[i].r)
            SetBlipHighDetail(blip, true)
            SetBlipColour(blip, processing[i].rcolor)
            SetBlipAlpha(blip, 128)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 2)

            local blip3 = AddBlipForCoord(processing[i].x, processing[i].y, processing[i].z)
            SetBlipSprite (blip3, processing[i].sprite)
            SetBlipDisplay(blip3, 2)
            SetBlipScale  (blip3, 0.5)
            SetBlipColour (blip3, processing[i].color)
            SetBlipAsShortRange(blip3, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(processing[i].name)
            EndTextCommandSetBlipName(blip3)
        end
    end

    created = true
end

Citizen.CreateThread(function()
    createDrugMarkers()
end)


local blockHarvest = false
local blockProcess = false
local blockSell = false

local function plantDrug(type)
    local ped = GetPlayerPed(-1)
	if not plantouWeed then
		if isPlantingWeed then return end
        if not RPC.execute('cframework:useSeed', type) then Citizen.Wait(1000) return end

        isPlantingWeed = true
        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, true)
        Citizen.Wait(10000)

        ClearPedTasks(PlayerPedId())

        ondePlantouWeed = GetEntityCoords(ped)
        plantouWeed = true
        isPlantingWeed = false
	else
		if #(GetEntityCoords(ped) - ondePlantouWeed) > 1.0 then ESX.ShowNotification(T("DRUGS_TOO_FAR_FROM_PLANT"), 'error') return end

        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
        Citizen.Wait(20000)

        RPC.execute('cframework:harvestDrug', type)

        ClearPedTasks(PlayerPedId())
		plantouWeed = false
	end
end


local continueProcessing = true

RegisterNetEvent("cframework:processDrugFail", function()
    continueProcessing = false
end)

local function processDrug(type)
    local coords = GetEntityCoords(PlayerPedId())

    continueProcessing = true

    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.CreateThread(function()
        while true do
            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_CANCEL"))
            if IsControlJustPressed(0, 38) or not continueProcessing then
                continueProcessing = false
                FreezeEntityPosition(PlayerPedId(), false)
                return
            end
            Citizen.Wait(0)
        end
    end)

    TriggerServerEvent("cframework:startProcessDrug", type)

    while continueProcessing do
        Citizen.Wait(5000)

        if not continueProcessing then
            goto final
        end

        ::final::

        if #(coords - GetEntityCoords(PlayerPedId())) > 10.0 then
            continueProcessing = false
        end
    end

    TriggerServerEvent("cframework:stopProcessDrug")
end



local continueSelling = true

RegisterNetEvent("cframework:sellDrugFail", function()
    continueSelling = false
end)

local function sellDrug(type)
    local coords = GetEntityCoords(PlayerPedId())

    continueSelling = true

    FreezeEntityPosition(PlayerPedId(), true)
    Citizen.CreateThread(function()
        while true do
            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_CANCEL"))
            if IsControlJustPressed(0, 38) or not continueSelling then
                continueSelling = false
                FreezeEntityPosition(PlayerPedId(), false)
                return
            end
            Citizen.Wait(0)
        end
    end)

    while continueSelling do
        Citizen.Wait(5000)

        if not continueSelling then
            goto final
        end

        TriggerServerEvent("cframework:sellDealerDrug", type)

        ::final::

        if #(coords - GetEntityCoords(PlayerPedId())) > 10.0 then
            continueSelling = false
        end
    end
end


RegisterNetEvent('drugsEnteredMarker', function(action)
    CurrentAction = action[1]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                goto final
            end

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'harvest' and not blockHarvest then
                blockHarvest = true
                plantDrug(action[2])
                blockHarvest = false
            end

            if CurrentAction == 'processing' and not blockProcess then
                blockProcess = true
                processDrug(action[2])
                blockProcess = false
            end

            if CurrentAction == 'dealer' and not blockSell then
                blockSell = true
                sellDrug(action[2])
                blockSell = false
            end

            ::final::

            Citizen.Wait(0)
        end
    end)
end)



RegisterNetEvent('drugsExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)


function blicasFritasComMolhoDeNaiao()
	TriggerServerEvent('esx_drugs:startHarvestCoke')
	TriggerServerEvent('esx_drugs:startTransformCoke')
	TriggerServerEvent('esx_drugs:startSellCoke')

	TriggerServerEvent('esx_drugs:startHarvestMeth')
	TriggerServerEvent('esx_drugs:startTransformMeth')
	TriggerServerEvent('esx_drugs:startSellMeth')

	TriggerServerEvent('esx_drugs:startHarvestWeed')
	TriggerServerEvent('esx_drugs:startTransformWeed')
	TriggerServerEvent('esx_drugs:startSellWeed')

	TriggerServerEvent('esx_drugs:startHarvestOpium')
	TriggerServerEvent('esx_drugs:startTransformOpium')
	TriggerServerEvent('esx_drugs:startSellOpium')
end

--[[
RegisterCommand("cocaine", function()
    TriggerEvent("fx:run", "cocaine", 8, 0.0, false, false)
end)

RegisterCommand("lsd", function()
    TriggerEvent("fx:run", "lsd", 30, -1, false)
end)

RegisterCommand("badlsd", function()
    TriggerEvent("fx:run", "lsd", 30, -1, true)
end)

RegisterCommand("alcohol", function()
    TriggerEvent("fx:run", "alcohol", 30, 1.0, -1, false)
end)

RegisterCommand("strongalcohol", function()
    TriggerEvent("fx:run", "alcohol", 30, 1.0, -1, true)
end)

RegisterCommand("weed", function()
    TriggerEvent("fx:run", "weed", 30, -1, false)
end)

RegisterCommand("crack", function()
    TriggerEvent("fx:run", "crack", 8, 0.0, false, false)
end)]]
