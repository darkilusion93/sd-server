

RegisterNetEvent("cframework:useLockpick", function()
	local playerPed <const> = PlayerPedId()
    local coords <const> = GetEntityCoords(playerPed)
    local closestVehicle <const>, distance <const> = ESX.Game.GetClosestVehicle(coords)

    if distance > 5.0 then
        return
    end

	if IsPedInAnyVehicle(playerPed, false) then
		return
	end

    if not DoesEntityExist(closestVehicle) then
        return
    end

    TriggerServerEvent('cframework:removeLockpickAfterUse')
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

    Citizen.Wait(1000)

	Citizen.CreateThread(function()
        FreezeEntityPosition(playerPed, true)

        local lockpickTime <const> = math.random(20000, 30000) + GetGameTimer()

        while GetGameTimer() < lockpickTime do
            Citizen.Wait(0)

            if not IsPedUsingScenario(playerPed, "PROP_HUMAN_BUM_BIN") then
                ESX.ShowNotification(T("LOCKPICK_CANCELED"), "error")
                FreezeEntityPosition(playerPed, false)
                return
            end
        end

		TriggerServerEvent("cframework:setLockStatus", NetworkGetNetworkIdFromEntity(closestVehicle), 1)
		ClearPedTasks(playerPed)
        FreezeEntityPosition(playerPed, false)

		ESX.ShowNotification(T("VEHICLES_UNLOCKED"), "success")
	end)
end)
