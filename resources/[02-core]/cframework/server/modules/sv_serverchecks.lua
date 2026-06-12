-- Title  : sv_serverchecks.lua
-- Author : Gonçalo Costa
-- Started: 06/08/24

local whitelistPeds = {}
local heatmapCoords = {}
local insiviblePlayers = {}

-- Localize natives for faster performance
local getPlayerPed = GetPlayerPed
local getSelectedPedWeapon = GetSelectedPedWeapon
local getEntityHealth = GetEntityHealth
local isEntityVisible = IsEntityVisible
local isPlayerBeingCarried = IsPlayerBeingCarried --This is not a native
local getEntityCoords = GetEntityCoords
local getEntityModel = GetEntityModel
local getHashKey = GetHashKey

function AddPlayerToPedWhitelist(player)
    whitelistPeds[player] = true
end

AddEventHandler("cframework:disableInvisibleCheck", function(player)
	insiviblePlayers[player] = true
end)

AddEventHandler("cframework:enableInvisibleCheck", function(player)
	insiviblePlayers[player] = nil
end)

Citizen.CreateThread(function()
	local femalePed, malePed, playerZero = `mp_f_freemode_01`, `mp_m_freemode_01`, `player_zero`

    while true do
        local xPlayers = ESX.GetPlayers()

		heatmapCoords = {}

		for i=1, #xPlayers, 1 do
            local source, hasweapon = xPlayers[i], false
            local ped = getPlayerPed(source)
			local pedweapon = getSelectedPedWeapon(ped)
			local health = getEntityHealth(ped)
			local isVisible = isEntityVisible(ped)
			local group = ESX.getGroup(source)

			if ESX.isLoadoutLoaded(source) and insiviblePlayers[source] == nil and not isPlayerBeingCarried(source) and group == "user" then
				if not isVisible then
					DropPlayer(source, "Sem Destino Anti-Cheat : Unseen man")
				end
			end

			if ped == 0 then
				DropPlayer(source, 'ERROR: inv-ped-'..#GetPlayers())
				goto final
			end

			local coords = getEntityCoords(ped)

			table.insert(heatmapCoords, {x = coords.x, y = coords.y, id = source})

			local pedModel = getEntityModel(ped)
			if whitelistPeds[source..""] == nil and pedModel ~= femalePed and pedModel ~= malePed and pedModel ~= playerZero then
				TriggerEvent('cframework:notAllowedPedBan', source)
			end

			if health <= 0 then
				goto final
			end

			if not ESX.GetWeaponFromHash(pedweapon) then
				goto final
			end

            local inventory = ESX.getInvContainer(source)

            if inventory == nil then
                goto final
            end

            local items = inventory.getItems()

			for k,v in ipairs(items) do
                if getHashKey(v.name) == pedweapon then
                    hasweapon = true
					break
                end
            end

            if not hasweapon then
				--DropPlayer(source, 'Sem Destino Anti-Cheat: Weapon Spawn')
                RemoveAllPedWeapons(ped, true)
            end

			::final::
		end
        Citizen.Wait(30000)
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(120000) --2 minutes

		ESX.SendHeatmapData(heatmapCoords)
	end
end)