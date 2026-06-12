ESX                           = {}
ESX.PlayerData                = {}
ESX.PlayerLoaded              = false
ESX.CurrentRequestId          = 0
ESX.ServerCallbacks           = {}
ESX.TimeoutCallbacks          = {}
ESX.Items                     = {}

ESX.UI                        = {}
ESX.UI.HUD                    = {}
ESX.UI.HUD.RegisteredElements = {}
ESX.UI.Menu                   = {}
ESX.UI.Menu.RegisteredTypes   = {}
ESX.UI.Menu.Opened            = {}

ESX.Game                      = {}
ESX.Game.Utils                = {}

ESX.Scaleform                 = {}
ESX.Scaleform.Utils           = {}

ESX.Streaming                 = {}

AddEventHandler('cframework:getData', function(cb, id)
	if id ~= 1 then
		TriggerServerEvent("cframework:areport3", 'cframework:getData')
	end
	cb(ESX)
end)

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

AddEventHandler('esx:getShbuedaloucoaredObjbuedaloucoect', function(cb)
	cb(ESX)
end)

function getSharedObject()
	return ESX
end

exports('getShbuedaloucoaredObjbuedaloucoect', function()
	return ESX
end)

function SetupInstructionalButtons(buttons)
	local scaleform = RequestScaleformMovie("instructional_buttons")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	local i = 0
	for _, button in pairs(buttons) do
		PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
		PushScaleformMovieFunctionParameterInt(i)
		PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, button.key, true))
		BeginTextCommandScaleformString("STRING")
		AddTextComponentScaleform(button.label)
		EndTextCommandScaleformString()
		PopScaleformMovieFunctionVoid()
		i = i + 1
	end

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(70)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

-- PlaySoundFromCoord
AddEventHandler('cframework:PlaySoundFromCoords', function(audioName, audioRef, coords, players, audioBank, times, sleep)
    if type(players) == 'number' then
        players = ESX.Game.GetPlayersServerIdsInArea(coords, players, true)
    end
    if (type(players) == 'table' and #players == 0) or (type(players) ~= 'table' and type(players) ~= 'nil') then return end
    if type(players) == 'table' and #players == 1 and players[1] == GetPlayerServerId(PlayerId()) then
        TriggerEvent('cframework:PlaySoundFromCoordsClient', audioName, audioRef, coords, audioBank, times, sleep)
    else
        TriggerServerEvent('cframework:PlaySoundFromCoords', audioName, audioRef, coords, players, audioBank, times, sleep)
    end
end)

RegisterNetEvent('cframework:PlaySoundFromCoordsClient', function(audioName, audioRef, coords, players, audioBank, times, sleep)
    if audioBank then
        while not RequestScriptAudioBank(audioBank, false) do Citizen.Wait(0) end
    end
    for _=1, times or 1 do
        local soundId = ((times and times > 1 and not sleep) or (not times and sleep)) and GetSoundId() or -1
        PlaySoundFromCoord(soundId, audioName, coords.x, coords.y, coords.z, audioRef, false, 0, false)
        if (times and times > 1 and not sleep) and soundId ~= -1 then
            while not HasSoundFinished(soundId) do
                Citizen.Wait(0)
            end
            ReleaseSoundId(soundId)
        elseif sleep then
            Citizen.Wait(sleep)
            if soundId ~= -1 then
                StopSound(soundId)
            end
        end
    end
    if audioBank then
        ReleaseNamedScriptAudioBank(audioBank)
    end
end)