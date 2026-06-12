


AddEventHandler('weaponDamageEvent', function(sender, ev)
    --local selectedWeapon = GetSelectedPedWeapon(GetPlayerPed(sender))

    --if ev.weaponType ~= 2725352035 and ev.weaponType ~= selectedWeapon then
    --    CancelEvent()
    --    return
    --end

    if ev.weaponType == 3452007600 then
        CancelEvent()
        return
    end

    if ev.weaponType == 849905853 then
        CancelEvent()
        return
    end

    if ev.weaponType == 911657153 and GetSelectedPedWeapon(GetPlayerPed(sender)) ~= 911657153 then
        CancelEvent()
        return
    end

    if ev.weaponType == 911657153 and GetSelectedPedWeapon(GetPlayerPed(sender)) == 911657153 then
        local ped = NetworkGetEntityFromNetworkId(ev.hitGlobalId)
		local target = NetworkGetEntityOwner(ped)

        if #(GetEntityCoords(GetPlayerPed(sender)) - GetEntityCoords(GetPlayerPed(target))) > 11.0 then
            CancelEvent()
            return
        end
    end
end)

AddEventHandler('removeAllWeaponsEvent', function(sender, ev)
    CancelEvent()
end)

AddEventHandler('removeWeaponEvent', function(sender, ev)
    CancelEvent()
end)

AddEventHandler('giveWeaponEvent', function(sender, ev)
    TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(sender), ESX.GetPlayerFromId(sender), 'Sem Destino Anti-Cheat : Spawn de armas', nil, false)

    CancelEvent()
end)