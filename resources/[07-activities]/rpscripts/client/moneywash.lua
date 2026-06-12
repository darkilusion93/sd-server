local KEY                       = 2254
local createdMarkers 			= {}
local CurrentAction				= nil
local CurrentActionMsg			= ''
local CurrentActionData			= {}
local isWashing					= false

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(10) end
	while ESX.GetPlayerData().job == nil do Citizen.Wait(10) end
	ESX.PlayerData = ESX.GetPlayerData()
	createMoneyMarkers()
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
	createMoneyMarkers()
end)

RegisterNetEvent('washedMoney', function(washedTotal)
	ESX.ShowNotification('Recebeste ' .. ESX.Math.GroupDigits(washedTotal) .. '€ dinheiro limpo.', 'success')
	isWashing = false
end)

RegisterNetEvent('washMoney', function(timeClock)
	ESX.ShowNotification('Tens dinheiro sujo a lavar. Tempo: ' ..  timeClock, 'inform')
	isWashing = true
	Citizen.CreateThread(function()
		FreezeEntityPosition(PlayerPedId(), true)
		while isWashing do Citizen.Wait(1000) end
		FreezeEntityPosition(PlayerPedId(), false)
	end)
end)

function OpenWashedMenu(zone)
	local elements = {{label = _U('wash_money'), 	value = 'wash_money'}}
	local data = ESX.DefaultMenu(_U('washed_menu'), elements)

	if data.value == 'wash_money' then
		local amount = tonumber(ESX.DialogMenu(_U('wash_money_amount')))
				
		if amount == nil then ESX.ShowNotification(_U('invalid_amount'), 'error') return end	
		if isWashing then ESX.ShowNotification('Já estás a lavar.', 'error') return end

		TriggerServerEvent('washMoney', amount, zone, KEY)
	end
end

AddEventHandler('esx_moneywash:hasEnteredMarker', function(zone)
	local zone = zone[1]
	CurrentAction     = 'wash_menu'
	CurrentActionMsg  = _U('press_menu')
	CurrentActionData = {zone = zone}
end)

AddEventHandler('esx_moneywash:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()		
end)

function createMoneyMarkers()
	removeMoneyMarkers()

	for k,zoneID in pairs(Config.WashZones) do
		if not Authorized(zoneID) then goto continue end
	
		for i = 1, #zoneID.Pos, 1 do
			exports.ft_libs:AddMarker("esx:moneywash" .. i, {type = Config.Type, x = zoneID.Pos[i].x, y = zoneID.Pos[i].y, z = zoneID.Pos[i].z,
			weight = Config.Size.x, height = Config.Size.z,red = Config.Color.r, green = Config.Color.g, blue = Config.Color.b, showDistance = Config.DrawDistance})

			exports.ft_libs:AddTrigger("esx:moneywash" .. i, {x = zoneID.Pos[i].x, y = zoneID.Pos[i].y,	z = zoneID.Pos[i].z, weight = Config.Size.x, height = 5,
			enter = {eventClient = "esx_moneywash:hasEnteredMarker"}, exit = {eventClient = "esx_moneywash:hasExitedMarker"}, data = {k}, active = {callback = activeMarkersMoneyWash}})

			table.insert(createdMarkers, "esx:moneywash" .. i)
		end
			
		::continue::
	end
end

function Authorized(zoneID)
	for _,job in pairs(zoneID.Jobs) do
		if job == 'any' or (ESX.PlayerData.job ~= nil and job == ESX.PlayerData.job.name) then return true end
	end
	
	return false
end

function removeMoneyMarkers()
	for i=1, #createdMarkers, 1 do
	  exports.ft_libs:RemoveTrigger(createdMarkers[i])
	  exports.ft_libs:RemoveMarker(createdMarkers[i])
	end
	createdMarkers = {}
end

function activeMarkersMoneyWash()
	if CurrentAction == nil then
		return
	end

	ESX.ShowHelpNotification(CurrentActionMsg)
	if IsControlJustReleased(0, 38) then
		if CurrentAction == 'wash_menu' then OpenWashedMenu(CurrentActionData.zone) end
		CurrentAction = nil
	end
end