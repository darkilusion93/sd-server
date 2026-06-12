Config.gangConfig                            = {}

Config.gangConfig.DrawDistance               = 30.0
Config.gangConfig.MarkerType                 = 1
Config.gangConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.gangConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.gangConfig.EnablePlayerManagement     = true
Config.gangConfig.EnableArmoryManagement     = true
Config.gangConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.gangConfig.EnableNonFreemodePeds      = true -- turn this on if you want custom peds
Config.gangConfig.EnableSocietyOwnedVehicles = true
Config.gangConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.gangConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.gangConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.gangConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.gangConfig.MaxInService               = -1
Config.gangConfig.Locale                     = 'br'

Config.gangConfig.Stations = {


	lost = {  --lost mc
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 972.3, y = -99.14, z = 73.85 },
		},

    Armories = {
      { x = 986.68, y = -92.66, z = 73.85 },
    },

		Vehicles = {
			{
				Spawner    = { x = 993.43, y = -129.75, z = 73.06 },
				SpawnPoints = {
					{ x = 993.51, y = -125.79, z = 73.06, heading = 97.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 998.02, y = -127.83, z = 73.06 },
		},

		BossActions = {
			{x = 976.94, y = -103.92, z = 73.85 },
		},
	},


	oficinaaero = { --Oficina Aeroporto
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1144.8, y = -2004.58, z = 12.18 },
		},

    Armories = {
      { x = -1141.62, y = -2005.64, z = 12.18 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1130.5, y = -2000.7, z = 12.17 },
				SpawnPoints = {
					{ x = -1130.5, y = -2000.7, z = 12.17, heading = 307.0, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = -1130.5, y = -2000.7, z = 12.17 },
		},

		BossActions = {
			{x = -1155.8, y = -2000.23, z = 12.18 },
		},
	},	
	

	
  brick = { --BRICK este
  
		Blip = {
		},

		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1797.28, y = 426.62, z = 127.51 },
		},

    Armories = {
      { x = -1818.94, y = 434.2, z = 131.31 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1794.85, y = 457.45, z = 65.32 },
				SpawnPoints = {
					{ x = -1794.54, y = 457.33, z = 65.09, heading = 252.27, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1794.96, y = 458.15, z = 127.31 },
		},

		BossActions = {
			{x = -1814.62, y = 445.21, z = 131.34 },
		},
	},
	
--    mafia = { --GOLF
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
--			{ x = -1369.23, y = 38.36, z = 59.61 },
--		},
--
--    Armories = {
--      { x = -1351.03, y = 83.59, z = 54.25 },
--    },
--
--		Vehicles = {
--			{
--				Spawner    = { x = -1376.04, y = 65.39, z = 52.7 },
--				SpawnPoints = {
--					{ x = -1381.61, y = 76.38, z = 52.76, heading = 3.02, radius = 6.0 },
--				},
--			},
--		},
--
--		Helicopters = {
--		},
--
--		VehicleDeleters = {
--			{x = -1373.91, y = 47.31, z = 52.7 },
--		},
--
--		BossActions = {
--			{x = -1347.15, y = 36.3, z = 59.6 },
--		},
--		
--	},




}

Config.gangConfig.AuthorizedVehicles = {
	Shared = {
	},

	soldato = {
		{
			model = 'yfz68',
			label = 'Mota'
		},
		{
			model = 'sandking',
			label = '4X4'
		},
		{
			model = 'mule3',
			label = 'Camião de transporte'
		},
		{
			model = 'guardian',
			label = 'Grande 4x4'
		},
		{
			model = 'burrito3',
			label = 'Mini Van'
		},
		{
			model = 'mesa',
			label = 'Terreno'
		},
		{
			model = 'demonhawk',
			label = 'Jeep - Demonhank'
		},
		{
			model = 'teslapd',
			label = 'Tesla - Model S'
		},
		{
			model = '2018zl1',
			label = 'Chevrolet - ZL1'
		},
		{
			model = 'crx2',
			label = 'Honda - CRX'
		},

	},

	capo = {
		{
			model = 'yfz68',
			label = 'Mota'
		},
		{
			model = 'sandking',
			label = '4X4'
		},
		{
			model = 'mule3',
			label = 'Camião de transporte'
		},
		{
			model = 'guardian',
			label = 'Grande 4x4'
		},
		{
			model = 'burrito3',
			label = 'Mini Van'
		},
		{
			model = 'mesa',
			label = 'Terreno'
		},
		{
			model = 'demonhawk',
			label = 'Jeep - Demonhank'
		},
		{
			model = 'teslapd',
			label = 'Tesla - Model S'
		},
		{
			model = '2018zl1',
			label = 'Chevrolet - ZL1'
		},
		{
			model = 'crx2',
			label = 'Honda - CRX'
		},
	},
	
	consigliere = {
		{
			model = 'yfz68',
			label = 'Mota'
		},
		{
			model = 'sandking',
			label = '4X4'
		},
		{
			model = 'mule3',
			label = 'Camião de transporte'
		},
		{
			model = 'guardian',
			label = 'Grande 4x4'
		},
		{
			model = 'burrito3',
			label = 'Mini Van'
		},
		{
			model = 'mesa',
			label = 'Terreno'
		},
		{
			model = 'demonhawk',
			label = 'Jeep - Demonhank'
		},
		{
			model = 'teslapd',
			label = 'Tesla - Model S'
		},
		{
			model = '2018zl1',
			label = 'Chevrolet - ZL1'
		},
		{
			model = 'crx2',
			label = 'Honda - CRX'
		},

	},

	boss = {
		{
			model = 'yfz68',
			label = 'Mota'
		},
		{
			model = 'sandking',
			label = '4X4'
		},
		{
			model = 'mule3',
			label = 'Camião de transporte'
		},
		{
			model = 'guardian',
			label = 'Grande 4x4'
		},
		{
			model = 'burrito3',
			label = 'Mini Van'
		},
		{
			model = 'mesa',
			label = 'Terreno'
		},
		{
			model = 'demonhawk',
			label = 'Jeep - Demonhank'
		},
		{
			model = 'teslapd',
			label = 'Tesla - Model S'
		},
		{
			model = '2018zl1',
			label = 'Chevrolet - ZL1'
		},
		{
			model = 'crx2',
			label = 'Honda - CRX'
		},
	}
}


-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements

Config.gangConfig.Uniforms = {
	a_wear = {
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 223,   ['torso_2'] = 4,
			['arms'] = 2,
			['pants_1'] = 87,   ['pants_2'] = 21,
			['shoes_1'] = 62,   ['shoes_2'] = 6,
			['helmet_1'] = 131,  ['helmet_2'] = 4,
			['glasses_1'] = 14,  ['glasses_2'] = 0,
			['bags_1'] = 0
		},
		female = {
		},
	},
	b_wear = {
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 224,   ['torso_2'] = 4,
			['arms'] = 4,
			['pants_1'] = 87,   ['pants_2'] = 21,
			['shoes_1'] = 62,   ['shoes_2'] = 6,
			['helmet_1'] = 131,  ['helmet_2'] = 4,
			['glasses_1'] = 14,  ['glasses_2'] = 0,
			['bags_1'] = 0
		},
		female = {
		},
	},
	c_wear = {
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 194,   ['torso_2'] = 0,
			['arms'] = 5,
			['pants_1'] = 90,   ['pants_2'] = 8,
			['shoes_1'] = 86,   ['shoes_2'] = 8,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 9,
			['bags_1'] = 41
		},
		female = {
		},
	},
	d_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 49,   ['torso_2'] = 2,
			['arms'] = 28,
			['pants_1'] = 59,   ['pants_2'] = 6,
			['shoes_1'] = 81,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['glasses_1'] = 5,  ['glasses_2'] = 9,
			['bags_1'] = 41
		},
		female = {
		}
	},
	e_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 75,  ['tshirt_2'] = 3,
			['torso_1'] = 119,   ['torso_2'] = 4,
			['arms'] = 77,
			['pants_1'] = 24,   ['pants_2'] = 5,
			['shoes_1'] = 21,   ['shoes_2'] = 9,
			['helmet_1'] = 21,  ['helmet_2'] = 3,
			['chain_1'] = 22,    ['chain_2'] = 0,
			['glasses_1'] = 8,  ['glasses_2'] = 5,
			['bags_1'] = 0
		},
		female = {
		}
	},
	f_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 26,  ['tshirt_2'] = 2,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['arms'] = 6,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 1,   ['shoes_2'] = 14,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 24,    ['chain_2'] = 9
		},
		female = {
		}
	},
	g_wear = { -- currently the same as chef_wear
        male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 128,   ['torso_2'] = 2,
			['arms'] = 11,
			['pants_1'] = 42,   ['pants_2'] = 0,
			['shoes_1'] = 9,   ['shoes_2'] = 5,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 24,    ['chain_2'] = 9
		},
		female = {
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