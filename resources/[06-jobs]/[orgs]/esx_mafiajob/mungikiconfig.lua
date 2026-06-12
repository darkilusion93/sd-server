Config.mungikiConfig                            = {}

Config.mungikiConfig.DrawDistance               = 30.0
Config.mungikiConfig.MarkerType                 = 1
Config.mungikiConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.mungikiConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.mungikiConfig.EnablePlayerManagement     = true
Config.mungikiConfig.EnableArmoryManagement     = true
Config.mungikiConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.mungikiConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.mungikiConfig.EnableSocietyOwnedVehicles = true
Config.mungikiConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.mungikiConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.mungikiConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.mungikiConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.mungikiConfig.MaxInService               = -1
Config.mungikiConfig.Locale                     = 'br'

Config.mungikiConfig.Stations = {
	oficinasul = { --Oficina Sul Ammunation
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 806.21, y = -2334.44, z = 29.46 },
		},

    Armories = {
      { x = 811.58, y = -2311.75, z = 29.46 },
    },

		Vehicles = {
			{
				Spawner    = { x = 826.96, y = -2342.69, z = 29.33 },
				SpawnPoints = {
					{ x = 836.27, y = -2346.78, z = 29.33, heading = 266.53, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 828.48, y = -2346.48, z = 29.33 },
		},

		BossActions = {
			{x = 807.34, y = -2318.71, z = 29.46 },
		},
	},
	

	
	  underpass = { -- OFICINA JUNTO NORAUTO
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 728.35, y = -1064.91, z = 21.17 },
		},

    Armories = {
      { x = 726.29, y = -1066.54, z = 27.31 },
    },

		Vehicles = {
			{
				Spawner    = { x = 721.27, y = -1081.3, z = 21.06 },
				SpawnPoints = {
					{ x = 707.41, y = -1077.11, z = 22.41, heading = 355.01, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 715.01, y = -1071.62, z = 20.78 },
		},

		BossActions = {
			{x = 726.2, y = -1069.79, z = 27.31 },
		},
	},
	
	
  fuente = {
  
		Blip = {
		},

		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1395.89, y = 1156.78, z = 113.33 },
		},

    Armories = {
      { x = 1405.51, y = 1137.78, z = 108.75 },
    },

		Vehicles = {
			{
				Spawner    = { x = 1414.74, y = 1118.24, z = 113.84 },
				SpawnPoints = {
					{ x = 1399.05, y = 1118.2, z = 113.84, heading = 88.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 1407.330, y = 1118.22, z = 113.84 },
		},

		BossActions = {
			{x = 1396.02, y = 1160.31, z = 113.33 },
		},
	},

	
--  restaurante = {
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
--			{ x = 123.98, y = -1031.49, z = 22.87 },
--		},
--
--    Armories = {
--      { x = 139.72, y = -1063.74, z = 21.96 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = 107.2, y = -1059.99, z = 28.19 },
--				SpawnPoints = {
--					{ x = 123.92, y = -1049.05, z = 28.19, heading = 161.45, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = 110.02, y = -1052.74, z = 28.2 },
--		},
--
--		BossActions = {
--			{x = 125.52, y = -1036.98, z = 28.28 },
--		},
--	},
}

Config.mungikiConfig.AuthorizedVehicles = {
	Shared = {
		{
			model = 's500w222',
			label = 'Mercedes Benz S65 AMG '
		},
		{
			model = 'srt8',
			label = 'Jeep SRT-8 2015'
		},
		{
			model = 'wraith',
			label = 'Rolls-Royce'
		},
		{
			model = 'stretch',
			label = 'Limousine'
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

Config.mungikiConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 1,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 24,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 26,    ['chain_2'] = 2,
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
	capo_wear = {
        male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 1,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 24,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 26,    ['chain_2'] = 2,
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
	consigliere_wear = {
        male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 1,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 24,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 26,    ['chain_2'] = 2,
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
	
	
	lieutenant_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 1,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 24,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 26,    ['chain_2'] = 2,
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
			['tshirt_1'] = 33,  ['tshirt_2'] = 1,
			['torso_1'] = 142,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 24,   ['pants_2'] = 1,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 26,    ['chain_2'] = 2,
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
			['tshirt_1'] = 127,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 31,
			['pants_1'] = 31,  ['pants_2'] = 2,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['bag'] = 69,    ['bag_color'] = 9,
			['glasses_1'] = 0,  ['glasses_2'] = 0
		},
		female = {
			['tshirt_1'] = 2,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 18,
			['pants_1'] = 102,  ['pants_2'] = 0,
			['shoes_1'] = 43,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 35,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 0
		}
	}

}