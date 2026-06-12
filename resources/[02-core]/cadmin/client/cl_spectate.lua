ESX = nil

local adminCommandsDisabled = true
local InSpectatorMode	= false
local TargetSpectate	= nil
local LastPosition		= nil
local polarAngleDeg		= 0;
local azimuthAngleDeg	= 90;
local radius			= -3.5;
local cam 				= nil
local PlayerDate		= {}
local ShowInfos			= false
local group = 'user'
local debounceKey = false

Citizen.CreateThread(function()
	while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Wait(0)
	end

	exports.ft_libs:RemoveButton("esx:spectate")
	exports.ft_libs:AddButton("esx:spectate", {
		key = 163,
		use = {
	  		callback = openSpec,
		},
	})
end)

RegisterNetEvent('cframework:disableAdminCommands', function()
	adminCommandsDisabled = true

	if InSpectatorMode then
		resetNormalCamera()
	end
end)

RegisterNetEvent('cframework:enableAdminCommands', function()
	adminCommandsDisabled = false
end)

RegisterNetEvent("cframework:spectate", function(target)
    if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end
    spectate(target, false)
end)

function spectate(target, customCam)
	if InSpectatorMode then
		resetNormalCamera()
	end

	if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end

	ESX.TriggerServerCallback("cframework:getSpectateData", function(player, pCoords)
		if not InSpectatorMode then
			LastPosition = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('cframework:saveLastProperty', {x = LastPosition.x, y = LastPosition.y, z = LastPosition.z})
		end

		local playerPed = GetPlayerPed(-1)

		SetEntityCollision(playerPed, false, false)
		SetEntityVisible(playerPed, false, false)
		--print(player.coords.x)

		SetEntityCoords(playerPed, pCoords.x, pCoords.y, pCoords.z + 10.0, false, false, false, false)

		PlayerData = player
		if ShowInfos then
			SendNUIMessage({
				type = 'infos',
				data = PlayerData
			})	
		end

		Citizen.CreateThread(function()
			InSpectatorMode = true
			TargetSpectate  = target
            TriggerEvent("mumble:voip:setSpectateTarget", TargetSpectate)

			Citizen.CreateThread(function()
				while InSpectatorMode do
				  Wait(0)
				  if InSpectatorMode then
                        local targetPlayerId = GetPlayerFromServerId(TargetSpectate)
                        local playerPed	  = GetPlayerPed(-1)
                        local targetPed	  = GetPlayerPed(targetPlayerId)
                        local coords	 = GetEntityCoords(targetPed)

                        HudWeaponWheelIgnoreSelection()

                        if IsControlPressed(2, 241) then
                            radius = radius + 2.0;
                        end

                        if IsControlPressed(2, 242) then
                            radius = radius - 2.0;
                        end

                        SetGameplayCamFollowPedThisUpdate(targetPed)

                        if DoesEntityExist(targetPed) then
                            SetEntityCoords(playerPed,  coords.x, coords.y, coords.z + 10.0, false, false, false, false)
                        else
                            SetEntityCoords(playerPed,  pCoords.x, pCoords.y, pCoords.z + 10.0, false, false, false, false)
                        end

                        if IsControlPressed(2, 47) and not debounceKey then
                            debounceKey = true
                            OpenAdminActionMenu(targetPlayerId)
                        elseif debounceKey then
                            debounceKey = false
                        end

                        local text = {}
                        -- cheat checks
                        local targetGod = GetPlayerInvincible(targetPlayerId)
                        if targetGod then
                            table.insert(text,"Godmode: ~r~Found~w~")
                        else
                            table.insert(text,"Godmode: ~g~Not Found~w~")
                        end
                        if not CanPedRagdoll(targetPed) and not IsPedInAnyVehicle(targetPed, false) and (GetPedParachuteState(targetPed) == -1 or GetPedParachuteState(targetPed) == 0) and not IsPedInParachuteFreeFall(targetPed) then
                            table.insert(text,"~r~Anti-Ragdoll~w~")
                        end
                        -- health info
                        table.insert(text,"Health"..": "..GetEntityHealth(targetPed).."/"..GetEntityMaxHealth(targetPed))
                        table.insert(text,"Armor"..": "..GetPedArmour(targetPed))

                        for i,theText in pairs(text) do
                            SetTextFont(0)
                            SetTextProportional(true)
                            SetTextScale(0.0, 0.30)
                            SetTextDropshadow(0, 0, 0, 0, 255)
                            SetTextEdge(1, 0, 0, 0, 255)
                            SetTextDropShadow()
                            SetTextOutline()
                            SetTextEntry("STRING")
                            AddTextComponentSubstringPlayerName(theText)
                            EndTextCommandDisplayText(0.3, 0.7+(i/30))
                        end
		  -- end of taken from easyadmin -- 
				    end
				end

                TriggerEvent("mumble:voip:setSpectateTarget", nil)
                TriggerServerEvent('cframework:saveLastProperty', nil)
		  end)

		end)
	end, target)
end

RegisterNetEvent("cframework:exitSpectate", function()
    resetNormalCamera(true)
end)

function resetNormalCamera(customCam)
	InSpectatorMode = false
	TargetSpectate  = nil
	local playerPed = GetPlayerPed(-1)

    if not customCam then
        SetEntityCollision(playerPed, true, true)
        SetEntityVisible(playerPed, true, false)

        if LastPosition == nil then return end

        SetEntityCoords(playerPed, LastPosition.x, LastPosition.y, LastPosition.z, false, false, false, false)
        TriggerServerEvent('cframework:deleteLastProperty')
    end

	TriggerServerEvent("cframework:exitSpectate")
end

RegisterNetEvent('esx_spectate:getPlayers')
AddEventHandler('esx_spectate:getPlayers', function(data)
	if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end

	TriggerScreenblurFadeIn(250.0)
	SetNuiFocus(true, true)

	SendNUIMessage({
		type = 'show',
		data = data,
		player = GetPlayerServerId(PlayerId())
	})
end)

function OpenAdminActionMenu(player)
    if ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'citizen_interaction') then
        return
    end

    ESX.TriggerServerCallback('esx_spectate:getOtherPlayerData', function(data)
        local jobLabel    = nil
        local sexLabel    = nil
        local sex         = nil
        local dobLabel    = nil
        local heightLabel = nil
        local idLabel     = nil
        local Bank		= data.bank
        local blackMoney	= 0
        local Inventory	= nil

        for k,v in pairs(data.accounts) do
            if v.name == 'black_money' then
                blackMoney = v.money
            end
        end

        if data.job.grade_label ~= nil and  data.job.grade_label ~= '' then
            jobLabel = 'Job : ' .. data.job.label .. ' - ' .. data.job.grade_label
        else
            jobLabel = 'Job : ' .. data.job.label
        end

        if data.sex ~= nil then
            if (data.sex == 'm') or (data.sex == 'M') then
                sex = 'Male'
            else
                sex = 'Female'
            end
            sexLabel = 'Sex : ' .. sex
        else
            sexLabel = 'Sex : Unknown'
        end

        if data.dob ~= nil then
            dobLabel = 'DOB : ' .. data.dob
        else
            dobLabel = 'DOB : Unknown'
        end

        if data.height ~= nil then
            heightLabel = 'Height : ' .. data.height
        else
            heightLabel = 'Height : Unknown'
        end

        local elements = {
            {label = 'Nome: ' .. data.firstname .. " " .. data.lastname, value = nil},
            {label = 'Banco: '.. ESX.formatAsCurrency(Bank), value = nil, itemType = 'item_account', amount = Bank},
            {label = jobLabel,    value = nil},
            {label = "Nome Steam: " .. data.name,     value = nil},
            {label = 'Tempo de Jogo: ' .. ESX.formatTime(data.playtime), value = nil},
        }

        if data.comserv > 0 then
            table.insert(elements, {label = 'Comserv: ' .. data.comserv, value = nil})
        end

        table.insert(elements, {label = 'Abrir Inventário', action = "openinventory", value = data.source})

        if data.licenses ~= nil then
            table.insert(elements, {label = '--- Licenses ---', value = nil})

            for i=1, #data.licenses, 1 do
                table.insert(elements, {label = data.licenses[i].label, value = nil})
            end

        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction',
            {
                title    = 'Player Control',
                align    = 'top-left',
                elements = elements,
            },
            function(data, menu)
                if data.current.action and data.current.action == 'openinventory' then
                    menu.close()
                    TriggerEvent("cframework:openPlayerInventory", data.current.value, GetPlayerName(player))
                end
            end,
            function(data, menu)
                menu.close()
            end
        )
    end, GetPlayerServerId(player))
end

function openSpec()
	if group ~= "user" then
		if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end
		TriggerEvent('esx_spectate:spectate')
	end
end

RegisterNetEvent('esx:playerLoaded', function(player)
	group = player.group
end)

RegisterNetEvent('esx_spectate:spectate')
AddEventHandler('esx_spectate:spectate', function()
	if group ~= "user" then
		if adminCommandsDisabled then ESX.ShowNotification('Comando desativado.', 'error') return end
		TriggerServerEvent('esx_spectate:getPlayers')
	end
end)

RegisterNUICallback('select', function(data, cb)
	print("select UI " .. json.encode(data))

    TriggerEvent("cframework:stopMapperImmediatly")

	spectate(data.id, false)
	TriggerScreenblurFadeOut(250.0)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('close2', function(data, cb)
	print("closing UI")
	TriggerScreenblurFadeOut(250.0)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('quit', function(data, cb)
	TriggerScreenblurFadeOut(250.0)
	SetNuiFocus(false, false)
	resetNormalCamera(false)
end)

RegisterNUICallback('kick', function(data, cb)
	TriggerScreenblurFadeOut(250.0)
	SetNuiFocus(false, false)
	TriggerServerEvent('esx_spectate:kick', data.id, data.reason)
	TriggerEvent('esx_spectate:spectate')
end)
