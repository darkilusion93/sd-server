function LoadRubber()
    local self = {}

    self.jobName = "rubber"

    self.extractionLocations = {
        vector3(-674.80, 5698.15, 28.39),
        vector3(-656.88, 5667.32, 33.17),
        vector3(-695.33, 5661.45, 31.19),
        vector3(-669.96, 5636.87, 34.60),
        vector3(-670.65, 5626.46, 33.63),
    }

    self.cloakRoomLocation = {
        vector3(-773.35, 5597.96, 33.61),
        vector3(1054.61, -1952.8, 32.09),
    }

    self.vulcanizationLocation = {
        vector3(1088.71, -2001.01, 30.88),
    }

    self.sellLocation = {
      --  vector3(84.79, -1598.61, 31.08),
    }

    self.rubberBlips = {
        { title = T("RUBBERJOB_VULCANIZATION"),    colour = 17, id = 365, x = 1109.03, y = -2007.61,  z = 30.94, scale = 0.5},
        { title = T("RUBBERJOB_LATEX_COLLECTION"), colour = 11, id = 415, x = -695.33, y = 5661.45,   z = 31.19, scale = 0.5},
        { title = T("RUBBERJOB_CLOAKROOM"),        colour = 2,  id = 280, x = -773.35, y = 5597.96,   z = 33.61, scale = 0.5},
        { title = T("RUBBERJOB_CLOAKROOM"),        colour = 2,  id = 280, x = 1054.61, y = -1952.8,   z = 32.09, scale = 0.5},
        { title = T("RUBBERJOB_SELLING_LOCATION"), colour = 25, id = 500, x =   64.49, y = -1590.37, z = 29.60, scale = 0.8},
    }

    self.extraction = {
        item = "latex",
        count = 1,
        time = 2500,
    }

    self.vulcanization = {
        rubber = {
            input = {
                { item = "latex", count = 1 },
            },
            output = { item = "rubber", count = 1 },
            time = 1000,
        },
        synthetic_leather = {
            input = {
                { item = "latex", count = 10 },
                { item = "rubber", count = 10 }
            },
            output = { item = "synthetic_leather", count = 1 },
            time = 3000,
        }
    }

    self.selling = {
       -- rubber = {
        --    item = "rubber",
         --   price = 20,
      --  },
        --synthetic_leather = {
        --    item = "synthetic_leather",
        --    price = 100,
        --}
    }

    return self
end