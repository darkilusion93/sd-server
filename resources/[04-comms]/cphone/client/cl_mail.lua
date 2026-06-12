RegisterNUICallback('mail_login', function(data, cb)
    local success, name, mails = RPC.execute('cframework:mail_login', data.username, data.password)

    cb({
        success = success,
        name = name,
        mails = mails
    })
end)

RegisterNUICallback('mail_register', function(data, cb)
    local success = RPC.execute('cframework:mail_register', data.username, data.password, data.name)

    cb({
        success = success
    })
end)

RegisterNUICallback('mail_send', function(data, cb)
    local success = RPC.execute('cframework:send_mail', data.sender, data.password, data.to, data.subject, data.message, {})

    cb({
        success = success
    })
end)

RegisterNUICallback('mail_getmails', function(data, cb)
    local mails = RPC.execute('cframework:mail_getmails', data.username, data.password)

    cb({
        mails = mails
    })
end)

RegisterNUICallback('mail_read', function(data, cb)
    TriggerServerEvent('cframework:mail_read', data.username, data.password, data.id)

    cb({})
end)

RegisterNUICallback('mail_logout', function(data, cb)
    TriggerServerEvent('cframework:mail_logout', data.username, data.password)

    cb({})
end)

RegisterNetEvent('cframework:mail_newmail', function(sender, senderName)
    TriggerEvent("cphone:showPhoneNotification", "Novo mail", senderName .. " (" .. sender .. ") " .. " enviou-te um mail", "fa-solid fa-envelope", "#1DA1F2")
end)