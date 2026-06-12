


local inAnimation = false

local function exitAnim()
	ClearPedTasks(PlayerPedId())
	TriggerEvent("destroyProp")
	inAnimation = false
end

RegisterNetEvent("cframework:toggleAnimProp", function(animDict, animName, propName, createThread)
    if inAnimation then
		exitAnim()
		return
	end

	inAnimation = true

	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(0)
	end

    TriggerEvent("attachItem", propName)
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1, -1, 50, 0, false, false, false)

	if not createThread then return end

	Citizen.CreateThread(function()
		while inAnimation do
			local playerPed <const> = PlayerPedId()

			if not IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
				TaskPlayAnim(playerPed, animDict, animName, 1.0, -1, -1, 50, 0, false, false, false)
			end

			if IsDisabledControlJustPressed(0, VK_ESCAPE) or IsControlJustPressed(0, VK_BACK) then
				exitAnim()
				return
			end

			DisablePlayerFiring(PlayerId(), true)
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 44, true) -- INPUT_COVER
			DisableControlAction(0, VK_TAB, true) -- INPUT_SELECT_WEAPON
			DisableControlAction(0, VK_ESCAPE, true)

			Citizen.Wait(0)
		end
	end)
end)
