


function OpenSpecial(specialNumber)
    if ESX.PlayerData.job.name == 'random2' then  -- Reapers
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(1944.29, 4630.07, 40.45), 358.37)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'cpx6' then
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(2513.83, 4077.67, 38.57), 119.70)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'tribunal' then -- Vipers
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(1985.28, 3032.31, 47.06), 58.52)
        end,
        function(data, menu)
            menu.close()
        end)

      elseif ESX.PlayerData.job.name == 'squad7' and Config.Stations[ESX.PlayerData.job.name].Special[specialNumber].type == 'classicos' then
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles['igreja2']
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-670.16, 323.45, 83.05), 272.96)
        end,
        function(data, menu)
            menu.close()
        end)

      elseif ESX.PlayerData.job.name == 'squad7' and Config.Stations[ESX.PlayerData.job.name].Special[specialNumber].type == 'pesados' then
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-372.81, -108.94, 38.68), 65.34)
        end,
        function(data, menu)
            menu.close()
        end)

      elseif ESX.PlayerData.job.name == 'squad10' then  -- soa
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(956.08, -119.64, 74.35), 222.80)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'oficina3' then -- Los Santos
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-347.80, -158.05, 39.01), 349.99)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'squad11' then -- Atomic
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(472.44, -1874.05, 26.85), 111.9)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'squad2' then -- Bikes
        --if PlayerData.job.grade_name ~= 'boss' and PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-1320.95, -1524.5, 4.42), 148.58)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'ilegal1' then  -- WCC
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(803.9, -3203.96, 5.9), 159.62) --COORDENADAS SPAWN VEICULO -> ilegal1
        end,
        function(data, menu)
            menu.close()
        end)
    elseif ESX.PlayerData.job.name == 'nautica' and Config.Stations[ESX.PlayerData.job.name].Special[specialNumber].type == 'boat' then --Barcos da nautica
        local elements = {}

        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'soldato' then return end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles['nautica2']
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(1432.17, 3871.70, 29.53), 71.36, 'boat') 
        end,
        function(data, menu)
            menu.close()
        end)


    elseif ESX.PlayerData.job.name == 'nautica' and Config.Stations[ESX.PlayerData.job.name].Special[specialNumber].type == 'aircraft' then --Helis da nautica
        local elements = {}

        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'soldato' then return end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(1427.09, 3730.59, 32.97), 190.20, 'aircraft')
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'oficina1' then
        --if PlayerData.job.grade_name ~= 'boss' and PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {table.unpack(ESX.orgStandVehicles[ESX.PlayerData.job.name])}

        if ESX.PlayerData.job.grade_name == 'boss' then
            for _,v in ipairs(ESX.orgStandVehicles["harmony2"]) do
                table.insert(elements, v)
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = elements
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(135.78, -3042.29, 7.08), 267.34) --COORDENADAS SPAWN VEICULO -> oficina1
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'oficina2' then   --BENNYS
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'consigliere' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-751.60, -2067.92, 8.90), 134.72)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'ilegal3' then  -- 
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'soldato' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(689.00, -766.88, 25.03), 357.96)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'oficina5' then  -- mare custom
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'soldato' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(560.11, 2789.94, 42.13), 357.43)
        end,
        function(data, menu)
            menu.close()
        end)

    elseif ESX.PlayerData.job.name == 'squad7' then -- Racing
        if ESX.PlayerData.job.grade_name ~= 'boss' and ESX.PlayerData.job.grade_name ~= 'capo' then return end
        local elements = {}

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas',{
            title    = 'Motas',
            align    = 'top-left',
            elements = ESX.orgStandVehicles[ESX.PlayerData.job.name]
        },
        function(data, menu)
            OpenMenuVeiculosCompra(data.current.value, data.current.price, vector3(-667.47, 324.58, 83.05), 263.08)
        end,
        function(data, menu)
            menu.close()
        end)
    end
end

function OpenMenuVeiculosCompra(mota, preco, pos, head, type)
    local elements = {}

    if type == nil then
        type = 'car'
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Motas2',{
        title    = 'Veiculos - Compra',
        align    = 'top-left',
        elements = {
            {label = 'Mostrar',   value = 'mostrar'},
            {label = 'Comprar',   value = 'comprar'},
        },
    },
    function(data2, menu2)
        if data2.current.value == 'mostrar' then
            TriggerServerEvent('cframework:showOrgVehicle', mota--[[model]], pos, head)
        elseif data2.current.value == 'comprar' then
            TriggerServerEvent('cframework:buyOrgVehicle', mota--[[model]], pos, head, type)
        end
    end,
    function(data2, menu2)
        TriggerServerEvent("cframework:cancelVehicleShow")
        menu2.close()
    end)
end

RegisterNetEvent("cframework:setVehicleUndrivable", function(netId)
    while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
        Citizen.Wait(0)
    end

    local vehicle = NetworkGetEntityFromNetworkId(netId)

    SetVehicleDoorsLocked(vehicle, 2)
    for i=0,7 do SetVehicleDoorCanBreak(vehicle, i, false) ;SetVehicleDoorOpen(vehicle, i, false, false) end
    SetEntityInvincible(vehicle, true)
    SetVehicleUndriveable(vehicle, true)
    SetEntityMaxSpeed(vehicle, 0.0)
    SetEntityAsMissionEntity(vehicle , true, true)
end)