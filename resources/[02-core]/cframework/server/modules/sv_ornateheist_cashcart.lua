

local heist = LoadOrnateHeist()
local cashCartCoords = heist.cashCart
local spawnedCarts, cashCartMoneyLeft = {}, {}

function SpawnOrnateHeistCashCarts()
    for i = 1, #cashCartCoords do
        local cart = cashCartCoords[i]
        local cartEntity = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), cart.x, cart.y, cart.z, true, true, false)

        local curTime <const> = os.time()

        while not DoesEntityExist(cartEntity) do
            Citizen.Wait(20)

            if os.time() - curTime > 20 then return nil end
        end

        FreezeEntityPosition(cartEntity, true)
        SetEntityHeading(cartEntity, cart.w)

        SetEntityIgnoreRequestControlFilter(cartEntity, true) -- Allow control requests

        cashCartMoneyLeft[i] = 45
        spawnedCarts[i] = cartEntity
    end
end

function DeleteOrnateHeistCashCarts()
    for i = 1, #spawnedCarts do
        local cart = spawnedCarts[i]

        if DoesEntityExist(cart) then
            DeleteEntity(cart)
        end
    end
end

RegisterNetEvent("cframework:collectCashFromCashCart", function(trolleyIndex)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local cart <const>, moneyLeft <const> = spawnedCarts[trolleyIndex], cashCartMoneyLeft[trolleyIndex]
    local inRobbery <const> = IsOrnateHeistRobberyActive()

    if not inRobbery then
        return
    end

    if moneyLeft == nil or moneyLeft <= 0 then return end
    if not DoesEntityExist(cart) then return end

    local ped <const> = GetPlayerPed(source)
    local pedCoords <const>, cartCoords <const> = GetEntityCoords(ped), GetEntityCoords(cart)

    if #(pedCoords - cartCoords) > 2.0 then return end

    cashCartMoneyLeft[trolleyIndex] = moneyLeft - 1

    inventory.addItem("black_money", math.random(6000, 8000))
end)
