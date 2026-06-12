

RegisterNetEvent("cframework:weaponInHandNotValid", function()
    ESX.ShowNotification(T("ATTACHS_WEAPON_NOT_VALID"), "error")
end)

RegisterNetEvent("cframework:attachmentNotValid", function()
    ESX.ShowNotification(T("ATTACHS_NOT_VALID"), "error")
end)

RegisterNetEvent("cframework:alreadyHasAttachment", function()
    ESX.ShowNotification(T("ATTACHS_ALREADY_HAVE"), "error")
end)