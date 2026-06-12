ESX = nil
local pos_before_assist,assisting,assist_target,last_assist,IsFirstSpawn = nil, false, nil, nil, true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	SetNuiFocus(false, false)
end)

function GetIndexedPlayerList()
	local players = {}
	for k,v in ipairs(GetActivePlayers()) do
		players[tostring(GetPlayerServerId(v))]=GetPlayerName(v)..(v==PlayerId() and " (self)" or "")
	end
	return json.encode(players)
end

RegisterNUICallback("ban", function(data,cb)
	if not data.target or not data.reason then return end
	ESX.TriggerServerCallback("el_bwh:ban",function(success,reason)
		if success then ESX.ShowNotification("Banido com sucesso") else ESX.ShowNotification(reason) end -- dont ask why i did it this way, im a bit retarded
	end, data.target, data.reason, data.length, data.offline)
end)

RegisterNUICallback("warn", function(data,cb)
	if not data.target or not data.message then return end
	ESX.TriggerServerCallback("el_bwh:warn",function(success)
		if success then ESX.ShowNotification("Avisado com sucesso") else ESX.ShowNotification("~r~Something went wrong") end
	end, data.target, data.message, data.anon)
end)

RegisterNUICallback("unban", function(data,cb)
	if not data.id then return end
	ESX.TriggerServerCallback("el_bwh:unban",function(success)
		if success then ESX.ShowNotification("Unban com sucesso") else ESX.ShowNotification("~r~Something went wrong") end
	end, data.id)
end)

RegisterNUICallback("getListData", function(data,cb)
	if not data.list or not data.page then cb(nil); return end
	ESX.TriggerServerCallback("el_bwh:getListData",function(data)
		cb(data)
	end, data.list, data.page, data.search)
end)

RegisterNUICallback("hidecursor", function(data,cb)
    TriggerScreenblurFadeOut(250.0)
	SetNuiFocus(false, false)
end)

AddEventHandler("playerSpawned", function(spawn)
    if IsFirstSpawn and Config.backup_kick_method then
		TriggerServerEvent("el_bwh:backupcheck")
        IsFirstSpawn = false
    end
end)

RegisterNetEvent("el_bwh:gotBanned")
AddEventHandler("el_bwh:gotBanned",function(rsn)
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(0) end
		BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		ScaleformMovieMethodAddParamTextureNameString("~r~BANNED")
		ScaleformMovieMethodAddParamTextureNameString(rsn)
		ScaleformMovieMethodAddParamInt(5)
		EndScaleformMovieMethod()
		PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", false)
		ClearDrawOrigin()
		ESX.UI.HUD.SetDisplay(0)
		while true do
			Citizen.Wait(0)
			DisableAllControlActions(0)
			DisableFrontendThisFrame()
			local ped = GetPlayerPed(-1)
			ESX.UI.Menu.CloseAll()
			SetEntityCoords(ped, 0, 0, 0, false, false, false, false)
			FreezeEntityPosition(ped, true)
			DrawRect(0.0,0.0,2.0,2.0,0,0,0,255)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
	end)
end)

RegisterNetEvent("el_bwh:receiveWarn")
AddEventHandler("el_bwh:receiveWarn",function(sender,message)
	TriggerEvent("chat:addMessage",{color={255,255,0},multiline=true,args={"BWH","You received a warning"..(sender~="" and " from "..sender or "").."!\n-> "..message}})
	Citizen.CreateThread(function()
		local scaleform = RequestScaleformMovie("mp_big_message_freemode")
		while not HasScaleformMovieLoaded(scaleform) do Citizen.Wait(0) end
		BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		ScaleformMovieMethodAddParamTextureNameString("~y~WARNING")
		ScaleformMovieMethodAddParamTextureNameString(message)
		ScaleformMovieMethodAddParamInt(5)
		EndScaleformMovieMethod()
		PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", false)
		local drawing = true
		Citizen.SetTimeout((Config.warning_screentime * 1000),function() drawing = false end)
		while drawing do
			Citizen.Wait(0)
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		end
		SetScaleformMovieAsNoLongerNeeded(scaleform)
	end)
end)

RegisterNetEvent("el_bwh:requestedAssist")
AddEventHandler("el_bwh:requestedAssist",function(t, name)
	--SendNUIMessage({show=true,window="assistreq",data=Config.popassistformat:format(name,t)})
	last_assist=t
end)

RegisterNetEvent("el_bwh:acceptedAssist")
AddEventHandler("el_bwh:acceptedAssist",function(t)
	if assisting then return end
	local target = GetPlayerFromServerId(t)
	if target then
		--local ped = GetPlayerPed(-1)
		--pos_before_assist = GetEntityCoords(ped)
		assisting = true
		assist_target = t
		--ESX.Game.Teleport(ped,GetEntityCoords(GetPlayerPed(target))+vector3(0,0.5,0))
	end
end)

RegisterNetEvent("el_bwh:assistDone")
AddEventHandler("el_bwh:assistDone",function()
	if assisting then
		assisting = false
		if pos_before_assist~=nil then ESX.Game.Teleport(GetPlayerPed(-1),pos_before_assist+vector3(0,0.5,0)); pos_before_assist = nil end
		assist_target = nil
	end
end)

RegisterNetEvent("el_bwh:hideAssistPopup")
AddEventHandler("el_bwh:hideAssistPopup",function(t)
	--SendNUIMessage({hide=true})
	last_assist=nil
end)

RegisterNetEvent("el_bwh:showWindow")
AddEventHandler("el_bwh:showWindow",function(win)
    TriggerScreenblurFadeIn(250.0)

	if win=="ban" or win=="warn" then
		SendNUIMessage({show=true,window=win,players=GetIndexedPlayerList()})
	elseif win=="banlist" or win=="warnlist" then
		SendNUIMessage({loading=true,window=win})
		ESX.TriggerServerCallback(win=="banlist" and "el_bwh:getBanList" or "el_bwh:getWarnList",function(list,pages)
			SendNUIMessage({show=true,window=win,list=list,pages=pages})
		end)
	end
	SetNuiFocus(true, true)
end)

RegisterCommand("negar",function(a,b,c)
	TriggerEvent("el_bwh:hideAssistPopup")
end, false)

if Config.assist_keys.enable then
	Citizen.CreateThread(function()
		exports.ft_libs:RemoveButton("esx:el_bwh_1")
        exports.ft_libs:AddButton("esx:el_bwh_1", {
            key = Config.assist_keys.accept,
            use = {
            	callback = aceitar,
            },
		})
		exports.ft_libs:RemoveButton("esx:el_bwh_2")
		exports.ft_libs:AddButton("esx:el_bwh_2", {
			key = Config.assist_keys.decline,
			use = {
				callback = negar,
			},
		})
	end)
end

function aceitar()
	--TriggerServerEvent("el_bwh:acceptAssistKey",last_assist)
	ExecuteCommand('aceitar')
end

function negar()
	TriggerEvent("el_bwh:hideAssistPopup")
end
--[[Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/negar', 'Hide assist popup',{})
    TriggerEvent('chat:addSuggestion', '/assist', 'Request help from admins',{{name="Reason", help="Why do you need help?"}})
    TriggerEvent('chat:addSuggestion', '/cassist', 'Cancel your pending help request',{})
    TriggerEvent('chat:addSuggestion', '/finassist', 'Finish assist and tp back',{})
    TriggerEvent('chat:addSuggestion', '/accassist', 'Accept a players help request', {{name="Player ID", help="ID of the player you want to help"}})
end)]]
