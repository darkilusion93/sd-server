Config                            = {}

Config.DrawDistance               = 30.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = true
Config.EnableLicenses             = true -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.MaxInService               = -1
Config.Locale                     = 'br'

Config.GaragensCayo = {
	{ x = 4984.13, y = -5150.22, z = 1.51, h = 182.38 },
	{ x = 5143.77, y = -5145.26, z = 1.21, h = 273.38 },
	{ x = 5198.78, y = -5005.86, z = 13.19, h = 218.68 },
	{ x = 5334.06, y = -5264.0, z = 31.69, h = 52.55 },
	{ x = 5477.41, y = -5834.52, z = 18.55, h = 5.18 },
	{ x = 4899.59, y = -5461.09, z = 29.66, h = 192.18 },
	{ x = 4890.33, y = -5736.49, z = 25.35, h = 158.75 },
}

Config.CorCayo = {
	["purple"] = 1, --PRETO **
	["gang"] =  110, -- BEJE
	["ballas"] = 145, --ROXO
	["grove"] = 126, -- AMARELO
	["party"] = 138, -- LARANAJA
	["snake"] = 24, -- BRANCO
	["cartel"] = 137, -- ROSA
	["mafia"] = 90, -- CASTANHO 
	["mungiki"] = 10, -- CINZA
	["black"] = 27, --VERMELHO  *
	["tequilla"] = 55, -- VERDE CLARO
	["vagos"] = 73, -- AZUL ESCURO
	["docks"] = 74, -- AZUL CLARO
	["yakuza"] = 53, --VERDE ESCURO **
}
Config.Stations = {
  
	cartel = {
  
		Blip = {
		},


    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
		},

    Armories = {
    },

		Vehicles = {
		},

		Helicopters = {
		},

		VehicleDeleters = {
		},

		BossActions = {
		},
	}
}

Config.AuthorizedVehicles = {
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

Config.Uniforms = {
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

----

Config.Config = {}

Config.Config.DrawDistance               = 30.0
Config.Config.MarkerType                 = 1
Config.Config.MarkerSize                 = { x = 2.5, y = 2.5, z = 1.0 }
Config.Config.MarkerColor                = { r = 50, g = 50, b = 204 }

Config.Config.EnablePlayerManagement     = true
Config.Config.EnableArmoryManagement     = true
Config.Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.Config.EnableSocietyOwnedVehicles = true
Config.Config.EnableLicenses             = false -- enable if you're using esx_license

Config.Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.Config.HandcuffTimer              = 60 * 60000 -- 10 mins

Config.Config.EnableJobBlip              = false -- enable blips for colleagues, requires esx_society

Config.Config.MaxInService               = -1
Config.Config.Locale                     = 'br'


Config.Config.Stations = {
  
	cartel = {
  
		Blip = {
		},


		-- https://wiki.rage.mp/index.php?title=WEAPONs
    AuthorizedWeapons = {
    
    },

		Cloakrooms = {
			--{ x = -1509.45, y = 849.61, z = 180.54 },
		},

    Armories = {
      --{ x = -1499.78, y = 835.1, z = 177.7 },
    },

		Vehicles = {

		},

		Helicopters = {
		},

		VehicleDeleters = {
			--{x = -1545.93, y = 886.36, z = 180.34 },
		},

		BossActions = {
			--{x = -1525.29, y = 840.25, z = 180.55 },	
		},
	}
}

Config.Config.AuthorizedVehicles = {
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

Config.Config.Uniforms = {
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