-- ## 3dme : client side

-- ## Variables
local pedDisplaying = {}
local visual = {
        color = { r = 230, g = 230, b = 230, a = 255 }, -- Text color
        font = 0, -- Text font
        time = 5000, -- Duration to display the text (in ms)
        scale = 0.5, -- Text scale
        dist = 250, -- Min. distance to draw 
    }

-- ## Functions

-- OBJ : draw text
-- PARAMETERS :
--      - coords : world coordinates to where you want to draw the text
--      - text : the text to display
local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    
    -- Experimental math to scale the text down
    local scale = 200 / (GetGameplayCamFov() * dist)

    -- Format the text
    local c = visual.color
    SetTextColour(c.r, c.g, c.b, c.a)
    SetTextScale(0.0, visual.scale * scale)
    SetTextFont(visual.font)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)

    -- Diplay the text
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)

    ---@diagnostic disable-next-line: missing-parameter
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

-- OBJ : handle the drawing of text above a ped head
-- PARAMETERS :
--      - coords : world coordinates to where you want to draw the text
--      - text : the text to display
local function Display(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= visual.dist then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        -- Timer
        local display = true

        
        Citizen.CreateThread(function()
            Wait(visual.time)
            display = false
        end)

        -- Display
        local offset = 0.9 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1

    end
end

-- ## Events

-- Share the display of 3D text
RegisterNetEvent('3dme:shareDisplay', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        Display(ped, text)
    end
end)

AddEventHandler("playerSpawned", function()
    SetCanAttackFriendly(PlayerPedId(), true, false)
    NetworkSetFriendlyFireOption(true)
end)

local group = 'user'
RegisterNetEvent('esx:playerLoaded', function(player)
	group = player.group
end)

RegisterNetEvent('3dme:chatPrivado', function(playerName, msg)
if group ~= "user" then
    TriggerEvent('chat:addMessage', {
	    template = '<div style="padding: 0.5vw;  margin: 0.5vw; background-color: rgba(242, 10, 10, 0.75); color: white; border-radius: 20px;"><i class="fa fa-exclamation-triangle">&ensp;<font color="#fffff">Privado | {0}: <font color="#fffff">{1}</font></div>',
        args = { playerName, msg }
    })
end
end)

RegisterNetEvent("cframework:announce", function(title, msg, sec)
	ESX.Scaleform.ShowMidSizedMessage(title, msg, sec)
end)



local disableMe = false

AddEventHandler('cframework:disableMe', function()
	disableMe = true
end)

AddEventHandler('cframework:enableMe', function()
	disableMe = false
end)


RegisterCommand('me', function(source, args, rawCommand)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(GetPlayerPed(-1)), 50)
	local serverSources = {}

	if disableMe then return end

	if IsEntityDead(PlayerPedId()) then
		return
    end

	for _, playerId in ipairs(players) do
		serverSources[GetPlayerServerId(playerId)] = true
	end

	TriggerServerEvent('3dme:shareDisplay', args, serverSources)
end, false)

RegisterNetEvent('3dme:forceDisplay', function(args)
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(GetPlayerPed(-1)), 50)
	local serverSources = {}

	for _, playerId in ipairs(players) do
		serverSources[GetPlayerServerId(playerId)] = true
	end

	TriggerServerEvent('3dme:shareDisplay', args, serverSources)
end)