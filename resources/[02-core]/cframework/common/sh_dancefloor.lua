function LoadDanceFloor()
    local self = {}

    self.locations = {
        ["nightclubBahamas"] = { --Bahamas
            dancefloor = {x = -1391.13, y = -605.51, z = 30.40, r = 30.0},
            djbooth =    {x = -1391.22, y = -605.81, z = 30.52},
        },
        ["nightclubunderground"] = { --Vanila
            dancefloor = {x = 110.99, y = -1288.24, z = 28.78, r = 30.0},
            djbooth =    {x = 121.91, y = -1281.77, z = 29.48},
        },
        ["nighclubMotoclub"] = { -- record 2
            dancefloor = {x = -1001.78, y = -258.92, z = 39.04, r = 30.0},
            djbooth =    {x = -1004.54, y = -250.54, z = 39.40},
        },
        ["rooftopcasino"] = { --Beach
            dancefloor = {x = -2977.78, y = -57.86, z = 1.76, r = 30.0},
            djbooth =    {x = -2990.71, y = -67.68, z = 1.74},
        },
        ["tribunal"] = { -- squad1
            dancefloor = {x = -2.64, y = -1812.45, z = 19.5, r = 30.0},
            djbooth =    {x = -2.64, y = -1812.45, z = 20.5},
        },
        ["ilegal3"] = {      -- record
            dancefloor = {x = -1007.61, y = -293.94, z = 44.8, r = 30.0},
            djbooth =    {x = -1011.82, y = -289.36, z = 44.79},
        },
        ["oficina2"] = {       -- Beach v2
            dancefloor = {x = -2962.49, y = -1.17,  z = 7.90, r = 30.0},
            djbooth =    {x = -2967.81, y = -10.34, z = 9.13},
        },
        ["ilha"] = {          -- arcade
            dancefloor = {x = 744.25, y = -821.29, z = 22.80, r = 30.0},
            djbooth =    {x = 734.94, y = -818.1,  z = 22.20},
        },
        ["squad12"] = {     -- galaxy v2
            dancefloor = {x = 402.26, y = 258.54, z = 91.05, r = 30.0},
            djbooth =    {x = 399.26, y = 269.27, z = 92.05},
        },
        ["arena"] = { -- Maze bank arena
            dancefloor = {x = -325.80, y = -1969.68, z = 21.05, r = 30.0},
            djbooth =    {x = -325.12, y = -1983.99, z = 22.99},
        },
    }

    return self
end