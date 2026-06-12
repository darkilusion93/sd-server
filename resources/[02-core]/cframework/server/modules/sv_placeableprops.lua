local placedBarriers = {}

ESX.RegisterUsableItem('barrier', function(source, slot)
    local inventory <const> = ESX.getInvContainer(source)

	inventory.removeItem('barrier', 1, slot)

    TriggerClientEvent('cframework:placePropAnim', source)
	Citizen.Wait(1000)

	local coords <const> = GetEntityCoords(GetPlayerPed(source))
	local propEntity <const> = CreateObject(`prop_barrier_work05`, coords.x, coords.y, coords.z - 1.0, true, true, false)

    SetEntityHeading(propEntity, GetEntityHeading(GetPlayerPed(source)))

	placedBarriers[propEntity] = true
end)

RegisterServerEvent('cframework:removeBarrier', function(netId)
	local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
	local propEntity = NetworkGetEntityFromNetworkId(netId)

    TriggerClientEvent('cframework:placePropAnim', source)
	Citizen.Wait(1000)

	if placedBarriers[propEntity] == nil then
		return
	end

	DeleteEntity(propEntity)
	placedBarriers[propEntity] = nil

	inventory.addItem('barrier', 1)
end)