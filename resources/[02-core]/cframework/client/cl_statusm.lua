local Status = {}
local isPaused = false

function ESX.PauseStatus(value)
	isPaused = value
end

local function GetStatusData(minimal)
	local status = {}

	for i=1, #Status, 1 do
		if minimal then
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				percent = (Status[i].val / 1000000) * 100
			})
		else
			table.insert(status, {
				name    = Status[i].name,
				val     = Status[i].val,
				color   = Status[i].color,
				visible = Status[i].visible(Status[i]),
				max     = Status[i].max,
				percent = (Status[i].val / 1000000) * 100
			})
		end
	end

	return status
end


AddEventHandler('esx_basicneeds:resetStatus', function()
	TriggerEvent('esx_status:set', 'hunger', 500000)
	TriggerEvent('esx_status:set', 'thirst', 500000)
    TriggerEvent('esx_status:set', 'drunk', 0)
end)

RegisterNetEvent('esx_basicneeds:healPlayer', function()
	-- restore hunger & thirst
	TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
    TriggerEvent('esx_status:set', 'drunk',  0)

	-- restore hp
	local playerPed = PlayerPedId()
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
end)

AddEventHandler('playerSpawned', function(spawn)
	if ESX.isPlayerDead() then
		TriggerEvent('esx_basicneeds:resetStatus')
	end
end)

Citizen.CreateThread(function()
	local hunger = CreateStatus('hunger', 1000000, '#CFAD0F', function(status)
		status.remove(ESX.HungerTick)

		if status.val == 0 then
			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			if prevHealth <= 150 then
				health = health - 15
			else
				health = health - 5
			end

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
				SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
				DoScreenFadeOut(300)
				Citizen.Wait(300)
				DoScreenFadeIn(300)
			end
		end
	end, function(status)

    end)

    table.insert(Status, hunger)

	local thirst = CreateStatus('thirst', 1000000, '#0C98F1', function(status)
		status.remove(ESX.ThirstTick)

		if status.val == 0 then
			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth

			if prevHealth <= 150 then
				health = health - 15
			else
				health = health - 5
			end

			if health ~= prevHealth then
				SetEntityHealth(playerPed, health)
				SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
				DoScreenFadeOut(300)
				Citizen.Wait(300)
				DoScreenFadeIn(300)
			end
		end
	end, function(status)

    end)

    table.insert(Status, thirst)

    local drunk = CreateStatus('drunk', 0, '#0C98F1', function(status)
        local prevStatus = status.val

		status.remove(ESX.DrunkTick)

        if status.val >= 50000 then
            local playerPed = GetPlayerPed(-1)
            SetTimecycleModifier("spectator5")
            SetPedMotionBlur(playerPed, true)
            SetPedIsDrunk(playerPed, true)
        end

        if status.val <= 0 then
            if prevStatus <= 0 then return end

            local playerPed = GetPlayerPed(-1)
            ClearTimecycleModifier()
            ResetScenarioTypesEnabled()
            ResetPedMovementClipset(playerPed, 0)
            SetPedIsDrunk(playerPed, false)
            SetPedMotionBlur(playerPed, false)
        elseif status.val >= 200000 then
            RequestAnimSet("move_m@drunk@slightlydrunk")

            while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
                Citizen.Wait(0)
            end

            SetPedMovementClipset(PlayerPedId(), "move_m@drunk@slightlydrunk", 0.0)
        elseif status.val >= 500000 then
            RequestAnimSet("move_m@drunk@moderatedrunk")

            while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
                Citizen.Wait(0)
            end

            SetPedMovementClipset(PlayerPedId(), "move_m@drunk@moderatedrunk", 0.0)
        elseif status.val >= 700000 then
            RequestAnimSet("move_m@drunk@verydrunk")

            while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
                Citizen.Wait(0)
            end

            SetPedMovementClipset(PlayerPedId(), "move_m@drunk@verydrunk", 0.0)
            DoScreenFadeOut(300)
            Citizen.Wait(300)
            DoScreenFadeIn(300)
        end

	end, function(status)
        if status.val >= 900000 then
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, true, true, false)
        end
    end)

    table.insert(Status, drunk)
end)


Citizen.CreateThread(function()
    while true do
        for i=1, #Status, 1 do
			if not isPaused then
            	Status[i].onTick()
			end
        end
        Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for i=1, #Status, 1 do
			if not isPaused then
            	Status[i].onFrameTick()
			end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        TriggerServerEvent('cframework:setStatus', GetStatusData(true))
    end
end)

RegisterNetEvent('esx:playerLoaded', function(player)
    local status = player.status

  	for i=1, #Status, 1 do
  		for j=1, #status, 1 do
  			if Status[i].name == status[j].name then
  				Status[i].set(status[j].val)
  			end
  		end
  	end
end)

RegisterNetEvent('esx_status:set', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].set(val)
			break
		end
	end
end)

RegisterNetEvent('esx_status:add', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].add(val)
			break
		end
	end

    TriggerServerEvent('cframework:setStatus', GetStatusData(true))
end)

RegisterNetEvent('esx_status:remove', function(name, val)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			Status[i].remove(val)
			break
		end
	end
end)

AddEventHandler('cframework:getStatus', function(name, cb)
	for i=1, #Status, 1 do
		if Status[i].name == name then
			cb(Status[i])
			return
		end
	end
end)
