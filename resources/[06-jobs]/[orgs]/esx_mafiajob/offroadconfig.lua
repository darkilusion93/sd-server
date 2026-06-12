Config.offroadConfig                            = {}

Config.offroadConfig.DrawDistance               = 30.0
Config.offroadConfig.MarkerType                 = 1
Config.offroadConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.offroadConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.offroadConfig.EnablePlayerManagement     = true
Config.offroadConfig.EnableArmoryManagement     = true
Config.offroadConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.offroadConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.offroadConfig.EnableSocietyOwnedVehicles = true
Config.offroadConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.offroadConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.offroadConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.offroadConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.offroadConfig.MaxInService               = -1
Config.offroadConfig.Locale                     = 'br'

Config.offroadConfig.Stations = {

 restaurante2 = { --sandy ex motogalia
 
	Blip = {
	},


	-- https://wiki.rage.mp/index.php?title=WEAPONs
   AuthorizedWeapons = {
   
   },

	Cloakrooms = {
		{ x = 2519.47, y = 4100.03, z = 34.59 },
	},

   Armories = {
     { x = 2526.71, y = 4109.41, z = 37.58 },
   },

	Vehicles = {
		{
			Spawner    = {x = -305.87, y = 6281.86, z = -30.49 },
			SpawnPoints = {
				{ x = -305.87, y = 6281.86, z = 30.49, heading = 161.45, radius = 6.0 },
			},
		},
	},

	Helicopters = {
	},

	VehicleDeleters = {
		{x = 2485.41, y = 4118.08, z = 37.2 },
		{x = 2512.36, y = 4076.58, z = 37.58 },
	},

	BossActions = {
		{ x = 2514.4, y = 4094.89, z = -34.59 },
	},
},
	
 
}

Config.offroadConfig.AuthorizedVehicles = {
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

Config.offroadConfig.Uniforms = {
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