--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

local buttons = {}
local enabledButtons = {}
local currentButtons = {}

--
-- Enable Button
--
function EnableButton(...)

    local args = {...}
    local count = #args

    if count == 1 and type(args[1]) == "table" then

        for _, name in pairs(args[1]) do
            if buttons[name] ~= nil then
                enabledButtons[name] = true
            end
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        if buttons[name] ~= nil then
            enabledButtons[name] = true
        end

    end

end

--
-- Disable Button
--
function DisableButton(...)

    local args = {...}
    local count = #args

    if count == 1 and type(args[1]) == "table" then

        for _, name in pairs(args[1]) do
            enabledButtons[name] = nil
            currentButtons[name] = nil
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        enabledButtons[name] = nil
        currentButtons[name] = nil

    end

end

--
-- Add Button
--
function AddButton(...)

    local args = {...}
    local count = #args

    if count == 1 and type(args[1]) == "table" then

        for name, value in pairs(args[1]) do
            if buttons[name] == nil then
                buttons[name] = button.new(value)
                if value.enable == nil or value.enable == true then
                    EnableButton(name)
                end
            end
            Citizen.Wait(10)
        end

    elseif count == 2 then

        local name = args[1]
        local value = args[2]
        if buttons[name] == nil then
            buttons[name] = button.new(value)

            if value.enable == nil or value.enable == true then
                EnableButton(name)
            end
        end

    end

end

--
-- Remove Button
--
function RemoveButton(...)

    local args = {...}
    local count = #args

    if count == 1 and type(args[1]) == "table" then

        for _, name in ipairs(args[1]) do
            if buttons[name] ~= nil then
                DisableButton(name)
                buttons[name] = nil
            end
            Citizen.Wait(10)
        end

    elseif count == 1 then

        local name = args[1]
        if buttons[name] ~= nil then
            DisableButton(name)
            buttons[name] = nil
        end

    end

end

--
-- Check
--
function ActiveButtonThread()

    Citizen.CreateThread(function()

        while true do

            for name, value in pairs(buttons) do

                local button = buttons[name]

                if IsControlPressed(0,  button.key) then
                    if button ~= nil and buttons[name] ~= nil then
                        button:Use()
                    end
                    Citizen.Wait(500)
                end

            end
            Citizen.Wait(0)
        end

    end)

end
