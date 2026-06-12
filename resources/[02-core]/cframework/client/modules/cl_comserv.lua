

local comservData = LoadCommunityService()

local isSentenced = false
local actionsRemaining = 0
local actionsReason = ""
local availableActions = {}
local disableActions = false

local function fillActionTable(lastAction)
	while #availableActions < 5 do
		local actionLocation <const> = comservData.ServiceLocations[math.random(1,#comservData.ServiceLocations)]
		local actionDoesNotExist = true

		for i = 1, #availableActions do
			if actionLocation.coords.x == availableActions[i].coords.x and actionLocation.coords.y == availableActions[i].coords.y and actionLocation.coords.z == availableActions[i].coords.z then
				actionDoesNotExist = false
			end
		end

		if lastAction ~= nil and actionLocation.coords.x == lastAction.coords.x and actionLocation.coords.y == lastAction.coords.y and actionLocation.coords.z == lastAction.coords.z then
			actionDoesNotExist = false
		end

		if actionDoesNotExist then
			table.insert(availableActions, actionLocation)
		end
	end
end

local function removeAction(action)
	local actionPos = -1

	for i=1, #availableActions do
		if action.coords.x == availableActions[i].coords.x and action.coords.y == availableActions[i].coords.y and action.coords.z == availableActions[i].coords.z then
			actionPos = i
		end
	end

	if actionPos ~= -1 then
		table.remove(availableActions, actionPos)
	end
end

local function executeAction(tmpAction)
	removeAction(tmpAction)
	fillActionTable(tmpAction)
	disableActions = true

	TriggerEvent('esx_basicneeds:healPlayer')

	if tmpAction.type == "cleaning" then
		ESX.Streaming.RequestAnimDict("amb@world_human_janitor@male@idle_a", function()
			TaskPlayAnim(PlayerPedId(), "amb@world_human_janitor@male@idle_a", "idle_a", 8.0, -8.0, -1, 0, 0, false, false, false)
			TriggerEvent("attachItem", "broom01")
		end)

		ESX.SetTimeout(10000, function()
			disableActions = false

			ClearPedTasks(PlayerPedId())
			TriggerEvent("destroyProp")

			actionsRemaining = actionsRemaining - 1

			ESX.PlayerData.comserv = actionsRemaining
			TriggerServerEvent('esx_communityservice:removeAction', actionsRemaining)
		end)
	end

	if tmpAction.type == "gardening" then
		TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)

		ESX.SetTimeout(6000, function()
			disableActions = false
			ClearPedTasks(PlayerPedId())

			actionsRemaining = actionsRemaining - 1

			ESX.PlayerData.comserv = actionsRemaining
			TriggerServerEvent('esx_communityservice:removeAction', actionsRemaining)
		end)
	end
end

local function drawAvailableActions()
	for i = 1, #availableActions do
		---@diagnostic disable-next-line: param-type-mismatch
		DrawMarker(21, availableActions[i].coords.x, availableActions[i].coords.y, availableActions[i].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 50, 50, 204, 100, false, true, 2, true, false, false, false)
	end
end

local function disableViolentActions()
	local playerPed <const> = PlayerPedId()

	if disableActions then
		DisableAllControlActions(0)
	end

	RemoveAllPedWeapons(playerPed, true)

	DisableControlAction(2, VK_TAB, true) -- disable weapon wheel (Tab)
	DisablePlayerFiring(playerPed,true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
    DisableControlAction(0, VK_KEY_X, true) -- Disable in-game mouse controls
    DisableControlAction(0, VK_KEY_R, true)
	DisableControlAction(0, VK_KEY_Q, true)
	DisableControlAction(0, 142, true)

	DisableControlAction(0, VK_KEY_N, true) --Disable falar

	if IsDisabledControlJustPressed(2, VK_TAB) then --if Tab is pressed, send error message
		SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) -- if tab is pressed it will set them to unarmed (this is to cover the vehicle glitch until I sort that all out)
	end

	if IsDisabledControlJustPressed(0, 106) then --if LeftClick is pressed, send error message
		SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true) -- If they click it will set them to unarmed
	end
end

local function drawOnScreenText(text, pos)
	SetTextFont(4)
	SetTextProportional(true)
	SetTextScale(0.45, 0.45)
	SetTextColour(255, 255, 255, 255)
	---@diagnostic disable-next-line: redundant-parameter
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(table.unpack(pos))
end

local function comservDrawLoop()
	while isSentenced do
		local playerCoords <const> = GetEntityCoords(PlayerPedId())

		drawOnScreenText( (T("COMSERV_ACTIONS_REMAINING")):format(ESX.Math.Round(actionsRemaining), actionsReason), { 0.175, 0.955 } )
		drawAvailableActions()
		disableViolentActions()

		for _, action in ipairs(availableActions) do
			local distance <const> = #(playerCoords - action.coords)

			if distance < 1.5 then
				ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))

				if IsControlJustReleased(1, VK_KEY_E) then
					executeAction(action)

					goto start_over
				end
			end
		end

		::start_over::
		Citizen.Wait(0)
	end
end

ESX.isSentenced = function()
	return isSentenced
end

RegisterNetEvent('esx_communityservice:inCommunityService', function(numberOfActions, reason)
	local playerPed <const> = PlayerPedId()

	if isSentenced then
		return
	end

	isSentenced = true
	ESX.PauseStatus(true)

	Citizen.CreateThread(function()
		comservDrawLoop()
	end)

	TriggerEvent('cframework:disableMe')
	TriggerEvent('cframework:disableEmotes')
	TriggerEvent('cframework:closePhone')
	TriggerEvent('cframework:stopPegar')
	TriggerEvent('cframework:disableVehiclePush')
	exports["mumble-voip"]:setOverrideCoords(true)

	actionsRemaining = numberOfActions
    actionsReason = reason or T("COMSERV_NO_REASON")
	ESX.PlayerData.comserv = actionsRemaining

	fillActionTable()

	ESX.Game.Teleport(playerPed, comservData.ServiceLocation)

	while isSentenced do
		if IsPedInAnyVehicle(playerPed, false) then
			ClearPedTasksImmediately(playerPed)
		end

		Citizen.Wait(1000)

		if #(GetEntityCoords(playerPed) - vector3(comservData.ServiceLocation.x, comservData.ServiceLocation.y, comservData.ServiceLocation.z)) > 45 then
			ESX.Game.Teleport(playerPed, comservData.ServiceLocation)

			ESX.ShowNotification(T("COMSERV_TRY_ESCAPING"), "error")
			TriggerServerEvent('esx_communityservice:extendService')
			actionsRemaining = actionsRemaining + comservData.ServiceExtensionOnEscape
		end
	end

	DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

	TriggerEvent('cframework:enableEmotes')
	TriggerEvent('cframework:enableVehiclePush')
	TriggerEvent('cframework:enableMe')
	exports["mumble-voip"]:setOverrideCoords(false)

	startBustedRoutine()
end)

RegisterNetEvent('esx_communityservice:finishCommunityService', function()
	isSentenced = false
	ESX.PauseStatus(false)
	actionsRemaining = 0
	ESX.PlayerData.comserv = 0
end)

RegisterNetEvent('cframework:fixComservActions', function(remaining)
	actionsRemaining = remaining
	ESX.PlayerData.comserv = actionsRemaining
end)
