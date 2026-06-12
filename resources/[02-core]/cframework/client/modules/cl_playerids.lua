local showId = false
local gamerTags = {}
local group = 'user'
local isAdminMod = false
local ID_MAX_DISTANCE <const> = 300.0

-- Gamer tags configuration
SetMpGamerTagsUseVehicleBehavior(false)
SetMpGamerTagsVisibleDistance(ID_MAX_DISTANCE)

RegisterNetEvent('esx:playerLoaded', function(player)
	group = player.group
end)

RegisterNetEvent("cframework:enterAdmin", function(id, name)
    isAdminMod = true
end)

RegisterNetEvent("cframework:leaveAdmin", function(id, name)
    showId = false
    isAdminMod = false
end)

local function ArrayHasValue(array, value, field)
	if field then
		for k, v in pairs(array) do
			if value == v[field] then
				return k
			end
		end
	else
		for k, v in pairs(array) do
			if value == v then
				return k
			end
		end
	end
end

local function startShowIdThread()
    Citizen.CreateThread(function()
        while showId do
            local playerPed = PlayerPedId()
            local closePlayers = ESX.Game.GetPlayers()

            for _, playerId in pairs(closePlayers) do
                local otherPed = GetPlayerPed(playerId)
                local targetCoords = GetEntityCoords(otherPed)

                if otherPed ~= playerPed and #(GetEntityCoords(playerPed) - targetCoords) < ID_MAX_DISTANCE then
                    local name = ('[%s] %s'):format(GetPlayerServerId(playerId), GetPlayerName(playerId))
                    gamerTags[playerId] = CreateFakeMpGamerTag(otherPed, name, false, false, '', 0)

                    -- Name
                    SetMpGamerTagVisibility(gamerTags[playerId], 0, true)
                    if GetEntityHealth(otherPed) <= 0 then
                        SetMpGamerTagColour(gamerTags[playerId], 0, 7)
                    elseif IsPedInAnyVehicle(otherPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(otherPed, false), -1) == otherPed then
                        SetMpGamerTagColour(gamerTags[playerId], 0, 10)
                    else
                        SetMpGamerTagColour(gamerTags[playerId], 0, 0)
                    end
                    SetMpGamerTagAlpha(gamerTags[playerId], 0, 255)

                    -- Health and armor
                    SetMpGamerTagVisibility(gamerTags[playerId], 2, true)
                    SetMpGamerTagColour(gamerTags[playerId], 2, 200)
                    SetMpGamerTagAlpha(gamerTags[playerId], 2, 255)

                    -- Talking stuff
                    SetMpGamerTagVisibility(gamerTags[playerId], 4, NetworkIsPlayerTalking(playerId))
                    SetMpGamerTagColour(gamerTags[playerId], 4, 9)
                    SetMpGamerTagAlpha(gamerTags[playerId], 4, 255)
                else
                    RemoveMpGamerTag(gamerTags[playerId])
                    gamerTags[playerId] = nil
                end
            end

            local playerIdsToRemove = {}
            for playerId,_ in pairs(gamerTags) do
                if not ArrayHasValue(closePlayers, playerId) then
                    table.insert(playerIdsToRemove, playerId)
                end
            end

            for _,playerId in pairs(playerIdsToRemove) do
                RemoveMpGamerTag(gamerTags[playerId])
                gamerTags[playerId] = nil
            end

            Citizen.Wait(100)
        end

        for _, v in pairs(gamerTags) do
            RemoveMpGamerTag(v)
        end
        gamerTags = {}
    end)
end

RegisterCommand("id", function(source, args , rawCommand)
    if group == 'user' then return end
    if not isAdminMod then return end

    showId = not showId
    startShowIdThread()
    TriggerEvent('cframework:toggleHouseIds', showId)
end, false)
