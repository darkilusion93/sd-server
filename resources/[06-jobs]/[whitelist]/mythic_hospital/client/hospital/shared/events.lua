RegisterNetEvent('mythic_hospital:client:FinishServices')
AddEventHandler('mythic_hospital:client:FinishServices', function(h, wasLucky)
    if h and usedHiddenRev then return end

    local player = PlayerPedId()
		
	--if IsPedDeadOrDying(PlayerPedId()) then
	--	local playerPos = GetEntityCoords(player, true)
	--	NetworkResurrectLocalPlayer(playerPos, true, true, false)
		--TriggerEvent('esx:ambulancejob:revive')
		--Citizen.Wait(750)
   -- end

    if wasLucky then
		--TriggerEvent('esx_ambulancejob:revive')
		--Citizen.Wait(5000)
        SetEntityHealth(player, GetEntityMaxHealth(player))
        ClearPedBloodDamage(player)
        SetPlayerSprint(PlayerId(), true)
        ResetAll()
		print (PlayerPedId())
    else
        SetEntityHealth(player, 110)
    end

    if h then
        usedHiddenRev = true
        DoScreenFadeIn(1000)
    else
        LeaveBed()
		Citizen.Wait(500)
		TriggerEvent('esx_ambulancejob:revive')
		
    end
end)