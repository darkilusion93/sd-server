ESX						= nil
local PlayerData		= {}
local prog = false
local prog2 = false
local block = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

OpenStorage = function()
TriggerEvent("cframework:removeWeaponsFromHandInstant")
Citizen.Wait(150)
TriggerEvent("cframework:openPropertyInventory", 'property')
end  



