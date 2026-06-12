


RegisterServerEvent("cframework:handcuff", function(target, isFacingFront)
    local source = source

    if not ESX.HasMobileActionPermission(source, "handcuff") then
        return
    end

    if target == -1 then return end

    if not IsEntityVisible(GetPlayerPed(source)) then return end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) > 10.0 then
        return
    end

    TriggerClientEvent('cframework:toggleHandcuff', target, isFacingFront)

    --ESX.logOrgActionsData(source, "ALGEMAR", ESX.getJob(source).name, ESX.getJob(source).label, target)
end)

RegisterServerEvent("cframework:drag", function(target)
    local source = source

    if not ESX.HasMobileActionPermission(source, "drag") then
        return
    end

    if target == -1 then return end

    if not IsEntityVisible(GetPlayerPed(source)) then return end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) > 10.0 then
        return
    end

    TriggerClientEvent("cframework:startDrag", target, source)
end)

RegisterServerEvent("cframework:hardcuff", function(targetid)
    local source = source
    local playerPed <const> = GetPlayerPed(source)
    local playerCoords <const>, playerheading <const> = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

    if not ESX.HasMobileActionPermission(source, "softcuff") then
        return
    end

    if targetid == -1 then return end

    if not IsEntityVisible(GetPlayerPed(source)) then return end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) > 10.0 then
        return
    end

    TriggerClientEvent("cframework:getArrested", targetid, playerheading, playerCoords, ESX.calculateForwardVectorDegrees(playerheading))
    TriggerClientEvent("cframework:doArrestAnim", source)

	--ESX.logOrgActionsData(source, "ALGEMAR", ESX.getJob(source).name, ESX.getJob(source).label, targetid)
end)

RegisterServerEvent('cframework:uncuff', function(targetid)
    local source = source
    local playerPed <const> = GetPlayerPed(source)
    local playerCoords <const>, playerheading <const> = GetEntityCoords(playerPed), GetEntityHeading(playerPed)

    if not ESX.HasMobileActionPermission(source, "uncuff") then
        return
    end

    if targetid == -1 then return end

    if not IsEntityVisible(GetPlayerPed(source)) then return end

    if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetid))) > 10.0 then
        return
    end

    TriggerClientEvent("cframework:getUncuffed", targetid, playerheading, playerCoords, ESX.calculateForwardVectorDegrees(playerheading))
    TriggerClientEvent("cframework:doReleaseAnim", source)

	--ESX.logOrgActionsData(source, "ALGEMAR", ESX.getJob(source).name, ESX.getJob(source).label, targetid)
end)
