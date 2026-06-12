local isHandcuffed = false
local isDragged = false

function ESX.isHandcuffed()
    return isHandcuffed
end

local function handcuffLoop(animDict, animName)
    local playerPed <const> = PlayerPedId()

    if isHandcuffed then
        RequestAnimDict(animDict)

        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(0)
        end

        TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, 100000, 49, 0, false, false, false)
        SetEnableHandcuffs(playerPed, true)
        SetPedCanPlayGestureAnims(playerPed, false)
    end

    Citizen.CreateThread(function()
        local cuffsProp <const> = "aim_low_loop" == animName and "cuff02" or "cuff01"

        if isHandcuffed then
            TriggerEvent('esx_inventoryhud:doClose')
            TriggerEvent("attachItem", cuffsProp)
            TriggerEvent('cframework:closePhone')
            TriggerEvent('cframework:stopPegar')
            TriggerEvent('cframework:disableVehiclePush')
            TriggerEvent('cframework:disablePegar')
            TriggerEvent('cframework:disableEmotes')
            TriggerEvent('cframework:disableSearchTrash')
            TriggerEvent('cframework:disableVehicleControl')
            TriggerEvent("cframework:removeWeaponsFromHandInstant")
        end

        while isHandcuffed do
            DisableControlAction(2, 24, true) -- Attack
            DisableControlAction(2, 257, true) -- Attack 2
            DisableControlAction(2, 25, true) -- Aim
            DisableControlAction(2, 263, true) -- Melee Attack 1
            DisableControlAction(2, 45, true) -- Reload
            DisableControlAction(2, 22, true) -- Jump
            DisableControlAction(2, 44, true) -- Cover
            DisableControlAction(2, 37, true) -- Select Weapon
            DisableControlAction(2, 23, true) -- Also 'enter'?
            DisableControlAction(2, 288, true) -- Disable phone
            DisableControlAction(2, 289, true) -- Inventory
            DisableControlAction(2, 170, true) -- Animations
            DisableControlAction(2, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
            DisableControlAction(2, 59, true) -- Disable steering in vehicle
            DisableControlAction(2, 36, true) -- Disable going stealth
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle

            Citizen.Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while isHandcuffed do
            local myPlayerPed <const> = PlayerPedId()

            if not IsEntityPlayingAnim(myPlayerPed, animDict, animName, 3) then
                TaskPlayAnim(myPlayerPed, animDict, animName, 8.0, -8.0, 100000, 49, 0, false, false, false)
            end

            if IsPedRagdoll(myPlayerPed) then
                ClearPedSecondaryTask(myPlayerPed)
            end

            if IsEntityDead(myPlayerPed) then
                isHandcuffed = false
            end

            Citizen.Wait(100)
        end

        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed,  true)
        DetachEntity(playerPed, true, false)
        TriggerEvent("destroyProp")
        TriggerEvent('cframework:enableEmotes')
		TriggerEvent('cframework:enablePegar')
		TriggerEvent('cframework:enableVehiclePush')
        TriggerEvent('cframework:enableSearchTrash')
        TriggerEvent('cframework:enableVehicleControl')
        isDragged = false
    end)
end

RegisterNetEvent('esx:onPlayerSpawn', function()
    isHandcuffed = false
end)

RegisterNetEvent('cframework:toggleHandcuff', function(isFacingFront)
    isHandcuffed = not isHandcuffed

    --local escape = ESX.taskBar(2, 1)
    --if escape then isHandcuffed = false return end
    if isFacingFront then
        handcuffLoop('anim@move_m@prisoner_cuffed_rc', 'aim_low_loop')
    else
        handcuffLoop('mp_arresting', 'idle')
    end
end)

RegisterNetEvent("cframework:startDrag", function(cop)
    isDragged = not isDragged

    if not isHandcuffed then return end

    local myPlayerPed <const> = PlayerPedId()
    local ped <const> = GetPlayerPed(GetPlayerFromServerId(cop))

    if not isDragged then
        DetachEntity(myPlayerPed, true, false)
        return
    end

    if DoesEntityExist(ped) then
        AttachEntityToEntity(myPlayerPed, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    end
end)

RegisterNetEvent("cframework:doArrestAnim", function()
    local myPlayerPed <const> = PlayerPedId()

    RequestAnimDict("mp_arrest_paired")

    while not HasAnimDictLoaded("mp_arrest_paired") do
        Citizen.Wait(0)
    end

	Citizen.Wait(250)
	TaskPlayAnim(myPlayerPed, "mp_arrest_paired", "cop_p2_back_right", 8.0, -8,3750, 2, 0, false, false, false)
	Citizen.Wait(3000)
    ClearPedTasks(myPlayerPed)
end)

RegisterNetEvent("cframework:doReleaseAnim", function()
    local myPlayerPed <const> = PlayerPedId()

    RequestAnimDict("mp_arresting")

    while not HasAnimDictLoaded("mp_arresting") do
        Citizen.Wait(0)
    end

	Citizen.Wait(250)
	TaskPlayAnim(myPlayerPed, "mp_arresting", "a_uncuff", 8.0, -8,-1, 2, 0, false, false, false)
	Citizen.Wait(5500)
	ClearPedTasks(myPlayerPed)
end)

RegisterNetEvent("cframework:getArrested", function(playerheading, playercoords, playerlocation)
    local myPlayerPed <const> = PlayerPedId()

    isHandcuffed = true

    --local escape = ESX.taskBar(2, 1)
    --if escape then return end

	local x <const>, y <const>, z <const> = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(myPlayerPed, x, y, z - 1.0, false, false, false, false)
	SetEntityHeading(myPlayerPed, playerheading)
	Citizen.Wait(250)

    RequestAnimDict("mp_arrest_paired")

    while not HasAnimDictLoaded("mp_arrest_paired") do
        Citizen.Wait(0)
    end

	TaskPlayAnim(myPlayerPed, 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, false, false, false)
	Citizen.Wait(3760)

    handcuffLoop('mp_arresting', 'idle')
end)

RegisterNetEvent("cframework:getUncuffed", function(playerheading, playercoords, playerlocation)
    local myPlayerPed <const> = PlayerPedId()

	local x <const>, y <const>, z <const> = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(myPlayerPed, x, y, z - 1.0, false, false, false, false)
	SetEntityHeading(myPlayerPed, playerheading)
	Citizen.Wait(250)

    RequestAnimDict("mp_arresting")

    while not HasAnimDictLoaded("mp_arresting") do
        Citizen.Wait(0)
    end

	TaskPlayAnim(myPlayerPed, 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, false, false, false)
	Citizen.Wait(5500)

	isHandcuffed = false
	ClearPedTasks(myPlayerPed)
end)
