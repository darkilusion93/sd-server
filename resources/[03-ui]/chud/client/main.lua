isInInventory = false
ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('cframework:getData', function(obj) ESX = obj end, 1)
        Citizen.Wait(0)
    end

    while not chudReady do Citizen.Wait(0) end

    SendNUIMessage({
        action = "setAvailableWeaponAttachments",
        extras = ESX.GetAllAttachments()
    })

    if not ESX.DEV then return end

    exports.ft_libs:RemoveButton("esx:inventoryhud_inventory")
    exports.ft_libs:AddButton("esx:inventoryhud_inventory", {
        key = Config.OpenControl,
        use = {
          callback = invOpen,
        },
    })
end)

function IsPlayerInInventory()
    return isInInventory
end

function invOpen()
    if IsPlayerInClothingMenu() or IsPlayerInInventory() then
        return
    end

    if not ESX.isPlayerDead() then
        openInventory()
    end
end

function compare(a,b)
    --if a.name == b.name then
    --    return a.ammo > b.ammo
    --end
    return a.name < b.name
end

AddEventHandler('playerSpawned', function(spawn)

    Citizen.Wait(15000) --prevent spawn exploits

    exports.ft_libs:RemoveButton("esx:inventoryhud_inventory")
    exports.ft_libs:AddButton("esx:inventoryhud_inventory", {
        key = Config.OpenControl,
        use = {
          callback = invOpen,
        },
    })
end)


RegisterNetEvent("cframework:updateInventory", function()
    if isInInventory then
        loadPlayerInventory()
    end
end)

function openInventory()
    loadPlayerInventory()
    isInInventory = true
    ESX.UI.Menu.CloseAll()

    TriggerEvent("chud:resetActivityLeaderboardFocus")

    local availableActions <const> = GetMobileAvailableMobilActions()

    TriggerEvent("cframework:setAvailableActions", availableActions)

    SendNUIMessage(
        {
            action = "setType",
            type = "normal"
        }
    )
    SendNUIMessage(
        {
            action = "display",
            type = "normal"
        }
    )
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(250.0)
    TriggerEvent('inventoryOpened')
end

RegisterNetEvent('inventoryOpened', function()
    Citizen.CreateThread(function()
        while isInInventory do
            Citizen.Wait(0)
            DisableControlAction(0, 1, true) -- Disable pan
            DisableControlAction(0, 2, true) -- Disable tilt
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 31, true) -- S (fault in Keys table!)
            DisableControlAction(0, 30, true) -- D (fault in Keys table!)

            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 23, true) -- Also 'enter'?

            DisableControlAction(0, 288, true) -- Disable phone
            DisableControlAction(0, 289, true) -- Inventory
            DisableControlAction(0, 170, true) -- Animations
            DisableControlAction(0, 167, true) -- Job

            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen

            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle

            DisableControlAction(2, 36, true) -- Disable going stealth

            DisableControlAction(0, 47, true) -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true) -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end)
end)

RegisterNetEvent("esx_inventoryhud:doClose", function()
    closeInventory()
end)

RegisterCommand('closeinv', function(source, args, raw)
    closeInventory()
end, false)

function closeInventory()
    SendNUIMessage(
        {
            action = "hide"
        }
    )
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(250.0)

    TriggerEvent('inventoryClosed')

    isInInventory = false
end

RegisterNUICallback("NUIFocusOff", function()
    closeInventory()
end)

RegisterNUICallback("getAttachmentItemName", function(data, cb)
    local itemName = ESX.GetItemFromAttachmentName(data.name)

    cb(itemName)
end)

RegisterNUICallback("backButtonPressed", function()
    TriggerEvent('cframework:backButtonPressed')
end)

RegisterNUICallback(
    "GetNearPlayers",
    function(data, cb)
        local playerPed = PlayerPedId()
        local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
        local foundPlayers = false
        local elements = {}

        for i = 1, #players, 1 do
            if players[i] ~= PlayerId() then
                foundPlayers = true

                table.insert(
                    elements,
                    {
                        label = GetPlayerName(players[i]),
                        player = GetPlayerServerId(players[i])
                    }
                )
            end
        end

        if not foundPlayers then
            ESX.ShowNotification('Sem jogadores nas proximidades.', 'error')
        else
            SendNUIMessage(
                {
                    action = "nearPlayers",
                    foundAny = foundPlayers,
                    players = elements,
                    item = data.item
                }
            )
        end

        cb("ok")
    end
)

RegisterNUICallback(
    "UseItem",
    function(data, cb)
        TriggerServerEvent("esx:useItem", data.item.slot, data.item.name)
        
        if shouldCloseInventory(data.item.name) then
            closeInventory()
        else
            Citizen.Wait(250)
            loadPlayerInventory()
        end

        cb("ok")
    end
)

RegisterNUICallback(
    "DropItem",
    function(data, cb)
        Wait(60000)
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            --TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
        end

        Wait(250)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback("changeSlot", function(data, cb)
    TriggerServerEvent("cframework:changeItemSlot", data.fromSlot, data.toSlot)

    cb("ok")
end)

RegisterNUICallback("splitSlot", function(data, cb)
    TriggerServerEvent("cframework:splitItemSlot", data.fromSlot, data.toSlot)

    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayer = false
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            if GetPlayerServerId(players[i]) == data.player then
                foundPlayer = true
            end
        end
    end

    if foundPlayer then
        local count = tonumber(data.number)

        TriggerServerEvent("cframework:giveInventoryItem", data.player, count, data.item.slot)
        Wait(250)
        loadPlayerInventory()
    else
        ESX.ShowNotification('O jogador já não está perto de ti.', 'error')
    end
    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

function loadPlayerInventory()
    --ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
    local pData = ESX.GetPlayerData()
    local items = {}
    local invData = pData.invData

    --print(json.encode(invData))

    --local accounts = pData.accounts
    --local money = pData.money
    --local weapons = pData.loadout

    --[[if Config.IncludeCash and money ~= nil and money > 0 then
        local moneyData = {
            label = _U("cash"),
            name = "cash",
            type = "item_money",
            count = money,
            usable = false,
            rare = false,
            limit = -1,
            canRemove = true
        }

        table.insert(items, moneyData)
    end

    if Config.IncludeAccounts and accounts ~= nil then
        for key, value in pairs(accounts) do
            if not shouldSkipAccount(accounts[key].name) then
                local canDrop = accounts[key].name ~= "bank"

                if accounts[key].money > 0 then
                    local accountData = {
                        label = accounts[key].label,
                        count = accounts[key].money,
                        type = "item_account",
                        name = accounts[key].name,
                        usable = false,
                        rare = false,
                        limit = -1,
                        canRemove = canDrop
                    }
                    table.insert(items, accountData)
                end
            end
        end
    end]]

    --[[if Config.IncludeWeapons and weapons ~= nil then
        for key, value in pairs(weapons) do
            local weaponHash = GetHashKey(weapons[key].name)
            local playerPed = PlayerPedId()
            if weapons[key].name ~= "WEAPON_UNARMED" then
                local ammo = weapons[key].ammo
                if HasPedGotWeapon(playerPed, weaponHash, false) then
                    ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                end

                if weapons[key].name ~= "WEAPON_KNIFE" and weapons[key].name ~= "WEAPON_CROWBAR" then
                    table.insert(
                        items,
                        {
                            label = weapons[key].label,
                            count = ammo,
                            limit = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            metadata = weapons[key].components,
                            usable = false,
                            rare = false,
                            canRemove = true
                        }
                    )
                else
                    table.insert(
                        items,
                        {
                            label = weapons[key].label,
                            count = ammo,
                            limit = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            metadata = weapons[key].components,
                            usable = true,
                            rare = false,
                            canRemove = true
                        }
                    )
                end
            end
        end
    end]]

    --print(json.encode(items))

    SendNUIMessage(
        {
            action = "setItems",
            itemList = invData.items,
            maxSlots = invData.slots
        }
    )
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        --SetCanPedEquipAllWeapons(PlayerPedId(), false)
        DisableControlAction(2, 37, true)

        DisableControlAction(2, 157, true)
        DisableControlAction(2, 158, true)
        DisableControlAction(2, 160, true)
        DisableControlAction(2, 164, true)
        DisableControlAction(2, 165, true)
        DisableControlAction(2, 159, true)
        DisableControlAction(2, 161, true)
        DisableControlAction(2, 162, true)
        DisableControlAction(2, 163, true)

        HudWeaponWheelIgnoreSelection()
    end
end)

local inFastSlotCooldown = false
local CTaskCombatRoll <const> = 3

local function useSlot(slot)
    local pData <const> = ESX.GetPlayerData()
    local items <const> = pData.invData.items
    local ped <const> = PlayerPedId()

    if inFastSlotCooldown then
        return
    end

    if GetIsTaskActive(ped, CTaskCombatRoll) then
        return
    end

    if ESX.isPlayerDead() or ESX.isHandcuffed() then
        return
    end

    if ESX.GetPlayerData().job.name == "police" and IsControlPressed(0, 217) then --Pressing ctrl
        TriggerEvent("cframework:resquestPoliceBackup", slot)
        return
    end

    inFastSlotCooldown = true

    for i = 1, #items, 1 do
        if items[i].slot == slot then
            TriggerServerEvent("esx:useItem", slot, items[i].name)
        end
    end

    Citizen.Wait(1000)
    inFastSlotCooldown = false
end

Citizen.CreateThread(function()
    for i = 1, 5 do
        RegisterKeyMapping("useslot"..i, 'Fastslot #'..i, 'keyboard', i.."")
        RegisterCommand("useslot"..i, function()
            useSlot(i)
        end, false)
    end
end)


RegisterKeyMapping("+togglefastlot", 'Show Fastslots', 'keyboard', "TAB")
RegisterCommand("+togglefastlot", function()
    local pData = ESX.GetPlayerData()
    local invData = pData.invData

    SendNUIMessage({action = "toggleQuickSlots", show = true, items = invData.items})
end, false)
RegisterCommand("-togglefastlot", function()
    SendNUIMessage({action = "toggleQuickSlots", show = false})
end, false)