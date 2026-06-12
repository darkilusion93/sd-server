Config.docksConfig                            = {}

Config.docksConfig.DrawDistance               = 30.0
Config.docksConfig.MarkerType                 = 1
Config.docksConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.docksConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.docksConfig.EnablePlayerManagement     = true
Config.docksConfig.EnableArmoryManagement     = true
Config.docksConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.docksConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.docksConfig.EnableSocietyOwnedVehicles = true
Config.docksConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.docksConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.docksConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.docksConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.docksConfig.MaxInService               = -1
Config.docksConfig.Locale                     = 'br'

Config.docksConfig.Stations = {

	


	
	
   casaabandonada = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 2443.31, y = 4976.8, z = 50.56 },
		},

    Armories = {
      { x = 2436.24, y = 4967.21, z = 41.35 },
    },

		Vehicles = {
			{
				Spawner    = { x = 2478.0, y = 4957.62, z = 43.98 },
				SpawnPoints = {
					{ x = 2485.89, y = 4958.96, z = 43.87, heading = 132.65, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 2491.41, y = 4964.0, z = 43.69 },
		},

		BossActions = {
			{x =  2435.93, y = 4959.16, z = 45.94 },
		},
		
	},
	

 	--mansao_piscinapequena = {
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
	--		{ x = -1181.8, y = 297.69, z = 72.65 },
	--	},
	--
    --Armories = {
    --  { x = -1202.86, y = 295.72, z = 68.72 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -1206.98, y = 272.18, z = 68.55 },
	--			SpawnPoints = {
	--				{ x = -1203.94, y = 273.49, z = 68.54, heading = 223.45, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{ x = -1205.78, y = 267.72, z = 68.54 },
	--	},
	--
	--	BossActions = {
	--		{x = -1182.43, y = 302.53, z = 72.66 },
	--	},
	--	
	--},


   	  hill_mansion = { --SHUTDOWN
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -2673.98, y = 1304.91, z = 151.01 },
		},

    Armories = {
      { x = -2674.88, y = 1328.38, z = 139.88 },
    },

		Vehicles = {
			{
				Spawner    = { x = -2669.76, y = 1309.75, z = 146.12 },
				SpawnPoints = {
					{ x = -2660.38, y = 1307.347, z = 146.12, heading = 269.51, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -2660.95, y = 1307.43, z = 146.12 },
		},

		BossActions = {
			{x = -2671.67, y = 1335.22, z = 143.26 },
		},
	},	


  karts = { --karts
  
		Blip = {
		},

		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1182.46, y = -2137.88, z = 12.26 },
		},

    Armories = {
      { x = -1179.93, y = -2129.43, z = 12.26 },
    },

		Vehicles = {
			{
				Spawner    = {x = -1161.75, y = -2111.79, z = 12.26 },
				SpawnPoints = {
					{ x = -77.54, y = -24.33, z = 65.09, heading = 252.27, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1161.75, y = -2111.79, z = 12.26 },
		},

		BossActions = {
			{x = -1109.48, y = -2111.24, z = 69.52 },
		},
	},

--  grove = { --CASA PERDIDA
--  
--		Blip = {
--		},
--
--		-- https://wiki.rage.mp/index.php?title=WEAPONs
--    AuthorizedWeapons = {
--    
--    },
--
--		Cloakrooms = {
--			--{ x = 00.00, y = 00.00, z = 00.00 },
--		},
--
--    Armories = {
--      { x = -110.66, y = -14.64, z = 69.52 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = -84.85, y = -25.45, z = 65.32 },
--				SpawnPoints = {
--					{ x = -77.54, y = -24.33, z = 65.09, heading = 252.27, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = -82.98, y = -20.95, z = 65.32 },
--		},
--
--		BossActions = {
--			{x = -109.48, y = -12.24, z = 69.52 },
--		},
--	},

}

Config.docksConfig.AuthorizedVehicles = {
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

Config.docksConfig.Uniforms = {
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