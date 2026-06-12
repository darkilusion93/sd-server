Blips = {}
Blips.routeBlips = {}
Blips.abortBlip = nil

-- Apenas cria os blips dos spawn points (fora de serviço)
function Blips.StartBlips()
    for _, route in pairs(Config.Routes) do
        if not Blips.routeBlips[route.Name] then
            Blips.routeBlips[route.Name] = Blips.CreateAndInitBlip(
                route.SpawnPoint, _U(route.Name)
            )
        end
    end
end

-- Move o blip existente (sem recriar → sem piscar)
function Blips.SetBlipCoords(routeName, x, y, z)
    if Blips.routeBlips[routeName] and DoesBlipExist(Blips.routeBlips[routeName]) then
        SetBlipCoords(Blips.routeBlips[routeName], x, y, z)
    end
end

-- Usado pelo código legado (SetBlipAndWaypoint substituído por SetBlipCoords + SetNewWaypoint)
function Blips.SetBlipAndWaypoint(routeName, x, y, z)
    Blips.SetBlipCoords(routeName, x, y, z)
    SetNewWaypoint(x, y)
end

function Blips.StopBlips()
    for name, blip in pairs(Blips.routeBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
        Blips.routeBlips[name] = nil
    end
    Blips.StopAbortBlip()
end

-- Repõe apenas os blips de spawn (chamado após fim/abort de rota)
function Blips.ResetBlips()
    Blips.StopBlips()
    Blips.StartBlips()
end

function Blips.StartAbortBlip(routeName, spawnPoint)
    Blips.StopAbortBlip() -- garantir que não há duplicado
    Blips.abortBlip = Blips.CreateAndInitBlip(
        spawnPoint, _U('abort_route', _U(routeName)), 1 -- vermelho
    )
end

function Blips.StopAbortBlip()
    if Blips.abortBlip and DoesBlipExist(Blips.abortBlip) then
        RemoveBlip(Blips.abortBlip)
    end
    Blips.abortBlip = nil
end

function Blips.CreateAndInitBlip(coords, blipLabel, colour)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 513)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, colour or 2) -- 2 = verde, 1 = vermelho
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blipLabel)
    EndTextCommandSetBlipName(blip)
    return blip
end