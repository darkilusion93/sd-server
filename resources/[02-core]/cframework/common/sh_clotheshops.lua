function LoadClotheShops()
    local self = {}

    self.cloakRooms = {
        {x =   429.85,  	y =  -811.88,   	z =  29.49,     camCoords = vector3(  429.31,   -808.11,  29.49),   camHeading = 180.97},  	
        {x =  -705.67,	    y =  -151.14,	    z =  37.42,     camCoords = vector3( -705.28,   -151.36,  37.42),   camHeading = 256.48},		
        {x =  -819.82,	    y = -1067.21,	    z =  11.33,     camCoords = vector3( -822.72,  -1069.52,  11.33),   camHeading = 303.49},		
        {x = -1447.13,	    y =  -240.92,	    z =  49.82,     camCoords = vector3( -1447.4,   -241.65,  49.82),   camHeading = 177.24},		
        {x =     3.69,		y =  6505.55,	    z =  31.88,     camCoords = vector3(    5.96,   6508.52,  31.88), 	camHeading =  137.5},		
        {x =  1698.68,	    y =  4818.00,	    z =  42.06,     camCoords = vector3( 1697.71,   4821.63,  42.06),   camHeading = 193.17},		
        {x =   617.54,	    y =  2773.48,	    z =  42.09,     camCoords = vector3(  620.19,   2768.35,  42.09),   camHeading =   31.5},		
        {x =  1202.15,	    y =  2714.46,	    z =  38.22,     camCoords = vector3(  1198.4,   2713.93,  38.22),   camHeading = 278.42},		
        {x = -3178.47,   	y =  1035.93,	    z =  20.86,     camCoords = vector3(-3178.54,    1041.9,  20.86),   camHeading = 185.78},		
        {x = -1100.31,	    y =  2717.20,	    z =  19.11,     camCoords = vector3(-1102.77,   2714.39,  19.11),   camHeading = 316.88},		
        {x =    70.90,		y = -1387.40,	    z =  29.38,     camCoords = vector3(   71.48,  -1391.04,  29.38),   camHeading =   1.65},
        {x =  1096.55,	    y =   200.97,		z = -49.44,     camCoords = vector3( 1096.86,    200.62, -49.44),   camHeading = 224.34},
        {x =   118.50,	    y =  -232.40,	    z =  54.56,     camCoords = vector3(  118.03,   -226.45,  54.56),   camHeading = 195.17},
        {x = -1182.35,   	y =  -765.02,	    z =  17.33,     camCoords = vector3(-1185.09,   -770.28,  17.33),   camHeading = 350.86},
        {x =  1787.64,	    y =  3634.43,	    z =  34.89,     camCoords = vector3( 1785.26,   3637.79,  34.89),   camHeading = 207.64},
        {x =   306.77,   	y =  -601.27,	    z =  43.27,     camCoords = vector3(  308.42,   -598.18,  43.27),   camHeading =  124.0},  
        {x =  1067.32,      y =  2733.97,   	z =  38.66,     camCoords = vector3( 1067.32,   2733.97,  38.66),   camHeading = 174.56}, 
        {x =   486.55,	    y = -972.11,	    z =  25.09,     camCoords = vector3(   484.17, -972.65, 26.09 ),   camHeading =  177.18},  -- Los Santos Police
        {x =   837.85,	    y = -1278.54,	    z =  26.29,     camCoords = vector3(   837.85,   -1278.54,  26.29),   camHeading =  180.13},  -- Los Santos Police 2
        {x =  1829.06,      y = 3674.29,        z =  34.71,     camCoords = vector3(  1829.06,  3674.29,  34.71),   camHeading =  23.81},  -- Sheriffs Sandy Shores
        {x =  -343.97,      y = 7208.42,        z =   6.80,     camCoords = vector3(  -340.19,  7208.92,  6.80 ),   camHeading =  91.16}, -- Rockswood 1
        {x =  5142.39,      y = -5088.63,       z =   1.46,     camCoords = vector3(  5138.58, -5088.89,  2.46 ),   camHeading =  91.16}, -- CAYO PERICO
    }

    self.clothesShops = {
        {x =    75.59,    y =  -1392.9,    z =  29.38,     camCoords = vector3(   72.14,  -1398.95,  29.38),      camHeading = 286.66},
        {x =  -709.97,    y =  -153.21,    z =  37.43,     camCoords = vector3( -706.64,   -160.23,  37.42),      camHeading = 356.69},
        {x =   425.29,    y =  -806.25,    z =  29.50,     camCoords = vector3(  428.64,   -800.29,  29.49), 	  camHeading = 109.38},
        {x =  -822.22,    y = -1073.83,    z =  11.34,     camCoords = vector3(  -829.2,  -1073.66,  11.33),      camHeading = 229.61},
        {x = -1450.54,    y =  -237.33,    z =  49.83,     camCoords = vector3(-1456.28,   -242.82,  49.81),      camHeading = 268.83},
        {x =     4.66,    y =  6512.58,    z =  31.89,     camCoords = vector3(   11.45,   6514.11,  31.88), 	  camHeading =  57.66},
        {x =   125.12,    y =  -224.63,    z =  54.56,     camCoords = vector3(  120.45,   -225.43,  54.56), 	  camHeading = 265.03},
        {x =  1693.73,    y =  4822.79,    z =  42.07,     camCoords = vector3( 1696.18,   4829.54,  42.06),      camHeading = 120.53},
        {x =   614.46,    y =  2763.83,    z =  42.10,     camCoords = vector3(  618.47,   2766.31,  42.09),      camHeading = 107.09},
        {x =   1196.7,    y =  2710.05,    z =  38.23,     camCoords = vector3( 1190.46,   2713.09,  38.22),      camHeading = 199.13},
        {x = -1192.22,    y =  -767.67,    z =  17.33,     camCoords = vector3(-1187.75,   -769.94,  17.33),      camHeading =  51.83},
        {x = -3171.16,    y =  1042.87,    z =  20.87,     camCoords = vector3(-3176.05,   1042.68,  20.86),      camHeading = 264.65},
        {x = -1101.38,    y =  2710.45,    z =  19.12,     camCoords = vector3(-1108.15,   2708.58,  19.11),      camHeading = 260.23},
        {x =  1101.74,    y =   196.82,    z = -49.44,     camCoords = vector3( 1103.57,    196.26, -49.44),      camHeading =  57.16},
        {x =  1781.25,    y =  3636.90,    z =  34.89,     camCoords = vector3( 1780.69,   3643.66,  34.89),      camHeading = 116.14},
        {x =  5137.13,    y = -5092.77,    z =   1.46,     camCoords = vector3( 5131.08,  -5088.64,  2.46),       camHeading = 178.18}, -- cayo perico
    }

    self.clothesPed = {
        --{x = -68.15, y = -2119.20, z = 16.92, w = 19.71},
    }

    self.barberShops = {
        {x = -822.05,  y = -185.15,  z = 37.6,     camCoords = vector3(-815.62, -184.15, 37.57), camHeading = 144.05},
        {x = 133.68,   y = -1709.17, z = 29.29,    camCoords = vector3(138.66, -1706.33, 29.29), camHeading = 6.16},
        {x = -1285.73, y = -1115.46, z = 6.99,     camCoords = vector3(-1280.85, -1117.9, 6.99), camHeading = 6.99},
        {x = 1931.65,  y = 3726.87,  z = 32.84,    camCoords = vector3(1931.42, 3731.54, 32.84), camHeading = 63.81},
        {x = 1209.97,  y = -470.28,  z = 66.21,    camCoords = vector3(1213.79, -473.58, 66.21), camHeading = 290.02},
        {x = -30.35,   y = -150.3,   z = 57.08,    camCoords = vector3(-33.84, -153.1, 57.08),   camHeading = 198.99},
        {x = -279.02,  y = 6231.46,  z = 31.7,     camCoords = vector3(-277.81, 6226.95, 31.7),  camHeading = 258.91},
    }

    self.tattooShops = {
        {x = 1322.6,  y = -1651.9, z = 52.30, --[[camCoords = vector3(,,), camHeading = ]]},
        {x = -1153.6, y = -1425.6, z = 5.0,   --[[camCoords = vector3(,,), camHeading = ]]},
        {x = 322.1,   y = 180.4,   z = 103.6, --[[camCoords = vector3(,,), camHeading = ]]},
        {x = -3170.0, y = 1075.0,  z = 20.83, --[[camCoords = vector3(,,), camHeading = ]]},
        {x = 1864.6,  y = 3747.7,  z = 33.03, --[[camCoords = vector3(,,), camHeading = ]]},
        {x = -293.7,  y = 6200.0,  z = 31.49, --[[camCoords = vector3(,,), camHeading = ]]},
    }

    self.maskShop = {
        {x = -1336.52,   y = -1279.19,   z = 4.85,     camCoords = vector3(-1338.38, -1276.59, 4.89), camHeading = 76.78},
    }

    self.maskPed = {
        {x = -1336.53, y = -1277.71, z = 4.87, w = 110.23},
    }

    self.barberPed = {
        {x = -822.98, y = -183.87, z = 37.57, w = 222.63},
        {x = -30.71, y = -151.70, z = 57.08, w = 334.26},
        {x = 134.66, y = -1708.05, z = 29.29, w = 131.82},
        {x = -277.90, y = 6230.46, z = 31.70, w = 45.62},
        {x = -1284.27, y = -1115.50, z = 6.99, w = 88.69},
        {x = 1931.02, y = 3728.25, z = 32.84, w = 204.06},
        {x = 1211.47, y = -470.71, z = 66.21, w = 78.14}
    }
    --MOTOCLBUS PED
    self.motoclubPed = {
        {x = 277.99, y = 6784.48, z = 15.70, w = 263.19}
    }

    return self
end