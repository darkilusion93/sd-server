
ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
PlayerData = {}

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	local job = xPlayer.job
	PlayerData = xPlayer
	local blackMoney = 0
	local cash = 0
	for _,v in ipairs(PlayerData.invData.items) do
		if v.name == "black_money" then
			blackMoney = v.count
		end
		if v.name == "cash" then
			cash = v.count
		end
	end

    SendNUIMessage({
		id = GetPlayerServerId(PlayerId()),
        cash = cash,
        black_money = blackMoney,
        bank = xPlayer.bank,
        job = job.label .. ' - ' .. job.grade_label
    })
	if job.grade_name == "boss" then
		SendNUIMessage({ soci = true })
		SendNUIMessage({ society = xPlayer.societyMoney })
	else
		SendNUIMessage({ soci = false })
	end
end)

RegisterNetEvent("esx:addInventoryItem", function(item, count, total)
	if item.name == "cash" then
    	SendNUIMessage({
			id = GetPlayerServerId(PlayerId()),
    	    cash = total
    	})
	end
end)

RegisterNetEvent("esx:removeInventoryItem", function(item, count, total)
	if item.name == "cash" then
    	SendNUIMessage({
			id = GetPlayerServerId(PlayerId()),
    	    cash = total
    	})
	end
end)

RegisterNetEvent('esx:setJob', function(job, societyMoney)
    SendNUIMessage({
		id = GetPlayerServerId(PlayerId()),
        job = job.label .. ' - ' .. job.grade_label
    })
	if job.grade_name == "boss" then
		SendNUIMessage({ soci = true })
		SendNUIMessage({ society = societyMoney })
	else
		SendNUIMessage({ soci = false })
	end
end)

RegisterNetEvent("getMenuInfo", function(value)
	SendNUIMessage({disp = value})
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'bank' then
		SendNUIMessage({
			id = GetPlayerServerId(PlayerId()),
    	    bank = account.money
    	})
	elseif account.name == 'black_money' then
		SendNUIMessage({
			id = GetPlayerServerId(PlayerId()),
		    black_money = account.money
		})
	end
end)

RegisterNetEvent('esx_addonaccount:setMoney', function(name, money)	
	SendNUIMessage({ society = money })
end)

Citizen.CreateThread(function()
    -- 1. Espera até que o ficheiro do minimapa esteja carregado na memória do jogo
    local minimap = RequestScaleformMovie("minimap")
    while not HasScaleformMovieLoaded(minimap) do
        Citizen.Wait(100)
    end

    -- Forçar o tamanho normal do mapa logo ao iniciar
    SetRadarBigmapEnabled(false, false)
    
    -- 2. Loop Seguro (Executa a cada 1.5 segundos, prevenindo que o mapa fique gigante)
    while true do
        Citizen.Wait(1500) 
        
        -- Aplica o layout '3' (Golf) que remove as barras de vida/escudo
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3) 
        EndScaleformMovieMethod()
    end
end)