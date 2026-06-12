

local heist = LoadOrnateHeist()
local zipTies <const> = heist.zipTies
local currentZipTie = nil

Citizen.CreateThread(function()
    for k, zipTie in pairs(zipTies) do
         exports.ft_libs:AddTrigger("ornateheist_ziptie" .. k, {x = zipTie.loc.x, y = zipTie.loc.y, z = zipTie.loc.z, weight = 1.0, height = 2,
         enter = {eventClient = "enteredZipTieMarker"}, exit = {eventClient = "exitedZipTieMarker"}, data = k, active = {}})
     end
end)

RegisterNetEvent("enteredZipTieMarker", function(zipTie)
    local weapon <const> = GetSelectedPedWeapon(PlayerPedId())

    if weapon ~= `WEAPON_KNIFE` then
        return
    end

    currentZipTie = zipTie

    Citizen.CreateThread(function()
        while currentZipTie ~= nil do

            ESX.ShowHelpNotification("Pressiona ~INPUT_CONTEXT~ para interagir.")
            Citizen.Wait(0)

            if not IsControlPressed(0, 38) then
                goto final
            end

            TriggerServerEvent("cframework:removeZipTieFromBankDoor", currentZipTie)
            currentZipTie = nil

            ::final::
        end
    end)
end)

RegisterNetEvent("exitedZipTieMarker", function()
    currentZipTie = nil
end)