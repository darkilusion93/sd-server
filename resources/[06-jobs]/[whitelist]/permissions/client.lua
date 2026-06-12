RegisterNetEvent("core_evidence:permissao_ueps")
AddEventHandler("core_evidence:permissao_ueps", function(res)
    if res then
        exports['mythic_notify']:SendAlert('inform', 'Modo UEPS Ativado', 5000)
    else
        exports['mythic_notify']:SendAlert('inform', 'Modo UEPS Desativado!', 5000)
    end
end)

RegisterNetEvent("core_evidence:permissao_cic")
AddEventHandler("core_evidence:permissao_cic", function(res)
    if res then
        exports['mythic_notify']:SendAlert('inform', 'Modo Investigação Criminal Ativado!', 5000)
    else
        exports['mythic_notify']:SendAlert('inform', 'Modo Investigação Criminal Desativado!', 5000)
    end
end)


RegisterNetEvent("core_evidence:permissao_transito")
AddEventHandler("core_evidence:permissao_transito", function(res)
    if res then
        exports['mythic_notify']:SendAlert('inform', 'Modo Trânsito Ativado', 5000)
    else
        exports['mythic_notify']:SendAlert('inform', 'Modo Trânsito Desativado!', 5000)
    end
end)
RegisterNetEvent("core_evidence:permissao_k9")
AddEventHandler("core_evidence:permissao_k9", function(res)
    if res then
        exports['mythic_notify']:SendAlert('inform', 'Modo K9 Ativado', 5000)
    else
        exports['mythic_notify']:SendAlert('inform', 'Modo K9 Desativado!', 5000)
    end
end)

