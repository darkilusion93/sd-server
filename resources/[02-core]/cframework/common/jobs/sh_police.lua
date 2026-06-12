Config.Stations["police"] = {
    MaxMembers = -1,
    JobName = "&#128110; PSP",
    JobGrades = {
        ["0"] = {grade = 0, name = "recruit", label = "Recruta", salary = 1500, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "officer", label = "Agente", salary = 2000, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "sergeant", label = "Chefe", salary = 2500, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "lieutenant", label = "Sub-Intendente", salary = 3000, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "boss", label = "Intendente", salary = 3500, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Comandante", salary = 4500, skin_male = {}, skin_female = {}},
    },
    MobileAction = {
        {value = 'body_search'},
        {value = 'handcuff'},
        {value = 'drag'},
        {value = 'softcuff'},
        {value = 'uncuff'},
        {value = 'put_in_vehicle'},
        {value = 'out_the_vehicle'},
        {value = 'fine'},
        {value = 'billing', nome = 'Policia'},
        {value = 'unpaid_bills'},
        {value = 'vehicle_infos'},
        {value = 'hijack_vehicle'},
        {value = 'del_vehicle'},
        {value = 'give_license', nome = 'weapon'}, --weapon, pesca
        {value = 'take_license', nome = 'weapon'},
        {value = 'license'},
        {value = 'put_bracelet', minGrade = 9},
        {value = 'take_bracelet', minGrade = 9},
    },
    CanBossCreateRaces = false,
    BuyMenu = {
        { name = 'WEAPON_PUMPSHOTGUN',      price =   15000 },
        { name = 'WEAPON_PUMPSHOTGUN_MK2',  price =   17000 },
        { name = 'WEAPON_COMBATSHOTGUN',    price =   20000 },
        { name = 'WEAPON_SMG',              price =   30000 },
        { name = 'WEAPON_SMG_MK2',          price =   32000 },
        { name = 'WEAPON_CARBINERIFLE',     price =   35000 },
        { name = 'WEAPON_CARBINERIFLE_MK2', price =   37000 },
        { name = 'WEAPON_TACTICALRIFLE',    price =   40000 },
        { name = 'WEAPON_DD16_B',           price =   40000 },
        { name = 'WEAPON_DD16_OD',          price =   40000 },
        { name = 'WEAPON_DD16_C',           price =   40000 },
        { name = 'WEAPON_SNIPERRIFLE',      price = 1000000 },
        { name = 'clip12',                  price =     500 },
        { name = 'combatpistol_clip',       price =     700 },
        { name = 'smg_clip',                price =     900 },
        { name = 'tactical_clip',           price =    1100 },
        { name = 'carbinerifle_clip',       price =    1100 },
        { name = 'clip762',                 price =    1300 },
        { name = 'armor2',                  price =     300 },
        { name = 'barrier',                 price =      10 },
        { name = 'nightvision_goggles',     price =     500 },
        { name = 'clip_rubber',             price =     500 },
        { name = 'WEAPON_RUBBERSHOTGUN',    price =   27000 },
    },
    AuthorizedCrafts = {},
    Duty = {
        { x = -1123.8540, y = -827.7534, z = 3.8707 },
    },

    Cloakrooms = {
        { x = -1141.3916, y = -809.8867, z = 3.8706}, -- Los Santos
    },

    Armories = {
		{ x = -1137.4287, y = -819.2418, z = 3.8707 }, -- Los Santos
    },
    Special = {},
    Vehicles = {
        {
            Spawner    = { x = -1110.5875, y = -828.7025, z = 3.8706 },  -- Los Santos
            SpawnPoint = { x = -1102.7318, y = -816.5353, z = 3.8706 },
            Heading    = 196.2406,
        },
        {
            Spawner    = { x = -1103.6079, y = -837.0062, z = 3.8706 },  -- Los Santos
            SpawnPoint = { x = -1102.7318, y = -816.5353, z = 3.8706 },
            Heading    = 196.2406,
        },
    },
    Helicopters = {},
    Boats = {},
    VehicleDeleters = {
        { x = -1093.8353, y = -808.5463, z = 3.8706 },     -- Los Santos heli
    },
    CanBossAddCars = false,
    BossActions = {
        { x =  -1074.5985, y = -821.8002, z = 18.3287 },     -- Los Santos
    },
    Doors = {},

    Uniforms = {
        recruit = {
            label = "Policia Recruta",
            male = {
                ['tshirt_1'] =  72,      ['tshirt_2'] = 3,
                ['torso_1' ] = 420,      ['torso_2' ] = 0,
                ['arms'    ] =   4,
                ['pants_1' ] = 46,      ['pants_2' ] = 0,-- calças
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,--  botas
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   6,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = -1,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  0,      ['bproof_2'] = 0, -- colete
            },
            female = {
			    ['tshirt_1'] = 71,  ['tshirt_2'] = 1,
			    ['torso_1'] = 456,   ['torso_2'] = 0,
			    ['arms'] = 6,
			    ['pants_1'] = 143,   ['pants_2'] = 1,
			    ['shoes_1'] = 25,   ['shoes_2'] = 0,
			    ['bproof_1'] = 0,  ['bproof_2'] = 0,
			    ['chain_1'] = 6,    ['chain_2'] = 0,
			    ['helmet_1'] = -1,  ['helmet_2'] = 0
            }
        },
        s2_wear = {
            label = "Police Sargentos Curta",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 550,      ['torso_2' ] = 0,
                ['arms'    ] =   0,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 591,      ['torso_2' ] = 0,
                ['arms'    ] =  14,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s3_wear = {
            label = "Police Praças Curta",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 550,      ['torso_2' ] = 0,
                ['arms'    ] =   0,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 222,      ['helmet_2'] = 2, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 591,      ['torso_2' ] = 0,
                ['arms'    ] =  14,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 220,      ['helmet_2'] = 3, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s4_wear = {
            label = "Police Oficiais Longa",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 548,      ['torso_2' ] = 6,
                ['arms'    ] =   1,
                ['pants_1' ] = 205,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 589,      ['torso_2' ] = 6,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s5_wear = {
            label = "Police Sargentos Longa",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 548,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 589,      ['torso_2' ] = 0,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s6_wear = {
            label = "Police Praças Longa",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 548,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 222,      ['helmet_2'] = 2, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 589,      ['torso_2' ] = 0,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 220,      ['helmet_2'] = 3, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s7_wear = {
            label = "Police Oficiais Longa2",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 549,      ['torso_2' ] = 6,
                ['arms'    ] =   1,
                ['pants_1' ] = 205,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 590,      ['torso_2' ] = 6,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s8_wear = {
            label = "Police Sargentos Longa2",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 549,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 590,      ['torso_2' ] = 0,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s9_wear = {
            label = "Police Praças Longa2",
            male = {
                ['tshirt_1'] =  40,      ['tshirt_2'] = 1,
                ['torso_1' ] = 549,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 222,      ['helmet_2'] = 2, -- capacete
                ['bproof_1'] =  74,      ['bproof_2'] = 1, -- colete
            },
            female = {
                ['tshirt_1'] =  38,      ['tshirt_2'] = 1,
                ['torso_1' ] = 590,      ['torso_2' ] = 0,
                ['arms'    ] =   3,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 220,      ['helmet_2'] = 3, -- capacete
                ['bproof_1'] =  66,      ['bproof_2'] = 1, -- colete
            }
        },
        s10_wear = {
            label = "Police Oficiais Casaco",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] = 286,      ['tshirt_2'] = 1,
                ['torso_1' ] = 600,      ['torso_2' ] = 0,
                ['arms'    ] =  14,
                ['pants_1' ] = 218,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
        s11_wear = {
            label = "Police Sargentos Casaco",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] = 286,      ['tshirt_2'] = 1,
                ['torso_1' ] = 600,      ['torso_2' ] = 0,
                ['arms'    ] =  14,
                ['pants_1' ] = 218,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
        s12_wear = {
            label = "Police Praças Casaco",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 222,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] = 286,      ['tshirt_2'] = 1,
                ['torso_1' ] = 600,      ['torso_2' ] = 0,
                ['arms'    ] =  14,
                ['pants_1' ] = 218,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 220,      ['helmet_2'] = 2, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
        s13_wear = {  
            label = "Police Oficiais Casaco2",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
        },
        s14_wear = {
            label = "Police Sargentos Casaco2",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 221,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
        },
        s15_wear = {
            label = "Police Praças Casaco2",
            male = {
                ['tshirt_1'] = 235,      ['tshirt_2'] = 1,
                ['torso_1' ] = 559,      ['torso_2' ] = 0,
                ['arms'    ] =   1,
                ['pants_1' ] = 202,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] = 222,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
        },
        s16_wear = {
            label = "Police Bike1",
            male = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 550,      ['torso_2' ] = 7,
                ['arms'    ] =   1,
                ['pants_1' ] = 203,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  86,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 591,      ['torso_2' ] = 7,
                ['arms'    ] =  14,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  -1,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
        s17_wear = {
            label = "Police Bike2",
            male = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 550,      ['torso_2' ] = 7,
                ['arms'    ] =   1,
                ['pants_1' ] = 203,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  86,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 591,      ['torso_2' ] = 7,
                ['arms'    ] =  14,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  -1,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
        s18_wear = {
            label = "Police Bike3",
            male = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 550,      ['torso_2' ] = 7,
                ['arms'    ] =   1,
                ['pants_1' ] = 203,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['bags_1'  ] =   0,      ['bags_2'  ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  86,      ['helmet_2'] = 0, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            },
            female = {
                ['tshirt_1'] =  15,      ['tshirt_2'] = 0,
                ['torso_1' ] = 591,      ['torso_2' ] = 7,
                ['arms'    ] =  14,
                ['pants_1' ] = 217,      ['pants_2' ] = 0,
                ['shoes_1' ] =  25,      ['shoes_2' ] = 0,
                ['chain_1' ] =   0,      ['chain_2' ] = 0, -- acessorio
                ['helmet_1'] =  -1,      ['helmet_2'] = 1, -- capacete
                ['bproof_1'] =   0,      ['bproof_2'] = 0, -- colete
            }
        },
    }
}

Config.Stations["offpolice"] = {
    MaxMembers = -1,
    JobName = "&#128110; PSP (Fora de Serviço)",
    JobGrades = {
        ["0"] = {grade = 0, name = "recruit", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "officer", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "sergeant", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "lieutenant", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "boss", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
    },
    MobileAction = {},
    Cloakrooms = {},
    Armories = {},
    Special = {},
    Vehicles = {},
    Helicopters = {},
    VehicleDeleters = {},
    BossActions = {}
}