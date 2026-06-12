function LoadHunting()
    local self = {}

    self.validHuntingZones = {
        -- Legal
        {loc = vector3(-1370.72, 4444.52, 26.96),  radius = 400.0, filter = {"deerbait", "boarbait", "rabbitbait"},   onMap = true, sprite = 141, color = 0,  rcolor = 0,  name = "Caça"}, -- veado, javali, coelho
        -- Ilegal
        {loc = vector3(2046.64,  3428.10, 44.11),  radius = 200.0, filter = {"deer_carcass", "rabbit_carcass"},       onMap = false, sprite = 141, color = 0,  rcolor = 0,  name = "Caça"}, -- Caça Ilegal Sandy  Shores -- Lion, coyote
        {loc = vector3(5275.11, -5691.47, 29.87),  radius = 150.0, filter = {"boar_carcass"},                         onMap = false, sprite = 141, color = 0,  rcolor = 0,  name = "Caça"}, -- Caça Ilegal Cayo Perico
        -- Caça Lendaria

      --  {loc = vector3(-4714.05, 8115.78, 65.55), radius = 800.0, filter = {"rabbit_leg"},                            onMap = true, sprite = 774, color = 0,  rcolor = 0,  name = "Caça Lendária"},
    }    

    self.huntingAnimals = {
        ["deerbait"] = {
            model = `Reindeer`,
            health = 400,
            useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            baitTime = 15000, -- 15 segundos para enterrar isca
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = false,
            skinItems = {
                {item = "deer_skin",    quantity = {min = 1, max = 3},  chance = 1.0},
                {item = "deer_meat",    quantity = {min = 1, max = 2},  chance = 1.0},
                {item = "deer_carcass", quantity = {min = 1, max = 1},  chance = 0.6},
                {item = "deer_head",    quantity = {min = 1, max = 1},  chance = 0.4},
            },
        },
        ["boarbait"] = {
            model = `a_c_boar`,
            health = 600,
            useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            baitTime = 15000, -- 15 segundos para enterrar isca
           -- skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "boar_skin",       quantity = {min = 1, max = 3}, chance = 1.0},
                {item = "boar_meat",       quantity = {min = 1, max = 2}, chance = 1.0},
                {item = "boar_carcass",    quantity = {min = 1, max = 1}, chance = 0.6},
                {item = "boar_tooth",      quantity = {min = 1, max = 1}, chance = 0.4},
            },
        },
        ["rabbitbait"] = {
            model = `a_c_rabbit_01`,
            health = 200,
            useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            baitTime = 15000, -- 15 segundos para enterrar isca
           -- skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = false,
            skinItems = {
                {item = "rabbit_skin",       quantity = {min = 1, max = 3}, chance = 1.0},
                {item = "rabbit_meat",       quantity = {min = 1, max = 2}, chance = 1.0},
                {item = "rabbit_carcass",    quantity = {min = 1, max = 1}, chance = 0.8},
                {item = "rabbit_leg",        quantity = {min = 1, max = 1}, chance = 0.8},
            },
        },
        ["rabbit_carcass"] = {
            model = `a_c_coyote`,
            health = 200,
            --useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 15000, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "coyote_skin",       quantity = {min = 1, max = 2}, chance = 1.0},
                {item = "coyote_head",       quantity = {min = 1, max = 2}, chance = 0.4},
                {item = "coyote_carcass",    quantity = {min = 1, max = 1}, chance = 0.6},
            },
        },
        ["deer_carcass"] = {
            model = `a_c_mtlion`,
            health = 400,
            --useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 4800, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "lioness_skin",                  quantity = {min = 1, max = 1}, chance = 0.5},
                {item = "lioness_skin_lowquality",       quantity = {min = 1, max = 1}, chance = 1.0},
                {item = "lioness_paw",                   quantity = {min = 1, max = 2}, chance = 0.4},
                {item = "lioness_head",                  quantity = {min = 1, max = 1}, chance = 0.4},
            },
        },
        ["boar_carcass"] = {
            model = `FT_Tiger`,
            health = 600,
            --useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 4800, -- 15 segundos para enterrar isca
           -- skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "tiger_skin",                   quantity = {min = 1, max = 1}, chance = 0.5},
                {item = "tiger_skin_lowquality",        quantity = {min = 1, max = 1}, chance = 1.0},
                {item = "tiger_tooth",                  quantity = {min = 1, max = 2}, chance = 0.4},
                {item = "tiger_head",                   quantity = {min = 1, max = 1}, chance = 0.4},
            },
        },
        ["penguinbait"] = {
            model = `ft-penguin`,
            health = 200,
            useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            baitTime = 15000, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = false,
            skinItems = {    
                {item = "penguin_skin",                  quantity = {min = 1, max = 1}, chance = 0.5},
                {item = "penguin_skin_lowquality",       quantity = {min = 1, max = 1}, chance = 1.0},
                {item = "penguin_beak",                  quantity = {min = 1, max = 3}, chance = 0.4},
            },
        },
        ["antelopebait"] = {
            model = `ft-araboryx`,
            health = 800,
            useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            baitTime = 15000, -- 15 segundos para enterrar isca
           -- skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "antelope_skin",             quantity = {min = 1, max = 1}, chance = 0.5},
                {item = "antelope_skin_lowquality",  quantity = {min = 1, max = 1}, chance = 1.0},
                {item = "antelope_horns",            quantity = {min = 1, max = 2}, chance = 0.4},
            },
        },
        ["coyote_carcass"] = {
            model = `ft-pbear`,
            health = 800,
           -- useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 4800, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "bear_skin",               quantity = {min = 1, max = 1}, chance = 0.5},
                {item = "bear_skin_lowquality",    quantity = {min = 1, max = 1}, chance = 1.0},
                {item = "bear_paw",                quantity = {min = 1, max = 2}, chance = 0.4},
                {item = "bear_head",               quantity = {min = 1, max = 2}, chance = 0.4},
            },
        },
        ["sardine"] = {
            model = `popcornrparcticfox`,
            health = 300,
           -- useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 4800, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "articfox",               quantity = {min = 1, max = 1}, chance = 1},
            },
        },
        --[[["rabbit_leg"] = {
            model = `redfoxprp`,
            health = 300,
           -- useBaitScenario = "WORLD_HUMAN_GARDENER_PLANT",
            useBaitAnim = "plant_bomb_b",
            useBaitDict = "missfbi_s4mop",
            baitTime = 4800, -- 15 segundos para enterrar isca
          --  skinAnimScenario = "WORLD_HUMAN_GARDENER_PLANT",
            skinAnim = "base",
            skinAnimDict = "amb@medic@standing@kneel@base",
            skinTime = 15000, -- 15 segundos para esfolar
            attacksPlayer = true,
            skinItems = {
                {item = "redfox",               quantity = {min = 1, max = 1}, chance = 1},
            },
        },]]
    }

    self.baitDistanceInUnits = 30.0

    return self
end