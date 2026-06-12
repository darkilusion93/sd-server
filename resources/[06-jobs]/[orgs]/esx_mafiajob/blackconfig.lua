Config.blackConfig                            = {}

Config.blackConfig.DrawDistance               = 30.0
Config.blackConfig.MarkerType                 = 1
Config.blackConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.blackConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.blackConfig.EnablePlayerManagement     = true
Config.blackConfig.EnableArmoryManagement     = true
Config.blackConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.blackConfig.EnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.blackConfig.EnableSocietyOwnedVehicles = true
Config.blackConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.blackConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.blackConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.blackConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.blackConfig.MaxInService               = -1
Config.blackConfig.Locale                     = 'br'

Config.blackConfig.Stations = {

	vski = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -347.27, y = 521.22, z = 119.54 },
		},

    Armories = {
      { x = -330.01, y = 513.4, z = 119.16 },
    },

		Vehicles = {
			{
				Spawner    = { x = -367.84, y = 513.55, z = 118.33 },
				SpawnPoints = {
					{ x = -360.42, y = 514.04, z = 118.62, heading = 129.59, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -362.18, y = 512.43, z = 118.55 },
		},

		BossActions = {
			{x = -341.82, y = 523.55, z = 119.16 },
		},
	},
	
  dinner = { --pops
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1590.48, y = 6457.72, z = 25.01 },
		},

    Armories = {
      { x = 1599.42, y = 6456.18, z = 24.32 },
    },

		Vehicles = {
			{
				Spawner    = { x = 1606.8, y = 6452.49, z = 24.24 },
				SpawnPoints = {
					{ x = 1606.8, y = 6452.49, z = 24.24, heading = 145.13, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = 1606.8, y = 6452.49, z = 24.24 },
		},

		BossActions = {
			{ x = 2198.88, y = 5613.87, z = 52.69 },
		},
		
	},
	


  paleto = { --Mojito
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -104.61, y = 6386.62, z = 31.18 },
		},

    Armories = {
      { x = -107.26, y = 6383.99, z = 31.18 },
    },

		Vehicles = {
			{
				Spawner    = { x = -97.51, y = 6383.07, z = 30.48 },
				SpawnPoints = {
					{ x = -103.89, y = 6395.03, z = 30.48, heading = 42.62, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -96.93, y = 6388.05, z = 30.49 },
		},

		BossActions = {
			{x = -110.12, y = 6381.04, z = 31.18 },
		},
	},
	
	
	playboy = { --Playboy
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1531.37, y = 142.56, z = 54.67 },
		},

    Armories = {
      { x = -1518.61, y = 112.86, z = 49.04 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1528.82, y = 81.73, z = 55.65 },
				SpawnPoints = {
					{ x = -1530.09, y = 85.74, z = 55.68, heading = 316.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1523.48, y = 82.41, z = 55.57 },
		},

		BossActions = {
			{x = -1497.97, y = 129.72, z = 54.67 },
		},
	},	





--	cartel2 = { --Covil
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
--			{ x = 3104.82, y = 2138.35, z = 1.75 },
--		},
--
--    Armories = {
--      { x = 3116.01, y = 2238.08, z = 2.84 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = 2836.96, y = 1459.31, z = 23.56 },
--				SpawnPoints = {
--					{ x = 2834.71, y = 1460.81, z = 24.56, heading = 338.21, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = 2829.17, y = 1461.15, z = 23.56 },
--		},
--
--		BossActions = {
--			{x = 3147.39, y = 2214.5, z = 2.2 },
--		},
--	},
}

Config.blackConfig.AuthorizedVehicles = {
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

Config.blackConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
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
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
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
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 1,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
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
			['tshirt_1'] = 58,  ['tshirt_2'] = 0,
			['torso_1'] = 55,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 41,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
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
			['bproof_1'] = 11,  ['bproof_2'] = 1
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