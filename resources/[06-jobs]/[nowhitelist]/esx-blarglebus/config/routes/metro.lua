-- Definição de todas as paragens do metro
local S = {
    [1]  = {Coords = {x = -526.2774,   y = -263.5606,  z = 35.4519}, UnloadType = UnloadType.Some, Name = 'stop_metro_carcer_way'},
    [3]  = {Coords = {x = -1418.3283,  y = -91.1142,   z = 52.4513}, UnloadType = UnloadType.Some, Name = 'stop_metro_eclipse_cougar'},
    [4]  = {Coords = {x = -1475.4442,  y = -635.4663,  z = 31.0511}, UnloadType = UnloadType.Some, Name = 'stop_metro_marathon_baycity'},
    [5]  = {Coords = {x = -1413.7164,  y = -566.5466,  z = 30.8335}, UnloadType = UnloadType.Some, Name = 'stop_metro_marathon_prosperity'},
    [6]  = {Coords = {x = -1169.3343,  y = -396.8692,  z = 35.5438}, UnloadType = UnloadType.Some, Name = 'stop_metro_marathon'},
    [7]  = {Coords = {x = -692.2866,   y = -671.1650,  z = 31.2891}, UnloadType = UnloadType.Some, Name = 'stop_metro_sanandreas_ginger'},
    [8]  = {Coords = {x = -504.8421,   y = -671.5119,  z = 33.4909}, UnloadType = UnloadType.Some, Name = 'stop_metro_sanandreas_calais'},
    [9]  = {Coords = {x = 115.3352,    y = -780.9725,  z = 31.8174}, UnloadType = UnloadType.Some, Name = 'stop_metro_fib'},
    [10] = {Coords = {x = -248.1879,   y = -712.1666,  z = 33.9617}, UnloadType = UnloadType.Some, Name = 'stop_metro_peaceful_san_andreas'},
    [11] = {Coords = {x = -267.2324,   y = -824.2173,  z = 32.2911}, UnloadType = UnloadType.Some, Name = 'stop_metro_peaceful_vespucci'},
    [12] = {Coords = {x = -250.1772,   y = -887.7517,  z = 31.0675}, UnloadType = UnloadType.Some, Name = 'stop_metro_vespucci_alta'},
    [13] = {Coords = {x = 355.2163,    y = -1067.8500, z = 29.9783}, UnloadType = UnloadType.Some, Name = 'stop_metro_vespucci_sinner'},
    [14] = {Coords = {x = -713.2615,   y = -823.8684,  z = 23.5511}, UnloadType = UnloadType.Some, Name = 'stop_metro_vespucci_ginger'},
    [15] = {Coords = {x = -932.4981,   y = -120.2621,  z = 37.7789}, UnloadType = UnloadType.Some, Name = 'stop_metro_delperro_madwayne'},
    [16] = {Coords = {x = -1528.3587,  y = -463.6042,  z = 35.8467}, UnloadType = UnloadType.Some, Name = 'stop_metro_delperro_plaza'},
    [17] = {Coords = {x = -642.2674,   y = -135.7480,  z = 37.8349}, UnloadType = UnloadType.Some, Name = 'stop_metro_rockford_eastbourne'},
    [18] = {Coords = {x = -681.7453,   y = -381.3421,  z = 34.2342}, UnloadType = UnloadType.Some, Name = 'stop_metro_dorset_palomino'},
    [19] = {Coords = {x = -179.0992,   y = -818.2785,  z = 31.0558}, UnloadType = UnloadType.Some, Name = 'stop_metro_alta_gruppe'},
    [29] = {Coords = {x = 66.2063,     y = -966.0771,  z = 29.3575}, UnloadType = UnloadType.Some, Name = 'stop_metro_vespucci_elgin'},
    [32] = {Coords = {x = -1281.3592,  y = -317.1460,  z = 36.7809}, UnloadType = UnloadType.Some, Name = 'stop_metro_delperro_morningwood'},
    [34] = {Coords = {x = 321.7252,    y = -241.9803,  z = 53.9631}, UnloadType = UnloadType.Some, Name = 'stop_metro_hawick_meteor'},
    [39] = {Coords = {x = 788.6597,    y = -775.8231,  z = 26.7654}, UnloadType = UnloadType.Some, Name = 'stop_metro_popular'},
    [42] = {Coords = {x = 263.5511,    y = -1210.4304, z = 29.3386}, UnloadType = UnloadType.All,  Name = 'stop_metro_station_arrivals'},
    [43] = {Coords = {x = 263.7222,    y = -1194.2947, z = 29.3560}, UnloadType = UnloadType.All,  Name = 'stop_metro_station_departures'},
    [44] = {Coords = {x = -216.5875,   y = -600.5554,  z = 34.2638}, UnloadType = UnloadType.Some, Name = 'stop_metro_business_center'},
    [45] = {Coords = {x = -698.0225,   y = -0.4975,    z = 38.2428}, UnloadType = UnloadType.Some, Name = 'stop_metro_delperro_rockford'},
    [46] = {Coords = {x = -735.3663,   y = -750.2927,  z = 26.8735}, UnloadType = UnloadType.Some, Name = 'stop_metro_ginger'},
    [47] = {Coords = {x = -249.4506,   y = -337.0251,  z = 29.9658}, UnloadType = UnloadType.Some, Name = 'stop_metro_rockford_plaza'},
    [48] = {Coords = {x = 303.4519,    y = -765.7985,  z = 29.3109}, UnloadType = UnloadType.Some, Name = 'stop_metro_strawberry_ave'},
    [49] = {Coords = {x = 187.6606,    y = -187.2898,  z = 54.0936}, UnloadType = UnloadType.Some, Name = 'stop_metro_hawick_alta'},
}

-- Helper para converter paragem em formato de stop para RouteLines
local function makeStop(entry, doors)
    return {
        Name        = entry.Name,
        Coords      = entry.Coords,
        Type        = 'BusStop',
        Doors       = doors,
        MinFare     = 2,
        MaxFare     = 8,
        UnloadType  = entry.UnloadType,
    }
end

local doors = {0, 1, 2, 3}

MetroRoute = {
    Name = 'metro_route',
    SpawnPoint = {x = 303.1034, y = -1208.9884, z = 29.4169, heading = 356.02},
    RouteLines = {
        -- Linha Amarela
        {
            BusModel = 'bus', BusColor = 42, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[11],doors), makeStop(S[44],doors),
            makeStop(S[47],doors), makeStop(S[1],doors),  makeStop(S[17],doors),
            makeStop(S[15],doors), makeStop(S[18],doors), makeStop(S[8],doors),
            makeStop(S[10],doors), makeStop(S[12],doors), makeStop(S[42],doors),
        },
        -- Linha Azul
        {
            BusModel = 'bus', BusColor = 83, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[45],doors), makeStop(S[15],doors),
            makeStop(S[32],doors), makeStop(S[16],doors), makeStop(S[4],doors),
            makeStop(S[7],doors),  makeStop(S[8],doors),  makeStop(S[19],doors),
            makeStop(S[42],doors),
        },
        -- Linha Vermelha
        {
            BusModel = 'bus', BusColor = 39, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[13],doors), makeStop(S[39],doors),
            makeStop(S[49],doors), makeStop(S[48],doors), makeStop(S[10],doors),
            makeStop(S[12],doors), makeStop(S[42],doors),
        },
        -- Linha Rosa
        {
            BusModel = 'bus', BusColor = 148, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[29],doors), makeStop(S[14],doors),
            makeStop(S[46],doors), makeStop(S[6],doors),  makeStop(S[5],doors),
            makeStop(S[3],doors),  makeStop(S[18],doors), makeStop(S[8],doors),
            makeStop(S[19],doors), makeStop(S[42],doors),
        },
        -- Linha Laranja
        {
            BusModel = 'bus', BusColor = 41, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[13],doors), makeStop(S[9],doors),
            makeStop(S[19],doors), makeStop(S[13],doors), makeStop(S[9],doors),
            makeStop(S[19],doors), makeStop(S[13],doors), makeStop(S[9],doors),
            makeStop(S[19],doors), makeStop(S[42],doors),
        },
        -- Linha Preta
        {
            BusModel = 'bus', BusColor = 12, Doors = doors, FirstSeat = 1,
            makeStop(S[43],doors), makeStop(S[14],doors), makeStop(S[46],doors),
            makeStop(S[7],doors),  makeStop(S[8],doors),  makeStop(S[10],doors),
            makeStop(S[14],doors), makeStop(S[46],doors), makeStop(S[7],doors),
            makeStop(S[8],doors),  makeStop(S[10],doors), makeStop(S[42],doors),
        },
    }
}