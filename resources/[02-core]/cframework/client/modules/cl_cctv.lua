


local inCam = false
local cctvCam = 0
local CCTVCamLocations = {
    { x = 1778.80,   y = 3721.96,    z = 38.50,   h = 229.69,  info = 'Sandy',        ["recent"] = false },--cctv 1
    { x = 1770.75,   y = 3732.26,    z = 38.00,   h = 352.96,  info = 'Sandy',        ["recent"] = false },--cctv 2 
    { x = 1741.73,   y = 3723.07,    z = 36.23,   h = 256.33,  info = 'Sandy',        ["recent"] = false },--cctv 3
    { x = 1755.04,   y = 3690.30,    z = 36.27,   h = 259.83,  info = 'Sandy',        ["recent"] = false },--cctv 4
    { x = 1710.92,   y = 3693.44,    z = 36.80,   h = 235.47,  info = 'Sandy',        ["recent"] = false },--cctv 5
    { x = 1682.07,   y = 3648.08,    z = 36.00,   h = 260.16,  info = 'Sandy',        ["recent"] = false },--cctv 6
    { x = 1646.34,   y = 3655.26,    z = 37.00,   h =  86.84,  info = 'Sandy',        ["recent"] = false },--cctv 7 
    { x = 1809.75,   y = 3677.46,    z = 40.00,   h = 146.41,  info = 'Sandy',        ["recent"] = false },--cctv 8
    { x = 1815.61,   y = 3665.66,    z = 35.50,   h =  54.81,  info = 'Sandy',        ["recent"] = false },--cctv 9
    { x = 1841.43,   y = 3688.33,    z = 38.05,   h = 310.96,  info = 'Sandy',        ["recent"] = false },--cctv 10
    { x = 1729.77,   y = 3679.84,    z = 39.00,   h =  93.93,  info = 'Sandy',        ["recent"] = false },--cctv 11
	{ x = 1733.06,   y = 3639.29,    z = 36.00,   h = 202.74,  info = 'Sandy',        ["recent"] = false },--cctv 12
	{ x = 1727.48,   y = 3635.73,    z = 36.45,   h = 188.99,  info = 'Sandy',        ["recent"] = false },--cctv 13
	{ x = 1729.14,   y = 3627.00,    z = 36.00,   h =  21.15,  info = 'Sandy',        ["recent"] = false },--cctv 14
	{ x = 1742.15,   y = 3615.37,    z = 36.00,   h = 251.57,  info = 'Sandy',        ["recent"] = false },--cctv 15
	{ x = 1957.79,   y = 3743.81,    z = 33.00,   h = 251.87,  info = 'Sandy',        ["recent"] = false },--cctv 16
	{ x = 1962.93,   y = 3748.34,    z = 33.00,   h =  88.00,  info = 'Sandy',        ["recent"] = false },--cctv 17

    { x =  537.73,   y = 2671.45,    z = 44.20,   h = 117.93,  info = 'R68',          ["recent"] = false },--cctv 18
    { x =  549.46,   y = 2674.07,    z = 44.20,   h =  31.62,  info = 'R68',          ["recent"] = false },--cctv 19
    { x =  552.70,   y = 2800.70,    z = 46.00,   h = 217.29,  info = 'R68',          ["recent"] = false },--cctv 20 
    { x =  572.87,   y = 2742.33,    z = 44.00,   h = 207.17,  info = 'R68',          ["recent"] = false },--cctv 21
    { x =  634.52,   y = 2785.54,    z = 45.00,   h = 212.76,  info = 'R68',          ["recent"] = false },--cctv 22
    { x =  620.04,   y = 2803.88,    z = 45.00,   h = 118.52,  info = 'R68',          ["recent"] = false },--cctv 23
    { x =  579.87,   y = 2789.38,    z = 45.00,   h = 285.74,  info = 'R68',          ["recent"] = false },--cctv 24
    { x =  550.51,   y = 2800.85,    z = 45.00,   h = 132.31,  info = 'R68',          ["recent"] = false },--cctv 25
    { x =  992.21,   y = 2800.68,    z = 39.00,   h = 212.25,  info = 'R68',          ["recent"] = false },--cctv 26
    { x =  973.87,   y = 2719.20,    z = 38.00,   h = 142.34,  info = 'R68',          ["recent"] = false },--cctv 27
    { x = 1068.24,   y = 2723.06,    z = 40.00,   h = 172.83,  info = 'R68',          ["recent"] = false },--cctv 28
	{ x =  970.85,   y = 2666.60,    z = 41.50,   h = 339.81,  info = 'R68',          ["recent"] = false },--cctv 29
    { x = 1001.98,   y = 2666.72,    z = 41.50,   h =  37.58,  info = 'R68',          ["recent"] = false },--cctv 30
	{ x = 1199.55,   y = 2646.48,    z = 38.00,   h =   8.03,  info = 'R68',          ["recent"] = false },--cctv 31
	{ x = 1194.14,   y = 2650.30,    z = 38.00,   h = 180.32,  info = 'R68',          ["recent"] = false },--cctv 32
	{ x =  549.72,   y = 2666.91,    z = 42.00,   h =  52.48,  info = 'R68',          ["recent"] = false },--cctv 33
	{ x =  543.47,   y = 2664.59,    z = 43.00,   h = 221.31,  info = 'R68',          ["recent"] = false },--cctv 34

	{ x = 1697.32,   y = 4791.52,    z = 46.63,   h =  36.88,  info = 'Grapesseed',   ["recent"] = false },--cctv 35
	{ x = 1702.97,   y = 4933.58,    z = 43.00,   h = 170.87,  info = 'Grapesseed',   ["recent"] = false },--cctv 36
	{ x = 1705.74,   y = 4916.11,    z = 41.00,   h =  19.55,  info = 'Grapesseed',   ["recent"] = false },--cctv 37
	{ x = 1708.10,   y = 4921.03,    z = 42.00,   h = 105.61,  info = 'Grapesseed',   ["recent"] = false },--cctv 38



}


RegisterCommand("cctv", function (source, args, rawCommand)
	local cam = args[1]
	local xPlayer = ESX.GetPlayerData()
	local job = xPlayer.job
	local jobname = xPlayer.job.name

    if job and jobname == 'police' then
		TriggerEvent('cctv:camera', cam)
	end
end, false)

RegisterNetEvent("cctv:camera", function(camNumber)
	camNumber = tonumber(camNumber)

	if inCam then
		inCam = false
		PlaySoundFrontend(-1, "HACKING_SUCCESS", "", false)
		Wait(250)
		ClearPedTasks(GetPlayerPed(-1))
	else
		if camNumber > 0 and camNumber < #CCTVCamLocations+1 then
			PlaySoundFrontend(-1, "HACKING_SUCCESS", "", false)
			TriggerEvent("cctv:startcamera",camNumber)
		else
            ESX.ShowNotification(T("CCTV_CAM_NOT_EXISTS"), "error")
		end
	end
end)

RegisterNetEvent("cctv:startcamera", function(camNumber)
	camNumber = tonumber(camNumber)

    local x = CCTVCamLocations[camNumber]["x"]
	local y = CCTVCamLocations[camNumber]["y"]
	local z = CCTVCamLocations[camNumber]["z"]
	local h = CCTVCamLocations[camNumber]["h"]

	inCam = true

	SetTimecycleModifier("heliGunCam")
	SetTimecycleModifierStrength(1.0)
	local scaleform = RequestScaleformMovie("TRAFFIC_CAM")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	cctvCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
	SetCamCoord(cctvCam, x, y, z + 1.2)
	SetCamRot(cctvCam, -15.0, 0.0, h, 0)
	SetCamFov(cctvCam, 110.0)
	RenderScriptCams(true, false, 0, true, false)
	PushScaleformMovieFunction(scaleform, "PLAY_CAM_MOVIE")
	SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
	PopScaleformMovieFunctionVoid()

    Citizen.CreateThread(function ()
        while inCam do
            Citizen.Wait(0)
            if inCam then
                local rota = GetCamRot(cctvCam, 2)

                if IsControlPressed(1, VK_NUMPAD4) then
                    SetCamRot(cctvCam, rota.x, 0.0, rota.z + 0.7, 2)
                end

                if IsControlPressed(1, VK_NUMPAD6) then
                    SetCamRot(cctvCam, rota.x, 0.0, rota.z - 0.7, 2)
                end

                if IsControlPressed(1, VK_NUMPAD8) then
                    SetCamRot(cctvCam, rota.x + 0.7, 0.0, rota.z, 2)
                end

                if IsControlPressed(1, VK_NUMPAD5) then
                    SetCamRot(cctvCam, rota.x - 0.7, 0.0, rota.z, 2)
                end
            end
        end
    end)

	while inCam do
		SetCamCoord(cctvCam,x,y,z+1.2)
		PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
		PushScaleformMovieFunctionParameterFloat(GetEntityCoords(h).z)
		PushScaleformMovieFunctionParameterFloat(1.0)
		PushScaleformMovieFunctionParameterFloat(GetCamRot(cctvCam, 2).z)
		PopScaleformMovieFunctionVoid()
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
		Citizen.Wait(0)
	end

	ClearFocus()
	ClearTimecycleModifier()
	RenderScriptCams(false, false, 0, true, false)
	SetScaleformMovieAsNoLongerNeeded(scaleform)
	DestroyCam(cctvCam, false)
	SetNightvision(false)
	SetSeethrough(false)
end)