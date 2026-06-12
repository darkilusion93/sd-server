local sellableItems = {}

Citizen.CreateThread(function()
    for item,_ in pairs(PoliceAllowedItems) do
        table.insert(sellableItems, item)
    end

    for i,station in pairs(Config.Stations) do
        if station.BuyMenu == nil or #station.BuyMenu == 0 then
            goto jump_loop
        end

        for j,item in pairs(station.BuyMenu) do
            if string.find(item.name, "WEAPON_") or string.find(item.name, "GADGET_") then
                Config.Stations[i].BuyMenu[j].label = ESX.GetWeaponLabel(item.name)
            else
                Config.Stations[i].BuyMenu[j].label = ESX.GetItemLabel(item.name)
            end
        end

        ::jump_loop::
    end
end)

local function openBuyMenu(station)
    TriggerEvent("esx_inventoryhud:openShop", "org", Config.Stations[station].BuyMenu, "cash")
end

local function openOrgShop(station)
    local elements = {}

    if PlayerData.job.grade >= 7 and PlayerData.job.grade <=  11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_OFFICIALS"), value = 'oficiais'})
    end

    if PlayerData.job.grade >= 4 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SERGEANTS"),    value = 'sargentos'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_PRIVATES"), value = 'pracas'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SHERIFFS"), value = 'swat'})
    end

    TriggerEvent("cframework:openCustomShop", Config.Stations[station].BuyMenu, elements, T("ARMORYMENU_BUY"), function(data)
        TriggerServerEvent("cframework:buyPoliceShop", data.amount, data.selectedOption, data.items)
    end)
end

local function openPatrolKitMenu()
    local elements = {}
    local extraItems = {
        {label = ESX.GetWeaponLabel('WEAPON_COMBATPISTOL'), name = 'WEAPON_COMBATPISTOL', count = 1},
        {label = ESX.GetWeaponLabel('WEAPON_STUNGUN'), name = 'WEAPON_STUNGUN', count = 1},
        {label = ESX.GetWeaponLabel('WEAPON_NIGHTSTICK'), name = 'WEAPON_NIGHTSTICK', count = 1},
        {label = ESX.GetWeaponLabel('WEAPON_FLASHLIGHT'), name = 'WEAPON_FLASHLIGHT', count = 1}
    }

    if PlayerData.job.grade >= 7 and PlayerData.job.grade <=  11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_OFFICIALS"), value = 'oficiais'})
    end

    if PlayerData.job.grade >= 4 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SERGEANTS"),    value = 'sargentos'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_PRIVATES"), value = 'pracas'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SHERIFFS"), value = 'swat'})
    end

    TriggerEvent('chud:itemselector', elements, T("ARMORYMENU_PATROL_KIT"), T("ARMORYMENU_BUY_5000"), function(value)
        local bought <const> = RPC.execute('cframework:buyPatrolKit', value)

        if bought then
            ESX.ShowNotification(T("ARMORYMENU_BOUGHT_KIT"), 'success')
        else
            ESX.ShowNotification(T("GENERIC_NOT_ENOUGH_MONEY"), 'error')
        end
    end, extraItems)
end

local function openSellMenu()
    TriggerEvent('chud:dispense', T("GENERIC_SELL"), -1, sellableItems, function(items)
        TriggerEvent('esx_inventoryhud:doClose')
        TriggerServerEvent("cframework:sellPolice", items)
    end)
end

local function openOrgMenu()
    if Config.Stations[PlayerData.job.name].InventoryGradeLimit and PlayerData.job.grade < Config.Stations[PlayerData.job.name].InventoryGradeLimit then
        ESX.ShowNotification(T("ARMORYMENU_CANT_USE_MENU"), 'error')
        return
    end
    TriggerEvent("cframework:openOrgInventory")
end

function OpenArmoryMenuPolice()
    local elements = {}

    if PlayerData.job.grade >= 7 and PlayerData.job.grade <=  11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_OFFICIALS"), value = 'inventory2'})
    end

    if PlayerData.job.grade >= 4 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SERGEANTS"),    value = 'inventory3'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_PRIVATES"), value = 'inventory'})
    end

    if PlayerData.job.grade >= 1 and PlayerData.job.grade <= 11 then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_SHERIFFS"), value = 'inventory4'})
    end

    table.insert(elements, {label = '🗃️ ' .. T("ARMORYMENU_PERSONAL_STASH"),     value = 'cofre'})

    if PlayerData.job.grade_name == 'boss' or PlayerData.job.grade_name == 'chief' then
        table.insert(elements, {label = '🔦 ' .. T("ARMORYMENU_PATROL_EQUIPMENT"), value = 'patrulha2'})
        table.insert(elements, {label = '💵 ' .. T("ARMORYMENU_BUY_WEAPONS"), value = 'buy_weapons'})
        table.insert(elements, {label = '💸 ' .. T("ARMORYMENU_SELL_ITEMS"), value = 'sell_items'})
    end

    TriggerEvent('chud:menu', elements, T("ARMORYMENU_POLICE"), function(value)
        if value == 'inventory' then
            TriggerEvent("cframework:openOrgInventory")
        end

        if value == 'inventory2' then
            TriggerEvent("cframework:openOrgInventory", "sheriff")
        end

        if value == 'inventory3' then
            TriggerEvent("cframework:openOrgInventory", "swat")
        end

        if value == 'inventory4' then
            TriggerEvent("cframework:openOrgInventory", "swat_chefe")
        end

        if value == 'patrulha2' then
            openPatrolKitMenu()
        end

        if value == 'buy_weapons' then
            openOrgShop(ESX.PlayerData.job.name)
        end

        if value == 'cofre' then
            TriggerEvent("cframework:openPropertyInventory", 'police_vault')
        end

        if value == 'sell_items' then
            openSellMenu()
        end
    end)
end

function OpenArmoryMenu(station)
    local bossMenu <const> = PlayerData.job.name .. "_chefe"
    local elements = {
        {label = '📦 ' .. T("ARMORYMENU_INVENTORY"), value = 'inventory'},
    }

    if PlayerData.job.grade_name == 'boss' then
        table.insert(elements, {label = '🧰 ' .. T("ARMORYMENU_BOSS_INVENTORY"), value = 'inventory_boss'})
    end

    if Config.Stations[PlayerData.job.name].BuyMenuMinGrade == nil or PlayerData.job.grade >= Config.Stations[PlayerData.job.name].BuyMenuMinGrade then
        table.insert(elements, {label = '💸 ' .. T("ARMORYMENU_CRAFT_MENU"), value = 'buy_weapons'})
    end

    TriggerEvent('chud:menu', elements, T("ARMORYMENU_ARMORY"), function(value)
        if value == 'inventory' then
            openOrgMenu()
        end

        if value == 'inventory_boss' then
            TriggerEvent("cframework:openOrgInventory", bossMenu)
        end

        if value == 'buy_weapons' then
            openBuyMenu(station)
        end
    end)
end

RegisterNetEvent("cframework:boughtPoliceShop", function()
    ESX.ShowNotification(T("ARMORYMENU_SUCECEFULLY_BOUGHT"), "success")
end)

RegisterNetEvent("cframework:notEnoughMoneyOnPoliceVault", function()
    ESX.ShowNotification(T("ARMORYMENU_NOT_ENOUGH_POLICE_MONEY"), "error")
end)