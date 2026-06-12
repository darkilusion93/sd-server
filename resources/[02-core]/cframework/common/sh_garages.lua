function LoadGarages()
    local self = {}

    self.zoneLabels = {
        ["los_santos"] = T("GARAGES_ZONE_LABEL_LOS_SANTOS"),
        ["roxwood"] = T("GARAGES_ZONE_LABEL_ROXWOOD"),
        ["cayoperico"] = T("GARAGES_ZONE_LABEL_CAYO_PERICO"),
        ["artico"] = T("GARAGES_ZONE_LABEL_ARCTIC")
    }

    self.poundCosts = {
        ["car"] = 500,
        ["boat"] = 20000,
        ["aircraft"] = 200000
    }

    self.CarGarages = { -- (-1)
        Garagem_1 = {
            GaragePoint = { x = -1049.77, y = -2648.82, z = 12.83 },                          
            SpawnPoint =  { x = -1048.05, y = -2657.62, z = 13.83, h = 232.95 },
            DeletePoint = { x = -1048.05, y = -2657.62, z = 12.83 },
            Zone = "los_santos"
        },
        Garagem_2 = {
            GaragePoint = { x = -833.26, y = -2351.10, z = 13.57 },                          
            SpawnPoint =  { x = -825.93, y = -2350.60, z = 14.57, h = 243.14 },
            DeletePoint = { x = -825.93, y = -2350.60, z = 13.57 },
            Zone = "los_santos"
        },
        Garagem_3 = {
            GaragePoint = { x = -938.13, y = -2076.68, z = 8.30 },                          
            SpawnPoint =  { x = -941.18, y = -2087.18, z = 9.30, h = 134.19 },
            DeletePoint = { x = -941.18, y = -2087.18, z = 8.30 },
            Zone = "los_santos"
        },
        Garagem_4 = {
            GaragePoint = { x = -796.19, y = -2023.18, z = 8.17 },                          
            SpawnPoint =  { x = -800.55, y = -2015.74, z = 9.34, h = 47.17 },
            DeletePoint = { x = -806.59, y = -2023.21, z = 8.23 },
            Zone = "los_santos"
        },
        Garagem_5 = {
            GaragePoint = { x = -609.56, y = -2238.52, z = 5.25 },                          
            SpawnPoint =  { x = -608.18, y = -2245.70, z = 6.15, h = 229.50 },
            DeletePoint = { x = -602.19, y = -2239.07, z = 5.21 },
            Zone = "los_santos"
        },
        Garagem_6 = {
            GaragePoint = { x = -169.02, y = -2144.41, z = 16.05 },                          
            SpawnPoint =  { x = -174.87, y = -2153.48, z = 17.70, h = 103.76 },
            DeletePoint = { x = -174.87, y = -2153.48, z = 15.70 },
            Zone = "los_santos"
        },
        Garagem_7 = {
            GaragePoint = { x = 212.77, y = -3044.49, z = 5.12 },                          
            SpawnPoint =  { x = 215.16, y = -3053.79, z = 6.80, h = 41.72 },
            DeletePoint = { x = 215.16, y = -3053.79, z = 4.80 },
            Zone = "los_santos"
        },
        Garagem_9 = {
            GaragePoint = { x = 810.65, y = -3147.62, z = 5.19 },                          
            SpawnPoint =  { x = 827.53, y = -3137.15, z = 6.90, h = 267.54 },
            DeletePoint = { x = 827.53, y = -3137.15, z = 4.90 },
            Zone = "los_santos"
        },
        Garagem_10 = {
            GaragePoint = { x = 1456.13, y = -2591.30, z = 47.63 },                          
            SpawnPoint =  { x = 1462.15, y = -2594.00, z = 48.58, h = 344.81 },
            DeletePoint = { x = 1462.15, y = -2594.00, z = 47.58 },
            Zone = "los_santos"
        },
        Garagem_11 = {
            GaragePoint = { x = 1007.05, y = -1911.29, z = 30.26 },                          
            SpawnPoint =  { x =  996.20, y = -1913.54, z = 31.16, h = 89.25 },
            DeletePoint = { x =  996.20, y = -1913.54, z = 30.16 },
            Zone = "los_santos"
        },
        Garagem_12 = {
            GaragePoint = { x =  1205.29, y = -1535.33, z = 38.40 },                          
            SpawnPoint =  { x =  1200.91, y = -1540.74, z = 39.40, h = 88.52 },
            DeletePoint = { x =  1200.91, y = -1540.74, z = 38.40 },
            Zone = "los_santos"
        },
        Garagem_13 = {
            GaragePoint = { x =  1036.30, y = -762.82, z = 56.99 },                          
            SpawnPoint =  { x =  1040.56, y = -776.43, z = 58.02, h = 1.51 },
            DeletePoint = { x =  1040.56, y = -776.43, z = 57.02 },
            Zone = "los_santos"
        },
        Garagem_14 = {
            GaragePoint = { x =  922.03, y = -72.96, z = 77.85 },                          
            SpawnPoint =  { x =  927.92, y = -73.19, z = 78.76, h = 24.52 },
            DeletePoint = { x =  927.92, y = -73.19, z = 77.76 },
            Zone = "los_santos"
        },
        Garagem_16 = {
            GaragePoint = { x =  48.02, y = -1703.53, z = 28.30 },                          
            SpawnPoint =  { x =  50.33, y = -1709.10, z = 29.32, h = 232.17 },
            DeletePoint = { x =  50.33, y = -1709.10, z = 28.32 },
            Zone = "los_santos"
        },
        Garagem_17 = {
            GaragePoint = { x =  25.32, y = -1594.71, z = 28.28 },                          
            SpawnPoint =  { x =  33.87, y = -1589.40, z = 29.32, h = 28.32 },
            DeletePoint = { x =  33.87, y = -1589.40, z = 28.32 },
            Zone = "los_santos"
        },
        Garagem_19 = {
            GaragePoint = { x =  -355.17, y = -1513.35, z = 26.72 },                          
            SpawnPoint =  { x =  -346.32, y = -1520.95, z = 27.73, h = 270.62 },
            DeletePoint = { x =  -346.32, y = -1520.95, z = 26.73 },
            Zone = "los_santos"
        },
        Garagem_20 = {
            GaragePoint = { x =  271.30, y = -1513.54, z = 28.21 },                          
            SpawnPoint =  { x =  255.85, y = -1512.51, z = 29.14, h = 111.12 },
            DeletePoint = { x =  255.85, y = -1512.51, z = 28.14 },
            Zone = "los_santos"
        },
        Garagem_21 = {
            GaragePoint = { x =  377.86, y = -1630.21, z = 27.27 },                          
            SpawnPoint =  { x =  388.93, y = -1623.05, z = 29.29, h = 317.37 },
            DeletePoint = { x =  388.93, y = -1623.05, z = 28.29 },
            Zone = "los_santos"
        },
        Garagem_22 = { -- Principal
            GaragePoint = { x =  214.05, y = -808.55, z = 30.01 },                          
            SpawnPoint =  { x =  229.32, y = -800.55, z = 30.58, h = 163.80 },
            DeletePoint = { x =  229.32, y = -800.55, z = 29.58 },
            Zone = "los_santos"
        },
        Garagem_23 = { -- Principal
            GaragePoint = { x =  56.88, y = -876.89, z = 29.65 },                          
            SpawnPoint =  { x =  48.07, y = -879.74, z = 30.32, h = 253.25 },
            DeletePoint = { x =  48.07, y = -879.74, z = 29.32 },
            Zone = "los_santos"
        },
        Garagem_24 = { -- Principal
            GaragePoint = { x =  58.78, y = -634.70, z = 30.90 },                          
            SpawnPoint =  { x =  51.68, y = -625.70, z = 31.63, h = 247.27 },
            DeletePoint = { x =  51.68, y = -625.70, z = 30.63 },
            Zone = "los_santos"
        },
        Garagem_25 = { 
            GaragePoint = { x =  -818.34, y = -1315.78, z = 4.10 },                          
            SpawnPoint =  { x =  -812.91, y = -1304.70, z = 5.00, h = 259.37 },
            DeletePoint = { x =  -812.91, y = -1304.70, z = 4.00 },
            Zone = "los_santos"
        },
        Garagem_26 = { 
            GaragePoint = { x =  -1184.34, y = -1509.56, z = 3.65 },                          
            SpawnPoint =  { x =  -1190.76, y = -1495.83, z = 4.38, h = 218.14 },
            DeletePoint = { x =  -1190.76, y = -1495.83, z = 3.38 },
            Zone = "los_santos"
        },
        Garagem_27 = { 
            GaragePoint = { x =  -1071.76, y = -852.40, z = 3.87 },                          
            SpawnPoint =  { x =  -1067.86, y = -859.74, z = 4.87, h = 204.48 },
            DeletePoint = { x =  -1067.86, y = -859.74, z = 3.87 },
            Zone = "los_santos"
        },
        Garagem_28 = { 
            GaragePoint = { x =  -1600.50, y = -873.10, z = 8.81 },                          
            SpawnPoint =  { x =  -1604.52, y = -876.62, z = 9.71, h = 227.27 },
            DeletePoint = { x =  -1604.52, y = -876.62, z = 8.71 },
            Zone = "los_santos"
        },
        Garagem_29 = { 
            GaragePoint = { x =  -2029.99, y = -465.85, z = 10.60 },                          
            SpawnPoint =  { x =  -2036.54, y = -469.53, z = 11.36, h = 225.61 },
            DeletePoint = { x =  -2036.54, y = -469.53, z = 10.36 },
            Zone = "los_santos"
        },
        Garagem_30 = { 
            GaragePoint = { x =  275.08, y = -345.41, z = 44.17 },                          
            SpawnPoint =  { x =  275.31, y = -327.61, z = 44.92, h = 158.50 },
            DeletePoint = { x =  275.31, y = -327.61, z = 43.92 },
            Zone = "los_santos"
        },
        Garagem_31 = { 
            GaragePoint = { x =  362.44, y = 298.87, z = 102.88 },                          
            SpawnPoint =  { x =  363.96, y = 288.23, z = 103.41, h = 334.85 },
            DeletePoint = { x =  363.96, y = 288.23, z = 102.41 },
            Zone = "los_santos"
        },
        Garagem_32 = { 
            GaragePoint = { x =  632.74, y = 2729.80, z = 40.85 },                          
            SpawnPoint =  { x =  621.41, y = 2732.18, z = 41.93, h = 93.75 },
            DeletePoint = { x =  621.41, y = 2732.18, z = 40.93 },
            Zone = "los_santos"
        },
        Garagem_33 = { 
            GaragePoint = { x =  1902.78, y = 2605.23, z = 44.97 },                          
            SpawnPoint =  { x =  1897.72, y = 2600.40, z = 45.73, h = 270.29 },
            DeletePoint = { x =  1897.72, y = 2600.40, z = 44.73 },
            Zone = "los_santos"
        },
        Garagem_34 = { 
            GaragePoint = { x =  1767.80, y = 3749.83, z = 32.78 },                          
            SpawnPoint =  { x =  1772.33, y = 3745.85, z = 33.75, h = 122.18 },
            DeletePoint = { x =  1772.33, y = 3745.85, z = 32.75 },
            Zone = "los_santos"
        },
        Garagem_35 = { 
            GaragePoint = { x =  -67.45, y = 6566.77, z = 30.49 },                          
            SpawnPoint =  { x =  -68.74, y = 6560.14, z = 31.49, h = 223.84 },
            DeletePoint = { x =  -68.74, y = 6560.14, z = 30.49 },
            Zone = "los_santos"
        },
        Garagem_36 = { 
            GaragePoint = { x =  -434.44, y = 6030.14, z = 30.34 },                          
            SpawnPoint =  { x =  -438.26, y = 6036.56, z = 31.34, h = 30.46 },
            DeletePoint = { x =  -438.26, y = 6036.56, z = 30.34 },
            Zone = "los_santos"
        },
        Garagem_37 = { 
            GaragePoint = { x =  -746.59, y = 5548.08, z = 32.61 },                          
            SpawnPoint =  { x =  -752.30, y = 5541.39, z = 33.49, h = 91.15 },
            DeletePoint = { x =  -752.30, y = 5541.39, z = 32.49 },
            Zone = "los_santos"
        },
        Garagem_42 = { 
            GaragePoint = { x =  4462.62, y = -4463.82, z = 3.23 },                          
            SpawnPoint =  { x =  4473.55, y = -4460.62, z = 4.25, h = 286.57 },
            DeletePoint = { x =  4473.55, y = -4460.62, z = 3.25 },
            Zone = "cayoperico"
        },
        Garagem_43 = {  -- mineiros
            GaragePoint = { x =  2707.39, y = 2776.78, z = 36.88 },                          
            SpawnPoint =  { x =  2686.13, y = 2766.52, z = 37.88, h = 211.87 },
            DeletePoint = { x =  2686.13, y = 2766.52, z = 36.88 },
            Zone = "los_santos"
        },
        Garagem_44 = {  
            GaragePoint = { x =  -3132.67, y = 1132.07, z = 19.68 },                          
            SpawnPoint =  { x =  -3136.77, y = 1123.97, z = 20.69, h = 160.90 },
            DeletePoint = { x =  -3136.77, y = 1123.97, z = 19.69 },
            Zone = "los_santos"
        },
        Garagem_45 = {  
            GaragePoint = { x =  -3022.00, y = 117.33, z = 10.77 },                          
            SpawnPoint =  { x =  -3033.25, y = 121.57, z = 11.61, h = 215.98 },
            DeletePoint = { x =  -3033.25, y = 121.57, z = 10.61 },
            Zone = "los_santos"
        },
        Garagem_46 = {  
            GaragePoint = { x =  -2542.08, y = 2349.01, z = 32.06 },                          
            SpawnPoint =  { x =  -2535.34, y = 2343.10, z = 33.06, h = 209.99 },
            DeletePoint = { x =  -2535.34, y = 2343.10, z = 32.06 },
            Zone = "los_santos"
        },
        Garagem_47 = {  
            GaragePoint = { x =  -1152.33, y = 2665.34, z = 17.09 },                          
            SpawnPoint =  { x =  -1153.37, y = 2661.63, z = 18.09, h = 221.33 },
            DeletePoint = { x =  -1153.37, y = 2661.63, z = 17.09 },
            Zone = "los_santos"
        },
        Garagem_48 = {  
            GaragePoint = { x =  4866.83, y = -5161.26, z = 1.44 },                          
            SpawnPoint =  { x =  4864.00, y = -5172.28, z = 2.44, h = 222.77 },
            DeletePoint = { x =  4865.00, y = -5172.28, z = 1.44 },
            Zone = "cayoperico"
        },
        Garagem_49 = {  
            GaragePoint = { x =  1536.50, y = 781.32, z = 76.44 },                          
            SpawnPoint =  { x =  1523.74, y = 784.80, z = 78.44, h = 110.84 },
            DeletePoint = { x =  1523.74, y = 784.80, z = 76.44 },
            Zone = "los_santos"
        },
        Garagem_50 = {  
            GaragePoint = { x =  2885.86, y = 4386.30, z = 49.74 },                          
            SpawnPoint =  { x =  2901.15, y = 4382.22, z = 50.36, h = 292.57 },
            DeletePoint = { x =  2901.15, y = 4382.22, z = 49.36 },
            Zone = "los_santos"
        },
        Garagem_51 = {  
            GaragePoint = { x =  231.01, y = 1223.75, z = 224.46 },                          
            SpawnPoint =  { x =  225.63, y = 1217.32, z = 225.46, h = 191.07 },
            DeletePoint = { x =  225.63, y = 1217.32, z = 224.46 },
            Zone = "los_santos"
        },
        Garagem_52 = {  
            GaragePoint = { x =  1464.72, y = 6547.70, z = 13.21 },                          
            SpawnPoint =  { x =  1454.17, y = 6548.49, z = 14.93, h = 127.39 },
            DeletePoint = { x =  1454.17, y = 6548.49, z = 13.93 },
            Zone = "los_santos"
        },
        Garagem_53 = {  
            GaragePoint = { x =  2867.08, y = 4726.87, z = 47.95 },                          
            SpawnPoint =  { x =  2863.45, y = 4737.76, z = 48.91, h = 15.82 },
            DeletePoint = { x =  2863.45, y = 4737.76, z = 47.91 },
            Zone = "los_santos"
        },
        Garagem_54 = {  
            GaragePoint = { x =  2479.07, y = 4122.89, z = 37.02 },                          
            SpawnPoint =  { x =  2484.82, y = 4117.34, z = 38.06, h = 244.61 },
            DeletePoint = { x =  2484.82, y = 4117.34, z = 37.06 },
            Zone = "los_santos"
        },
        Garagem_55 = {  
            GaragePoint = { x =  -72.40, y = 908.28, z = 234.62 },                          
            SpawnPoint =  { x =  -72.11, y = 898.62, z = 235.57, h = 199.04 },
            DeletePoint = { x =  -72.11, y = 898.62, z = 234.57 },
            Zone = "los_santos"
        },
        Garagem_56 = {  
            GaragePoint = { x =  -1155.30, y = 929.74, z = 197.15 },                          
            SpawnPoint =  { x =  -1162.24, y = 935.20, z = 197.68, h = 46.16 },
            DeletePoint = { x =  -1162.24, y = 935.20, z = 196.68 },
            Zone = "los_santos"
        },
        Garagem_57 = {  
            GaragePoint = { x =  -803.00, y = 354.10, z = 86.87 },                          
            SpawnPoint =  { x =  -807.87, y = 362.56, z = 87.87, h = 85.89 },
            DeletePoint = { x =  -807.87, y = 362.56, z = 86.87 },
            Zone = "los_santos"
        },
        Garagem_59 = {  
            GaragePoint = { x =  -2220.95, y = 4227.34, z = 46.50 },                          
            SpawnPoint =  { x =  -2221.77, y = 4235.83, z = 47.05, h = 314.70 },
            DeletePoint = { x =  -2221.77, y = 4235.83, z = 46.05 },
            Zone = "los_santos"
        },
        Garagem_60 = {  
            GaragePoint = { x =  -1532.27, y = -554.10, z = 32.42 },                          
            SpawnPoint =  { x =  -1520.60, y = -555.15, z = 33.22, h = 303.29 },
            DeletePoint = { x =  -1520.60, y = -555.15, z = 32.22 },
            Zone = "los_santos"
        },
        Garagem_61 = {  
            GaragePoint = { x =  -518.86, y = 44.61, z = 51.58 },                          
            SpawnPoint =  { x =  -528.42, y = 47.27, z = 52.58, h = 349.02 },
            DeletePoint = { x =  -528.42, y = 47.27, z = 51.58 },
            Zone = "los_santos"
        },
        Garagem_62 = {  
            GaragePoint = { x =  -1650.94, y = -239.59, z = 53.98 },                          
            SpawnPoint =  { x =  -1653.78, y = -246.32, z = 54.88, h = 251.01 },
            DeletePoint = { x =  -1653.78, y = -246.32, z = 53.88 },
            Zone = "los_santos"
        },
        Garagem_63 = {  
            GaragePoint = { x =  -1679.62, y = 497.03, z = 129.08 },                          
            SpawnPoint =  { x =  -1677.84, y = 489.35, z = 128.88, h = 300.09 },
            DeletePoint = { x =  -1677.84, y = 489.35, z = 127.88 },
            Zone = "los_santos"
        },
        Garagem_64 = {  
            GaragePoint = { x =  2048.44, y = 3446.87, z = 42.79 },                          
            SpawnPoint =  { x =  2041.39, y = 3451.30, z = 43.86, h = 117.61 },
            DeletePoint = { x =  2041.39, y = 3451.30, z = 42.86 },
            Zone = "los_santos"
        },
    }



    self.CarPounds = { -- Apreendidos -- (-1)
        Pound_1 = {
            PoundPoint = { x = 1894.32, y = 3715.09, z = 31.76 },                    
            SpawnPoint = { x = 1884.74, y = 3715.49, z = 32.92, h = 25.75},
            Zone = "los_santos"
        },
        Pound_3 = {
            PoundPoint = { x = 1180.77, y = -1535.62, z = 38.40 },                      
            SpawnPoint = { x = 1200.91, y = -1540.74, z = 38.40, h = 88.52 },     
            Zone = "los_santos"
        },
        Pound_4 = {
            PoundPoint = { x = 1033.95, y = -767.58, z = 57.00 },                      
            SpawnPoint = { x = 1040.56, y = -776.43, z = 57.02, h = 1.51 },     
            Zone = "los_santos"
        },
        Pound_5 = {
            PoundPoint = { x = 369.42, y = -1607.53, z = 28.29 },                      
            SpawnPoint = { x = 388.93, y = -1623.05, z = 28.29, h = 317.37 },     
            Zone = "los_santos"
        },
        Pound_6 = { -- Principal
            PoundPoint = { x = 44.40, y = -842.17, z = 30.14 },                      
            SpawnPoint = { x = 45.99, y = -851.97, z = 29.75, h = 338.29 },     
            Zone = "los_santos"
        },
        Pound_7 = { 
            PoundPoint = { x = -1057.82, y = -840.90, z = 4.04 },                      
            SpawnPoint = { x = -1047.34, y = -852.41, z = 3.87, h = 127.23 },     
            Zone = "los_santos"
        },
        Pound_8 = { 
            PoundPoint = { x = 1898.46, y = 2605.38, z = 44.97 },                      
            SpawnPoint = { x = 1900.80, y = 2610.03, z = 44.74, h = 260.96 },     
            Zone = "los_santos"
        },
        Pound_9 = { 
            PoundPoint = { x = -449.53, y = 6053.29, z = 30.34 },                      
            SpawnPoint = { x = -446.30, y = 6048.37, z = 30.34, h = 219.08 },     
            Zone = "los_santos"
        },
        Pound_11 = { 
            PoundPoint = { x = 4435.18, y = -4484.46, z = 3.30 },                      
            SpawnPoint = { x = 4438.70, y = -4491.69, z = 3.21, h = 283.89 },     
            Zone = "cayoperico"
        },
    }

    self.BoatGarages = { -- (-1)
        Garage_1 = {
            GaragePoint = { x = 73.80, y = -2256.16, z = 5.08 },
            SpawnPoint =  { x = 78.36, y = -2280.90, z = 0.10, h = 95.80 },  
            DeletePoint = { x = 78.36, y = -2280.90, z = 0.10 },
            Zone = "los_santos"
        },
        Garage_2 = {
            GaragePoint = { x = 13.88, y = -2800.19, z = 1.53 },
            SpawnPoint =  { x = 12.79, y = -2833.09, z = 0.20, h = 181.90 },  
            DeletePoint = { x = 12.79, y = -2833.09, z = 0.20 },
            Zone = "los_santos"
        },
        Garage_3 = {
            GaragePoint = { x = 4930.05, y = -5145.78, z = 1.46 },
            SpawnPoint =  { x = 4908.22, y = -5141.77, z = 0.10, h = 66.39 },  
            DeletePoint = { x = 4908.22, y = -5141.77, z = 0.10 },
            Zone = "cayoperico"
        },
        Garage_4 = {
            GaragePoint = { x = 1387.32, y = 3775.96, z = 30.09 },
            SpawnPoint =  { x = 1364.90, y = 3790.23, z = 30.00, h = 25.00 },  
            DeletePoint = { x = 1364.90, y = 3790.23, z = 30.00 },
            Zone = "los_santos"
        },
        Garage_7 = {
            GaragePoint = { x = -1605.00, y = 5257.36, z = 1.08 },
            SpawnPoint =  { x = -1588.33, y = 5266.53, z = 0.10, h = 39.30 },  
            DeletePoint = { x = -1588.33, y = 5266.53, z = 0.10 },
            Zone = "los_santos"
        },
    }

    self.BoatPounds = { -- Apreendidos -- (-1)
        Pound_B1 = {
            PoundPoint = { x = 181.81, y = -2256.11, z = 5.08 },
            SpawnPoint = { x = 170.58, y = -2281.51, z = 0.10, h = 96.80 }, 
            Zone = "los_santos"
        },
        Pound_B2 = {
            PoundPoint = { x = 23.90, y = -2807.73, z = 4.70 },
            SpawnPoint = { x = 12.79, y = -2833.09, z = 0.20, h = 181.90 }, 
            Zone = "los_santos"
        },
        Pound_B3 = {
            PoundPoint = { x = 4928.53, y = -5173.65, z = 1.44 },
            SpawnPoint = { x = 4908.22, y = -5141.77, z = 0.10, h = 66.39 }, 
            Zone = "cayoperico"
        },
        Pound_B4 = {
            PoundPoint = { x = 1520.39, y = 3941.07, z = 30.19 },
            SpawnPoint = { x = 1529.80, y = 3961.52, z = 29.50, h = 1.50 }, 
            Zone = "los_santos"
        },
    }

    self.AircraftGarages = { -- (-1)
        Garagem_1 = {
            GaragePoint = { x = -1173.50, y = -2834.42, z = 12.95 },
            SpawnPoint =  { x = -1178.33, y = -2845.81, z = 12.95, h = 150.29 },      
            DeletePoint = { x = -1178.33, y = -2845.81, z = 12.95 },
            Zone = "los_santos"
        },
        Garagem_2 = {
            GaragePoint = { x = -718.28, y = -1436.40, z = 4.00 },
            SpawnPoint =  { x = -724.31, y = -1443.52, z = 4.00, h = 138.79 },      
            DeletePoint = { x = -724.31, y = -1443.52, z = 4.00 },
            Zone = "los_santos"
        },
        Garagem_3 = {
            GaragePoint = { x = 4065.60, y = -4692.19, z = 3.17 },
            SpawnPoint =  { x = 4061.30, y = -4679.14, z = 3.18, h = 21.57 },      
            DeletePoint = { x = 4061.30, y = -4679.14, z = 3.18 },
            Zone = "cayoperico"
        },
        Garagem_4 = {
            GaragePoint = { x = 1437.46, y = 3736.89, z = 32.23 },
            SpawnPoint =  { x = 1427.09, y = 3730.79, z = 31.97, h = 198.20 },      
            DeletePoint = { x = 1427.09, y = 3730.79, z = 31.97 },
            Zone = "los_santos"
        },
        Garagem_6 = {
            GaragePoint = { x = 2123.33, y = 4785.09, z = 39.97 },
            SpawnPoint =  { x = 2134.88, y = 4811.10, z = 40.20, h = 114.85 },      
            DeletePoint = { x = 2134.88, y = 4811.10, z = 40.20 },
            Zone = "los_santos"
        },
       }

    self.AircraftPounds = { -- Apreendidos -- (-1)
        Pound_A1 = {
            PoundPoint = { x = -1140.40, y = -2854.36, z = 12.95 },                
            SpawnPoint = { x = -1146.05, y = -2864.35, z = 12.95, h = 148.24 },
            Zone = "los_santos"
        },
        Pound_A2 = {
            PoundPoint = { x = -751.16, y = -1475.33, z = 4.00 },                
            SpawnPoint = { x = -745.35, y = -1468.73, z = 4.00, h = 315.58 },
            Zone = "los_santos"
        },
        Pound_A3 = {
            PoundPoint = { x = 4895.05, y = -5722.08, z = 25.35 },                
            SpawnPoint = { x = 4890.26, y = -5736.92, z = 25.35, h = 161.92 },
            Zone = "cayoperico"
        },
        Pound_A4 = {
            PoundPoint = { x = 1761.70, y = 3237.29, z = 41.08 },
            SpawnPoint = { x = 1770.78, y = 3239.81, z = 41.14, h = 281.86 }, 
            Zone = "los_santos"
        },
    }

    return self
end
