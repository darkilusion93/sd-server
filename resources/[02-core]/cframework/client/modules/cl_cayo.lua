

local inCayoPerico = false

ESX.isPlayerinCayoPerico = function()
    return inCayoPerico
end

Citizen.CreateThread(function()
    exports.ft_libs:RemoveTrigger("cayoperico")
    exports.ft_libs:AddTrigger("cayoperico", {
        x = 4840.571,
        y = -5174.425,
        z = 2.0,
        weight = 1800,
        height = 1800,
        enter = {
            eventClient = "fivem:enterCayoPerico",
        },
        exit = {
            eventClient = "fivem:leaveCayoPerico",
        },
    })
end)

RegisterNetEvent("fivem:leaveCayoPerico",function()
	SetIslandEnabled("HeistIsland", false)
    inCayoPerico = false
end)

RegisterNetEvent("fivem:enterCayoPerico",function()
	SetIslandEnabled("HeistIsland", true)  -- load the map and removes the city
    inCayoPerico = true
end)

RegisterNetEvent('esx:playerLoaded', function(playerData)
	local islandVec = vector3(4840.571, -5174.425, 2.0)
	local pCoords = vector3(playerData.lastPosition.x, playerData.lastPosition.y, playerData.lastPosition.z)
	local distance1 = #(pCoords - islandVec)
	if distance1 < 1800.0 then
		local forceFreeze = true
		Citizen.CreateThread(function()
			while forceFreeze do
				FreezeEntityPosition(PlayerPedId(), true)
				Citizen.Wait(0)
			end
		end)
		SetIslandEnabled("HeistIsland", true)  -- load the map and removes the city
        inCayoPerico = true

		Citizen.Wait(40000)
		forceFreeze = false
		FreezeEntityPosition(PlayerPedId(), false)
	else
		SetIslandEnabled("HeistIsland", false)
        inCayoPerico = false
	end
end)
