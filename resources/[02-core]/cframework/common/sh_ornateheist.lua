

function LoadOrnateHeist()
    local self = {}

    self.minCops = 10
    self.robberyCooldown = 3600 * 3 -- 3 Hours

    self.thermalChargeDoors = {
        ["main"] = {
            loc = vector4(257.40, 220.20, 106.35, 336.48),
            ptfx = vector3(257.39, 221.20, 106.29),
            oldmodel = "hei_v_ilev_bk_gate_pris",
            newmodel = "hei_v_ilev_bk_gate_molten",
            doorName = "ornateheistmain",
            rotplus = 0.0,
            method = 1
        },
        ["inside1"] = {
            loc = vector4(252.95, 220.70, 101.76, 160.0),
            ptfx = vector3(252.985, 221.70, 101.72),
            oldmodel = "hei_v_ilev_bk_safegate_pris",
            newmodel = "hei_v_ilev_bk_safegate_molten",
            doorName = "ornateheistinside1",
            rotplus = 170.0,
            method = 2
        },
        ["inside2"] = {
            loc = vector4(261.65, 215.60, 101.76, 252.0),
            ptfx = vector3(261.68, 216.63, 101.75),
            oldmodel = "hei_v_ilev_bk_safegate_pris",
            newmodel = "hei_v_ilev_bk_safegate_molten",
            doorName = "ornateheistinside2",
            rotplus = 270.0,
            method = 3
        }
    }

    self.zipTies = {
        ["main"] = {
            loc = vector4(232.098, 215.356, 106.345, -65.0),
            door1 = "principalbank1",
            door2 = "principalbank2",
        },
        ["alternate1"] = {
            loc = vector4(259.492, 214.040, 106.348, 250.313),
            door1 = "principalbank3",
            door2 = "principalbank4",
        },
        ["alternate2"] = {
            loc = vector4(259.440, 203.696, 106.346, -20.356),
            door1 = "principalbank5",
            door2 = "principalbank6",
        }
    }

    self.cashCart = {
        vector4(257.44, 215.07, 100.68, 0.0),
        vector4(262.34, 213.28, 100.68, 0.0),
        vector4(263.45, 216.05, 100.68, 150.0)
    }

    self.rouletteWords = {
        "DESTINO",
        "ABSOLUTE",
        "ISTANBUL",
        "DOCTRINE",
        "IMPERIUS",
        "DELIRIUM",
        "MAETHRIL"
    }

    self.hackableDoors = {
        ["stairs"] = vector4(262.65, 222.75, 105.94, 244.19),
        ["vault"] = vector4(253.34, 228.25, 101.39, 63.60)
    }

    self.hackableDoorNames = {
        ["stairs"] = "ornateheiststairs",
        ["vault"] = "ornateheistvault"
    }

    return self
end