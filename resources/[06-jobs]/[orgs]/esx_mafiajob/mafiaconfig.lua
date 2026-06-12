Config.mafiaConfig                            = {}

Config.mafiaConfig.DrawDistance               = 30.0
Config.mafiaConfig.MarkerType                 = 1
Config.mafiaConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.mafiaConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.mafiaConfig.EnablePlayerManagement     = true
Config.mafiaConfig.EnableArmoryManagement     = true
Config.mafiaConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.mafiaConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.mafiaConfig.EnableSocietyOwnedVehicles = true
Config.mafiaConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.mafiaConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.mafiaConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.mafiaConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.mafiaConfig.MaxInService               = -1
Config.mafiaConfig.Locale                     = 'br'
Config.mafiaConfig.Stations = {

  --hamas = { -- Bahamas Bar
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
	--		{ x = -1367.37, y = -613.87, z = 29.32 },
	--	},
  --
  --Armories = {
  --  { x = -1397.1, y = -628.96, z = 29.32 },
  --},
  --
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -1385.66, y = -635.51, z = 27.7 },
	--			SpawnPoints = {
	--				{ x = -1408.77, y = -636.98, z = 27.67, heading = 213.35, radius = 6.0 },
	--			},
	--		},
	--	},
  --
	--	Helicopters = {
	--	},
  --
	--	VehicleDeleters = {
	--		{x = -1392.24, y = -634.22, z = 27.7 },
	--	},
  --
	--	BossActions = {
	--		{x = -1365.92, y = -616.59, z = 29.32 },
	--	},
	--},
	
	mansao_piscinapequena = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -1181.8, y = 297.69, z = 72.65 },
		},

    Armories = {
      { x = -1202.86, y = 295.72, z = 68.72 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1206.98, y = 272.18, z = 68.55 },
				SpawnPoints = {
					{ x = -1203.94, y = 273.49, z = 68.54, heading = 223.45, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = -1205.78, y = 267.72, z = 68.54 },
		},

		BossActions = {
			{x = -1182.43, y = 302.53, z = 72.66 },
		},
		
	},

  canibal = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{x = -1149.34, y = 4939.75, z = 221.27 },
			
		},

    Armories = {
      { x = -1134.71, y = 4944.83, z = 221.27 },
    },

		Vehicles = {
			{
				Spawner    = { x = -1094.5, y = 4939.78, z = 217.24 },
				SpawnPoints = {
					{ x = -1096.43, y = 4933.86, z = 217.02, heading = 155.79, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = -1094.48, y = 4947.12, z = 217.35 },
		},

		BossActions = {
			{x = -1138.37, y = 4936.31, z = 221.27 },
		},
		
	},
	

	
  --[[mafia = {
  
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
		
	},--]]




	

	
	--mafia5 = { --Loja Barcos
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
	--		{ x = -1508.18, y = 1510.79, z = 114.29 },
	--	},
	--
    --Armories = {
    --  { x = -1510.51, y = 1517.98, z = 114.29 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -1513.42, y = 1498.03, z = 114.35 },
	--			SpawnPoints = {
	--				{ x = -1512.56, y = 1484.32, z = 115.45, heading = 191.2, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{x = -1514.63, y = 1494.01, z = 114.7 },
	--	},
	--
	--	BossActions = {
	--		{x = -1508.91, y = 1520.4, z = 114.29 },
	--	},
	--	
	--},
}

Config.mafiaConfig.AuthorizedVehicles = {
	Shared = {
		{
			model = 'C7',
			label = 'Chevrolet Corvette'
		},
		{
			model = 'rs7',
			label = 'Audi RS'
		},
		{
			model = 'patriot',
			label = 'Hummer'
		},
		{
			model = 'bmws',
			label = 'BMW S1000 RR 2014'
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

Config.mafiaConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 52,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 13,  ['glasses_2'] = 10
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
			['tshirt_1'] = 52,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 13,  ['glasses_2'] = 10
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
			['tshirt_1'] = 52,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 13,  ['glasses_2'] = 10
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
			['tshirt_1'] = 52,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 13,  ['glasses_2'] = 10
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
			['tshirt_1'] = 52,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 24,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 0,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['glasses_1'] = 13,  ['glasses_2'] = 10
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
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 17,
			['pants_1'] = 102,  ['pants_2'] = 0,
			['shoes_1'] = 71,   ['shoes_2'] = 1,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['mask_1'] = 35,    ['mask_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
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
	},
	gilet1_wear = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 164,   ['torso_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 27,  ['pants_2'] = 4,
			['shoes_1'] = 7,   ['shoes_2'] = 9,
			['chain_1'] = 90,    ['chain_2'] = 0
		},
		female = {
		}
	},
	gilet2_wear = {
		male = {
			['tshirt_1'] = 16,  ['tshirt_2'] = 0,
			['torso_1'] = 220,   ['torso_2'] = 20,
			['arms'] = 1,
			['pants_1'] = 1,  ['pants_2'] = 1,
			['shoes_1'] = 7,   ['shoes_2'] = 2,
			['helmet_1'] = 51,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0
		},
		female = {
		}
	},
	gilet4_wear = {
		male = {
			['tshirt_1'] = 26,  ['tshirt_2'] = 3,
			['torso_1'] = 58,   ['torso_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 28,  ['pants_2'] = 0,
			['shoes_1'] = 40,   ['shoes_2'] = 8,
			['chain_1'] = 24,    ['chain_2'] = 2,
			['helmet_1'] = 95,  ['helmet_2'] = 1,
			['glasses_1'] = 5,  ['glasses_2'] = 5
		},
		female = {
		}
	},
	gilet5_wear = {
		male = {
			['tshirt_1'] = 100,  ['tshirt_2'] = 0,
			['torso_1'] = 281,   ['torso_2'] = 12,
			['arms'] = 22,
			['pants_1'] = 64,  ['pants_2'] = 10,
			['shoes_1'] = 42,   ['shoes_2'] = 3,
			['chain_1'] = 123,    ['chain_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['glasses_1'] = 17,  ['glasses_2'] = 10
		},
		female = {
		}
	},
	gilet3_wear = {
		male = {
			['tshirt_1'] = 22,  ['tshirt_2'] = 2,
			['torso_1'] = 120,   ['torso_2'] = 3,
			['arms'] = 14,
			['pants_1'] = 28,  ['pants_2'] = 2,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0
		},
		female = {
		}
	}

}