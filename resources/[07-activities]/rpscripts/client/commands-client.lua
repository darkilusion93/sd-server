ESX = nil
local coordsCarro = nil
local stored = false
local hash = nil
props = nil
local engineHealth = nil
local heading = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end
end)

RegisterNetEvent('commands:lookup')
AddEventHandler('commands:lookup', function(playerName)
	DropPlayer(source, 'Este comando não é permitido!')
	TriggerClientEvent('chat:addMessage', -1,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { "Servidor" , "Jogador ^2" .. GetPlayerName(source) .. "^0 Foi kickado(^2Usar o comando /lookup é proíbido^0)"}
	})
	--ESX.ShowNotification(_U('commands_lookup', playerName))
end)

RegisterNetEvent('commands:addy')
AddEventHandler('commands:addy', function(y)
	local sourcePed = GetPlayerPed(-1)
	--SetEntityCoords(sourcePed, GetEntityCoords(sourcePed) + y)
end)

--[[RegisterCommand("garagem", function(source, args, rawCommand)
	local ped = GetPlayerPed(-1)
	if not stored then
		coordsCarro = GetEntityCoords(ped)
		if IsPedInAnyVehicle(ped, true) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			heading = GetEntityHeading(vehicle)
			engineHealth = GetVehicleEngineHealth(vehicle)
			hash = GetEntityModel(vehicle)
			props = ESX.Game.GetVehicleProperties(vehicle)
			ESX.Game.DeleteVehicle(vehicle)
			stored = true
		else
			exports["cframework"]:SendAlert("error", 'Não estás em nenhum veículo.')	
		end
	else
		if not IsPedInAnyVehicle(ped, true) then
			if(GetDistanceBetweenCoords(GetEntityCoords(ped), coordsCarro, true) < 10.0) then
				local propsi = props
				ESX.Game.SpawnVehicle(props.model, coordsCarro, heading, function(vehicle_c)
					ESX.Game.SetVehicleProperties(vehicle_c, propsi)
					SetVehicleEngineHealth(vehicle_c, engineHealth)
				end)

				hash = nil
				props = nil
				stored = false
			else
				exports["cframework"]:SendAlert("error", 'Estás demasiado afastado do local onde guardaste o veículo.')
			end
		else
			exports["cframework"]:SendAlert("error", 'Não podes guardar mais do que um veículo ao mesmo tempo.')
		end
	end
end, false)

RegisterCommand("garagem", function(source, args, rawCommand)
	local ped = GetPlayerPed(-1)
	if not stored then
		coordsCarro = GetEntityCoords(ped)
		if IsPedInAnyVehicle(ped, true) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			heading = GetEntityHeading(vehicle)
			engineHealth = GetVehicleEngineHealth(vehicle)
			hash = GetEntityModel(vehicle)
			props = ESX.Game.GetVehicleProperties(vehicle)
			ESX.Game.DeleteVehicle(vehicle)
			stored = true
		else
			exports["cframework"]:SendAlert("error", 'Não estás em nenhum veículo.')	
		end
	else
		if not IsPedInAnyVehicle(ped, true) then
			if(GetDistanceBetweenCoords(GetEntityCoords(ped), coordsCarro, true) < 10.0) then
				local propsi = props
				ESX.Game.SpawnVehicle(props.model, coordsCarro, heading, function(vehicle_c)
					ESX.Game.SetVehicleProperties(vehicle_c, propsi)
					SetVehicleEngineHealth(vehicle_c, engineHealth)
				end)

				hash = nil
				props = nil
				stored = false
			else
				exports["cframework"]:SendAlert("error", 'Estás demasiado afastado do local onde guardaste o veículo.')
			end
		else
			exports["cframework"]:SendAlert("error", 'Não podes guardar mais do que um veículo ao mesmo tempo.')
		end
	end
end, false)]]


--[[
RegisterCommand("effect", function(source, args, rawCommand)
	AnimpostfxPlay(
		args[1], 
		1000, 
		true
	)
end, false)

RegisterCommand("drug", function(source, args, rawCommand)
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	psychedelic()
	AnimpostfxPlay('DrugsMichaelAliensFight', 2000, true)
	Citizen.Wait(10000)
	AnimpostfxStop('DrugsMichaelAliensFight')
end, false)

function psychedelic()
	AnimpostfxPlay('DrugsMichaelAliensFight', 200, false)
	AnimpostfxPlay('MinigameEndTrevor', 200, false)
	Citizen.Wait(100)
	AnimpostfxPlay('MinigameEndFranklin', 200, false)
	Citizen.Wait(200)
	AnimpostfxPlay('MinigameEndMichael', 200, false)
	Citizen.Wait(200)
	AnimpostfxPlay('DrugsMichaelAliensFight', 200, false)
	AnimpostfxPlay('MinigameEndNeutral', 200, false)
	Citizen.Wait(300)
	AnimpostfxPlay('MinigameEndFranklin', 200, false)
	Citizen.Wait(200)
	AnimpostfxPlay('MinigameEndNeutral', 200, false)
	Citizen.Wait(100)
	AnimpostfxPlay('DrugsMichaelAliensFight', 200, false)
	AnimpostfxPlay('MinigameEndTrevor', 200, false)
	Citizen.Wait(200)
	AnimpostfxPlay('MinigameEndMichael', 200, false)
end

RegisterCommand("seffect", function(source, args, rawCommand)
	AnimpostfxStopAll()
end, false)


RegisterCommand("camstart", function(source, args, rawCommand)
	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
	end
	SetCamActive(cam,  true)
	RenderScriptCams(true,  false,  0,  true,  true)
	SetCamCoord(cam, -288.92544555664, -2443.6701660156, 591.98687744141)
	PointCamAtCoord(cam, -169.18321228027, -1056.4204101563, 129.99223327637)
end, false)

RegisterCommand("camstop", function(source, args, rawCommand)
	SetCamActive(cam,  false)
	RenderScriptCams(false,  false,  0,  true,  true)
end, false)

RegisterCommand("createcam", function(source, args, rawCommand)
	local playerCoords = GetEntityCoords(PlayerPedId())

	local object = GetClosestObjectOfType(playerCoords, 5.0, GetHashKey("prop_dart_bd_cab_01"), 1, 0, 1)
	local rotation = GetEntityRotation(object, 2)


	if DoesEntityExist(object) then
		local offset = GetOffsetFromEntityInWorldCoords(object, -0.1792, -1.738, 0.2214)
		local camRot = vector3(-7.9947, 0.0, rotation.z )--+ 36.19176)
		local camera = CreateCameraWithParams(26379945, offset, camRot, 65.0, 0, 2);
		SetCamFov(camera, 30.0)
		SetCamActive(camera, true)
		RenderScriptCams(true, false, 3000, 1, 0, 0)
	end
					
end, false)

RegisterCommand("chamaboi", function(source, args, rawCommand)
	TriggerEvent("fx:run", "lsd", 8, 0.0, true, false)
end, false)

RegisterCommand("broca", function(source, args, rawCommand)
	local playerPed = GetPlayerPed(-1)

	TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CONST_DRILL", 0, true)

end, false)]]

--[[
RegisterCommand("pedonscreen", function(source, args, rawCommand)
    Citizen.CreateThread(function()
        local heading = GetEntityHeading(PlayerPedId())
        SetFrontendActive(true)
        ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_JOINING_SCREEN"), true, -1)
        Wait(100)
        SetMouseCursorVisibleInMenus(false)
        PlayerPedPreview = ClonePed(PlayerPedId(), false, true, false)
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedPreview))

		---@diagnostic disable-next-line: missing-parameter
        SetEntityCoords(PlayerPedPreview, x, y, z - 10)
        FreezeEntityPosition(PlayerPedPreview, true)
        SetEntityVisible(PlayerPedPreview, false, false)
        NetworkSetEntityInvisibleToNetwork(PlayerPedPreview, false)
        Wait(200)
        SetPedAsNoLongerNeeded(PlayerPedPreview)
        GivePedToPauseMenu(PlayerPedPreview, 2)
        SetPauseMenuPedLighting(true)
        if true then
            SetPauseMenuPedSleepState(false)
            Wait(1000)
            SetPauseMenuPedSleepState(true)
        else
            SetPauseMenuPedSleepState(true)
        end
    end)
end, false)]]

--[[
RegisterCommand("opendoor", function(source, args, rawCommand)
	local vehicle, distance = ESX.Game.GetClosestVehicle()

    --TaskEnterVehicle(PlayerPedId(), vehicle, 5000, 0, 1.0, 1, 0)
    TaskOpenVehicleDoor(PlayerPedId(), vehicle, 5000, 0, 1.0)
end, false)

--SetGameplayCamFollowPedThisUpdate

RegisterNetEvent("CEventNetworkPlayerEnteredVehicle", function(entities, eventEntity, data)
    print(json.encode(entities))
    print(eventEntity)
    print(json.encode(data))
end)

AddEventHandler('gameEventTriggered', function (name, args)
    print('game event ' .. name .. ' (' .. json.encode(args) .. ')')
end)



local walkstick = `prop_cs_walking_stick`

local PlayerProps = {}
local holdingstick = false

local walk_net = 0

RegisterCommand("walkstick", function()
    local player = GetPlayerPed(-1)
    local plyCoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, -5.0)

    if not HasModelLoaded(walkstick) then
        RequestModel(walkstick)
        while not HasModelLoaded(walkstick) do print("Requesting", walkstick) Citizen.Wait(1) end
    end

    local umbspawned = CreateObject(walkstick, plyCoords.x, plyCoords.y, plyCoords.z, false, true, true)
    table.insert(PlayerProps, umbspawned)

    if (DoesEntityExist(player) and not IsEntityDead(player)) then 
        if holdingstick then
            Wait(100)
            ClearPedSecondaryTask(GetPlayerPed(-1))
            DetachEntity(walk_net, 1, 1)
            DeleteEntity(walk_net)

            walk_net = 0
            holdingstick = false
        else
            Wait(500)

            AttachEntityToEntity(umbspawned, player, GetPedBoneIndex(player, 57005), 0.15, 0.0, -0.01, 0.0, -90.0, 0.0, 1, 1, 0, 1, 0, 1)
            
            RequestWalking('move_heist_lester')
            SetPedMovementClipset(PlayerPedId(-1), 'move_heist_lester', 0.2)
            RemoveAnimSet('move_heist_lester')
            Wait(120)
            walk_net = umbspawned
            holdingstick = true
        end
    end
end)

function RequestWalking(animSet)
    RequestAnimSet(animSet)
    while not HasAnimSetLoaded(animSet) do Citizen.Wait(1) end
end]]


--[[ Delta Time calculation example
    local lastTime = GetGameTimer()

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0) -- runs every frame

            local currentTime = GetGameTimer()
            local dt = (currentTime - lastTime) / 1000.0 -- Convert to seconds
            lastTime = currentTime

            -- Use dt for smooth calculations (like movement)
            print("Delta Time: " .. dt)
        end
    end)
]]


--[[ 
    This function needs to be invoked prior to calling CreateMissionTrain  or the trains (as well as its carriages) won't spawn.
    Could also result in a game-crash when CreateMissionTrain is called without
    loading the train model needed for the variation before-hand.

function loadTrainModels()
    local trainsAndCarriages = {
        'freight', 'metrotrain', 'freightcont1', 'freightcar', 
        'freightcar2', 'freightcont2', 'tankercar', 'freightgrain'
    }

    for _, vehicleName in ipairs(trainsAndCarriages) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey) -- load the model
        -- wait for the model to load
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(500)
        end
    end
end

loadTrainModels()

RegisterCommand("createtrain", function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            args = { 
                'Error, provide a variation id, you can find those in trains.xml. Variations range from 0 to 26.'
            }
        })
        return
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
     -- Now actually create a train using a variation
     -- These coordinates were used for testing: 1438.98, 6405.92, 34.19
    CreateMissionTrain(
        tonumber(args[1]),
        playerCoords.x, playerCoords.y, playerCoords.z,
        true,
        false,
        true
    )
end, false)]]