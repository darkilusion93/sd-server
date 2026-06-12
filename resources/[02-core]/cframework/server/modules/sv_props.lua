local playersWithProps, playersWithSecondProps, poolCues = {}, {}, {}

---Creates entities to attach
---@param prop string
RegisterNetEvent("cframework:createPropToAttach", function(prop)
    local source = source

    Citizen.CreateThread(function()
        local coords <const> = GetEntityCoords(GetPlayerPed(source))

        if attachPropList[prop] == nil or attachPropList[prop].model == nil then return end

        --Only allow one prop per player
        if playersWithProps[source] ~= nil and DoesEntityExist(playersWithProps[source]) then
            DeleteEntity(playersWithProps[source])
            playersWithProps[source] = nil
        end

        local propEntity <const> = CreateObject(GetHashKey(attachPropList[prop].model), coords.x, coords.y, coords.z - 10.0, true, true, false)

        --Store prop for later checks
        playersWithProps[source] = propEntity

		local curTime <const> = os.time()

		while not DoesEntityExist(propEntity) do
			Citizen.Wait(0)

			if os.time() - curTime > 10 then return end
		end

        --Set entity routing bucket based on player routing bucket
        local playerBucket <const> = GetPlayerRoutingBucket(source)

        SetEntityRoutingBucket(propEntity, playerBucket)

        TriggerClientEvent('cframework:attachProp', source, NetworkGetNetworkIdFromEntity(propEntity), prop)
    end)
end)


---Creates entities to attach
---@param prop string
RegisterNetEvent("cframework:createSecondPropToAttach", function(prop)
    local source = source

    Citizen.CreateThread(function()
        local coords <const> = GetEntityCoords(GetPlayerPed(source))

        if attachPropList[prop] == nil or attachPropList[prop].model == nil then return end

        --Only allow one prop per player
        if playersWithSecondProps[source] ~= nil and DoesEntityExist(playersWithSecondProps[source]) then
            DeleteEntity(playersWithSecondProps[source])
            playersWithSecondProps[source] = nil
        end

        local propEntity <const> = CreateObject(GetHashKey(attachPropList[prop].model), coords.x, coords.y, coords.z - 10.0, true, true, false)

        --Store prop for later checks
        playersWithSecondProps[source] = propEntity

		local curTime <const> = os.time()

		while not DoesEntityExist(propEntity) do
			Citizen.Wait(0)

			if os.time() - curTime > 10 then return end
		end

        --Set entity routing bucket based on player routing bucket
        local playerBucket <const> = GetPlayerRoutingBucket(source)

        SetEntityRoutingBucket(propEntity, playerBucket)

        TriggerClientEvent('cframework:attachProp', source, NetworkGetNetworkIdFromEntity(propEntity), prop)
    end)
end)


---Creates entities to attach
AddEventHandler("cframework:createPoolCue", function(source)
    Citizen.CreateThread(function()
        local coords <const> = GetEntityCoords(GetPlayerPed(source))

        --Only allow one prop per player
        if poolCues[source] ~= nil and DoesEntityExist(poolCues[source]) then
            DeleteEntity(poolCues[source])
            poolCues[source] = nil
        end

        local propEntity <const> = CreateObject(`prop_pool_cue`, coords.x, coords.y, coords.z, true, true, false)

        --Store prop for later checks
        poolCues[source] = propEntity

		local curTime <const> = os.time()

		while not DoesEntityExist(propEntity) do
			Citizen.Wait(0)

			if os.time() - curTime > 10 then return end
		end

        --Set entity routing bucket based on player routing bucket
        local playerBucket <const> = GetPlayerRoutingBucket(source)

        SetEntityRoutingBucket(propEntity, playerBucket)

        TriggerClientEvent('cframework:receivePoolCueEntity', source, NetworkGetNetworkIdFromEntity(propEntity))
    end)
end)

RegisterNetEvent("cframework:destroyPoolCue", function()
    local source = source

    --Find pool cue and destroy
    if poolCues[source] ~= nil and DoesEntityExist(poolCues[source]) then
        DeleteEntity(poolCues[source])
        poolCues[source] = nil
    end
end)


---Destroys attached props
RegisterNetEvent("cframework:destroyAttachedProp", function()
    local source = source

    --Find the attached prop and destroy it
    if playersWithProps[source] ~= nil and DoesEntityExist(playersWithProps[source]) then
        DeleteEntity(playersWithProps[source])
        playersWithProps[source] = nil
    end

    --Find the attached second prop and destroy it
    if playersWithSecondProps[source] ~= nil and DoesEntityExist(playersWithSecondProps[source]) then
        DeleteEntity(playersWithSecondProps[source])
        playersWithSecondProps[source] = nil
    end
end)


---Destroys attached props
AddEventHandler('playerDropped', function(_)
	local source = source

    --Find the attached prop and destroy it
    if playersWithProps[source] ~= nil and DoesEntityExist(playersWithProps[source]) then
        DeleteEntity(playersWithProps[source])
        playersWithProps[source] = nil
    end

    --Find the attached second prop and destroy it
    if playersWithSecondProps[source] ~= nil and DoesEntityExist(playersWithSecondProps[source]) then
        DeleteEntity(playersWithSecondProps[source])
        playersWithSecondProps[source] = nil
    end

    --Find pool cue and destroy
    if poolCues[source] ~= nil and DoesEntityExist(poolCues[source]) then
        DeleteEntity(poolCues[source])
        poolCues[source] = nil
    end
end)