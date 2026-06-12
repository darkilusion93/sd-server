local ESX					= nil
local killer 			= nil
local weapon 			= nil
local killername 	= nil
local deadname 		= nil
local dna 				= {}
local weapons = {
	[-1569615261] = {name = 'WEAPON_UNARMED', hash = 2725352035, text = 'Murro'},
	[-1716189206] = {name = 'WEAPON_KNIFE', hash = 2578778090, text = 'Faca'},
	[1737195953]  = {name = 'WEAPON_NIGHTSTICK', hash = 1737195953, text = 'Lanterna'},
	[2508868239]  = {name = 'WEAPON_BAT', hash = 2508868239, text = 'Bastão'},
	[1317494643]  = {name = 'WEAPON_HAMMER', hash = 1317494643, text = 'Martelo'},
	[1141786504]  = {name = 'WEAPON_GOLFCLUB', hash =1141786504, text = 'Taco de Golfe'},
	[2227010557]  = {name = 'WEAPON_CROWBAR', hash =2227010557, text = 'Pé de Cabra'},
	[2460120199]  = {name = 'WEAPON_DAGGER', hash =2460120199, text = 'Faca'},
	[3638508604]  = {name = 'WEAPON_KNUCKLE', hash =3638508604, text = 'Soco Inglês'},
	[4191993645]  = {name = 'WEAPON_HATCHET', hash =4191993645, text = 'Maxado'},
	[3713923289]  = {name = 'WEAPON_MACHETE', hash =3713923289, text = 'Machete'},
	[3756226112]  = {name = 'WEAPON_SWITCHBLADE', hash =3756226112, text = 'Faca'},
	[3441901897]  = {name = 'WEAPON_BATTLEAXE', hash =3441901897, text = 'Maxado'},
	[2484171525]  = {name = 'WEAPON_POOLCUE', hash =2484171525, text = 'Taco de Snooker'},
	[419712736]   = {name = 'WEAPON_WRENCH', hash =419712736, text = 'Chave Inglesa'}
}
local inMarker = false
local PlayerData = {}
local dnaOpen = false
local allowed = false
local ESX = nil
local job = nil
local grade = nil

RegisterNetEvent("core_evidence:permissao_cic")
AddEventHandler("core_evidence:permissao_cic", function(res)
    allowed = res
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    job = ESX.GetPlayerData().job.name
    grade = ESX.GetPlayerData().job.grade
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(j)
    job = j.name
    grade = j.grade
end)

function notification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    local shown = false
    local inDistance = false
    
    while true do
        Citizen.Wait(0)
        
        if (job == 'police' or job == 'sheriff' or job == 'state' and allowed) or job == 'pj' or job == 'siis' then
            local playerPed = GetPlayerPed(-1)
            local playerCoords = GetEntityCoords(playerPed)
            local v = Config.Computer
            
            local distanceToPos1 = GetDistanceBetweenCoords(playerCoords, v.Pos.x, v.Pos.y, v.Pos.z, true)
            local distanceToPos2 = GetDistanceBetweenCoords(playerCoords, v.Pos2.x, v.Pos2.y, v.Pos2.z, true)
        
            if v.Type ~= -1 then
                if distanceToPos1 < 50 then
                    DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end

                if distanceToPos2 < 50 then
                    DrawMarker(v.Type, v.Pos2.x, v.Pos2.y, v.Pos2.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
                end
            end
        
            if (distanceToPos1 < v.Size.x or distanceToPos2 < v.Size.x) then
                inDistance = true
            else
                inDistance = false
            end
        
            if inDistance then
                if not shown then
                    exports['okokTextUI']:Open('[E] DNA', 'darkblue', 'left')
                    shown = true
                end
                
                if IsControlJustReleased(0, 38) then
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = "open"
                    })
                end
            else
                if shown then
                    exports['okokTextUI']:Close()
                    shown = false
                end
            end
        else
            if shown then
                exports['okokTextUI']:Close()
                shown = false
            end
        end
    end
end)

RegisterNetEvent('jsfour-dna:remove')
AddEventHandler('jsfour-dna:remove', function()
	dna = {}
end)
RegisterNetEvent('jsfour-dna:get')
AddEventHandler('jsfour-dna:get', function(playerId)
    if dna.p == nil then
        local ped = GetPlayerPed(GetPlayerFromServerId(playerId))

        if IsPedFatallyInjured(ped) then
            local killerped = GetPedSourceOfDeath(ped)
            local killerid = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerped))
            local killername = GetPlayerName(NetworkGetPlayerIndexFromPed(killerped))

            local deadname = GetPlayerName(GetPlayerFromServerId(playerId))
            local _weapon = GetPedCauseOfDeath(ped)

            local weapon = nil
            for k, v in pairs(weapons) do
                if k == _weapon then
                    weapon = v.text
                    break
                end
            end

            Citizen.Wait(1000)

            if weapon then
                dna = {k = killername, d = playerId, w = weapon, p = killerid}
                ESX.ShowNotification('Você coletou uma amostra de DNA do corpo')
            else
                ESX.ShowNotification('Não foi possível encontrar DNA no corpo')
            end
        else
            dna = {k = nil, d = playerId, w = nil, p = playerId}
            ESX.ShowNotification('Você coletou uma amostra de DNA')
        end
    else
        ESX.ShowNotification('Você já tem uma amostra de DNA, por favor entregue-a no laboratório')
    end
end)

Citizen.CreateThread(function()
  while true do
    if dnaOpen then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) 
      DisableControlAction(0, 2, active) 
      DisableControlAction(0, 24, active) 
      DisablePlayerFiring(ply, true) 
      DisableControlAction(0, 142, active)
      DisableControlAction(0, 106, active) 
    end
    Citizen.Wait(0)
  end
end)

RegisterNetEvent('jsfour-dna:callback')
AddEventHandler('jsfour-dna:callback', function(_type, data, _type1, val)
	SendNUIMessage({
		action = _type,
		array = data,
		atype  = _type1,
		value = val
	})
	if data == 'upload-failed' then
		dna = {}
	end
end)

RegisterNUICallback('upload', function(data, cb)
	if dna.p ~= nil then
		TriggerServerEvent('jsfour-dna:save', dna)
		dna = {}
		cb('ok')
	else
		SendNUIMessage({
			action = "callback",
			array = 'upload-fail'
		})
		cb('error')
	end
end)

RegisterNUICallback('fetch', function(data, cb)
	TriggerServerEvent('jsfour-dna:fetch', data.type)
	cb('ok')
end)

RegisterNUICallback('remove', function(data, cb)
	if data.name ~= nil then
		TriggerServerEvent('jsfour-dna:remove', 'name', data.name)
	elseif data.id ~= nil then
		TriggerServerEvent('jsfour-dna:remove', 'id', data.id)
	elseif data.match ~= nil then
		TriggerServerEvent('jsfour-dna:remove', 'match', data.match)
	end
	cb('ok')
end)

RegisterNUICallback('match', function(data, cb)
	TriggerServerEvent('jsfour-dna:match', data.id)
	cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
	SetNuiFocus(false, false)
	dnaOpen = false
	cb('ok')
end)
