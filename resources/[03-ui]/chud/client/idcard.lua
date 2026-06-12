RegisterNetEvent('chud:idcard', function(elements)
    if ESX.isPlayerDead() then
        return
    end

    local mugshot = ESX.GetMugShotBase64(PlayerPedId(), false)

    SendNUIMessage(
        {
            action = "setType",
            type = "idcard"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = elements,
            mugshot = mugshot
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "idcard"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

RegisterNUICallback('idcardClick', function(data, cb)
    local player <const>, distance <const> = ESX.Game.GetClosestPlayer()
    if distance == -1 or distance > 3.0 then
        return
    end

    TriggerServerEvent("cframework:showLicense", GetPlayerServerId(player), data.type)

    cb('ok')
end)

RegisterNetEvent('chud:buildIdCardBlob', function(targetSource, elements)
    local mugshot = ESX.GetMugShotBase64(GetPlayerPed(GetPlayerFromServerId(targetSource)), false)

    SendNUIMessage(
        {
            action = "buildIdCardBlob",
            itemList = elements,
            mugshot = mugshot
        }
    )
end)

RegisterNetEvent("cframework:chooseActionOption", function(id)
    if id == "idCard" then
        TriggerServerEvent("cframework:getShowableLicenses")
    end
end)

RegisterNUICallback('sendCapturedIdcard', function(data, cb)
    if type(data) ~= 'table' or type(data.base64) ~= 'string' then
        cb({ ok = false, err = 'invalid' })
        return
    end

    local base64 = data.base64

    TriggerEvent('chat:addMessage', {  multiline = true,  args = {base64} })
    cb({ ok = true })
end)

--[[
RegisterCommand('abrirmen', function()
    TriggerServerEvent("cframework:showLicense", 1, "idcard")
end)

RegisterCommand('abrirmen', function()
    local elements = {
        ["idcard"] = {
            name = "Gonçalo Costa",
            sex = "M",
            height = "185",
            birthdate = "07-01-2001",
            citizenid = "YASXR8"
        },
        ["hunting"] = {
            name = "Gonçalo Costa",
            birthdate = "07-01-2001",
            cardnumber = "6066"
        },
        ["license"] = {
            name = "Gonçalo Costa",
            sex = "M",
            height = "185",
            birthdate = "07-01-2001",
            types = {"CAR", "BIKE", "TRUCK"}
        },
        ["firearm"] = {
            name = "Gonçalo Costa",
            birthdate = "07-01-2001",
        },
    }

    TriggerEvent('chud:idcard', elements)

end)]]
