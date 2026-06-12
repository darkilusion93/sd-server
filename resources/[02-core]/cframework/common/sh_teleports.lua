function LoadTeleporters()
    local self = {}

    self.Teleporters = {
        ['hospital'] = {
            Job = 'none',
            Enter = { x = -801.53, y = -1251.83, z = 7.34 },
            Exit = { x = -773.35, y = -1206.75, z = 51.15 }
        },
        ['segurancas'] = {
            Job = 'none',
            Enter = { x = -117.41, y = -605.87, z = 36.28 },
            Exit = { x = -77.70, y = -829.92, z = 243.39 }
        },
        ['seguranca'] = {
            Job = 'none',
            Enter = { x = -136.65, y = -596.24, z = 206.92 },
            Exit = { x = -76.89, y = -826.44, z = 243.39 }
        },
        ['casinoatlantisrooftop'] = {
            Job = 'none',
            Enter = { x = -1496.64, y = -593.47, z = 67.52 },
            Exit = { x = -1524.50, y = -591.04, z = 31.28 }
        },
        ['elevadoroficina'] = {
            Job = 'none',
            Enter = { x = -303.87, y = -136.16, z = 57.86 },
            Exit = { x = -303.96, y = -136.30, z = 40.35 }
        },
    }


    return self
end