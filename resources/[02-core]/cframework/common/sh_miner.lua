function LoadMiner()
    local self = {}

    self.legalMineResources = {
        {name = 'iron_ore',     chance = 40},
        {name = 'copper_ore',   chance = 40},
        {name = 'coal_ore',     chance = 10},
        {name = 'lithium_ore',  chance = 10},
    }

    self.ilegalMineResources = {
        {name = 'gold_ore',     chance = 40},
        {name = 'platinum_ore', chance = 39},
        {name = 'tin_ore',      chance = 10},
        {name = 'rhodium_ore',  chance = 5},
        {name = 'raw_emerald',  chance = 2},
        {name = 'raw_diamond',  chance = 2},
        {name = 'raw_ruby',     chance = 2},
    }

    self.oreMaceration = {
        ["iron_ore"] = {
            inputItem = 'iron_ore',
            inputCount = 1,
            outputItem = 'crushed_iron_ore',
            outputCount = 2
        },
    }

    self.oreWashing = {
        ["iron"] = {
            crushedOreItem = 'crushed_iron_ore',
            crushedOreCount = 1,
            purifiedOreItem = 'purified_crushed_iron_ore',
            purifiedOreCount = 1,
            nuggetItem = 'iron_nugget',
            nuggetCount = 2,
            dustItem = 'boulder_dust',
            dustCount = 1,
            washSpeed = 1000,
        },
    }

    self.materialCentrifuge = {
        ["iron"] = {
            inputItem = 'purified_crushed_iron_ore',
            inputCount = 1,
            outputItem1 = 'iron_dust',
            outputItem1Count = 1,
            outputItem2 = 'gold_nugget',
            outputItem2Count = 2,
        },
    }

    self.metalRemelting = {
        ["copper"] = {
            inputItem = 'copper_nugget',
            inputCount = 1,
            outputItem = 'copper',
            outputCount = 1
        },
        ["iron"] = {
            inputItem = 'iron_nugget',
            inputCount = 1,
            outputItem = 'iron',
            outputCount = 1
        },
        ["gold"] = {
            inputItem = 'gold_nugget',
            inputCount = 5,
            outputItem = 'gold_ingot',
            outputCount = 1
        },
    }

    self.miningLocations = {
        vector3(2924.14, 2792.5, 40.61),
        vector3(2926.69, 2788.6, 39.99),
        vector3(2919.71, 2799.81, 41.28),
        vector3(2932.53, 2784.32, 39.31),
        vector3(2950.91, 2769.52, 39.0),
        vector3(2947.38, 2768.8, 38.98),
        vector3(2943.29, 2761.16, 41.85),
        vector3(2974.07, 2775.17, 38.2),
        vector3(2978.86, 2789.82, 40.54),
        vector3(2972.67, 2797.19, 41.15),
    }

    self.illegalMiningLocations = {
        vector3(-564.66, 1886.06, 123.04),
        vector3(-560.46, 1888.94, 123.04),
        vector3(-554.86, 1891.41, 123.04),
        vector3(-549.14, 1896.98, 123.06),
        vector3(-482.67, 1895.5,  119.79),
        vector3(-486.47, 1897.43, 120.03),
        vector3(-492.56, 1894.43, 120.37),
        vector3(-473.27, 2089.75, 120.07),
        vector3(-471.32, 2085.12, 120.12),
        vector3(-470.98, 2079.13, 120.31),
        vector3(-423.68, 2067.3,  120.02),
        vector3(-427.96, 2064.12, 120.61),
        vector3(-443.81, 2015.58, 123.55),
        vector3(-446.09, 2012.91, 123.57),
    }


    self.illegalProcessingLocation = {
        vector3(5379.40, -5387.56, 43.51),
        vector3(1561.34, -1692.93, 88.21),
    }

    self.cloakRoomLocation = {
        vector3(2953.14, 2741.38, 43.83),
        vector3(2745.53, 2788.61, 35.43),
        vector3(1054.79, -1952.72, 32.09),
    }

    self.washingLocation = {
        vector3(2673.43, 2792.14, 31.81),
    }

    self.macerationLocation = {
        vector3(2626.04, 2817.41, 32.67),
    }

    self.thermalCentrifugeLocation = {
        vector3(1115.04, -2003.85, 34.44),
    }

    self.remeltingLocation = {
        vector3(1109.03, -2007.61, 29.94),
    }

    self.sellLocation = {
      --  vector3(638.74, 2778.62, 40.99),
    }

    self.minerBlips = {
        { title="Refinaria",             colour = 17, id = 365, x = 1109.03, y = -2007.61, z = 30.94, scale = 0.5},
        { title="Lavagem de Minérios",   colour = 5,  id = 365, x = 2673.43, y =  2792.14, z = 32.81, scale = 0.5},
        { title="Maceração",             colour = 50, id =  58, x = 2626.04, y =  2817.41, z = 32.67, scale = 0.5},
        { title="Centrifugação Térmica", colour = 1,  id = 365, x = 1115.04, y = -2003.85, z = 34.44, scale = 0.5},
        { title="Mina",                  colour = 3,  id = 477, x = 2926.69, y =   2788.6, z = 39.99, scale = 0.7},
        { title="Vestuario Mineiro",     colour = 5,  id = 280, x = 2953.14, y =  2741.38, z = 43.83, scale = 0.5},
        { title="Vestuario Mineiro",     colour = 5,  id = 280, x = 2745.53, y =  2788.61, z = 35.43, scale = 0.5},
        { title="Vestuario Mineiro",     colour = 5,  id = 280, x = 1054.79, y = -1952.72, z = 32.09, scale = 0.5},
        { title="Venda de Minérios",     colour = 25, id = 500, x =   64.49, y = -1590.37, z = 29.60, scale = 0.8},
    }

    return self
end
