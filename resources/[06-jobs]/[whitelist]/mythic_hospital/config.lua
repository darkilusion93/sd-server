Config = Config or {}
Config.Debug = false

-- Keys
Config.Keys = {}
Config.Keys.GetUp = 73 -- Key Used To Get Out Of Bed When Using /bed Command
Config.Keys.Revive = 38 -- Key Used To Revive Or Teleport

--[[
    GENERAL SETTINGS | THESE WILL AFFECT YOUR ENTIRE SERVER SO BE SURE TO SET THESE CORRECTLY
    MaxHp : Maximum HP Allowed, set to -1 if you want to disable mythic_hospital from setting this
        NOTE: Anything under 100 and you are dead
    RegenRate : 
]]
Config.MaxHp = 200
Config.RegenRate = 0.0

--[[
    HiddenRevChance : The % Chance That Using The Hidden Revive Spot Will Result In A Full Revive With All Limb Damage & Bleeds Removed
    HiddenCooldown : The time, in minutes, for how long a player must wait before using the hidden revive spot again
]]
Config.HiddenRevChance = 65
Config.HiddenCooldown = 30

--[[
    Pricing
]]
Config.InjuryBase = 250
Config.HiddenInjuryBase = 1000

--[[
    AlertShowInfo : 
]]
Config.AlertShowInfo = 2

--[[

]]
Config.Hospital = {
	Location = { x = -256.132, y = 6329.224, z = 32.408, h = 179.07 },
	Location2 = { x = -1852.96, y = -338.55, z = 49.44, h = 315.62 },
	Location3 = { x = 99999999.12, y = 999999.25, z = 9999999.41, h = 180.4409942627 },
	Location4 = { x = 99999999.12, y = 999999.25, z = 9999999.41, h = 180.4409942627 },
    ShowBlip = false,
}
Config.Hospital.Blip = { name = "Pillbox Medical Center", color = 38, id = 153, scale = 1.0, short = false, x = Config.Hospital.Location.x, y = Config.Hospital.Location.y, z = Config.Hospital.Location.z }

--[[
    Hidden: Location of the hidden location where you can heal and no alert of GSW's will be made.
]]

Config.Hidden = {
   Location = { x = 1984.14, y = 5176.25, z = -47.65 },
   ShowBlip = false,
}
Config.Hidden.Blip = { name = 'Hidden Medic', color = 12, id = 153, scale = 1.0, short = false, x = Config.Hidden.Location.x, y = Config.Hidden.Location.y, z = Config.Hidden.Location.z }

Config.Teleports = {
}