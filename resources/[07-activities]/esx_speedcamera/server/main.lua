ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


RegisterServerEvent('esx_speedcamera:PayBill60Zone')
AddEventHandler('esx_speedcamera:PayBill60Zone', function(finalBillingPrice)
	local xPlayer = ESX.GetPlayerFromId(source)

	-- FIX (2026-06-12): multa fixa server-side. Antes usava o valor do cliente
	-- (finalBillingPrice) → mandar negativo dava dinheiro. Alinhado com 80/120.
	xPlayer.removeMoney(500)
end)

RegisterServerEvent('esx_speedcamera:PayBill80Zone')
AddEventHandler('esx_speedcamera:PayBill80Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(1000)	
end)

RegisterServerEvent('esx_speedcamera:PayBill120Zone')
AddEventHandler('esx_speedcamera:PayBill120Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(1500)
end)


RegisterServerEvent('esx_speedcamera:openGUI')
AddEventHandler('esx_speedcamera:openGUI', function()
	TriggerClientEvent('esx_speedcamera:openGUI', source)
end)

RegisterServerEvent('esx_speedcamera:closeGUI')
AddEventHandler('esx_speedcamera:closeGUI', function()
	TriggerClientEvent('esx_speedcamera:closeGUI', source)
end)



function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end