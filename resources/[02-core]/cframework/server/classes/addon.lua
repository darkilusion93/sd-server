function CreateAddonAccount(name, owner, money)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money

	self.addMoney = function(m)
		self.money = self.money + m
		self.save()

		if string.find(self.name, "society_") then
			for player, _ in pairs(ESX.getJobSourceList(string.gsub(self.name, "society_", ""))) do
				TriggerClientEvent('esx_addonaccount:setMoney', player, self.name, self.money)
			end
		end
	end

	self.removeMoney = function(m)
		self.money = self.money - m
		self.save()

		if string.find(self.name, "society_") then
			for player, _ in pairs(ESX.getJobSourceList(string.gsub(self.name, "society_", ""))) do
				TriggerClientEvent('esx_addonaccount:setMoney', player, self.name, self.money)
			end
		end
	end

	self.setMoney = function(m)
		self.money = m
		self.save()

		if string.find(self.name, "society_") then
			for player, _ in pairs(ESX.getJobSourceList(string.gsub(self.name, "society_", ""))) do
				TriggerClientEvent('esx_addonaccount:setMoney', player, self.name, self.money)
			end
		end
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name', {
				['@account_name'] = self.name,
				['@money']        = self.money
			})
		else
			MySQL.Async.execute('UPDATE addon_account_data SET money = @money WHERE account_name = @account_name AND owner = @owner', {
				['@account_name'] = self.name,
				['@money']        = self.money,
				['@owner']        = self.owner
			})
		end
	end

	return self
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

function CreateDataStore(name, owner, data)
	local self = {}

	self.name  = name
	self.owner = owner
	self.data  = data

	local timeoutCallbacks = {}

	self.set = function(key, val)
		data[key] = val
		self.save()
	end

	self.get = function(key, i)
		local path = stringsplit(key, '.')
		local obj  = self.data

		for i=1, #path, 1 do
			obj = obj[path[i]]
		end

		if i == nil then
			return obj
		else
			return obj[i]
		end
	end

	self.count = function(key, i)
		local path = stringsplit(key, '.')
		local obj  = self.data

		for i=1, #path, 1 do
			obj = obj[path[i]]
		end

		if i ~= nil then
			obj = obj[i]
		end

		if obj == nil then
			return 0
		else
			return #obj
		end
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @name', {
				['@data'] = json.encode(self.data),
				['@name'] = self.name,
			})
		else
			MySQL.Async.execute('UPDATE datastore_data SET data = @data WHERE name = @name and owner = @owner', {
				['@data']  = json.encode(self.data),
				['@name']  = self.name,
				['@owner'] = self.owner,
			})
		end
	end

	return self
end
