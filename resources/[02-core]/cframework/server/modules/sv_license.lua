--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 1.0.1, 15/05/2019     --

local licensesData = LoadLicenses()
local cachedLicensesTypes = {}
local cachedUserLicenses = {}

MySQL.ready(function()
    for _,v in ipairs(licensesData.licenses) do
        cachedLicensesTypes[v.type] = {
            type  = v.type,
            label = v.label
        }
    end

	MySQL.Async.fetchAll('SELECT * FROM user_licenses', {}, function(result)
		for i=1, #result, 1 do
			if cachedUserLicenses[result[i].owner] == nil then cachedUserLicenses[result[i].owner] = {} end

			table.insert(cachedUserLicenses[result[i].owner], result[i].type)
		end

		print('[DATA] Cached all user licenses')
	end)
end)

function AddLicense(target, type, cb)
	local identifier = ESX.getIdentifier(target)

	if cachedUserLicenses[identifier] == nil then cachedUserLicenses[identifier] = {} end

	table.insert(cachedUserLicenses[identifier], type)

	MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)',
	{
		['@type']  = type,
		['@owner'] = identifier
	},
	function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function RemoveLicense(target, type, cb)
	local identifier = ESX.getIdentifier(target)

	for k, v in ipairs(cachedUserLicenses[identifier]) do
		if v == type then
			table.remove(cachedUserLicenses[identifier], k)
		end
	end

	MySQL.Async.execute('DELETE FROM user_licenses WHERE type = @type AND owner = @owner',
	{
		['@type']  = type,
		['@owner'] = identifier
	},
	function(rowsChanged)
		if cb ~= nil then
			cb()
		end
	end)
end

function GetLicense(rType, cb)
	cb(cachedLicensesTypes[rType])
end

function GetLicenses(target, cb)
	local identifier = ESX.getIdentifier(target)
	local licenses   = {}

	if cachedUserLicenses[identifier] == nil then cb({}) return end

	for k, v in ipairs(cachedUserLicenses[identifier]) do
		table.insert(licenses, cachedLicensesTypes[v])
	end

	cb(licenses)
end

function GetLicensesFromIdentifier(identifier, cb)
	local licenses   = {}

	if cachedUserLicenses[identifier] == nil then cb({}) return end

	for k, v in ipairs(cachedUserLicenses[identifier]) do
		table.insert(licenses, cachedLicensesTypes[v])
	end

	cb(licenses)
end

function CheckLicense(target, lType, cb)
	local identifier = ESX.getIdentifier(target)

	if cachedUserLicenses[identifier] == nil then
        if cb then
            cb(false)
        end
        return false
    end

	for k, v in ipairs(cachedUserLicenses[identifier]) do
		if v == lType then
            if cb then
                cb(true)
            end
			return true
		end
	end

    if cb then
        cb(false)
    end
    return false
end

function GetLicensesList(cb)
	cb(cachedLicensesTypes)
end


RegisterNetEvent('esx_license:addLicense')
AddEventHandler('esx_license:addLicense', function(target, type, cb)
	AddLicense(target, type, cb)
end)

RegisterNetEvent('esx_license:removeLicense')
AddEventHandler('esx_license:removeLicense', function(target, type, cb)
	RemoveLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicense', function(type, cb)
	GetLicense(type, cb)
end)

AddEventHandler('esx_license:getLicenses', function(target, cb)
	GetLicenses(target, cb)
end)

AddEventHandler('esx_license:getLicensesFromIdentifier', function(identifier, cb)
	GetLicensesFromIdentifier(identifier, cb)
end)


AddEventHandler('esx_license:checkLicense', function(target, type, cb)
	CheckLicense(target, type, cb)
end)

AddEventHandler('esx_license:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

ESX.RegisterServerCallback('esx_license:getLicense', function(source, cb, type)
	GetLicense(type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicenses', function(source, cb, target)
	GetLicenses(target, cb)
end)

ESX.RegisterServerCallback('esx_license:checkLicense', function(source, cb, target, type)
	CheckLicense(target, type, cb)
end)

ESX.RegisterServerCallback('esx_license:getLicensesList', function(source, cb)
	GetLicensesList(cb)
end)
