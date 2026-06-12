ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

jobslist = {
  "grove",
  "ballas",
  "gang",
  "mafia",
  "cartel",
  "mungiki",
  "tequilla",
  "vagos",
  "black",
  "casino",
  "mob",
  "party",
"docks",
"purple",
"coast",
"golf",
"revisao",
"usados",
"sata",
"ammunation",
"vigne",
"unicorn",
"offroad",
"yakuza",
"snake",
"galaxy",
}

for k, v in pairs(jobslist) do
	TriggerEvent('esx_society:registerSociety', v, v, 'society_' .. v, 'society_' .. v, 'society_' .. v, {type = 'public'})
	TriggerEvent('esx_service:activateService', v, -1)
end


function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end
  

-- FIX C10 (2026-06-12): whitelist de armas construída do config (todos os
-- AuthorizedWeapons em qualquer Config.*). Antes giveWeapon dava QUALQUER
-- item em QUALQUER quantidade sem validação.
local authorizedWeapons
local function isAuthorizedWeapon(name)
  if not authorizedWeapons then
    authorizedWeapons = {}
    local function scan(t, depth)
      if type(t) ~= "table" or depth > 6 then return end
      for k, v in pairs(t) do
        if k == "AuthorizedWeapons" and type(v) == "table" then
          for _, w in ipairs(v) do
            if type(w) == "table" and w.name then authorizedWeapons[w.name] = true end
          end
        elseif type(v) == "table" then
          scan(v, depth + 1)
        end
      end
    end
    scan(Config, 0)
  end
  return authorizedWeapons[name] == true
end

RegisterServerEvent('esx_mafiajob:giveWeapon')
AddEventHandler('esx_mafiajob:giveWeapon', function(weapon, count)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return end
  if not xPlayer.job or xPlayer.job.name == 'unemployed' then return end
  if type(weapon) ~= "string" or not isAuthorizedWeapon(weapon) then return end
  count = math.floor(tonumber(count) or 0)
  if count <= 0 or count > 1000 then count = 1000 end
  xPlayer.addInventoryItem(weapon, count)
end)

RegisterNetEvent('esx_mafiajob:getStockItem')
AddEventHandler('esx_mafiajob:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local job = xPlayer.job.name

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
		local inventoryItem = inventory.getItem(itemName)
		count = math.floor(tonumber(count) or 0)
		if count > 0 and inventoryItem.count >= count then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. count .. ' ' .. inventoryItem.label)
			else
				xPlayer.showNotification(_U('quantity_invalid'))
			end
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mafiajob:getStockItems', function(source, cb)
  local items = {
      {name = 'weapon_bullpuprifle', label = 'QBZ', count = 10}
  }
  cb(items)
end)

RegisterNetEvent('esx_mafiajob:putStockItems')
AddEventHandler('esx_mafiajob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = xPlayer.job.name
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
		local inventoryItem = inventory.getItem(itemName)
		count = math.floor(tonumber(count) or 0)
		if count > 0 and sourceItem.count >= count then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('added') .. count .. ' ' .. inventoryItem.label)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end
	end)
end)

ESX.RegisterServerCallback('esx_mafiajob:getOtherPlayerData', function(source, cb, target)

    local xPlayer = ESX.GetPlayerFromId(target)

    local identifier = GetPlayerIdentifiers(target)[1]

    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
      ['@identifier'] = identifier
    })

    local user      = result[1]
    local firstname     = user['firstname']
    local lastname      = user['lastname']
    local sex           = user['sex']
    local dob           = user['dateofbirth']
    local height        = user['height'] .. " Inches"

    local data = {
      name        = GetPlayerName(target),
      job         = xPlayer.job,
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      weapons     = xPlayer.loadout,
      firstname   = firstname,
      lastname    = lastname,
      sex         = sex,
      dob         = dob,
      height      = height
    }

    TriggerEvent('esx_status:getStatus', source, 'drunk', function(status)

      if status ~= nil then
        data.drunk = math.floor(status.percent)
      end

    end)

      TriggerEvent('esx_license:getLicenses', source, function(licenses)
        data.licenses = licenses
        cb(data)
      end)

end)

ESX.RegisterServerCallback('esx_mafiajob:getArmoryWeapons', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  
  local job = xPlayer.job.name

  TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. job, function(store)

    local weapons = store.get('weapons')

    if weapons == nil then
      weapons = {}
    end

    cb(weapons)

  end)

end)


ESX.RegisterServerCallback('esx_mafiajob:buy', function(source, cb, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  
  local job = xPlayer.job.name

  TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. job, function(account)

    if account.money >= amount then
      account.removeMoney(amount)
      cb(true)
    else
      cb(false)
    end

  end)

end)

ESX.RegisterServerCallback('esx_mafiajob:getStockItems', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  
  if xPlayer then
    local job = xPlayer.job.name

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_' .. job, function(inventory)
      if inventory and inventory.items then
        cb(inventory.items)
      else
        cb({}) -- Retorna uma tabela vazia caso o inventário seja nulo ou não tenha itens
      end
    end)
  else
    cb({}) -- Retorna uma tabela vazia caso o jogador não seja encontrado
  end
end)



ESX.RegisterServerCallback('cayo:getVehicles', function(source, callback)
  local xPlayer = ESX.GetPlayerFromId(source)
  local playerVehicles = {}

  if xPlayer.job.name == 'docks' then
  table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO A01", state = true })
  table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO A02", state = true })
  table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO A03", state = true })
  table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO A04", state = true })
  table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO A05", state = true })
  table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO A06", state = true })
  table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO A07", state = true })
  table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO A08", state = true })
  table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO A09", state = true })
  table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO A10", state = true })
  table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO A11", state = true })
  table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO A12", state = true })
  elseif xPlayer.job.name == 'ballas' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO B01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO B02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO B03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO B04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO B05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO B06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO B07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO B08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO B09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO B10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO B11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO B12", state = true })
  elseif xPlayer.job.name == 'party' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO C01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO C02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO C03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO C04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO C05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO C06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO C07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO C08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO C09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO C10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO C11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO C12", state = true })
  elseif xPlayer.job.name == 'black' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO D01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO D02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO D03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO D04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO D05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO D06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO D07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO D08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO D09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO D10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO D11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO D12", state = true })
  elseif xPlayer.job.name == 'vagos' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO E01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO E02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO E03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO E04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO E05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO E06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO E07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO E08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO E09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO E10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO E11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO E12", state = true })
  elseif xPlayer.job.name == 'mafia' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO F01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO F02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO F03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO F04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO F05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO F06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO F07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO F08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO F09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO F10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO F11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO F12", state = true })
  elseif xPlayer.job.name == 'cartel' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO G01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO G02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO G03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO G04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO G05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO G06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO G07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO G08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO G09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO G10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO G11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO G12", state = true })
  elseif xPlayer.job.name == 'grove' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO H01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO H02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO H03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO H04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO H05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO H06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO H07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO H08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO H09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO H10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO H11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO H12", state = true })
  elseif xPlayer.job.name == 'purple' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO I01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO I02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO I03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO I04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO I05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO I06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO I07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO I08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO I09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO I10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO I11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO I12", state = true })
  elseif xPlayer.job.name == 'tequilla' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO J01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO J02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO J03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO J04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO J05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO J06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO J07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO J08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO J09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO J10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO J11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO J12", state = true })
  elseif xPlayer.job.name == 'gang' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO K01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO K02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO K03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO K04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO K05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO K06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO K07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO K08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO K09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO K10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO K11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO K12", state = true })
  elseif xPlayer.job.name == 'snake' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO L01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO L02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO L03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO L04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO L05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO L06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO L07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO L08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO L09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO L10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO L11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO L12", state = true })
  elseif xPlayer.job.name == 'mungiki' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO M01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO M02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO M03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO M04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO M05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO M06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO M07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO M08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO M09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO M10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO M11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO M12", state = true })
  elseif xPlayer.job.name == 'yakuza' then
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO N01", state = true })
    table.insert(playerVehicles, { vehicle = { model = "verus" }, plate = "CAYO N02", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO N03", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bifta" }, plate = "CAYO N04", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO N05", state = true })
    table.insert(playerVehicles, { vehicle = { model = "bodhi2" }, plate = "CAYO N06", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO N07", state = true })
    table.insert(playerVehicles, { vehicle = { model = "squaddie" }, plate = "CAYO N08", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO N09", state = true })
    table.insert(playerVehicles, { vehicle = { model = "winky" }, plate = "CAYO N10", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO N11", state = true })
    table.insert(playerVehicles, { vehicle = { model = "vetir" }, plate = "CAYO N12", state = true })

  end

  callback(playerVehicles)
end)



function SpawnGaragensCayo(vehicle, plate, x, y, z, h, job)
  TriggerClientEvent('cayo:spawnGaragensCayo', -1, vehicle, plate, x, y, z, h, job)
  TriggerServerEvent('cayo:modifystate', plate, false)

end

function GuardarCayo(vehicle, plate)
  TriggerClientEvent('cayo:deleteVehicle', -1, vehicle)
  TriggerServerEvent('cayo:modifystate', plate, true)
  exports['mythic_notify']:SendAlert('Inform', 'O veículo foi guardado', 4000)
end

RegisterServerEvent('esx_mafiajob:putInVehicle')
AddEventHandler('esx_mafiajob:putInVehicle', function(target)
  TriggerClientEvent('esx_mafiajob:putInVehicle', target)
end)

RegisterServerEvent('esx_mafiajob:OutVehicle')
AddEventHandler('esx_mafiajob:OutVehicle', function(target)
    TriggerClientEvent('esx_mafiajob:OutVehicle', target)
end)


ESX.RegisterServerCallback('esx_mafiajob:getVehicleInfos', function(source, cb, plate)

  if Config.EnableESXIdentity then

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local ownerName = result[1].firstname .. " " .. result[1].lastname

              local infos = {
                plate = plate,
                owner = ownerName
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  else

    MySQL.Async.fetchAll(
      'SELECT * FROM owned_vehicles',
      {},
      function(result)

        local foundIdentifier = nil

        for i=1, #result, 1 do

          local vehicleData = json.decode(result[i].vehicle)

          if vehicleData.plate == plate then
            foundIdentifier = result[i].owner
            break
          end

        end

        if foundIdentifier ~= nil then

          MySQL.Async.fetchAll(
            'SELECT * FROM users WHERE identifier = @identifier',
            {
              ['@identifier'] = foundIdentifier
            },
            function(result)

              local infos = {
                plate = plate,
                owner = result[1].name
              }

              cb(infos)

            end
          )

        else

          local infos = {
          plate = plate
          }

          cb(infos)

        end

      end
    )

  end

end)



ESX.RegisterServerCallback('esx_mafiajob:getPlayerInventory', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  local items   = xPlayer.inventory

  cb({
    items = items
  })

end)

RegisterServerEvent('esx_mafiajob:dartabuleiro')
AddEventHandler('esx_mafiajob:dartabuleiro', function(targetPlayerId, action)
    local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    if targetPlayer then
        if action == 'tabuleiro' then
          TriggerClientEvent('esx_mafiajob:ComecarAnimTabuleio',targetPlayerId, action)
        elseif action == 'tabuleiro2' then
         
          TriggerClientEvent('esx_mafiajob:ComecarAnimTabuleio',targetPlayerId, action)
        elseif action == 'tabuleiro3' then
          
          TriggerClientEvent('esx_mafiajob:ComecarAnimTabuleio',targetPlayerId, action)
        end
    end
end)

RegisterNetEvent('esx:mafia:sata_porao')
AddEventHandler('esx:mafia:sata_porao', function (targetPlayer)
  local source = source
  local xPlayer = ESX.GetPlayerFromId(source)
  local targetPlayerSource = ESX.GetPlayerFromId(targetPlayer)

  if xPlayer and targetPlayerSource then
    TriggerClientEvent('TxDEV:chaveporao', targetPlayerSource.source,true)
  end
end)