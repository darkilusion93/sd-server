


function ESX.GetJobMetadataKey(key)
    return ESX.PlayerData.job.metadata[key]
end

RegisterNetEvent("cframework:updateJobMetadata", function(metadata)
    ESX.PlayerData.job.metadata = metadata
end)

RegisterNetEvent("esx:setJob", function(job)
	ESX.PlayerData.job = job
end)
