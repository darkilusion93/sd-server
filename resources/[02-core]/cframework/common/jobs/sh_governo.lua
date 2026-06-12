Config.Stations["governo"] = {
    MaxMembers = -1,
    JobName = "&#127963 Governo",
    JobGrades = {
        ["0"] =  {grade = 0,  name = "soldato", label = "Segurança",                          salary = 2700,  skin_male = {}, skin_female = {}},
        ["1"] =  {grade = 1,  name = "soldato", label = "Chefe de Segurança",                 salary = 5000,  skin_male = {}, skin_female = {}},
        ["2"] =  {grade = 2,  name = "soldato", label = "Secretário",                         salary = 7500,  skin_male = {}, skin_female = {}},
        ["3"] =  {grade = 3,  name = "soldato", label = "Secretário de Estado Adj e Justiça", salary = 10500, skin_male = {}, skin_female = {}},
        ["4"] =  {grade = 4,  name = "soldato", label = "Ministro das Finanças",              salary = 12500, skin_male = {}, skin_female = {}},
        ["5"] =  {grade = 5,  name = "soldato", label = "Ministro da Saúde",                  salary = 12500, skin_male = {}, skin_female = {}},
        ["6"] =  {grade = 6,  name = "soldato", label = "Ministro do Trabalho",               salary = 12500, skin_male = {}, skin_female = {}},
        ["7"] =  {grade = 7,  name = "soldato", label = "Ministro da Justiça",                salary = 15000, skin_male = {}, skin_female = {}},
        ["8"] =  {grade = 8,  name = "soldato", label = "Diretor Nacional",                   salary = 13000, skin_male = {}, skin_female = {}},
        ["9"] =  {grade = 9,  name = "boss",    label = "Primeiro Ministro",                  salary = 18000, skin_male = {}, skin_female = {}},
        ["10"] = {grade = 10, name = "boss",    label = "Presidente ",                        salary = 20000, skin_male = {}, skin_female = {}},
    },

    MobileAction = {
        {value = 'billing', nome = 'Governo'},
        {value = 'unpaid_bills'},
    },

    CanBossCreateRaces = false,

    AuthorizedCrafts = {
    },

    Cloakrooms = {
        { x = 213.68, y = -391.08, z = 46.92 },
    },

    Armories = {
        { x = 220.96, y = -394.34, z = 46.92 },
    },

    Vehicles = {
        {
            Spawner    = { x = 214.30, y = -460.25, z = 35.24 },
            SpawnPoint = { x = 214.04, y = -450.43, z = 36.24 },
            Heading    = 157.46,
        }
    },

    Helicopters = {
     -- {
      --  Spawner    = { x = 327.31, y = -603.37, z = 42.0 },
      --  SpawnPoint = { x = 351.04, y = -587.43, z = 125.17 },
      --  Heading    = 90.98,
     -- }
    },

    Boats = {
    },

    VehicleDeleters = {
        { x = 210.84, y = -438.23, z = 35.24},
    },

    CanBossAddCars = true,

    BossActions = {
        { x = 211.10, y = -391.62, z = 46.92 },
    },

    Doors = {
         {
            model       = -770041648,
            coords      = vector3(189.636688, 449.658264, 38.115345),
            lock        = true,
            job         = {'tribunal','governo'}
        },
         {
            model       = 512695579,
            coords      = vector3(250.440994, -434.040710, 42.961369),
            lock        = true,
            job         = {'tribunal','governo'}
        },
         {
            model       = -529120688,
            coords      = vector3(246.247467, -432.988617, 48.072491),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(244.945175, -421.488190, 48.075489),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(244.304810, -423.247650, 48.075489),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(231.211060, -426.331696, 48.073696),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(229.452545, -425.691650, 48.073696),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(221.575043, -414.975159, 48.075718),
            lock        = true,
            job         = {'tribunal','governo'}
        },
        {
            model       = -622379819,
            coords      = vector3(222.215118, -413.216583, 48.075718),
            lock        = true,
            job         = {'tribunal','governo'}
        },
    }
}