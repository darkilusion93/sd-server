local partNumCraft = nil

RegisterNetEvent("esx_inventoryhud:openCraft",function(craftData, partNum)
    partNumCraft = partNum
    setCraftData(craftData)
    openCraft()
end)

RegisterNetEvent("cframework:updateCraftingInfo", function(craftData, partNum)
    if partNumCraft ~= partNum or not isInInventory then
        return
    end

    setCraftData(craftData)
end)

function setCraftData(craftData)
    SendNUIMessage(
        {
            action = "setType",
            type = "craft"
        }
    )

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            isCraftingAndNotCanceled = ESX.isCraftingAndNotCanceled(),
            itemList = craftData
        }
    )
end

function openCraft()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "craft"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
    TriggerServerEvent("cframework:requestCraftUpdates", partNumCraft)
end

AddEventHandler("inventoryClosed", function()
    if partNumCraft == nil then
        return
    end

    partNumCraft = nil
    TriggerServerEvent("cframework:stopCraftUpdates")
end)

RegisterNUICallback("CraftItem", function(data, cb)
    if ESX.isCraftingAndNotCanceled() then
        TriggerEvent("cframework:forceCancelCraft")
        return
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        local count = tonumber(data.number)

        TriggerEvent('cframework:startCraft', partNumCraft, data.itemIndex, count)
    end

    --closeInventory()

    cb("ok")
end)