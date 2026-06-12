local PlayerSpawned = false
local Pickups       = {}

local function checkItems()
    local hasRadio, hasPhone, hasTablet = false, false, false

    for k,v in ipairs(ESX.PlayerData.invData.items) do
        if v.name == 'radio' and v.count > 0 then
            hasRadio = true
		end
		if v.name == 'tel' and v.count > 0 then
			hasPhone = true
		end
		if v.name == 'tablet' and v.count > 0 then
			hasTablet = true
        end
    end

    exports["mumble-voip"]:SetRadio(hasRadio)
    exports["cphone"]:SetPhone(hasPhone)
    exports["cphone"]:SetTablet(hasTablet)
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerLoaded = true
	ESX.PlayerData   = xPlayer

	SpawnPlayer({x = xPlayer.lastPosition.x, y = xPlayer.lastPosition.y, z = xPlayer.lastPosition.z, skin = xPlayer.skin})

	--, xPlayer.health
	print(xPlayer.isDead)
	if xPlayer.isDead ~= 0 and xPlayer.isDead ~= false and xPlayer.isDead ~= "0" then
		print("Dead")
		SpawnAlreadyDead(xPlayer.deathData)
		StartDeathLoop()
	else
		print("noDead")
		StartDeathLoop()
		SetEntityHealth(PlayerPedId(), xPlayer.health)
	end

    checkItems()
end)


AddEventHandler('playerSpawned', function()
	while not ESX.PlayerLoaded do
		Citizen.Wait(1)
	end

	local playerPed = PlayerPedId()

	-- Restore position
	if ESX.PlayerData.lastPosition then
		SetEntityCoords(playerPed, ESX.PlayerData.lastPosition.x, ESX.PlayerData.lastPosition.y, ESX.PlayerData.lastPosition.z, false, false, false, false)
	end

	if ESX.PlayerData.comserv > 0 then
		TriggerEvent('esx_communityservice:inCommunityService', ESX.PlayerData.comserv)
	end

	isLoadoutLoaded = true
	isPlayerSpawned = true
end)

RegisterNetEvent('cframework:setMoney', function(money)
    if ESX.PlayerData.money == nil then return end
	if money < 0 then ESX.ShowNotification(T("CURRENCY_NEGATIVE_MONEY") .. money, 'inform') end

	local amount = money - ESX.PlayerData.money

	ESX.PlayerData.money = money

	if amount < 0 then
		ESX.UI.ShowInventoryItemNotification(false, {label=""}, ESX.formatAsCurrency(amount*-1))
	else
		ESX.UI.ShowInventoryItemNotification(true, {label=""}, ESX.formatAsCurrency(amount))
	end
end)

RegisterNetEvent('cframework:deleteVehicle', function(plate)
	for i=1, #ESX.PlayerData.vehicles, 1 do
		if ESX.PlayerData.vehicles[i].plate == plate then
			table.remove(ESX.PlayerData.vehicles, i)
			break
		end
	end
end)

RegisterNetEvent('cframework:addVehicle', function(vehicle)
	table.insert(ESX.PlayerData.vehicles, vehicle)
end)

RegisterNetEvent('cframework:setVehiclePoundState', function(plate, state, zone)
	for i=1, #ESX.PlayerData.vehicles, 1 do
		if ESX.PlayerData.vehicles[i].plate == plate then
			ESX.PlayerData.vehicles[i].stored = state
            if zone ~= nil then
                ESX.PlayerData.vehicles[i].zone = zone
            end
			break
		end
	end
end)

RegisterNetEvent('cframework:updateVehiclePoundStateAndProps', function(vehicle, state, zone)
	local originVehicle = nil

	for i=1, #ESX.PlayerData.vehicles, 1 do
		if ESX.PlayerData.vehicles[i].plate == vehicle.plate then
			originVehicle = ESX.PlayerData.vehicles[i]

			if originVehicle.vehicle.model == vehicle.vehicle.model then
				ESX.PlayerData.vehicles[i].vehicle = vehicle.vehicle
				ESX.PlayerData.vehicles[i].stored = state

				if zone ~= nil then
                	ESX.PlayerData.vehicles[i].zone = zone
				end
			end

			break
		end
	end
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if ESX.PlayerData.accounts == nil then return end

	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end
end)

RegisterNetEvent('esx:addInventoryItem', function(item, count, invCount, insert)
    if insert then
        table.insert(ESX.PlayerData.invData.items, item)
    else
        for k,v in ipairs(ESX.PlayerData.invData.items) do
            if v.slot == item.slot then
                ESX.PlayerData.invData.items[k].count = item.count
                break
            end
        end
    end

	ESX.UI.ShowInventoryItemNotification(true, item, count)
    TriggerEvent("cframework:updateInventory")
    checkItems()
end)

RegisterNetEvent('esx:removeInventoryItem', function(item, count, invCount, remove)
	for k,v in ipairs(ESX.PlayerData.invData.items) do
		if v.name == item.name and v.slot == item.slot then
            if remove then
                table.remove(ESX.PlayerData.invData.items, k)
            else
                ESX.PlayerData.invData.items[k].count = item.count
            end
			break
		end
	end

	ESX.UI.ShowInventoryItemNotification(false, item, count)
    TriggerEvent("cframework:updateInventory")
    checkItems()
end)

RegisterNetEvent('esx:changeSlotItem', function(item, fromSlot, remove)
    if remove then
        local originItemKey = nil
        local targetItemKey = nil

        for k,v in ipairs(ESX.PlayerData.invData.items) do
            if v.slot == fromSlot then
                originItemKey = k
            end

            if v.slot == item.slot then
                targetItemKey = k
            end
        end

        if targetItemKey then
            ESX.PlayerData.invData.items[targetItemKey].count = item.count
        end

        if originItemKey then
            table.remove(ESX.PlayerData.invData.items, originItemKey)
        end
    else
        local originItemKey = nil
        local targetItemKey = nil

        for k,v in ipairs(ESX.PlayerData.invData.items) do
            if v.slot == fromSlot then
                originItemKey = k
            end

            if v.slot == item.slot then
                targetItemKey = k
            end
        end

        if originItemKey then
            ESX.PlayerData.invData.items[originItemKey].slot = item.slot
        end

        if targetItemKey then
            ESX.PlayerData.invData.items[targetItemKey].slot = fromSlot
        end
    end

    TriggerEvent("cframework:updateInventory")
end)

RegisterNetEvent("esx:updateMetadata", function(item, metadataKey, metadataValue)
    for k,v in ipairs(ESX.PlayerData.invData.items) do
        if v.slot == item.slot then
            ESX.PlayerData.invData.items[k].metadata[metadataKey] = metadataValue
            break
        end
    end

    TriggerEvent("cframework:updateInventory")
end)

RegisterNetEvent("esx:updateSlots", function(slots)
    ESX.PlayerData.invData.slots = slots

    TriggerEvent("cframework:updateInventory")
end)



RegisterNetEvent('esx:addArmour')
AddEventHandler('esx:addArmour', function(value)
	local playerPed  = PlayerPedId()

	SetPedArmour(playerPed, value)
	--AddAmmoToPed(playerPed, weaponHash, ammo) possibly not needed
end)

RegisterNetEvent('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local playerPed  = PlayerPedId()
	local weaponHash = GetHashKey(weaponName)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash

	GiveWeaponComponentToPed(playerPed, weaponHash, componentHash)
end)

-- Commands
RegisterNetEvent('esx:teleport', function(pos)
	pos.x = pos.x + 0.0
	pos.y = pos.y + 0.0
	pos.z = pos.z + 0.0

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)

	while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		RequestCollisionAtCoord(pos.x, pos.y, pos.z)
		Citizen.Wait(1)
	end

	SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z, false, false, false, false)
end)

RegisterNetEvent('esx:setJob', function(job)
	if Config.EnableHud then
		ESX.UI.HUD.UpdateElement('job', {
			job_label   = job.label,
			grade_label = job.grade_label
		})
	end
end)

RegisterNetEvent('esx:loadIPL', function(name)
    Citizen.CreateThread(function()
		LoadMpDlcMaps()
		RequestIpl(name)
	end)
end)

RegisterNetEvent('esx:unloadIPL', function(name)
	Citizen.CreateThread(function()
		RemoveIpl(name)
	end)
end)

RegisterNetEvent('esx:playAnim', function(dict, anim)
	Citizen.CreateThread(function()
		local playerPed = PlayerPedId()
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, dict, anim, 1.0, -1.0, 20000, 0, 1, true, true, true)
	end)
end)

RegisterNetEvent('esx:playEmote', function(emote)
	Citizen.CreateThread(function()

		local playerPed = PlayerPedId()

		TaskStartScenarioInPlace(playerPed, emote, 0, false);
		Citizen.Wait(20000)
		ClearPedTasks(playerPed)
	end)
end)

RegisterNetEvent('esx:spawnObject', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	ESX.Game.SpawnObject(model, {
		x = x,
		y = y,
		z = z
	}, function(obj)
		SetEntityHeading(obj, GetEntityHeading(playerPed))
		PlaceObjectOnGroundProperly(obj)
	end)
end)

RegisterNetEvent('esx:pickup', function(id, label, player)
	local ped     = GetPlayerPed(GetPlayerFromServerId(player))
	local coords  = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local x, y, z = table.unpack(coords + forward * -2.0)

	ESX.Game.SpawnLocalObject('prop_money_bag_01', {
		x = x,
		y = y,
		z = z - 2.0,
	}, function(obj)
		SetEntityAsMissionEntity(obj, true, false)
		PlaceObjectOnGroundProperly(obj)

		Pickups[id] = {
			id = id,
			obj = obj,
			label = label,
			inRange = false,
			coords = {
				x = x,
				y = y,
				z = z
			}
		}
	end)
end)

RegisterNetEvent('esx:removePickup', function(id)
	ESX.Game.DeleteObject(Pickups[id].obj)
	Pickups[id] = nil
end)

RegisterNetEvent('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords.x, pickupCoords.y, pickupCoords.z, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:spawnPed', function(model)
	model           = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
	local forward   = GetEntityForwardVector(playerPed)
	local x, y, z   = table.unpack(coords + forward * 1.0)

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		CreatePed(5, model, x, y, z, 0.0, true, false)
	end)
end)

RegisterNetEvent('esx:deleteVehicle', function()
	local playerPed = PlayerPedId()
	--local vehicle   = ESX.Game.GetVehicleInDirection()
	local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle()

	if IsPedInAnyVehicle(playerPed, true) then
		closestVehicle = GetVehiclePedIsIn(playerPed, false)
	end

	if DoesEntityExist(closestVehicle) and closestDistance < 5.0 then
		ESX.Game.DeleteVehicle(closestVehicle)
	end
end)

-- Last position
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

    	if GetPlayerWantedLevel(PlayerId()) ~= 0 then
    	  SetPlayerWantedLevel(PlayerId(), 0, false)
    	  SetPlayerWantedLevelNow(PlayerId(), false)
    	end

		if ESX.PlayerLoaded and PlayerSpawned then
			local playerPed = PlayerPedId()
			local coords    = GetEntityCoords(playerPed)

			if not IsEntityDead(playerPed) then
				ESX.PlayerData.lastPosition = {x = coords.x, y = coords.y, z = coords.z}
			end
		end
	end
end)

CreateThread(function()
	while true do
		SetRadarAsExteriorThisFrame()
		SetRadarAsInteriorThisFrame(`h4_fake_islandx`, 4700.0, -5145.0, 0, 0)
		Wait(0)
	end
end)

--[[
RegisterNetEvent('autodestruct', function()
    SetPedArmour(PlayerPedId(), 0)
    SetEntityHealth(PlayerPedId(), 110)
end)]]