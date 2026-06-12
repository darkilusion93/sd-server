Markers = {}
Markers.markerPositions = {}
Markers.abortMarkerPosition = nil

function Markers.StartMarkers()
    Markers.InitNotOnDutyMarkers()

    Citizen.CreateThread(function ()
        while true do
            Citizen.Wait(0) -- Render em cada frame: elimina o piscar dos markers
    
            for _, markerPosition in pairs(Markers.markerPositions) do
                Markers.DrawMarker(markerPosition, Config.Markers.StartColor)
            end

            if Markers.abortMarkerPosition ~= nil then
                Markers.DrawMarker(Markers.abortMarkerPosition, Config.Markers.AbortColor)
            end
        end
    end)
end

function Markers.ResetMarkers()
    Markers.StopMarkers()
    Markers.InitNotOnDutyMarkers()
end

function Markers.StopMarkers()
    Markers.markerPositions = {}
    Markers.StopAbortMarker()
end

function Markers.SetMarkers(markersTable)
    Markers.markerPositions = markersTable
end

function Markers.InitNotOnDutyMarkers()
    for _, markerPosition in pairs(Config.Routes) do
        table.insert(Markers.markerPositions, markerPosition.SpawnPoint)
    end
end

function Markers.StartAbortMarker(abortMarkerPosition)
    Markers.abortMarkerPosition = abortMarkerPosition
end

function Markers.StopAbortMarker()
    Markers.abortMarkerPosition = nil
end

function Markers.DrawMarker(coords, markerColor)
    local s = Config.Markers.Size
    DrawMarker(21,               -- type 1 = cilindro no chão (simples e discreto)
        coords.x,
        coords.y,
        coords.z-0.5,               -- posZ no chão, sem offset
        0, 0, 0,                -- dir
        0.0, 0.0, 0.0,          -- rot
        s,                      -- scaleX
        s,                      -- scaleY
        0.8,                    -- scaleZ (altura fina)
        markerColor.r,
        markerColor.g,
        markerColor.b,
        markerColor.a,
        false,                  -- bobUpAndDown
        false,                  -- faceCamera
        2,
        false,                  -- rotate
        nil,
        nil,
        false
    )
end