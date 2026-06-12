

local RegisteredSocieties = {}
local players  = {}
local numPlayers = 0

local function getJobEmployees(jobName)
	local employees = {}

	local users <const> = MySQL.Sync.fetchAll('SELECT * FROM users WHERE job = @job', {
		['@job'] = jobName
	})

	local usersOff <const> = MySQL.Sync.fetchAll('SELECT * FROM users WHERE job = @job', {
		['@job'] = "off"..jobName
	})

	local usersOnline <const>, usersTable <const> = ESX.getJobSourceList(jobName), {}
	local usersOffDutyOnline <const> = ESX.getJobSourceList("off"..jobName)

	for player, _ in pairs(usersOnline) do
		usersTable[ESX.getIdentifier(player)] = player
	end

	for player, _ in pairs(usersOffDutyOnline) do
		usersTable[ESX.getIdentifier(player)] = player
	end

	if users == nil then return {} end
	if usersOff == nil then return {} end

	for identifier, player in pairs(usersTable) do
		local job = ESX.getJob(player)

        if job == nil then
            goto continue
        end

        if ESX.Jobs[job.name] == nil or ESX.Jobs[job.name].grades[tostring(job.grade)] == nil then
            goto continue
        end

		table.insert(employees, {
			name       = ESX.getFirstName(player) .. " " .. ESX.getLastName(player),
			identifier = identifier,
			job = {
				name        = job.name,
				label       = ESX.Jobs[job.name].label,
				grade       = job.grade,
				grade_name  = ESX.Jobs[job.name].grades[tostring(job.grade)].name,
				grade_label = ESX.Jobs[job.name].grades[tostring(job.grade)].label
			}
		})

        ::continue::
	end

	for _, player in ipairs(users) do
		if usersTable[player.identifier] == nil and ESX.Jobs[player.job] ~= nil and ESX.Jobs[player.job].grades[tostring(player.job_grade)] ~= nil then
			table.insert(employees, {
				name       = player.firstname .. " " .. player.lastname,
				identifier = player.identifier,
				job = {
					name        = player.job,
					label       = ESX.Jobs[player.job].label,
					grade       = player.job_grade,
					grade_name  = ESX.Jobs[player.job].grades[tostring(player.job_grade)].name,
					grade_label = ESX.Jobs[player.job].grades[tostring(player.job_grade)].label
				}
			})
		end
	end

	for _, player in ipairs(usersOff) do
		if usersTable[player.identifier] == nil and ESX.Jobs[player.job] ~= nil and ESX.Jobs[player.job].grades[tostring(player.job_grade)] ~= nil then
			table.insert(employees, {
				name       = player.firstname .. " " .. player.lastname,
				identifier = player.identifier,
				job = {
					name        = player.job,
					label       = ESX.Jobs[player.job].label,
					grade       = player.job_grade,
					grade_name  = ESX.Jobs[player.job].grades[tostring(player.job_grade)].name,
					grade_label = ESX.Jobs[player.job].grades[tostring(player.job_grade)].label
				}
			})
		end
	end

    return employees
end

RPC.register("cframework:getEmployees", function()
	local source <const> = source
	local xPlayer <const> = ESX.GetPlayerFromId(source)

	return getJobEmployees(xPlayer.job.name)
end)

RPC.register("cframework:getJobInfo", function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local job = json.decode(json.encode(ESX.Jobs[xPlayer.job.name]))
	local grades = {}

	for _,v in pairs(job.grades) do
		table.insert(grades, v)
	end

	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)

	job.grades = grades

	return job
end)

RegisterNetEvent("cframework:bossSetJob", function(identifier, job, grade, type)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local isBoss <const> = xPlayer.job.grade_name == "boss"
	local isValid <const> = xPlayer.job.name == job or job == "unemployed"

	if not isValid or not isBoss then
		return
	end

    if type == "hire" then
        local jobMemberCount <const> = #getJobEmployees(xPlayer.job.name)

        if ESX.Jobs[xPlayer.job.name].maxMembers ~= -1 and jobMemberCount >= ESX.Jobs[xPlayer.job.name].maxMembers then
            TriggerClientEvent("esx:showNotification", source, T("SOCIETY_MEMBERS_FULL"), "error")
            return
        end
    end

	local xTarget = ESX.GetPlayerFromIdentifier(identifier)

	if xTarget then
		if type == "hire" then
            TriggerClientEvent("esx:showNotification", source, T("SOCIETY_RECRUITED"), "success")
			TriggerClientEvent("esx:showNotification", xTarget.source, (T("SOCIETY_HAVE_BEEN_HIRED")):format(ESX.GetJobLabel(job)), "inform")
		elseif type == "promote" then
			TriggerClientEvent("esx:showNotification", xTarget.source, (T("SOCIETY_HAVE_BEEN_PROMOTED")):format(ESX.GetJobGradeLabel(job, grade)), "success")
		elseif type == "fire" then
			TriggerClientEvent("esx:showNotification", xTarget.source, (T("SOCIETY_HAVE_BEEN_FIRED")):format(xPlayer.job.label), "error")
		end

		xTarget.setJob(job, grade)
	else
		MySQL.Async.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier", {
			["@job"]        = job,
			["@job_grade"]  = grade,
			["@identifier"] = identifier
		})
		if cachedUsers[identifier] ~= nil then
			cachedUsers[identifier].job = job
			cachedUsers[identifier].job_grade = grade
		end
	end
end)





function GetSociety(name)
	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			return RegisteredSocieties[i]
		end
	end
end

AddEventHandler('esx_society:registerSociety', function(name, label, account, datastore, inventory, data)
	local found = false

	local society = {
		name      = name,
		label     = label,
		account   = account,
		datastore = datastore,
		inventory = inventory,
		data      = data,
	}

	for i=1, #RegisteredSocieties, 1 do
		if RegisteredSocieties[i].name == name then
			found = true
			RegisteredSocieties[i] = society
			break
		end
	end

	if not found then
		table.insert(RegisteredSocieties, society)
	end
end)

AddEventHandler('esx_society:getSocieties', function(cb)
	cb(RegisteredSocieties)
end)

AddEventHandler('esx_society:getSociety', function(name, cb)
	cb(GetSociety(name))
end)


RegisterServerEvent('esx_society:withdrawMoney', function(amount)
	local source = source
    local inventory <const> = ESX.getInvContainer(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(xPlayer.job.name)

	-- FIX C20 (2026-06-12): só o boss pode levantar do cofre da sociedade.
	-- Sem este check qualquer membro grade-0 esvaziava a conta.
	if not society then return end
	if xPlayer.job.grade_name ~= "boss" then
		print(('esx_society: %s tentou withdrawMoney sem ser boss!'):format(xPlayer.identifier))
		return
	end

	amount = ESX.Math.Round(tonumber(amount))
	if not amount or amount <= 0 then return end

	TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
		if amount > 0 and account.money >= amount and inventory.canAddItem("cash", amount) then
			account.removeMoney(amount)
			inventory.addItem("cash", amount)

			--ESX.logOrgData(source, "LEVANTAR", "money", amount, xPlayer.job.name, xPlayer.job.label, "Dinheiro")
			--TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn', ESX.Math.GroupDigits(amount)), 'success')
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, T("GENERIC_INVALID_AMOUNT"), 'error')
		end
	end)
end)

RegisterServerEvent('esx_society:depositMoney', function(society, amount)
	local source = source
    local inventory <const> = ESX.getInvContainer(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local society = GetSociety(society)
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society.name then
		print(('esx_society: %s attempted to call depositMoney!'):format(xPlayer.identifier))
		return
	end

	if amount > 0 and inventory.canRemoveItem("cash", amount) then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			inventory.removeItem("cash", amount)
			account.addMoney(amount)

			--ESX.logOrgData(source, "DEPOSITAR", "money", amount, xPlayer.job.name, xPlayer.job.label, "Dinheiro")
		end)

		TriggerClientEvent('esx:showNotification', xPlayer.source, (T("SOCIETY_HAVE_DEPOSIT_MONEY")):format(ESX.Math.GroupDigits(amount)))
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, T("GENERIC_INVALID_AMOUNT"))
	end
end)

RegisterServerEvent('esx_society:washMoney')
AddEventHandler('esx_society:washMoney', function(society, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local account = xPlayer.getAccount('black_money')
	amount = ESX.Math.Round(tonumber(amount))

	if xPlayer.job.name ~= society then
		print(('esx_society: %s attempted to call washMoney!'):format(xPlayer.identifier))
		return
	end

	if amount and amount > 0 and account.money >= amount then
		xPlayer.removeAccountMoney('black_money', amount)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, T("GENERIC_INVALID_AMOUNT"))
	end

end)

ESX.RegisterServerCallback('esx_society:getSocietyMoney', function(source, cb, societyName)
	local society = GetSociety(societyName)

	if society then
		TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
			cb(account.money)
		end)
	else
		cb(0)
	end
end)


AddEventHandler('esx:setJob', function(playerId, job, lastJob)
	for i=1, #players, 1 do
		if playerId == players[i].source then
			players[i].job = job.name
			break
		end
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local add = true
	for i=1, #players, 1 do
		if players[i] ~= nil and source == players[i].source then
			add = false
			break
		end
	end
	if add then
		numPlayers = numPlayers + 1
		AddPlayerToList(xPlayer, true)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId)
	for i=1, #players, 1 do
		if players[i] ~= nil and playerId == players[i].source then
			numPlayers = numPlayers - 1
			table.remove(players, i)
			break
		end
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(1000)
			AddPlayersToList()
		end)
	end
end)

function AddPlayersToList()
	local players1 = ESX.GetPlayers()

	for i=1, #players1, 1 do
		local xPlayer = ESX.GetPlayerFromId(players1[i])
		numPlayers = numPlayers + 1
		AddPlayerToList(xPlayer, false)
	end
end

function AddPlayerToList(xPlayer, update)
	local playerId = xPlayer.source

	players[numPlayers] = {}
	players[numPlayers].source = xPlayer.source
	players[numPlayers].identifier = xPlayer.identifier
	players[numPlayers].name = xPlayer.name
	players[numPlayers].job = xPlayer.job
end

ESX.RegisterServerCallback('cframework:societyGetPlayersInArea', function(source, cb, coords, area)
	local allPlayers <const> = GetPlayers()
	local playersInArea = {}

	for i=1, #allPlayers, 1 do
		local target <const> = GetPlayerPed(allPlayers[i])
		local targetCoords <const> = GetEntityCoords(target)
		local distance <const> = #(vector3(targetCoords.x, targetCoords.y, targetCoords.z) - vector3(coords.x, coords.y, coords.z))

		if distance <= area and tonumber(source) ~= tonumber(allPlayers[i]) then
			local player <const> = {
				id = ESX.getIdentifier(allPlayers[i]),
				name = ESX.getFirstName(allPlayers[i]) .. ' ' .. ESX.getLastName(allPlayers[i]),
			}

			table.insert(playersInArea, player)
		end
	end

	cb(playersInArea)
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

ESX.RegisterServerCallback('esx_society:isBoss', function(source, cb, job)
	cb(isPlayerBoss(source, job))
end)

function isPlayerBoss(playerId, job)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
		return true
	else
		print(('esx_society: %s attempted open a society boss menu!'):format(xPlayer.identifier))
		return false
	end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Stations) do
        if v.JobName then
            ESX.RegisterJob(k, v.JobName, v.JobGrades, true, v.MaxMembers)
            RegisterSharedAccount('society_' .. k)
        end

        TriggerEvent('esx_society:registerSociety', k, k, 'society_' .. k, 'society_' .. k, 'society_' .. k, {type = 'public'})
    end
end)