

ESX.RegisterUsableItem('fixkit', function(source, slot)
	TriggerClientEvent('cframework:onFixkit', source, 'fixkit', slot)
end)

ESX.RegisterUsableItem('fixkith', function(source, slot)
	TriggerClientEvent('cframework:onFixkit', source, 'fixkith', slot)
end)

ESX.RegisterUsableItem('fixkitb', function(source, slot)
	TriggerClientEvent('cframework:onFixkit', source, 'fixkitb', slot)
end)

ESX.RegisterUsableItem('blowtorch', function(source, slot)
	TriggerClientEvent('cframework:onBlowtorchHijack', source, slot)
end)

RegisterNetEvent('cframework:useFixkit', function(type, slot)
	local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)

    if type ~= "fixkit" and type ~= "fixkith" and type ~= "fixkitb" and type ~= "blowtorch" then
        return
    end

	inventory.removeItem(type, 1, slot)
end)
