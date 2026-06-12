Config.Stations["sheriff"] = {
    MaxMembers = -1,
    JobName = "&#128130; GNR",
    JobGrades = {
        ["0"] = {grade = 0, name = "guarda", label = "Guarda", salary = 1500, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "cabo", label = "Cabo", salary = 2000, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "alferes", label = "Alferes", salary = 2500, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "tenente", label = "Tenente", salary = 3000, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "capitao", label = "Capitão", salary = 3500, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Coronel", salary = 4500, skin_male = {}, skin_female = {}},
    },
    MobileAction = {
        {value = 'billing', nome = 'Multa'},
        {value = 'handcuff'},
        {value = 'search'},
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

Config.Stations["offsheriff"] = {
    MaxMembers = -1,
    JobName = "&#128130; GNR (Fora de Serviço)",
    JobGrades = {
        ["0"] = {grade = 0, name = "guarda", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "cabo", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "alferes", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "tenente", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "capitao", label = "Fora de Serviço", salary = 0, skin_male = {}, skin_female = {}},
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