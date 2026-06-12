RegisterNetEvent("mythic_hospital:items:gauze")
AddEventHandler("mythic_hospital:items:gauze", function(item)

    exports['okokNotify']:Alert('Informação', 'A aplicar gaze...', 5000, 'info')

    local success = lib.progressBar({
        duration = 1500,
        label = "A aplicar gaze",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "missheistdockssetup1clipboard@idle_a",
            clip = "idle_a",
            flag = 49,
        },
        prop = {
            {
                model = `prop_paper_bag_small`,
                bone = 18905,
                pos = vec3(0.10, 0.02, 0.08),
                rot = vec3(0.0, 0.0, 0.0),
            }
        }
    })

    if success then
        TriggerEvent('mythic_hospital:client:FieldTreatBleed')
    end
end)

RegisterNetEvent("mythic_hospital:items:bandage")
AddEventHandler("mythic_hospital:items:bandage", function(item)

    local success = lib.progressBar({
        duration = 5000,
        label = "A tomar um antibiótico",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "missheistdockssetup1clipboard@idle_a",
            clip = "idle_a",
            flag = 49,
        },
        prop = {
            {
                model = `prop_paper_bag_small`,
                bone = 18905,
                pos = vec3(0.10, 0.02, 0.08),
                rot = vec3(0.0, 0.0, 0.0),
            }
        }
    })

    if success then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
        local health = GetEntityHealth(PlayerPedId())
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))

        SetEntityHealth(PlayerPedId(), newHealth)
    end
end)

RegisterNetEvent("mythic_hospital:items:firstaid")
AddEventHandler("mythic_hospital:items:firstaid", function(item)

    local success = lib.progressBar({
        duration = 10000,
        label = "Using First Aid",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "missheistdockssetup1clipboard@idle_a",
            clip = "idle_a",
            flag = 49,
        },
        prop = {
            {
                model = `prop_stat_pack_01`,
                bone = 18905,
                pos = vec3(0.10, 0.02, 0.08),
                rot = vec3(0.0, 0.0, 0.0),
            }
        }
    })

    if success then
        local maxHealth = GetEntityMaxHealth(PlayerPedId())
        local health = GetEntityHealth(PlayerPedId())
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 8))
        SetEntityHealth(PlayerPedId(), newHealth)
    end
end)

RegisterNetEvent("mythic_hospital:items:medkit")
AddEventHandler("mythic_hospital:items:medkit", function(item)

    local success = lib.progressBar({
        duration = 20000,
        label = "Using Medkit",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "missheistdockssetup1clipboard@idle_a",
            clip = "idle_a",
            flag = 49,
        },
        prop = {
            {
                model = `prop_ld_health_pack`,
                bone = 18905,
                pos = vec3(0.10, 0.02, 0.08),
                rot = vec3(0.0, 0.0, 0.0),
            }
        }
    })

    if success then
        SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
        TriggerEvent('mythic_hospital:client:FieldTreatLimbs')
    end
end)

RegisterNetEvent("mythic_hospital:items:oxy")
AddEventHandler("mythic_hospital:items:oxy", function(item)

    local success = lib.progressBar({
        duration = 1000,
        label = "Tomando Oxicodona",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 49,
        },
        prop = {
            {
                model = `prop_cs_pills`,
                bone = 58866,
                pos = vec3(0.1, 0.0, 0.001),
                rot = vec3(-60.0, 0.0, 0.0),
            }
        }
    })

    if success then
        TriggerEvent('mythic_hospital:client:UsePainKiller', 9)
        Wait(1000)

        TriggerEvent('mythic_hospital:client:FieldTreatBleed')
        Wait(1000)

        TriggerEvent('mythic_hospital:client:UseAdrenaline', 9)
        Wait(1000)

        local maxHealth = GetEntityMaxHealth(PlayerPedId())
        local health = GetEntityHealth(PlayerPedId())
        local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 2.5))

        SetEntityHealth(PlayerPedId(), newHealth)
    end
end)


RegisterNetEvent("mythic_hospital:items:medicamento")
AddEventHandler("mythic_hospital:items:medicamento", function(item)

    lib.progressBar({
        duration = 2000,
        label = "Tomando Medicamento",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 49,
        },
        prop = {
            {
                model = `prop_cs_pills`,
                bone = 58866,
                pos = vec3(0.1, 0.0, 0.001),
                rot = vec3(-60.0, 0.0, 0.0),
            }
        }
    })

end)

RegisterNetEvent("mythic_hospital:items:hydrocodone")
AddEventHandler("mythic_hospital:items:hydrocodone", function(item)

    local success = lib.progressBar({
        duration = 1000,
        label = "A tomar Ben-u-ron",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 49,
        },
        prop = {
            {
                model = `prop_cs_pills`,
                bone = 58866,
                pos = vec3(0.1, 0.0, 0.001),
                rot = vec3(-60.0, 0.0, 0.0),
            }
        }
    })

    if success then
        TriggerEvent('mythic_hospital:client:UsePainKiller', 4)
        TriggerEvent('mythic_hospital:client:UseAdrenaline', 2)
    end
end)

RegisterNetEvent("mythic_hospital:items:morphine")
AddEventHandler("mythic_hospital:items:morphine", function(item)

    local success = lib.progressBar({
        duration = 2000,
        label = "A tomar Morfina",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 49,
        },
        prop = {
            {
                model = `prop_cs_pills`,
                bone = 58866,
                pos = vec3(0.1, 0.0, 0.001),
                rot = vec3(-60.0, 0.0, 0.0),
            }
        }
    })

    if success then
        TriggerEvent('mythic_hospital:client:UsePainKiller', 8)
    end
end)

RegisterNetEvent("mythic_hospital:items:adrenaline")
AddEventHandler("mythic_hospital:items:adrenaline", function(item)

    local success = lib.progressBar({
        duration = 2000,
        label = "A tomar Adrenalina",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = false,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 49,
        },
        prop = {
            {
                model = `prop_cs_pills`,
                bone = 58866,
                pos = vec3(0.1, 0.0, 0.001),
                rot = vec3(-60.0, 0.0, 0.0),
            }
        }
    })

    if success then
        TriggerEvent('mythic_hospital:client:UseAdrenaline', 8)
    end
end)