

RegisterNetEvent("cframework:useClip", function(slot, carregador)
    local ped <const> = PlayerPedId()

    if not IsPedArmed(ped, 4) then ESX.ShowNotification(T("WEAPON_NOT_USING"), "error")
        return
    end

    local hash <const> = GetSelectedPedWeapon(ped)

    if not ESX.compatibleClip(hash, carregador) then ESX.ShowNotification(T("WEAPON_CLIP_INCOMPATIBLE"), "error")
        return
    end

    AddAmmoToPed(ped, hash, 25)

    TriggerServerEvent("cframework:clipRemove", slot, carregador, ESX.GetWeaponInHandSlot(), GetAmmoInPedWeapon(ped, hash))

    ESX.ShowNotification(T("WEAPON_USED_CLIP"), "success")
end)