
local KEY = 2254

function secondsToClock(seconds)
	if seconds <= 0 then
		return "00:00:00"
	end

    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
end

local timeClock = secondsToClock(tonumber(ESX.Math.Round(Config.timer / 1000)))

RegisterServerEvent('washMoney', function(amount, zone, returnedKey)
	local source = source
    local inventory <const> = ESX.getInvContainer(source)

	if not (returnedKey and returnedKey == KEY) then TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat: MoneyWash', nil, false) 
		return
	end

	local job = ESX.getJob(source)

	if job.grade_name ~= "boss" then TriggerClientEvent('esx:showNotification', source, 'Não tens cargo suficiente para lavar dinheiro.', 'error')
		return
	end

	local amount = ESX.Math.Round(tonumber(amount))
	if amount <= 0 or not inventory.canRemoveItem("black_money", amount) then TriggerClientEvent('esx:showNotification', source, 'Quantidade inválida', 'error')
		return
	end

	if Config.WashZones[zone] == nil then return end

	local washedTotal = ESX.Math.Round(tonumber(amount * Config.WashZones[zone].Percentage))

    if not inventory.canAddItem("cash", washedTotal) then
        TriggerClientEvent('esx:showNotification', source, 'Não tens espaço suficiente no inventário.', 'error')
        return
    end

	inventory.removeItem("black_money", amount)
	TriggerClientEvent('washMoney', source, timeClock)
	Citizen.Wait(Config.timer)
	inventory.addItem("cash", washedTotal)
	TriggerClientEvent('washedMoney', source, washedTotal)
end)