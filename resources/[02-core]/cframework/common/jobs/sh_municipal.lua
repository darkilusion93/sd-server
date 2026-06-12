Config.Stations["municipal"] = {
    MaxMembers = -1,
    JobName = "🚔 Polícia Municipal",
    JobGrades = {
        ["0"] = {grade = 0, name = "soldato", label = "Agente Estagiário", salary = 800, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "soldato", label = "Agente Municipal de 3ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "soldato", label = "Agente Municipal de 2ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "soldato", label = "Agente Municipal de 1ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "soldato", label = "Agente Graduado", salary = 800, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "soldato", label = "Agente Graduado Principal", salary = 800, skin_male = {}, skin_female = {}},
        ["6"] = {grade = 6, name = "soldato", label = "Agente Graduado-Coordenador", salary = 0, skin_male = {}, skin_female = {}},
        ["7"] = {grade = 7, name = "boss", label = "2º Comandante Adj.", salary = 0, skin_male = {}, skin_female = {}},
        ["8"] = {grade = 8, name = "boss", label = "2º Comandante", salary = 0, skin_male = {}, skin_female = {}},
        ["9"] = {grade = 9, name = "boss", label = "1º Comandante", salary = 0, skin_male = {}, skin_female = {}},
    },
    MobileAction = { {value = 'billing', nome = 'Multa'}, {value = 'handcuff'}, {value = 'search'} },
    CanBossCreateRaces = false, BuyMenu = {}, AuthorizedCrafts = {}, Duty = {}, Cloakrooms = {}, Armories = {}, Special = {}, Vehicles = {}, Helicopters = {}, Boats = {}, VehicleDeleters = {}, CanBossAddCars = false, BossActions = {}, Doors = {}
}

Config.Stations["offmunicipal"] = {
    MaxMembers = -1,
    JobName = "🚔 Fora de Serviço",
    JobGrades = {
        ["0"] = {grade = 0, name = "soldato", label = "Agente Estagiário", salary = 800, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "soldato", label = "Agente Municipal de 3ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "soldato", label = "Agente Municipal de 2ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "soldato", label = "Agente Municipal de 1ª Classe", salary = 800, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "soldato", label = "Agente Graduado", salary = 800, skin_male = {}, skin_female = {}},
        ["5"] = {grade = 5, name = "soldato", label = "Agente Graduado Principal", salary = 800, skin_male = {}, skin_female = {}},
        ["6"] = {grade = 6, name = "soldato", label = "Agente Graduado-Coordenador", salary = 0, skin_male = {}, skin_female = {}},
        ["7"] = {grade = 7, name = "boss", label = "2º Comandante Adj.", salary = 0, skin_male = {}, skin_female = {}},
        ["8"] = {grade = 8, name = "boss", label = "2º Comandante", salary = 0, skin_male = {}, skin_female = {}},
        ["9"] = {grade = 9, name = "boss", label = "1º Comandante", salary = 0, skin_male = {}, skin_female = {}},
    },
    MobileAction = { {value = 'billing', nome = 'Multa'}, {value = 'handcuff'}, {value = 'search'} },
    CanBossCreateRaces = false, BuyMenu = {}, AuthorizedCrafts = {}, Duty = {}, Cloakrooms = {}, Armories = {}, Special = {}, Vehicles = {}, Helicopters = {}, Boats = {}, VehicleDeleters = {}, CanBossAddCars = false, BossActions = {}, Doors = {}
}