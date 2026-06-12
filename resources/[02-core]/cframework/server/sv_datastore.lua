local DataStores, DataStoresIndex, SharedDataStores = {}, {}, {}

MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore')

    if result == nil then return end

	for i=1, #result, 1 do
		local name, label, shared = result[i].name, result[i].label, result[i].shared

		if shared == 0 then
			table.insert(DataStoresIndex, name)
			DataStores[name] = {}

			--for j=1, #result2, 1 do
			--	local storeName  = result2[j].name
			--	local storeOwner = result2[j].owner
			--	local storeData  = (result2[j].data == nil and {} or json.decode(result2[j].data))
			--	local dataStore  = CreateDataStore(storeName, storeOwner, storeData)

			--	DataStores[name][storeOwner] = dataStore
			--end
		else
            local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
                ['@name'] = name
            })
			local data = {}

            if result2 == nil then return end

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
					['@name'] = name
				})
			else
				data = json.decode(result2[1].data)
			end

			local dataStore = CreateDataStore(name, nil, data)
			SharedDataStores[name] = dataStore
		end
	end
end)

function GetDataStore(name, owner)
    if DataStores[name][owner] == nil then
        local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE owner = @owner', {
			['@owner'] = owner
		})

        if result2 == nil then return end

        for j=1, #result2, 1 do
			local storeName  = result2[j].name
			local storeOwner = result2[j].owner
			local storeData  = (result2[j].data == nil and {} or json.decode(result2[j].data))

            if DataStores[storeName][storeOwner] == nil then
                local dataStore  = CreateDataStore(storeName, storeOwner, storeData)

                DataStores[storeName][storeOwner] = dataStore
            end
		end
    end

	return DataStores[name][owner]
end

function GetSharedDataStore(name)
	return SharedDataStores[name]
end

AddEventHandler('esx_datastore:getDataStore', function(name, owner, cb)
	cb(GetDataStore(name, owner))
end)

AddEventHandler('esx_datastore:getDataStoreOwners', function(name, cb)
	print("deprecated function datastore get owners, do not use")
	--cb(GetDataStoreOwners(name))
end)

AddEventHandler('esx_datastore:getSharedDataStore', function(name, cb)
	cb(GetSharedDataStore(name))
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local doQuery = false

    for i=1, #DataStoresIndex, 1 do
		local name = DataStoresIndex[i]
		local dataStore = DataStores[name][xPlayer.identifier]

		if dataStore == nil then
            doQuery = true
		end
	end

    if doQuery then
        local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE owner = @owner', {
			['@owner'] = xPlayer.identifier
		})

        if result2 == nil then return end

        for j=1, #result2, 1 do
			local storeName  = result2[j].name
			local storeOwner = result2[j].owner
			local storeData  = (result2[j].data == nil and {} or json.decode(result2[j].data))

            if DataStores[storeName][storeOwner] == nil then
                local dataStore  = CreateDataStore(storeName, storeOwner, storeData)

                DataStores[storeName][storeOwner] = dataStore
            end
		end
    end

	for i=1, #DataStoresIndex, 1 do
		local name = DataStoresIndex[i]
		local dataStore = DataStores[name][xPlayer.identifier]

		if dataStore == nil then
			MySQL.Async.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, @owner, @data)', {
				['@name']  = name,
				['@owner'] = xPlayer.identifier,
				['@data']  = '{}'
			})

			dataStore = CreateDataStore(name, xPlayer.identifier, {})
			DataStores[name][xPlayer.identifier] = dataStore
		end
	end
end)