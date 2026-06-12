ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'taxi', 'taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'private'})

local taxiCooldown = {}

RegisterServerEvent('esx_taxijob:success')
AddEventHandler('esx_taxijob:success', function()

  math.randomseed(os.time())

  local xPlayer        = ESX.GetPlayerFromId(source)
  -- FIX (2026-06-12): exige job de taxi + cooldown (antes qualquer jogador
  -- spamava o evento para farmar pagamentos NPC).
  if not xPlayer or xPlayer.job.name ~= 'taxi' then return end
  local now = os.time()
  if taxiCooldown[source] and (now - taxiCooldown[source]) < 20 then return end
  taxiCooldown[source] = now

  local total          = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max);
  local societyAccount = nil

  if xPlayer.job.grade >= 3 then
    total = total * 2
  end

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_taxi', function(account)
    societyAccount = account
  end)

  if societyAccount ~= nil then

    local playerMoney  = math.floor(total / 100 * 30)
    local societyMoney = math.floor(total / 100 * 70)

    xPlayer.addMoney(playerMoney)
    societyAccount.addMoney(societyMoney)

    TriggerClientEvent('esx:showNotification', xPlayer.source, "Recebeste " .. playerMoney .. "€")

  else

    xPlayer.addMoney(total)
    TriggerClientEvent('esx:showNotification', xPlayer.source, "Recebeste " .. total .. "€")

  end

end)

RegisterServerEvent('esx_taxijob:getStockItem')
AddEventHandler('esx_taxijob:getStockItem', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= count then
      inventory.removeItem(itemName, count)
      xPlayer.addInventoryItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantidade inválida")
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, "Retiraste " .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_taxijob:getStockItems', function(source, cb)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
    cb(inventory.items)
  end)

end)

RegisterServerEvent('esx_taxijob:putStockItems')
AddEventHandler('esx_taxijob:putStockItems', function(itemName, count)

  local xPlayer = ESX.GetPlayerFromId(source)

  TriggerEvent('esx_addoninventory:getSharedInventory', 'society_taxi', function(inventory)

    local item = inventory.getItem(itemName)

    if item.count >= 0 then
      xPlayer.removeInventoryItem(itemName, count)
      inventory.addItem(itemName, count)
    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, "Quantidade inválida")
    end

    TriggerClientEvent('esx:showNotification', xPlayer.source, "Adicionaste " .. count .. ' ' .. item.label)

  end)

end)

ESX.RegisterServerCallback('esx_taxijob:getPlayerInventory', function(source, cb)

  local xPlayer    = ESX.GetPlayerFromId(source)
  local items      = xPlayer.inventory

  cb({
    items      = items
  })

end)
