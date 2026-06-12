Config.cartelConfig                            = {}

Config.cartelConfig.DrawDistance               = 30.0
Config.cartelConfig.MarkerType                 = 1
Config.cartelConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.cartelConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.cartelConfig.EnablePlayerManagement     = true
Config.cartelConfig.EnableArmoryManagement     = true
Config.cartelConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.cartelConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.cartelConfig.EnableSocietyOwnedVehicles = true
Config.cartelConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.cartelConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.cartelConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.cartelConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.cartelConfig.MaxInService               = -1
Config.cartelConfig.Locale                     = 'br'

Config.cartelConfig.Stations = {

	  barco = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -2239.79, y = -637.27, z = 12.9 },
		},

    Armories = {
      { x = -2244.38, y = -638.01, z = 12.9 },
    },

		Vehicles = {
			{
				Spawner    = { x = -2101.2, y = -495.24, z = 11.1 },
				SpawnPoints = {
					{ x = -2104.14, y = -493.17, z = 11.1, heading = 326.71, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -2106.96, y = -491.2, z = 11.1 },
		},

		BossActions = {
			{x = -2249.92, y = -640.92, z = 12.9 },
		},
	},

  mafia = {  --AUDITÓRIOS
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -65.79, y = 989.05, z = 233.57 },
		},

    Armories = {
      { x = -85.37, y = 997.48, z = 229.61 },
    },

		Vehicles = {
			{
				Spawner    = { x = -125.25, y = 1006.92, z = 234.73 },
				SpawnPoints = {
					{ x = -123.54, y = 995.11, z = 234.77, heading = 154.85, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -130.6, y = 1004.82, z = 234.73 },
		},

		BossActions = {
			{x = -58.27, y = 982.45, z = 233.58 },
		},
		
	},
	


  mike = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -803.77, y = 169.53, z = 75.74 },
		},

    Armories = {
      { x = -799.86, y = 177.46, z = 71.83 },
    },

		Vehicles = {
			{
				Spawner    = { x = -819.73, y = 183.98, z = 71.13 },
				SpawnPoints = {
					{ x = -824.0, y = 181.32, z = 70.67, heading = 145.13, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -824.0, y = 181.32, z = 70.67 },
		},

		BossActions = {
			{x = -811.79, y = 175.09, z = 75.75 },
		},
		
	},
	
	--[[cartel = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1509.45, y = 849.61, z = 180.54 },
		},

    Armories = {
      { x = -1499.78, y = 835.1, z = 177.7 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1551.3, y = 880.54, z = 180.32 },
				SpawnPoints = {
					{ x = -1534.61, y = 883.04, z = 181.67, heading = 260.00, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1545.93, y = 886.36, z = 180.34 },
		},

		BossActions = {
			{x = -1525.29, y = 840.25, z = 180.55 },
		},
	},
	  cartel2 = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 3104.82, y = 2138.35, z = 1.75 },
		},

    Armories = {
      { x = 3116.01, y = 2238.08, z = 2.84 },
    },

		Vehicles = {
			{
				Spawner    = { x = 2836.96, y = 1459.31, z = 23.56 },
				SpawnPoints = {
					{ x = 2834.71, y = 1460.81, z = 24.56, heading = 338.21, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 2829.17, y = 1461.15, z = 23.56 },
		},

		BossActions = {
			{x = 3147.39, y = 2214.5, z = 2.2 },
		},
	},--]]

	
    --mafia5 = { --Oficina Meio da Cidade
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
	--		{ x = -111.09, y = -52.67, z = 55.42 },
	--	},
	--
    --Armories = {
    --  { x = -94.77, y = -68.66, z = 57.15 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -106.49, y = -55.54, z = 55.42 },
	--			SpawnPoints = {
	--				{ x = -109.25, y = -61.17, z = 55.42, heading = 160.0, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{x = -102.46, y = -56.9, z = 55.42 },
	--	},
	--
	--	BossActions = {
	--		{x = -113.99, y = -58.08, z = 55.42 },
	--	},
	--	
	--},
	

	
	--casino = {
	--
	--		Blip = {
	--		},
	--
	--
	--		-- https://wiki.rage.mp/index.php?title=WEAPONs
	--	AuthorizedWeapons = {
	--	
	--	},
	--
	--		Cloakrooms = {
	--			{ x = 964.71, y = 17.32, z = 74.74 },
	--		},
	--
	--	Armories = {
	--	{ x = 958.73, y = 19.29, z = 74.74 },
	--	},
	--
	--		Vehicles = {
	--			{
	--				Spawner    = { x = 956.78, y = 50.0, z = 79.96 },
	--				SpawnPoints = {
	--					{ x = 958.14, y = 45.24, z = 79.56, heading = 238.49, radius = 6.0 },
	--				},
	--			},
	--		},
	--
	--		Helicopters = {
	--		},
	--
	--		VehicleDeleters = {
	--			{x = 964.51, y = 46.60, z = 79.96 },
	--		},
	--
	--		BossActions = {
	--			{x = 957.24, y = 54.92, z = 74.44 },
	--		},
	--	},	
}

Config.cartelConfig.AuthorizedVehicles = {
	Shared = {
		{
			model = 'mCARTEL',
			label = 'Mercedes AMG'
		},
		{
			model = 'patriot',
			label = 'Hummer'
		},
		{
			model = '18Velar',
			label = 'Land Rover'
		},
		{
			model = 'bmwX6F16',
			label = 'BMW X6'
		}
	},

	recruit = {
	},

	officer = {
	},
	
	sergeant = {
	},
	
	lieutenant = {
	},

	boss = {
	},
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.cartelConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 2,
			['torso_1'] = 72,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 45,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 2,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 7
		},
		female = {
		}
	},
	capo_wear = {
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 2,
			['torso_1'] = 72,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 45,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 2,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 7
		},
		female = {
		}
	},
	consigliere_wear = {
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 2,
			['torso_1'] = 72,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 45,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 2,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 7
		},
		female = {
		}
	},
	
	
	lieutenant_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 2,
			['torso_1'] = 72,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 45,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 2,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 7
		},
		female = {
			['tshirt_1'] = 23,  ['tshirt_2'] = 12,
			['torso_1'] = 7,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 1,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0
		}
	},
	boss_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 32,  ['tshirt_2'] = 2,
			['torso_1'] = 72,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 22,
			['pants_1'] = 45,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = 7,  ['helmet_2'] = 2,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 7
		},
		female = {
			['tshirt_1'] = 23,  ['tshirt_2'] = 12,
			['torso_1'] = 7,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 1,    ['chain_2'] = 1,
			['ears_1'] = 0,     ['ears_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0
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
			['tshirt_1'] = 14,  ['tshirt_2'] = 0,
			['torso_1'] = 86,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 23,
			['pants_1'] = 34,  ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 94,  ['helmet_2'] = 8,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['glasses_1'] = 7,  ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 2,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,  ['pants_2'] = 0,
			['shoes_1'] = 43,   ['shoes_2'] = 1,
			['helmet_1'] = 1,  ['helmet_2'] = 0,
			['mask_1'] = 35,    ['mask_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0
		}
	}

}