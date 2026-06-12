

local heist = LoadOrnateHeist()
local cashCartCoords <const> = heist.cashCart
local currentgrab = 0

local function isTrolleyEmpty(trolleyIndex)
    local trolleyCoords <const> = cashCartCoords[trolleyIndex]
    local trolley <const> = GetClosestObjectOfType(trolleyCoords.x, trolleyCoords.y, trolleyCoords.z, 1.0, `hei_prop_hei_cash_trolly_01`, false, false, false)

    if not DoesEntityExist(trolley) then
        return true, 0
    end

    if IsEntityPlayingAnim(trolley, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return true, trolley
    end

    return false, trolley
end

Citizen.CreateThread(function()
    for k, cartCoords in ipairs(cashCartCoords) do
        exports.ft_libs:AddTrigger("ornateheist_cart" .. k, {x = cartCoords.x, y = cartCoords.y, z = cartCoords.z, weight = 1.0, height = 2,
        enter = {eventClient = "enteredOrnateHeistMarker"}, exit = {eventClient = "exitedOrnateHeistMarker"}, data = k, active = {}})
    end
end)

RegisterNetEvent("enteredOrnateHeistMarker", function(grab)
    local isEmpty <const> = isTrolleyEmpty(grab)

    if isEmpty then return end

    currentgrab = grab

    Citizen.CreateThread(function()
        while currentgrab ~= 0 do

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            local isCartEmpty <const>, trolley <const> = isTrolleyEmpty(currentgrab)

            if isCartEmpty then
                ESX.ShowNotification("O carrinho já está vazio.", "error")
                return
            end

            ESX.StartGrabbingCashFromTrolley(trolley, `hei_prop_heist_cash_pile`, function()
                TriggerServerEvent("cframework:collectCashFromCashCart", currentgrab)
            end)

            currentgrab = 0

            ::final::
        end
    end)
end)

RegisterNetEvent("exitedOrnateHeistMarker", function()
    currentgrab = 0
end)
