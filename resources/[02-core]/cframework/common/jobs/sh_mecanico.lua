Config.Stations["mechanic"] = {
    MaxMembers = -1,
    JobName = "&#128295; Mecânico",
    JobGrades = {
        ["0"] = {grade = 0, name = "recruit", label = "Estagiário", salary = 1200, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "novice", label = "Mecânico", salary = 1600, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "master", label = "Oficial", salary = 2100, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "subchief", label = "Sub-Chefe", salary = 2600, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "chief", label = "Chefe", salary = 3100, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Patrão", salary = 4000, skin_male = {}, skin_female = {}},
    },
    MobileAction = {
        {value = 'billing', nome = 'Oficina'},
        {value = 'repair'},
        {value = 'clean'},
        {value = 'impound'},
    },
    Tunning = {
        {
            coords = vector3( 603.6754, -147.2406, 53.5224),
            illegal = false,
            isMotoclub = false,
            isNautica = false,
        },
    },
    CanBossCreateRaces = false,
    BuyMenu = {},
    AuthorizedCrafts = {},
    Duty = {},
    Cloakrooms = {},
    Armories = {},
    Special = {},
    Vehicles = {},
    Helicopters = {},
    Boats = {},
    VehicleDeleters = {},
    CanBossAddCars = false,
    BossActions = {},
    Doors = {}
}

Config.Stations["offmechanic"] = {
    MaxMembers = -1,
    JobName = "&#128295; Mecânico (Fora de Serviço)",
    JobGrades = {
        ["0"] = {grade = 0, name = "recruit", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "novice", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "master", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "subchief", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "chief", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
    },
    MobileAction = {},
    Cloakrooms = {},
    Armories = {},
    Special = {},
    Vehicles = {},
    Helicopters = {},
    VehicleDeleters = {},
    BossActions = {}
}