function LoadBoosting()
    local self = {}

    self.towVehicle = `towtruck2`
    self.dismantleCargoVehicle = `scrap`
    self.containerObject = `tr_prop_tr_container_01a`
    self.lockObject = `tr_prop_tr_lock_01a`

    self.dismantleVehicleBlipSprite = 225
    self.dismantleVehicleBlipColor = 1
    self.dismantleVehicleBlipScale = 1.0

    self.findDismantleSpotBlipSprite = 225
    self.findDismantleSpotBlipColor = 1
    self.findDismantleSpotBlipScale = 1.0

    self.deliverEngineBlipSprite = 225
    self.deliverEngineBlipColor = 1
    self.deliverEngineBlipScale = 1.0

    self.deliverPlateBlipSprite = 225
    self.deliverPlateBlipColor = 1
    self.deliverPlateBlipScale = 1.0

    self.deliverVehicleBlipSprite = 225
    self.deliverVehicleBlipColor = 1
    self.deliverVehicleBlipScale = 1.0

    self.findContainerBlipRadius = 100.0
    self.findContainerBlipColor = 1

    self.findTowBlipRadius = 100.0
    self.findTowBlipColor = 1

    self.findVehicleBlipRadius = 100.0
    self.findVehicleBlipColor = 1

    self.missions = {
        ["rob_vehicle"] = {
            label = "Roubar Veículo",
            steps = {
                "find_vehicle",
                "deliver_vehicle",
            }
        },
        ["rob_plate"] = {
            label = "Roubar Matrícula",
            steps = {
                "find_vehicle",
                "steal_plate",
                "deliver_plate",
            }
        },
        ["rob_engine"] = {
            label = "Roubar Motor",
            steps = {
                "find_vehicle",
                "steal_engine",
                "deliver_engine",
            }
        },
        ["tow_vehicle"] = {
            label = "Rebocar Veículo",
            steps = {
                "find_tow",
                "find_vehicle",
                "deliver_vehicle",
            }
        },
        ["dismantle_vehicle"] = {
            label = "Desmantelar Veículo",
            steps = {
                "find_vehicle",
                "find_dismantle_spot",
                "dismantle_vehicle",
                "deliver_dismantled_vehicle",
            }
        },
        --["steal_vehicle_cargo"] = {
        --    label = "Roubar Veículo de Contentor",
        --    steps = {
        --        "find_container",
        --        "open_container",
        --        "deliver_vehicle",
        --    }
        --},
    }

    self.vehicles = {
        ["low"] = {
            "brioso",
        },
        ["boat"] = {
            "jetmax",
        },
    }

    self.vehiclesLabels = {
        ["low"] = "Classe A",
        ["boat"] = "Barco",
    }

    self.locations = {
        ["los_santos_vehicle_spawners"] = {
            vector4(26.21, -1072.86, 37.55, 249.32),
        },
        ["los_santos_tow_spawners"] = {
            vector4(121.27, -1081.79, 28.81, 0.31),
        },
        ["los_santos_vehicle_deliver"] = {
            vector4(29.01, -1314.08, 29.52, 5.96),
        },
        ["los_santos_plate_deliver"] = {
            vector4(284.87, -1005.42, 30.29, 3.82),
        },
        ["los_santos_vehicle_scenario"] = {
            {
                spawn = vector4(117.54, -1221.72, 28.69, 94.35),
                peds = {
                    {model = `s_m_y_robber_01`, coords = vector4(118.09, -1222.82, 29.30, 191.23), scenario = "WORLD_HUMAN_LEANING", weapon = `WEAPON_PISTOL`, --[[anim = "", animDict = ""]]},
                    {model = `s_m_y_robber_01`, coords = vector4(116.90, -1224.27, 29.30, 329.66), scenario = "WORLD_HUMAN_SMOKING", weapon = `WEAPON_PISTOL`},
                },
            },
        },
        ["los_santos_boat_scenario"] = {
            {
                spawn = vector4(2839.09, -665.06, 0.30, 354.66),
                peds = {
                    {model = `s_m_y_robber_01`, coords = vector4(2835.41, -662.58, 1.09, 142.61),  scenario = "WORLD_HUMAN_SMOKING", weapon = `WEAPON_PISTOL`, --[[anim = "", animDict = ""]]},
                    {model = `s_m_y_robber_01`, coords = vector4(2835.13, -666.63, 1.03, 3.34),    scenario = "WORLD_HUMAN_SMOKING", weapon = `WEAPON_PISTOL`},
                    {model = `s_m_y_robber_01`, coords = vector4(2834.33, -675.21, 0.99, 49.80),   scenario = "WORLD_HUMAN_SMOKING", weapon = `WEAPON_PISTOL`},
                },
            },
        },
        ["los_santos_boat_deliver"] = {
            vector4(1.10, -2776.63, 1.28, 95.21),
        },
        ["los_santos_container_spawn"] = {
            {
                container = vector4(899.746, -3086.894, 4.893, -88.43),
                vehicle = vector4(899.746, -3086.894, 4.893, -88.43),
            }
        },
    }

    self.contracts = {
        --["cat_3_boost_2"] = {
        --    level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "steal_vehicle_cargo", pedModel = `s_m_y_robber_01`,
        --    vehicleType = "low", containerSpawn = "los_santos_container_spawn", deliverLocation = "los_santos_vehicle_deliver", requires = {},
        --    rewards = {
        --        coins = 300,
        --    },
        --},
        ["cat_1_boost_1"] = {
            level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "rob_vehicle", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", deliverLocation = "los_santos_vehicle_deliver", requires = {},
            rewards = {
                coins = 20,
            },
        },
        ["cat_3_boost_1"] = {
            level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "dismantle_vehicle", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", dismantleSpotSpawn = "los_santos_tow_spawners", deliverLocation = "los_santos_vehicle_deliver", requires = {},
            rewards = {
                coins = 200,
            },
        },
        ["cat_2_boost_1"] = {
            level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "rob_vehicle", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_scenario", deliverLocation = "los_santos_vehicle_deliver", requires = {},
            rewards = {
                --vehicle = true
                coins = 45,
            },
        },
        ["cat_2_boost_2"] = {
            level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = false, missionType = "rob_vehicle", pedModel = `s_m_y_robber_01`,
            vehicleType = "boat", vehicleSpawn = "los_santos_boat_scenario", deliverLocation = "los_santos_boat_deliver", requires = {},
            rewards = {
                --vehicle = true
                coins = 120,
            },
        },
        ["cat_1_boost_2"] = {
            level = 1, increment = 50, minCops = 0, timer = 3600, vehicleLocked = false, missionType = "rob_plate", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", deliverLocation = "los_santos_plate_deliver",
            requires = {
                items = {
                    {name = "lockpick", count = 1},
                },
                coins = 2,
            },
            rewards = {
                coins = 10,
            },
        },
        ["cat_1_boost_3"] = {
            level = 2, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "rob_plate", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", deliverLocation = "los_santos_plate_deliver",
            requires = {
                items = {
                    {name = "lockpick", count = 1},
                },
                coins = 2,
            },
            rewards = {
                items = {
                    {name = "black_money", minCount = 1500, maxCount = 2500},
                },
                coins = 15,
            },
        },
        ["cat_1_boost_4"] = {
            level = 2, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "rob_engine", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", deliverLocation = "los_santos_vehicle_deliver",
            requires = {
                items = {
                    {name = "lockpick", count = 1},
                },
                coins = 2,
            },
            rewards = {
                items = {
                    {name = "black_money", minCount = 1500, maxCount = 2500},
                },
            },
        },
        ["cat_1_boost_5"] = {
            level = 2, increment = 50, minCops = 0, timer = 3600, vehicleLocked = true, missionType = "tow_vehicle", pedModel = `s_m_y_robber_01`,
            vehicleType = "low", vehicleSpawn = "los_santos_vehicle_spawners", towVehicleSpawn = "los_santos_tow_spawners", deliverLocation = "los_santos_vehicle_deliver",
            requires = {
                items = {
                    {name = "lockpick", count = 1},
                },
                coins = 2,
            },
            rewards = {
                items = {
                    {name = "black_money", minCount = 1500, maxCount = 2500},
                },
            },
        },
    }

    return self
end
