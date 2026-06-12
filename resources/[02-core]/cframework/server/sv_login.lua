-- This gets called whenever a user spawns for the first time in the server, it basically loads the player
-- Loads the user when called, only ever needs to get called once
local function preLoadUser(identifier, source)
	local user <const> = cachedUsers[identifier]

	if not user.license then DropPlayer(source, T("CONNECTING_ROCKSTAR_MISSING"))
		return
	end

	if user.group == "user" and (IsRolePresent(source, "staff") or IsRolePresent(source, "dev") or IsRolePresent(source, "estagiario")) then
		user.group = "admin"
	end

	InitPlayerLoad(source, user.permission_level, user.identifier, user.license or "", user.group)
end

local function registerUser(identifier, source)
	if cachedUsers[identifier] == nil then
		local dbUser <const> = MySQL.Sync.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		})[1]

		cachedUsers[identifier] = dbUser
	end

	if cachedUsers[identifier] == nil then
		local license <const> = GetPlayerIdentifierByType(source, "license")

        local myCitizenId = nil
		repeat
			myCitizenId = ESX.getRandomCitizenId()
			local id = ESX.getIdentifierByCitizenId(myCitizenId)
		until id == nil

		MySQL.Async.fetchAll("INSERT INTO users(identifier, license, citizen_id) VALUES (@identifier, @license, @citizenId)", {
			['@identifier'] = identifier,
			['@license'] = license,
            ['@citizenId'] = myCitizenId,
		})

		cachedUsers[identifier] = {
			identifier = identifier,
			license = license,
			job = "unemployed",
			job_grade = 0,
            citizen_id = myCitizenId,
			position = '{"x":-268.94,"y":-956.15,"z":31.22}',
			permission_level = 0,
			group = "user",
			isDead = 0,
			health = 200,
			jail = 0,
			vip = 0,
			armour = 0,
			reports = 0,
			canReport = 1,
			playtime = 0,
			globalPlayTime = 0,
			experience = '{"mafia":0,"gang":0,"org":0}',
			communityservice = 0,
			coins = 0,
		}
	end

	preLoadUser(identifier, source)
end

RegisterServerEvent("cframework:initPlayerLoad", function()
	local source <const> = source

	Citizen.CreateThread(function()
		local id <const> = GetPlayerIdentifierByType(source, "steam")

		if id == nil then
			DropPlayer(source, T("CONNECTING_STEAM_MISSING"))
			return
		end

		registerUser(id, source)
	end)
end)
