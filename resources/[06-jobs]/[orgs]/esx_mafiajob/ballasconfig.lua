Config.ballasConfig                            = {}

Config.ballasConfig.DrawDistance               = 30.0
Config.ballasConfig.MarkerType                 = 1
Config.ballasConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.ballasConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.ballasConfig.EnablePlayerManagement     = true
Config.ballasConfig.EnableArmoryManagement     = true
Config.ballasConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.ballasConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.ballasConfig.EnableSocietyOwnedVehicles = true
Config.ballasConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.ballasConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.ballasConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.ballasConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.ballasConfig.MaxInService               = -1
Config.ballasConfig.Locale                     = 'br'

Config.ballasConfig.Stations = {





	mafia3 = { --OFICINA SUL / bombeiros antigos
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 965.92, y = -1833.90, z = 30.28 },
		},

    Armories = {
      { x = 965.63, y = -1837.77, z = 30.28 },
    },

		Vehicles = {
			{
				Spawner    = { x = 964.53, y = -1824.23, z = 30.1 },
				SpawnPoints = {
					{ x = 982.39, y = -1817.04, z = 30.17, heading = 82.05, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{x = 968.8, y = -1824.6, z = 30.1 },
		},

		BossActions = {
			{x = 974.24, y = -1838.28, z = 35.11 },
		},
		
	},


	
  fazemda = { --FAZENDA
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = 2230.38, y = 5619.56, z = 53.87 },
		},

    Armories = {
      { x = 2229.25, y = 5605.48, z = 53.87 },
    },

		Vehicles = {
			{
				Spawner    = { x = 2198.88, y = 5613.87, z = 52.69 },
				SpawnPoints = {
					{ x = 2198.88, y = 5613.87, z = 52.69, heading = 145.13, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = 2201.67, y = 5615.33, z = 52.83 },
		},

		BossActions = {
			{ x = 2198.88, y = 5613.87, z = 52.69 },
		},
		
	},
	
	


-- ballas2 = { --Penthouse
--  
--		Blip = {
--	},
--
--
--	-- https://wiki.rage.mp/index.php?title=WEAPONs
--AuthorizedWeapons = {
--
--},
--
--	Cloakrooms = {
--		{ x = -276.62, y = -745.62, z = 124.05 },
--	},
--
--Armories = {
--  { x = -284.47, y = -735.24, z = 124.05 },
--},
--
--	Vehicles = {
--		{
--			Spawner    = { x = -66.51, y = -811.14, z = 35.45 },
--			SpawnPoints = {
--				{ x = -82.53, y = -812.17, z = 36.27, heading = 343.35, radius = 6.0 },
--			},
--		},
--	},
--
--	Helicopters = {
--	},
--
--	VehicleDeleters = {
--		{x = -97.09, y = -805.28, z = 35.45 },
--	},
--
--	BossActions = {
--		{x = -273.75, y = -732.6, z = 127.27 },
--	},
--},




}

Config.ballasConfig.AuthorizedVehicles = {
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

Config.ballasConfig.Uniforms = {
	soldato_wear = {
        male = {
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 27,    ['chain_2'] = 2
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
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 27,    ['chain_2'] = 2
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
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 27,    ['chain_2'] = 2
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
			['tshirt_1'] = 33,  ['tshirt_2'] = 0,
			['torso_1'] = 10,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 33,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 27,    ['chain_2'] = 2
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
		},
	},
	bullet_wear = {
		male = {
			['bproof_1'] = 11,  ['bproof_2'] = 1
		},
		female = {
			['bproof_1'] = 13,  ['bproof_2'] = 1
		},
	},
	gilet_wear = {
		male = {
			['tshirt_1'] = 22,  ['tshirt_2'] = 4,
			['torso_1'] = 11,   ['torso_2'] = 1,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 1,
			['pants_1'] = 28,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 11,    ['chain_2'] = 2
		},
		female = {
			['tshirt_1'] = 36,  ['tshirt_2'] = 1
		},
	},

}