Config        = {}
Config.Locale = 'en'

------------------------------------------
--	iEnsomatic RealisticVehicleFailure  --
------------------------------------------
--
--	Created by Jens Sandalgaard
--
--	This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
--
--	https://github.com/iEns/RealisticVehicleFailure
--


-- Configuration:

-- IMPORTANT: Some of these values MUST be defined as a floating point number. ie. 10.0 instead of 10

cfg = {
	deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 20.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 20.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 64.0,				-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 3.51,				-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 10,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 450.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 260.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 50.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,				-- Decrease engine torque as engine gets more and more damaged

	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25

	preventVehicleFlip = true,					-- If true, you can't turn over an upside down vehicle

	sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	displayBlips = false,						-- Show blips for mechanics locations

	compatibilityMode = false,					-- prevents other scripts from modifying the fuel tank health to avoid random engine failure with BVA 2.01 (Downside is it disabled explosion prevention)

	randomTireBurstInterval = 0,				-- Number of minutes (statistically, not precisely) to drive above 22 mph before you get a tire puncture. 0=feature is disabled


	-- Class Damagefactor Multiplier
	-- The damageFactor for engine, body and Petroltank will be multiplied by this value, depending on vehicle class
	-- Use it to increase or decrease damage for each class

	classDamageMultiplier = {
		[0] = 	0.25,		--	0: Compacts
				0.25,		--	1: Sedans
				0.25,		--	2: SUVs
				0.25,		--	3: Coupes
				0.25,		--	4: Muscle
				0.25,		--	5: Sports Classics
				0.25,		--	6: Sports
				0.25,		--	7: Super
				0.05,		--	8: Motorcycles
				0.25,		--	9: Off-road
				0.25,		--	10: Industrial
				0.25,		--	11: Utility
				0.25,		--	12: Vans
				0.25,		--	13: Cycles
				0.25,		--	14: Boats
				0.25,		--	15: Helicopters
				0.25,		--	16: Planes
				0.25,		--	17: Service
				0.25,		--	18: Emergency
				0.25,		--	19: Military
				0.25,		--	20: Commercial
				0.25			--	21: Trains
	}
}



--[[

	-- Alternate configuration values provided by ImDylan93 - Vehicles can take more damage before failure, and the balance between vehicles has been tweaked.
	-- To use: comment out the settings above, and uncomment this section.

cfg = {

	deformationMultiplier = -1,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch
	deformationExponent = 1.0,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 1.0,				-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 5.1,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 5.1,						-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 61.0,				-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 1.0,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 0.124,			-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 7.4,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 1.5,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 677.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 310.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 100.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,				-- Decrease engine torge as engine gets more and more damaged

	limpMode = false,							-- If true, the engine never fails completely, so you will always be able to get to a mechanic unless you flip your vehicle and preventVehicleFlip is set to true
	limpModeMultiplier = 0.15,					-- The torque multiplier to use when vehicle is limping. Sane values are 0.05 to 0.25

	preventVehicleFlip = true,					-- If true, you can't turn over an upside down vehicle

	sundayDriver = true,						-- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
	sundayDriverAcceleratorCurve = 7.5,			-- The response curve to apply to the accelerator. Range 0.0 to 10.0. Higher values enables easier slow driving, meaning more pressure on the throttle is required to accelerate forward. Does nothing for keyboard drivers
	sundayDriverBrakeCurve = 5.0,				-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	displayBlips = true,						-- Show blips for mechanics locations

	classDamageMultiplier = {
		[0] = 	1.0,		--	0: Compacts
				1.0,		--	1: Sedans
				1.0,		--	2: SUVs
				0.95,		--	3: Coupes
				1.0,		--	4: Muscle
				0.95,		--	5: Sports Classics
				0.95,		--	6: Sports
				0.95,		--	7: Super
				0.27,		--	8: Motorcycles
				0.7,		--	9: Off-road
				0.25,		--	10: Industrial
				0.35,		--	11: Utility
				0.85,		--	12: Vans
				1.0,		--	13: Cycles
				0.4,		--	14: Boats
				0.7,		--	15: Helicopters
				0.7,		--	16: Planes
				0.75,		--	17: Service
				0.85,		--	18: Emergency
				0.67,		--	19: Military
				0.43,		--	20: Commercial
				1.0			--	21: Trains
	}
}

]]--





-- End of Main Configuration

-- Configure Repair system

-- id=446 for wrench icon, id=72 for spraycan icon


RepairEveryoneWhitelisted = true
RepairWhitelist =
{
	"steam:123456789012345",
	"steam:000000000000000",
	"ip:192.168.0.1"			-- not sure if ip whitelist works?
}

-- Amount of Time to Blackout, in milliseconds
-- 2000 = 2 seconds
Config.BlackoutTime = 1000

--[[Config.Effect = {
    Time = {8 ,13 ,19 ,25 ,33},
    Damage = {15, 25, 45, 65, 100}
    Speed = {20, 45, 65,95, 130}
}]]

Config.EffectTimeLevel1 = 8
Config.EffectTimeLevel2 = 13
Config.EffectTimeLevel3 = 19
Config.EffectTimeLevel4 = 25
Config.EffectTimeLevel5 = 33

-- Enable blacking out due to vehicle damage
-- If a vehicle suffers an impact greater than the specified value, the player blacks out
Config.BlackoutDamageRequiredLevel1 = 15
Config.BlackoutDamageRequiredLevel2 = 25
Config.BlackoutDamageRequiredLevel3 = 45
Config.BlackoutDamageRequiredLevel4 = 65
Config.BlackoutDamageRequiredLevel5 = 300

-- Enable blacking out due to speed deceleration
-- If a vehicle slows down rapidly over this threshold, the player blacks out
Config.BlackoutSpeedRequiredLevel1 = 20 -- Speed in MPH
Config.BlackoutSpeedRequiredLevel2 = 45
Config.BlackoutSpeedRequiredLevel3 = 65
Config.BlackoutSpeedRequiredLevel4 = 95
Config.BlackoutSpeedRequiredLevel5 = 130

-- Enable the disabling of controls if the player is blacked out
Config.DisableControlsOnBlackout = true
Config.TimeLeftToEnableControls = 10

-- Multiplier of screen shaking strength
Config.ScreenShakeMultiplier = 0.1


-- Are you using ESX? Turn this to true if you would like fuel & jerry cans to cost something.
Config.UseESX = true

-- What should the price of jerry cans be?
Config.JerryCanCost = 50
Config.RefillCost = 500 -- If it is missing half of it capacity, this amount will be divided in half, and so on.

-- Fuel decor - No need to change this, just leave it.
Config.FuelDecor = "_FUEL_LEVEL"

-- What keys are disabled while you're fueling.
Config.DisableKeys = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Want to use the HUD? Turn this to true.
Config.EnableHUD = false

-- Configure blips here. Turn both to false to disable blips all together.
Config.ShowNearestGasStationOnly = false
Config.ShowAllGasStations = true

-- Configure the strings as you wish here.
Config.Strings = {
	ExitVehicle = "Sai do veiculo para abastecer.",
	EToRefuel = "Pressione ~g~E ~w~para abastecer o veiculo.",
	JerryCanEmpty = "O Jerry Can está vazio.",
	FullTank = "Tanque Cheio.",
	PurchaseJerryCan = "Pressione ~g~E ~w~tpara comprar um Jerry Can por ~g~€" .. Config.JerryCanCost,
	CancelFuelingPump = "Pressione ~g~E ~w~para parar de abastecer.",
	CancelFuelingJerryCan = "Pressione ~g~E ~w~para parar de abastecer.",
	NotEnoughCash = "Dinheiro Insuficiente.",
	RefillJerryCan = "Pressione ~g~E ~w~ para reabastecer o Jerry Can. ",
	NotEnoughCashJerryCan = "Não tem dinheiro suficiente para reabastecer o Jerry Can.",
	JerryCanFull = "O Jerry Can está cheio",
	TotalCost = "Custo.",
}

if not Config.UseESX then
	Config.Strings.PurchaseJerryCan = "Pressione ~g~E ~w~para comprar um Jerry Can."
	Config.Strings.RefillJerryCan = "Pressione ~g~E ~w~ para reabastecer o Jerry Can."
end

Config.PumpModels = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true,
	[1767019582] = true, --ROXWOOD
}

-- Blacklist certain vehicles. Use names or hashes. https://wiki.gtanet.work/index.php?title=Vehicle_Models
Config.Blacklist = {
	--"Adder",
	--276773164
}

-- Do you want the HUD removed from showing in blacklisted vehicles?
Config.RemoveHUDForBlacklistedVehicle = true

-- Class multipliers. If you want SUVs to use less fuel, you can change it to anything under 1.0, and vise versa.
Config.Classes = {
	[0] = 0.7, -- Compacts
	[1] = 0.7, -- Sedans
	[2] = 0.7, -- SUVs
	[3] = 0.7, -- Coupes
	[4] = 0.7, -- Muscle
	[5] = 0.7, -- Sports Classics
	[6] = 0.7, -- Sports
	[7] = 0.7, -- Super
	[8] = 0.7, -- Motorcycles
	[9] = 0.7, -- Off-road
	[10] = 0.7, -- Industrial
	[11] = 0.7, -- Utility
	[12] = 0.7, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 0.7, -- Boats
	[15] = 0.7, -- Helicopters
	[16] = 0.7, -- Planes
	[17] = 0.7, -- Service
	[18] = 0.7, -- Emergency
	[19] = 0.7, -- Military
	[20] = 0.7, -- Commercial
	[21] = 0.7, -- Trains
}

-- The left part is at percentage RPM, and the right is how much fuel (divided by 10) you want to remove from the tank every second
Config.FuelUsage = {
	[1.0] = 0.3,
	[0.9] = 0.3,
	[0.8] = 0.3,
	[0.7] = 0.3,
	[0.6] = 0.3,
	[0.5] = 0.3,
	[0.4] = 0.3,
	[0.3] = 0.3,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

Config.GasStations = {
	vector3(49.4187, 2778.793, 58.043),
	vector3(263.894, 2606.463, 44.983),
	vector3(1039.958, 2671.134, 39.550),
	vector3(1207.260, 2660.175, 37.899),
	vector3(2539.685, 2594.192, 37.944),
	vector3(2679.858, 3263.946, 55.240),
	vector3(2005.055, 3773.887, 32.403),
	vector3(1687.156, 4929.392, 42.078),
	vector3(1701.314, 6416.028, 32.763),
	vector3(179.857, 6602.839, 31.868),
	vector3(-94.4619, 6419.594, 31.489),
	vector3(-2554.996, 2334.40, 33.078),
	vector3(-1800.375, 803.661, 138.651),
	vector3(-1437.622, -276.747, 46.207),
	vector3(-2096.243, -320.286, 13.168),
	vector3(-724.619, -935.1631, 19.213),
	vector3(-526.019, -1211.003, 18.184),
	vector3(-70.2148, -1761.792, 29.534),
	vector3(265.648, -1261.309, 29.292),
	vector3(819.653, -1028.846, 26.403),
	vector3(1208.951, -1402.567,35.224),
	vector3(1181.381, -330.847, 69.316),
	vector3(620.843, 269.100, 103.089),
	vector3(2581.321, 362.039, 108.468),
	vector3(176.631, -1562.025, 29.263),
	vector3(176.631, -1562.025, 29.263),
	vector3(-319.292, -1471.715, 30.549),
	vector3(1784.324, 3330.55, 41.253),
    vector3(4472.78, -4453.75, 4.05), --Cayo
}


--Moneywash
Config.DrawDistance 	= 50
Config.Size 			= {x = 2.5, y = 1.5, z = 0.3}
Config.Color 			= {r = 300, g = 900, b = 0}
Config.Type 			= 1

Config.taxRate = 1.0  -- percentagem

Config.enableTimer = true -- timer
local second = 300
local minute = 60 * second
local hour = 60 * minute

Config.timer = 300 * second 

Config.WashZones = {
	
	{	
		Pos = { 
			{x = -1366.25 , y = -624.83 , z = 29.33},
			{x = 408.46 , y = 245.32 , z = 91.05},
		},
		
		Jobs = {
		'squad12', 'nightclub'
		},
		Percentage = 1 - 0.05
	},

}

-- End of Private Garages
ConfigCasas                      = {} -- LEAVE ALONE
ConfigCasas.DrawDistance             = 25 -- The Draw distance for any other markers, including those within a casa.
ConfigCasas.MotelDrawDistance        = 1 -- The Draw Distance for unrented Motel rooms
ConfigCasas.MotelRentedDrawDistance  = 5 -- The Draw Distance for Rented Motel Rooms
ConfigCasas.MotelRentalPrice         = 50 -- How much rent should Motel Rooms cost
ConfigCasas.PedActionTime            = 5000 -- How long should it take the person to sign a contract of purchase or rental
ConfigCasas.OpenDoorTime             = 2000 -- How long should it take the person to unlock and enter the room
ConfigCasas.MotelMarkerForRent       = {r = 239, g = 57, b = 188} -- Color of a Motel room avaliable to rent marker
ConfigCasas.MarkerSize               = {x = 0.6, y = 0.6, z = 0.6} -- The default Marker SIZE for Motels and casas and all other casa related markers
ConfigCasas.MarkerColor              = {r = 255, g = 0, b = 0} -- Color of the Standard casa markers when not owned.
ConfigCasas.MarkerColorOwned         = {r = 93, g = 182, b = 229} -- Color of the Standard casa & Motel markers when owned
ConfigCasas.RoomMenuMarkerColor      = {r = 0, g = 157, b = 255} -- Color of the Room Menu markers
ConfigCasas.MarkerType               = 20 -- What marker type should be displayed. 20 is the default
ConfigCasas.Zones                    = {} -- Create a empty table for the marker zones
ConfigCasas.Casas               = {} -- Create a empty table for Casas around the map
ConfigCasas.EnablePlayerManagement   = false -- If set to true you need esx_realestateagentjob
ConfigCasas.Locale                   = 'en' -- Default language set, -- Motels only support en

-- Set the time (in minutes) during the player is outlaw
Config.Timer = 1

-- Set if show alert when player use gun
Config.GunshotAlert = true

-- Set if show when player do carjacking
Config.CarJackingAlert = false

-- Set if show when player fight in melee
Config.MeleeAlert = false

-- In seconds
Config.BlipGunTime = 15

-- Blip radius, in float value!
Config.BlipGunRadius = 90.0

-- In seconds
Config.BlipMeleeTime = 7

-- Blip radius, in float value!
Config.BlipMeleeRadius = 50.0

-- In seconds
Config.BlipJackingTime = 20

-- Blip radius, in float value!
Config.BlipJackingRadius = 50.0

-- Show notification when cops steal too?
Config.ShowCopsMisbehave = true

-- Jobs in this table are considered as cops
Config.WhitelistedCops = {
	'police',
	'gnr',
	'staff',
}

ConfigCTT              = {}
ConfigCTT.DrawDistance = 100.0
ConfigCTT.Locale       = 'en'

ConfigCTT.JobVehiclePlate = 'CTT' -- Plaque des vehicules du job (maximun 8 caractères)
ConfigCTT.MaxLetter	   = 4 -- Maximum de lettre par point
ConfigCTT.MinLetter	   = 1 -- Maximum de lettre par point
ConfigCTT.MaxColis		   = 2 -- Maximum de colis par point
ConfigCTT.MinColis		   = 0 -- Maximum de colis par point

ConfigCTT.Caution 		   = 1000
ConfigCTT.PricePerLetter  = 6
ConfigCTT.PricePerColis   = 8

ConfigCTT.Vehicle = { -- Ajouter les véhicules du métier ici
	"boxville2"
}

ConfigCTT.Zones = { -- Emplacement des points
	CloakRoom = {
		Pos   = {x = 78.899, y = 111.934, z = 80.1},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Color = {r = 231, g = 76, b = 60},
		Type  = 1
	},

	VehicleSpawner = {
		Pos   = {x = 69.0792, y = 125.886, z = 78.1},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 142, g = 68, b = 173},
		Type  = 1
	},

	VehicleSpawnPoint = {
		Pos     = {x = 66.232, y = 121.310, z = 79.112},
		Heading = 160.0, -- Orientation 
		Size    = {x = 3.0, y = 3.0, z = 1.0},
		Type    = -1
	},

	VehicleDeleter = {
		Pos   = {x = 79.134, y = 88.883, z = 77.6},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 142, g = 68, b = 173},
		Type  = 1
	},

	Distribution = { -- point pr récuperer les colis & courrier
		Pos   = {x = 115.141, y = 100.649, z = 79.890},
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Color = {r = 236, g = 240, b = 241},
		Type  = 1
	},
}

ConfigCTT.Uniforms = { -- Tenue de service
	
male = {
	['tshirt_1'] = 15,  ['tshirt_2'] = 0,
	['torso_1']  = 420, ['torso_2'] = 0,
	['decals_1'] = 0,   ['decals_2'] = 0,
	['arms']     = 0,
	['pants_1']  = 10,  ['pants_2'] = 0,
	['shoes_1']  = 4,  ['shoes_2'] = 0,
    },
    female = {
      ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
      ['torso_1'] = 446,  ['torso_2'] = 0,
      ['decals_1'] = 0,   ['decals_2'] = 0,
      ['arms'] = 0,
      ['pants_1'] = 34,   ['pants_2'] = 0,
      ['shoes_1'] = 3,   ['shoes_2'] = 0,   
    },
}


-- Point des livraisons

ConfigCTT.Livraisons = {
	Richman = {
		Pos = {
			{x = -1129.1517, y = 395.020, z = 69.651, letter = true, colis = false},
			{x = -1103.568, y = 284.569, z = 63.094, letter = true, colis = false},
			{x = -1473.558, y = -10.789, z = 54.525, letter = true, colis = false},
			{x = -1532.2011, y = -37.736, z = 56.381, letter = true, colis = false},
			{x = -1545.794, y = -33.281, z = 56.891, letter = true, colis = false},
			{x = -1464.423, y = 51.018, z = 53.988, letter = true, colis = false},
			{x = -1470.73046875, y = 63.990886688232, z = 51.173046112061},
			{x = -1504.2097167969, y = 44.28625869751, z = 53.951641082764, letter = true, colis = false},
			{x = -1585.7332763672, y = 44.503841400146, z = 59.00085067749, letter = true, colis = false},
			{x = -1619.6723632813, y = 57.411979675293, z = 60.791728973389},
			{x = -1615.3327636719, y = 74.720077514648, z = 60.412998199463, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 211, g = 84, b = 0},
        Type  = 1
	},

	RockfordHills = {
		Pos = {
			{x = -822.11590576172, y = -28.949552536011, z = 37.660648345947},
			{x = -877.12579345703, y = 1.4300217628479, z = 43.068756103516, letter = true, colis = false},
			{x = -883.50225830078, y = 19.95990562439, z = 43.858791351318, letter = true, colis = false},
			{x = -904.48303222656, y = 17.959585189819, z = 45.375545501709, letter = true, colis = false},
			{x = -849.53887939453, y = 103.97817993164, z = 51.921394348145, letter = true, colis = false},
			{x = -851.21838378906, y = 178.97734069824, z = 68.720985412598, letter = true, colis = false},
			{x = -923.23107910156, y = 178.72102355957, z = 65.937400817871, letter = true, colis = false},
			{x = -954.20562744141, y = 177.81230163574, z = 64.367691040039, letter = true, colis = false},
			{x = -934.73480224609, y = 123.06588745117, z = 55.740001678467, letter = true, colis = false},
			{x = -950.38397216797, y = 125.10294342041, z = 56.440544128418},
			{x = -979.54205322266, y = 147.44619750977, z = 59.907157897949, letter = true, colis = false},
			{x = -1046.2899169922, y = 209.78942871094, z = 62.423046112061, letter = true, colis = false},			
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 46, g = 204, b = 113},
        Type  = 1
	},

	Vespucci = {
		Pos = {
			{x = -1091.9807128906, y = -923.61407470703, z = 2.1418874263763, letter = true, colis = false},
			{x = -1038.87109375, y = -891.09130859375, z = 4.2144069671631},
			{x = -948.60479736328, y = -898.53344726563, z = 1.1630630493164},
			{x = -919.51391601563, y = -952.21594238281, z = 1.162935256958, letter = true, colis = false},
			{x = -933.55932617188, y = -1081.3103027344, z = 1.1503119468689, letter = true, colis = false},
			{x = -954.99682617188, y = -1083.3701171875, z = 1.1503119468689, letter = true, colis = false},
			{x = -1025.9075927734, y = -1129.6602783203, z = 1.1702592372894, letter = true, colis = false},
			{x = -1061.0762939453, y = -1155.3466796875, z = 1.1118972301483, letter = true, colis = false},
			{x = -1253.8918457031, y = -1330.2947998047, z = 3.0237193107605},
			{x = -1106.5417480469, y = -1534.9737548828, z = 3.3808641433716, letter = true, colis = false},
			{x = -1116.1688232422, y = -1575.6658935547, z = 3.3870568275452, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 52, g = 152, b = 219},
        Type  = 1
	},

	SLS = {
		Pos = {
			{x = -50.930358886719, y = -1783.6270751953, z = 27.300802230835, letter = true, colis = false},
			{x = 13.642129898071, y = -1850.1307373047, z = 23.055648803711, letter = true, colis = false},
			{x = 110.53960418701, y = -1956.0163574219, z = 19.751287460327, letter = true, colis = false},
			{x = 151.61938476563, y = -1896.3343505859, z = 22.092262268066, letter = true, colis = false},
			{x = 158.33076477051, y = -1876.6044921875, z = 22.980903625488},
			{x = 221.90466308594, y = -1720.8103027344, z = 28.202871322632, letter = true, colis = false},
			{x = 249.87113952637, y = -1730.8135986328, z = 28.669330596924, letter = true, colis = false},
			{x = 263.07949829102, y = -1704.0960693359, z = 28.205499649048, letter = true, colis = false},
			{x = 332.95666503906, y = -1742.1281738281, z = 28.730531692505, letter = true, colis = false},
			{x = 326.57717895508, y = -1763.9366455078, z = 28.015428543091, letter = true, colis = false},
			{x = 321.9792175293, y = -1838.9698486328, z = 26.227586746216, letter = true, colis = false},
			{x = 440.62481689453, y = -1840.9602050781, z = 26.871042251587, letter = true, colis = false},
			{x = 385.88714599609, y = -1882.3186035156, z = 24.838005065918, letter = true, colis = false},
		},
		Size  = {x = 1.5, y = 1.5, z = 1.0},
        Color = {r = 241, g = 196, b = 15},
        Type  = 1
    }

}

-- The max distnace from a hooker you can pick them up
Config.MaxDistance = 7.5

-- The maximum amount of services a hooker will accept before they leave
Config.MaxServices = 3

-- The maximum speed (meters per seconds) your vehicle can have before it checks for nearby hookers etc.
Config.MaxVehicleSpeed = 0.1

Config.PaymentEnabled = true
Config.Prices = {
    SERVICE_BLOWJOB = 50,
    SERVICE_SEX = 100
}

-- Localization
Config.Localization = {
	InviteHooker = "Pressiona ~INPUT_VEH_HORN~ ou buzina para convidar a prostituta a entrar no veículo.",
    FindSecludedArea = "Vai para um local mais reservado.",
    FindSecludedAreaFailed = "Não encontraste um local reservado a tempo.",
    VehicleUnsuitable = "Não podes levar prostitutas neste veículo.",
    FrontSeatOccupied = "O banco da frente precisa de estar livre para convidares uma prostituta.",
    NotEnoughMoney = "Não tens dinheiro suficiente!"
}

-- The peds that are considered hookers. (be carefull what you add here.)
Config.HookerPedModels = {
    [`s_f_y_hooker_01`] = true,
    [`s_f_y_hooker_02`] = true,
    [`s_f_y_hooker_03`] = true
}

-- The vehicle classes that can't be used to pick up hookers
Config.BlackListedVehicleClasses = {
    [8] = true, -- Motorcycles
    [13] = true, -- Cycles
    [14] = true, -- Boats
    [15] = true, -- Helicopters
    [16] = true, -- Planes
    [18] = true, -- Emergency
    [19] = true, -- Military
    [21] = true, -- Trains
    [22] = true, -- Open Wheel
}

-- Vehicles that can't be used to pick up hookers
-- These were taken from pb_prostitute.c
Config.BlackListedVehicles = {
    [`infernus`] = true,
    [`voltic`] = true,
    [`stingergt`] = true,
    [`stinger`] = true,
    [`bullet`] = true,
    [`entityxf`] = true,
    [`feltzer3`] = true,
    [`granger`] = true,
    [`panto`] = true,
    [`phoenix`] = true,
    [`fmj`] = true,
    [`reaper`] = true,
    [`le7b`] = true,
    [`tyrus`] = true,
    [`infernus2`] = true
}