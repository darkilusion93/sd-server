local availableActions = {
    ["quickCraft"] = true,
    ["idCard"] = true,
    ["fishingLeaderboard"] = false,
    ["huntingLeaderboard"] = false,
    ["fpsMenu"] = false,
}

function GetMobileAvailableMobilActions()
    return availableActions
end

RegisterNetEvent("cframework:updateMobileCraftUi", function()
    SendNUIMessage({
        action = "setMobileActionsCrafts",
        isCraftingAndNotCanceled = ESX.isCraftingAndNotCanceled(),
        currentCraftItem = ESX.getCurrentCraftItem(),
        itemList = ESX.getAvailableMobileCrafts()
    })
end)

RegisterNetEvent("cframework:chooseActionOption", function(id)
    if id == "quickCraft" then
        SendNUIMessage(
            {
                action = "setType",
                type = "mobilecraft"
            }
        )

        SendNUIMessage({
            action = "setMobileActionsCrafts",
            isCraftingAndNotCanceled = ESX.isCraftingAndNotCanceled(),
            currentCraftItem = ESX.getCurrentCraftItem(),
            itemList = ESX.getAvailableMobileCrafts()
        })

        return
    end

    if id == "fpsMenu" then
        if availableActions["fpsMenu"] then
            TriggerEvent("cframework:disableFpsOtimization")
            availableActions["fpsMenu"] = false
        else
            TriggerEvent("cframework:enableFpsOtimization")
            availableActions["fpsMenu"] = true
        end

        TriggerEvent("cframework:setAvailableActions", availableActions)

        return
    end
end)

RegisterNUICallback("startMobileCraft", function(data, cb)
    if ESX.isCraftingAndNotCanceled() then
        TriggerEvent("cframework:forceCancelCraft")
        TriggerEvent("cframework:updateMobileCraftUi")
        return
    end

    if type(data.value) == "number" and math.floor(data.value) == data.value then
        TriggerEvent('cframework:startMobileCraft', data.value)
    end

    cb("ok")
end)