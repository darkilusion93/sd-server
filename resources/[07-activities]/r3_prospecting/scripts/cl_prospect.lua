ESX = nil
local blip_location = vector3(4797.06, -4584.28, 22.27)
local blip = nil
local area_blip = nil
local area_size = 350.0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- CreateThread(function()
--     -- AddTextEntry("PROSP_BLIP", Config.ProspectingBlipText)
--     -- blip = AddBlipForCoord(blip_location)
--     -- SetBlipSprite(blip, Config.ProspectingBlipSprite)
--     -- SetBlipAsShortRange(blip, true)
--     -- BeginTextCommandSetBlipName("PROSP_BLIP")
--     -- EndTextCommandSetBlipName(blip)
--     -- area_blip = AddBlipForRadius(blip_location, area_size)
--     -- SetBlipSprite(area_blip, 10)
-- end)

RegisterNetEvent("r3_prospecting:startProspecting")
AddEventHandler("r3_prospecting:startProspecting", function()
    local pos = GetEntityCoords(PlayerPedId())

    local dist = #(pos - blip_location)
    if dist < area_size then
        TriggerServerEvent("r3_prospecting:activateProspecting")
    else
		exports['okokNotify']:Alert("ERROR", "Não estás na zona de prospecção!", 5000, 'error')
	end
end, false)

RegisterNetEvent("r3_prospecting:useDetector")
AddEventHandler("r3_prospecting:useDetector", function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		exports['okokNotify']:Alert("ERROR", "Não podes estar numa viatura!", 5000, 'error')
	else
		TriggerEvent("r3_prospecting:startProspecting")
	end
end)