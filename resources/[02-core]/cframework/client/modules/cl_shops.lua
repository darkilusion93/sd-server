

local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}

Citizen.CreateThread(function()
    for i,_ in pairs(ESX.Shops) do
        for j,item in pairs(ESX.Shops[i].items) do
            if string.find(item.name, "WEAPON_") or string.find(item.name, "GADGET_") then
                ESX.Shops[i].items[j].limit = 1
                ESX.Shops[i].items[j].label = ESX.GetWeaponLabel(item.name)
            elseif string.find(item.name, "cash") then
                ESX.Shops[i].items[j].limit = -1
                ESX.Shops[i].items[j].label = "€"
            else
                ESX.Shops[i].items[j].limit = ESX.Items[item.name].limit
                ESX.Shops[i].items[j].label = ESX.GetItemLabel(item.name)
            end
        end
    end
end)

function OpenShopMenu(zone, pos)
	if ESX.Shops[zone].Pos[pos] ~= nil and ESX.Shops[zone].Pos[pos].minJob ~= nil then
		local num <const> = RPC.execute("cframework:getPlayersInJob", ESX.Shops[zone].Pos[pos].minJob)
		if num >= ESX.Shops[zone].Pos[pos].minNum then
			TriggerEvent('esx_inventoryhud:openShop', zone, ESX.Shops[zone].items, ESX.Shops[zone].moneyType)
		else
			ESX.ShowNotification(T("SHOPS_MARKET_CLOSED"), 'error')
		end
    elseif ESX.Shops[zone].Pos[pos] ~= nil and ESX.Shops[zone].Pos[pos].maxJob ~= nil then
        local num <const> = RPC.execute("cframework:getPlayersInJob", ESX.Shops[zone].Pos[pos].maxJob)
		if num >= ESX.Shops[zone].Pos[pos].maxNum then
			TriggerEvent('esx_inventoryhud:openShop', zone, ESX.Shops[zone].items, ESX.Shops[zone].moneyType)
		else
			ESX.ShowNotification(T("SHOPS_MARKET_CLOSED"), 'error')
		end
	else
		TriggerEvent('esx_inventoryhud:openShop', zone, ESX.Shops[zone].items, ESX.Shops[zone].moneyType)
	end
end

AddEventHandler('cframework:openShopMenu', function(zone)
	OpenShopMenu(zone, 1)
end)

AddEventHandler('esx_shops:hasEnteredMarker', function(zone)
	CurrentAction     = 'shop_menu'
	CurrentActionMsg  = T("GENERIC_PRESS_TO_INTERACT")
	CurrentActionData = {zone = zone[1], pos = zone[2]}

	while CurrentAction ~= nil do
		if ESX.isHandcuffed() then
			CurrentAction = nil
		end

        if IsPedInAnyVehicle(PlayerPedId(), false) then
            CurrentAction = nil
        end

		ESX.ShowHelpNotification(CurrentActionMsg)

		if IsControlJustReleased(0, 38) then

			if CurrentAction == 'shop_menu' then
				OpenShopMenu(CurrentActionData.zone, CurrentActionData.pos)
			end
		end

		Citizen.Wait(0)
	end
end)

AddEventHandler('esx_shops:hasExitedMarker', function()
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Create Blips
Citizen.CreateThread(function()
	AddTextEntry('SHOPBLIP', T("SHOPS_SHOP"))
	AddTextEntry('BARBLIP', T("SHOPS_BAR"))
	AddTextEntry('MECHBLIP', T("SHOPS_MECHANIC"))
	AddTextEntry('ELECTRONICBLIP', T("SHOPS_ELECTRONIC"))

	for i=1, #ESX.ShopsMap, 1 do
		local blip <const> = AddBlipForCoord(ESX.ShopsMap[i].x, ESX.ShopsMap[i].y, ESX.ShopsMap[i].z)
		SetBlipSprite (blip, ESX.ShopsMap[i].id)
		SetBlipScale  (blip, 0.5)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, ESX.ShopsMap[i].color)
		SetBlipAsShortRange(blip, true)

		if ESX.ShopsMap[i].name == 1 then
			BeginTextCommandSetBlipName("SHOPBLIP")
		elseif ESX.ShopsMap[i].name == 2 then
			BeginTextCommandSetBlipName("BARBLIP")
		elseif ESX.ShopsMap[i].name == 3 then
			BeginTextCommandSetBlipName("MECHBLIP")
		elseif ESX.ShopsMap[i].name == 4 then
			BeginTextCommandSetBlipName("ELECTRONICBLIP")
		end

		EndTextCommandSetBlipName(blip)
	end

	for k,v in pairs(ESX.Shops) do
		if k ~= "Mina" then
			for i = 1, #v.Pos, 1 do
				exports.ft_libs:AddMarker("shop" .. k .. i, {type = 50, x = v.Pos[i].x, y = v.Pos[i].y, z = v.Pos[i].z+1,
				red = 145, green = 187, blue = 255, showDistance = 25})

				exports.ft_libs:AddTrigger("shop" .. k .. i, {x = v.Pos[i].x, y = v.Pos[i].y, z = v.Pos[i].z, weight = 1.7, height = 2,
					enter = {eventClient = "esx_shops:hasEnteredMarker"}, exit = {eventClient = "esx_shops:hasExitedMarker"}, data = {k, i},
					active = {}})
			end

			for i = 1, #v.Ped, 1 do
				exports.ft_libs:AddPed(k.."shop_selling" .. i, {model = v.Ped[i].model, x = v.Ped[i].x, y = v.Ped[i].y, z = v.Ped[i].z, w = v.Ped[i].w})
			end
		end
	end
end)

