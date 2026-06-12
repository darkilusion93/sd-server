Config.groveConfig                            = {}

Config.groveConfig.DrawDistance               = 30.0
Config.groveConfig.MarkerType                 = 1
Config.groveConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.groveConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.groveConfig.EnablePlayerManagement     = true
Config.groveConfig.EnableArmoryManagement     = true
Config.groveConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.groveConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.groveConfig.EnableSocietyOwnedVehicles = true
Config.groveConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.groveConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.groveConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.groveConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.groveConfig.MaxInService               = -1
Config.groveConfig.Locale                     = 'br'

Config.groveConfig.Stations = {

--  sallon = { --paleto sallon
  
-- 		Blip = {
-- 		},


-- 		-- https://wiki.rage.mp/index.php?title=WEAPONs
--     AuthorizedWeapons = {
    
--     },

-- 		Cloakrooms = {
-- 			{ x = -295.0, y = 6294.3, z = 30.65 },
-- 		},

--     Armories = {
--       { x = -297.58, y = 6289.78, z = 30.65 },
--     },

-- 		Vehicles = {
-- 			{
-- 				Spawner    = {x = -305.87, y = 6281.86, z = 30.49 },
-- 				SpawnPoints = {
-- 					{ x = -305.87, y = 6281.86, z = 30.49, heading = 161.45, radius = 6.0 },
-- 				},
-- 			},
-- 		},

-- 		Helicopters = {
-- 		},

-- 		VehicleDeleters = {
-- 			{x = -293.2, y = 6285.69, z = 30.49 },
-- 		},

-- 		BossActions = {
-- 			{x = -295.85, y = 6268.38, z = 30.53 },
-- 		},
-- 	},

  celeiro = { --Barraco da Weed
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1932.81, y = 4623.41, z = 39.47 },
		},

    Armories = {
      { x = 1932.02, y = 4612.79, z = 39.47 },
    },

		Vehicles = {
			{
				Spawner    = { x = 1946.73, y = 4652.21, z = 39.55 },
				SpawnPoints = {
					{ x = 1964.43, y = 4646.25, z = 39.79, heading = 267.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			--{x = 1952.95, y = 4651.43, z = 39.68 },
			{x = 1941.86, y = 4642.48, z = 39.67 },
		},

		BossActions = {
			{x = 1924.53, y = 4623.58, z = 39.47 },
		},
	},
	

	
    avengers = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -3340.63, y = 1778.47, z = 27.95 },
		},

    Armories = {
     { x = -3347.56, y = 1796.86, z = 21.21 },
    },

		Vehicles = {
			{
				Spawner    = { x = -3366.14, y = 1794.51, z = 25.14 },
				SpawnPoints = {
					{ x = -3366.14, y = 1794.51, z = 25.14, heading = 236.28, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -3366.14, y = 1794.51, z = 25.14 },
		},

		BossActions = {
			{ x = -3347.56, y = 1796.86, z = -21.21 },
		},
		
	}, 

	
--    mafia = { --docas
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
--			{ x = 591.18, y = -3278.73, z = 5.07 },
--		},
--
--    Armories = {
--      { x = 588.24, y = -3278.83, z = 5.07 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = 609.09, y = -3130.87, z = 6.07 },
--				SpawnPoints = {
--					{ x = 609.77, y = -3118.61, z = 5.07, heading = 356.84, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = 465.86, y = -3191.1, z = 5.07 },
--		},
--
--		BossActions = {
--			{x = 591.08, y = -3282.1, z = 5.07},
--		},
--		
--	},
	
}

Config.groveConfig.AuthorizedVehicles = {
	Shared = {
		{
			model = '16challenger',
			label = 'Dodge Challenger 2016'
		},
		{
			model = 'titan17',
			label = 'Nissan Titan'
		},
		{
			model = 'mule3',
			label = 'Carrinha de transporte'
		},
		{
			model = 'hfc250',
			label = 'Honda FC 250'
		},
		{
			model = 'gtr',
			label = 'Nissan GTR'
		},
	},

	soldato = {


	},

	capo = {
		

	},
	consigliere = {
		

	},

	boss = {
		

	}
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.groveConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 1,
			['torso_1'] = 140,   ['torso_2'] = 10,
			['glasses_1'] = 5,   ['glasses_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 7,
			['helmet_1'] = 61,  ['helmet_2'] = 4,
			['chain_1'] = 27,    ['chain_2'] = 15
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
	},
	capo_wear = {
        male = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 1,
			['torso_1'] = 140,   ['torso_2'] = 10,
			['glasses_1'] = 5,   ['glasses_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 7,
			['helmet_1'] = 61,  ['helmet_2'] = 4,
			['chain_1'] = 27,    ['chain_2'] = 15
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
	},
	consigliere_wear = {
        male = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 1,
			['torso_1'] = 140,   ['torso_2'] = 10,
			['glasses_1'] = 5,   ['glasses_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 7,
			['helmet_1'] = 61,  ['helmet_2'] = 4,
			['chain_1'] = 27,    ['chain_2'] = 15
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 1,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		},
	},
	boss_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 1,
			['torso_1'] = 140,   ['torso_2'] = 10,
			['glasses_1'] = 5,   ['glasses_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 20,   ['shoes_2'] = 7,
			['helmet_1'] = 61,  ['helmet_2'] = 4,
			['chain_1'] = 27,    ['chain_2'] = 15
		},
		female = {
			['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
		}
	},
	bullet_wear = {
        male = {
			['tshirt_1'] = 26,  ['tshirt_2'] = 7,
			['torso_1'] = 192,   ['torso_2'] = 6,
			['glasses_1'] = 5,   ['glasses_2'] = 0,
			['arms'] = 26,
			['pants_1'] = 24,   ['pants_2'] = 4,
			['shoes_1'] = 20,   ['shoes_2'] = 7,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		}
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 59,  ['tshirt_2'] = 1
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		}
	}

}