local isPlayerDead = false


Citizen.CreateThread(function()
    while true do
        if IsPlayerDead(PlayerId()) then
            if isPlayerDead == false then 
                isPlayerDead = true
                SendNUIMessage({
					setDisplay = true
				})
				--DisableControlAction(1, 244, true)
            end
        else 
            if isPlayerDead == true then
                isPlayerDead = false
                SendNUIMessage({
					setDisplay = false
				})
				--DisableControlAction(1, 244, true)
            end
        end
        Citizen.Wait(200)
    end
end)

