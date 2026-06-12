RegisterNUICallback("chooseActionOption", function(data, cb)
    TriggerEvent("cframework:chooseActionOption", data.id)

    cb("ok")
end)

AddEventHandler("cframework:setAvailableActions", function(data)
    local actionsAvailable <const> = data

    SendNUIMessage({
        action = "setActions",
        actions = actionsAvailable
    })
end)