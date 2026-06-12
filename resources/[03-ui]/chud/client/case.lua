local call = nil

local cases = {
    {name = "Basic", price = 10, items = {{name = "Basic", img = "default.png"}, {name = "Basic", img = "default.png"}, {name = "Basic", img = "default.png"}}, img = "default.png"},
    {name = "Silver", price = 20, items = {}, img = "default.png"},
    {name = "Gold", price = 30, items = {}, img = "default.png"},
    {name = "Premium", price = 40, items = {}, img = "default.png"},
    {name = "Advanced", price = 50, items = {}, img = "default.png"},
    {name = "Ultimate", price = 60, items = {}, img = "default.png"},
    {name = "Destino", price = 100, items = {}, img = "default.png"},
}

AddEventHandler('chud:case', function()
    SendNUIMessage(
        {
            action = "setType",
            type = "case"
        }
    )

    --call = callback

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            cases = cases
        }
    )

    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "case"
        }
    )

    SetNuiFocus(true, true)
    ESX.UI.Menu.CloseAll()
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end)

--[[RegisterNUICallback("textmenuSubmit", function(data, cb)
    call(data.value)

    cb("ok")
end)



RegisterCommand('abrircase', function()
    TriggerEvent('chud:case')
end)]]
