-- Title	:	sv_doctor.lua
-- Author   :   Peter
-- Started  :   19/01/25

local emsOnline = 0
local doctorData = LoadDoctor()

AddEventHandler("esx:onlineEms", function(count)
    emsOnline = count or 0
end)

RegisterNetEvent("cframework:payHospitalDoctor", function(idx)
	local source <const> = source
	local xPlayer <const> =  ESX.GetPlayerFromId(source)
	local loc <const> = doctorData.locations[idx]

    if loc == nil then
        return
    end

    if not ESX.playerInsideLocation(source, {loc.doctor.xyz}, 10.0) then
        return
    end

	if (xPlayer.dead == 1 or xPlayer.dead == true) and (xPlayer.deathData.bleeding == 5 or xPlayer.deathData.bleeding == "5") then
		TriggerClientEvent("cframework:playerIsDead", source)
		return
	end

	local price <const> = emsOnline > doctorData.emsThreshold and doctorData.priceWithEms or doctorData.priceBase

	--ESX.logRevives(source, source, "REVIVE", "DR MARIO")
	TriggerEvent("cframework:sendBill", source, "society_ambulance", "Hospital", price)
	TriggerClientEvent("cframework:startRevive", source, idx, 1)
end)
