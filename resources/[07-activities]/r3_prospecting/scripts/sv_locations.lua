    ESX = nil

    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end) 

    local locations = {
        {x = 4910.927, y = -4546.60, z = 20.700, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4867.000, y = -4505.81, z = 13.000, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4897.975, y = -4422.13, z = 9.1441, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4780.411, y = -4301.08, z = 5.2293, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4799.205, y = -4413.02, z = 17.505, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4707.622, y = -4519.21, z = 26.614, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4571.401, y = -4595.57, z = 9.6305, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4566.606, y = -4692.22, z = 3.3395, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4767.791, y = -4712.61, z = 3.0448, data = {item = "pepitas", label = "Pepitas Ouro"}},
        {x = 4861.666, y = -4636.78, z = 14.229, data = {item = "pepitas", label = "Pepitas Ouro"}},
        ----------------------[[LÍTIO]]---------------------
        {x = 4985.295, y = -4589.23, z = 13.160, data = {item = "litio", label = "Lítio"}},
        {x = 4986.589, y = -4501.46, z = 8.9238, data = {item = "litio", label = "Lítio"}},
        {x = 5024.908, y = -4457.61, z = 2.5259, data = {item = "litio", label = "Lítio"}},
        {x = 4882.009, y = -4472.48, z = 8.4017, data = {item = "litio", label = "Lítio"}},
        {x = 4703.228, y = -4444.77, z = 6.2832, data = {item = "litio", label = "Lítio"}},
        {x = 4719.669, y = -4478.27, z = 10.828, data = {item = "litio", label = "Lítio"}},
        {x = 4607.548, y = -4516.31, z = 12.285, data = {item = "litio", label = "Lítio"}},
        {x = 4594.857, y = -4447.26, z = 2.8400, data = {item = "litio", label = "Lítio"}},
        {x = 4605.962, y = -4410.81, z = 3.3238, data = {item = "litio", label = "Lítio"}},
        {x = 4672.215, y = -4456.62, z = 5.4394, data = {item = "litio", label = "Lítio"}},
        
       
    }
    
    local base_location = vector3(4784.139, -4638.20, 15.435)
    local area_size = 100.0

    function GetNewRandomItem()
        local randomIndex = math.random(1, #locations)
        return locations[randomIndex].data
    end

    function GetNewRandomLocation()
        local offsetX = math.random(-area_size, area_size)
        local offsetY = math.random(-area_size, area_size)
        local pos = vector3(offsetX, offsetY, 0.0)
        if #(pos) > area_size then
            return GetNewRandomLocation()
        end
        return base_location + pos
    end

    function GenerateNewTarget()
        local newPos = GetNewRandomLocation()
        local newData = GetNewRandomItem()
        Prospecting.AddTarget(newPos.x, newPos.y, newPos.z, newData)
    end

    RegisterServerEvent("r3_prospecting:activateProspecting")
    AddEventHandler("r3_prospecting:activateProspecting", function()
        local source = source
        Prospecting.StartProspecting(source)
    end)

    CreateThread(function()

        Prospecting.SetDifficulty(1.0)
        Prospecting.AddTargets(locations)
        for n = 0, 10 do
            GenerateNewTarget()
        end

        Prospecting.SetHandler(function(source, data, x, y, z)
            FoundItem(source, data)
            GenerateNewTarget()
        end)

        Prospecting.OnStart(function(source)
           -- TriggerClientEvent("r3_notifications:client:sendNotification", source, "Started prospecting", "inform", 2500)
        end)

        Prospecting.OnStop(function(source, time)
            --TriggerClientEvent("r3_notifications:client:sendNotification", source, "Stopped prospecting", "inform", 2500)
        end)
    end)


    ESX.RegisterUsableItem("detector", function(source)
        TriggerClientEvent("r3_prospecting:useDetector", source)
    end)

    function FoundItem(source, data)
        local xPlayer = ESX.GetPlayerFromId(source)
        local random = math.random(1, 5)

        if xPlayer.getInventoryItem(data.item).limit then
            xPlayer.addInventoryItem(data.item, random)

            TriggerClientEvent('okokNotify:Alert', source,
                "PROSPEÇÃO",
                'Encontraste '..random..' de '..data.label..'!',
                5000,
                'success'
            )
        else
            TriggerClientEvent('okokNotify:Alert', source,
                "ERRO",
                'Tens o inventário cheio!',
                5000,
                'error'
            )
        end
    end