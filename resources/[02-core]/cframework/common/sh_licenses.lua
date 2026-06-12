function LoadLicenses()
    local self = {}

    self.licenses = {
        { type = "dmv",         label = T("LICENSE_DMV")            },
        { type = "drive",       label = T("LICENSE_DRIVE")          },
        { type = "drive_bike",  label = T("LICENSE_DRIVE_BIKE")     },
        { type = "drive_truck", label = T("LICENSE_DRIVE_TRUCK")    },
        { type = "weapon",      label = T("LICENSE_WEAPON")         },
        { type = "pesca",       label = T("LICENSE_PESCA")          },
        { type = "advogado",    label = T("LICENSE_ADVOGADO")       },
        { type = "hunt",        label = T("LICENSE_HUNT")           },
        { type = "weapon_hunt", label = T("LICENSE_WEAPON_HUNT")    },
        { type = "boat",        label = T("LICENSE_BOAT")           },
        { type = "aircraft",    label = T("LICENSE_AIRCRAFT")       },
    }

    return self
end