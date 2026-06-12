Config.Stations["ranger"] = {
    MaxMembers = -1,
    JobName = "&#9875; Polícia Marítima",
    JobGrades = {
        ["0"] = {grade = 0, name = "recruta", label = "Recruta", salary = 1500, skin_male = {}, skin_female = {}},
        ["1"] = {grade = 1, name = "guarda", label = "Guarda Marítimo", salary = 2000, skin_male = {}, skin_female = {}},
        ["2"] = {grade = 2, name = "subchefe", label = "Sub-Chefe", salary = 2600, skin_male = {}, skin_female = {}},
        ["3"] = {grade = 3, name = "chefe", label = "Chefe", salary = 3200, skin_male = {}, skin_female = {}},
        ["4"] = {grade = 4, name = "boss", label = "Comandante", salary = 4200, skin_male = {}, skin_female = {}},
    },
    MobileAction = {
        {value = 'billing', nome = 'Multa'},
        {value = 'handcuff'},
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