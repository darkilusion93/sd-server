cachedVehicles = {}
cachedUsers = {}
cachedAccounts = {}
cachedBilling = {}
cachedContacts = {}

Citizen.CreateThread(function()
	SetRoutingBucketEntityLockdownMode(0, "inactive")

	Citizen.Wait(2000)

	MySQL.Async.fetchAll('SELECT * FROM billing', {}, function(result)
		for _,v in pairs(result) do
			if cachedBilling[v.identifier] == nil then cachedBilling[v.identifier] = {} end

			table.insert(cachedBilling[v.identifier], v)
		end

		print('[DATA] Cached all billing')
	end)
end)