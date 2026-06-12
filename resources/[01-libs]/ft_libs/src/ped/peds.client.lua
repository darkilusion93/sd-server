--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

local peds = {}
local currentPeds = {}


--
-- Add Ped to activepeds table
--
function EnablePed(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for _, name in pairs(args[1]) do
            if peds[name] then
                currentPeds[name] = true
            end
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        if peds[name] then
            currentPeds[name] = true
        end

    end

end

--
-- Remove Ped from currentPeds table
--
function DisablePed(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table"  then

        for _, name in pairs(args[1]) do
            local ped = peds[name]

            ped:Hide()
            currentPeds[name] = nil
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        local ped = peds[name]

        ped:Hide()
        currentPeds[name] = nil

    end

end


--
-- Add Ped in the peds table
--
function AddPed(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for name, value in pairs(args[1]) do
            if peds[name] == nil then
                peds[name] = ped.new(value)
                if value.enable == nil or value.enable == true then
                    EnablePed(name)
                end
            end
            Citizen.Wait(10)
        end

    elseif count == 2 then

        local name = args[1]
        local value = args[2]
        if peds[name] == nil then
            peds[name] = ped.new(value)
            if value.enable == nil or value.enable == true then
                EnablePed(name)
            end
        end

    end

end

--
-- Remove Ped in the peds table
--
function RemovePed(...)

    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then

        for _, name in ipairs(args[1]) do
            if peds[name] ~= nil then
                DisablePed(name)
                peds[name] = nil
                Citizen.Wait(10)
            end
        end

    elseif count == 1 then

        local name = args[1]
        if peds[name] ~= nil then
            DisablePed(name)
            peds[name] = nil
        end

    end

end

--
-- Get Ped Handle in the peds table
--
function GetPedHandle(name)
    return peds[name]?.ped
end

--
-- Get Ped Handle in the peds table
--
function GetPedName(handle)
    for name, ped in pairs(peds) do
        if ped.ped == handle then
            return name
        end
    end

    return ""
end

--
-- Set Ped
--
function SetPed(...)

    local args = {...}
    local count = #args

    if count == 1 and type(args[1]) == "table" then

        for name, values in pairs(args[1]) do
            if peds[name] ~= nil then
                local ped = peds[name]
                for key, value in pairs(values) do
                    ped[key] = value
                end
            end
            Citizen.Wait(1)
        end

    elseif count == 2 then

        local name = args[1]
        local values = args[2]
        if peds[name] ~= nil then
            local ped = peds[name]
            for key, value in pairs(values) do
                ped[key] = value
            end
        end

    end

end

function ActivePedThread()

    Citizen.CreateThread(function()
        while true do
            local playerCoords = GetPlayerCoords()

            for name, value in pairs(currentPeds) do
                local ped = peds[name]
                if #(vector3(ped.x, ped. y, ped.z) - vector3(playerCoords.x, playerCoords. y, playerCoords.z)) < 100.0 then
                    if ped and currentPeds[name] ~= nil then
                        ped:Show()
                    end
                else
                    ped:Hide()
                end
            end

            Citizen.Wait(1000)
        end

    end)

end
