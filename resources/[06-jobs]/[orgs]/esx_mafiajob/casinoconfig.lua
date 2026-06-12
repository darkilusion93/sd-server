Config.casinoConfig                            = {}

Config.casinoConfig.DrawDistance               = 30.0
Config.casinoConfig.MarkerType                 = 1
Config.casinoConfig.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.casinoConfig.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.casinoConfig.EnablePlayerManagement     = true
Config.casinoConfig.EnableArmoryManagement     = true
Config.casinoConfig.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.casinoConfig.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.casinoConfig.EnableSocietyOwnedVehicles = true
Config.casinoConfig.EnableLicenses             = false -- enable if you're using esx_license

Config.casinoConfig.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.casinoConfig.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.casinoConfig.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.casinoConfig.MaxInService               = -1
Config.casinoConfig.Locale                     = 'br'

Config.casinoConfig.Stations = {

	--  vski = {  -- ESC ECLIPSE
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
	--		{ x = -720.94, y = 270.66, z = 83.65 },
	--	},
	--
    --Armories = {
    --  --{ x = -330.01, y = 513.4, z = 119.16 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = -696.94, y = 315.61, z = 82.03 },
	--			SpawnPoints = {
	--				{ x = -697.62, y = 309.73, z = 82.95, heading = 170.00, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{ x = -700.82, y = 315.88, z = 82.05 },
	--	},
	--
	--	BossActions = {
	--		{x = -717.96, y = 261.05, z = 83.14 },
	--	},
	--},

	vski2 = {  -- ESC ECLIPSE
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			{ x = -930.75, y = -2048.0, z = 8.4 },
			{ x = 963.83, y = 26.35, z = 70.46 },
		},

    Armories = {
      { x = -937.84, y = -2036.71, z = 8.4 },
    },

		Vehicles = {
			{
				Spawner    = { x = -971.85, y = -2058.74, z = 8.51 },
				SpawnPoints = {
					{ x = -981.72, y = -2059.38, z = 8.41, heading = 222.00, radius = 6.0 },
				},
			},
		},

		Helicopters = {
		},

		VehicleDeleters = {
			{ x = -985.04, y = -2055.66, z = 8.41 },
		},

		BossActions = {
			{x = -717.96, y = 261.05, z = 83.14 },
		},
	},
	
	--casinio = { --Casino
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
	--		{ x = 961.68, y = -2.7, z = 70.84 },
	--	},
	--
    --Armories = {
    --  { x = 954.65, y = 1.48, z = 70.84 },
    --},
	--
	--	Vehicles = {
	--		{
	--			Spawner    = { x = 942.02, y = 40.26, z = 80.16 },
	--			SpawnPoints = {
	--				{ x = 947.13, y = 27.67, z = 80.16, heading = 229.53, radius = 6.0 },
	--			},
	--		},
	--	},
	--
	--	Helicopters = {
	--	},
	--
	--	VehicleDeleters = {
	--		{x = 948.77, y = 35.02, z = 80.16 },
	--	},
	--
	--	BossActions = {
	--		{x = 974.35, y = 7.07, z = 70.84 },
	--	},
	--},	
	
}

Config.casinoConfig.AuthorizedVehicles = {
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

Config.casinoConfig.Uniforms = {
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