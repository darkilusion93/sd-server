local PlayerData                = {}
local CurrentPropertyOwner    = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

local invOpen = false
local inMotel = false
local createdTriggersMotel = {}

local interiorsCoords = {
    ["default"] = {
        inside = vector3(151.48, -1007.59, -99.00),
        vault = vector3(154.9879, -1007.788, -99.2062),
        vaultHeading = 269.99996,
        cloakroom = vector3(152.14, -1002.29, -98.97),
        cloakroomHeading = 227.72,
    },
    ["cayo"] = {
        inside = vector3(5178.60, -5145.48, -100.34),
        vault = vector3(5181.583, -5145.452, -100.520),
        vaultHeading = 269.99996,
        cloakroom = vector3(5178.24, -5140.41, -100.34),
        cloakroomHeading = 213.92,
    },
    ["warehouse"] = {
        inside = vector3(992.38, -3097.81, -39.00),
        vault = vector3(994.64, -3100.05, -39.00),
    },
}

RegisterNetEvent("inventoryClosed", function()
    invOpen = false
end)

Citizen.CreateThread(function()
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0)
	end

	PlayerData = ESX.GetPlayerData()

	TriggerEvent('instance:registerType', 'property', function(instance)
		EnterProperty(instance.data.property, instance.data.owner, instance.data.type)
	end, function(instance)
		ExitProperty(instance.data.property)
	end)

	ESX.TriggerServerCallback('esx_property:getProperties',function(properties)
		Config.Properties = properties

		for i=1, #Config.Properties, 1 do
			local property = Config.Properties[i]

            if property.entering and not property.disabled  then
                exports.ft_libs:AddMarker("property_entering" .. property.name, {type = 50, x = property.entering.x, y = property.entering.y, z = property.entering.z, red = 0, green = 0, blue = 255, showDistance = 5})
                exports.ft_libs:AddTrigger("property_entering" .. property.name, {x = property.entering.x, y = property.entering.y, z = property.entering.z, weight = 1, height = 2,
                enter = {eventClient = "esx_property:hasEnteredMarker"}, exit = {eventClient = "esx_property:hasExitedMarker"}, data = {'entering', property.name, property.motelroom}, active = {}})
            end
		end
	end)
end)

function EnterProperty(name, owner, mType)
	local property       = GetProperty(name)
	local playerPed      = PlayerPedId()
	CurrentProperty      = property
	CurrentPropertyOwner = owner


    local interiorToUse = ESX.isPlayerinCayoPerico() and "cayo" or "default"

    if mType == "warehouse" then
        interiorToUse = "warehouse"
    end

    local interiorCoords = interiorsCoords[interiorToUse]

	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name ~= name then
			Config.Properties[i].disabled = true
		end
	end

	inMotel = true

	TriggerEvent('cframework:closePhone')
	TriggerEvent('cframework:stopPegar')
	TriggerEvent('cframework:disableVehiclePush')

	TriggerServerEvent('cframework:saveLastProperty', property.outside)

    Citizen.CreateThread(function()
        DoScreenFadeOut(800)

        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end

        for i=1, #property.ipls, 1 do
            RequestIpl(property.ipls[i])

            while not IsIplActive(property.ipls[i]) do
                Citizen.Wait(0)
            end
        end

        SetEntityCoords(playerPed, interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z, false, false, false, false)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
            Citizen.Wait(0)
            SetEntityCoords(playerPed, interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z, false, false, false, false)
        end

        DoScreenFadeIn(800)
        --DrawSub(property.label, 5000)
    end)


    if mType == "motel" then
        local menuAberto = false
        local vaultDoorNetId <const> = RPC.execute("cframework:spawnMotelVault", ESX.isPlayerinCayoPerico())

        Citizen.CreateThread(function()
            while inMotel do
                if #(vector3(interiorCoords.vault.x, interiorCoords.vault.y, interiorCoords.vault.z) - GetEntityCoords(PlayerPedId())) < 1.5 then

                    ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_OPEN_VAULT"))

                    if IsControlPressed(0, 38) and not menuAberto then
                        menuAberto = true

                        TriggerEvent("cframework:removeWeaponsFromHandInstant")

                        Citizen.Wait(150)
                        if OpenCloseVault(NetworkGetEntityFromNetworkId(vaultDoorNetId), true) then
                            if not inMotel then return end

                            TriggerEvent("cframework:openPropertyInventory", 'property')

                            invOpen = true

                            while invOpen do
                                Citizen.Wait(50)
                            end
                            OpenCloseVault(NetworkGetEntityFromNetworkId(vaultDoorNetId), false)
                        else
                            TriggerEvent("cframework:openPropertyInventory", 'property')
                        end
                        menuAberto = false

                    end
                else
                    Citizen.Wait(1000)
                end

                if #(vector3(interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z) - GetEntityCoords(PlayerPedId())) > 40.0 and inMotel then
                    SetEntityCoords(PlayerPedId(), interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z, false, false, false, false)
                end

                Citizen.Wait(5)
            end
        end)
    elseif mType == "warehouse" then
        Citizen.CreateThread(function()
            while inMotel do
                if #(vector3(interiorCoords.vault.x, interiorCoords.vault.y, interiorCoords.vault.z) - GetEntityCoords(PlayerPedId())) < 1.5 then

                    ESX.ShowHelpNotification(T("GENERIC_PRESS_TO_OPEN_VAULT"))

                    if IsControlPressed(0, 38) then
                        TriggerEvent("cframework:openPropertyInventory", 'storage_unit')
                        Citizen.Wait(1000)
                    end
                else
                    Citizen.Wait(1000)
                end

                if #(vector3(interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z) - GetEntityCoords(PlayerPedId())) > 40.0 and inMotel then
                    SetEntityCoords(PlayerPedId(), interiorCoords.inside.x, interiorCoords.inside.y, interiorCoords.inside.z, false, false, false, false)
                end

                Citizen.Wait(5)
            end
        end)
    end

	--Disable animations, prevent bugs
	Citizen.CreateThread(function()
		--Disable stuff
		TriggerEvent('cframework:disablePegar')
		TriggerEvent('cframework:disableEmotes')
		while inMotel do
			DisableControlAction(0,22,true)
            --DisableControlAction(0,21,true)
			Citizen.Wait(0)
		end
		--Enable stuff
		TriggerEvent('cframework:enableEmotes')
		TriggerEvent('cframework:enablePegar')
		TriggerEvent('cframework:enableVehiclePush')
	end)

    if mType == "motel" then
        exports.ft_libs:AddTrigger("property_cloakroom" .. property.name, {x = interiorCoords.cloakroom.x, y = interiorCoords.cloakroom.y, z = interiorCoords.cloakroom.z, weight = 1, height = 2,
        enter = {eventClient = "esx_property:hasEnteredMarker"}, exit = {eventClient = "esx_property:hasExitedMarker"}, data = {'roomMenu', name}, active = {}})
        table.insert(createdTriggersMotel, "property_cloakroom" .. property.name)
    end

    exports.ft_libs:AddTrigger("property_exit" .. property.name, {x = interiorCoords.inside.x, y = interiorCoords.inside.y, z = interiorCoords.inside.z, weight = 1, height = 2,
    enter = {eventClient = "esx_property:hasEnteredMarker"}, exit = {eventClient = "esx_property:hasExitedMarker"}, data = {'exit', name}, active = {}})
    table.insert(createdTriggersMotel, "property_exit" .. property.name)

end

function ExitProperty(name)
	local property  = GetProperty(name)
	local playerPed = PlayerPedId()
	local outside   = nil
	CurrentProperty = nil

	inMotel = false

	for i=1, #createdTriggersMotel, 1 do
        exports.ft_libs:RemoveTrigger(createdTriggersMotel[i])
        exports.ft_libs:RemoveMarker(createdTriggersMotel[i])
    end
    createdTriggersMotel = {}

	TriggerServerEvent('cframework:deleteLastProperty')
    TriggerServerEvent("cframework:deleteMotelVault")

	Citizen.CreateThread(function()
		SetEntityCoords(playerPed, property.outside.x, property.outside.y, property.outside.z, false, false, false, false)

		for i=1, #property.ipls, 1 do
			RemoveIpl(property.ipls[i])
		end

		for i=1, #Config.Properties, 1 do
			Config.Properties[i].disabled = false
		end

		DoScreenFadeIn(800)
	end)
end

function OpenRoomMenu(property, owner)
	ESX.UI.Menu.CloseAll()

    local interiorToUse = ESX.isPlayerinCayoPerico() and "cayo" or "default"
    local interiorCoords = interiorsCoords[interiorToUse]

	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}

		for i=1, #dressing, 1 do
			table.insert(elements, {
				label = dressing[i],
				value = i
			})
		end

        TriggerEvent('chud:clothing', interiorCoords.cloakroom, interiorCoords.cloakroomHeading, 'cloakroom', elements, function(data)
            
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
					TriggerEvent('skinchanger:loadClothes', skin, clothes)
					TriggerEvent('esx_skin:setLastSkin', skin)

					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
				end, tonumber(data.value))
            end)
			
        end)
	end)
end

RegisterNetEvent('instance:onCreate', function(instance)
	if instance.type == 'property' then
		TriggerEvent('instance:enter', instance)
	end
end)

RegisterNetEvent('instance:onEnter', function(instance)
	if instance.type == 'property' then
		
	end
end)

RegisterNetEvent('instance:onPlayerLeft', function(instance, player)
	if player == instance.host then
		TriggerEvent('instance:leave')
	end
end)

-- only used when script is restarting mid-session
RegisterNetEvent('esx_property:sendProperties', function(properties)
	Config.Properties = properties
	--CreateBlips()
end)

function GetProperty(name)
	for i=1, #Config.Properties, 1 do
		if Config.Properties[i].name == name then
			return Config.Properties[i]
		end
	end
end

AddEventHandler('esx_property:hasEnteredMarker', function(data)
	local name, part, type = data[2], data[1], data[3]
	local property = GetProperty(name)

	if part == 'entering' then
		if property.isSingle then
			CurrentAction     = 'property_menu'
			CurrentActionMsg  = T("GENERIC_PRESS_TO_ENTER_PROPERTY")
			CurrentActionData = {property = property}
		end
	elseif part == 'exit' then
		CurrentAction     = 'room_exit'
		CurrentActionMsg  = T("GENERIC_PRESS_TO_EXIT_PROPERTY")
		CurrentActionData = {propertyName = name}
	elseif part == 'roomMenu' then
		CurrentAction     = 'room_menu'
		CurrentActionMsg  = T("GENERIC_PRESS_TO_INTERACT")
		CurrentActionData = {property = property, owner = CurrentPropertyOwner}
	end

	Citizen.CreateThread(function()
		while CurrentAction ~= nil do
			ESX.ShowHelpNotification(CurrentActionMsg)
			Citizen.Wait(0)

			if ESX.isHandcuffed() then
				CurrentAction = nil
			end

			if not IsControlPressed(0, VK_KEY_E) then
				goto final
			end

			if CurrentAction == 'property_menu' then
				ESX.clearAttachedProps()
				TriggerEvent('instance:create', 'property', {property = CurrentActionData.property.name, owner = PlayerData.identifier, type = type})
			end

			if CurrentAction == 'room_menu' then
				OpenRoomMenu(CurrentActionData.property, CurrentActionData.owner)
			end

			if CurrentAction == 'room_exit' then
				ESX.clearAttachedProps()

                DoScreenFadeOut(800)

                while not IsScreenFadedOut() do
                    Citizen.Wait(0)
                end

				TriggerEvent('instance:leave')
			end

			CurrentAction = nil

			--Citizen.Wait(1000)

			::final::
		end
	end)
end)

AddEventHandler('esx_property:hasExitedMarker', function(data)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

