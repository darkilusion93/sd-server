


local function giveAnim()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		return
	end
    Citizen.CreateThread(function()
        	local lib, anim = "mp_common", "givetake1_a"			
		    ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
		end)
    end)
end

local function dispenseItemAnim()
    Citizen.CreateThread(function()
        local lib, anim = "pickup_object", "pickup_low"
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
    end)
end

local function removeBagFromPlayer()
    Citizen.CreateThread(function()
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 or 1 then
                local clothesSkin = { ['bags_1'] = 0, ['bags_2'] = 0 }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
        end)
    end)
end

local function giveBagToPlayer()
    Citizen.CreateThread(function()
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex == 0 or 1 then
                local clothesSkin = { ['bags_1'] = 45, ['bags_2'] = 0 }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end
        end)
    end)
end

RegisterNetEvent('cframework:playGiveAnim', function()
    giveAnim()
end)

RegisterNetEvent('cframework:playDispenseItemAnim', function()
    dispenseItemAnim()
end)

RegisterNetEvent('cframework:removeBagFromPlayer', function()
    removeBagFromPlayer()
end)

RegisterNetEvent('cframework:giveBagToPlayer', function(source)
    giveBagToPlayer()
end)
