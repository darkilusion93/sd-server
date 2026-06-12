local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

-- Open ID card
RegisterServerEvent('badge:open')
AddEventHandler('badge:open', function(ID, targetID, type)
	-- mostra-se SEMPRE o crachá do próprio caller (não de um ID arbitrário) → mata a fuga de PII
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	local identifier = xPlayer.identifier

	local xTarget = ESX.GetPlayerFromId(targetID)
	if not xTarget then return end
	local _source 	 = xTarget.source
	local show       = false

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height,job FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
	function (user)
		if (user[1] ~= nil) then
			MySQL.Async.fetchAll('SELECT type FROM users WHERE identifier = @identifier', {['@identifier'] = identifier},
			function (licenses)
				if type ~= nil then
					for i=1, #licenses, 1 do
						if type == 'driver' then
							if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
								show = true
							end
						elseif type =='weapon' then
							if licenses[i].type == 'weapon' then
								show = true
							end
						end
					end
				else
					show = true
				end

				if show then
					local array = {
						user = user,
						licenses = licenses
					}
					TriggerClientEvent('badge:open', _source, array, type)
					TriggerClientEvent( 'badge:shot', _source, source )
				else
					TriggerClientEvent('esx:showNotification', _source, "You don't have that type of license..")
				end
			end)
		end
	end)
end)
-- -----------------------------------------------------------------------------------
-- ESX.RegisterUsableItem("crachapsp",function(source)
--     local _source = source
--     local xPlayer  = ESX.GetPlayerFromId(_source)  
--     if xPlayer.job.name == 'police' then
--         TriggerClientEvent("badge:openPD",source)
       
      
--     else
-- 	  TriggerClientEvent('okokNotify:Alert', source, "Crachá da PSP", "Não podes usar o crachá da policia. Por favor entregue na esquadra mais proxima.", 10000, 'error')	
--     end
-- end)
-- -----------------------------------------------------------------------------------