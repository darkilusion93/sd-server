

local writeQueue = {}

function ESX.MySqlQueueQuery(query, params)
    writeQueue[#writeQueue + 1] = {query = query, values = params}
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)

        if #writeQueue > 0 then
            local batch = {}

            -- up to 300 queries per batch
            for i = 1, 300 do
                local q = table.remove(writeQueue, 1)
                if not q then break end
                batch[#batch+1] = q
            end

            exports.oxmysql:transaction(batch)
        end
    end
end)