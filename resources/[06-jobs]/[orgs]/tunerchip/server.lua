ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local cS,dS,wDS
ESX.RegisterUsableItem("tuning_laptop",function(source)
    if not cS then return; end
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('tuning_laptop', 1)
    TriggerClientEvent("tuning:useLaptop",source)
end)

ESX.RegisterServerCallback("tuning:CheckStats",function(source,cb,veh)
  MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate=@plate',{['@plate'] = veh.plate},function(retData)
    if retData and retData[1] and cS then
      cb(true,json.decode(retData[1].tunerdata))
    else
      cb(false,false)
    end
  end)  
end)

-- FIX (2026-06-12): só o DONO do veículo pode mexer no tunerdata da matrícula.
-- Antes qualquer jogador punha/limpava chip em qualquer matrícula.
RegisterNetEvent('tuning:SetData')
AddEventHandler('tuning:SetData', function(data,veh)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer or type(veh) ~= 'table' or not veh.plate then return end
  MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate=@plate AND owner=@owner',{['@plate'] = veh.plate, ['@owner'] = xPlayer.identifier},function(retData)
    if retData and retData[1] and wDS then
      MySQL.Async.execute('UPDATE owned_vehicles SET tunerdata=@tunerdata WHERE plate=@plate AND owner=@owner',{['@tunerdata'] = json.encode(data),['@plate'] = veh.plate, ['@owner'] = xPlayer.identifier},function(data)
      end)
    end
  end)
end)

RegisterNetEvent('tuning:UnSetData')
AddEventHandler('tuning:UnSetData', function(veh)
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer or type(veh) ~= 'table' or not veh.plate then return end
  MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate=@plate AND owner=@owner',{['@plate'] = veh.plate, ['@owner'] = xPlayer.identifier},function(retData)
    if retData and retData[1] and wDS then
      MySQL.Async.execute('UPDATE owned_vehicles SET tunerdata=@tunerdata WHERE plate=@plate AND owner=@owner',{['@tunerdata'] = '',['@plate'] = veh.plate, ['@owner'] = xPlayer.identifier},function(data)
      end)
    end
  end)
end)

xPlyId = function(source)
  local tick = 0
  while not xPlayer and tick < 1000 do
    tick = tick + 1
    xPlayer = ESX.GetPlayerFromId(source)
    Citizen.Wait(0)
  end
  return xPlayer or false
end

local CT = Citizen.CreateThread
DoAwake = function(...)
  while not ESX do Citizen.Wait(0); end
	  DSP(true)
      dS = true
      sT()
end
ErrorLog = function(msg) print(msg) end
DSP = function(val) cS = val; end
sT = function(...) if dS and cS then wDS = 1; end; end
CT(function(...) DoAwake(...); end)
