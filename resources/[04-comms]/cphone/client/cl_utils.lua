-- Title	:	cl_utils.lua
-- Author	:	Gonçalo Costa
-- Started	:	30/03/25

RegisterNetEvent("cphone:showPhoneNotification", function(title, text, icon, color)
    SendNUIMessage({
        action = "PhoneNotification",
        PhoneNotify = {
            title = title,
            text = text,
            icon = icon,
            color = color,
        },
    })
end)