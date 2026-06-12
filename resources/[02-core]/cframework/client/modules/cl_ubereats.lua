local createdMarkers = {}
local PlayerData = {}
local created = false
local CurrentAction = nil

local canWorkUber = false
local hasPendingJob = false
local deliveryBlip = nil

local cloakRoomLocation = {
    { x = -1182.44, y = -883.4, z = 13.78 },
}

local vehicleSpawner = {
    { x = -1172.13, y = -876.09, z = 14.11 },
}

local vehicleDeleter = {
    { x = -1169.09, y = -883.49, z = 14.11 },
}

local uberBlips = {
    { title = "Destino Eats", colour = 24, id = 512, x = -1182.44, y = -883.4, z = 12.78, scale = 0.5 },
}

local uberUniforms = {
	male = {
		['tshirt_1'] = 15,  ['tshirt_2'] = 0,
		['torso_1']  = 608, ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms']     = 0,
		['pants_1']  = 298,  ['pants_2'] = 0,
		['shoes_1']  = 1,  ['shoes_2'] = 1,
	},
  	female = {
		['tshirt_1'] = 15,   ['tshirt_2'] = 0,
		['torso_1'] =711,  ['torso_2'] = 0,
		['decals_1'] = 0,   ['decals_2'] = 0,
		['arms'] = 14,
		['pants_1'] = 279,   ['pants_2'] = 0,
		['shoes_1'] = 1,   ['shoes_2'] = 1,  
  	},
}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    removeUberMarkers()
    createUberMarkers()
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeUberMarkers()
    createUberMarkers()
end)

RegisterNetEvent('uberEnteredMarker', function(action)
    CurrentAction = action

    Citizen.CreateThread(function()
        while CurrentAction ~= nil do

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            if CurrentAction == 'cloakroom' then
                CurrentAction = nil
                uberCloakroom()
            end

            if CurrentAction == 'vehiclespawner' and canWorkUber then
                CurrentAction = nil
				uberVehicleSpawner()
            end

            if CurrentAction == 'vehicledeleter' then
                CurrentAction = nil
				uberVehicleDeleter()
            end

            ::final::
        end
    end)
end)

RegisterNetEvent('uberExitedMarker', function()
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Enter / Exit marker events
function createUberMarkers()

    if PlayerData.job == nil or PlayerData.job.name ~= 'ubereats' then 
        return 
    end

    for i=1, #cloakRoomLocation, 1 do
        exports.ft_libs:AddMarker("uber_cloakroom" .. i, {type = 20, x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 1, red = 155, green = 253, blue = 155, showDistance = 25})
        exports.ft_libs:AddTrigger("uber_cloakroom" .. i, {x = cloakRoomLocation[i].x, y = cloakRoomLocation[i].y, z = cloakRoomLocation[i].z, weight = 1, height = 2,
        enter = {eventClient = "uberEnteredMarker"}, exit = {eventClient = "uberExitedMarker"}, data = 'cloakroom', active = {}})
        table.insert(createdMarkers, "uber_cloakroom" .. i)
    end

    for i=1, #vehicleSpawner, 1 do
        exports.ft_libs:AddMarker("uber_vehiclespawner" .. i, {type = 20, x = vehicleSpawner[i].x, y = vehicleSpawner[i].y, z = vehicleSpawner[i].z, weight = 1, height = 1, red = 0, green = 255, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("uber_vehiclespawner" .. i, {x = vehicleSpawner[i].x, y = vehicleSpawner[i].y, z = vehicleSpawner[i].z, weight = 1, height = 2,
        enter = {eventClient = "uberEnteredMarker"}, exit = {eventClient = "uberExitedMarker"}, data = 'vehiclespawner', active = {}})
        table.insert(createdMarkers, "uber_vehiclespawner" .. i)
    end

	for i=1, #vehicleDeleter, 1 do
        exports.ft_libs:AddMarker("uber_vehicledeleter" .. i, {type = 20, x = vehicleDeleter[i].x, y = vehicleDeleter[i].y, z = vehicleDeleter[i].z, weight = 1, height = 1, red = 255, green = 0, blue = 0, showDistance = 25})
        exports.ft_libs:AddTrigger("uber_vehicledeleter" .. i, {x = vehicleDeleter[i].x, y = vehicleDeleter[i].y, z = vehicleDeleter[i].z, weight = 1, height = 2,
        enter = {eventClient = "uberEnteredMarker"}, exit = {eventClient = "uberExitedMarker"}, data = 'vehicledeleter', active = {}})
        table.insert(createdMarkers, "uber_vehicledeleter" .. i)
    end

    for _, info in pairs(uberBlips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, info.scale)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(info.title)
        EndTextCommandSetBlipName(info.blip)
    end

    created = true
end

function removeUberMarkers()
    for i=1, #createdMarkers, 1 do
        exports.ft_libs:RemoveTrigger(createdMarkers[i])
        exports.ft_libs:RemoveMarker(createdMarkers[i])
    end
    createdMarkers = {}

    if not created then
        return
    end

    for i, blip in pairs(uberBlips) do
		RemoveBlip(blip.blip)
	end
    created = false
end

function uberCloakroom()
    local elements = {
        {label = '🧥 Roupas de civil',         value = 'cloakroom1'},
        {label = '👔 Roupa de trabalho',       value = 'cloakroom2'},
    }

    ESX.UI.Menu.CloseAll()

    TriggerEvent('chud:menu', elements, 'Ubereats', function(value)
        if value == 'cloakroom1' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
            TriggerServerEvent('cframework:exitUberService')
            canWorkUber = false
        end

        if value == 'cloakroom2' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                end
            end)
            TriggerServerEvent('cframework:enterUberService')
            canWorkUber = true
        end
    end)
end


function uberVehicleSpawner()
	TriggerServerEvent('cframework:spawnUberVehicle')
end

function uberVehicleDeleter()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then ESX.ShowNotification('Não estás em nenhum veículo', 'error') return end

	TriggerServerEvent('cframework:storeVehicle', nil)
end

function DrawOnScreenText(msg)
	SetTextFont(0)
	SetTextProportional(true)
	SetTextScale(0.0, 0.4)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayText(0.900, 0.850)
end

RegisterNetEvent('cframework:uberHasVehicle', function()
	ESX.ShowNotification('Já retiraste um veículo.', 'error')
end)

RegisterNetEvent('cframework:uberGetJob', function(jobDetails)
	hasPendingJob = true

	if deliveryBlip then RemoveBlip(deliveryBlip) end
	exports.ft_libs:RemoveMarker("uber_pendingjob")

	deliveryBlip = AddBlipForCoord(jobDetails.coords.x, jobDetails.coords.y, jobDetails.coords.z)
	SetBlipRoute(deliveryBlip, true)

	exports.ft_libs:AddMarker("uber_pendingjob", {type = 20, x = jobDetails.coords.x, y = jobDetails.coords.y, z = jobDetails.coords.z+1, weight = 1, height = 1, red = 235, green = 64, blue = 52, showDistance = 25})

	while hasPendingJob do
		if #(GetEntityCoords(PlayerPedId()) - jobDetails.coords) < 2.5 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
			ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para entregar o pedido.")

			if IsControlJustReleased(1, 38) then
				TriggerServerEvent('cframework:uberFinishDelivery')
				break
			end
		end

		DrawOnScreenText('~y~Entrega~w~:\nCola: ~g~' .. jobDetails.drink.count .. '~w~\nBatatas Fritas: ~g~' .. jobDetails.food.count)

		Citizen.Wait(0)
	end

	exports.ft_libs:RemoveMarker("uber_pendingjob")
	RemoveBlip(deliveryBlip)
	deliveryBlip = nil
end)

RegisterNetEvent('cframework:uberCantFinishJob', function()
	ESX.ShowNotification('Não conseguiste entregar a encomenda. Itens em falta.', 'error')
end)

RegisterNetEvent('cframework:uberOutOfService', function()
	hasPendingJob = false
end)
