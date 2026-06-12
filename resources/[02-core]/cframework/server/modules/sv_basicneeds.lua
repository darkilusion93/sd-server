ESX.RegisterUsableItem('condom', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

	inventory.removeItem('condom', 1, slot)
    TriggerClientEvent('useCondom', source)
end)

ESX.RegisterUsableItem('suede', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

	inventory.removeItem('suede', 1, slot)
    TriggerClientEvent('UseItem', source, 'suede')
end)

ESX.RegisterUsableItem('cigarett', function(source, slot)
	local inventory <const> = ESX.getInvContainer(source)
	local lighterAmount <const> = inventory.getItemAmount("lighter")

    if lighterAmount <= 0 then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NO_LIGHTER"), 'error')
        return
    end

    inventory.removeItem('cigarett', 1, slot)
    TriggerClientEvent('startSmoke', source)
end)

ESX.RegisterUsableItem('cigar', function(source, slot)
	local inventory <const> = ESX.getInvContainer(source)
	local lighterAmount <const> = inventory.getItemAmount("lighter")

    if lighterAmount <= 0 then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NO_LIGHTER"), 'error')
        return
    end

    inventory.removeItem('cigar', 1, slot)
    TriggerClientEvent('startSmokeCigar', source)
end)

ESX.RegisterUsableItem('blunt', function(source, slot)
	local inventory <const> = ESX.getInvContainer(source)
	local lighterAmount <const> = inventory.getItemAmount("lighter")

    if lighterAmount <= 0 then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NO_LIGHTER"), 'error')
        return
    end

    inventory.removeItem('blunt', 1, slot)
    TriggerClientEvent('startSmokeWeed', source)
end)

ESX.RegisterUsableItem('rolling_paper', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)
	local weed <const> = inventory.getItemAmount('weed_pooch')
	local weedNew <const> = inventory.getItemAmount('weed_pooch_new')
    local hashish <const> = inventory.getItemAmount('hashish_pooch')
    local cigarett <const> = inventory.getItemAmount('cigarett')

	if weed > 0 then
        TriggerClientEvent('startEnrolar', source)
    	inventory.removeItem('weed_pooch', 1)
		inventory.removeItem('rolling_paper', 1, slot)
		inventory.addItem('blunt', 1)
    elseif weedNew > 0 then
        TriggerClientEvent('startEnrolar', source)
    	inventory.removeItem('weed_pooch_new', 1)
		inventory.removeItem('rolling_paper', 1, slot)
		inventory.addItem('blunt', 1)
    elseif hashish > 0 then
        if cigarett <= 0 then
            TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NEED_CIGARRRETT"), 'error')
            return
        end

        TriggerClientEvent('startEnrolar', source)
    	inventory.removeItem('hashish_pooch', 1)
		inventory.removeItem('rolling_paper', 1, slot)
        inventory.removeItem('cigarett', 1)
		inventory.addItem('blunt', 1)
	else
		TriggerClientEvent('esx:showNotification', source, T("ACTIONS_NEED_WEED"), 'error')
	end
end)

ESX.RegisterUsableItem('adrenaline_shot', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

	inventory.removeItem('adrenaline_shot', 1, slot)
	TriggerClientEvent('esx_optionalneeds:onAdrenaline', source)
end)

ESX.RegisterUsableItem('tranquilizer', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)
    local playerPed <const> = GetPlayerPed(source)

    if DoesEntityExist(GetVehiclePedIsIn(playerPed, false)) then
        TriggerClientEvent('esx:showNotification', source, T("ACTIONS_CANT_USE_IN_VEHICLE"), 'error')
        return
    end

    inventory.removeItem('tranquilizer', 1, slot)
	TriggerClientEvent('esx_optionalneeds:syringetrigger', source)
    TriggerClientEvent('esx:showNotification', source, T("ACTIONS_USED_TRANQUILIZER"), 'inform')
end)

ESX.RegisterUsableItem('nitro', function(source, slot)
	local inventory <const> = ESX.getInvContainer(source)

    inventory.removeItem('nitro', 1, slot)
    TriggerClientEvent('cframework:nitro', source)
end)

ESX.RegisterUsableItem('anchor', function(source)
	TriggerClientEvent('client:anchor', source)
end)

ESX.RegisterUsableItem('binoculars', function(source)
	TriggerClientEvent('cframework:useBinoculars', source)
end)

ESX.RegisterUsableItem('cam', function(source)
    TriggerClientEvent("cframework:toggleAnimProp", source, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", "tvcamera02", true)
end)

ESX.RegisterUsableItem('bmic', function(source)
    TriggerClientEvent("cframework:toggleAnimProp", source, "missfra1", "mcs2_crew_idle_m_boom", "boomMIKE01", true)
end)

ESX.RegisterUsableItem('mic', function(source)
    TriggerClientEvent("cframework:toggleAnimProp", source, "missheistdocksprep1hold_cellphone", "hold_cellphone", "tvmic01", false)
end)

RegisterServerEvent('esx_optionalneeds:syringe', function(targetid, playerheading, playerCoords,  playerlocation)
    TriggerClientEvent('esx_optionalneeds:syringe', targetid, playerheading, playerCoords, playerlocation)
end)
