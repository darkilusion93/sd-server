

local CAM_HEIGHT <const> = 0.3 -- decimal of screen height, where 1.0 is 100% and 0.0 is 0%

local camActive = false
local camMoving = false
local camHeight = 0.0


local function hideHUDComponents()
    for i = 0, 22 do
        if IsHudComponentActive(i) then
            HideHudComponentThisFrame(i)
        end
    end
end

local function handleCinmetaicAnim() -- [[Handles Displaying Radar, Body Armour and the rects themselves.]]
    camMoving = true

    if camActive then
        for i = 0, CAM_HEIGHT, 0.01 do
            camHeight = i

            Citizen.Wait(1)
        end
    else
        for i = CAM_HEIGHT, 0, -0.01 do
            camHeight = i

            Citizen.Wait(1)
        end
    end

    camMoving = false
end


RegisterCommand("cinematic", function()
    if IsPauseMenuActive() then
        return
    end

    if camMoving then
        return
    end

    camActive = not camActive

    TriggerEvent("cframework:toggleCinematic", camActive)

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        DisplayRadar(not camActive)
    end

    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        SendNUIMessage({ action = 'toggleUi', value = not camActive })
    end

    Citizen.CreateThread(handleCinmetaicAnim)

    while camHeight >= 0.01 or camActive do
        for i = 0, 1.0, 1.0 do
            DrawRect(0.0, 0.0, 2.0, camHeight, 0, 0, 0, 255)
            DrawRect(0.0, i, 2.0, camHeight, 0, 0, 0, 255)
        end

        hideHUDComponents()

        Citizen.Wait(0)
    end
end, false)