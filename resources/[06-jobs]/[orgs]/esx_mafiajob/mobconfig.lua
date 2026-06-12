Config.mobConfig                            = {}

Config.mobConfig.DrawDistance               = 30.0
Config.mobConfig.MarkerType                 = 1
Config.mobConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.mobConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.mobConfig.EnablePlayerManagement     = true
Config.mobConfig.EnableArmoryManagement     = true
Config.mobConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.mobConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.mobConfig.EnableSocietyOwnedVehicles = true
Config.mobConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.mobConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.mobConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.mobConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.mobConfig.MaxInService               = -1
Config.mobConfig.Locale                     = 'br'

Config.mobConfig.Stations = {


 yellow = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1992.104, y = 3047.552, z = 49.501 },
			
		},

    Armories = {

	  {x = 1994.466, y = 3043.063, z = 46.213 },
    },

		Vehicles = {
			{
				Spawner    = { x = 1973.22, y = 3028.14, z = 46.07 },
				SpawnPoints = {
					{ x = 1967.25, y = 3035.29, z = 46.05, heading = 321.68, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 1995.547, y = 3031.029, z = 46.034 },
		},

		BossActions = {
			{x = 1987.582, y = 3046.461, z = 49.501 },
		},
		
	},	


}

Config.mobConfig.AuthorizedVehicles = {
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

Config.mobConfig.Uniforms = {
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