Config.ammunationConfig                            = {}

Config.ammunationConfig.DrawDistance               = 30.0
Config.ammunationConfig.MarkerType                 = 1
Config.ammunationConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.ammunationConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.ammunationConfig.EnablePlayerManagement     = true
Config.ammunationConfig.EnableArmoryManagement     = true
Config.ammunationConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.ammunationConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.ammunationConfig.EnableSocietyOwnedVehicles = true
Config.ammunationConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.ammunationConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.ammunationConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.ammunationConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.ammunationConfig.MaxInService               = -1
Config.ammunationConfig.Locale                     = 'br'

Config.ammunationConfig.Stations = {

	
  subterr = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 918.19, y = -1795.86, z = 21.14 },
		},

    Armories = {
      { x = 911.23, y = -1808.89, z = 21.34 },
    },

		Vehicles = {
			{
				Spawner    = {x = 1191.41, y = -3212.72, z = -9.16 },
				SpawnPoints = {
					{ x = 1191.41, y = -3212.72, z = -9.16, heading = 161.45, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 910.61, y = -1785.39, z = 21.14},
		},

		BossActions = {
			{x = 1207.86, y = -3199.00, z = -9.16 },
		},
	},
	
  grove = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1187.17, y = 2636.03, z = 37.4 },
		},

    Armories = {
      { x = 1188.79, y = 2640.83, z = 37.4 },
    },

		Vehicles = {
			{
				Spawner    = {x = -107.2, y = -1809.25, z = 25.81 },
				SpawnPoints = {
					{ x = -107.2, y = -1809.25, z = 25.81, heading = 161.45, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 1173.31, y = 2629.0, z = 36.79},
		},

		BossActions = {
			{x = -99.89, y = -1792.77, z = 31.2 },
		},
	},
}

Config.ammunationConfig.AuthorizedVehicles = {
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

Config.ammunationConfig.Uniforms = {
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