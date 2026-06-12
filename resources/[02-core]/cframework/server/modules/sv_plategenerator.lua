

local numberCharset = {}
local charset = {}

Citizen.CreateThread(function()
    for i = 48,  57 do table.insert(numberCharset, string.char(i)) end

    for i = 65,  90 do table.insert(charset, string.char(i)) end
    for i = 97, 122 do table.insert(charset, string.char(i)) end
end)

local function getRandomNumber(length)
	Citizen.Wait(1)

	if length > 0 then
		return getRandomNumber(length - 1) .. numberCharset[math.random(1, #numberCharset)]
	else
		return ""
	end
end

local function getRandomLetter(length)
	Citizen.Wait(1)

	if length > 0 then
		return getRandomLetter(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

local function generatePlate()
    math.randomseed(GetGameTimer())

	while true do
		local generatedPlate <const> = string.upper(getRandomLetter(2) .. " " .. getRandomNumber(2)) .. " " .. string.upper(getRandomLetter(2))

		local dbVehicle = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {
			["@plate"] = generatedPlate
		})[1]

		if dbVehicle == nil then
			return generatedPlate
		end
	end
end

ESX.GeneratePlate = function()
	return generatePlate()
end
