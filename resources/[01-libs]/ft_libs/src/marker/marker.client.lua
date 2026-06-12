--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

--
marker = {}

-- class table
local Marker = {}
local drawMarker = DrawMarker

--
-- Show Marker
--
function Marker:Show()

    local weight = self.weight * 1.0
    local height = self.height + 0.0

    if self.type == -1 then
        --Do nothing
    elseif self.type ~= 50 then
        ---@diagnostic disable-next-line: param-type-mismatch
        drawMarker(self.type, self.x, self.y, self.z, 0, 0, 0, 0, 0, 0, weight, weight, height, self.red, self.green, self.blue, self.alpha, false, false, 0, false, nil, nil, false)
    else
        ---@diagnostic disable-next-line: param-type-mismatch
        drawMarker(2, self.x, self.y, self.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, self.red, self.green, self.blue, self.alpha, false, false, 0, true, nil, nil, false)
    end

    if self.text ~= nil then
        Show3DText({
            x = self.x,
            y = self.y,
            z = self.z + self.textOffset,
            text = self.text,
        })
    end

end

--
-- Create new instace of Marker
--
function marker.new(data)

    assert(type(data.x) == "number", "Marker : x must be number")
    assert(type(data.y) == "number", "Marker : y must be number")
    assert(type(data.z) == "number", "Marker : z must be number")

    local self = data
    self.type = data.type or 1
    self.weight = data.weight or 2.0
    self.height = data.height or 0.5
    self.red = data.red or 255
    self.green = data.green or 255
    self.blue = data.blue or 255
    self.alpha = data.alpha or 255
    self.showDistance = data.showDistance or self.weight + 20
    self.text = data.text
    self.textOffset = data.textOffset or 0
    

    if data.enable == nil or type(data.enable) ~= "boolean" then
        self.enable = true
    end

    setmetatable(self, { __index = Marker })
    return self

end
