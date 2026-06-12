Config.yakuzaConfig                            = {}

Config.yakuzaConfig.DrawDistance               = 30.0
Config.yakuzaConfig.MarkerType                 = 1
Config.yakuzaConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.yakuzaConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.yakuzaConfig.EnablePlayerManagement     = true
Config.yakuzaConfig.EnableArmoryManagement     = true
Config.yakuzaConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.yakuzaConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.yakuzaConfig.EnableSocietyOwnedVehicles = true
Config.yakuzaConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.yakuzaConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.yakuzaConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.yakuzaConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.yakuzaConfig.MaxInService               = -1
Config.yakuzaConfig.Locale                     = 'br'

Config.yakuzaConfig.Stations = {

    mafia2 = { --WHITE HOUSE
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -3218.83, y = 784.04, z = 13.08 },
		},

    Armories = {
      { x = -3198.29, y = 835.63, z = 7.93 },
    },

		Vehicles = {
			{
				Spawner    = { x = -3189.81, y = 819.6, z = 7.93 },
				SpawnPoints = {
					{ x = -3198.04, y = 815.99, z = 7.93, heading = 185.84, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -3197.53, y = 816.19, z = 7.93 },
		},

		BossActions = {
			{x = -3233.98, y = 814.27, z = 13.08 },
		},
		
	},

--     mafia223 = { --PMA
  
-- 		Blip = {
-- 		},


-- 		-- https://wiki.rage.mp/index.php?title=WEAPONs
--     AuthorizedWeapons = {
    
--     },

-- 		Cloakrooms = {
-- 			{ x = -643.92, y = -1240.42, z = 10.55 },
-- 		},

--     Armories = {
--       { x = -644.55, y = -1244.27, z = 10.55 },
--     },

-- 		Vehicles = {
-- 			{
-- 				Spawner    = {x = -641.18, y = -1220.57, z = 10.47  },
-- 				SpawnPoints = {
-- 					{ x = -641.18, y = -1220.57, z = 10.47, heading = 185.84, radius = 6.0 },
-- 				},
-- 			},
-- 		},

-- 		Helicopters = {
-- 		},

-- 		VehicleDeleters = {
-- 			{x = -641.18, y = -1220.57, z = 10.47 },
-- 		},

-- 		BossActions = {
-- 			{x = -644.55, y = -1244.27, z = -10.55 },
-- 		},
		
-- 	},

	ocean = { --piscina oceano
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -3055.62, y = 103.27, z = 11.35 },
		},

    Armories = {
      { x = -2998.34, y = 55.26, z = 11.26 },
    },

		Vehicles = {
			{
				Spawner    = {x = 1523.72, y = 2234.14, z = -74.42 },
				SpawnPoints = {
					{ x = 1523.72, y = 2234.14, z = 74.42, heading = 236.07, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -2957.4, y = 59.03, z = 10.61 },
		},

		BossActions = {
			{ x = 770.99, y = 5564.67, z = -76.79 },
		},
		
	},

}

Config.yakuzaConfig.AuthorizedVehicles = {
	Shared = {
		{
			model = '370z',
			label = 'Nissan 370Z Nismo'
		},
		{
			model = 'i8',
			label = 'BMW i8'
		},
		{
			model = 'rs615',
			label = 'Audi RS6 2016'
		},
		{
			model = 'cls53',
			label = 'Mercedes CLS53 AMG'
		},
	},

	soldato = {

	},

	capo = {

	},
	consigliere = {
		
	},

	boss = {

	},
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.yakuzaConfig.Uniforms = {
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