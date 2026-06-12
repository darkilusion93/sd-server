local shops <const> = LoadClotheShops()

local cloakRooms <const> = shops.cloakRooms
local clothesShops <const> = shops.clothesShops
local clothesPed <const> = shops.clothesPed
local barberShops <const> = shops.barberShops
local tattooShops <const> = shops.tattooShops
local maskShop <const> = shops.maskShop
local maskPed <const> = shops.maskPed
local barberPed <const> = shops.barberPed
local motoclubPed <const> = shops.motoclubPed

local CurrentAction = nil

RegisterNetEvent('clothingShopsEnterMarker', function(action)
    CurrentAction = action[1]

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

            ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_INTERACT"))
            Citizen.Wait(0)

			if ESX.isHandcuffed() then
				CurrentAction = nil
			end

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'cloakroom' then
                CurrentAction = nil
                OpenChangingMenu(cloakRooms[action[2]].camCoords, cloakRooms[action[2]].camHeading)
            end

			if CurrentAction == 'clothes' then
                CurrentAction = nil
                OpenClothesMenu(clothesShops[action[2]].camCoords, clothesShops[action[2]].camHeading)
            end

			if CurrentAction == 'barber' then --done
                CurrentAction = nil
                OpenBarberMenu(barberShops[action[2]].camCoords, barberShops[action[2]].camHeading)
            end

			if CurrentAction == 'tattoo' then --done
                CurrentAction = nil
                OpenTattooMenu()
            end

			if CurrentAction == 'mask' then --done
                CurrentAction = nil
                OpenAccessory('Mask', maskShop[action[2]].camCoords, maskShop[action[2]].camHeading)
            end

            ::final::
        end
    end)

end)

RegisterNetEvent('clothingShopsExitedMarker', function()
    CurrentAction = nil
end)


-- Enter / Exit marker events
Citizen.CreateThread(function()
    for i=1, #cloakRooms, 1 do
		exports.ft_libs:AddMarker("cloakRooms"..i, {type = 50, x = cloakRooms[i].x, y = cloakRooms[i].y, z = cloakRooms[i].z, weight = 1, height = 1, red = 245, green = 105, blue = 66, showDistance = 25})
		exports.ft_libs:AddTrigger("cloakRooms"..i, {x = cloakRooms[i].x, y = cloakRooms[i].y, z = cloakRooms[i].z, weight = 1, height = 2,
        enter = {eventClient = "clothingShopsEnterMarker"}, exit = {eventClient = "clothingShopsExitedMarker"}, data = {'cloakroom', i}, active = {}})
    end

	AddTextEntry('CLOTHESHOP', T("CLOTHING_SHOP"))
	AddTextEntry('BARBERSHOP', T("BARBER_SHOP"))
	AddTextEntry('TATTOOSHOP', T("TATTOO_SHOP"))
	AddTextEntry('MASKSHOP', T("MASK_SHOP"))

    for i=1, #clothesShops, 1 do
		exports.ft_libs:AddMarker("clothesShops"..i, {type = 50, x = clothesShops[i].x, y = clothesShops[i].y, z = clothesShops[i].z, weight = 1, height = 1, red = 3, green = 255, blue = 255, showDistance = 25})
        exports.ft_libs:AddTrigger("clothesShops"..i, {x = clothesShops[i].x, y = clothesShops[i].y, z = clothesShops[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "clothingShopsEnterMarker"}, exit = {eventClient = "clothingShopsExitedMarker"}, data = {'clothes', i}, active = {}})

		local blip = AddBlipForCoord(clothesShops[i].x, clothesShops[i].y, clothesShops[i].z)

		SetBlipSprite(blip, 73)  -- Loja de roupa blip 
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 30)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("CLOTHESHOP")
		EndTextCommandSetBlipName(blip)
    end
	for i = 1, #clothesPed, 1 do
		exports.ft_libs:AddPed("clothes_selling" .. i, {model = `a_m_m_business_01`, x = clothesPed[i].x, y = clothesPed[i].y, z = clothesPed[i].z, w = clothesPed[i].w})
	end

	for i = 1, #motoclubPed, 1 do
		exports.ft_libs:AddPed("barber_selling" .. i, {model = `ig_clay`, x = motoclubPed[i].x, y = motoclubPed[i].y, z = motoclubPed[i].z, w = motoclubPed[i].w})
	end

    for i=1, #barberShops, 1 do
        exports.ft_libs:AddMarker("barberShops"..i, {type = 50, x = barberShops[i].x, y = barberShops[i].y, z = barberShops[i].z, weight = 1, height = 1, red = 255, green = 154, blue = 3, showDistance = 25})
        exports.ft_libs:AddTrigger("barberShops"..i, {x = barberShops[i].x, y = barberShops[i].y, z = barberShops[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "clothingShopsEnterMarker"}, exit = {eventClient = "clothingShopsExitedMarker"}, data = {'barber', i}, active = {}})

        local blip = AddBlipForCoord(barberShops[i].x, barberShops[i].y, barberShops[i].z)

        SetBlipSprite(blip, 71)
        SetBlipDisplay(blip, 4)
        SetBlipColour(blip, 5)
        SetBlipScale(blip, 0.5)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('BARBERSHOP')
        EndTextCommandSetBlipName(blip)
    end

    for i = 1, #barberPed, 1 do
        exports.ft_libs:AddPed("barber_selling" .. i, {model = `ig_drfriedlander`, x = barberPed[i].x, y = barberPed[i].y, z = barberPed[i].z, w = barberPed[i].w})
    end

    for i=1, #tattooShops, 1 do
		exports.ft_libs:AddMarker("tattooShops"..i, {type = 50, x = tattooShops[i].x, y = tattooShops[i].y, z = tattooShops[i].z, weight = 1, height = 1, red = 255, green = 0, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("tattooShops"..i, {x = tattooShops[i].x, y = tattooShops[i].y, z = tattooShops[i].z, weight = 2.5, height = 2,
        enter = {eventClient = "clothingShopsEnterMarker"}, exit = {eventClient = "clothingShopsExitedMarker"}, data = {'tattoo', i}, active = {}})

		local blip = AddBlipForCoord(tattooShops[i].x, tattooShops[i].y, tattooShops[i].z)
		SetBlipSprite(blip, 75)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.5)
		SetBlipColour(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('TATTOOSHOP')
		EndTextCommandSetBlipName(blip)
    end

    for i=1, #maskShop, 1 do
		exports.ft_libs:AddMarker("maskShop"..i, {type = 50, x = maskShop[i].x, y = maskShop[i].y, z = maskShop[i].z, weight = 1, height = 1, red = 3, green = 255, blue = 82, showDistance = 25})
        exports.ft_libs:AddTrigger("maskShop" .. i, {x = maskShop[i].x, y = maskShop[i].y, z = maskShop[i].z, weight = 2, height = 2,
        enter = {eventClient = "clothingShopsEnterMarker"}, exit = {eventClient = "clothingShopsExitedMarker"}, data = {'mask', i}, active = {}})

		local blip = AddBlipForCoord(maskShop[i].x, maskShop[i].y, maskShop[i].z)

		SetBlipSprite(blip, 362)
		SetBlipDisplay(blip, 4)
		SetBlipScale (blip, 0.5)
		SetBlipColour(blip, 2)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("MASKSHOP")
		EndTextCommandSetBlipName(blip)
    end

	for i = 1, #maskPed, 1 do
		exports.ft_libs:AddPed("mask_selling" .. i, {model = `u_m_y_pogo_01`, x = maskPed[i].x, y = maskPed[i].y, z = maskPed[i].z, w = maskPed[i].w})
	end
end)

function OpenAccessory(accessory, coords, heading)
	local _accessory = string.lower(accessory)
	local restrict = {}

	restrict = { _accessory .. '_1', _accessory .. '_2' }

	TriggerEvent('chud:clothingShop', coords, heading, _accessory, restrict, function(success)
        if success then
            ESX.TriggerServerCallback('esx_accessories:checkMoney', function(hasEnoughMoney)
                if hasEnoughMoney then
                    TriggerServerEvent('esx_accessories:pay')
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_accessories:save', skin, accessory)
                    end)
                else
                    TriggerEvent('esx_skin:getLastSkin', function(skin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                    end)
                    ESX.ShowNotification(T("GENERIC_NOT_ENOUGH_MONEY"), "error")
                end
            end)
        else
            TriggerEvent('esx_skin:getLastSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
    end)
end

function OpenBarberMenu(coords, heading)
	local restrict = {
		'beard_1',
		'beard_2',
		'beard_3',
		'beard_4',
		'hair_1',
		'hair_2',
		'hair_color_1',
		'hair_color_2',
		'eyebrows_1',
		'eyebrows_2',
		'eyebrows_3',
		'eyebrows_4',
		'makeup_1',
		'makeup_2',
		'makeup_3',
		'makeup_4',
		'lipstick_1',
		'lipstick_2',
		'lipstick_3',
		'lipstick_4',
		'ears_1',
		'ears_2',
		'blush_1',
		'blush_2',
		'blush_3',
		'chest_1',
		'chest_2',
		'chest_3'
	}

	TriggerEvent('chud:clothingShop', coords, heading, 'barber', restrict, function(success)
        if success then
			ESX.TriggerServerCallback('esx_barbershop:checkMoney', function(hasEnoughMoney)
				if hasEnoughMoney then
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)

					TriggerServerEvent('esx_barbershop:pay')
				else
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)

					ESX.ShowNotification(T("GENERIC_NOT_ENOUGH_MONEY"), "error")
				end
			end)
        else
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
        end
    end)
end

function OpenChangingMenu(coords, heading)
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}

		for i=1, #dressing, 1 do
			table.insert(elements, {
				label = dressing[i],
				value = i
			})
		end

        TriggerEvent('chud:clothing', coords, heading, 'cloakroom', elements, function(data)
			if data.action == 'select' then
				TriggerEvent('skinchanger:getSkin', function(skin)
					ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
						TriggerEvent('skinchanger:loadClothes', skin, clothes)
						TriggerEvent('esx_skin:setLastSkin', skin)

						TriggerEvent('skinchanger:getSkin', function(skin)
							TriggerServerEvent('esx_skin:save', skin)
						end)
					end, tonumber(data.value))
				end)
			elseif data.action == 'delete' then
				TriggerServerEvent('esx_property:removeOutfit', tonumber(data.value))
			end
        end)
	end)
end

function StoreClothesCloakroom()
	local elements = {
		{label = ("✔️ %s"):format(T("CLOAKROOM_STORE_OUTFIT")), value = "confirm"},
		{label = ("❌ %s"):format(T("GENERIC_CANCEL")),  value = 'cancel'}
	}

	TriggerEvent('chud:menu', elements, T("CLOAKROOM_STORE_OUTFIT"), function(value)
		if value == 'confirm' then
			TriggerEvent('chud:textmenu', T("CLOAKROOM_OUTFIT_NAME"), T("CLOAKROOM_STORE_OUTFIT"), function(value)
				TriggerEvent('esx_inventoryhud:doClose')

				if value ~= "" then
					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_clotheshop:saveOutfit', value, skin)
					end)

					ESX.ShowNotification(T("CLOAKROOM_OUTFIT_SAVED"), 'success')
				end
			end)
		end

		if value == 'cancel' then
			TriggerEvent('esx_inventoryhud:doClose')
		end
	end)
end

function OpenClothesMenu(coords, heading)
	local elements = {
		{label = ("👕 %s"):format(T("CLOTHING_CLOTHES")), value = 'Clothes'},
		{label = ("⛑️ %s"):format(T("CLOTHING_HELMET")), value = 'Helmet'},
		{label = ("👂 %s"):format(T("CLOTHING_EAR")), value = 'Ears'},
		{label = ("👓 %s"):format(T("CLOTHING_GLASSES")), value = 'Glasses'}
	}

	TriggerEvent('chud:menu', elements, 'Loja de Roupa', function(value)
		TriggerEvent('esx_inventoryhud:doClose')

		if value == 'Clothes' then
			local restrict = {
				'tshirt_1',
				'tshirt_2',
				'torso_1',
				'torso_2',
				'decals_1',
				'decals_2',
				'arms',
				'arms_2',
				'pants_1',
				'pants_2',
				'shoes_1',
				'shoes_2',
				'chain_1',
				'chain_2',
				'bracelets_1',
				'bracelets_2',
				'bags_1',
				'bags_2',
				'bproof_1',
				'bproof_2',
				'watches_1',
				'watches_2',
			}

			TriggerEvent('chud:clothingShop', coords, heading, 'shop', restrict, function(success)
				if success then
					ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
						if bought then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)

							HasPaid = true

							ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
								if foundStore then
									StoreClothesCloakroom()
								end
							end)

						else
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(T("GENERIC_NOT_ENOUGH_MONEY"), 'error')
						end
					end)
				else
					ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)
				end
			end)
		end

		if value == 'Helmet' then
			OpenAccessory('Helmet', coords, heading)
		end

		if value == 'Ears' then
			OpenAccessory('Ears', coords, heading)
		end

		if value == 'Glasses' then
			OpenAccessory('Glasses', coords, heading)
		end
	end)
end

local currentTattoos = {}
local cam = 0

AddEventHandler('skinchanger:modelLoaded', function()
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)

AddEventHandler('cframework:loadTattoos', function()
	ESX.TriggerServerCallback('esx_tattooshop:requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooList[v.collection][v.texture].nameHash))
			end

			currentTattoos = tattooList
		end
	end)
end)

local function setPedSkin()
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	Citizen.Wait(1000)

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooList[v.collection][v.texture].nameHash))
	end
end

local function drawTattoo(current, collection)
	SetEntityHeading(PlayerPedId(), 297.7296)
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooList[v.collection][v.texture].nameHash))
	end

	TriggerEvent('skinchanger:getSkin', function(skin)
		if skin.sex == 0 then
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 0,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 15,
				torso_2  = 0,
				pants_1  = 14,
				pants_2  = 0
			})
		else
			TriggerEvent('skinchanger:loadSkin', {
				sex      = 1,
				tshirt_1 = 15,
				tshirt_2 = 0,
				arms     = 15,
				torso_1  = 15,
				torso_2  = 0,
				pants_1  = 21,
				pants_2  = 0
			})
		end
	end)

	ApplyPedOverlay(PlayerPedId(), GetHashKey(collection), GetHashKey(TattooList[collection][current].nameHash))

    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

	if not DoesCamExist(cam) then
		cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamCoord(cam, x, y, z)
		SetCamRot(cam, 0.0, 0.0, 0.0, 0)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 0, true, true)
		SetCamCoord(cam, x, y, z)
	end

	SetCamCoord(cam, x + TattooList[collection][current].addedX, y + TattooList[collection][current].addedY, z + TattooList[collection][current].addedZ)
	SetCamRot(cam, 0.0, 0.0, TattooList[collection][current].rotZ, 0)
end

local function cleanPlayer()
	ClearPedDecorations(PlayerPedId())

	for k,v in pairs(currentTattoos) do
		ApplyPedOverlay(PlayerPedId(), GetHashKey(v.collection), GetHashKey(TattooList[v.collection][v.texture].nameHash))
	end
end

function OpenTattooMenu()
	local elements = {}

	for k,v in pairs(TattooCategories) do
		table.insert(elements, {label= v.name, value = v.value})
	end

	if DoesCamExist(cam) then
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(cam, false)
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop', {
		title    = T("TATTOOS"),
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		local currentLabel, currentValue = data.current.label, data.current.value

		if data.current.value then
			elements = {{label = T("GENERIC_GO_BACK"), value = nil}}

			for k,v in pairs(TattooList[data.current.value]) do
				table.insert(elements, {
					label = (T("TATTOO_ITEM")):format(k, v.price),
					value = k,
					price = v.price
				})
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'tattoo_shop_categories', {
				title    =  ("%s | %s"):format(T("TATTOOS"), currentLabel),
				align    = 'bottom-right',
				elements = elements
			}, function(data2, menu2)
				local price = data2.current.price
				if data2.current.value ~= nil then

					ESX.TriggerServerCallback('esx_tattooshop:purchaseTattoo', function(success)
						if success then
							table.insert(currentTattoos, {collection = currentValue, texture = data2.current.value})
						end
					end, currentTattoos, price, {collection = currentValue, texture = data2.current.value})

				else
					OpenTattooMenu()
					RenderScriptCams(false, false, 0, true, false)
					DestroyCam(cam, false)
					cleanPlayer()
				end

			end, function(data2, menu2)
				menu2.close()
				RenderScriptCams(false, false, 0, true, false)
				DestroyCam(cam, false)
				setPedSkin()
			end, function(data2, menu2) -- when highlighted
				if data2.current.value ~= nil then
					drawTattoo(data2.current.value, currentValue)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
		setPedSkin()
	end)
end

