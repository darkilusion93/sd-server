

function ESX.HasPlayerPermsToCreateRaces(source)
    local job = ESX.getJob(source)
    local station = Config.Stations[job.name]

    if station and station.CanBossCreateRaces then
        if job.grade_name == "boss" then
            return true
        end
    end

    return false
end