Config.Stations["realestateagent"] = {
    MaxMembers = -1,
    JobName = "⚖️ Tribunal",
    JobGrades = {
        ["0"] = {grade = 0, name = "location", label = "Advogado Estagiário", salary = 5000, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "location", label = "Advogado", salary = 6000, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "vendeur", label = "Advogado-Chefe", salary = 7000, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "vendeur", label = "Juiz Estagiário", salary = 8000, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "gestion", label = "Juiz", salary = 9000, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "boss", label = "Juiz-Presidente", salary = 10000, skin_male = {}, skin_female = {}},
    },
    MobileAction = { {value = 'billing', nome = 'Multa'}, {value = 'handcuff'}, {value = 'search'} },
    CanBossCreateRaces = false, BuyMenu = {}, AuthorizedCrafts = {}, Duty = {}, Cloakrooms = {}, Armories = {}, Special = {}, Vehicles = {}, Helicopters = {}, Boats = {}, VehicleDeleters = {}, CanBossAddCars = false, BossActions = {}, Doors = {}
}