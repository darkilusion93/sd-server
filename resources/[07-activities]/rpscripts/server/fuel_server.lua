RegisterServerEvent('fuel:pay', function(price)
	local source = source
	-- FIX C14 (2026-06-12): rejeita preço <=0 (abastecer de graça) e limita o
	-- máximo por abastecimento. TODO: recalcular o custo do nível real de
	-- combustível server-side (vehiclesFuel[netId]) em vez de confiar no cliente.
	price = math.floor(tonumber(price) or 0)
	if price <= 0 or price > 2000 then return end
	local amount = ESX.Math.Round(price)
	local inventory <const> = ESX.getInvContainer(source)
	inventory.removeItem("cash", amount)
end)

RegisterServerEvent('cframework:buyJerrycan', function()
	local source = source
    local inventory <const> = ESX.getInvContainer(source)

	if Config.JerryCanCost > 0 and inventory.canAddItem('WEAPON_PETROLCAN', 1, nil, {ammo = 4500}) and inventory.canRemoveItem("cash", Config.JerryCanCost) then
        inventory.removeItem("cash", Config.JerryCanCost)
		inventory.addItem('WEAPON_PETROLCAN', 1, nil, {ammo = 4500})
	end
end)

local vehiclesFuel = {}
RegisterServerEvent('cframework:syncFuel', function(netId, fuel)
    local source = source

    vehiclesFuel[netId] = fuel
end)

exports('getVehicleFuel', function(netId)
    return vehiclesFuel[netId] or 0.0
end)

ESX.RegisterServerCallback('getFuelMoney', function(source, cb)
    local inventory <const> = ESX.getInvContainer(source)

    cb(inventory.getItemAmount("cash"))
end)

RegisterServerEvent('hookers:moneyCheck')
AddEventHandler('hookers:moneyCheck', function(service)
    local cost = Config.Prices[service]
    local src = source


    if ESX.getMoney(src) >= cost then
        ESX.removeMoney(src, cost)
        TriggerClientEvent('hookser:paymentReturn', src, true)
    else
        TriggerClientEvent('hookser:paymentReturn', src, false)
    end
end)
