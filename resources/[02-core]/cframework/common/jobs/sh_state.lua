Config.Stations["state"] = {
    MaxMembers = -1,
    JobName = "🌐 Estado",
    JobGrades = {
        ["2"] = {grade = 2, name = "soldato", label = "Oficial de Justiça", salary = 10000, skin_male = {}, skin_female = {}},
    },
    MobileAction = { {value = 'billing', nome = 'Multa'}, {value = 'handcuff'}, {value = 'search'} },
    CanBossCreateRaces = false, BuyMenu = {}, AuthorizedCrafts = {}, Duty = {}, Cloakrooms = {}, Armories = {}, Special = {}, Vehicles = {}, Helicopters = {}, Boats = {}, VehicleDeleters = {}, CanBossAddCars = false, BossActions = {}, Doors = {}
}

Config.Stations["offstate"] = {
    MaxMembers = -1,
    JobName = "🌐 Fora de Serviço",
    JobGrades = {
        ["0"] = {grade = 0, name = "soldato", label = "Oficial de Justiça", salary = 10000, skin_male = {}, skin_female = {}},
    },
    MobileAction = { {value = 'billing', nome = 'Multa'}, {value = 'handcuff'}, {value = 'search'} },
    CanBossCreateRaces = false, BuyMenu = {}, AuthorizedCrafts = {}, Duty = {}, Cloakrooms = {}, Armories = {}, Special = {}, Vehicles = {}, Helicopters = {}, Boats = {}, VehicleDeleters = {}, CanBossAddCars = false, BossActions = {}, Doors = {}
}