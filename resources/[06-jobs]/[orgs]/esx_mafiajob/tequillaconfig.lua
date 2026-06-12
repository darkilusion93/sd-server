Config.tequillaConfig                            = {}

Config.tequillaConfig.DrawDistance               = 30.0
Config.tequillaConfig.MarkerType                 = 1
Config.tequillaConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.tequillaConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.tequillaConfig.EnablePlayerManagement     = true
Config.tequillaConfig.EnableArmoryManagement     = true
Config.tequillaConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.tequillaConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.tequillaConfig.EnableSocietyOwnedVehicles = true
Config.tequillaConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.tequillaConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.tequillaConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.tequillaConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.tequillaConfig.MaxInService               = -1
Config.tequillaConfig.Locale                     = 'br'

Config.tequillaConfig.Stations = {

  pearl = { --HAYES / OLD CENTROVIA
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1424.91, y = -457.29, z = 34.91 },
		},

    Armories = {
      { x = -1410.18, y = -448.08, z = 34.91 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1409.03, y = -462.94, z = 33.48 },
				SpawnPoints = {
					{ x = -1851.55, y = -1186.36, z = 12.02, heading = 316.87, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1409.03, y = -459.94, z = 33.48 },
		},

		BossActions = {
			{x = -1427.76, y = -458.44, z = 34.91 },
		},
	},

	npoficina = { --DOCAS NP AUTO
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 153.57, y = -3011.44, z = 6.04 },
		},

    Armories = {
      { x = 146.68, y = -3007.96, z = 6.04 },
    },

		Vehicles = {
			{
				Spawner    = { x = 125.64, y = -3044.17, z = 6.04 },
				SpawnPoints = {
					{ x = 125.64, y = -3044.17, z = 6.04, heading = 316.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 125.64, y = -3044.17, z = 6.04 },
		},

		BossActions = {
			{x = 124.71, y = -3013.83, z = 6.04 },
		},
	},
	
	

	reab = {  --REABILITA
  
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
	
	
	
}

Config.tequillaConfig.AuthorizedVehicles = {
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

Config.tequillaConfig.Uniforms = {
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