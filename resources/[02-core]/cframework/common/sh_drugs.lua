function LoadDrugs()
    local self = {}

    self.harvestAmounts = {
        withScissorAndFertilizer = {min = 3, max = 5},
        withFertilizer = {min = 3, max = 4},
        without = {min = 2, max = 3},
    }

    self.harvestableDrugs = {
        ["weed"] =      {seedItem = 'weed_seed',    harvestedItem = 'weed_untrimmed',    fertilizerItem = "fertilizer", scissorsItem = "scissors", plantObject = `prop_weed_01` },
        ["coke"] =      {seedItem = 'coke_seed',    harvestedItem = 'coke_uncut',        fertilizerItem = "fertilizer", scissorsItem = "scissors", plantObject = `h4_prop_bush_cocaplant_01` },
        ["hashish"] =   {seedItem = 'hashish_seed', harvestedItem = 'hashish_untrimmed', fertilizerItem = "fertilizer", scissorsItem = "scissors", plantObject = `prop_weed_01` },
        ["poppy"] =     {seedItem = 'poppy_seed',   harvestedItem = 'poppy_head',        fertilizerItem = "fertilizer", scissorsItem = "scissors", plantObject = `h4_prop_bush_bgnvla_sml_01` },
    }

    self.harvest = {
        {x = -2274.07,     y = 7367.02,      z = 32.77,  w = 50.0, r = 200.0, type =  'weed',       onMap = false, sprite = 469, color = 2,  rcolor = 1,  name = 'Plantação de Erva'},
        {x =  -1671.61,    y = 8077.96,      z = 44.51,  w = 50.0, r = 200.0, type =  'hashish',    onMap = false, sprite = 469, color = 25, rcolor = 1,  name = 'Plantação de Haxixe'},
        {x =  1477.09,     y = 6353.14,      z = 23.78,  w = 35.0, r = 100.0, type =  'coke',       onMap = false, sprite = 501, color = 0,  rcolor = 1,  name = 'Plantação de Coca'},
        {x =  5341.34,     y = -5250.60,     z = 32.43,  w = 35.0, r = 100.0, type =  'poppy',      onMap = false, sprite = 501, color = 0,  rcolor = 1,  name = 'Plantação de Papoila'},
    }

    self.processableDrugs = {
        ["lsd"] = {
            jobs = {"none"},
            needs = {
                {name = 'lisergicacid',   count = 1, consume = true},
                {name = 'paper',         count = 1, consume = true},
            },
            result = {
                {name = 'lsd', count = 1},
            }
        },
        ["meth"] = {
            jobs = {"none"},
            needs = {
                {name = 'acetone_bottle',   count = 1, consume = true},
                {name = 'efedrina',         count = 1, consume = true},
                {name = 'battery',          count = 1, consume = false},
            },
            result = {
                {name = 'meth', count = 2},
            }
        },
        ["coke"] = {
            jobs = {"none"},
            needs = {
                {name = 'coke_uncut',   count = 1, consume = true},
            },
            result = {
                {name = 'coke', count = 2},
            }
        },
        ["crack"] = {
            jobs = {"none"},
            needs = {
                {name = 'coke',                 count = 1, consume = true},
                {name = 'sodiumbicarbonate',    count = 1, consume = true},
            },
            result = {
                {name = 'crack', count = 2},
            }
        },
        ["hashish"] = {
            jobs = {"none"},
            needs = {
                {name = 'hashish_untrimmed',    count = 2, consume = true},
                {name = 'ice',                  count = 1, consume = true},
                {name = 'jar',                  count = 1, consume = false},
            },
            result = {
                {name = 'hashish', count = 5},
            }
        },
        ["weed"] = {
            jobs = {"none"},
            needs = {
                {name = 'weed_untrimmed',   count = 3, consume = true},
            },
            result = {
                {name = 'weed', count = 5},
            }
        },
        ["opium"] = {
            jobs = {"none"},
            needs = {
                {name = 'poppy_head',   count = 3, consume = true},
            },
            result = {
                {name = 'opium', count = 5},
            }
        },
    }

    self.processing = {
        {x = -2207.17,    y = 7431.97,   z =  36.23,   r = 50.0, type = 'weed',     onMap = false, sprite = 0,   rcolor = 1, color = 0,  name = 'Processo de Erva'},
        {x = -1663.66,    y = 8059.78,   z =  43.74,   r = 50.0, type = 'hashish',  onMap = false, sprite = 0,   rcolor = 1, color = 0,  name = 'Processo de Haxixe'},
        {x = 1504.67,     y = 6325.06,   z =  23.17,   r = 50.0, type = 'coke',     onMap = false, sprite = 0,   rcolor = 1, color = 0,  name = 'Processo de Coca'},
        --{x = 5559.10,     y = -5345.33,  z = 23.51,   r = 50.0, type = 'crack',    onMap = false, sprite = 0,   rcolor = 1, color = 0,  name = 'Processo de Crack'},
        {x = -1571.33,    y = -3224.21,  z = 25.34,   r = 50.0, type = 'lsd',      onMap = false, sprite = 403, rcolor = 1, color = 19, name = 'Processo de LSD'},
        {x =  2442.7,     y = 4975.14,   z = 45.81,   r = 80.0, type = 'meth',     onMap = false, sprite = 499, rcolor = 1, color = 38, name = 'Processo de Meth'},
        {x =  5214.52,    y = -5128.06,  z = 5.23,    r = 80.0, type = 'opium',    onMap = false, sprite = 499, rcolor = 1, color = 38, name = 'Processo de Opio'},
    }

    self.pedSelling = {
        ["comunidadeze"] = {
            minCops = 1,
            locations = {
                {x = 5297.51,  y = -5094.85,  z = 15.19, h = 180.86, model =   'a_m_y_methhead_01',    scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5314.95,  y = -5094.09,  z = 15.57, h = 172.33, model =   'a_m_y_jetski_01',      scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5368.06,  y = -5101.29,  z = 11.78, h = 161.99, model =   'ig_fabien',            scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5408.23,  y = -5111.64,  z = 15.21, h = 158.44, model =   'a_m_o_acult_02',       scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5442.90,  y = -5123.31,  z = 15.48, h = 138.39, model =   'a_m_y_methhead_01',    scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5476.17,  y = -5139.52,  z = 14.97, h = 146.22, model =   'a_m_y_jetski_01',      scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5505.66,  y = -5149.70,  z = 14.09, h = 139.57, model =   'ig_fabien',            scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5523.51,  y = -5194.21,  z = 16.00, h = 104.69, model =   'a_m_o_acult_02',       scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5525.94,  y = -5203.23,  z = 16.31, h =  99.22, model =   'a_m_y_methhead_01',    scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5322.24,  y = -5113.73,  z = 16.04, h = 354.87, model =   'a_m_y_jetski_01',      scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5357.54,  y = -5120.59,  z = 15.21, h = 345.74, model =   'ig_fabien',            scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5388.02,  y = -5126.42,  z = 14.85, h = 351.63, model =   'a_m_o_acult_02',       scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5418.19,  y = -5136.19,  z = 15.41, h = 336.73, model =   'a_m_y_methhead_01',    scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = 5468.85,  y = -5162.78,  z = 15.21, h = 332.53, model =   'a_m_y_jetski_01',      scenario = "WORLD_HUMAN_SMOKING_POT"},
            },
            items = {
                {name = 'meth_pooch',       count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4'}},
                {name = 'opium_bag',        count = 10, price = 400, jobPrice = 500, cash = "black_money", jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4'}},
                {name = 'weed_pooch_new',   count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4'}},
                {name = 'hashish_pooch',    count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4'}},
                {name = 'coke_pooch_new',   count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {'familia1', 'familia2', 'familia3', 'familia4', 'familia5', 'familia6'}},
                {name = 'crack_pooch',      count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {'cpx1', 'cpx2', 'cpx3', 'cpx4', 'cpx5', 'cpx6'}},
                {name = "lsd_pooch",        count = 10, price = 350, jobPrice = 400, cash = "black_money", jobs = {}},
            }
        },
        ["pier"] = {
            minCops = 0,
            locations = {
                {x = -1621.24,  y = -1080.70,  z = 13.02, h = 355.72,  model =   'g_m_y_ballasout_01',    scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = -1619.57,  y = -1080.52,  z = 13.02, h =  50.98,  model =   'g_f_y_ballas_01',       scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = -1620.18,  y = -1051.18,  z = 13.15, h =  192.42, model =   'a_m_o_beach_01',        scenario = "WORLD_HUMAN_SMOKING_POT"},
                {x = -1609.11,  y = -1064.28,  z = 13.02, h =  71.12,  model =   'a_m_y_beach_01',        scenario = "WORLD_HUMAN_SMOKING_POT"},
            },
            items = {
                {name = 'meth_pooch',       count = 10, price = 200, jobPrice = 250, cash = "black_money", jobs = {'squad1', 'squad2', 'squad3', 'squad4', 'squad5', 'squad6', 'squad7', 'squad8', 'squad9', 'squad10', 'squad11', 'squad12', 'ilegal4'}},
            }
        },
    }

    self.dealerSelling = {
        ["vendasecundaria"] = {
            jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4", "cpx1", "cpx2", "cpx3", "cpx4", "cpx5", "cpx6"},
            msg = "brincadeira tem hora",
            minCops = 3,
            cooldown = 3600,  -- 1 hora
            enableInfluence = true,
            influenceVariation = 1,
            influenceMsg = "quem tem influencia na secundaria?",
            locations = {
                {x =  -418.09,    y =  1150.38,    z = 326.87, h = 0.0, model = 'a_m_m_og_boss_01'},
                {x =   846.31,    y =   2136.49,   z =  52.86, h = 0.0, model = 'a_m_m_og_boss_01'},
            },
            items = {
                {name = 'opium_bag',        count = 2, price = 550, influenceCount = 2, influencePrice = 650, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4"}},
                {name = 'weed_pooch_new',   count = 2, price = 450, influenceCount = 2, influencePrice = 550, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4"}},
                {name = 'hashish_pooch',    count = 2, price = 450, influenceCount = 2, influencePrice = 550, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4"}},
                {name = 'crack_pooch',      count = 2, price = 500, influenceCount = 2, influencePrice = 600, cash = "black_money", jobs = {"cpx1", "cpx2", "cpx3", "cpx4", "cpx5", "cpx6"}},
            }
        },

        ["vendaprimaria"] = {
            jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4", "familia1", "familia2", "familia3", "familia4", "familia5", "familia6","kiwi","cpx1", "cpx2", "cpx3", "cpx4", "cpx5", "cpx6"},
            msg = "tenho material para ti",
            minCops = 5,
            cooldown = 3600,  -- 1 hora
            enableInfluence = true,
            influenceVariation = 1,
            influenceMsg = "quem tem influencia na primaria?",
            locations = {
                {x =  2789.75,    y =  -750.14,    z = 8.34, h = 85.04, model = 'a_m_m_og_boss_01'},
                {x = -5779.12,    y =  7614.23,    z = 49.51, h = 153.20, model = 'a_m_m_og_boss_01'},
            },
            items = {
                {name = 'opium_bag',        count = 2, price = 800, influenceCount = 2, influencePrice = 950, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4","familia1", "familia2", "familia3", "familia4", "familia5", "familia6","kiwi","cpx1", "cpx2", "cpx3", "cpx4", "cpx5", "cpx6"}},
                {name = 'weed_pooch_new',   count = 2, price = 600, influenceCount = 2, influencePrice = 750, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4"}},
                {name = 'hashish_pooch',    count = 2, price = 600, influenceCount = 2, influencePrice = 750, cash = "black_money", jobs = {"squad1", "squad2", "squad3", "squad4", "squad5", "squad6", "squad7", "squad8", "squad9", "squad10", "squad11", "squad12", "ilegal4"}},
                {name = 'coke_pooch_new',   count = 2, price = 700, influenceCount = 2, influencePrice = 850, cash = "black_money", jobs = {"familia1", "familia2", "familia3", "familia4", "familia5", "familia6","kiwi"}},
                {name = 'crack_pooch',      count = 2, price = 700, influenceCount = 2, influencePrice = 850, cash = "black_money", jobs = {"cpx1", "cpx2", "cpx3", "cpx4", "cpx5", "cpx6"}},
            }
        },
    }

    return self
end
