Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DEL'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

Config = {}

Config.BailPrice = 1500

Config.Uniforms = {
	seguranca = {
		male = {
			['tshirt_1'] = 20,  ['tshirt_2'] = 3,
			['torso_1'] = 3,   ['torso_2'] = 3,
			['arms'] = 4,
			['pants_1'] = 22,   ['pants_2'] = 0,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['bproof_1'] = 4,  ['bproof_2'] = 1
		},
		female = {
			['tshirt_1'] = 19,  ['tshirt_2'] = 3,
			['torso_1'] = 3,   ['torso_2'] = 3,
			['arms'] = 3,
			['pants_1'] = 51,   ['pants_2'] = 1,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 4,  ['bproof_2'] = 1
		}
	},
	meo = {
		male = {
			['tshirt_1'] = 88,  ['tshirt_2'] = 0,
			['torso_1'] = 3,   ['torso_2'] = 0,
			['arms'] = 4,
			['pants_1'] = 47,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 4
		},
		female = {
			['tshirt_1'] = 7,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 3,
			['arms'] = 0,
			['pants_1'] = 48,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 20,  ['bproof_2'] = 4
		}
	},
	garbage = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 0,   ['torso_2'] = 0,
			['arms'] = 30,
			['pants_1'] = 36,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 10,  ['bproof_2'] = 4
		},
		female = {
			['tshirt_1'] = 8,  ['tshirt_2'] = 0,
			['torso_1'] = 43,   ['torso_2'] = 3,
			['arms'] = 0,
			['pants_1'] = 35,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['bproof_1'] = 20,  ['bproof_2'] = 4
		}
	},
	gopostal = {
		male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 3,   ['torso_2'] = 14,
			['arms'] = 4,
			['pants_1'] = 10,   ['pants_2'] = 3,
			['shoes_1'] = 10,   ['shoes_2'] = 0,
			['bproof_1'] = 18,  ['bproof_2'] = 5,
			['helmet_1'] = 63,  ['helmet_2'] = 9
		},
		female = {
			['tshirt_1'] = 8,  ['tshirt_2'] = 0,
			['torso_1'] = 103,   ['torso_2'] = 1,
			['arms'] = 3,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 63,  ['helmet_2'] = 9,
			['bproof_1'] = 0,  ['bproof_2'] = 0
		}
	}
}	

Config.Locations = {
    ["garbagemain"] = {
        label = "Vuilnisstortplaats",
        coords = {x = -323.61, y = -1523.38, z = 27.23, h = 264.0},
    },
    ["garbageVehicle"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -323.61, y = -1523.38, z = 27.54, h = 265.0},
    },
    ["garbageVehicle2"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -361.28, y = -1566.87, z = 24.54, h = 186.0},
    },
    ["garbage1"] ={
        [1] = {
            name = "roylowensteinblvd",
            coords = {x = 509.99, y = -1620.98, z = 29.09, h = 0.5},
        },
        [2] = {
            name = "littlebighornavenue",
            coords = {x = 488.49, y = -1284.1, z = 29.24, h = 138.5},
        },
        [3] = {
            name = "vespucciblvd",
            coords = {x = 307.47, y = -1033.6, z = 29.03, h = 46.5},
        },
        [4] = {
            name = "elginavenue",
            coords = {x = 239.19, y = -681.5, z = 37.15, h = 178.5},
        },
        [5] = {
            name = "powerstreet",
            coords = {x = 268.72, y = -25.92, z = 73.36, h = 90.5},
        },
        [6] = {
            name = "altastreet",
            coords = {x = 267.03, y = 276.01, z = 105.54, h = 332.5},
        },
        [7] = {
            name = "didiondrive",
            coords = {x = 21.65, y = 375.44, z = 112.67, h = 323.5},
        },
        [8] = {
            name = "miltonroad",
            coords = {x = -546.9, y = 286.57, z = 82.85, h = 127.5},
        },
        [9] = {
            name = "eastbourneway",
            coords = {x = -683.23, y = -169.62, z = 37.74, h = 267.5},
        },
        [10] = {
            name = "eastbourneway2",
            coords = {x = -771.02, y = -218.06, z = 37.05, h = 277.5},
        },
        [11] = {
            name = "industrypassage",
            coords = {x = -1057.06, y = -515.45, z = 35.83, h = 61.5},
        },
        [12] = {
            name = "boulevarddelperro",
            coords = {x = -1558.64, y = -478.22, z = 35.18, h = 179.5, r = 1.0},
        },
        [13] = {
            name = "sandcastleway",
            coords = {x = -1350.0, y = -895.64, z = 13.36, h = 17.5},
        },
        [14] = {
            name = "magellanavenue",
            coords = {x = -1243.73, y = -1359.72, z = 3.93, h = 287.5},
        },
        [15] = {
            name = "palominoavenue",
            coords = {x = -845.87, y = -1113.07, z = 6.91, h = 253.5},
        },
        [16] = {
            name = "southrockforddrive",
            coords = {x = -635.21, y = -1226.45, z = 11.8, h = 143.5},
        },
        [17] = {
            name = "southarsenalstreet",
            coords = {x = -587.74, y = -1739.13, z = 22.47, h = 339.5},
        },
    },
    ["garbage2"] ={
        [17] = {
            name = "roylowensteinblvd",
            coords = {x = 509.99, y = -1620.98, z = 29.09, h = 0.5},
        },
        [16] = {
            name = "littlebighornavenue",
            coords = {x = 488.49, y = -1284.1, z = 29.24, h = 138.5},
        },
        [15] = {
            name = "vespucciblvd",
            coords = {x = 307.47, y = -1033.6, z = 29.03, h = 46.5},
        },
        [14] = {
            name = "elginavenue",
            coords = {x = 239.19, y = -681.5, z = 37.15, h = 178.5},
        },
        [13] = {
            name = "powerstreet",
            coords = {x = 268.72, y = -25.92, z = 73.36, h = 90.5},
        },
        [12] = {
            name = "altastreet",
            coords = {x = 267.03, y = 276.01, z = 105.54, h = 332.5},
        },
        [11] = {
            name = "didiondrive",
            coords = {x = 21.65, y = 375.44, z = 112.67, h = 323.5},
        },
        [10] = {
            name = "miltonroad",
            coords = {x = -546.9, y = 286.57, z = 82.85, h = 127.5},
        },
        [9] = {
            name = "eastbourneway",
            coords = {x = -683.23, y = -169.62, z = 37.74, h = 267.5},
        },
        [8] = {
            name = "eastbourneway2",
            coords = {x = -771.02, y = -218.06, z = 37.05, h = 277.5},
        },
        [7] = {
            name = "industrypassage",
            coords = {x = -1057.06, y = -515.45, z = 35.83, h = 61.5},
        },
        [6] = {
            name = "boulevarddelperro",
            coords = {x = -1558.64, y = -478.22, z = 35.18, h = 179.5, r = 1.0},
        },
        [5] = {
            name = "sandcastleway",
            coords = {x = -1350.0, y = -895.64, z = 13.36, h = 17.5},
        },
        [4] = {
            name = "magellanavenue",
            coords = {x = -1243.73, y = -1359.72, z = 3.93, h = 287.5},
        },
        [3] = {
            name = "palominoavenue",
            coords = {x = -845.87, y = -1113.07, z = 6.91, h = 253.5},
        },
        [2] = {
            name = "southrockforddrive",
            coords = {x = -635.21, y = -1226.45, z = 11.8, h = 143.5},
        },
        [1] = {
            name = "southarsenalstreet",
            coords = {x = -587.74, y = -1739.13, z = 22.47, h = 339.5},
        },
    },
    ["segurancamain"] = {
        label = "Vuilnisstortplaats",
        coords = {x = -5.5, y = -671.36, z = 32.03, h = 185.0},
    },
    ["segurancaVehicle"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -5.5, y = -671.36, z = 32.03, h = 185.0},
    },
    ["segurancaVehicle2"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -18.68, y = -702.85, z = 32.34, h = 354.0},
    },
    ["meomain"] = {
        label = "Vuilnisstortplaats",
        coords = {x = -147.8, y = -590.2, z = 32.12, h = 155.0},
    },
    ["meoVehicle"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -147.8, y = -590.2, z = 32.12, h = 155.0},
    },
    ["meoVehicle2"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = -159.95, y = -584.81, z = 32.42, h = 154.84},
    },
    ["cttmain"] = {
        label = "Vuilnisstortplaats",
        coords = {x = 66.52, y = 119.59, z = 78.8, h = 163.0},
    },
    ["cttVehicle"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = 66.52, y = 119.59, z = 78.8, h = 163.0},
    },
    ["cttVehicle2"] = {
        label = "Vuilniswagen Opslag",
        coords = {x = 117.65, y = 98.49, z = 80.50, h = 245.1},
    },
    ["gopostal1"] ={
		[1] = {
            name = "1",
            coords = {x = 2.44, y = 36.34, z = 71.53, h = 325.68},
        },
		
		 [2] = {
             name = "2",
             coords = {x = -69.39, y = 63.23, z = 71.89, h = 329.75},
         },
		
		 [3] = {
             name = "3",
             coords = {x = -201.24, y = 186.21, z = 80.32, h = 269.05},
         },
		
		 [4] = {
             name = "4",
             coords = {x = -766.16, y = -157.68, z = 37.59, h = 121.65},
         },
		
		 [5] = {
             name = "5",
             coords = {x = -480.59, y = -401.36, z = 34.55, h = 173.89},
         },
		
		 [6] = {
             name = "6",
             coords = {x = -290.3, y = -819.08, z = 32.42, h = 75.41},
         },
		
		 [7] = {
             name = "7",
             coords = {x = -719.4, y = 256.58, z = 79.9, h = 28.15},
         },
		
		 [8] = {
             name = "8",
             coords = {x = -287.42, y = -1062.65, z = 27.21, h = 73.26},
         },
		
		 [9] = {
             name = "9",
             coords = {x = 225.08, y = -1511.28, z = 29.29, h = 46.56},
         },
		
		 [10] = {
             name = "10",
             coords = {x = 412.02, y = -1488.44, z = 30.15, h = 216.28},
         },
		
		 [11] = {
             name = "11",
             coords = {x = 225.08, y = -1511.28, z = 29.29, h = 46.56},
         },
		
		 [12] = {
             name = "12",
             coords = {x = 451.63, y = -801.51, z = 27.52, h = 91.12},
         },
		
		 [13] = {
             name = "13",
             coords = {x = 542.3, y = 99.35, z = 96.51, h = 47.7},
         },
		
		 [14] = {
             name = "14",
             coords = {x = 456.26, y = 130.23, z = 99.29, h = 344.58},
         },
		
		 [15] = {
             name = "15",
             coords = {x = 397.01, y = 176.23, z = 103.86, h = 274.33},
         },
		
		 [16] = {
             name = "16",
             coords = {x = 412.54, y = 314.23, z = 103.02, h = 31.72},
         },
		
		 [17] = {
             name = "17",
             coords = {x = 232.22, y = 364.93, z = 106.0, h = 341.73},
         },
		
		 [18] = {
             name = "18",
             coords = {x = 40.39, y = 360.74, z = 116.04, h = 41.22},
         },
		
		 [19] = {
             name = "19",
             coords = {x = -60.01, y = 360.01, z = 113.06, h = 68.84},
         },
		
		 [20] = {
             name = "20",
             coords = {x = -37.49, y = 170.53, z = 95.36, h = 133.08},
         },
    },
    ["gopostal2"] ={
		[20] = {
            name = "1",
            coords = {x = 2.44, y = 36.34, z = 71.53, h = 325.68},
        },
		
		[19] = {
            name = "2",
            coords = {x = -69.39, y = 63.23, z = 71.89, h = 329.75},
        },
		
		[18] = {
            name = "3",
            coords = {x = -201.24, y = 186.21, z = 80.32, h = 269.05},
        },
		
		[17] = {
            name = "4",
            coords = {x = -766.16, y = -157.68, z = 37.59, h = 121.65},
        },
		
		[16] = {
            name = "5",
            coords = {x = -480.59, y = -401.36, z = 34.55, h = 173.89},
        },
		
		[15] = {
            name = "6",
            coords = {x = -290.3, y = -819.08, z = 32.42, h = 75.41},
        },
		
		[14] = {
            name = "7",
            coords = {x = -719.4, y = 256.58, z = 79.9, h = 28.15},
        },
		
		[13] = {
            name = "8",
            coords = {x = -287.42, y = -1062.65, z = 27.21, h = 73.26},
        },
		
		[12] = {
            name = "9",
            coords = {x = 225.08, y = -1511.28, z = 29.29, h = 46.56},
        },
		
		[11] = {
            name = "10",
            coords = {x = 412.02, y = -1488.44, z = 30.15, h = 216.28},
        },
		
		[10] = {
            name = "11",
            coords = {x = 225.08, y = -1511.28, z = 29.29, h = 46.56},
        },
		
		[9] = {
            name = "12",
            coords = {x = 451.63, y = -801.51, z = 27.52, h = 91.12},
        },
		
		[8] = {
            name = "13",
            coords = {x = 542.3, y = 99.35, z = 96.51, h = 47.7},
        },
		
		[7] = {
            name = "14",
            coords = {x = 456.26, y = 130.23, z = 99.29, h = 344.58},
        },
		
		[6] = {
            name = "15",
            coords = {x = 397.01, y = 176.23, z = 103.86, h = 274.33},
        },
		
		[5] = {
            name = "16",
            coords = {x = 412.54, y = 314.23, z = 103.02, h = 31.72},
        },
		
		[4] = {
            name = "17",
            coords = {x = 232.22, y = 364.93, z = 106.0, h = 341.73},
        },
		
		[3] = {
            name = "18",
            coords = {x = 40.39, y = 360.74, z = 116.04, h = 41.22},
        },
		
		[2] = {
            name = "19",
            coords = {x = -60.01, y = 360.01, z = 113.06, h = 68.84},
        },
		
		[1] = {
            name = "20",
            coords = {x = -37.49, y = 170.53, z = 95.36, h = 133.08},
        },
    },
    ["meo2"] ={
		[1] = {
            name = "1",
            coords = {x = -334.27, y = -645.21, z = 32.41, h = 183.35},
        },
        [2] = {
            name = "2",
            coords = {x = -460.69, y = -645.55, z = 32.25, h = 181.13},
        },

		[3] = {
            name = "3",
            coords = {x = -592.33, y = -886.73, z = 25.93, h = 262.67},
        },
        [4] = {
            name = "4",
            coords = {x = -547.35, y = -942.71, z = 23.79, h = 63.49},
        },
		
		[5] = {
            name = "5",
            coords = {x = -709.72, y = -1229.38, z = 10.67, h = 129.08},
        },
        [6] = {
            name = "6",
            coords = {x = -824.62, y = -1150.76, z = 7.88, h = 27.18},
        },

		[7] = {
            name = "7",
            coords = {x = -1057.86, y = -1015.03, z = 2.17, h = 121.47},
        },
        [8] = {
            name = "8",
            coords = {x = -1081.01, y = -1173.55, z = 2.16, h = 298.43},
        },
		[9] = {
            name = "9",
            coords = {x = -1115.08, y = -1217.62, z = 2.52, h = 213.59},
        },
        [10] = {
            name = "10",
            coords = {x = -1222.58, y = -1182.46, z = 7.72, h = 276.12},
        },

		[11] = {
            name = "11",
            coords = {x = -1139.75, y = -838.94, z = 14.8, h = 222.95},
        },
        [12] = {
            name = "12",
            coords = {x = -1154.97, y = -425.72, z = 35.65, h = 8.67},
        },
		
		[13] = {
            name = "13",
            coords = {x = -1226.71, y = -288.61, z = 37.75, h = 205.04},
        },
		
		[14] = {
            name = "14",
            coords = {x = -816.6, y = -207.84, z = 37.42, h = 131.9},
        },
		
		[15] = {
            name = "15",
            coords = {x = 215.02, y = -651.57, z = 38.56, h = 253.83},
        },
		
		[16] = {
            name = "16",
            coords = {x = -587.91, y = -225.43, z = 36.64, h = 122.8},
        },
		
		[17] = {
            name = "17",
            coords = {x = -190.9, y = -85.97, z = 51.96, h = 354.67},
        },
		
		[18] = {
            name = "18",
            coords = {x = -533.28, y = 24.26, z = 44.4, h = 358.45},
        },
		
		[19] = {
            name = "19",
            coords = {x = -465.82, y = -185.33, z = 37.67, h = 29.76},
        },
		
		[20] = {
            name = "20",
            coords = {x = -37.38, y = -239.28, z = 45.93, h = 342.43},
        },
    },
    ["meo1"] ={
		[20] = {
            name = "1",
            coords = {x = -334.27, y = -645.21, z = 32.41, h = 183.35},
        },
        [19] = {
            name = "2",
            coords = {x = -460.69, y = -645.55, z = 32.25, h = 181.13},
        },

		[18] = {
            name = "3",
            coords = {x = -592.33, y = -886.73, z = 25.93, h = 262.67},
        },
        [17] = {
            name = "4",
            coords = {x = -547.35, y = -942.71, z = 23.79, h = 63.49},
        },
		
		[16] = {
            name = "5",
            coords = {x = -709.72, y = -1229.38, z = 10.67, h = 129.08},
        },
        [15] = {
            name = "6",
            coords = {x = -824.62, y = -1150.76, z = 7.88, h = 27.18},
        },

		[14] = {
            name = "7",
            coords = {x = -1057.86, y = -1015.03, z = 2.17, h = 121.47},
        },
        [13] = {
            name = "8",
            coords = {x = -1081.01, y = -1173.55, z = 2.16, h = 298.43},
        },
		[12] = {
            name = "9",
            coords = {x = -1115.08, y = -1217.62, z = 2.52, h = 213.59},
        },
        [11] = {
            name = "10",
            coords = {x = -1222.58, y = -1182.46, z = 7.72, h = 276.12},
        },

		[10] = {
            name = "11",
            coords = {x = -1139.75, y = -838.94, z = 14.8, h = 222.95},
        },
        [9] = {
            name = "12",
            coords = {x = -1154.97, y = -425.72, z = 35.65, h = 8.67},
        },
		
		[8] = {
            name = "13",
            coords = {x = -1226.71, y = -288.61, z = 37.75, h = 205.04},
        },
		
		[7] = {
            name = "14",
            coords = {x = -816.6, y = -207.84, z = 37.42, h = 131.9},
        },
		
		[6] = {
            name = "15",
            coords = {x = 215.02, y = -651.57, z = 38.56, h = 253.83},
        },
		
		[5] = {
            name = "16",
            coords = {x = -587.91, y = -225.43, z = 36.64, h = 122.8},
        },
		
		[4] = {
            name = "17",
            coords = {x = -190.9, y = -85.97, z = 51.96, h = 354.67},
        },
		
		[3] = {
            name = "18",
            coords = {x = -533.28, y = 24.26, z = 44.4, h = 358.45},
        },
		
		[2] = {
            name = "19",
            coords = {x = -465.82, y = -185.33, z = 37.67, h = 29.76},
        },
		
		[1] = {
            name = "20",
            coords = {x = -37.38, y = -239.28, z = 45.93, h = 342.43},
        },
    },
    ["seguranca1"] ={
		[1] = {
            name = "1",
            coords = {x = 143.09, y = -1042.9, z = 29.37, h = 70.69},
        },

		[2] = {
            name = "2",
            coords = {x = 26.21, y = -1340.37, z = 29.5, h = 174.84},
        },
		
		[3] = {
            name = "2f",
            coords = {x = -42.54, y = -1749.3, z = 29.42, h = 318.53},
        },
		
		[4] = {
            name = "3",
            coords = {x = -709.24, y = -904.33, z = 19.22, h = 7.57},
        },

		[5] = {
            name = "4",
            coords = {x = -1220.66, y = -915.82, z = 11.33, h = 124.27},
        },
		
		[6] = {
            name = "4f",
            coords = {x = -1478.98, y = -375.39, z = 39.16, h = 222.43},
        },
		
		[7] = {
            name = "5",
            coords = {x = -1215.63, y = -337.11, z = 37.78, h = 124.66},
        },
		
		[8] = {
            name = "6",
            coords = {x = -631.31, y = -229.14, z = 38.06, h = 29.9},
        },
		
		[9] = {
            name = "7",
            coords = {x = -357.52, y = -52.26, z = 49.04, h = 73.57},
        },
		
		[10] = {
            name = "8",
            coords = {x = 375.79, y = 332.39, z = 103.57, h = 103.57},
        },
		
		[11] = {
            name = "9",
            coords = {x = 1160.06,y = -314.39, z = 69.21, h = 12.46},
        },

		[12] = {
            name = "9f",
            coords = {x = 1126.87,y = -980.63, z = 45.42, h = 5.90},
        },
		
		[13] = {
            name = "10f",
            coords = {x = 307.38, y = -281.47, z = 54.16, h = 75.19},
        },
    },
    ["seguranca2"] ={
		[13] = {
            name = "1",
            coords = {x = 143.09, y = -1042.9, z = 29.37, h = 70.69},
        },

		[12] = {
            name = "2",
            coords = {x = 26.21, y = -1340.37, z = 29.5, h = 174.84},
        },
		
		[11] = {
            name = "2f",
            coords = {x = -42.54, y = -1749.3, z = 29.42, h = 318.53},
        },
		
		[10] = {
            name = "3",
            coords = {x = -709.24, y = -904.33, z = 19.22, h = 7.57},
        },

		[9] = {
            name = "4",
            coords = {x = -1220.66, y = -915.82, z = 11.33, h = 124.27},
        },
		
		[8] = {
            name = "4f",
            coords = {x = -1478.98, y = -375.39, z = 39.16, h = 222.43},
        },
		
		[7] = {
            name = "5",
            coords = {x = -1215.63, y = -337.11, z = 37.78, h = 124.66},
        },
		
		[6] = {
            name = "6",
            coords = {x = -631.31, y = -229.14, z = 38.06, h = 29.9},
        },
		
		[5] = {
            name = "7",
            coords = {x = -357.52, y = -52.26, z = 49.04, h = 73.57},
        },
		
		[4] = {
            name = "8",
            coords = {x = 375.79, y = 332.39, z = 103.57, h = 103.57},
        },
		
		[3] = {
            name = "9",
            coords = {x = 1160.06,y = -314.39, z = 69.21, h = 12.46},
        },

		[2] = {
            name = "9f",
            coords = {x = 1126.87,y = -980.63, z = 45.42, h = 5.90},
        },
		
		[1] = {
            name = "10f",
            coords = {x = 307.38, y = -281.47, z = 54.16, h = 75.19},
        },
    },
}

Config.Vehicles = {
    ["trash"] = "Camião Lixo",
}