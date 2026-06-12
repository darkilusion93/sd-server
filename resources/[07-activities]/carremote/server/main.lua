ESX          = nil
local owners = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('carremote:checkOwnedVehicle', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			if result[1].plate then
				cb(true)
			else
				cb(false)
			end
		end                
	end)
end)

ESX.RegisterServerCallback('carremote:checkOwnedVehicleJob', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
		['@owner'] = xPlayer.job.name,
		['@plate'] = plate
	}, function(result)
		if result[1] then
			if result[1].plate then
				cb(true)
			else
				cb(false)
			end
		end                
	end)
end)

-- FIX (2026-06-12): clamp de volume/distância + valida soundFile (antes qualquer
-- cliente fazia broadcast de som a volume/alcance arbitrários = DoS de áudio).
RegisterNetEvent('carremote:playSoundFromVehicle')
AddEventHandler('carremote:playSoundFromVehicle', function(maxDistance, soundFile, maxVolume, vehicleNetId)
	if type(soundFile) ~= "string" or #soundFile == 0 or #soundFile > 64 then return end
	maxDistance = math.min(tonumber(maxDistance) or 10.0, 50.0)
	maxVolume = math.min(math.max(tonumber(maxVolume) or 0.3, 0.0), 1.0)
	TriggerClientEvent('carremote:playSoundFromVehicle', -1, source, maxDistance, soundFile, maxVolume, vehicleNetId)
end)

RegisterNetEvent('carremote:playSound')
AddEventHandler('carremote:playSound', function(maxDistance, soundFile, soundVolume)
    if type(soundFile) ~= "string" or #soundFile == 0 or #soundFile > 64 then return end
    maxDistance = math.min(tonumber(maxDistance) or 10.0, 50.0)
    soundVolume = math.min(math.max(tonumber(soundVolume) or 0.3, 0.0), 1.0)
    TriggerClientEvent('carremote:playSound', -1, source, maxDistance, soundFile, soundVolume)
end)