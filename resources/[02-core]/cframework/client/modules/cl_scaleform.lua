local Scaleform = {}

local scaleform = {}
local AnnouncementScaleform

scaleform.__index = scaleform

function Scaleform.Request(Name)
	local ScaleformHandle = RequestScaleformMovie(Name)
	local StartTime = GetGameTimer()
	while not HasScaleformMovieLoaded(ScaleformHandle) do Citizen.Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print("loading failed")
			return
		end 
	end
	print("Loaded")
	local data = {name = Name, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function Scaleform.RequestHud(id)
	local ScaleformHandle = RequestHudScaleform(id)
	local StartTime = GetGameTimer()
	while not HasHudScaleformLoaded(ScaleformHandle) do 
		Citizen.Wait(0) 
		if GetGameTimer() - StartTime >= 5000 then
			print("loading failed")
			return
		end
	end
	print("Loaded")
	local data = {Name = id, handle = ScaleformHandle}
	return setmetatable(data, scaleform)
end

function scaleform:CallScaleFunction(scType, theFunction, ...)
	if scType == "hud" then
		BeginScaleformMovieMethodHudComponent(self.handle, theFunction)
	elseif scType == "normal" then
		BeginScaleformMovieMethod(self.handle, theFunction)
	end
    local arg = {...}
    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == "boolean" then
                PushScaleformMovieMethodParameterBool(arg[i])
			elseif sType == "number" then
				if math.type(arg[i]) == "integer" then
					PushScaleformMovieMethodParameterInt(arg[i])
				else
					PushScaleformMovieMethodParameterFloat(arg[i])
				end
            elseif sType == "string" then
                PushScaleformMovieMethodParameterString(arg[i])
            else
                PushScaleformMovieMethodParameterInt()
            end
		end
	end
	return EndScaleformMovieMethod()
end

function scaleform:CallHudFunction(theFunction, ...)
    self:CallScaleFunction("hud", theFunction, ...)
end

function scaleform:CallFunction(theFunction, ...)
    self:CallScaleFunction("normal", theFunction, ...)
end

function scaleform:Draw2D(alpha)
	DrawScaleformMovieFullscreen(self.handle, 255, 255, 255, (alpha and alpha or 255))
end

function scaleform:Draw2DNormal(x, y, width, height, r, g, b, a, v, v2)
	DrawScaleformMovie(self.handle, x, y, width, height, r, g, b, a, v, v2)
end

function scaleform:Draw2DScreenSpace(locx, locy, sizex, sizey)
	local Width, Height = GetScreenResolution()
	local x = locy / Width
	local y = locx / Height
	local width = sizex / Width
	local height = sizey / Height
	DrawScaleformMovie(self.handle, x + (width / 2.0), y + (height / 2.0), width, height, 255, 255, 255, 255)
end

function scaleform:Render3D(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3dNonAdditive(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Render3DAdditive(x, y, z, rx, ry, rz, scalex, scaley, scalez)
	DrawScaleformMovie_3d(self.handle, x, y, z, rx, ry, rz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function scaleform:Dispose()
	SetScaleformMovieAsNoLongerNeeded(self.handle)
	setmetatable({}, scaleform)
end

function scaleform:IsValid()
	return self and true or false
end

function StartDraw(type, time)
	Citizen.CreateThread(function()
		local fading = false
		while not AnnouncementScaleform do Wait(0) end
		local StartTime = GetGameTimer()
		while true do
			AnnouncementScaleform:Draw2D()

			if GetGameTimer() - StartTime > time * 1000 then 
				if type == 1 and not fading then 
					fading = true
					AnnouncementScaleform:CallFunction("SHARD_ANIM_OUT", 2, 1) 
				elseif type ~= 1 then
					AnnouncementScaleform:Dispose()
					return 
				end
			end

			if GetGameTimer() - StartTime > (time + 1.25) * 1000  then
				AnnouncementScaleform:Dispose()
				fading = false
				return 
			end
			Wait(0)
		end
	end)
end

ESX.Scaleform.ShowFreemodeMessage = function(title, msg, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowMidSizedMessage = function(title, msg, sec)
	Citizen.CreateThread(function()
		StartDraw(1, sec)
	end)

	AnnouncementScaleform = Scaleform.Request("MIDSIZED_MESSAGE")
	AnnouncementScaleform:CallFunction("SHOW_SHARD_MIDSIZED_MESSAGE", title, msg, 2, true, true)
end

ESX.Scaleform.ShowBreakingNews = function(title, msg, bottom, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('BREAKING_NEWS')

	BeginScaleformMovieMethod(scaleform, 'SET_TEXT')
	PushScaleformMovieMethodParameterString(msg)
	PushScaleformMovieMethodParameterString(bottom)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_SCROLL_TEXT')
	PushScaleformMovieMethodParameterInt(0) -- top ticker
	PushScaleformMovieMethodParameterInt(0) -- Since this is the first string, start at 0
	PushScaleformMovieMethodParameterString(title)

	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'DISPLAY_SCROLL_TEXT')
	PushScaleformMovieMethodParameterInt(0) -- Top ticker
	PushScaleformMovieMethodParameterInt(0) -- Index of string

	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowPopupWarning = function(title, msg, bottom, sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('POPUP_WARNING')

	BeginScaleformMovieMethod(scaleform, 'SHOW_POPUP_WARNING')

	PushScaleformMovieMethodParameterFloat(500.0) -- black background
	PushScaleformMovieMethodParameterString(title)
	PushScaleformMovieMethodParameterString(msg)
	PushScaleformMovieMethodParameterString(bottom)
	PushScaleformMovieMethodParameterBool(true)

	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.ShowTrafficMovie = function(sec)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('TRAFFIC_CAM')

	BeginScaleformMovieMethod(scaleform, 'PLAY_CAM_MOVIE')

	EndScaleformMovieMethod()

	while sec > 0 do
		Citizen.Wait(1)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

ESX.Scaleform.Utils.RequestScaleformMovie = function(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	return scaleform
end