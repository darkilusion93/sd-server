Config.vagosConfig                           = {}

Config.vagosConfig.DrawDistance               = 30.0
Config.vagosConfig.MarkerType                 = 1
Config.vagosConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.vagosConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.vagosConfig.EnablePlayerManagement     = true
Config.vagosConfig.EnableArmoryManagement     = true
Config.vagosConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.vagosConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.vagosConfig.EnableSocietyOwnedVehicles = true
Config.vagosConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.vagosConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.vagosConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.vagosConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.vagosConfig.MaxInService               = -1
Config.vagosConfig.Locale                     = 'br'

Config.vagosConfig.Stations = {



	
    --mafia255555 = { --NÃO USAR
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
	--		{ x = -592.52, y = -1617.86, z = 32.01 },
	--	},
	--
    --Armories = {
    --  { x = -599.11, y = -1617.26, z = 32.01 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -610.0, y = -1597.44, z = 25.75 },
	--			SpawnPoints = {
	--				{ x = -609.11, y = -1587.71, z = 25.75, heading = 114.02, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{ x = -615.8, y = -1604.473, z = 25.75 },
	--	},
	--
	--	BossActions = {
	--		{x = -617.61, y = -1623.16, z = 32.01 },
	--	},
	--	
	--},

	
  arcade = {
  
		Blip = {
		},

		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 732.6, y = -795.72, z = 17.07 },
		},

    Armories = {
      { x = 727.07, y = -791.52, z = 15.47 },
    },

		Vehicles = {
			{
				Spawner    = { x = 710.19, y = -791.22, z = 15.47 },
				SpawnPoints = {
					{ x = 708.2, y = -797.94, z = 15.47, heading = 91.99, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 710.44, y = -797.69, z = 15.47 },
		},

		BossActions = {
			{x = 741.39, y = -813.86, z = 23.27 },
		},
	},	

	
  black = { --coiso anbandonado drogas
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 1446.15, y = -1668.97, z = 65.13 },
		},

    Armories = {
      { x = 1449.08, y = -1666.12, z = 65.13 },
    },

		Vehicles = {
			{
				Spawner    = { x = 1445.03, y = -1684.96, z = 64.83 },
				SpawnPoints = {
					{ x = 1441.65, y = -1696.88, z = 66.48, heading = 18.15, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = 1457.06, y = -1689.29, z = 65.25 },
		},

		BossActions = {
			{x = 1446.42, y = -1661.28, z = 65.13 },
		},
	},
	
  vagos = { -- tequilla
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -572.23, y = 286.31, z = 78.2 },
		},

    Armories = {
      { x = -573.99, y = 292.98, z = 78.18 },
    },

		Vehicles = {
			{
				Spawner    = { x = -551.14, y = 297.84, z = 82.04 },
				SpawnPoints = {
					{ x = -547.9, y = 303.81, z = 82.04, heading = 271.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -560.2, y = 301.76, z = 82.16 },
		},

		BossActions = {
			{x = -601.34, y = 292.83, z = 93.92 },
		},
	},
}

Config.vagosConfig.AuthorizedVehicles = {
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

Config.vagosConfig.Uniforms = {
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
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 42,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 5,
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
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 42,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 5,
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
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 42,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 5,
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
			['tshirt_1'] = 38,  ['tshirt_2'] = 0,
			['torso_1'] = 66,   ['torso_2'] = 2,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 7,   ['pants_2'] = 0,
			['shoes_1'] = 42,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 5,
		}
	},
	bullet_wear = {
        male = {
			['tshirt_1'] = 16,  ['tshirt_2'] = 0,
			['torso_1'] = 53,   ['torso_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 59,   ['pants_2'] = 6,
			['shoes_1'] = 24,   ['shoes_2'] = 0,
			['helmet_1'] = 60,  ['helmet_2'] = 9,
			['chain_1'] = 0,    ['chain_2'] = 0
		},
		female = {
			['tshirt_1'] = 41,  ['tshirt_2'] = 1,
			['torso_1'] = 194,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 37,   ['pants_2'] = 4,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 7,
		},
	},
	gilet_wear = {
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
			['tshirt_1'] = 41,  ['tshirt_2'] = 1,
			['torso_1'] = 194,   ['torso_2'] = 6,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 49,
			['pants_1'] = 37,   ['pants_2'] = 4,
			['shoes_1'] = 29,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 4,  ['glasses_2'] = 7,
		},
	}

}