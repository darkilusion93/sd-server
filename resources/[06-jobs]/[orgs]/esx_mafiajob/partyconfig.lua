Config.partyConfig                            = {}

Config.partyConfig.DrawDistance               = 30.0
Config.partyConfig.MarkerType                 = 1
Config.partyConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.partyConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.partyConfig.EnablePlayerManagement     = true
Config.partyConfig.EnableArmoryManagement     = true
Config.partyConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.partyConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.partyConfig.EnableSocietyOwnedVehicles = true
Config.partyConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.partyConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.partyConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.partyConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.partyConfig.MaxInService               = -1
Config.partyConfig.Locale                     = 'br'

Config.partyConfig.Stations = {


	vinhas = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1887.06, y = 2071.01, z = 144.57 },
		},

    Armories = {
      { x = -1869.23, y = 2059.41, z = 134.43 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1919.24, y = 2048.46, z = 139.74 },
				SpawnPoints = {
					{ x = -1912.67, y = 2037.81, z = 139.74, heading = 214.71, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1920.76, y = 2040.24, z = 139.74 },
		},

		BossActions = {
			{x = -1866.96, y = 2061.75, z = 134.43 },
		},
	},


    mafia223 = { --STUDIO IGREJA
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -813.49, y = -728.81, z = 27.06 },
		},

    Armories = {
      { x = -826.01, y = -732.82, z = 22.78 },
    },

		Vehicles = {
			{
				Spawner    = { x = -817.79, y = -728.69, z = 22.78 },
				SpawnPoints = {
					{ x = -817.79, y = -728.69, z = 22.78, heading = 185.84, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -817.79, y = -728.69, z = 22.78 },
		},

		BossActions = {
			{x = -826.01, y = -732.82, z = -22.78 },
		},
		
	},

    mafia2233 = { --MUNICIPAL
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 498.84, y = -1531.52, z = 28.29 },
		},

    Armories = {
      { x = 489.1999, y = -1525.34, z = 28.288 },
    },

		Vehicles = {
			{
				Spawner    = { x = 482.76, y = -1525.75, z = 28.3 },
				SpawnPoints = {
					{ x = 482.76, y = -1525.75, z = 28.3, heading = 185.84, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 482.76, y = -1525.75, z = 28.3 },
		},

		BossActions = {
			{x = 498.84, y = -1531.52, z = -28.29 },
		},
		
	},
	
--   casaabandonada = {
--  
--		Blip = {
--		},
--
--
--		-- https://wiki.rage.mp/index.php?title=WEAPONs
--    AuthorizedWeapons = {
--    
--    },
--
--		Cloakrooms = {
--			{ x = 2443.31, y = 4976.8, z = 50.56 },
--		},
--
--    Armories = {
--      { x = 2436.24, y = 4967.21, z = 41.35 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = 2478.0, y = 4957.62, z = 43.98 },
--				SpawnPoints = {
--					{ x = 2485.89, y = 4958.96, z = 43.87, heading = 132.65, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = 2491.41, y = 4964.0, z = 43.69 },
--		},
--
--		BossActions = {
--			{x =  2435.93, y = 4959.16, z = 45.94 },
--		},
--		
--	},
}

Config.partyConfig.AuthorizedVehicles = {
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

Config.partyConfig.Uniforms = {
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