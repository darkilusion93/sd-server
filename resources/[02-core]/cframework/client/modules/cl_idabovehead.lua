

local disPlayerNames = 5
local playerDistances = {}
local IsAdminMod = false
local showId = false
local group = 'user'

RegisterNetEvent('esx:playerLoaded', function(player)
	group = player.group
end)

RegisterNetEvent("cframework:enterAdmin", function(id, name)
    IsAdminMod = true
end)

RegisterNetEvent("cframework:leaveAdmin", function(id, name)
    IsAdminMod = false
end)

local function DrawText3D(x,y,z, text, r,g,b, id) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r	, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(text)
        DrawText(_x,_y)
    end
end

local function DrawText3DHouse(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz)-vector3(x,y,z))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r	, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(text)
        DrawText(_x,_y)
    end
end

local letSleep = true
local instanced = false

AddEventHandler('cframework:toggleHouseIds', function(show)
    if group == 'user' then return end

    showId = show
    Citizen.CreateThread(function()
        while showId do
            Citizen.Wait(0)
            letSleep = true
            if not instanced and IsAdminMod then
                for k,v in pairs(Config.properties) do
                    if #(GetEntityCoords(PlayerPedId()) - v.entrance) < 40 then
                        letSleep = false
                        DrawText3DHouse(v.entrance.x, v.entrance.y, v.entrance.z+1, T("GENERIC_HOUSE_ID"):format(k), 255,255,255)
                    end
                end
            end
            if letSleep then
                Citizen.Wait(500)
            end
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        for _, id in ipairs(GetActivePlayers()) do
            if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                distance = math.floor(#(vector3(x1,  y1,  z1)-vector3(x2,  y2,  z2)))
				playerDistances[id] = distance
            end
        end
        Citizen.Wait(1000)
    end
end)


local showID = false
local timerActive = false

RegisterCommand('+showid', function()
    showID = true

    Citizen.CreateThread(function()
        while showID do
            Citizen.Wait(0)
            for _, id in ipairs(GetActivePlayers()) do
                if GetPlayerPed(id) ~= GetPlayerPed(-1) then
                    if playerDistances[id] and IsEntityVisible(GetPlayerPed(id)) == 1 then
                        if (playerDistances[id] < disPlayerNames) then
                            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))
                            if NetworkIsPlayerTalking(id) then
                                DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 0, 208, 255, id)
                            else
                                DrawText3D(x2, y2, z2+1, GetPlayerServerId(id), 255,255,255, id)
                            end
                        elseif (playerDistances[id] < 25) then
                            x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(id), true))						
                            if NetworkIsPlayerTalking(id) then
                            end
                        end
                    end
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        timerActive = true -- Mark the timer as active
        local elapsed = 0
        while showID and timerActive do
            Citizen.Wait(100) -- Check every 100ms
            elapsed = elapsed + 100
            if elapsed >= 5000 then
                showID = false
                timerActive = false -- Reset the timer
            end
        end
    end)
end, false)

RegisterCommand('-showid', function()
    showID = false
    timerActive = false -- Stop the timer
end, false)

RegisterKeyMapping('+showid', 'ID', 'keyboard', 'HOME')