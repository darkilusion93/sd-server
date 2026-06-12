Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if NetworkIsSessionStarted() then
			TriggerServerEvent("cframework:initPlayerLoad")
			return
		end
	end
end)

