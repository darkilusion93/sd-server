-- Title	:	cl_messages.lua
-- Author	:	Gonçalo Costa
-- Started	:	22/12/25


RegisterNUICallback("getLatestMessages", function(data, cb)
    TriggerServerEvent("cphone:getLatestMessages")

    cb("ok")
end)

RegisterNUICallback("getMessagesFromPhoneNumber", function(data, cb)
    TriggerServerEvent("cphone:getMessagesFromPhoneNumber", data.number)

    cb("ok")
end)

RegisterNetEvent("cphone:loadLatestMessages", function(messages)
    SendNUIMessage({action = "loadLatestMessages", messages = messages})
end)

RegisterNetEvent("cphone:loadMessagesFromPhoneNumber", function(number, messages)
    SendNUIMessage({action = "loadMessagesFromPhoneNumber", number = number, messages = messages})
end)

RegisterNUICallback('GetProfilePicture', function(data, cb)
    local picture = "default"--RPC.execute('cphone:server:GetPicture', data.number)

    cb(picture)
end)

RegisterNUICallback("SendMessage", function(data, cb)
    TriggerServerEvent("cphone:sendMessage", data.ChatMessage, data.ChatNumber, data.ChatType)

    cb("ok")
end)

RegisterNUICallback("ClearAlerts", function(data, cb)
    local chat = data.number

    TriggerServerEvent("cphone:setReadMessageNumber", chat)
end)

RegisterNetEvent("cphone:receiveMessage", function(message)
    SendNUIMessage({action = "UpdateChat", chatNumber = message.transmitter})

    if message.owner == 0 and HasPhone and not IsPhoneInAirPlaneMode() then
        TriggerEvent("cphone:showPhoneNotification", "Mensagens", "Nova mensagem de "..IsNumberInContacts(message.transmitter).."!", "fab fa-whatsapp", "#25D366")

        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", false, 0, true)
    end
end)

RegisterNUICallback("SharedLocation", function(data)
    local x = data.coords.x
    local y = data.coords.y

    SetNewWaypoint(x, y)

    TriggerEvent("cphone:showPhoneNotification", "Mensagens", "Coordenadas marcadas no GPS!", "fab fa-whatsapp", "#25D366")
end)

RegisterNUICallback("DeleteMessages", function(data)
    local ChatNumber = data.ChatNumber

    TriggerServerEvent("cphone:deleteMessageNumber", ChatNumber)
end)