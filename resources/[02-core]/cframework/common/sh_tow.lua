function LoadTow()
    local self = {}

    self.allowedTowModels = {
        ["flatbed"] = {x = 0.0, y = -0.85, z = 1.25}, -- default GTA V flatbed
    }

    self.cloakRoomLocation = {
        {x = -429.07, y = -1728.11, z = 19.78},
        {x = 1360.81, y = 3604.14, z = 34.96},
        {x = -195.78, y = 6264.92, z = 31.49},
    }

    self.vehicleSpawnLocation = {
        {x = -427.79, y = -1708.60, z = 19.15, h = 247.11},
        {x = 1351.15, y = 3589.29, z = 34.89, h = 188.75},
        {x = -191.00, y = 6298.46, z = 31.49, h = 44.83},
    }

    self.vehicleDeleteLocation = {
        {x = -424.17, y = -1684.40, z = 19.03},
        {x = 1369.79, y = 3595.46, z = 34.89},
        {x = -198.18, y = 6271.91, z = 31.49},
    }

    self.towBlips = {
        {title = "Vestuário Reboque", colour = 5, id = 280, x = -429.07, y = -1728.11, z = 19.78, scale = 0.5},
        {title = "Vestuário Reboque", colour = 5, id = 280, x = 1360.81, y = 3604.14, z = 34.96, scale = 0.5},
        {title = "Vestuário Reboque", colour = 5, id = 280, x = -195.78, y = 6264.92, z = 31.49, scale = 0.5},
    }

    return self
end