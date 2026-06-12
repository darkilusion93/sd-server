

local emptyVehicles = {}
local warnsSent = {}
local persistentVehicles = {}

Citizen.CreateThread(function()
	while true do
        ---@diagnostic disable-next-line: param-type-mismatch
		for _, v in pairs(GetAllVehicles()) do
			if DoesEntityExist(v) and GetPedInVehicleSeat(v, -1) == 0 and emptyVehicles[v] == nil and not persistentVehicles[v] then
				emptyVehicles[v] = { timestamp = os.time() + 3600, entity = v }
                warnsSent[v] = nil
				--SetEntityDistanceCullingRadius(v, 75.0)
			end
		end

		for _, v in pairs(emptyVehicles) do
			if DoesEntityExist(v.entity) and GetPedInVehicleSeat(v.entity, -1) == 0 and not persistentVehicles[v.entity] then
				if v.timestamp < os.time() then
					DeleteEntity(v.entity)
					emptyVehicles[v.entity] = nil
                    warnsSent[v.entity] = nil
				end

                if v.timestamp < os.time() - 300 then -- 5 minutes left
                    if not warnsSent[v.entity] then
                        local serverId <const> = NetworkGetEntityOwner(v.entity)
                        local plate <const> = GetVehicleNumberPlateText(v.entity)

                        TriggerClientEvent("esx:showNotification", serverId, (T("VEHICLE_CLEANUP_WARN")):format(plate), "inform")

                        warnsSent[v.entity] = true
                    end
                end
			else
				--SetEntityDistanceCullingRadius(v.entity , 0.0)
				emptyVehicles[v.entity] = nil
			end
		end

		Citizen.Wait(2500)
	end
end)

AddEventHandler("cframework:resetVehicleCleanup", function(vehicle)
    if emptyVehicles[vehicle] then
        emptyVehicles[vehicle] = nil
    end
end)

RegisterNetEvent("cframework:setPersistentVehicle", function(vehicleNetId, persistent)
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)

    if persistent then
        persistentVehicles[vehicle] = true
    else
        persistentVehicles[vehicle] = nil
    end
end)