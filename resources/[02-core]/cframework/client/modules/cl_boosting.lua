

local boostingData = LoadBoosting()

ESX.GetContractInfo = function(contractId)
    if boostingData.contracts[contractId].vehicleType then
        boostingData.contracts[contractId].vehicleTypeLabel = boostingData.vehiclesLabels[boostingData.contracts[contractId].vehicleType]
    end

    return boostingData.contracts[contractId]
end

ESX.GetMissionInfo = function(missionId)
    return boostingData.missions[missionId]
end
