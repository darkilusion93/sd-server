function CreateExtendedPlayer(userData)
	local self = {}

	self.source 			= userData.source
	self.permission_level 	= userData.permissionLevel
	self.identifier 		= userData.identifier
	self.license 			= userData.license
	self.group 				= userData.group

	self.firstName 			= userData.firstname
	self.lastName 			= userData.lastname
	self.skin				= userData.skin
	self.bank 		    	= userData.bank
	self.accounts       	= userData.accounts
	self.iban				= userData.iban
    self.extraSlots         = userData.extraSlots or 0
	self.inventory      	= CreateInventory("player", userData.identifier, ESX.GetBaseInvSlots(userData.job.name, userData.extraSlots or 0))
	self.job            	= userData.job
	self.name           	= userData.playerName
	self.lastPosition   	= userData.lastPosition
	self.phoneNumber    	= userData.phone_number
	self.armour		    	= userData.armour
	self.report	  	    	= userData.canReport
	self.experience     	= userData.experience
	self.globalplaytime 	= userData.globalPlayTime
    self.status        	    = userData.status
    self.taxEvading     	= false

	self.loadoutLoaded  	= false
	self.loadoutFlaged		= false

	self.vip 				= userData.vip
	self.coins          	= userData.coins

	self.vehicles			= userData.vehicles
    self.boostCoins         = userData.boostCoins
	self.dead				= userData.isDead
	self.deathData      	= userData.deathData

	self.overridecoords 	= nil
	self.inJobService		= false

	self.inAdminMode		= false

	self.logtime	  		= os.time()
	self.logtime2	  		= os.time()

	self.cooldownTimer		= 0

	self.communityservice 	= userData.communityservice

	-- FXServer <3
	ExecuteCommand('add_principal identifier.' .. self.identifier .. ' group.' .. self.group)

	-- Make sure we receive updates from the inventory
	self.inventory.addUpdateListener(self.source)

    self.getBoostCoins = function()
        return self.boostCoins
    end

    self.setBoostCoins = function(boostCoins)
        self.boostCoins = boostCoins

        TriggerClientEvent("cframework:updateBoostCoins", self.source, boostCoins)
    end

    self.getExtraSlots = function()
        return self.extraSlots
    end

    self.setExtraSlots = function(extraSlots)
        self.extraSlots = extraSlots

        self.inventory.setSlots(ESX.GetBaseInvSlots(self.job.name, self.extraSlots))
    end

	self.getActionsRemaining = function()
		return self.communityservice
	end

	self.setActionsRemaining = function(actions)
		self.communityservice = actions
	end

	self.isLoadoutLoaded = function()
		return self.loadoutLoaded
	end

	self.setLoadoutLoaded = function(loaded)
		self.loadoutLoaded = loaded
	end

	self.isDead = function()
		return self.dead
	end

	self.setDead = function(isDead, dData)
		self.dead = isDead
		self.deathData = dData
	end

	self.isLoadoutFlaged = function()
		return self.loadoutFlaged
	end

	self.setLoadoutFlaged = function(flaged)
		self.loadoutFlaged = flaged
	end

	self.setOverrideCoords = function(coords)
		self.overridecoords = coords
	end

    self.getOverrideCoords = function()
		return self.overridecoords
	end

	self.inService = function()
		return self.inJobService
	end

	self.setService = function(state)
		self.inJobService = state
	end

    self.isTaxEvading = function()
        return self.taxEvading
    end

    self.setTaxEvading = function(state)
        self.taxEvading = state
    end

	self.inAdmin = function()
		return self.inAdminMode
	end

	self.setAdmin = function(state)
		self.inAdminMode = state
	end

	self.passedCooldown = function(cooldown)
		local now = GetGameTimer()

		if now - self.cooldownTimer > cooldown then
			self.cooldownTimer = now
			return true
		end

		return false
	end

	self.getPlayTime = function()
		local cTime	= os.time()
		local sessionTime = cTime - self.logtime2

		return self.globalplaytime + sessionTime
	end

	self.getFirstName = function()
		return self.firstName
	end

	self.getLastName = function()
		return self.lastName
	end

	self.setFirstName = function(name)
		self.firstName = name
	end

	self.setLastName = function(name)
		self.lastName = name
	end

	self.getSkin = function()
		return self.skin
	end

	self.setSkin = function(skin)
		self.skin = skin
	end

	self.getIban = function()
		return self.iban
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
            local currentMoney = self.inventory.getItemAmount("cash")
            local diff = money - currentMoney

            if diff > 0 then
                self.inventory.addItem("cash", diff)
            elseif diff < 0 then
                self.inventory.removeItem("cash", -diff)
            end
		else
			print(('cframework: %s attempted exploiting! (reason: player tried setting -1 cash balance)'):format(self.identifier))
		end
	end

	self.getMoney = function()
		return self.inventory.getItemAmount("cash")
	end

	self.setBankBalance = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.bank = money
			TriggerEvent("es:setBank", self.source, money)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried setting -1 bank balance)'):format(self.identifier))
		end
	end

	self.getBank = function()
		return self.bank
	end

	self.getAccounts2 = function()
		return self.accounts
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.inventory.addItem("cash", money)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried adding -1 cash balance)'):format(self.identifier))
		end
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			self.inventory.removeItem("cash", money)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried removing -1 cash balance)'):format(self.identifier))
		end
	end

	self.getCoins = function()
		return self.coins
	end

	self.addCoins = function(coins)
		coins = ESX.Math.Round(coins)

		if coins >= 0 then
			local newCoins = self.coins + coins

			self.coins = newCoins

			TriggerClientEvent("cframework:updateCoins", self.source, newCoins)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried adding -1 cash balance)'):format(self.identifier))
		end
	end

	self.removeCoins = function(coins)
		coins = ESX.Math.Round(coins)

		if coins >= 0 then
			local newCoins = self.coins - coins

			self.coins = newCoins

			TriggerClientEvent("cframework:updateCoins", self.source, newCoins)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried removing -1 cash balance)'):format(self.identifier))
		end
	end

	self.addBank = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			local newBank = self.bank + money

			self.bank = newBank
			TriggerEvent("es:addBank", self.source, newBank)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried adding -1 bank balance)'):format(self.identifier))
		end
	end

	self.removeBank = function(money)
		money = ESX.Math.Round(money)

		if money >= 0 then
			local newBank = self.bank - money

			self.bank = newBank
			TriggerEvent("es:addBank", self.source, newBank)
		else
			print(('cframework: %s attempted exploiting! (reason: player tried removing -1 bank balance)'):format(self.identifier))
		end
	end

	self.getPermissions = function()
		return self.permission_level
	end

	self.setPermissions = function(p)
		self.permission_level = p
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.getPhoneNumber = function()
		return self.phoneNumber
	end

	self.setPhoneNumber = function(phoneNumber)
		self.phoneNumber = phoneNumber
	end

	self.getGroup = function()
		return self.group
	end

	self.set = function(k, v)
		self[k] = v
	end

	self.get = function(k)
		return self[k]
	end

	self.getPlayer = function()
		return self.player
	end

	self.getAccounts = function()
		local accounts = {}

		for i=1, #Config.Accounts, 1 do
			if Config.Accounts[i] == 'bank' then

				table.insert(accounts, {
					name  = 'bank',
					money = self.bank,
					label = Config.AccountLabels['bank']
				})

			else

				for j=1, #self.accounts, 1 do
					if self.accounts[j].name == Config.Accounts[i] then
						table.insert(accounts, self.accounts[j])
					end
				end

			end
		end

		return accounts
	end

	self.getAccount = function(a)
		if a == 'bank' then
			return {
				name  = 'bank',
				money = self.bank,
				label = Config.AccountLabels['bank']
			}
		end

		for i=1, #self.accounts, 1 do
			if self.accounts[i].name == a then
				return self.accounts[i]
			end
		end
	end

	self.getInventory = function()
		return self.inventory.getItems()
	end

    self.getInvContainer = function()
		return self.inventory
	end

	self.getJob = function()
		return self.job
	end

	self.getName = function()
		return self.name
	end

	self.canReport = function()
		return self.report
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.getLastPosition = function()
		if self.lastPosition and self.lastPosition.x and self.lastPosition.y and self.lastPosition.z then
            return {x = ESX.Math.Round(self.lastPosition.x, 1), y = ESX.Math.Round(self.lastPosition.y, 1), z = ESX.Math.Round(self.lastPosition.z, 1)}
		end

		return self.lastPosition
	end

	self.setLastPosition = function(position)
		self.lastPosition = position
	end

	self.getMissingAccounts = function(cb)
		local result = cachedAccounts[self.getIdentifier()]
		local missingAccounts = {}

		for i=1, #Config.Accounts, 1 do
			if Config.Accounts[i] ~= 'bank' then
				local found = false

				for j=1, #result, 1 do
					if Config.Accounts[i] == result[j].name then
						found = true
						break
					end
				end

				if not found then
					table.insert(missingAccounts, Config.Accounts[i])
				end
			end
		end

		cb(missingAccounts)
	end

	self.createAccounts = function(missingAccounts, cb)
		for i=1, #missingAccounts, 1 do
			table.insert(cachedAccounts[self.getIdentifier()], {
				name  = missingAccounts[i],
				money = 0,
				label = Config.AccountLabels[missingAccounts[i]]
			})

			MySQL.Async.execute('INSERT INTO `user_accounts` (identifier, name) VALUES (@identifier, @name)', {
				['@identifier'] = self.getIdentifier(),
				['@name']       = missingAccounts[i]
			})

			if cb ~= nil then
				cb()
			end
		end
	end

	self.setAccountMoney = function(acc, money)
		if money < 0 then
			print(('cframework: %s attempted exploiting! (reason: player tried setting -1 account balance)'):format(self.identifier))
			return
		end

		local account   = self.getAccount(acc)
		local prevMoney = account.money
		local newMoney  = ESX.Math.Round(money)

		account.money = newMoney

		if acc == 'bank' then
			self.set('bank', newMoney)
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.addAccountMoney = function(acc, money)
		if money < 0 then
			print(('cframework: %s attempted exploiting! (reason: player tried adding -1 account balance)'):format(self.identifier))
			return
		end

		local account  = self.getAccount(acc)
		local newMoney = account.money + ESX.Math.Round(money)

		account.money = newMoney

		if acc == 'bank' then
			self.bank = newMoney
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.removeAccountMoney = function(a, m)
		if m < 0 then
			print(('cframework: %s attempted exploiting! (reason: player tried removing -1 account balance)'):format(self.identifier))
			return
		end

		local account  = self.getAccount(a)
		local newMoney = account.money - m

		account.money = newMoney

		if a == 'bank' then
			self.bank = newMoney
		end

		TriggerClientEvent('esx:setAccountMoney', self.source, account)
	end

	self.getInventoryItem = function(name)
		return self.inventory.getItem(name)
	end

	self.addInventoryItem = function(name, count)
		self.inventory.addItem(name, count)
	end

	self.removeInventoryItem = function(name, count)
		self.inventory.removeItem(name, count)
	end

	self.addExperience = function(type, amount)
        if self.experience[type] == nil then
            self.experience[type] = 0
        end

		local numAmount = tonumber(amount)
		local oldExperience = tonumber(self.experience[type])
		self.experience[type] = self.experience[type] + numAmount
		TriggerClientEvent("cframework:giveExperience", self.source, oldExperience, numAmount)
		TriggerClientEvent("cframework:addExperience", self.source, type, amount)
	end

	self.setExperience = function(type, value)
		self.experience[type] = value
		TriggerClientEvent("cframework:setExperience", self.source, type, value)
	end

	self.getExperience = function(type)
		return self.experience[type] or 0
	end

	self.setJob = function(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id         = jobObject.id
			self.job.name       = jobObject.name
			self.job.label      = jobObject.label
            self.job.metadata   = jobObject.metadata

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			self.job.skin_male    = {}
			self.job.skin_female  = {}

			if gradeObject.skin_male ~= nil then
				self.job.skin_male = gradeObject.skin_male
			end

			if gradeObject.skin_female ~= nil then
				self.job.skin_female = gradeObject.skin_female
			end

			local society, societyMoney = GetSociety(self.job.name), 0

			if society then
				societyMoney = GetSharedAccount(society.account).money
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			TriggerClientEvent('esx:setJob', self.source, self.job, societyMoney)

			ESX.removeSourceFromJob(lastJob.name, self.source)
			ESX.addSourceToJob(job, self.source)
		else
			print(('cframework: ignoring setJob for %s due to job not found!'):format(self.source))
		end
	end

	self.setArmour = function(value)
		if value >= 0 and value <= 100 then
			self.armour = self.armour + value
			if self.armour > 100 then
				self.armour = 100
			end
			TriggerClientEvent('esx:addArmour', self.source, value)
		end
	end

	self.getArmour = function()
		return self.armour
	end

	self.getFullname = function()
		if type(self.firstName) == "string" and type(self.lastName) == "string" then
			return self.firstName .. ' ' .. self.lastName
		end

		return "Unknown Name"
	end

	self.isVip = function()
		return self.vip
	end

	--Vehicle stuff

	self.getVehicle = function(plate)
		for _,v in pairs(self.vehicles) do
			if v.plate == plate then return v end
		end
	end

	self.getPoundedVehicles = function(type)
		local vehicles = {}

		for _,v in pairs(self.vehicles) do
			if not v.stored and v.type == type then table.insert(vehicles, v) end
		end

		return vehicles
	end

	self.getGarageVehicles = function(type)
		local vehicles = {}

		for _,v in pairs(self.vehicles) do
			if v.stored and v.type == type then table.insert(vehicles, v) end
		end

		return vehicles
	end

	self.getVehicles = function()
		return self.vehicles
	end

	self.deleteVehicle = function(plate, updateSql)  --Replicate client
		local vehicle = nil

		for i=1, #self.vehicles, 1 do
			if self.vehicles[i].plate == plate then
				vehicle = self.vehicles[i]
				table.remove(self.vehicles, i)
				break
			end
		end

		if vehicle ~= nil then
			cachedVehicles[self.identifier] = self.vehicles
		end

		if updateSql and vehicle ~= nil then
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', { ["@plate"] = plate})
		end

		TriggerClientEvent('cframework:deleteVehicle', self.source, plate)

		return vehicle
	end

	self.addVehicle = function(vehicle, updateSql)  --Replicate client
		if not vehicle.type or not vehicle.vehicle or not vehicle.plate then return false end

		table.insert(self.vehicles, vehicle)

		cachedVehicles[self.identifier] = self.vehicles

		vehicle.owner = self.identifier

		if updateSql then
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, type, `stored`, `zone`) VALUES (@owner, @plate, @vehicle, @type, @stored, @zone)', {
				['@owner']   = self.identifier,
				['@plate']   = vehicle.plate,
				['@vehicle'] = json.encode(vehicle.vehicle),
				['@type']    = vehicle.type,
				['@stored']  = true,
				['@zone']    = vehicle.zone or 'los_santos'
			})
		end

		TriggerClientEvent('cframework:addVehicle', self.source, vehicle)		

		return true
	end

	self.isVehiclePounded = function(plate)

		for _,v in pairs(self.vehicles) do
			if v.plate == plate then return v.stored, v.type end
		end

		return false, ''
	end

	self.setVehiclePoundState = function(plate, state, zone)  --Replicate client
		local updated = false

		for i=1, #self.vehicles, 1 do
			if self.vehicles[i].plate == plate then
				self.vehicles[i].stored, updated = state, true
                if zone ~= nil then
                    self.vehicles[i].zone = zone
                end
				break
			end
		end

		if updated then
			cachedVehicles[self.identifier] = self.vehicles

            if zone ~= nil then
                MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, `zone` = @zone WHERE plate = @plate', {
                    ['@stored'] = state,
                    ['@plate'] = plate,
                    ['@zone'] = zone
                })
            else
                MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
                    ['@stored'] = state,
                    ['@plate'] = plate
                })
            end

			TriggerClientEvent('cframework:setVehiclePoundState', self.source, plate, state, zone)
		end
	end

	self.updateVehiclePoundStateAndProps = function(vehicle, state, zone)  --Replicate client
		local originVehicle = nil

		for i=1, #self.vehicles, 1 do
			if self.vehicles[i].plate == vehicle.plate then
				originVehicle = self.vehicles[i]

				if originVehicle.vehicle.model == vehicle.vehicle.model then
					self.vehicles[i].vehicle = vehicle.vehicle
					self.vehicles[i].stored = state

                    if zone ~= nil then
                        self.vehicles[i].zone = zone
                    end
				end

				break
			end
		end

		if originVehicle == nil then return false end

		if originVehicle.vehicle.model == vehicle.vehicle.model then
            if originVehicle.vehicle.trailerModel ~= nil then
                vehicle.vehicle.trailerModel = originVehicle.vehicle.trailerModel
            end

			cachedVehicles[self.identifier] = self.vehicles

            if zone ~= nil then
                MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, stored = @stored, zone = @zone WHERE owner = @owner AND plate = @plate', {
                    ['@owner'] = self.identifier,
                    ['@vehicle'] = json.encode(vehicle.vehicle),
                    ['@plate'] = vehicle.plate,
                    ['@stored'] = state,
                    ['@zone'] = zone
                })
            else
                MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, stored = @stored WHERE owner = @owner AND plate = @plate', {
                    ['@owner'] = self.identifier,
                    ['@vehicle'] = json.encode(vehicle.vehicle),
                    ['@plate'] = vehicle.plate,
                    ['@stored'] = state
                })
            end

			TriggerClientEvent('cframework:updateVehiclePoundStateAndProps', self.source, vehicle, state, zone)
		end

		return originVehicle.vehicle.model == vehicle.vehicle.model
	end

	--vehicle = spawnownedvehicle(matricula)

	return self
end
