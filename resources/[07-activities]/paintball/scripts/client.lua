ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local playingPaintball = false
local queuing = false
local queueText = ''
local matchends = ''
local kills = 0
local deaths = 0
local iamdead = false

local queue_blue = 0
local queue_red = 0
local team = ''

local score_blue = 0 
local score_red = 0
local visao = 1

Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


RegisterNetEvent('loaf_paintball:filacheia')
AddEventHandler('loaf_paintball:filacheia', function()
	queuing = false
	exports['mythic_notify']:SendAlert('Error', 'Essa equipa está cheia', 4000)
end)

RegisterNetEvent('loaf_paintball:scoregeral')
AddEventHandler('loaf_paintball:scoregeral', function(a, b)
	score_blue = b
	score_red = a
end)


RegisterNetEvent('loaf_paintball:queueInfo')
AddEventHandler('loaf_paintball:queueInfo', function(text, other, b, r)
    queueText = text
    matchends = other
	queue_blue = b
	queue_red = r
end)

RegisterNetEvent('loaf_paintball:mataste')
AddEventHandler('loaf_paintball:mataste', function(s)
	kills = s
end)


RegisterNetEvent('loaf_paintball:hudNotify')
AddEventHandler('loaf_paintball:hudNotify', function(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, true)
end)

local teamBlips = {}

function CleanTeamBlips()
    if teamBlips then
        for k, blip in pairs(teamBlips) do
            if DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
    teamBlips = {} -- Reinicializa como tabela vazia
end

RegisterNetEvent('loaf_paintball:start')
AddEventHandler('loaf_paintball:start', function(random123)
    local ped = PlayerPedId()
    
    TriggerServerEvent('esx:paintball_startmatch')
    
    -- Teus originais mantidos
    visao = (random123 > 3) and 1 or 4
    queuing = false 
    playingPaintball = true
    deaths = 0
    kills = 0
    
    -- Voz e Rádio mantidos
    TriggerEvent('voice:paintball', (team == 'blue' and 288) or 289)
    
    -- Troca de roupa mantida
    if Config.Clothes.ChangeClothes then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local outfit = (skin.sex == 0) and Config.Clothes.Outfits[team]['male'] or Config.Clothes.Outfits[team]['female']
            TriggerEvent('skinchanger:loadClothes', skin, outfit)
        end)
    end

    -- Sistema de Teleporte Anti-Queda
    Citizen.CreateThread(function()
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do Citizen.Wait(0) end

        local spawnPos = Config.SpawnPoints[team][math.random(1, #Config.SpawnPoints[team])]
        
        -- Congelar e forçar posição repetidamente enquanto carrega
        FreezeEntityPosition(ped, true)
        
        local attempts = 0
        while not HasCollisionLoadedAroundEntity(ped) and attempts < 100 do
            attempts = attempts + 1
            -- Forçamos as coords no loop para o jogo não te "soltar" no mar
            SetEntityCoords(ped, spawnPos.x, spawnPos.y, spawnPos.z, false, false, false, false)
            RequestCollisionAtCoord(spawnPos.x, spawnPos.y, spawnPos.z)
            Citizen.Wait(100)
        end

        -- Posicionamento final com ajuste de solo
        SetEntityCoords(ped, spawnPos.x, spawnPos.y, spawnPos.z)
        ClearPedBloodDamage(ped)
        
        Citizen.Wait(4000) -- Tempo extra de segurança
        
        DoScreenFadeIn(1000)
        FreezeEntityPosition(ped, false)
    end)
end)

-- LOOP DOS BLIPS (Adicionar no fim do ficheiro)
Citizen.CreateThread(function()
    while true do
        local wait = 2000
        if playingPaintball then
            wait = 500
            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetId = GetPlayerServerId(player)
                
                if targetPed ~= PlayerPedId() then
                    -- Verifica se o estado da equipa vindo do servidor coincide com a tua
                    local targetTeam = Entity(targetPed).state.paintball_team
                    
                    if targetTeam == team then 
                        if not DoesBlipExist(teamBlips[targetId]) then
                            local blip = AddBlipForEntity(targetPed)
                            SetBlipSprite(blip, 1) -- Seta
                            SetBlipColour(blip, (team == 'blue' and 3 or 1))
                            SetBlipScale(blip, 0.7)
                            SetBlipAsShortRange(blip, true)
                            
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentSubstringPlayerName("Aliado")
                            EndTextCommandSetBlipName(blip)
                            
                            teamBlips[targetId] = blip
                        end
                    end
                end
            end
        else
            if next(teamBlips) then
                for k, v in pairs(teamBlips) do RemoveBlip(v) end
                teamBlips = {}
            end
        end
        Citizen.Wait(wait)
    end
end)

RegisterNetEvent('loaf_paintball:stop')
AddEventHandler('loaf_paintball:stop', function()
    playingPaintball = false
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(Config.Weapon))
    SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    deaths = 0
    kills = 0
    queuing = false
    if Config.Clothes.ChangeClothes then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end)

RegisterNetEvent('loaf_paintball:matchOver')
AddEventHandler('loaf_paintball:matchOver', function(me, vencedor, pblue, pred, var1)
    if Config.RemoveWeapon then
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Config.Weapon))
    end
    
    TriggerEvent('mythic_hospital:client:RemoveBleed') 
    TriggerEvent('mythic_hospital:client:ResetLimbs')
    SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
    
    playingPaintball = false
    SetPedInfiniteAmmo(PlayerPedId(), false, GetHashKey(Config.Weapon))
    TriggerEvent('voice:paintball', 'sair')
    
    
    kills = 0
    deaths = 0
    score_blue = 0
    score_red = 0
    
    me = json.decode(me)
    local timer = GetGameTimer() + (Config.DisplayWinner * 1000)

    
    if var1 > 0 then
        SetEntityCoords(PlayerPedId(), Config.WinnerPosition[1])
        FreezeEntityPosition(PlayerPedId(), true)

        local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
        SetCamCoord(cam, Config.WinnerCam.x, Config.WinnerCam.y, Config.WinnerCam.z)
        RenderScriptCams(1, 0, 0, 1, 1)
        ClearPedBloodDamage(PlayerPedId())

        while timer >= GetGameTimer() do
            Wait(0)
            SetEntityHeading(PlayerPedId(), Config.WinnerHeading)
            for i = 0, 31 do DisableAllControlActions(i) end
            PointCamAtEntity(cam, PlayerPedId(), 0.0, 0.0, 0.0, true)
            
            
            drawText((Config.Translations['won']):format(Config.Translations[vencedor], pblue, pred, me.kills, me.deaths), 0.15, 0.75)
        end
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
    else
        
        SetEntityVisible(PlayerPedId(), false, false)
        local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
        SetCamCoord(cam, Config.WinnerCam.x, Config.WinnerCam.y, Config.WinnerCam.z)
        RenderScriptCams(1, 0, 0, 1, 1)

        while timer >= GetGameTimer() do
            Wait(0)
            for i = 0, 31 do DisableAllControlActions(i) end
            
            if var1 == -1 then
                drawText((Config.Translations['tie']):format(pblue, pred, me.kills, me.deaths), 0.15, 0.70)
            else
                drawText((Config.Translations['won']):format(Config.Translations[vencedor], pblue, pred, me.kills, me.deaths), 0.15, 0.70)
            end
        end
        SetEntityVisible(PlayerPedId(), true, false)
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
    end

    
    SetEntityCoords(PlayerPedId(), Config.JoinCircle)
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)
    if Config.Clothes.ChangeClothes then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
end)

RegisterNetEvent('loaf_paintball:died')
AddEventHandler('loaf_paintball:died', function(killedBy)
    deaths = deaths + 1
    local timer = GetGameTimer() + 10000
    SetTimecycleModifier("BlackOut")
    SetEntityHasGravity(PlayerPedId(), false)

    local coordsFrom = GetEntityCoords(PlayerPedId())

    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    SetCamCoord(cam, coordsFrom.x, coordsFrom.y, coordsFrom.z)
    RenderScriptCams(1, 0, 0, 1, 1)

    SetEntityCoords(PlayerPedId(), GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z+5.0)
    Citizen.CreateThread(function()
        while timer >= GetGameTimer() and playingPaintball do
            SetCamFov(cam, GetCamFov(cam) - 0.1)
            Wait(50)
        end
    end)
    while timer >= GetGameTimer() and playingPaintball do
        Wait(0)
        PointCamAtEntity(cam, GetPlayerPed(GetPlayerFromServerId(killedBy)), 0.0, 0.0, 0.0, true)
        SetEntityVisible(PlayerPedId(), false, false)
        for i = 0, 31 do
            DisableAllControlActions(i)
        end
    end
    
	local cordsraa = Config.SpawnPoints[team][math.random(1, #Config.SpawnPoints[team])]
	if playingPaintball then
        DoScreenFadeOut(0)
		Citizen.Wait(10)
		RenderScriptCams(false, false, 0, true, false)
		DestroyCam(cam)
        SetEntityCoords(PlayerPedId(), cordsraa)			
    end
	

	StopScreenEffect('DeathFailOut')
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityHasGravity(PlayerPedId(), true)
	SetEntityInvincible(PlayerPedId(), true)
    SetPlayerInvincible(PlayerId(), true)
	SetLocalPlayerAsGhost(true)
    ClearTimecycleModifier()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
	Citizen.Wait(1000)
	DoScreenFadeIn(2000)
	Citizen.Wait(3000)
	SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)	
	SetLocalPlayerAsGhost(false)
	iamdead = false
	TriggerEvent('mythic_hospital:client:RemoveBleed') 
	TriggerEvent('mythic_hospital:client:ResetLimbs')
end)

Citizen.CreateThread(function()
    while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Wait(0) end
    while not NetworkIsSessionStarted() or ESX.GetPlayerData().job == nil do Wait(0) end

    local blip = AddBlipForCoord(Config.JoinCircle)
    SetBlipSprite(blip, 313)
    SetBlipColour(blip, 8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Paintball')
    EndTextCommandSetBlipName(blip)
	
    while true do
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.JoinCircle, true) <= 20.0 then
            --DrawMarker(1, Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 12.5, 12.5, 0.1, 50, 255, 50, 150, false, true, 2, false, false, false, false)
			

		   if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.JoinCircle, true) <= 7.5 then
                if queueText ~= Config.Translations['match_progress'] then
                    if not queuing then
                        DrawMarker(20, Config.RCircle.x, Config.RCircle.y, Config.RCircle.z+0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 220, 0, 0, 200, false, true, 2, true, false, false, false)
						DrawMarker(20, Config.BCircle.x, Config.BCircle.y, Config.BCircle.z+0.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.5, 0.4, 0.3, 0, 100, 220, 200, false, true, 2, true, false, false, false)
						DrawText3D2(Config.BCircle.x, Config.BCircle.y, Config.BCircle.z+1.2, "~b~[~s~E~b~]~s~ Equipa Azul ("..Config.Price.."€)")
						DrawText3D2(Config.RCircle.x, Config.RCircle.y, Config.RCircle.z+1.2, "~r~[~s~E~r~]~s~ Equipa Vermelha ("..Config.Price.."€)")
						
						DrawText3D2(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+2.0, (Config.Translations['join_paintball']))
						drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.7), queueText)
                    else
                        drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), (Config.Translations['leave_paintball']):format(queueText))
                    end
                    if IsControlJustReleased(0, 38) then
                        
						if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.BCircle, true) <= 2.5 then
							queuing = not queuing
							team = 'blue'
							TriggerServerEvent('loaf_paintball:join', team)
						elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.RCircle, true) <= 2.5 then
							queuing = not queuing
							team = 'red'
							TriggerServerEvent('loaf_paintball:join', team)
						end
                    end
                else
                    drawText3D(vector3(Config.JoinCircle.x, Config.JoinCircle.y, Config.JoinCircle.z+1.0), (Config.Translations['match_in_progress']):format(queueText, math.floor(matchends)))
                end
            else
                if queuing then
                    queuing = false
                    TriggerServerEvent('loaf_paintball:join')
                    Citizen.CreateThread(function()
                        notify(Config.Translations['left_paintball'], 3)
                    end)
                end
            end
        end
        Wait(5)
    end
end)

Citizen.CreateThread(function()
    local sleep = 1000
	
	while true do
        sleep = 1000
        if playingPaintball then
            sleep = 0
            local playerPed = GetPlayerPed(-1)

			if type(matchends) == 'number' then
                drawText((Config.Translations['match_ends']):format(math.floor(tonumber(matchends-Config.DisplayWinner)), tostring(score_red), tostring(score_blue), kills, deaths), 0.015, 0.015)
				
				drawText(Config.Translations[team..'1'], 0.049, 0.805)
            else
                drawText((Config.Translations['match_ends']):format(matchends, tostring(score_red), tostring(score_blue), kills, deaths ), 0.015, 0.015)
				
				drawText(Config.Translations[team..'1'], 0.049, 0.805)
            end
            if Config.ForceFirstPerson then
                --if IsPlayerFreeAiming(PlayerId()) then
				--	SetFollowPedCamViewMode(4)
				--else
					SetFollowPedCamViewMode(visao)
				--end
            end

            if not HasPedGotWeapon(PlayerPedId(), GetHashKey(Config.Weapon), false) then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(Config.Weapon), 250, false, true)
            end
            SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(Config.Weapon))
			
			if GetSelectedPedWeapon(PlayerPedId()) ~= GetHashKey(Config.Weapon) then
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey(Config.Weapon), true)
			end
			
			DisableControlAction(0, Keys['TAB'], true) -- Select Weapon
			DisableControlAction(0, Keys['F1'], true)
			DisableControlAction(0, Keys['F2'], true) -- Inventory
			DisableControlAction(0, Keys['F3'], true) -- Animations
			DisableControlAction(0, Keys['F5'], true) -- Disable phone
			DisableControlAction(0, Keys['F6'], true) -- Job
			DisableControlAction(0, Keys['F7'], true) -- Job
			DisableControlAction(0, Keys['Z'], true) -- Job
			DisableControlAction(0, Keys['1'], true) -- Job
			DisableControlAction(0, Keys['2'], true) -- Job
			DisableControlAction(0, Keys['3'], true) -- Job
			DisableControlAction(0, Keys['4'], true) -- Job
			DisableControlAction(0, Keys['5'], true) -- Job
			DisableControlAction(0, Keys['6'], true) -- Job
			DisableControlAction(0, Keys['7'], true) -- Job
			DisableControlAction(0, Keys['8'], true) 
			DisableControlAction(0, Keys['9'], true)
			DisableControlAction(0, Keys['V'], true)
			DisableControlAction(0, Keys['K'], true)
			
			if IsPedSwimming(playerPed) then
				SetEntityHealth(PlayerPedId(), 0)
			end
			
			if IsPedDeadOrDying(PlayerPedId()) and iamdead == false then
				iamdead = true
				local killerped = GetPedSourceOfDeath(GetPlayerPed(-1))
				local killerid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerped))
				
				
				local coords = GetEntityCoords(PlayerPedId(), true)
				NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0.0, true, false)	
				TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, 0.0)				
				
				TriggerServerEvent('loaf_paintball:kill', killerid, team)	
				SetEntityInvincible(PlayerPedId(), true)
				SetPlayerInvincible(PlayerId(), true)			
			end
        else
            if HasPedGotWeapon(PlayerPedId(), GetHashKey(Config.Weapon), false) and Config.RemoveWeapon then
                RemoveWeaponFromPed(PlayerPedId(), GetHashKey(Config.Weapon))
                notify(Config.Translations['gun_removed'], 5)
            end
        end
        Wait(sleep)
    end
end)

notify = function(text, length)
    local wait = GetGameTimer()+length*1000
    while wait >= GetGameTimer() do
        Wait(0)
        drawText3D(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.4), text)
    end
end

drawText = function(text, x, y)
    SetTextColour(255, 255, 255, 255)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextWrap(0.0, 1.0)
    SetTextCentre(false)
    SetTextOutline()
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

drawText3D = function(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function DrawText3D2(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
