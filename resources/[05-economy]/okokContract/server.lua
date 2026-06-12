ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Webhook = 'https://discord.com/api/webhooks/'

RegisterServerEvent('okokContract:changeVehicleOwner')
AddEventHandler('okokContract:changeVehicleOwner', function(data)
	-- FIX C6 (2026-06-12): o COMPRADOR é sempre quem assina por último e dispara
	-- este evento → forçar pagador = source (consentimento). Antes o vendedor
	-- escolhia comprador+preço do cliente e drenava a conta de qualquer vítima.
	-- TODO: preço devia vir de uma oferta guardada server-side (não do cliente).
	local _source = tonumber(data.sourceIDSeller)   -- vendedor (dono da viatura)
	local target = source                            -- comprador = quem assina e paga
	local plate = data.plateNumberSeller
	local model = data.modelSeller
	local source_name = data.sourceNameSeller
	local target_name = data.targetNameSeller
	local vehicle_price = math.floor(tonumber(data.vehicle_price) or 0)

	if not _source or vehicle_price <= 0 or _source == target then return end

	local xPlayer = ESX.GetPlayerFromId(_source)
	local tPlayer = ESX.GetPlayerFromId(target)
	if not xPlayer or not tPlayer then return end
	local webhookData = {
		model = model,
		plate = plate,
		target_name = target_name,
		source_name = source_name,
		vehicle_price = vehicle_price
	}
	local result = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
		['@identifier'] = xPlayer.identifier,
		['@plate'] = plate
	})

	if Config.RemoveMoneyOnSign then
		local bankMoney = tPlayer.getAccount('bank').money

		if result[1] ~= nil  then
			if bankMoney >= vehicle_price then
				MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@target'] = tPlayer.identifier,
					['@plate'] = plate
				}, function (result2)
					if result2 ~= 0 then	
						tPlayer.removeAccountMoney('bank', vehicle_price)
						xPlayer.addAccountMoney('bank', vehicle_price)

						TriggerClientEvent('okokNotify:Alert', _source, "VEHICLE", "Você vendeu o veículo com sucesso <b>"..model.."</b> com o número da placa <b>"..plate.."</b>", 10000, 'success')
						TriggerClientEvent('okokNotify:Alert', target, "VEHICLE", "Você comprou o veículo com sucesso <b>"..model.."</b> com o número da placa <b>"..plate.."</b>", 10000, 'success')

						if Webhook ~= '' then
							sellVehicleWebhook(webhookData)
						end
					end
				end)
			else
				TriggerClientEvent('okokNotify:Alert', _source, "VEHICLE", target_name.." não tem dinheiro suficiente para comprar seu veículo", 10000, 'error')
				TriggerClientEvent('okokNotify:Alert', target, "VEHICLE", "Você não tem dinheiro suficiente para comprar"..source_name.."'s vehicle", 10000, 'error')
			end
		else
			TriggerClientEvent('okokNotify:Alert', _source, "VEHICLE", "O veículo com o número da placa <b>"..plate.."</b> não é seu", 10000, 'error')
			TriggerClientEvent('okokNotify:Alert', target, "VEHICLE", source_name.." tentou te vender um veículo que ele não possui", 10000, 'error')
		end
	else
		if result[1] ~= nil then
			MySQL.Async.execute('UPDATE owned_vehicles SET owner = @target WHERE owner = @owner AND plate = @plate', {
				['@owner'] = xPlayer.identifier,
				['@target'] = tPlayer.identifier,
				['@plate'] = plate
			}, function (result2)
				if result2 ~= 0 then
					TriggerClientEvent('okokNotify:Alert', _source, "VEHICLE", "Você vendeu o veículo com sucesso <b>"..model.."</b> com o número da placa <b>"..plate.."</b>", 10000, 'success')
					TriggerClientEvent('okokNotify:Alert', target, "VEHICLE", "Você comprou o veículo com sucesso <b>"..model.."</b> com o número da placa <b>"..plate.."</b>", 10000, 'success')

					if Webhook ~= '' then
						sellVehicleWebhook(webhookData)
					end
				end
			end)
		else
			TriggerClientEvent('okokNotify:Alert', _source, "VEHICLE", "O veículo com o número da placa <b>"..plate.."</b> não é seu", 10000, 'error')
			TriggerClientEvent('okokNotify:Alert', target, "VEHICLE", source_name.." tentou te vender um veículo que ele não possui", 10000, 'error')
		end
	end
end)

ESX.RegisterServerCallback('okokContract:GetTargetName', function(source, cb, targetid)
	local target = ESX.GetPlayerFromId(targetid)
	local targetname = target.getName()

	cb(targetname)
end)

RegisterServerEvent('okokContract:SendVehicleInfo')
AddEventHandler('okokContract:SendVehicleInfo', function(description, price)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('okokContract:GetVehicleInfo', _source, xPlayer.getName(), os.date(Config.DateFormat), description, price, _source)
end)

RegisterServerEvent('okokContract:SendContractToBuyer')
AddEventHandler('okokContract:SendContractToBuyer', function(data)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent("okokContract:OpenContractOnBuyer", data.targetID, data)
	TriggerClientEvent('okokContract:startContractAnimation', data.targetID)

	if Config.RemoveContractAfterUse then
		xPlayer.removeInventoryItem('contract', 1)
	end
end)

ESX.RegisterUsableItem('contract', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerClientEvent('okokContract:OpenContractInfo', _source)
	TriggerClientEvent('okokContract:startContractAnimation', _source)
end)




















-------------------------- SELL VEHICLE WEBHOOK

function sellVehicleWebhook(data)
	local information = {
		{
			["color"] = Config.sellVehicleWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Logs',
			},
			["title"] = 'VEHICLE SALE',
			["description"] = '**Vehicle: **'..data.model..'**\nPlate: **'..data.plate..'**\nBuyer name: **'..data.target_name..'**\nSeller name: **'..data.source_name..'**\nPrice: **'..data.vehicle_price..'€',

			["footer"] = {
				["text"] = os.date(Config.WebhookDateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end