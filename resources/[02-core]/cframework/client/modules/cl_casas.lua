local CurrentAction = nil
local insideProperty = false
local currentProperty = nil
local currentPropertyId = 0
local currentPropertyOwner = nil
local lowFrontDoorEntity = 0
local myIdentifier = nil

local ownedHouses = {}
local sharedHouses = {}
local propertyBlips = {}

local tvRenderTarget = 0

local function loadTvRenderTarget(model)
    if IsNamedRendertargetRegistered("television") then
        return
    end

    RequestStreamedTextureDict("television", false)

    RegisterNamedRendertarget("tvscreen", false)
    LinkNamedRendertarget(model)

    tvRenderTarget = GetNamedRendertargetRenderId("tvscreen")
end

local function setupTvChannel()
    SetTvChannel(0)
    SetTvChannelPlaylist(0, "PL_STD_CNT", false)
    SetTvVolume(50)
    EnableMovieSubtitles(false)
end

local function formatNumberWithSpaces(number)
    local formattedNumber = tostring(number):reverse():gsub("(%d%d%d)", "%1 "):reverse()
    return formattedNumber
end

local function promptTransferStorage(id)
    local elements2 = {}

    table.insert(elements2, {label = "✔️ Confirmar - 5.000.000€", value = "confirm"})
    table.insert(elements2, {label = "❌ Cancelar",  value = 'cancel'})

    TriggerEvent('chud:menu', elements2, 'Transferir Armazenamento', function(value)
        TriggerEvent('esx_inventoryhud:doClose')

        if value == 'confirm' then
            TriggerServerEvent('cframework:transferToStorageUnit', id)
        end
    end)
end

local function openArmarioCasa()
	local outside = currentProperty.entrance
	local elements = {}

	table.insert(elements, {label = "📦 Armazém", value = "casa_inventory"})
	table.insert(elements, {label = "🙋‍♂️ Convidar alguém",  value = 'invite_player'})

	if myIdentifier == currentPropertyOwner then
		table.insert(elements, {label = "🗝️ Trocar fechadura", value = 'remove_access'})
        table.insert(elements, {label = "🚚 Transferir Armazenamento", value = 'transfer_storage'})
	end

	TriggerEvent('chud:menu', elements, 'Armário', function(value)
		if value == 'invite_player' then
			ESX.TriggerServerCallback('esx_casa:getPlayersInArea', function(playersInArea)
				local inviteElements      = {}

				for i=1, #playersInArea, 1 do
					if playersInArea[i] ~= PlayerId() then
						table.insert(inviteElements, {label = playersInArea[i].name, value = playersInArea[i].id})
					end
				end

				TriggerEvent('chud:menu', inviteElements, 'Convidar', function(value2)
					TriggerServerEvent('cframework:invitePlayer', value2, currentPropertyId)
					ESX.ShowNotification("Jogador convidado!", "success")
					openArmarioCasa()
				end)
			end, outside, 10.0)
		end

		if value == "casa_inventory" then
        	TriggerEvent("cframework:openCasaInventory", "casa")
		end

		if value == "remove_access" then
			local elements2 = {}

			table.insert(elements2, {label = "✔️ Confirmar", value = "confirm"})
			table.insert(elements2, {label = "❌ Cancelar",  value = 'cancel'})

        	TriggerEvent('chud:menu', elements2, 'Mudar chaves', function(value)
				if value == 'confirm' then
					TriggerServerEvent('cframework:changeKeys', currentPropertyId)
					openArmarioCasa()
				end

				if value == 'cancel' then
					openArmarioCasa()
				end
			end)
		end

        if value == "transfer_storage" then
            promptTransferStorage("casa")
        end
	end)
end

local garageCarLocations = {
    ["small"] = {
        {x = 170.91, y = -1003.65, z = -99.0, h = 180.0},
        {x = 174.71, y = -1003.65, z = -99.0, h = 180.0},
    },
    ["medium"] = {
        {x = 193.60, y = -996.82, z = -99.0, h = 214.2},
        {x = 197.56, y = -996.82, z = -99.0, h = 214.2},
        {x = 192.87, y = -1003.57, z = -99.0, h = 0.0},
        {x = 196.31, y = -1003.57, z = -99.0, h = 0.0},
        {x = 199.84, y = -1003.57, z = -99.0, h = 0.0},
        {x = 203.32, y = -1003.57, z = -99.0, h = 0.0}
    },
    ["big"] = {
        {x = 232.87, y = -983.6, z = -99.0, h = 128.60},
        {x = 232.87, y = -987.75, z = -99.0, h = 128.60},
        {x = 232.87, y = -991.9, z = -99.0, h = 128.60},
        {x = 232.87, y = -996.05, z = -99.0, h = 128.60},
        {x = 232.87, y = -1000.2, z = -99.0, h = 128.60},
        {x = 224.27, y = -983.6, z = -99.0, h = 235.31},
        {x = 224.27, y = -987.75, z = -99.0, h = 235.31},
        {x = 224.27, y = -991.9, z = -99.0, h = 235.31},
        {x = 224.27, y = -996.05, z = -99.0, h = 235.31},
        {x = 224.27, y = -1000.2, z = -99.0, h = 235.31},
    },
}

local function openArmarioGarage()
	local elements = {}

	table.insert(elements, {label = "📦 Armazém", value = "casa_inventory"})
	table.insert(elements, {label = "🧰 Crafts",  value = 'crafts'})
    table.insert(elements, {label = "🚗 Garagem",  value = 'garage'})

    if myIdentifier == currentPropertyOwner then
        table.insert(elements, {label = "🚚 Transferir Armazenamento", value = 'transfer_storage'})
	end

	TriggerEvent('chud:menu', elements, 'Armário', function(value)
		if value == "casa_inventory" then
        	TriggerEvent("cframework:openCasaInventory", "garage")
		end

        if value == "transfer_storage" then
            promptTransferStorage("garage")
        end

        if value == "garage" then
            local garagePos = RPC.execute('cframework:getVehicleGarageFreeSlot', currentPropertyId)

            if garagePos == nil then
                ESX.ShowNotification("A garagem está cheia!", "error")
                return
            end

            local spawnPoint = garageCarLocations[currentProperty.garage.interior][garagePos]

            SetCurrentGarage(spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.h, currentPropertyId)
            ListOwnedVehiclesMenu('car', T("GARAGES_CAR"), false, false, true, currentProperty.entrance)
        end
	end)
end

RegisterNetEvent('cframework:vehicleSpawned', function(netId)
	while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
		Citizen.Wait(20)
	end

    if insideProperty then
        TriggerServerEvent('cframework:setVehicleInsideProperty', netId, currentPropertyId)
    end
end)


local function openCloakroomCasa(x, y, z, h)
	local dressing = RPC.execute('cframework:getPlayerDressing')
	local elements = {}

	for i=1, #dressing, 1 do
		table.insert(elements, {
			label = dressing[i],
			value = i
		})
	end

	TriggerEvent('chud:clothing', vector3(x, y, z), h, 'cloakroom', elements, function(data)
		if data.action == 'select' then
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_casa:getPlayerOutfit', function(clothes)
					TriggerEvent('skinchanger:loadClothes', skin, clothes)
					TriggerEvent('esx_skin:setLastSkin', skin)

					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
				end, tonumber(data.value))
			end)
		end
	end)
end

local function createLowApartDoor()
    local doorHash <const> = `v_ilev_mp_low_frontdoor`

    if DoesEntityExist(lowFrontDoorEntity) then return end

    RequestModel(doorHash)

    while not HasModelLoaded(doorHash) do
        Citizen.Wait(0)
    end

    ClearAreaOfObjects(264.483, -1001.621, -98.8586, 1.0, 0)
    lowFrontDoorEntity = CreateObjectNoOffset(doorHash, 264.483, -1001.621, -98.8586, true, true, true)
    SetEntityRotation(lowFrontDoorEntity, 0.0, 0.0, 180.0, 2, true)
	NetworkSetEntityInvisibleToNetwork(lowFrontDoorEntity, true)
    FreezeEntityPosition(lowFrontDoorEntity, true)
end

local function enterLowEndApartment()
    RequestAnimDict('mp_doorbell')

    while not HasAnimDictLoaded('mp_doorbell') do
        Citizen.Wait(0)
    end

    local scriptCam = CreateCam("DEFAULT_ANIMATED_CAMERA", false)
    SetCamCoord(scriptCam, 1.0, 1.0, 1.0)

    local scene = NetworkCreateSynchronisedScene(264.483, -1001.621, -98.8586, 0.0, 0.0, 180.0, 2, false, false, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), scene, "mp_doorbell", "PLAYER_ENTER_L_PEDA", 8.0, -2.0, 6, 0, 1.5, 0)
    NetworkAddEntityToSynchronisedScene(lowFrontDoorEntity, scene, "mp_doorbell", "PLAYER_ENTER_L_DOOR", 1000.0, -1000.0, 5)

    NetworkStartSynchronisedScene(scene)

    local localId = NetworkGetLocalSceneFromNetworkId(scene)
    while localId == -1 do
        Citizen.Wait(0)
        localId = NetworkGetLocalSceneFromNetworkId(scene)
    end

    PlaySynchronizedCamAnim(scriptCam, localId, "PLAYER_ENTER_L_CAM", "mp_doorbell")
    SetCamActive(scriptCam, true)
    SetCamControlsMiniMapHeading(scriptCam, true)

    RenderScriptCams(true, false, 3000, true, false)

    while GetSynchronizedScenePhase(localId) < 1.0 do
        Citizen.Wait(0)
    end

    if DoesCamExist(scriptCam) then
        SetCamActive(scriptCam, false)
        DestroyCam(scriptCam, false)
    end
    StopRenderingScriptCamsUsingCatchUp(false, 0.0, 3)
end

local function deleteLowApartDoor()
    DeleteEntity(lowFrontDoorEntity)
end

local function exitLowEndApartment()
    RequestAnimDict('mp_doorbell')

    while not HasAnimDictLoaded('mp_doorbell') do
        Citizen.Wait(0)
    end

    local exitscene = NetworkCreateSynchronisedScene(264.483, -1001.621, -98.8586, 0.0, 0.0, 180.0, 2, false, false, 1.0, 0.0, 1.0)
    NetworkAddPedToSynchronisedScene(PlayerPedId(), exitscene, "mp_doorbell", "PLAYER_EXIT_R_PEDA", 8.0, -8.0, 6, 0, 1.5, 0)
    NetworkAddSynchronisedSceneCamera(exitscene, "mp_doorbell", "PLAYER_EXIT_R_CAM")
    NetworkAddEntityToSynchronisedScene(lowFrontDoorEntity, exitscene, "mp_doorbell", "PLAYER_EXIT_R_DOOR", 1000.0, -1000.0, 5)

    NetworkStartSynchronisedScene(exitscene)
end

local function executeExitAnimationLowend()
	exitLowEndApartment()

	Citizen.Wait(3000)
	DoScreenFadeOut(500)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	deleteLowApartDoor()

	insideProperty = false

	TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
end

local function handlePoorHouseEntry(alternateEntry)
	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	SetEntityCoords(PlayerPedId(), 266.12, -1004.06, -99.01, false, false, false, false)
	createLowApartDoor()

	DoScreenFadeIn(500)

	enterLowEndApartment()

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(265.08, -1001.26, -99.01)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair de casa')

				if IsControlJustReleased(0, 38) then
					if currentProperty.garage ~= nil then
						local elements = {
							{label = "🚪 Sair", value = 'exit'},
							{label = "🚘 Garagem", value = 'garage'},
						}
						TriggerEvent('chud:menu', elements, 'Casa', function(value)
							TriggerEvent('esx_inventoryhud:doClose')

							if value == "exit" then
								executeExitAnimationLowend()
							elseif value == "garage" then
								exitLowEndApartment()

								Citizen.Wait(3000)
								DoScreenFadeOut(500)

								while not IsScreenFadedOut() do
									Citizen.Wait(0)
								end

								deleteLowApartDoor()

								insideProperty = false
								TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, true, false)
							end
						end)
					else
						executeExitAnimationLowend()
						return
					end
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, 259.76, -1003.92, -99.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 196, 138, 255, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(259.76, -1003.92, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o guarda roupa')

				if IsControlJustReleased(0, 38) then
					openCloakroomCasa(260.12, -1003.72, -99.01, 297.33)
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, 257.42, -995.96, -99.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 56, 99, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(257.42, -995.96, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioCasa()
				end
			end

			Citizen.Wait(0)
		end
	end)

    Citizen.CreateThread(function()
        local tvHash = GetHashKey("prop_tv_03")
        local tvEntity = GetClosestObjectOfType(266.12, -1004.06, -99.01, 20.0, tvHash, false, false, false)

        while not DoesEntityExist(tvEntity) do
            tvEntity = GetClosestObjectOfType(266.12, -1004.06, -99.01, 20.0, tvHash, false, false, false)
            Citizen.Wait(100)
        end

        loadTvRenderTarget(tvHash)
        setupTvChannel()

        while insideProperty do
            SetTextRenderId(tvRenderTarget)

            SetScriptGfxDrawOrder(4);
            SetScriptGfxDrawBehindPausemenu(true)

            DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
            SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            Citizen.Wait(0)
        end
    end)
end

local function handleMediumHouseEntry(alternateEntry)
	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	SetEntityCoords(PlayerPedId(), -901.64, -444.36, 150.96, false, false, false, false)

	DoScreenFadeIn(500)

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(-901.64, -444.36, 150.96)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair de casa')

				if IsControlJustReleased(0, 38) then
					if currentProperty.garage ~= nil then
						local elements = {
							{label = "🚪 Sair", value = 'exit'},
							{label = "🚘 Garagem", value = 'garage'},
						}
						TriggerEvent('chud:menu', elements, 'Casa', function(value)
							TriggerEvent('esx_inventoryhud:doClose')

							if value == "exit" then
								DoScreenFadeOut(500)

								while not IsScreenFadedOut() do
									Citizen.Wait(0)
								end

								insideProperty = false

								TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
								return
							elseif value == "garage" then
								insideProperty = false
								TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, true, false)
							end
						end)
					else
						DoScreenFadeOut(500)

						while not IsScreenFadedOut() do
							Citizen.Wait(0)
						end

						insideProperty = false

						TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
						return
					end
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -912.59, -440.82, 150.96, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 196, 138, 255, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-912.59, -440.82, 150.96)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o guarda roupa')

				if IsControlJustReleased(0, 38) then
					openCloakroomCasa(-911.88, -443.79, 150.96, 345.54)
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -909.27, -447.80, 150.96, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 56, 99, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-909.27, -447.80, 150.96)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioCasa()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

local function handleRichHouseEntry(alternateEntry)
	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	if alternateEntry then
		SetEntityCoords(PlayerPedId(), -912.42, -365.05, 114.27, false, false, false, false)
	else
		SetEntityCoords(PlayerPedId(), -915.89, -365.55, 114.27, false, false, false, false)
	end

	DoScreenFadeIn(500)

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(-915.89, -365.55, 114.27)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair de casa')

				if IsControlJustReleased(0, 38) then
					DoScreenFadeOut(500)

					while not IsScreenFadedOut() do
						Citizen.Wait(0)
					end

					insideProperty = false

					TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
					return
				end
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(-912.42, -365.05, 114.27)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para entrar na garagem')

				if IsControlJustReleased(0, 38) then
					insideProperty = false
					TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, true, false)
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -903.8, -363.71, 113.07, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 196, 138, 255, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-903.8, -363.71, 113.07)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o guarda roupa')

				if IsControlJustReleased(0, 38) then
					openCloakroomCasa(-902.76, -364.62, 113.07, 181.04)
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -927.57, -377.48, 113.67, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 56, 99, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-927.57, -377.48, 113.67)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioCasa()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

local function handleMidRichHouseEntry(alternateEntry)
	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	SetEntityCoords(PlayerPedId(), -454.95, 6186.76, 21.55, false, false, false, false)

	DoScreenFadeIn(500)

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(-454.95, 6186.76, 21.55)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair de casa')

				if IsControlJustReleased(0, 38) then
					if currentProperty.garage ~= nil then
						local elements = {
							{label = "🚪 Sair", value = 'exit'},
							{label = "🚘 Garagem", value = 'garage'},
						}
						TriggerEvent('chud:menu', elements, 'Casa', function(value)
							TriggerEvent('esx_inventoryhud:doClose')

							if value == "exit" then
								DoScreenFadeOut(500)

								while not IsScreenFadedOut() do
									Citizen.Wait(0)
								end

								insideProperty = false

								TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
								return
							elseif value == "garage" then
								insideProperty = false
								TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, true, false)
							end
						end)
					else
						DoScreenFadeOut(500)

						while not IsScreenFadedOut() do
							Citizen.Wait(0)
						end

						insideProperty = false

						TriggerServerEvent("cframework:exitProperty", currentPropertyId, false, false)
						return
					end
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -450.84, 6204.83, 21.55, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 196, 138, 255, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-450.84, 6204.83, 21.55)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o guarda roupa')

				if IsControlJustReleased(0, 38) then
					openCloakroomCasa(-450.74, 6204.72, 21.55, 210.78)
				end
			end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, -456.38, 6203.14, 21.55, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 56, 99, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(-456.38, 6203.14, 21.55)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioCasa()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

local function handleSmallGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	DoScreenFadeOut(800)

	TriggerEvent("cframework:disableAntiLimbo")

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	if alternateEntry then
		SetEntityCoords(PlayerPedId(), 178.98, -1000.53, -99.0, false, false, false, false)
	else
		if withVehicle then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)

			if garagePos == 1 then
				SetEntityCoords(vehicle, 170.91, -1003.65, -99.0, false, false, false, false)
			elseif garagePos == 2 then
				SetEntityCoords(vehicle, 174.71, -1003.65, -99.0, false, false, false, false)
			end
			SetEntityHeading(vehicle, 180.0)
		else
			SetEntityCoords(PlayerPedId(), 172.77, -1007.74, -99.0, false, false, false, false)
		end
	end

	DoScreenFadeIn(500)

	while not IsScreenFadedIn() do
		Citizen.Wait(0)
	end

	if withVehicle then
		Citizen.Wait(1000)
	end

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(172.77, -1007.74, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair da garagem')

				if IsControlJustReleased(0, 38) then
					DoScreenFadeOut(500)

					while not IsScreenFadedOut() do
						Citizen.Wait(0)
					end

					insideProperty = false

					TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, false)
					return
				end
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(178.98, -1000.53, -99.0)) < 1.0 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para entrar na casa')

				if IsControlJustReleased(0, 38) then
					insideProperty = false

					TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, false, false)
					return
				end
			end

			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) >= 1.0 and (IsControlPressed(0, 71) or IsControlPressed(0, 72))  then
				DoScreenFadeOut(500)

				while not IsScreenFadedOut() do
					Citizen.Wait(0)
				end

				insideProperty = false

				TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, true)
				return
			end

            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para guardar o veículo')

                if IsControlJustReleased(0, 38) then
					TriggerServerEvent("cframework:removeVehicleFromProperty", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false)), currentPropertyId)
					StoreOwnedVehicle(currentPropertyId)
				end
            end


			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, 177.39, -1000.25, -99.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 171, 193, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(177.39, -1000.25, -99.0)) < 1.0 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioGarage()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

local function handleMediumGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	DoScreenFadeOut(800)

	TriggerEvent("cframework:disableAntiLimbo")

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	if alternateEntry then
		SetEntityCoords(PlayerPedId(), 206.94, -999.06, -99.0, false, false, false, false)
	else
		if withVehicle then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)

			if garagePos == 1 then
				SetEntityCoords(vehicle, 193.60, -996.82, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 214.2)
			elseif garagePos == 2 then
				SetEntityCoords(vehicle, 197.56, -996.82, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 214.2)
			elseif garagePos == 3 then
				SetEntityCoords(vehicle, 192.87, -1003.57, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 0.0)
			elseif garagePos == 4 then
				SetEntityCoords(vehicle, 196.31, -1003.57, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 0.0)
			elseif garagePos == 5 then
				SetEntityCoords(vehicle, 199.84, -1003.57, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 0.0)
			elseif garagePos == 6 then
				SetEntityCoords(vehicle, 203.32, -1003.57, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 0.0)
			end
		else
			SetEntityCoords(PlayerPedId(), 194.55, -1006.74, -99.0, false, false, false, false)
		end
	end

	DoScreenFadeIn(500)

	while not IsScreenFadedIn() do
		Citizen.Wait(0)
	end

	if withVehicle then
		Citizen.Wait(1000)
	end

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(194.55, -1006.74, -99.0)) < 1.5 or #(GetEntityCoords(PlayerPedId()) - vector3(202.02, -1007.56, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair da garagem')

				if IsControlJustReleased(0, 38) then
					DoScreenFadeOut(500)

					while not IsScreenFadedOut() do
						Citizen.Wait(0)
					end

					insideProperty = false

					TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, false)
					return
				end
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(206.94, -999.06, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para entrar na casa')

				if IsControlJustReleased(0, 38) then
					insideProperty = false

					TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, false, false)
					return
				end
			end

			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) >= 1.0 and (IsControlPressed(0, 71) or IsControlPressed(0, 72))  then
				DoScreenFadeOut(500)

				while not IsScreenFadedOut() do
					Citizen.Wait(0)
				end

				insideProperty = false

				TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, true)
				return
			end

            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para guardar o veículo')

                if IsControlJustReleased(0, 38) then
					TriggerServerEvent("cframework:removeVehicleFromProperty", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false)), currentPropertyId)
					StoreOwnedVehicle(currentPropertyId)
				end
            end


			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, 200.61, -994.46, -99.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 171, 193, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(200.61, -994.46, -99.0)) < 1.0 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioGarage()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

local function handleBigGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	DoScreenFadeOut(800)

	TriggerEvent("cframework:disableAntiLimbo")

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	if alternateEntry then
		SetEntityCoords(PlayerPedId(), 240.41, -1004.87, -99.0, false, false, false, false)
	else
		if withVehicle then
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)

            if garagePos == 1 then
                SetEntityCoords(vehicle, 232.87, -983.6, -99.0, false, false, false, false)
                SetEntityHeading(vehicle, 128.60)
            elseif garagePos == 2 then
                SetEntityCoords(vehicle, 232.87, -987.75, -99.0, false, false, false, false)
                SetEntityHeading(vehicle, 128.60)
            elseif garagePos == 3 then
                SetEntityCoords(vehicle, 232.87, -991.9, -99.0, false, false, false, false)
                SetEntityHeading(vehicle, 128.60)
            elseif garagePos == 4 then
                SetEntityCoords(vehicle, 232.87, -996.05, -99.0, false, false, false, false)
                SetEntityHeading(vehicle, 128.60)
            elseif garagePos == 5 then
                SetEntityCoords(vehicle, 232.87, -1000.2, -99.0, false, false, false, false)
                SetEntityHeading(vehicle, 128.60)
			elseif garagePos == 6 then
				SetEntityCoords(vehicle, 224.27, -983.6, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 235.31)
			elseif garagePos == 7 then
				SetEntityCoords(vehicle, 224.27, -987.75, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 235.31)
			elseif garagePos == 8 then
				SetEntityCoords(vehicle, 224.27, -991.9, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 235.31)
			elseif garagePos == 9 then
				SetEntityCoords(vehicle, 224.27, -996.05, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 235.31)
			elseif garagePos == 10 then
				SetEntityCoords(vehicle, 224.27, -1000.2, -99.0, false, false, false, false)
				SetEntityHeading(vehicle, 235.31)
			end
		else
			SetEntityCoords(PlayerPedId(), 231.81, -1005.55, -99.0, false, false, false, false)
		end

	end

	DoScreenFadeIn(500)

	while not IsScreenFadedIn() do
		Citizen.Wait(0)
	end

	if withVehicle then
		Citizen.Wait(1000)
	end

	Citizen.CreateThread(function()
		while insideProperty do
			if #(GetEntityCoords(PlayerPedId()) - vector3(231.81, -1005.55, -99.0)) < 1.5 or #(GetEntityCoords(PlayerPedId()) - vector3(224.51, -1005.55, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para sair da garagem')

				if IsControlJustReleased(0, 38) then
					DoScreenFadeOut(500)

					while not IsScreenFadedOut() do
						Citizen.Wait(0)
					end

					insideProperty = false

					TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, false)
					return
				end
			end

			if #(GetEntityCoords(PlayerPedId()) - vector3(240.41, -1004.87, -99.0)) < 1.5 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para entrar na casa')

				if IsControlJustReleased(0, 38) then
					insideProperty = false

					TriggerServerEvent("cframework:enterProperty", currentPropertyId, true, false, false)
					return
				end
			end

			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 and GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) >= 1.0 and (IsControlPressed(0, 71) or IsControlPressed(0, 72)) then
				DoScreenFadeOut(500)

				while not IsScreenFadedOut() do
					Citizen.Wait(0)
				end

				insideProperty = false

				TriggerServerEvent("cframework:exitProperty", currentPropertyId, true, true)
				return
			end

            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para guardar o veículo')

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("cframework:removeVehicleFromProperty", NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(PlayerPedId(), false)), currentPropertyId)
					StoreOwnedVehicle(currentPropertyId)
				end
            end

			---@diagnostic disable-next-line: missing-parameter
			DrawMarker(2, 234.96, -977.48, -99.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 171, 193, 255, false, false, 0, true)

			if #(GetEntityCoords(PlayerPedId()) - vector3(234.96, -977.48, -99.0)) < 1.0 then
				ESX.ShowHelpNotification('Pressiona ~INPUT_CONTEXT~ para abrir o armário')

				if IsControlJustReleased(0, 38) then
					openArmarioGarage()
				end
			end

			Citizen.Wait(0)
		end
	end)
end

RegisterNetEvent('cframework:receiveInvite', function(houseId)
	ESX.ShowNotification("Recebeste um convite para entrar na casa", "inform")

	for _,id in ipairs(sharedHouses) do
		if houseId == id then return end
	end

	exports.ft_libs:EnableMarker(houseId)
	exports.ft_libs:EnableTrigger(houseId)
end)

RegisterNetEvent('cframework:inviteExpired', function(houseId)
	for _,id in ipairs(sharedHouses) do
		if houseId == id then return end
	end

	exports.ft_libs:DisableMarker(houseId)
	exports.ft_libs:DisableTrigger(houseId)
end)

RegisterNetEvent("cframework:outHouse", function(isGarage, withVehicle, seatIndex)
	TriggerServerEvent('cframework:deleteLastProperty')

	insideProperty = false

	DoScreenFadeOut(800)

	while not IsScreenFadedOut() do
		Citizen.Wait(0)
	end

	local coords = isGarage and currentProperty.garage.entrance or currentProperty.entrance

	if withVehicle then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)

		SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.2, false, false, false, false)
		SetEntityHeading(vehicle, coords.w)
	else
		SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 0.2, false, false, false, false)
	end

	Citizen.Wait(1750)

	if withVehicle then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

		TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)

		SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.2, false, false, false, false)
		SetEntityHeading(vehicle, coords.w)
	else
		SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 0.2, false, false, false, false)
	end

	DoScreenFadeIn(800)

	TriggerEvent("cframework:enableAntiLimbo")
end)

RegisterNetEvent("cframework:inHouse", function(houseId, houseOwner, alternateEntry, isGarage, withVehicle, garagePos, seatIndex)
	local house = Config.properties[houseId]
	insideProperty = true

	currentProperty = house
	currentPropertyId = houseId
	currentPropertyOwner = houseOwner

	TriggerEvent('cframework:closePhone')
	TriggerEvent('cframework:stopPegar')
	TriggerEvent('cframework:disableVehiclePush')

	if isGarage then
		TriggerServerEvent('cframework:saveLastProperty', {x = house.garage.entrance.x, y = house.garage.entrance.y, z = house.garage.entrance.z,})
	else
		TriggerServerEvent('cframework:saveLastProperty', {x = house.entrance.x, y = house.entrance.y, z = house.entrance.z,})
	end

	if not isGarage and house.interior == "pobre" then
		handlePoorHouseEntry(alternateEntry)
	elseif not isGarage and house.interior == "mediorico" then
		handleMediumHouseEntry(alternateEntry)
	elseif not isGarage and house.interior == "rico" then
		handleRichHouseEntry(alternateEntry)
	elseif not isGarage and house.interior == "medio" then
		handleMidRichHouseEntry(alternateEntry)
	elseif isGarage and house.garage.interior == "small" then
		handleSmallGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	elseif isGarage and house.garage.interior == "medium" then
		handleMediumGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	elseif isGarage and house.garage.interior == "big" then
		handleBigGarageEntry(alternateEntry, withVehicle, garagePos, seatIndex)
	end

	--Disable animations, prevent bugs
	Citizen.CreateThread(function()
		--Disable stuff
		TriggerEvent('cframework:disablePegar')
		TriggerEvent('cframework:disableRagdoll')
		while insideProperty do
			DisableControlAction(0,22,true) --Jump
			--DisableControlAction(0,21,true) --Sprint
			Citizen.Wait(0)
		end
		--Enable stuff
		TriggerEvent('cframework:enableRagdoll')
		TriggerEvent('cframework:enablePegar')
		TriggerEvent('cframework:enableVehiclePush')
	end)

	--[[Citizen.CreateThread(function()
		while insideProperty do
			if #(vector3(-901.64, -444.36, 150.96) - GetEntityCoords(PlayerPedId())) > 50.0 then
				SetEntityCoords(PlayerPedId(), -901.64, -444.36, 150.96, false, false, false, false)
			end

			Citizen.Wait(0)
		end
	end)]]
end)


Citizen.CreateThread(function()
    for k, house in pairs(Config.properties) do
		exports.ft_libs:AddMarker(k, {type = 50, x = house.entrance.x, y = house.entrance.y, z = house.entrance.z,
			red = 120, green = 190, blue = 255, showDistance = 25})

		exports.ft_libs:AddTrigger(k, {x = house.entrance.x, y = house.entrance.y, z = house.entrance.z, weight = 1.7, height = 2,
			enter = {eventClient = "cframework:hasEnteredPropertyMarker"}, exit = {eventClient = "cframework:hasExitedPropertyMarker"}, data = {k, 'house_entrance'},
			active = {}})

		if house.garage ~= nil then
			exports.ft_libs:AddMarker(k.."garage", {type = 50, x = house.garage.entrance.x, y = house.garage.entrance.y, z = house.garage.entrance.z,
			red = 255, green = 210, blue = 143, showDistance = 25})

			exports.ft_libs:AddTrigger(k.."garage", {x = house.garage.entrance.x, y = house.garage.entrance.y, z = house.garage.entrance.z, weight = 2.7, height = 2,
				enter = {eventClient = "cframework:hasEnteredPropertyMarker"}, exit = {eventClient = "cframework:hasExitedPropertyMarker"}, data = {k, 'house_garage'},
				active = {}})

			exports.ft_libs:DisableMarker(k.."garage")
			exports.ft_libs:DisableTrigger(k.."garage")
		end

		exports.ft_libs:DisableMarker(k)
		exports.ft_libs:DisableTrigger(k)
    end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	myIdentifier = xPlayer.identifier
end)

RegisterNetEvent("cframework:houseForSale", function(houseId)
	local house, message = Config.properties[houseId], ""

	if house.garage ~= nil then
		message = "Casa para venda com garagem por " .. formatNumberWithSpaces(house.price) .. "€"
	else
		message = "Casa para venda por " .. formatNumberWithSpaces(house.price) .. "€"
	end

    if house.coins then
        message = message .. " ou " .. formatNumberWithSpaces(house.coins) .. " Coins"
    end

	ESX.ShowNotification(message, "inform")
end)

RegisterNetEvent('cframework:sendCasa', function(propertyId, identifier)
    if identifier == nil then --Put house on sale
        if propertyBlips[propertyId] ~= nil then
            RemoveBlip(propertyBlips[propertyId])
        end
        propertyBlips[propertyId] = nil

        propertyBlips[propertyId] = AddBlipForCoord(Config.properties[propertyId].entrance.x, Config.properties[propertyId].entrance.y, Config.properties[propertyId].entrance.z)
        SetBlipSprite (propertyBlips[propertyId], 375)
        SetBlipDisplay(propertyBlips[propertyId], 4)
        SetBlipScale  (propertyBlips[propertyId], 0.5)
        SetBlipAsShortRange(propertyBlips[propertyId], true)
        BeginTextCommandSetBlipName("HOUSEFORSALE")
        EndTextCommandSetBlipName(propertyBlips[propertyId])
        exports.ft_libs:EnableMarker(propertyId)
        exports.ft_libs:EnableTrigger(propertyId)

        if Config.properties[propertyId].garage ~= nil then
            exports.ft_libs:EnableMarker(propertyId.."garage")
            exports.ft_libs:EnableTrigger(propertyId.."garage")
        end

        return
    end

	if propertyBlips[propertyId] ~= nil then
		RemoveBlip(propertyBlips[propertyId])
	end

	propertyBlips[propertyId] = nil

	if Config.properties[propertyId].garage ~= nil then
		exports.ft_libs:DisableMarker(propertyId.."garage")
		exports.ft_libs:DisableTrigger(propertyId.."garage")
	end

	exports.ft_libs:DisableMarker(propertyId)
	exports.ft_libs:DisableTrigger(propertyId)

	if identifier == myIdentifier then
		propertyBlips[propertyId] = AddBlipForCoord(Config.properties[propertyId].entrance.x, Config.properties[propertyId].entrance.y, Config.properties[propertyId].entrance.z)

		SetBlipSprite (propertyBlips[propertyId], 374)
		SetBlipDisplay(propertyBlips[propertyId], 4)
		SetBlipScale  (propertyBlips[propertyId], 0.5)
		SetBlipAsShortRange(propertyBlips[propertyId], true)

		BeginTextCommandSetBlipName("BOUGHTHOUSE")
		EndTextCommandSetBlipName(propertyBlips[propertyId])

		exports.ft_libs:EnableMarker(propertyId)
		exports.ft_libs:EnableTrigger(propertyId)

		if Config.properties[propertyId].garage ~= nil then
			exports.ft_libs:EnableMarker(propertyId.."garage")
			exports.ft_libs:EnableTrigger(propertyId.."garage")
		end
	end
end)

RegisterNetEvent('cframework:sendCasasAndSales', function(oHouses, sHouses, forSale)
	for k,v in pairs(propertyBlips) do
		RemoveBlip(v)
	end

    for k, house in pairs(Config.properties) do
		if house.garage ~= nil then
			exports.ft_libs:DisableMarker(k.."garage")
			exports.ft_libs:DisableTrigger(k.."garage")
		end

		exports.ft_libs:DisableMarker(k)
		exports.ft_libs:DisableTrigger(k)
	end

	ownedHouses = oHouses
	sharedHouses = sHouses

	local boughtHouses = {}
	local sharedWithMe = {}

	for k,houseId in ipairs(ownedHouses) do
		exports.ft_libs:EnableMarker(houseId)
		exports.ft_libs:EnableTrigger(houseId)

		if Config.properties[houseId].garage ~= nil then
			exports.ft_libs:EnableMarker(houseId.."garage")
			exports.ft_libs:EnableTrigger(houseId.."garage")
		end

		boughtHouses[houseId] = true
	end

	for k,houseId in ipairs(sharedHouses) do
		exports.ft_libs:EnableMarker(houseId)
		exports.ft_libs:EnableTrigger(houseId)

		if Config.properties[houseId].garage ~= nil then
			exports.ft_libs:EnableMarker(houseId.."garage")
			exports.ft_libs:EnableTrigger(houseId.."garage")
		end

		sharedWithMe[houseId] = true
	end

	local housesForSale = {}

	for k,houseId in ipairs(forSale) do
		exports.ft_libs:EnableMarker(houseId)
		exports.ft_libs:EnableTrigger(houseId)

		if Config.properties[houseId].garage ~= nil then
			exports.ft_libs:EnableMarker(houseId.."garage")
			exports.ft_libs:EnableTrigger(houseId.."garage")
		end

		housesForSale[houseId] = true
	end

	AddTextEntry('SHAREDHOUSE', 'Casa Partilhada')
	AddTextEntry('BOUGHTHOUSE', 'Casa Comprada')
	AddTextEntry('HOUSEFORSALE', 'Casa para venda')

    if ESX.DEV then
        return
    end

	for k,v in pairs(Config.properties) do
		if housesForSale[k] then
			propertyBlips[k] = AddBlipForCoord(v.entrance.x, v.entrance.y, v.entrance.z)

			SetBlipSprite (propertyBlips[k], 375)
			SetBlipDisplay(propertyBlips[k], 4)
			SetBlipScale  (propertyBlips[k], 0.5)
			SetBlipAsShortRange(propertyBlips[k], true)

			BeginTextCommandSetBlipName("HOUSEFORSALE")
			EndTextCommandSetBlipName(propertyBlips[k])
		else
			if boughtHouses[k] then
				propertyBlips[k] = AddBlipForCoord(v.entrance.x, v.entrance.y, v.entrance.z)

				SetBlipSprite (propertyBlips[k], 374)
				SetBlipDisplay(propertyBlips[k], 4)
				SetBlipScale  (propertyBlips[k], 0.5)
				SetBlipAsShortRange(propertyBlips[k], true)

				BeginTextCommandSetBlipName("BOUGHTHOUSE")
				EndTextCommandSetBlipName(propertyBlips[k])
			end

			if sharedWithMe[k] then
				propertyBlips[k] = AddBlipForCoord(v.entrance.x, v.entrance.y, v.entrance.z)

				SetBlipSprite (propertyBlips[k], 374)
				SetBlipDisplay(propertyBlips[k], 4)
				SetBlipScale  (propertyBlips[k], 0.5)
				SetBlipColour(propertyBlips[k], 43)
				SetBlipAsShortRange(propertyBlips[k], true)

				BeginTextCommandSetBlipName("SHAREDHOUSE")
				EndTextCommandSetBlipName(propertyBlips[k])
			end
		end
	end
end)

RegisterNetEvent('cframework:hasEnteredPropertyMarker', function(data)
	local houseId, action = data[1], data[2]

	CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

			if ESX.isHandcuffed() then
				CurrentAction = nil
			end

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'house_entrance' then
                CurrentAction = nil
				TriggerServerEvent("cframework:enterProperty", houseId, false, false, false)
            end

			if CurrentAction == 'house_garage' then
                CurrentAction = nil
				TriggerServerEvent("cframework:enterProperty", houseId, false, true, IsPedInAnyVehicle(PlayerPedId(), false))
            end

            ::final::
        end
    end)

end)

RegisterNetEvent('cframework:hasExitedPropertyMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

RegisterNetEvent('cframework:choosePaymentOnHousePurchase', function()
    local elements = {
        {label = "💵 Dinheiro", value = "cash"},
        {label = "💰 Coins", value = "coins"}
    }

    TriggerEvent('chud:menu', elements, 'Pagamento', function(value)
        TriggerEvent('esx_inventoryhud:doClose')

        if value == 'cash' then
            TriggerServerEvent('cframework:buyHouse', "cash")
        end

        if value == 'coins' then
            TriggerServerEvent('cframework:buyHouse', "coins")
        end
    end)
end)