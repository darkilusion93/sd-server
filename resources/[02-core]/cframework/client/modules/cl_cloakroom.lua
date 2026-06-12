


local function setStationUniform(uniform)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Stations[ESX.PlayerData.job.name].Uniforms[uniform].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Stations[ESX.PlayerData.job.name].Uniforms[uniform].female)
        end

        TriggerEvent('skinchanger:getSkin', function(skinToSave)
            TriggerServerEvent('esx_skin:save', skinToSave)
        end)
    end)
end


function OpenStationUniformMenu()
    if Config.Stations[ESX.PlayerData.job.name].Uniforms == nil then
        return
    end

    local elements = {}

    for k,v in pairs(Config.Stations[ESX.PlayerData.job.name].Uniforms) do
        table.insert(elements, {label = v.label, value = k})
    end

    ESX.UI.Menu.CloseAll()
    local data = ESX.DefaultMenu(T("ORGMENU_CLOAKROOM"), elements)

	if data and data.value ~= 'citizen_wear' then
        setStationUniform(data.value)
    end
end


function OpenCloakroomMenu()
    ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
        local elements = {}

        for i=1, #dressing, 1 do
            table.insert(elements, {
                label = dressing[i],
                value = i
            })
        end

        ESX.UI.Menu.CloseAll()
        local data = ESX.DefaultMenu(T("ORGMENU_CLOAKROOM"), elements)

        if data and data.value then
            TriggerEvent('skinchanger:getSkin', function(skin)
                ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
                    TriggerEvent('skinchanger:loadClothes', skin, clothes)
                    TriggerEvent('esx_skin:setLastSkin', skin)

                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_skin:save', skin)
                    end)
                end, data.value)
            end)
        end
    end)
end
