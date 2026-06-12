

local licensesCache = {}

RegisterNetEvent("cframework:getShowableLicenses", function()
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)

    local licenses <const> = MySQL.Sync.fetchAll('SELECT id, type FROM user_licenses WHERE owner = @identifier', {
        ['@identifier'] = identifier
    }) or {}

    local extraData <const> = MySQL.Sync.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, citizen_id FROM users WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    })[1]

    local showableLicenses = {}

    showableLicenses["idcard"] = {
        title = T("IDCARD_CITIZEN_ID"),
        param1 = {label = T("IDCARD_FULLNAME"),     value = ESX.getFullname(source) },
        param2 = {label = T("IDCARD_SEX"),          value = extraData.sex           },
        param3 = {label = T("IDCARD_HEIGHT"),       value = extraData.height        },
        param4 = {label = T("IDCARD_BIRTHDATE"),    value = extraData.dateofbirth   },
        param5 = {label = T("IDCARD_CITIZENID"),    value = extraData.citizen_id    },
        signature = ESX.getFullname(source),
        mugshot = true,
        img = "idcard"
    }

    for i=1, #licenses, 1 do
        if licenses[i].type == 'drive' or licenses[i].type == 'drive_bike' or licenses[i].type == 'drive_truck' then
            local types = {}

            if licenses[i].type == 'drive' then
                table.insert(types, "CAR")
            elseif licenses[i].type == 'drive_bike' then
                table.insert(types, "BIKE")
            elseif licenses[i].type == 'drive_truck' then
                table.insert(types, "TRUCK")
            end

            showableLicenses["license"] = {
                title = T("IDCARD_DRIVER_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_SEX"),           value = extraData.sex            },
                param3 = {label = T("IDCARD_HEIGHT"),        value = extraData.height         },
                param4 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                param5 = {label = "Carta",                   value = table.concat(types, ", ")},
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "dmv"
            }
        elseif licenses[i].type == 'weapon' then
            showableLicenses["firearm"] = {
                title = T("IDCARD_WEAPON_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "weapon"
            }
        elseif licenses[i].type == 'weapon_hunt' then
            showableLicenses["hunting"] = {
                title = "Licença de Caça",
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                param3 = {label = T("IDCARD_CARD_NUMBER"),   value = licenses[i].id           },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "hunt"
            }
        elseif licenses[i].type == 'boat' then
            showableLicenses["boat"] = {
                title = T("IDCARD_BOAT_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "boat"
            }
        elseif licenses[i].type == 'aircraft' then
            showableLicenses["aircraft"] = {
                title = T("IDCARD_FLY_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "heli"
            }
        elseif licenses[i].type == 'advogado' then
            showableLicenses["advogado"] = {
                title = T("IDCARD_LAWYER_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),      value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),     value = extraData.dateofbirth    },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "lawyer"
            }
        elseif licenses[i].type == 'pesca' then
            showableLicenses["pesca"] = {
                title = T("IDCARD_FISHING_LICENSE"),
                param1 = {label = T("IDCARD_FULLNAME"),         value = ESX.getFullname(source)  },
                param2 = {label = T("IDCARD_BIRTHDATE"),        value = extraData.dateofbirth    },
                param3 = {label = T("IDCARD_CARD_NUMBER"),      value = licenses[i].id           },
                signature = ESX.getFullname(source),
                mugshot = false,
                img = "fish"
            }
        end
    end

    licensesCache[identifier] = showableLicenses

    TriggerClientEvent('chud:idcard', source, showableLicenses)
end)

RegisterNetEvent("cframework:showLicense", function(targetSource, type)
    local source <const> = source
    local identifier <const> = ESX.getIdentifier(source)
    local playerPed, targetPed = GetPlayerPed(source), GetPlayerPed(targetSource)

    if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 10.0 then
        return
    end

    local showableLicenses <const> = licensesCache[identifier]

    if showableLicenses == nil then
        return
    end

    local licenseData <const> = showableLicenses[type]

    if licenseData == nil then
        return
    end

    TriggerClientEvent('chud:buildIdCardBlob', targetSource, source, {[type] = licenseData})
end)