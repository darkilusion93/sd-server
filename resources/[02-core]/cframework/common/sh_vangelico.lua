

local cabinetProp1, cabinetProp2, cabinetProp3, cabinetProp4 = "DES_Jewel_Cab", "DES_Jewel_Cab2", "DES_Jewel_Cab3", "DES_Jewel_Cab4"
local originVector = vector3(0.0, 0.0, 0.0)

function LoadVangelicoHeist()
    local self = {}

    self.minCops = 10
    self.robberyCooldown = 3600 * 3 -- 3 Hours

    self.glassCabinets = {
        { --1
            coords = vector3(-627.735, -234.439, 37.875),
            objectCoords = vector3(-628.187, -233.538, 37.0946),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --2
            coords = vector3(-626.716, -233.685, 37.8583),
            objectCoords = vector3(-627.136, -232.775, 37.0946),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --3
            coords = vector3(-627.35, -234.947, 37.8531),
            objectCoords = vector3(-626.62, -235.725, 37.0946),
            animRotation = vector3(0.0, 0.0, 36.0),
            camCoords = originVector,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --4
            coords = vector3(-626.298, -234.193, 37.8492),
            objectCoords = vector3(-625.57, -234.962, 37.0946),
            animRotation = vector3(0.0, 0.0, 36.0),
            camCoords = originVector,
            cabinetProp = cabinetProp4,
            entityAnimState = 0,
            robbed = false
        },
        { --5
            coords = vector3(-626.399, -239.132, 37.8616),
            objectCoords = vector3(-626.894, -238.2, 37.0856),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp2,
            entityAnimState = 0,
            robbed = false
        },
        { --6
            coords = vector3(-625.376, -238.358, 37.8687),
            objectCoords = vector3(-625.867, -237.458, 37.0946),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --7
            coords = vector3(-625.517, -227.421, 37.86),
            objectCoords = vector3(-624.738, -228.2, 37.0946),
            animRotation = vector3(0.0, 0.0, 36.0),
            camCoords = originVector,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --8
            coords = vector3(-624.467, -226.653, 37.861),
            objectCoords = vector3(-623.688, -227.437, 37.0946),
            animRotation = vector3(0.0, 0.0, 36.0),
            camCoords = originVector,
            cabinetProp = cabinetProp4,
            entityAnimState = 0,
            robbed = false
        },
        { --9
            coords = vector3(-623.8118, -228.6336, 37.8522),
            objectCoords = vector3(-624.293, -227.831, 37.0946),
            animRotation = vector3(0.0, 0.0, -143.511),
            camCoords = originVector,
            cabinetProp = cabinetProp2,
            entityAnimState = 0,
            robbed = false
        },
        { --10
            coords = vector3(-624.1267, -230.7476, 37.8618),
            objectCoords = vector3(-624.939, -231.247, 37.0946),
            animRotation = vector3(0.0, 0.0, -54.13),
            camCoords = originVector,
            cabinetProp = cabinetProp4,
            entityAnimState = 0,
            robbed = false
        },
        { --11
            coords = vector3(-621.7181, -228.9636, 37.8425),
            objectCoords = vector3(-620.864, -228.481, 37.0946),
            animRotation = vector3(0.0, 0.0, 126.925),
            camCoords = vector3(-620.8779, -227.7553, 38.7692),
            camRot1 = vector3(-15.0723, -0.325, 147.1275),
            camFov1 = 35.2071,
            camCoords2 = vector3(-620.4113, -227.7727, 38.6039),
            camRot2 = vector3(-1.7684, 0.1702, 123.3868),
            camFov2 = 35.2071,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --12
            coords = vector3(-622.7541, -232.614, 37.8638),
            objectCoords = vector3(-623.3596, -233.2296, 37.0946),
            animRotation = vector3(0.0, 0.0, -52.984),
            camCoords = vector3(-622.0359, -233.6082, 38.44986),
            camRot1 = vector3(-1.763292, -2.630027, 46.96361),
            camFov1 = 39.74993,
            camCoords2 = vector3(-621.4892, -232.9718, 38.6356),
            camRot2 = vector3(-8.36115, -2.628445, 86.69191),
            camFov2 = 37.1155,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --13
            coords = vector3(-620.3262, -230.829, 37.8578),
            objectCoords = vector3(-619.408, -230.1969, 37.0946),
            animRotation = vector3(0.0, 0.0, 126.352),
            camCoords = originVector,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --14
            coords = vector3(-620.6465, -232.9308, 37.8407),
            objectCoords = vector3(-620.184, -233.729, 37.0946),
            animRotation = vector3(0.0, 0.0, 36.398),
            camCoords = vector3(-618.883, -233.4098, 38.15371),
            camRot1 = vector3(-2.226855, -2.630027, 64.84428),
            camFov1 = 40.18032,
            camCoords2 = vector3(-618.9713, -233.348, 38.638),
            camRot2 = vector3(-1.0873, -1.7225, 84.9176),
            camFov2 = 40.18032,
            cabinetProp = cabinetProp4,
            entityAnimState = 0,
            robbed = false
        },
        { --15
            coords = vector3(-619.978, -234.93, 37.8537),
            objectCoords = vector3(-620.44, -234.084, 37.0946),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --16
            coords = vector3(-618.937, -234.16, 37.8425),
            objectCoords = vector3(-619.39, -233.32, 37.0946),
            animRotation = vector3(0.0, 0.0, -144.0),
            camCoords = originVector,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --17
            coords = vector3(-620.163, -226.212, 37.8266),
            objectCoords = vector3(-620.797, -226.79, 37.0946),
            animRotation = vector3(0.0, 0.0, -54.0),
            camCoords = originVector,
            cabinetProp = cabinetProp1,
            entityAnimState = 0,
            robbed = false
        },
        { --18
            coords = vector3(-619.384, -227.259, 37.8342),
            objectCoords = vector3(-620.055, -227.817, 37.0856),
            animRotation = vector3(0.0, 0.0, -54.0),
            camCoords = originVector,
            cabinetProp = cabinetProp2,
            entityAnimState = 0,
            robbed = false
        },
        { --19
            coords = vector3(-618.019, -229.115, 37.8302),
            objectCoords = vector3(-618.679, -229.704, 37.0946),
            animRotation = vector3(0.0, 0.0, -54.0),
            camCoords = originVector,
            cabinetProp = cabinetProp3,
            entityAnimState = 0,
            robbed = false
        },
        { --20
            coords = vector3(-617.249, -230.156, 37.8201),
            objectCoords = vector3(-617.937, -230.731, 37.0856),
            animRotation = vector3(0.0, 0.0, -54.0),
            camCoords = originVector,
            cabinetProp = cabinetProp2,
            entityAnimState = 0,
            robbed = false
        },
    }

    self.validWeapons = {
        ["WEAPON_SMG"] = true,
        ["WEAPON_ASSAULTSMG"] = true,
        ["WEAPON_SMG_MK2"] = true,
        ["WEAPON_COMBATPDW"] = true,
        ["WEAPON_PUMPSHOTGUN"] = true,
        ["WEAPON_PUMPSHOTGUN_MK2"] = true,
        ["WEAPON_SAWNOFFSHOTGUN"] = true,
        ["WEAPON_ASSAULTSHOTGUN"] = true,
        ["WEAPON_BULLPUPSHOTGUN"] = true,
        ["WEAPON_COMBATSHOTGUN"] = true,
        ["WEAPON_ASSAULTRIFLE"] = true,
        ["WEAPON_ASSAULTRIFLE_MK2"] = true,
        ["WEAPON_CARBINERIFLE"] = true,
        ["WEAPON_CARBINERIFLE_MK2"] = true,
        ["WEAPON_ADVANCEDRIFLE"] = true,
        ["WEAPON_SPECIALCARBINE"] = true,
        ["WEAPON_SPECIALCARBINE_MK2"] = true,
        ["WEAPON_BULLPUPRIFLE"] = true,
        ["WEAPON_BULLPUPRIFLE_MK2"] = true,
        ["WEAPON_COMPACTRIFLE"] = true,
        ["WEAPON_MILITARYRIFLE"] = true,
        ["WEAPON_HEAVYRIFLE"] = true,
        ["WEAPON_TACTICALRIFLE"] = true,
    }

    return self
end