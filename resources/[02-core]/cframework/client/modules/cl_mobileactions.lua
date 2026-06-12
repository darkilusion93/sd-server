local isPlayingAnim = false

AddEventHandler("inventoryClosed", function()
    if isPlayingAnim then
        StopAnimTask(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 3.0)
        isPlayingAnim = false
    end
end)

local function hasMobileActionPermission(action)
    if Config.Stations[ESX.PlayerData.job.name] == nil or Config.Stations[ESX.PlayerData.job.name].MobileAction == nil then
        return false
    end

    for _, v in pairs(Config.Stations[ESX.PlayerData.job.name].MobileAction) do
        if v.value == action then
            if v.minGrade ~= nil and ESX.PlayerData.job.grade < v.minGrade then
                return false
            end

            return true
        end
    end

    return false
end


local function openFineCategoryMenuPolice(player, category)
	ESX.TriggerServerCallback('esx_policejob:getFineList', function(fines)
		local elements = {}

		for i=1, #fines, 1 do
			table.insert(elements, {
				label     = fines[i].label .. ' <span style="color: green;">$' .. fines[i].amount .. '</span>',
				value     = fines[i].id,
				amount    = fines[i].amount,
				fineLabel = fines[i].label
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine_category',
		{
			title    = T("MOBILEACTIONS_FINE"),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			local label  = data.current.fineLabel
			local amount = data.current.amount

			menu.close()

			ESX.ShowNotification(T("MOBILEACTIONS_FINE_SENT"), 'inform')
            TriggerServerEvent('cframework:sendBill', GetPlayerServerId(player), 'society_governo', T("MOBILEACTIONS_FINE") .. ': ' .. label, amount)
		end, function(data, menu)
			menu.close()
		end)
	end, category)
end

local function openFineMenu(player)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fine',
    {
        title    = T("MOBILEACTIONS_FINE"),
        align    = 'top-left',
        elements = {
            {label = T("FINES_TRAFFIC_OFFENSE"),   value = 0},
            {label = T("FINES_MINOR_OFFENSE")  ,   value = 1},
            {label = T("FINES_AVERAGE_OFFENSE"),   value = 2},
            {label = T("FINES_MAJOR_OFFENSE")  ,   value = 3}
        },
    },
    function(data, menu)
        openFineCategoryMenuPolice(player, data.current.value)
    end,
    function(data, menu)
        menu.close()
    end)
end

local function openVehicleInfosMenu(vehicleData)
    ESX.TriggerServerCallback('esx_orgs:getVehicleInfos', function(infos)
        local elements = {}

        table.insert(elements, {label = (T("MOBILEACTIONS_PLATE")):format(infos.plate), value = nil})

        if infos.owner == nil then
            table.insert(elements, {label = T("MOBILEACTIONS_OWNER_UNKOWN"), value = nil})
        else
            table.insert(elements, {label = (T("MOBILEACTIONS_OWNER")):format(infos.owner), value = nil})
        end

        ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vehicle_infos',
        {
            title    = T("MOBILEACTIONS_VEHICLE_INFOS"),
            align    = 'top-left',
            elements = elements,
        },
        nil,
        function(data, menu)
            menu.close()
        end)
    end, vehicleData.plate)
end

local function showPlayerLicense(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		if data.licenses ~= nil then
			for i=1, #data.licenses, 1 do
				if data.licenses[i].label ~= nil and data.licenses[i].type ~= nil then
					table.insert(elements, {label = data.licenses[i].label, value = data.licenses[i].type})
				end
			end
		end

		local targetName = data.firstname .. ' ' .. data.lastname

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_license',
		{
			title    = T("MOBILEACTIONS_REVOKE_LICENSE"),
			align    = 'top-left',
			elements = elements,
		}, function(data, menu)
			ESX.ShowNotification((T("MOBILEACTIONS_LICENCE_YOU_REVOKED")):format(data.current.label, targetName))
            TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.current.value)

			ESX.SetTimeout(300, function()
				showPlayerLicense(player)
			end)
		end, function(data, menu)
			menu.close()
		end)

	end, GetPlayerServerId(player))
end

local function openUnpaidBillsMenu(player)
	local elements = {}

	ESX.TriggerServerCallback('esx_billing:getTargetBills', function(bills)
		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = T("MOBILEACTIONS_UNPAID_BILLS"),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end

local function isFacingFront(targetPlayer)
    -- Get your player (source)
    local sourcePlayer = PlayerPedId()
    -- Get positions of source and target
    local sourcePos = GetEntityCoords(sourcePlayer)
    local targetPos = GetEntityCoords(targetPlayer)

    -- Get forward vectors of source and target
    local targetForward = GetEntityForwardVector(targetPlayer)
    local directionToTarget = (sourcePos - targetPos)
    directionToTarget = vector3(
        directionToTarget.x / #(directionToTarget),
        directionToTarget.y / #(directionToTarget),
        directionToTarget.z / #(directionToTarget)
    )

    -- Dot product to determine relative facing
    local dotProduct = targetForward.x * directionToTarget.x +
                       targetForward.y * directionToTarget.y +
                       targetForward.z * directionToTarget.z

    -- If dotProduct is positive, you're facing the front; negative means back
    if dotProduct > 0 then
        return true -- Facing front
    else
        return false -- Facing back
    end
end

local function closestBodySearch()
    if not hasMobileActionPermission('body_search') then
        return
    end

    local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
    if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
        return
    end

    RequestAnimDict("anim@heists@prison_heistig1_p1_guard_checks_bus")

    while not HasAnimDictLoaded("anim@heists@prison_heistig1_p1_guard_checks_bus") do
        Citizen.Wait(150)
    end

    isPlayingAnim = true
    TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistig1_p1_guard_checks_bus", "loop", 8.0, 0.0, -1, 49, 0, false, false, false)

    TriggerEvent("cframework:openPlayerInventory", GetPlayerServerId(player), GetPlayerName(player))
end

local function openActionsMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}

    for _, v in pairs(Config.Stations[ESX.PlayerData.job.name].MobileAction) do
        if v.minGrade == nil or ESX.PlayerData.job.grade >= v.minGrade then
            if v.value == 'give_license' or v.value == 'take_license' then
                v.label = (T("MOBILEACTIONS_MENU_" .. v.value:upper())):format(T("LICENSE_" .. v.nome:upper()))
            else
                v.label = T("MOBILEACTIONS_MENU_" .. v.value:upper())
            end

            table.insert(elements, v)
        end
    end

    local data <const> = ESX.DefaultMenu(ESX.PlayerData.job.label, elements)

    if data == nil then return end

    if data.value == 'billing' then
        local amount <const> = tonumber(ESX.DialogMenu(T("MOBILEACTIONS_SEND_BILL")))
        local job = ESX.PlayerData.job.name

        if amount == nil or amount < 0 then ESX.ShowNotification(T("GENERIC_INVALID_AMOUNT"), 'error')
            return
        end

        local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        if ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'pm' then
            job = 'governo'
        end

        TriggerServerEvent('cframework:sendBill', GetPlayerServerId(player), 'society_' .. job, data.nome, amount)
    end


    if data.value == 'body_search' then
        closestBodySearch()
    end


    if data.value == 'handcuff' then
        local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 1.2 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:handcuff', GetPlayerServerId(player), isFacingFront(GetPlayerPed(player)))
    end


    if data.value == 'drag' then
        local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:drag', GetPlayerServerId(player))
    end


    if data.value == 'put_in_vehicle' then
        local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:putInVehicle', GetPlayerServerId(player))
    end


    if data.value == 'out_the_vehicle' then
        local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:OutVehicle', GetPlayerServerId(player))
    end

    if data.value == 'trailer_tow' then
        TrailerTowRoutine()
    end

    if data.value == 'hijack_vehicle' then
        local playerPed <const> = PlayerPedId()
        local vehicle <const> = ESX.Game.GetVehicleInDirection()

        if IsPedSittingInAnyVehicle(playerPed) then ESX.ShowNotification(T("VEHICLES_NO_INSIDE"), 'error')
            return
        end

        if vehicle == nil or not DoesEntityExist(vehicle) then ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
            return
        end

        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)

        Citizen.Wait(10000)

        SetVehicleDoorsLocked(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        ClearPedTasksImmediately(playerPed)

        ESX.ShowNotification(T("VEHICLES_UNLOCKED"), 'success')
    end


    if data.value == 'fix_vehicle' then
        local playerPed <const> = PlayerPedId()
        local vehicle <const> = ESX.Game.GetVehicleInDirection()

        if IsPedSittingInAnyVehicle(playerPed) then ESX.ShowNotification(T("VEHICLES_NO_INSIDE"), 'error')
            return
        end

        if vehicle == nil or not DoesEntityExist(vehicle) then ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
            return
        end

        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)

        Citizen.Wait(20000)

        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true, false)
        ClearPedTasksImmediately(playerPed)

        ESX.ShowNotification(T("VEHICLES_REPAIRED"), 'success')
    end


    if data.value == 'clean_vehicle' then
        local playerPed <const> = PlayerPedId()
        local vehicle <const> = ESX.Game.GetVehicleInDirection()

        if IsPedSittingInAnyVehicle(playerPed) then ESX.ShowNotification(T("VEHICLES_NO_INSIDE"), 'error')
            return
        end

        if vehicle == nil or not DoesEntityExist(vehicle) then ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
            return
        end

        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)

        Citizen.Wait(10000)

        SetVehicleDirtLevel(vehicle, 0)
        ClearPedTasksImmediately(playerPed)

        ESX.ShowNotification(T("VEHICLES_CLEANED"), 'success')
    end


    if data.value == 'del_vehicle' then
        local playerPed = PlayerPedId()

        if IsPedSittingInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                ESX.ShowNotification(T("VEHICLES_IMPOUNDED"), 'success')
                ESX.Game.DeleteVehicle(vehicle)
            else
                ESX.ShowNotification(T("VEHICLES_MUST_BE_DRIVER"), 'error')
            end
        else
            local vehicle = ESX.Game.GetVehicleInDirection()

            if vehicle ~= nil and DoesEntityExist(vehicle) then
                ESX.ShowNotification(T("VEHICLES_IMPOUNDED"), 'success')
                ESX.Game.DeleteVehicle(vehicle)
            else
                ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
            end
        end
    end


    if data.value == 'wheelchair' then -- revive
        TriggerEvent('useWheelChair')
    end

    if data.value == 'revive' then -- revive
        TriggerEvent("cframework:ambulanceRevive")
    end


    if data.value == 'damage' then
        ExecuteCommand('med')
    end


    if data.value == 'ems_small' then
        TriggerEvent("cframework:ambulanceHealSmall")
    end


    if data.value == 'ems_big' then
        TriggerEvent("cframework:ambulanceHealBig")
    end


    if data.value == 'unpaid_bills' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        openUnpaidBillsMenu(player)
    end


    if data.value == 'skin' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:openSkinMenuSurgery', GetPlayerServerId(player))
    end


    if data.value == 'give_license' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
            if hasLicense then ESX.ShowNotification(T("PLAYERS_HAS_LICENSE"), 'error')
                return
            end

            TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(player), data.nome)
            ESX.ShowNotification(T("PLAYERS_LICENSE_ATRIBUTTED") .. GetPlayerServerId(player), 'success')
        end, GetPlayerServerId(player), data.nome)
    end


    if data.value == 'take_license' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasLicense)
            if not hasLicense then ESX.ShowNotification(T("PLAYERS_NO_LICENSE"), 'error')
                return
            end

            TriggerServerEvent('esx_license:removeLicense', GetPlayerServerId(player), data.nome)
            ESX.ShowNotification(T("PLAYERS_LICENSE_REMOVED") .. GetPlayerServerId(player), 'success')
        end, GetPlayerServerId(player), data.nome)
    end


    if data.value == 'fine' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        openFineMenu(player)
    end


    if data.value == 'softcuff' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 1.2 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent('cframework:hardcuff', GetPlayerServerId(player))
    end


    if data.value == 'uncuff' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 1.2 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent("cframework:uncuff", GetPlayerServerId(player))
    end


    if data.value == 'license' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 3.0 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        showPlayerLicense(player)
    end


    if data.value == 'vehicle_infos' then
        local vehicle = ESX.Game.GetVehicleInDirection()
        if vehicle == nil or not DoesEntityExist(vehicle) then ESX.ShowNotification(T("VEHICLES_NO_NEARBY"), 'error')
            return
        end

        local vehicleData = ESX.Game.GetVehicleProperties(vehicle)
        openVehicleInfosMenu(vehicleData)
    end

    if data.value == 'tow' then
        TriggerEvent('cframework:tow')
    end


    if data.value == 'ankle_bracelet' then
      --OpenAnkleBraceletMenu()
    end

    if data.value == 'routes' then
        StartOrgRoute()
    end

    if data.value == 'put_bracelet' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 1.2 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent("cframework:putElectronicBracelet", GetPlayerServerId(player))
    end

    if data.value == 'take_bracelet' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance == -1 or distance > 1.2 then ESX.ShowNotification(T("PLAYERS_NO_NEARBY"), 'error')
            return
        end

        TriggerServerEvent("cframework:takeElectronicBracelet", GetPlayerServerId(player))
    end

end

function MobileAction()
    if ESX.isPlayerDead() then
        ESX.ShowNotification(T("PLAYERS_NO_MENU_WHEN_DEAD"), 'error')
        return
    end

    if Config.Stations[ESX.PlayerData.job.name].MenuGradeLimit and ESX.PlayerData.job.grade < Config.Stations[ESX.PlayerData.job.name].MenuGradeLimit then
        ESX.ShowNotification(T("PLAYERS_CANT_USE_MENU"), 'error')
        return
    end

    if ESX.isHandcuffed() then
        return
    end

    openActionsMenu()
end


RegisterNetEvent("cframework:OutVehicle", function()
    local plyPos <const> = GetEntityCoords(PlayerPedId(),  true)
    local xnew <const>, ynew <const> = plyPos.x + 2, plyPos.y + 2

    SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z, false, false, false, false)
end)

RegisterNetEvent("cframework:putInVehicle", function()
    local playerPed <const> = PlayerPedId()
    local coords <const> = GetEntityCoords(playerPed)

    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        return
    end

    local vehicle <const>, distance <const> = ESX.Game.GetClosestVehicle()

    if distance == -1 or distance > 5.0 then
        return
    end

    if not DoesEntityExist(vehicle) then
        return
    end

    local maxSeats <const> = GetVehicleMaxNumberOfPassengers(vehicle)
    local freeSeat = nil

    for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
            freeSeat = i
            break
        end
    end

    if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
    end
end)


RegisterCommand('bodysearch', function()
    closestBodySearch()
end, false)