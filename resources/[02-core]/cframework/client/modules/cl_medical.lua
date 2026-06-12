RegisterNetEvent('cframework:heal', function(type)
    local playerPed = PlayerPedId()
    local maxHealth = GetEntityMaxHealth(playerPed)

    if type == 'small' then --Bandage
        SetEntityHealth(playerPed, math.min(maxHealth, math.floor(GetEntityHealth(playerPed) + maxHealth / 8)))
    end

    if type == 'big' then --Medickit
        SetEntityHealth(playerPed, maxHealth)
    end

    ESX.ShowNotification(T("MEDICAL_HEALED"), 'success')
end)

RegisterNetEvent("cframework:applyingBandage", function()
    ESX.CreateTimerBar(T("ITEMS_BANDAGE"), 3000, 0, 204, 0, 0, 117, 0)
end)

RegisterNetEvent("cframework:applyingArmor", function()
    ESX.CreateTimerBar(T("MEDICAL_ARMOR"), 5000, 3, 94, 252, 0, 0, 255)
end)

RegisterNetEvent("cframework:applyingArmor2", function()
    ESX.CreateTimerBar(T("MEDICAL_ARMOR"), 10000, 3, 94, 252, 0, 0, 255)
end)

RegisterNetEvent("cframework:applyingArmor3", function()
    ESX.CreateTimerBar(T("MEDICAL_ARMOR"), 15000, 3, 94, 252, 0, 0, 255)
end)

RegisterNetEvent('cframework:applyArmour3', function()
    local playerPed <const> = PlayerPedId()

    SetPedArmour(playerPed, 100)
    SetEntityHealth(playerPed, GetEntityHealth(playerPed) + 30)

    ESX.ShowNotification(T("MEDICAL_ARMOR_EQUIPPED"), 'success')
end)

RegisterNetEvent('cframework:applyArmour2', function()
    SetPedArmour(PlayerPedId(), 100)

    ESX.ShowNotification(T("MEDICAL_ARMOR_EQUIPPED"), 'success')
end)

RegisterNetEvent('cframework:applyArmour', function()
    local currentArmour <const> = GetPedArmour(PlayerPedId())

    SetPedArmour(PlayerPedId(), currentArmour + 50)

    ESX.ShowNotification(T("MEDICAL_ARMOR_EQUIPPED"), 'success')
end)


RegisterNetEvent("cframework:ambulanceRevive", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance == -1 or distance > 3.0 then
        ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
        return
    end

    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
        if qtty <= 0 then
            ESX.ShowNotification(T("MEDICAL_MEDKIT_NOT_FOUND"), 'error')
            return
        end

        local closestPlayerPed = GetPlayerPed(player)
        local health = GetEntityHealth(closestPlayerPed)
        local playerPed = GetPlayerPed(-1)

        ESX.ShowNotification(T("MEDICAL_REVIVE_IN_PROGRESS"), 'inform')
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        Citizen.Wait(10000)
        ClearPedTasks(playerPed)
        TriggerServerEvent('cframework:revive', GetPlayerServerId(player))
    end, 'medikit')
end)

RegisterNetEvent("cframework:ambulanceHealSmall", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance == -1 or distance > 3.0 then
        ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
        return
    end

    ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
        if qtty <= 0 then
            ESX.ShowNotification(T("MEDICAL_BANDAGE_NOT_FOUND"), 'error')
            return
        end

        local playerPed = GetPlayerPed(-1)
        local closestPlayerPed = GetPlayerPed(player)
        local health = GetEntityHealth(closestPlayerPed)

        if health <= 0 then
            ESX.ShowNotification(T("MEDICAL_PLAYER_NOT_CONSCIOUS"), 'error')
            return
        end

        ESX.ShowNotification(T("MEDICAL_HEALING_IN_PROGRESS"), 'inform')
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
        ClearPedTasks(playerPed)
        TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
        TriggerServerEvent('cframework:heal', GetPlayerServerId(player), 'small')
    end, 'bandage')
end)

RegisterNetEvent("cframework:ambulanceHealBig", function()
  local player, distance = ESX.Game.GetClosestPlayer()
  if distance == -1 or distance > 3.0 then
    ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
    return
  end

  ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)
    if qtty <= 0 then
      ESX.ShowNotification(T("MEDICAL_MEDKIT_NOT_FOUND"), 'error')
      return
    end

    local playerPed = GetPlayerPed(-1)
    local closestPlayerPed = GetPlayerPed(player)
    local health = GetEntityHealth(closestPlayerPed)

    if health <= 0 then
      ESX.ShowNotification(T("MEDICAL_PLAYER_NOT_CONSCIOUS"), 'error')
      return
    end

    ESX.ShowNotification(T("MEDICAL_HEALING_IN_PROGRESS"), 'inform')
    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
    Citizen.Wait(10000)
    ClearPedTasks(playerPed)
    TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
    TriggerServerEvent('cframework:heal', GetPlayerServerId(player), 'big')
  end, 'medikit')
end)


local isCairDisabled = false

RegisterNetEvent('cframework:disableCair', function()
  isCairDisabled = true
end)

RegisterNetEvent('cframework:enableCair', function()
  isCairDisabled = false
end)

RegisterCommand("cair", function(source, args, rawCommand)
	if ESX.isPlayerDead() and not isCairDisabled then
		local ped <const> = PlayerPedId()
		local coords <const> = GetEntityCoords(ped)
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, 0, 1, false)
		SetPedToRagdoll(PlayerPedId(), 6000, 6000, 0, false, false, false)     ---ragdoll
		SetPlayerInvincible(PlayerPedId(), true)
		SetEntityHealth(PlayerPedId(), 1)
	end
end, false)
