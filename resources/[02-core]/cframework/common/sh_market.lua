function LoadMarket()
    local self = {}

    self.vaultLocation = {
        { x = 271.26, y = 7.27, z = 79.25, vaultId = "market_vault" },
        --{ x = 5117.86, y = -5190.84, z = 2.38, vaultId = "market_vault_cayo" },
    }

    self.marketCenter = {
        vector3(389.37, -355.57, 48.02),
        --vector3(5059.24, -5053.25, -0.47),
    }
    self.centerRadius = 40.0

    self.marketShops = {
        { x = 375.74, y = -362.85, z = 46.82, id = "shop1", vaultId = "market_vault", illegal = false },
        { x = 381.57, y = -367.95, z = 46.84, id = "shop2", vaultId = "market_vault", illegal = false },
        { x = 368.02, y = -367.50, z = 46.68, id = "shop3", vaultId = "market_vault", illegal = false },
        { x = 389.03, y = -369.17, z = 46.68, id = "shop4", vaultId = "market_vault", illegal = false },
        { x = 407.50, y = -357.69, z = 46.85, id = "shop5", vaultId = "market_vault", illegal = false },
        { x = 406.87, y = -349.62, z = 46.85, id = "shop6", vaultId = "market_vault", illegal = false },
        { x = 397.19, y = -345.13, z = 46.85, id = "shop7", vaultId = "market_vault", illegal = false },
        { x = 386.78, y = -342.39, z = 46.81, id = "shop8", vaultId = "market_vault", illegal = false },

        --{ x = 5039.19, y = -5063.93, z = 2.22, id = "cayo_shop1", vaultId = "market_vault_cayo", illegal = true },
    }

    self.rentPrice = 10000
    self.rentTime = 3600 -- 1h
    self.closeTimer = 280 -- 4min 40s (So it closes after 5 minutes of inactivity with 30 second checks)
    self.maxSalePrice = 10000000

    self.policeJob = "police"
    self.policeGrade = 6

    self.minPrices = {
        ["WEAPON_STUNGUN"] = 5000,
        ["WEAPON_PISTOL"] = 15000,
        ["WEAPON_VINTAGEPISTOL"] = 15000,
        ["WEAPON_SNSPISTOL"] = 10000,
        ["WEAPON_PUMPSHOTGUN"] = 30000,
        ["WEAPON_BULLPUPSHOTGUN"] = 40000,
        ["WEAPON_GUSENBERG"] = 50000,


        ["WEAPON_MINISMG"] = 30000,
        ["WEAPON_MICROSMG"] = 70000,
        ["WEAPON_PISTOLXM3"] = 30000,
        ["WEAPON_MACHINEPISTOL"] = 70000,
        ["WEAPON_TECPISTOL"] = 80000,
        ["WEAPON_APPISTOL"] = 80000,
        ["WEAPON_COMPACTRIFLE"] = 150000,
        ["WEAPON_HEAVYPISTOL"] = 100000,
        ["WEAPON_PISTOL50"] = 150000,
        ["WEAPON_ASSAULTSMG"] = 150000,
        ["WEAPON_COMBATPDW"] = 150000,
        ["WEAPON_ASSAULTRIFLE"] = 190000,
        ["WEAPON_BULLPUPRIFLE"] = 190000,
        ["WEAPON_SPECIALCARBINE"] = 210000,
        ["WEAPON_GADGETPISTOL"] = 250000,
        ["WEAPON_DOUBLEACTION"] = 280000,

        ["weapon_body"] = 50000,
        ["weapon_body2"] = 10000,
        ["weapon_body3"] = 80000,
        ["weapon_body4"] = 120000,
    }

    self.maxPrices = {
        ["bradio"] = 30,
        ["btel"] = 30,
        ["scrap"] = 40,
        ["coal"] = 36,
        ["wood_plank_cherry"] = 40,
        ["wwood_plank_oak"] = 50,
        ["wood_plank_pine"] = 30,
        ["wood_plank_ebony"] = 200,
        ["recicled_plastic"] = 40,
        ["rubber"] = 70,
        ["iron"] = 70,
        ["fabric"] = 70,
        ["copper"] = 70,
        ["electronic_waste"] = 30,
        ["gunpowder"] = 100,
        ["kevlar"] = 600,
        ["paper"] = 100,
        ["leather"] = 1500,
        ["steel"] = 1000,
    }

    return self
end
