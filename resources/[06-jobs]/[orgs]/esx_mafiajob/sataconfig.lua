Config.sataConfig                            = {}

Config.sataConfig.DrawDistance               = 30.0
Config.sataConfig.MarkerType                 = 1
Config.sataConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.sataConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.sataConfig.EnablePlayerManagement     = true
Config.sataConfig.EnableArmoryManagement     = true
Config.sataConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.sataConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.sataConfig.EnableSocietyOwnedVehicles = true
Config.sataConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.sataConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.sataConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.sataConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.sataConfig.MaxInService               = -1
Config.sataConfig.Locale                     = 'br'

Config.sataConfig.Stations = {

    --aero1 = {
	--
	--	Blip = {
	--	},
	--
	--
	--	-- https://wiki.rage.mp/index.php?title=WEAPONs
    --AuthorizedWeapons = {
    --
    --},
	--
	--	Cloakrooms = {
	--		--{ x = -1369.23, y = 38.36, z = 59.61 },
	--	},
	--
    --Armories = {
    --  --{ x = -1351.03, y = 83.59, z = 54.25 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -1677.5, y = -3102.82, z = 12.94 },
	--			SpawnPoints = {
	--				{ x = -1682.61, y = -3095.88, z = 12.91, heading = 326.02, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{x = -1674.18, y = -3097.41, z = 12.94 },
	--	},
	--
	--	BossActions = {
	--		--{x = -1347.15, y = 36.3, z = 59.6 },
	--	},
	--	
	--},
	--
    --aero = {
	--
	--	Blip = {
	--	},
	--
	--
	--	-- https://wiki.rage.mp/index.php?title=WEAPONs
    --AuthorizedWeapons = {
    --
    --},
	--
	--	Cloakrooms = {
	--		--{ x = -1369.23, y = 38.36, z = 59.61 },
	--	},
	--
    --Armories = {
    --  --{ x = -1351.03, y = 83.59, z = 54.25 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -1668.14, y = -3170.05, z = 12.99 },
	--			SpawnPoints = {
	--				{ x = -1645.04, y = -3130.45, z = 12.99, heading = 324.58, radius = 10.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{x = -1654.29, y = -3146.71, z = 13.50 },
	--	},
	--
	--	BossActions = {
	--		--{x = -1347.15, y = 36.3, z = 59.6 },
	--	},
	--	
	--},
  pearl = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1622.01, y = -3152.48, z = 12.99 },
		},

    Armories = {
      --{ x = -1622.33, y = -3152.11, z = 12.99 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1215.06, y = -2802.61, z = 13.48 },
				SpawnPoints = {
					{x = -1215.06, y = -2802.61, z = 13.48, heading = 316.87, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1214.41, y = -2804.7, z = 12.95 },
			{x = -1646.72, y = -3182.19, z = 12.99 },
			{x = 1728.85, y = 3320.59, z = 40.22 },
			--{x = 1728.85, y = 3320.59, z = 40.22 },
			{x = 4433.0, y = -4470.3, z = 3.33 },
		},

		BossActions = {
			{x = -1630.83, y = -3163.52, z = 12.99 },
		},
	},
}

Config.sataConfig.AuthorizedVehicles = {
	Shared = {
	},

	soldato = {

	},

	capo = {

	},
	consigliere = {
		{
			model = 'luxor',
			label = 'Learjet 45 (Preto)'
		},
		{
			model = 'luxor2',
			label = 'Learjet 45 (Dourado)'
		},
		{
			model = 'shamal',
			label = 'Learjet 55'
		},
		{
			model = 'nimbus',
			label = 'Cessna Citation X'
		},		
	},

	boss = {
		{
			model = 'luxor',
			label = 'Learjet 45 (Preto)'
		},
		{
			model = 'luxor2',
			label = 'Learjet 45 (Dourado)'
		},
		{
			model = 'shamal',
			label = 'Learjet 55'
		},
		{
			model = 'nimbus',
			label = 'Cessna Citation X'
		},
	},
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.sataConfig.Uniforms = {
	seg_wear = {
        male = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 27,   ['torso_2'] = 0,
			['arms'] = 12,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 3,
			['chain_1'] = 22,    ['chain_2'] = 7,
			['helmet_1'] = 61,  ['helmet_2'] = 8,
			['glasses_1'] = 5,  ['glasses_2'] = 5
		},
		female = {
		},
	},
	seg1_wear = {
        male = {
			['tshirt_1'] = 75,  ['tshirt_2'] = 3,
			['torso_1'] = 27,   ['torso_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['helmet_1'] = 64,  ['helmet_2'] = 2,
			['glasses_1'] = 3,  ['glasses_2'] = 5
		},
		female = {
		},
	},
	barman_wear = {
        male = {
			['tshirt_1'] = 6,  ['tshirt_2'] = 0,
			['torso_1'] = 120,   ['torso_2'] = 11,
			['arms'] = 11,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 20,   ['shoes_2'] = 11,
			['chain_1'] = 22,    ['chain_2'] = 3,
			['helmet_1'] = 7,  ['helmet_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 5
		},
		female = {
		},
	},
	gerente_wear = {
        male = {
			['tshirt_1'] = 21,  ['tshirt_2'] = 4,
			['torso_1'] = 119,   ['torso_2'] = 8,
			['arms'] = 6,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 40,   ['shoes_2'] = 1,
			['chain_1'] = 32,    ['chain_2'] = 0,
			['helmet_1'] = 64,  ['helmet_2'] = 1,
			['glasses_1'] = 3,  ['glasses_2'] = 5
		},
		female = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 8,   ['pants_2'] = 0,
			['shoes_1'] = 6,   ['shoes_2'] = 0,
			['chain_1'] = 10,    ['chain_2'] = 0
		},
	},
	boss1_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 75,  ['tshirt_2'] = 3,
			['torso_1'] = 119,   ['torso_2'] = 4,
			['arms'] = 77,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 21,   ['shoes_2'] = 9,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['helmet_1'] = 21,  ['helmet_2'] = 3,
			['glasses_1'] = 8,  ['glasses_2'] = 5
		},
		female = {
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 180,   ['torso_2'] = 10,
			['arms'] = 3,
			['pants_1'] = 79,   ['pants_2'] = 10,
			['shoes_1'] = 58,   ['shoes_2'] = 10
		},
	},
	boss_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 31,  ['tshirt_2'] = 0,
			['torso_1'] = 140,   ['torso_2'] = 1,
			['arms'] = 12,
			['pants_1'] = 28,   ['pants_2'] = 8,
			['shoes_1'] = 20,   ['shoes_2'] = 10,
			['helmet_1'] = 64,  ['helmet_2'] = 4,
			['chain_1'] = 22,    ['chain_2'] = 7,
			['glasses_1'] = 8,  ['glasses_2'] = 1
		},
		female = {
			['tshirt_1'] = 13,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 8,   ['pants_2'] = 0,
			['shoes_1'] = 6,   ['shoes_2'] = 0,
			['chain_1'] = 10,  ['chain_2'] = 0
		},
	},
	bullet_wear = {
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 0,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 40,   ['shoes_2'] = 4,
			['helmet_1'] = 61,  ['helmet_2'] = 8
		},
		female = {
		},
	},
	gilet_wear = {
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 178,   ['torso_2'] = 10,
			['arms'] = 4,
			['pants_1'] = 77,   ['pants_2'] = 10,
			['shoes_1'] = 55,   ['shoes_2'] = 10
			--['helmet_1'] = 94,  ['helmet_2'] = 4
		},
		female = {
		},
	}

}