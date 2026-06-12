--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

--
ped = {}

-- class table
local Ped = {}

--
-- Show Ped
--
function Ped:Show()

    if self.ped ~= nil and DoesEntityExist(self.ped) then
        return
    end

    if not HasModelLoaded(self.model) then
        RequestModel(self.model)
        repeat Wait(0) until HasModelLoaded(self.model)
    end

    self.ped = CreatePed(4, self.model, self.x, self.y, self.z, self.w, false, true)

    SetEntityCanBeDamaged(self.ped, false)
    SetBlockingOfNonTemporaryEvents(self.ped, true)
    SetPedCanRagdollFromPlayerImpact(self.ped, false)

    SetPedResetFlag(self.ped, 249, true)
    SetPedConfigFlag(self.ped, 185, true)
    SetPedConfigFlag(self.ped, 108, true)
    SetPedConfigFlag(self.ped, 208, true)

end

function Ped:Hide()

    if self.ped == nil or not DoesEntityExist(self.ped) then
        return
    end

    DeleteEntity(self.ped)

end

--
-- Create new instace of Ped
--
function ped.new(data)

    assert(type(data.x) == "number", "Ped : x must be number")
    assert(type(data.y) == "number", "Ped : y must be number")
    assert(type(data.z) == "number", "Ped : z must be number")
    assert(type(data.w) == "number", "Ped : w must be number")

    local self = data
    self.model = data.model or `mp_m_freemode_01`

    if data.enable == nil or type(data.enable) ~= "boolean" then
        self.enable = true
    end

    setmetatable(self, { __index = Ped })
    return self

end
