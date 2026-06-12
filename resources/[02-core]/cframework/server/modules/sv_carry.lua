local playersBeingCarried = {}
local playersCarried = {}

function IsPlayerBeingCarried(player)
	return playersCarried[player] == true
end

RPC.register("cframework:carrySync", function(targetSrc)
	local source <const> = source
    local isAdmin <const> = ESX.getGroup(source) ~= "user"

	if targetSrc == -1 then return false end

	if not IsEntityVisible(GetPlayerPed(source)) then return false end

	if playersBeingCarried[targetSrc] then return false end
	if playersBeingCarried[source] then return false end

	if #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(targetSrc))) > 10.0 then
		return false
	end

	playersBeingCarried[targetSrc] = true
	playersBeingCarried[source] = true
	playersCarried[targetSrc] = true

	TriggerClientEvent('cframework:syncCarryTarget', targetSrc, source, isAdmin)
	return true
end)


RegisterServerEvent('cframework:stopCarry', function(targetSrc)
	local source <const> = source

	if targetSrc == -1 or targetSrc == 0 or targetSrc == nil then return end

	playersBeingCarried[targetSrc] = nil
	playersBeingCarried[source] = nil
	playersCarried[targetSrc] = nil

	TriggerClientEvent('cframework:stopCarrySync', targetSrc)
end)
