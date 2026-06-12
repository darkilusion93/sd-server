ESX = nil

cachedData = {
	["motels"] = {},
	["storages"] = {},
	["furnishings"] = {},
	["keys"] = {}
}

Citizen.CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(25)
	end

	if ESX.IsPlayerLoaded() then
		Init()
	end

	AddTextEntry("furnishing_instructions", Config.HelpTextMessage)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(playerData)
	ESX.PlayerData = playerData

	Init()
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

AddEventHandler("onResourceStop", function(resource)
	if resource ~= GetCurrentResourceName() then return end

	RemoveSpawnedProps()
end)

RegisterNetEvent("james_motels:eventHandler")
AddEventHandler("james_motels:eventHandler", function(event, eventData)
	if event == "update_motels" then
		cachedData["motels"] = eventData
	elseif event == "update_storages" then
		cachedData["storages"][eventData["storageId"]] = eventData["newTable"]

		if ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "main_storage_menu_" .. eventData["storageId"]) then
			local openedMenu = ESX.UI.Menu.GetOpened("default", GetCurrentResourceName(), "main_storage_menu_" .. eventData["storageId"])

			if openedMenu then
				openedMenu.close()

				--OpenStorage(eventData["storageId"])
			end
		end
	elseif event == "invite_player" then
		if eventData["player"]["source"] == GetPlayerServerId(PlayerId()) then
			Citizen.CreateThread(function()
				local startedInvite = GetGameTimer()

				cachedData["invited"] = true

				while GetGameTimer() - startedInvite < 7500 do
					Citizen.Wait(0)

					ESX.ShowHelpNotification("Foste convidado ao quarto #" .. eventData["motel"]["room"] .. ". ~INPUT_DETONATE~ para entrar.")

					if IsControlJustPressed(0, 47) then
						EnterMotel(eventData["motel"])

						break
					end
				end

				cachedData["invited"] = false
			end)
		end
	elseif event == "knock_motel" then
		local currentInstance = DecorGetInt(PlayerPedId(), "currentInstance")

		if currentInstance and currentInstance == eventData["uniqueId"] then
			ESX.ShowNotification("Você ouviu uma batida de fora.", "inform")
		end
	elseif event == "update_furnishing" then
		local currentInstance = DecorGetInt(PlayerPedId(), "currentInstance")

		cachedData["furnishings"][eventData["motelId"]]["furnishing"] = eventData["furnishingData"]

		if currentInstance == eventData["motelId"] then
			SpawnFurnishing(currentInstance)
		end
	elseif event == "update_owned_furnishing" then
		if not cachedData["furnishings"][eventData["id"]] then cachedData["furnishings"][eventData["id"]] = {} end

		cachedData["furnishings"][eventData["id"]]["ownedFurnishing"] = eventData["newData"]
	else
		-- print("Wrong event handler.")
	end
end)

RegisterNetEvent("james_motels:menuchaves")
AddEventHandler("james_motels:menuchaves", function()
	ShowKeyMenu()
end)

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if IsControlJustPressed(0, 56) then
			ShowKeyMenu()
		end
	end
end)]]

Citizen.CreateThread(function()
	Citizen.Wait(50)

	cachedData["lastCheck"] = GetGameTimer() - 4750

	CreateBlip()

	local hasOpenedTextUI = false

	while true do
		local sleepThread = 5

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		local yourMotel = GetPlayerMotel()

		for motelRoom, motelPos in ipairs(Config.MotelsEntrances) do
			local playerRoom = yourMotel and (yourMotel["room"] == motelRoom)

			local dstCheck = #(pedCoords - motelPos)
			local dstRange = playerRoom and 35.0 or 3.0

			if dstCheck <= dstRange then
				sleepThread = 0

				DrawScriptMarker({
					["type"] = 2,
					["pos"] = motelPos,
					["r"] = not playerRoom and 150 or 0,
					["g"] = playerRoom and 150 or 0,
					["b"] = 0,
					["sizeX"] = 0.3,
					["sizeY"] = 0.3,
					["sizeZ"] = 0.3,
					["rotate"] = true
				})

				if dstCheck <= 0.8 then
					local displayText = (playerRoom and "[E] Entrar" or "")

					if not hasOpenedTextUI then
						ESX.ShowHelpNotification(displayText)
						hasOpenedTextUI = "motel_" .. motelRoom
					end

					if IsControlJustPressed(0, 38) then
						if playerRoom then
							EnterMotel(yourMotel)
						end
					end

					DrawScriptText(motelPos + vector3(0.0, 0.0, 0.5), displayText)
				end
			end
		end

		local dstCheckLandlord = #(pedCoords - Config.LandLord["position"])

		if dstCheckLandlord <= 3.0 then
			sleepThread = 0

			local displayText = "Comprar Quarto"

			if dstCheckLandlord <= 0.9 then
				displayText = "[E] " .. displayText

				if not hasOpenedTextUI then
					ESX.ShowHelpNotification(displayText)
					hasOpenedTextUI = "landlord"
				end

				if IsControlJustPressed(0, 38) then
					OpenLandLord()
				end
			end

			DrawScriptText(Config.LandLord["position"], displayText)
		end

		if hasOpenedTextUI and sleepThread == 5 then
			hasOpenedTextUI = false
		end

		Citizen.Wait(sleepThread)
	end
end)