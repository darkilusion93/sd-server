function LoadFishing()
    local self = {}

    self.fishingLocations = {
    {x = 1824.81, y = 4230.62, z = -199.34, radius = 850.0,   -- LAGO 100%
        fishableFish = {
            { name = "carp",         chance =   40 },
            { name = "loss",         chance =   20 },
            { name = "tench",        chance =   20 },
            { name = "lucio",        chance =   10 },
            { name = "sea_plastic",  chance =  0.5 }, 
            { name = "rusty_scrap",  chance =  0.5 },
            { name = "old_coin1",    chance =    3 },
            { name = "old_coin2",    chance =    3 },
            { name = "old_coin3",    chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 489.81, y = 3925.62, z = 0.10, radius = 800.0,   -- LAGO 
        fishableFish = {
            { name = "carp",         chance =   40 },
            { name = "loss",         chance =   20 },
            { name = "tench",        chance =   20 },
            { name = "lucio",        chance =   10 },
            { name = "sea_plastic",  chance =  0.5 }, 
            { name = "rusty_scrap",  chance =  0.5 },
            { name = "old_coin1",    chance =    3 },
            { name = "old_coin2",    chance =    3 },
            { name = "old_coin3",    chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 1131.17, y = 3975.64, z = 0.10, radius = 40.0,   -- LAGO 
        fishableFish = {
            { name = "carp",         chance =   40 },
            { name = "loss",         chance =   20 },
            { name = "tench",        chance =   20 },
            { name = "lucio",        chance =   10 },
            { name = "sea_plastic",  chance =  0.5 }, 
            { name = "rusty_scrap",  chance =  0.5 },
            { name = "old_coin1",    chance =    3 },
            { name = "old_coin2",    chance =    3 },
            { name = "old_coin3",    chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },
    -------------------------------------------------------------------------------
    {x = -2204.67, y = 2594.65, z = 0.10, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -1601.25, y = 2661.75, z = 0.10, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -879.60, y = 2795.80, z = 0.10, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -251.00, y = 3006.20, z = 17.80, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -2552.60, y = 2574.17, z = 0.10, radius = 40.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -1738.35, y = 4492.30, z = 0.10, radius = 500.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -1382.50, y = 4299.50, z = 0.10, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -930.50, y = 4364.00, z = 0.10, radius = 800.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -470.50, y = 4421.30, z = 0.10, radius = 400.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -1825.14, y = 4596.17, z = 0.10, radius = 40.0,  -- RIO
        fishableFish = {
            { name = "trout",         chance =   36 },   
            { name = "barbel",        chance =   19 },
            { name = "eel",           chance =   16 },
            { name = "boga",          chance =   10 },
            { name = "salmon",        chance =    8 },
            { name = "sea_plastic",   chance =  0.5 },  
            { name = "rusty_scrap",   chance =  0.5 },
            { name = "old_coin1",     chance =    3 },
            { name = "old_coin2",     chance =    3 },
            { name = "old_coin3",     chance =    3 },
            { name = "packaged_drug", chance =    1 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },
    -------------------------------------------------------------------------------
    {x = -3679.99, y = 961.08, z = 0.10, radius = 1000.0,   -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },         
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -3679.99, y = 961.08, z = 0.10, radius = 40.0,   -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -2159.06, y = -1495.85, z = 0.10, radius = 1000.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -2159.06, y = -1495.85, z = 0.10, radius = 40.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 45.65, y = -3266.52, z = 0.10, radius = 1500.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -228.00, y = -3081.04, z = 0.10, radius = 40.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 4118.67, y = 4833.75, z = 0.10, radius = 40.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 4394.57, y = 4793.58, z = 0.10, radius = 1000.0,  -- MAR PEIXE
        fishableFish = {
            { name = "sardine",             chance =   24 },
            { name = "common_seahorse",     chance =   17 },
            { name = "mackerel",            chance =   15 },
            { name = "seabass",             chance =   12 },
            { name = "gilt_head_bream",     chance =    8 },
            { name = "tuna",                chance =    6 },
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },
    -------------------------------------------------------------------------------    
    {x = -186.38, y = 7223.35, z = -199.10, radius = 1300.0,  -- MAR ROXWOOD
        fishableFish = {
            { name = "sardine",             chance =   30 },
            { name = "baby_turtle",         chance =   24 },
            { name = "turtle",              chance =   17 },  
            { name = "rare_turtle",         chance =    7 },  
            { name = "legendary_turtle",    chance =    4 },   
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -1251.69, y = 6371.88, z = -199.10, radius = 1000.0,  -- MAR ROXWOOD
        fishableFish = {
            { name = "sardine",             chance =   30 },
            { name = "baby_turtle",         chance =   24 },
            { name = "turtle",              chance =   17 },  
            { name = "rare_turtle",         chance =    7 },  
            { name = "legendary_turtle",    chance =    4 },   
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -2013.79, y = 5872.41, z = -199.10, radius = 1300.0,  -- MAR ROXWOOD
        fishableFish = {
            { name = "sardine",             chance =   30 },
            { name = "baby_turtle",         chance =   24 },
            { name = "turtle",              chance =   17 },  
            { name = "rare_turtle",         chance =    7 },  
            { name = "legendary_turtle",    chance =    4 },   
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = -3064.73, y = 5573.43, z = -199.10, radius = 1500.0,  -- MAR ROXWOOD
        fishableFish = {
            { name = "sardine",             chance =   30 },
            { name = "baby_turtle",         chance =   24 },
            { name = "turtle",              chance =   17 },  
            { name = "rare_turtle",         chance =    7 },  
            { name = "legendary_turtle",    chance =    4 },   
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

     {x = -1407.18, y = 6025.52, z = -199.10, radius = 40.0,  -- MAR ROXWOOD
        fishableFish = {
            { name = "sardine",             chance =   30 },
            { name = "baby_turtle",         chance =   24 },
            { name = "turtle",              chance =   17 },  
            { name = "rare_turtle",         chance =    7 },  
            { name = "legendary_turtle",    chance =    4 },   
            { name = "sea_plastic",         chance =    2 },   
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },
    --------------------------------------------------------------------------------
    {x = 4673.79, y = -5040.43, z = -199.15, radius = 2000.0,  
        fishableFish = {
            { name = "sardine",             chance =   27 },
            { name = "sea_lion",            chance =   18 },    
            { name = "raja",                chance =   18 },
            { name = "dolphin",             chance =    6 }, 
            { name = "blue_shark",          chance =    4 },   
            { name = "hammerhead_shark",    chance =    4 }, 
            { name = "white_shark",         chance =    3 },
            { name = "whale",               chance =    2 },
            { name = "sea_plastic",         chance =    2 },  --   18
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = false, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },

    {x = 3859.79, y = -5366.83, z = -199.15, radius = 40.0,  
        fishableFish = {
            { name = "sardine",             chance =   27 },
            { name = "sea_lion",            chance =   18 },    
            { name = "raja",                chance =   18 },
            { name = "dolphin",             chance =    6 }, 
            { name = "blue_shark",          chance =    4 },   
            { name = "hammerhead_shark",    chance =    4 }, 
            { name = "white_shark",         chance =    3 }, 
            { name = "whale",               chance =    2 },
            { name = "sea_plastic",         chance =    2 },  --   18
            { name = "rusty_scrap",         chance =    2 },
            { name = "old_coin1",           chance =    3 },
            { name = "old_coin2",           chance =    3 },
            { name = "old_coin3",           chance =    3 },
            { name = "packaged_drug",       chance =    1 }, 
            { name = "rusty_weapons_crate", chance =    1 },
            { name = "mysterious_box",      chance =    3 },
        },
        onMap = true, sprite = 317, color = 18, rcolor = 12, name = "Zona de Pesca"
    },
}

    self.restaurantLocation = { --Restaurantes para vender peixe (job do centro de emprego ou job whitelist, pescarias)
       -- {x = -1497.58, y =  -225.55,  z = 51.32},
       -- {x = -1392.87, y =  -732.68,  z = 24.58},
       -- {x = -1342.58, y =  -871.88,  z = 16.86},
       -- {x = -1221.12, y = -1095.69,  z =  8.12},
       -- {x = -1271.81, y = -1200.72,  z =  5.37},
       -- {x = -1168.88, y = -1267.39,  z =   6.2},
       -- {x = -1038.36, y = -1397.06,  z =  5.55},
       -- {x = -1129.26, y = -1374.27,  z =  5.11},
       -- {x = -1182.19, y = -1410.87,  z =   4.5},
       -- {x =  -860.98, y = -1140.73,  z =  7.19},
       -- {x =  -638.66, y = -1249.55,  z = 11.81},
       -- {x =  -585.1,  y =  -872.01,  z = 25.83},
       -- {x =  -628.86, y =  -300.96,  z = 35.34},
       -- {x =  -659.12, y =  -814.42,  z = 24.54},
       -- {x =   127.83, y =  -1028.4,  z = 29.36},
       -- {x =   273.67, y =  -833.36,  z = 29.41},
       -- {x =   410.07, y = -1910.73,  z = 25.46},
       -- {x =    84.28, y = -1552.09,  z =  29.6},
       -- {x =   166.17, y = -1451.54,  z = 29.24},
       -- {x =    99.05, y = -1419.38,  z = 29.42},
       -- {x =   169.35, y = -1633.81,  z = 29.29},
       -- {x =  1179.97, y =   -394.6,  z = 68.01},
       -- {x =  1241.55, y =  -366.93,  z = 69.08},
       -- {x =  1138.93, y =  -962.57,  z = 47.53},
       -- {x =   793.88, y =  -735.74,  z = 27.96},
       -- {x =    12.63, y =  -1605.85, z = 29.4},
    }

    self.rentBoatLocation = {
       -- {x = -1604.54, y = 5256.66, z = 2.07,  jobs = {"anzol", "pescadores"}, spawn = vector4(-1591.24, 5258.63, -0.40, 29.24)},
       -- {x = -279.54,  y = 6634.03, z = 6.50,  jobs = {"vila", "medusa"}, spawn = vector4(-320.07, 6680.39, -0.50, 47.20)},
       -- {x = 3857.65,  y = 4459.03, z = 1.84,  jobs = {"navy", "tomate"}, spawn = vector4(3862.04, 4473.02, -0.10, 274.23)},
    }

    self.deleteBoatLocation = {
      --  {x = -1591.24, y = 5258.63, z = -0.10,  jobs = {"anzol", "pescadores"}},
      --  {x = 1333.83,  y = 4239.34, z = 29.20,  jobs = {"vila", "medusa"}     },
      --  {x = 3862.03,  y = 4473.01, z = -0.10,  jobs = {"navy", "tomate"}     },

        --Veiculos
      --  {x = 1577.41, y = 5160.56, z = 19.78,   jobs = {"anzol", "pescadores"}},
      --  {x = -219.84, y = 6519.56,  z = 10.09,  jobs = {"vila", "medusa"}     },
      --  {x = 3785.23, y = 4464.68, z = 6.04,    jobs = {"navy", "tomate"}     },
    }

    self.fishCanning = {
      --  {x = 997.09, y = -2187.81, z = 29.98},
    }

    self.fishingCloakroom = {
        {x = -1598.94, y = 5188.62, z = 4.35, jobs = {"anzol"}},
      --  {x = 1335.38,  y = 4306.76, z = 38.1, jobs = {"vila"}},
      --  {x = 3797.91,  y = 4478.37, z = 5.99, jobs = {"navy"}},
    }

    self.rentVehicleLocation = {
     --   {x = -1586.05, y = 5153.85, z = 19.67, jobs = {"anzol"}, spawn = vector4(-1577.41, 5160.56, 19.78, 186.3)},
     --   {x = -220.85,  y = 6524.98, z = 10.10, jobs = {"vila"},  spawn = vector4(-219.84, 6519.56, 11.09, 130.35)},
     --   {x = 3790.0,   y = 4463.61, z = 5.82,  jobs = {"navy"},  spawn = vector4(3785.23, 4464.68, 6.04, 86.5)   },
    }

    self.fishingShopJobs = {'pescadores', 'medusa', 'tomate'}
    self.fisherManJobs = {'anzol'}

    self.fishermanBoatPrice = 1500
    self.fishingShopBoatPrice = 500

    self.rentalBoatModel = `tug` -- Modelo do barco de aluguer

    self.fishermanVehicle = { -- Veiculos para alugar para os pescadores
        ["anzol"] = `mule`,
      --  ["vila"] = `mule222`,
      --  ["navy"] = `mule222`,
    }

    self.fishingSociety = { --Jobs para onde vai o dinheiro do aluguer dos barcos
       -- ['anzol'] = 'pescadores',
       -- ['vila'] = 'medusa',
       -- ['navy'] = 'tomate',
    }

    self.canning = { --Enlatamento de peixes
        ["sardine"] = {
            time = 1000,
            items_in = {
                {name = "sardine", count = 1}
            },
            items_out = {
                {name = "canned_sardine", count = 1},
            }
        },
        ["tuna"] = {
            time = 1000,
            items_in = {
                {name = "tuna", count = 1}
            },
            items_out = {
                {name = "canned_tuna", count = 1}
            }
        },
    }

    self.restaurantCooldown = 30 * (60) * 1000 -- 30 minutos para voltar a vender no restaurante

    self.fishSaleValue = {
       -- ["sardine"] = 100,
       -- ["tuna"] = 100,
       -- ["codfish"] = 150,
       -- ["salmon"] = 200,
       -- ["canned_sardine"] = 300,
       -- ["canned_tuna"] = 300,
    }

    self.fishermanSellPrices = {
      --  ["sardine"] = 100,
      --  ["tuna"] = 100,
      --  ["codfish"] = 150,
      --  ["salmon"] = 200,
      --  ["canned_sardine"] = 300,
      --  ["canned_tuna"] = 300,
    }

    self.fishTypes = {
        -- LAGO
        ['carp'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
            },
            bait = {
                ['bait1'] = true,
            },
        },
        ['loss'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
            },
            bait = {
                ['bait1'] = true,
            },
        },
        ['tench'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
            },
            bait = {
                ['bait1'] = true,
            },
        },
        ['lucio'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
            },
            bait = {
                ['bait1'] = true,
            },
        },
        ['sea_plastic'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
            },
        },
        ['rusty_scrap'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['old_coin1'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['old_coin2'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['old_coin3'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['packaged_drug'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['rusty_weapons_crate'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },
        ['mysterious_box'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['weakreel'] = true,
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['weaknylon'] = true,
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook1'] = true,
                ['hook2'] = true,
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,
            },
            bait = {
                ['bait1'] = true,
                ['bait2'] = true,
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
                ['hook5'] = true,
            },
        },

        -- RIO 
        ['trout'] = {    
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook2'] = true,
            },
            bait = {
                ['bait2'] = true,
            },
        },
        ['barbel'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook2'] = true,
            },
            bait = {
                ['bait2'] = true,
            },
        },
        ['eel'] = {
           rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook2'] = true,
            },
            bait = {
                ['bait2'] = true,
            },
        },
        ['boga'] = {
           rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook2'] = true,
            },
            bait = {
                ['bait2'] = true,
            },
        },
        ['salmon'] = {
           rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['mediumreel'] = true,
                ['strongreel'] = true,
            },
            nylon = {
                ['mediumnylon'] = true,
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook2'] = true,
            },
            bait = {
                ['bait2'] = true,
            },
        },

        -- MAR
        ['common_seahorse'] = {     
            rod = { 
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
            },
            bait = {
                ['bait3'] = true,
            },
        }, 

        ['sardine'] = {   
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
                ['hook4'] = true,
                ['hook5'] = true,  
            },
            bait = {
                ['bait3'] = true,
                ['bait4'] = true,
                ['turtle_meat'] = true,
            },
        },
        ['mackerel'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
            },
            bait = {
                ['bait3'] = true,
            },
        },
        ['seabass'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
            },
            bait = {
                ['bait3'] = true,
            },
        },
        ['gilt_head_bream'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
            },
            bait = {
                ['bait3'] = true,
            },
        },
        ['tuna'] = {
            rod = {
                ['magnumxlrod'] = true,
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook3'] = true,
            },
            bait = {
                ['bait3'] = true,
            },
        },

        -- ILEGAL MAR / RIO 
        ['turtle'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook4'] = true,
            },
            bait = {
                ['bait4'] = true,
            },
        },
        ['rare_turtle'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook4'] = true,
            },
            bait = {
                ['bait4'] = true,
            },
        },
        ['baby_turtle'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook4'] = true,
            },
            bait = {
                ['bait4'] = true,
            },
        },
        ['legendary_turtle'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook4'] = true,
            },
            bait = {
                ['bait4'] = true,
            },
        },

        ------------------------------------------------
        ['raja'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
        ['sea_lion'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
        ['blue_shark'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
        ['hammerhead_shark'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
        ['white_shark'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
         ['whale'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
        ['dolphin'] = {
            rod = {
                ['elementalrod'] = true,
            },
            reel = {
                ['strongreel'] = true,
            },
            nylon = {
                ['strongnylon'] = true,
            },
            anzol = {
                ['hook5'] = true,
            },
            bait = {
                ['turtle_meat'] = true,
            },
        }, 
    }


    return self
end