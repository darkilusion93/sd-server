

RegisterServerEvent('cframework:takeHostage', function(target, animationLib,animationLib2, animation, animation2, distans, distans2, height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget,attachFlag)
	local source <const> = source

	if targetSrc == -1 or targetSrc == nil then return end

    local playerPed <const>, targetPed <const> = GetPlayerPed(source), GetPlayerPed(targetSrc)

    if not DoesEntityExist(playerPed) or not DoesEntityExist(targetPed) then return end
	if not IsEntityVisible(playerPed) then return end

	if #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed)) > 10.0 then
		return
	end

	TriggerClientEvent('cframework:takeHostageTargetSync', targetSrc, source, animationLib2, animation2, distans, distans2, height, length,spin,controlFlagTarget,animFlagTarget,attachFlag)
	TriggerClientEvent('cframework:takeHostageSelfSync', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
end)

RegisterServerEvent('cframework:releaseHostage', function(targetSrc)
	if targetSrc ~= nil and targetSrc ~= 0 and targetSrc ~= -1 then
		TriggerClientEvent('cframework:releaseHostageClient', targetSrc)
	end
end)
