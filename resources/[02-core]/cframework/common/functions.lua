local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

ESX.DEV = GetConvar("sv_environment", "PROD") == "DEV"

ESX.TunningLocations = {}

Citizen.CreateThread(function()
    for job, station in pairs(Config.Stations) do
        if station.Tunning then
            for k,v in pairs(station.Tunning) do
                table.insert(ESX.TunningLocations, {
                    coords = v.coords,
                    job = job,
                    howmuchtopay = 100,
                    society = true,
                    used = false,
                    illegal = v.illegal,
                    isMotoclub = v.isMotoclub,
                    isNautica = v.isNautica,
                })
            end
        end
    end
end)

ESX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

ESX.GetItemLabel = function(item)
	if ESX.Items[item] ~= nil then
		return ESX.Items[item].label
	end
end

ESX.GetItemLimit = function(item)
	if ESX.Items[item] ~= nil then
		return ESX.Items[item].limit
	end

    return 0
end

ESX.GetConfig = function()
	return Config
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for name, weapon in pairs(weapons) do
		if name == weaponName then
			return name, weapon
		end
	end
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in pairs(ESX.Items) do
		if v.type == "weapon" and GetHashKey(k) == weaponHash then
			return v, k
		end
	end
end

ESX.GetItemFromAttachmentName = function(attachmentName)
    for k,v in pairs(ESX.Items) do
		if v.attachment and v.attachment == attachmentName then
			return k
		end
	end
end

ESX.GetAllAttachments = function()
    local attachments = {}

    for k,v in pairs(ESX.Items) do
        if v.attachment then
            attachments[v.attachment] = {name = k, label = v.label}
        end
    end

    return attachments
end

ESX.DoesWeaponKill = function(weaponHash)
	for k,v in pairs(ESX.Items) do
		if v.type == "weapon"and GetHashKey(k) == weaponHash then
			return v.kill
		end
	end
end

ESX.GetWeaponList = function()
    local weapons = {}

    for k,v in pairs(ESX.Items) do
        if v.type == "weapon" then
            weapons[k] = v
        end
    end

	return weapons
end

ESX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for name, weapon in pairs(weapons) do
		if name == weaponName then
			return weapon.label
		end
	end
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = ESX.GetWeaponList()

	for name, weapon in pairs(weapons) do
		if name == weaponName then
			for j=1, #weapon.components, 1 do
				if weapon.components[j].name == weaponComponent then
					return weapon.components[j]
				end
			end
		end
	end
end

ESX.TableContainsValue = function(table, value)
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end

	return false
end

ESX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

ESX.Round = function(value, numDecimalPlaces)
	return ESX.Math.Round(value, numDecimalPlaces)
end

ESX.formatAsCurrency = function(amount)
    return string.format("%d€", amount):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
end

ESX.formatTime = function(seconds)
    -- Calculate days, hours, minutes, and remaining seconds
    local days = math.floor(seconds / 86400) -- 1 day = 86400 seconds
    seconds = seconds % 86400
    local hours = math.floor(seconds / 3600) -- 1 hour = 3600 seconds
    seconds = seconds % 3600
    local minutes = math.floor(seconds / 60) -- 1 minute = 60 seconds
    local remaining_seconds = seconds % 60

    -- Return formatted time in "days:hours:minutes:seconds" format
    return string.format("%dd%dh%dm%ds", days, hours, minutes, remaining_seconds)
end
