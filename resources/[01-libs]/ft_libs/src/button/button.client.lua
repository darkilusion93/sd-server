--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

--
button = {}

-- class table
local Button = {}

--
--
--
function Button:Use()
    Citizen.CreateThread(function()

        if self.use.callback ~= nil then
            local callback = self.use.callback
            callback(self.data)
        end

        if self.use.eventClient ~= nil then
            TriggerEvent(self.use.eventClient, self.data)
        end

        if self.use.eventServer ~= nil then
            TriggerServerEvent(self.use.eventServer, self.data)
        end

    end)
end

--
--
--
function button.new(data)

    local self = data
    self.key = data.key or 38
    self.data = data.data or {}
    self.use = data.use or {}

    if data.enable == nil or type(data.enable) ~= "boolean" then
        self.enable = true
    end

    setmetatable(self, { __index = Button })
    return self

end
