chudReady = false

RegisterNetEvent('esx:setJob', function(job, societyMoney)
	SendNUIMessage({action = 'hud', part = 'isBoss', text = job.grade_name })
	SendNUIMessage({action = 'hud', part = 'jobMoney', text = societyMoney })
	SendNUIMessage({action = 'hud', part = 'job', text = job.label .. ' - ' .. job.grade_label })
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'bank' then
		SendNUIMessage({action = 'hud', part = 'bank', text = account.money })
	end
end)

RegisterNetEvent('esx_addonaccount:setMoney', function(name, money)	
	SendNUIMessage({action = 'hud', part = 'jobMoney', text = money })
end)

RegisterNetEvent('cframework:updateCoins', function(pCoins)
	SendNUIMessage({action = 'hud', part = 'coins', text = pCoins })
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	local job = xPlayer.job

	while not chudReady do Citizen.Wait(0) end

	SendNUIMessage({action = 'hud', part = 'isBoss', text = job.grade_name })
	SendNUIMessage({action = 'hud', part = 'jobMoney', text = xPlayer.societyMoney })
	SendNUIMessage({action = 'hud', part = 'job', text = job.label .. ' - ' .. job.grade_label })
	SendNUIMessage({action = 'hud', part = 'bank', text = xPlayer.bank })
    SendNUIMessage({action = 'hud', part = 'coins', text = xPlayer.coins })
end)

RegisterNUICallback("chudReady", function(data, cb)
    chudReady = true

    cb("ok")
end)