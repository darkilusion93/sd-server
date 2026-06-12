


local function getInfluence(influenceId)
    return RPC.execute("cframework:getInfluence", influenceId)
end

function ESX.requestInfluence(influenceId)
    return getInfluence(influenceId)
end