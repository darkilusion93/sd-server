ESX	= nil
local PlayerData = {}

local destinatario = nil
local remetente = nil
local coima = 0
local dados_papel_destino = {}
local dados_papel = {}

local assinatura_destino = false
local assinatura = false

local correctSCREEN = 1



Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	
	Citizen.Wait(30*1000)
	
	local x, y = GetActiveScreenResolution()
	
	if y < 1000 or y > 1200 then
	
		correctSCREEN = math.floor(100 * y / 1080) / 100
	
	end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)


RegisterCommand('dar_auto', function(source, args)
	if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or  PlayerData.job.name == 'municipal' or  PlayerData.job.name == 'pj' or PlayerData.job.name == 'siis' then
		if dados_papel_destino ~= {} then
			local ped_destino = GetPlayerFromServerId(destinatario)
			if ped_destino ~= nil and ped_destino > 0 then
				local coords_destino = GetEntityCoords(GetPlayerPed(ped_destino))
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local distance = #(coords_destino - pos)
				
				if distance < 4 then
					TriggerServerEvent('autocontra:enviar', dados_papel_destino, destinatario)
					exports['mythic_notify']:SendAlert('inform','Auto fornecido ao cidadão!')
				else
					exports['mythic_notify']:SendAlert('error','O destinatário do auto está muito longe!')	
				end
			else
				exports['mythic_notify']:SendAlert('error','O destinatário do auto não está perto de ti!')	
			end
		end
	else
		exports['mythic_notify']:SendAlert('error','Sem permissão!')	
	end
end)


RegisterNetEvent('autocontra:receber')
AddEventHandler('autocontra:receber', function(dataclient, fonte)
	assinatura = false
	dados_papel = dataclient
	coima = dataclient.coima
	remetente = fonte

    SetNuiFocus(true, true)
	
	
	SendNUIMessage({
		dados = dataclient,
		assinatura = "",
		botao = true,
		action = "auto",
		correct = correctSCREEN
	})

end)

RegisterNetEvent('autocontra:dados')
AddEventHandler('autocontra:dados', function(dataclient, target)
	assinatura_destino = false
	dados_papel_destino = dataclient	
	destinatario = target

    SetNuiFocus(true, true)
	
	
	SendNUIMessage({
		dados = dataclient,
		assinatura = "",
		botao = false,
		action = "auto",
		correct = correctSCREEN,
	})

end)


RegisterNetEvent('autocontra:emitido')
AddEventHandler('autocontra:emitido', function()
	assinatura_destino = true
	exports['mythic_notify']:SendAlert('inform','O cidadão assinou o auto!')
	
	SetNuiFocus(true, true)
	
	SendNUIMessage({
		dados = dados_papel_destino,
		assinatura = dados_papel_destino.nome,
		botao = false,
		action = "auto",
		correct = correctSCREEN
	})
	
end)

RegisterCommand('ver_auto', function(source, args)

	local dados_autoantigo = {}
	local assinado = false
	local algo = false

	if destinatario ~= nil then
		dados_autoantigo = dados_papel_destino
		assinado = assinatura_destino
		algo = true
	
	elseif remetente ~= nil then
		dados_autoantigo = dados_papel
		assinado = assinatura
		algo = true
	end
	
	if algo == true then
		SetNuiFocus(true, true)
		
		SendNUIMessage({
			dados = dados_autoantigo,
			assinatura = (assinado == true and dados_autoantigo.nome) or "",
			botao = false,
			action = "auto",
			correct = correctSCREEN
		})
	else
		exports['mythic_notify']:SendAlert('error','Não tens nenhum auto!')
	end

end)

RegisterNUICallback("assinado", function(data)
	assinatura = true
	if coima > 0 then
		TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_state', 'Contraordenação Rodoviária', coima)
		TriggerServerEvent('autocontra:assinado', remetente)
		coima = 0
	end
		
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

RegisterNUICallback("error", function(data)
	exports['mythic_notify']:SendAlert('error','A declaração não está totalmente preenchida!')
end)


RegisterNetEvent('police_s:dar_auto')
AddEventHandler('police_s:dar_auto', function()
	ExecuteCommand('dar_auto')
end)
RegisterNetEvent('police_s:ver_auto')
AddEventHandler('police_s:ver_auto', function()
	ExecuteCommand('ver_auto')
end)
RegisterNetEvent('police_s:gerar_auto')
AddEventHandler('police_s:gerar_auto', function()
	ExecuteCommand('gerar_auto')
end)
RegisterNetEvent('police_s:selo')
AddEventHandler('police_s:selo', function()
	ExecuteCommand('selo')
end)





local AV_name = ''
local AV_ID = ''

local AV_fonte = ''
local AV_data_recebida = {}


RegisterNetEvent('autocontra:criar_noti')
AddEventHandler('autocontra:criar_noti', function(dataAV)

    SetNuiFocus(true, true)
	AV_name = dataAV.agente
	AV_ID = dataAV.codeAV
	
	SendNUIMessage({
		action = 'criar_noti',
		botao = false,
		correct = correctSCREEN,
		dados = dataAV		
	})
	
end)


RegisterNetEvent('autocontra:check_destinoAV')
AddEventHandler('autocontra:check_destinoAV', function(data, target, targetname)

	local ped_destino = GetPlayerFromServerId(target)
	if ped_destino ~= nil and ped_destino > 0 then -- remover 0 para self test
		local coords_destino = GetEntityCoords(GetPlayerPed(ped_destino))
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local distance = #(coords_destino - pos)
		
		if distance < 4 then
			data.nomecondutor = targetname
			TriggerServerEvent('autocontra:enviarAV', data, target)
			
			exports['mythic_notify']:SendAlert('inform','Declaração fornecido ao cidadão!')
		else
			exports['mythic_notify']:SendAlert('error','O destinatário da declaração está muito longe!')	
		end
	else
		exports['mythic_notify']:SendAlert('error','O destinatário da declaração não está perto de ti!')	
	end


end)



RegisterNetEvent('autocontra:receberAV')
AddEventHandler('autocontra:receberAV', function(data, fonte)

	AV_fonte = fonte
	AV_data_recebida = data
	
	SetNuiFocus(true, true)
	
	SendNUIMessage({
		action = 'AV_show',
		botao = true,
		correct = correctSCREEN,
		dados = data
	})
end)


RegisterNetEvent('autocontra:receberAV_assinado')
AddEventHandler('autocontra:receberAV_assinado', function(data)

	AV_data_recebida = data
	
	SetNuiFocus(true, true)
	
	SendNUIMessage({
		action = 'AV_show',
		botao = false,
		correct = correctSCREEN,
		dados = data
	})
end)


RegisterNetEvent('autocontra:todosAV')
AddEventHandler('autocontra:todosAV', function(resultadosTODOS)

	local elements = {}
	
	for k,v in pairs(resultadosTODOS) do
		table.insert(elements, {label = 'Declaração '..k, value = v})
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'av',
	{
		title    = 'Declarações',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		
		TriggerEvent('autocontra:abrirAV_manual', data.current.value)

		menu.close()

	end, function(data, menu)
		menu.close()
	end)

	
	
end)

RegisterNetEvent('autocontra:abrirAV_manual')
AddEventHandler('autocontra:abrirAV_manual', function(dados)
		SetNuiFocus(true, true)
		
		SendNUIMessage({
			action = 'AV_show',
			correct = correctSCREEN,
			botao = false,
			dados = dados
		})
end)

RegisterNUICallback("dados_form", function(data)
	data.agente = AV_name
	data.ID = AV_ID
	
	TriggerServerEvent('autocontra:procurar_destinoAV', data)
end)


RegisterNUICallback("assinadoAV", function(data)
	TriggerServerEvent('autocontra:assinadoAV', AV_data_recebida, AV_fonte)	
end)




RegisterCommand('criar_av', function(source, args) --CRIAR NOVA DECLARACAO

	if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or  PlayerData.job.name == 'municipal' or  PlayerData.job.name == 'pj' or PlayerData.job.name == 'siis' then
	
		ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ocoorencia', {
			title = 'Número Ocorrência'
		}, function(data, menu)
		
			--local amount = tonumber(data.value)
			if data.value == nil then
				exports['mythic_notify']:SendAlert('error','Ocorrência Inválida')
			else
				menu.close()
				TriggerServerEvent('autocontra:novoAV', data.value)
		
			end
		
		end, function(data, menu)
			menu.close()
		end)

	else
		exports['mythic_notify']:SendAlert('error','Sem permissão!')	
	end
	
end)


--RegisterCommand('ver_av', function(source, args) -- VER O ÚLTIMO RECEBIDO, USAR ITEM EM ALTERNATIVA
--	if AV_data_recebida ~= {} then
--		
--		SetNuiFocus(true, true)
--		
--		SendNUIMessage({
--			action = 'AV_show',
--			correct = correctSCREEN,
--			botao = false,
--			dados = AV_data_recebida
--		})
--		
--	end
--end)


RegisterCommand('abrir_av', function(source, args) --VOLTAR A MOSTAR SE FECHADO


    SetNuiFocus(true, true)
	
	SendNUIMessage({
		action = 'open2',
		correct = correctSCREEN,
		botao = false,
	})

end)

RegisterCommand('dar_av', function(source, args) --DAR PARA ASSINAR

	if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or  PlayerData.job.name == 'municipal' or  PlayerData.job.name == 'pj' or PlayerData.job.name == 'siis' then
		
		if AV_ID == '' then
			exports['mythic_notify']:SendAlert('error','Tens de gerar uma declaração primeiro!')
			return
		end
		
		SendNUIMessage({
			action = 'get_noti',		
		})
	
	else
		exports['mythic_notify']:SendAlert('error','Sem permissão!')	
	end

end)




RegisterNetEvent('police_s:dar_av')
AddEventHandler('police_s:dar_av', function()
	ExecuteCommand('dar_av')
end)
RegisterNetEvent('police_s:abrir_av')
AddEventHandler('police_s:abrir_av', function()
	ExecuteCommand('abrir_av')
end)
RegisterNetEvent('police_s:criar_av')
AddEventHandler('police_s:criar_av', function()
	ExecuteCommand('criar_av')
end)