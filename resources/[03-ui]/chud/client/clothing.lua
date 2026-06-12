
local headCam = nil
local fullBodyCam = nil
local bodyCam = nil
local pantsCam = nil
local shoesCam = nil
local currentCam = nil
local isSpinning = false
local call = nil
local shopCall = nil
local inClothingMenu = false

function IsPlayerInClothingMenu()
    return inClothingMenu
end

local function createBodyCam(distanceOffset, leftOffset, heightOffset, pointOffset, fov)
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local playerPed = PlayerPedId()

    local entityForwardVector = GetEntityForwardVector(playerPed)
    local entityForwardVector90 = vector3(entityForwardVector.y, entityForwardVector.x * -1.0, entityForwardVector.z)
    local head = GetPedBoneCoords(playerPed, GetEntityBoneIndexByName(playerPed, 'SKEL_HEAD'), 0.0, 0.0, 0.0)

    local finalCoords = GetEntityCoords(playerPed) + entityForwardVector * distanceOffset
    local headWithRot = head + entityForwardVector90 * leftOffset

    SetCamCoord(cam, finalCoords.x, finalCoords.y, finalCoords.z + heightOffset)
    PointCamAtCoord(cam, headWithRot.x, headWithRot.y, headWithRot.z + pointOffset)
    SetCamDofFocalLengthMultiplier(cam, 100.0)
    SetCamFov(cam, fov)

    return cam
end


AddEventHandler('chud:clothing', function(coords, heading, menuType, elements, callback)
    if inClothingMenu then return end

    inClothingMenu = true

    --TriggerEvent('cframework:disableEmotes')
    --TriggerEvent('cframework:disableVehiclePush')

    DoScreenFadeOut(500)

    call = callback

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    FreezeEntityPosition(PlayerPedId(), true)

    Citizen.CreateThread(function()
        while inClothingMenu do
            local playerPed = PlayerPedId()

            for _, player in ipairs(GetActivePlayers()) do
                local otherPlayerPed = GetPlayerPed(player)

                if playerPed ~= otherPlayerPed then
                    SetEntityLocallyInvisible(otherPlayerPed)
                    SetEntityVisible(otherPlayerPed, false, false)
                    SetEntityNoCollisionEntity(playerPed, otherPlayerPed, true)
                end
            end

            DisableControlAction(2, 37, true)

            DisableControlAction(2, 157, true)
            DisableControlAction(2, 158, true)
            DisableControlAction(2, 160, true)
            DisableControlAction(2, 164, true)
            DisableControlAction(2, 165, true)
            DisableControlAction(2, 159, true)
            DisableControlAction(2, 161, true)
            DisableControlAction(2, 162, true)
            DisableControlAction(2, 163, true)

            HudWeaponWheelIgnoreSelection()

            Citizen.Wait(0)
        end

        Citizen.Wait(500)

        SetEntityVisible(PlayerPedId(), true, false)
        FreezeEntityPosition(PlayerPedId(), false)
    end)

    Citizen.Wait(100)

    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z-1.0, false, false, false, true)
    SetEntityHeading(PlayerPedId(), heading)

    Citizen.Wait(100)

    SendNUIMessage(
        {
            action = "setType",
            type = "clothing"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
            type = menuType
        }
    )

    headCam = createBodyCam(2.0, -0.22, 0.75, 0.6, 20.0)
    bodyCam = createBodyCam(2.4, -0.50, 0.65, 0.2, 30.0)
    pantsCam = createBodyCam(2.4, -0.50, 0.45, -0.5, 30.0)
    shoesCam = createBodyCam(2.4, -0.45, 0.45, -0.8, 25.0)
    fullBodyCam = createBodyCam(3.5, -0.72, 0.45, 0.0, 35.0)

    if menuType == 'cloakroom' then
        currentCam = fullBodyCam
    elseif menuType == 'mask' then
        currentCam = headCam
    elseif menuType == 'helmet' then
        currentCam = headCam
    elseif menuType == 'ears' then
        currentCam = headCam
    elseif menuType == 'glasses' then
        currentCam = headCam
    elseif menuType == 'barber' then
        currentCam = headCam
    else
        currentCam = fullBodyCam
    end

    SetCamActive(currentCam, true)
    RenderScriptCams(true, true, 0, true, true)

    DoScreenFadeIn(250)

    SendNUIMessage(
        {
            action = "display",
            type = "clothing"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerEvent('inventoryOpened')

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end
end)

RegisterNUICallback("clothingHandsup", function(data, cb)
    TriggerEvent('cframework:handsUp')
end)

RegisterNUICallback("startSpin", function(data, cb)
    -- data.direction
    if isSpinning then return end

    isSpinning = true

    local direction = -0.5

    if data.direction == 'right' then
        direction = 0.5
    end

    local heading = GetEntityHeading(PlayerPedId())

    while isSpinning do
        Citizen.Wait(0)
        heading = heading + direction
        SetEntityHeading(PlayerPedId(), heading)
    end
end)

RegisterNUICallback("stopSpin", function(data, cb)
    isSpinning = false
end)

RegisterNUICallback("closeClothing", function(data, cb)
    DoScreenFadeOut(500)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    SetCamActive(currentCam, false)
    RenderScriptCams(false, true, 0, true, true)

    if DoesCamExist(headCam) then
        DestroyCam(headCam, false)
        headCam = nil
    end

    if DoesCamExist(fullBodyCam) then
        DestroyCam(fullBodyCam, false)
        fullBodyCam = nil
    end

    if DoesCamExist(bodyCam) then
        DestroyCam(bodyCam, false)
        bodyCam = nil
    end

    if DoesCamExist(pantsCam) then
        DestroyCam(pantsCam, false)
        pantsCam = nil
    end

    if DoesCamExist(shoesCam) then
        DestroyCam(shoesCam, false)
        shoesCam = nil
    end

    if DoesCamExist(currentCam) then
        DestroyCam(currentCam, false)
        currentCam = nil
    end

    if shopCall ~= nil then
        shopCall(data.success)
    end

    SetNuiFocus(false, false)

    TriggerEvent('inventoryClosed')
    shopCall = nil

    DoScreenFadeIn(250)

    while not IsScreenFadedIn() do
        Citizen.Wait(0)
    end

    inClothingMenu = false

    cb("ok")
end)

RegisterNUICallback("chooseClothingCam", function(data, cb)
    if data.value == 'fullBody' then
        if fullBodyCam == currentCam then return end

        SetCamActiveWithInterp(fullBodyCam, currentCam, 500, 10, 1)

        currentCam = fullBodyCam
    end

    if data.value == 'head' then
        if headCam == currentCam then return end

        SetCamActiveWithInterp(headCam, currentCam, 500, 10, 1)

        currentCam = headCam
    end

    if data.value == 'body' then
        if bodyCam == currentCam then return end

        SetCamActiveWithInterp(bodyCam, currentCam, 500, 10, 1)

        currentCam = bodyCam
    end

    if data.value == 'pants' then
        if pantsCam == currentCam then return end

        SetCamActiveWithInterp(pantsCam, currentCam, 500, 10, 1)

        currentCam = pantsCam
    end

    if data.value == 'shoes' then
        if shoesCam == currentCam then return end

        SetCamActiveWithInterp(shoesCam, currentCam, 500, 10, 1)

        currentCam = shoesCam
    end

    cb("ok")
end)

RegisterNUICallback("clothingSelect", function(data, cb)
    call(data)

    cb("ok")
end)

RegisterNUICallback("clothingShopUpdate", function(data, cb)
    call(data)

    cb("ok")
end)

AddEventHandler('chud:clothingShop', function(coords, heading, menuType, restrict, callback)
    shopCall = callback

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerEvent('esx_skin:setLastSkin', skin)
    end)

    TriggerEvent('skinchanger:getData', function(components, maxVals)
		local elements    = {}
		local _components = {}

		-- Restrict menu
		if restrict == nil then
			for i=1, #components, 1 do
				_components[i] = components[i]
			end
		else
			for i=1, #components, 1 do
				local found = false

				for j=1, #restrict, 1 do
					if components[i].name == restrict[j] then
						found = true
					end
				end

				if found then
					table.insert(_components, components[i])
				end
			end
		end

		-- Insert elements
		for i=1, #_components, 1 do
			local value       = _components[i].value
			local componentId = _components[i].componentId

			if componentId == 0 then
				value = GetPedPropIndex(playerPed, _components[i].componentId)
			end

			local data = {
				label     = _components[i].label,
				name      = _components[i].name,
				value     = value,
				min       = _components[i].min,
                max       = maxVals[_components[i].name],
				textureof = _components[i].textureof,
				zoomOffset= _components[i].zoomOffset,
				camOffset = _components[i].camOffset,
				type      = 'slider'
			}

			table.insert(elements, data)
		end

        TriggerEvent('chud:clothing', coords, heading, menuType, elements, function(data)
            local value = tonumber(data.value)

            TriggerEvent('skinchanger:getSkin', function(skin)
				if skin[data.name] ~= value then
					-- Change skin element
					TriggerEvent('skinchanger:change', data.name, value)

					-- Update max values
					TriggerEvent('skinchanger:getData', function(components, maxVals)
						for i=1, #elements, 1 do
							--local newData = {}

							elements[i].max = maxVals[elements[i].name]

                            if elements[i].name == data.name then
                                elements[i].value = value
                            end

							if elements[i].textureof ~= nil and data.name == elements[i].textureof then
								TriggerEvent('skinchanger:change', elements[i].name, 0)
                                elements[i].value = 0
							end
						end

                        SendNUIMessage(
                            {
                                action = "updateValuesClothing",
                                itemList = elements,
                            }
                        )
					end)
				end
			end)
        end)
    end)
end)


--[[
RegisterCommand('clothing', function()
    local restrict = {}

    TriggerEvent('chud:clothingShop', GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), 'shop', {}, function(success) end)
end)]]
