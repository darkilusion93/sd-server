ESX = exports.cframework:getSharedObject()

local depositou = 'https://discord.com/api/webhooks/'
local retirou = 'https://discord.com/api/webhooks/'
local transferiu = 'https://discord.com/api/webhooks/'

function interp(s, tab)
	return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

-- FIX C2 (2026-06-12): montante seguro (inteiro > 0). Antes nenhum handler
-- validava amount>0 — valor negativo invertia a aritmética (transfer negativo
-- roubava de terceiros). Aplicado à entrada de todos os handlers de dinheiro.
local function safeAmount(v)
	v = tonumber(v)
	if not v then return nil end
	v = math.floor(v)
	if v <= 0 then return nil end
	return v
end

-- FIX (2026-06-13): saque/transferência DA sociedade só pelo boss. Antes os
-- handlers de sociedade não verificavam membership/grade → qualquer jogador
-- drenava o cofre de qualquer sociedade ("society_<job>") para o próprio bolso.
-- Convenção de boss = grade_name "boss" (igual ao fix C20 do cframework sv_society).
local function isSocietyBoss(xPlayer, society)
	if not xPlayer or type(society) ~= "string" then return false end
	local jobName = society:gsub("^society_", "")
	local job = xPlayer.job
	if not job then return false end
	return job.name == jobName and job.grade_name == "boss"
end

ESX.RegisterServerCallback("okokBanking:GetPlayerInfo", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local db = result[1]
		local data = {
			playerName = getName(source),
			playerBankMoney = xPlayer.getAccount('bank').money,
			playerIBAN = db.iban,
			walletMoney = xPlayer.getMoney(),
			sex = db.sex,
		}

		cb(data)
	end)
end)

ESX.RegisterServerCallback("okokBanking:IsIBanUsed", function(source, cb, iban)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM users WHERE iban = @iban', {
		['@iban'] = iban
	}, function(result)
		local db = result[1]

		if db ~= nil then
			cb(db, true)
		else
			if Config.UseAddonAccount then
				MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE owner = @iban', {
					['@iban'] = iban
				}, function(result2)
					local db2 = result2[1]
					local dbdata
					if db2 ~= nil then
						while json.encode(ESX.Jobs) == "[]" do
							ESX = exports.cframework:getSharedObject()
							Citizen.Wait(100)
						end
						dbdata = {
							iban = db2.owner,
							value = db2.money,
							society_name = ESX.Jobs[string.gsub(db2.account_name, "society_", "")].label,
							society = db2.account_name
						}
					end
					
					cb(dbdata, false)
				end)
			else
				MySQL.Async.fetchAll('SELECT * FROM okokbanking_societies WHERE iban = @iban', {
					['@iban'] = iban
				}, function(result2)
					local db2 = result2[1]
					
					cb(db2, false)
				end)
			end
		end
	end)
end)

ESX.RegisterServerCallback("okokBanking:GetPIN", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT pincode FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
	}, function(result)
		local pin = result[1]

		cb(pin.pincode)
	end)
end)

ESX.RegisterServerCallback("okokBanking:SocietyInfo", function(source, cb, society)
	if Config.UseAddonAccount then
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = society
		}, function(result)
			local db = result[1]
			local aa
			if db ~= nil then
				while json.encode(ESX.Jobs) == "[]" do
					ESX = exports.cframework:getSharedObject()
					Citizen.Wait(100)
				end
				aa = {
					value = db.money,
					society_name = ESX.Jobs[string.gsub(db.account_name, "society_", "")].label,
					society = db.account_name,
					iban = db.owner
				}
			end
			cb(aa)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM okokbanking_societies WHERE society = @society', {
			['@society'] = society
		}, function(result)
			local db = result[1]
			cb(db)
		end)
	end
end)

RegisterServerEvent("okokBanking:CreateSocietyAccount")
AddEventHandler("okokBanking:CreateSocietyAccount", function(society, society_name, value, iban)
	-- FIX C3 (2026-06-12): contas de sociedade começam SEMPRE a 0. Antes o
	-- cliente escolhia o saldo inicial (value) → criar conta pré-financiada.
	value = 0
	if type(society) ~= "string" or type(iban) ~= "string" then return end
	if Config.UseAddonAccount then
		MySQL.Async.insert('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, @owner)', {
			['@account_name'] = society,
			['@money'] = value,
			['@owner'] = string.gsub(iban:upper(), " ", ""),
		}, function (result)
		end)
	else
		MySQL.Async.insert('INSERT INTO okokbanking_societies (society, society_name, value, iban) VALUES (@society, @society_name, @value, @iban)', {
			['@society'] = society,
			['@society_name'] = society_name,
			['@value'] = value,
			['@iban'] = iban:upper(),
		}, function (result)
		end)
	end
end)

RegisterServerEvent("okokBanking:SetIBAN")
AddEventHandler("okokBanking:SetIBAN", function(iban)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	-- FIX C4 (2026-06-12): IBAN tem de ser único — senão clonava-se o IBAN de
	-- uma vítima para intercetar transferências.
	if type(iban) ~= "string" or #iban == 0 or #iban > 32 then return end
	local existing = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE iban = @iban', { ['@iban'] = iban })
	if existing[1] and existing[1].identifier ~= xPlayer.identifier then return end

	MySQL.Async.execute('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
		['@iban'] = iban,
	}, function (result)
	end)
end)

ESX.RegisterServerCallback("okokBanking:HasCreditCard", function(source, cb)
	cb(ESX.GetPlayerFromId(source).getInventoryItem(Config.CreditCardItem).count >=1)
end)

RegisterServerEvent("okokBanking:DepositMoney")
AddEventHandler("okokBanking:DepositMoney", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	local playerMoney = xPlayer.getMoney()

	if amount <= playerMoney then
		if Config.ESX11 then
			xPlayer.removeMoney(amount)
		else
			xPlayer.removeAccountMoney('money', amount)
		end
		xPlayer.addAccountMoney('bank', amount)

		TriggerEvent('okokBanking:AddDepositTransaction', amount, source)
		TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', source, _L('deposited').title, interp(_L('deposited').text, {s1 = amount}), _L('deposited').time, _L('deposited').type)
		local msg = "O Player (".. source ..") " .. GetPlayerName(source) .." depositou " .. amount .. " € "
		PerformHttpRequest(depositou, function(err, text, headers) end, 'POST', json.encode({username = "Banco", content = msg}), { ['Content-Type'] = 'application/json' })
		--DepositMoneyWebhook({sender_name = getName(source), value = ESX.Math.GroupDigits(amount)})
	else
		TriggerClientEvent('okokNotify:Alert', source, _L('no_money_pocket').title, _L('no_money_pocket').text, _L('no_money_pocket').time, _L('no_money_pocket').type)
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoney")
AddEventHandler("okokBanking:WithdrawMoney", function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	local playerMoney = xPlayer.getAccount('bank').money

	if amount <= playerMoney then
		xPlayer.removeAccountMoney('bank', amount)
		if Config.ESX11 then
			xPlayer.addMoney(amount)
		else
			xPlayer.addAccountMoney('money', amount)
		end

		TriggerEvent('okokBanking:AddWithdrawTransaction', amount, source)
		TriggerClientEvent('okokBanking:updateTransactions', source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', source, _L('withdrawn').title, interp(_L('withdrawn').text, {s1 = amount}), _L('withdrawn').time, _L('withdrawn').type)
		local msg = "O Player (".. source ..") " .. GetPlayerName(source) .." retirou " .. amount .. " € "
		PerformHttpRequest(retirou, function(err, text, headers) end, 'POST', json.encode({username = "Banco", content = msg}), { ['Content-Type'] = 'application/json' })
		--WithdrawMoneyWebhook({receiver_name = getName(source), value = ESX.Math.GroupDigits(amount)})
	else
		TriggerClientEvent('okokNotify:Alert', source, _L('no_money_bank').title, _L('no_money_bank').text, _L('no_money_bank').time, _L('no_money_bank').type)
	end
end)

RegisterServerEvent("okokBanking:TransferMoney")
AddEventHandler("okokBanking:TransferMoney", function(amount, ibanNumber, targetIdentifier, acc, targetName)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	-- FIX C2 (2026-06-12): amount inteiro>0; o IBAN destino resolve o
	-- targetIdentifier server-side (não confiar no que o cliente envia);
	-- o lado do alvo NUNCA usa o JSON `acc` do cliente (reescrevia as
	-- contas todas da vítima) — usa fetch+update server-side.
	amount = safeAmount(amount); if not amount then return end
	if type(ibanNumber) ~= "string" then return end
	ibanNumber = ibanNumber:upper()
	local playerMoney = xPlayer.getAccount('bank').money

	-- resolver o destinatário pelo IBAN, server-side
	local ibanRow = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE iban = @iban', { ['@iban'] = ibanNumber })
	if not ibanRow[1] then
		TriggerClientEvent('okokNotify:Alert', _source, _L('no_money_bank').title, "IBAN inválido", _L('no_money_bank').time, _L('no_money_bank').type)
		return
	end
	targetIdentifier = ibanRow[1].identifier

	if xPlayer.identifier == targetIdentifier then
		TriggerClientEvent('okokNotify:Alert', _source, _L('not_send_yourself').title, _L('not_send_yourself').text, _L('not_send_yourself').time, _L('not_send_yourself').type)
		return
	end
	if amount > playerMoney then
		TriggerClientEvent('okokNotify:Alert', _source, _L('no_money_bank').title, _L('no_money_bank').text, _L('no_money_bank').time, _L('no_money_bank').type)
		return
	end

	local tName = getName(targetIdentifier)
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)
	xPlayer.removeAccountMoney('bank', amount)
	TriggerEvent('okokBanking:AddTransferTransaction', amount, xTarget, _source, tName, targetIdentifier)
	TriggerClientEvent('okokBanking:updateTransactions', _source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
	TriggerClientEvent('okokNotify:Alert', _source, _L('transferred_to').title, interp(_L('transferred_to').text, {s1 = amount, s2 = tName}), _L('transferred_to').time, _L('transferred_to').type)
	PerformHttpRequest(transferiu, function() end, 'POST', json.encode({username = "Banco", content = "O Player (".. _source ..") " .. GetPlayerName(_source) .." transferiu " .. amount .. " € para "..tName}), { ['Content-Type'] = 'application/json' })

	if not Config.ESX11 then
		-- ler as contas REAIS do alvo e somar ao bank (ignora `acc` do cliente)
		local trow = MySQL.Sync.fetchAll('SELECT accounts FROM users WHERE identifier = @target', { ['@target'] = targetIdentifier })
		if trow[1] and trow[1].accounts then
			local tAcc = json.decode(trow[1].accounts) or {}
			tAcc.bank = (tAcc.bank or 0) + amount
			MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE identifier = @target', {
				['@accounts'] = json.encode(tAcc),
				['@target'] = targetIdentifier,
			})
		end
	else
		MySQL.Async.execute('UPDATE users SET bank = bank + @bank WHERE identifier = @target', {
			['@bank'] = amount,
			['@target'] = targetIdentifier
		})
	end
end)

RegisterServerEvent("okokBanking:DepositMoneyToSociety")
AddEventHandler("okokBanking:DepositMoneyToSociety", function(amount, society, societyName)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	local playerMoney = xPlayer.getMoney()

	if amount <= playerMoney then
		if Config.UseAddonAccount then
			MySQL.Async.execute('UPDATE addon_account_data SET money = money + @money WHERE account_name = @account_name', {
				['@money'] = amount,
				['@account_name'] = society,
			}, function(changed)
				TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
					account.addMoney(amount)
				end)
			end)
		else
			MySQL.Async.execute('UPDATE okokbanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
				['@value'] = amount,
				['@society'] = society,
				['@society_name'] = societyName,
			}, function(changed)
			end)
		end

		if Config.ESX11 then
			xPlayer.removeMoney(amount)
		else
			xPlayer.removeAccountMoney('money', amount)
		end

		TriggerEvent('okokBanking:AddDepositTransactionToSociety', amount, source, society, societyName)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', source, _L('deposited_to').title, interp(_L('deposited_to').text, {s1 = amount, s2 = societyName}), _L('deposited_to').time, _L('deposited_to').type)
		else
		TriggerClientEvent('okokNotify:Alert', source, _L('no_money_pocket').title, _L('no_money_pocket').text, _L('no_money_pocket').time, _L('no_money_pocket').type)
	end
end)

RegisterServerEvent("okokBanking:WithdrawMoneyToSociety")
AddEventHandler("okokBanking:WithdrawMoneyToSociety", function(amount, society, societyName, societyMoney)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	local _source = source
	if not isSocietyBoss(xPlayer, society) then
		TriggerClientEvent('okokNotify:Alert', _source, _L('society_no_money').title, "Sem permissão (só o patrão)", _L('society_no_money').time, _L('society_no_money').type)
		return
	end
	local db
	local hasChecked = false

	if Config.UseAddonAccount then
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = society
		}, function(result)
			db = result[1]
			hasChecked = true
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM okokbanking_societies WHERE society = @society', {
			['@society'] = society
		}, function(result)
			db = result[1]
			hasChecked = true
		end)
	end

	MySQL.Async.execute('UPDATE okokbanking_societies SET is_withdrawing = 1 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)

	while not hasChecked do 
		Citizen.Wait(100)
	end
	
	if db.value ~= nil and amount <= db.value or db.money ~= nil and amount <= db.money then
		if db.is_withdrawing ~= nil and db.is_withdrawing == 1 then
			TriggerClientEvent('okokNotify:Alert', _source, _L('someone_withdrawing').title, _L('someone_withdrawing').text, _L('someone_withdrawing').time, _L('someone_withdrawing').type)
		else
			if Config.UseAddonAccount then
				MySQL.Async.execute('UPDATE addon_account_data SET money = money - @money WHERE account_name = @account_name', {
					['@money'] = amount,
					['@account_name'] = society,
				}, function(changed)
					TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
						account.removeMoney(amount)
					end)
				end)
			else
				MySQL.Async.execute('UPDATE okokbanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
					['@value'] = amount,
					['@society'] = society,
					['@society_name'] = societyName,
				}, function(changed)
				end)
			end
			
			if Config.ESX11 then
				xPlayer.addMoney(amount)
			else
				xPlayer.addAccountMoney('money', amount)
			end

			TriggerEvent('okokBanking:AddWithdrawTransactionToSociety', amount, _source, society, societyName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', _source, xPlayer.getMoney())
			TriggerClientEvent('okokNotify:Alert', _source, _L('you_have_withdrawn').title, interp(_L('you_have_withdrawn').text, {s1 = amount, s2 = societyName}), _L('you_have_withdrawn').time, _L('you_have_withdrawn').type)
		end
	else
		TriggerClientEvent('okokNotify:Alert', _source, _L('society_no_money').title, _L('society_no_money').text, _L('society_no_money').time, _L('society_no_money').type)
	end

	MySQL.Async.execute('UPDATE okokbanking_societies SET is_withdrawing = 0 WHERE society = @society AND society_name = @society_name', {
		['@value'] = amount,
		['@society'] = society,
		['@society_name'] = societyName,
	}, function(changed)
	end)
end)

RegisterServerEvent("okokBanking:TransferMoneyToSociety")
AddEventHandler("okokBanking:TransferMoneyToSociety", function(amount, ibanNumber, societyName, society)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	local playerMoney = xPlayer.getAccount('bank').money
	if amount <= playerMoney then
		if Config.UseAddonAccount then
			MySQL.Async.execute('UPDATE addon_account_data SET money = money + @money WHERE owner = @owner', {
				['@money'] = amount,
				['@owner'] = ibanNumber
			}, function(changed)
				TriggerEvent('esx_addonaccount:getSharedAccount', ibanNumber, function(account)
					account.addMoney(amount)
				end)
			end)
		else
			MySQL.Async.execute('UPDATE okokbanking_societies SET value = value + @value WHERE iban = @iban', {
				['@value'] = amount,
				['@iban'] = ibanNumber
			}, function(changed)
			end)
		end
		xPlayer.removeAccountMoney('bank', amount)
		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, _source, society, societyName)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', _source, xPlayer.getMoney())
		TriggerClientEvent('okokBanking:updateTransactions', _source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('okokBanking:updateMoney', _source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', _source, _L('transferred_to').title, interp(_L('transferred_to').text, {s1 = amount, s2 = societyName}), _L('transferred_to').time, _L('transferred_to').type)
		
	else
		TriggerClientEvent('okokNotify:Alert', _source, _L('no_money_bank').title, _L('no_money_bank').text, _L('no_money_bank').time, _L('no_money_bank').type)
	end
end)

function getSocietyInfo(society, iban)
	local done = false
	local societyInfo = nil
	if Config.UseAddonAccount then
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = society
		}, function(result)
			local db = result[1]
			local aa
			if db ~= nil then
				while json.encode(ESX.Jobs) == "[]" do
					ESX = exports.cframework:getSharedObject()
					Citizen.Wait(100)
				end
				aa = {
					value = db.money,
					society_name = ESX.Jobs[string.gsub(db.account_name, "society_", "")].label,
					society = db.account_name,
					iban = db.owner
				}
			end
			societyInfo = aa
			done = true
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM okokbanking_societies WHERE society = @society', {
			['@society'] = society
		}, function(result)
			local db = result[1]
			societyInfo = db
			done = true
		end)
	end
	while not done do
		Citizen.Wait(100)
	end
	return societyInfo
end

RegisterServerEvent("okokBanking:TransferMoneyToSocietyFromSociety")
AddEventHandler("okokBanking:TransferMoneyToSocietyFromSociety", function(amount, ibanNumber, societyNameTarget, societyTarget, society, societyName, societyMoney)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	if not isSocietyBoss(xPlayer, society) then return end
	local xPlayers = ESX.GetPlayers()

	-- teto a partir do saldo REAL da sociedade (server-side), não do cliente
	local societyInfo = getSocietyInfo(society, ibanNumber)
	if not societyInfo then return end

	if amount <= societyInfo.value then
		if Config.UseAddonAccount then
			MySQL.Async.execute('UPDATE addon_account_data SET money = money + @money WHERE account_name = @account_name', {
				['@money'] = amount,
				['@account_name'] = societyTarget,
			}, function(changed)
				MySQL.Async.execute('UPDATE addon_account_data SET money = money - @money WHERE account_name = @account_name', {
					['@money'] = amount,
					['@account_name'] = society,
				}, function(changed)
					TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
						account.removeMoney(amount)
						TriggerEvent('esx_addonaccount:getSharedAccount', societyTarget, function(account)
							account.addMoney(amount)
						end)
					end)
				end)
			end)
		else
			MySQL.Async.execute('UPDATE okokbanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
				['@value'] = amount,
				['@society'] = society,
				['@society_name'] = societyName,
			}, function(changed)
				MySQL.Async.execute('UPDATE okokbanking_societies SET value = value + @value WHERE society = @society AND society_name = @society_name', {
					['@value'] = amount,
					['@society'] = societyTarget,
					['@society_name'] = societyNameTarget,
				}, function(changed)
				end)
			end)
		end
		TriggerEvent('okokBanking:AddTransferTransactionFromSociety', amount, society, societyName, societyTarget, societyNameTarget)
		TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', source, _L('transferred_to').title, interp(_L('transferred_to').text, {s1 = amount, s2 = societyNameTarget}), _L('transferred_to').time, _L('transferred_to').type)
		
	else
		TriggerClientEvent('okokNotify:Alert', source, _L('society_no_money').title, _L('society_no_money').text, _L('society_no_money').time, _L('society_no_money').type)
	end
end)

RegisterServerEvent("okokBanking:TransferMoneyToPlayerFromSociety")
AddEventHandler("okokBanking:TransferMoneyToPlayerFromSociety", function(amount, ibanNumber, targetIdentifier, acc, targetName, society, societyName, societyMoney, toMyself)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	if not isSocietyBoss(xPlayer, society) then return end
	local xTarget = ESX.GetPlayerFromIdentifier(targetIdentifier)
	local xPlayers = ESX.GetPlayers()

	-- FIX (2026-06-12): teto do saldo REAL da sociedade (server-side),
	-- não o `societyMoney` do cliente (permitia sacar ilimitado de qualquer sociedade).
	local societyInfo = getSocietyInfo(society, ibanNumber)
	if not societyInfo then return end

	if amount <= societyInfo.value then
		if Config.UseAddonAccount then
			MySQL.Async.execute('UPDATE addon_account_data SET money = money - @value WHERE account_name = @society', {
				['@value'] = amount,
				['@society'] = society,
			}, function(changed)
				TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
					account.removeMoney(amount)
				end)
			end)
		else
			MySQL.Async.execute('UPDATE okokbanking_societies SET value = value - @value WHERE society = @society AND society_name = @society_name', {
				['@value'] = amount,
				['@society'] = society,
				['@society_name'] = societyName,
			}, function(changed)
			end)
		end
		if xTarget ~= nil then
			xTarget.addAccountMoney('bank', amount)
			if not toMyself then
				for i=1, #xPlayers, 1 do
					local xForPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xForPlayer.identifier == targetIdentifier then
						TriggerClientEvent('okokBanking:updateTransactions', xPlayers[i], xTarget.getAccount('bank').money, xTarget.getMoney())
						TriggerClientEvent('okokNotify:Alert', xPlayers[i], _L('received_from').title, interp(_L('received_from').text, {s1 = amount, s2 = getName(source)}), _L('received_from').time, _L('received_from').type)
					end
				end
			end
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
			TriggerClientEvent('okokNotify:Alert', source, _L('transferred_to').title, interp(_L('transferred_to').text, {s1 = amount, s2 = getName(targetIdentifier) }), _L('transferred_to').time, _L('transferred_to').type)

		elseif xTarget == nil then
			-- FIX (2026-06-12): alvo offline — ler accounts do alvo server-side
			-- e somar (ignora o JSON `acc` do cliente).
			TriggerEvent('okokBanking:AddTransferTransactionFromSocietyToP', amount, society, societyName, targetIdentifier, targetName)
			TriggerClientEvent('okokBanking:updateTransactionsSociety', source, xPlayer.getMoney())
			TriggerClientEvent('okokNotify:Alert', source, _L('transferred_to').title, interp(_L('transferred_to').text, {s1 = amount, s2 = targetName }), _L('transferred_to').time, _L('transferred_to').type)

			if not Config.ESX11 then
				local trow = MySQL.Sync.fetchAll('SELECT accounts FROM users WHERE identifier = @target', { ['@target'] = targetIdentifier })
				if trow[1] and trow[1].accounts then
					local tAcc = json.decode(trow[1].accounts) or {}
					tAcc.bank = (tAcc.bank or 0) + amount
					MySQL.Async.execute('UPDATE users SET accounts = @playerAccount WHERE identifier = @target', {
						['@playerAccount'] = json.encode(tAcc),
						['@target'] = targetIdentifier
					}, function(changed)

					end)
				end
			else
				MySQL.Async.execute('UPDATE users SET bank = bank + @bank WHERE identifier = @target', {
					['@bank'] = amount,
					['@target'] = targetIdentifier
				}, function(changed)

				end)
			end
		end
	else
		TriggerClientEvent('okokNotify:Alert', source, _L('society_no_money').title, _L('society_no_money').text, _L('society_no_money').time, _L('society_no_money').type)
	end
end)

ESX.RegisterServerCallback("okokBanking:GetOverviewTransactions", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerIdentifier = xPlayer.identifier
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	MySQL.Async.fetchAll('SELECT * FROM okokbanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = playerIdentifier
	}, function(result)
		MySQL.Async.fetchAll('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokbanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY AND receiver_identifier = @identifier OR sender_identifier = @identifier', {
			['@identifier'] = playerIdentifier
		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)

ESX.RegisterServerCallback("okokBanking:GetSocietyTransactions", function(source, cb, society)
	local playerIdentifier = society
	local allDays = {}
	local income = 0
	local outcome = 0
	local totalIncome = 0
	local day1_total, day2_total, day3_total, day4_total, day5_total, day6_total, day7_total = 0, 0, 0, 0, 0, 0, 0

	MySQL.Async.fetchAll('SELECT * FROM okokbanking_transactions WHERE receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
		['@identifier'] = society
	}, function(result)
		MySQL.Async.fetchAll('SELECT *, DATE(date) = CURDATE() AS "day1", DATE(date) = CURDATE() - INTERVAL 1 DAY AS "day2", DATE(date) = CURDATE() - INTERVAL 2 DAY AS "day3", DATE(date) = CURDATE() - INTERVAL 3 DAY AS "day4", DATE(date) = CURDATE() - INTERVAL 4 DAY AS "day5", DATE(date) = CURDATE() - INTERVAL 5 DAY AS "day6", DATE(date) = CURDATE() - INTERVAL 6 DAY AS "day7" FROM `okokbanking_transactions` WHERE DATE(date) >= CURDATE() - INTERVAL 7 DAY AND receiver_identifier = @identifier OR sender_identifier = @identifier ORDER BY id DESC', {
			['@identifier'] = society
		}, function(result2)
			for k, v in pairs(result2) do
				local type = v.type
				local receiver_identifier = v.receiver_identifier
				local sender_identifier = v.sender_identifier
				local value = tonumber(v.value)

				if v.day1 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day1_total = day1_total + value
							income = income + value
						elseif type == "withdraw" then
							day1_total = day1_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day1_total = day1_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day1_total = day1_total - value
							outcome = outcome - value
						end
					end
					
				elseif v.day2 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day2_total = day2_total + value
							income = income + value
						elseif type == "withdraw" then
							day2_total = day2_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day2_total = day2_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day2_total = day2_total - value
							outcome = outcome - value
						end
					end

				elseif v.day3 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day3_total = day3_total + value
							income = income + value
						elseif type == "withdraw" then
							day3_total = day3_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day3_total = day3_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day3_total = day3_total - value
							outcome = outcome - value
						end
					end

				elseif v.day4 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day4_total = day4_total + value
							income = income + value
						elseif type == "withdraw" then
							day4_total = day4_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day4_total = day4_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day4_total = day4_total - value
							outcome = outcome - value
						end
					end

				elseif v.day5 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day5_total = day5_total + value
							income = income + value
						elseif type == "withdraw" then
							day5_total = day5_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day5_total = day5_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day5_total = day5_total - value
							outcome = outcome - value
						end
					end

				elseif v.day6 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day6_total = day6_total + value
							income = income + value
						elseif type == "withdraw" then
							day6_total = day6_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day6_total = day6_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day6_total = day6_total - value
							outcome = outcome - value
						end
					end

				elseif v.day7 == 1 then
					if value ~= nil then
						if type == "deposit" then
							day7_total = day7_total + value
							income = income + value
						elseif type == "withdraw" then
							day7_total = day7_total - value
							outcome = outcome - value
						elseif type == "transfer" and receiver_identifier == playerIdentifier then
							day7_total = day7_total + value
							income = income + value
						elseif type == "transfer" and sender_identifier == playerIdentifier then
							day7_total = day7_total - value
							outcome = outcome - value
						end
					end

				end
			end

			totalIncome = day1_total + day2_total + day3_total + day4_total + day5_total + day6_total + day7_total

			table.remove(allDays)
			table.insert(allDays, day1_total)
			table.insert(allDays, day2_total)
			table.insert(allDays, day3_total)
			table.insert(allDays, day4_total)
			table.insert(allDays, day5_total)
			table.insert(allDays, day6_total)
			table.insert(allDays, day7_total)
			table.insert(allDays, income)
			table.insert(allDays, outcome)
			table.insert(allDays, totalIncome)

			cb(result, playerIdentifier, allDays)
		end)
	end)
end)


RegisterServerEvent("okokBanking:AddDepositTransaction")
AddEventHandler("okokBanking:AddDepositTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = 'bank',
		['@receiver_name'] = 'Bank Account',
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(getName(_source)),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransaction")
AddEventHandler("okokBanking:AddWithdrawTransaction", function(amount, source_)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.identifier),
		['@receiver_name'] = tostring(getName(_source)),
		['@sender_identifier'] = 'bank',
		['@sender_name'] = 'Bank Account',
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransaction")
AddEventHandler("okokBanking:AddTransferTransaction", function(amount, xTarget, source_, targetName, targetIdentifier)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	if targetName == nil then
		MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(xTarget.identifier),
			['@receiver_name'] = tostring(getName(targetIdentifier)),
			['@sender_identifier'] = tostring(xPlayer.identifier),
			['@sender_name'] = tostring(getName(_source)),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	elseif targetName ~= nil and targetIdentifier ~= nil then
		MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
			['@receiver_identifier'] = tostring(targetIdentifier),
			['@receiver_name'] = tostring(targetName),
			['@sender_identifier'] = tostring(xPlayer.identifier),
			['@sender_name'] = tostring(getName(_source)),
			['@value'] = tonumber(amount),
			['@type'] = 'transfer'
		}, function (result)
		end)
	end
end)

RegisterServerEvent("okokBanking:AddTransferTransactionToSociety")
AddEventHandler("okokBanking:AddTransferTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = society,
		['@receiver_name'] = societyName,
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(getName(_source)),
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSocietyToP")
AddEventHandler("okokBanking:AddTransferTransactionFromSocietyToP", function(amount, society, societyName, identifier, name)

	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = identifier,
		['@receiver_name'] = name,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddTransferTransactionFromSociety")
AddEventHandler("okokBanking:AddTransferTransactionFromSociety", function(amount, society, societyName, societyTarget, societyNameTarget)
	
	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = societyTarget,
		['@receiver_name'] = societyNameTarget,
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddDepositTransactionToSociety")
AddEventHandler("okokBanking:AddDepositTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = society,
		['@receiver_name'] = societyName,
		['@sender_identifier'] = tostring(xPlayer.identifier),
		['@sender_name'] = tostring(getName(_source)),
		['@value'] = tonumber(amount),
		['@type'] = 'deposit'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:AddWithdrawTransactionToSociety")
AddEventHandler("okokBanking:AddWithdrawTransactionToSociety", function(amount, source_, society, societyName)
	local _source = nil
	if source_ ~= nil then
		_source = source_
	else
		_source = source
	end

	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = tostring(xPlayer.identifier),
		['@receiver_name'] = tostring(getName(_source)),
		['@sender_identifier'] = society,
		['@sender_name'] = societyName,
		['@value'] = tonumber(amount),
		['@type'] = 'withdraw'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:UpdateIbanDB")
AddEventHandler("okokBanking:UpdateIbanDB", function(iban, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end
	-- IBAN único (ver SetIBAN)
	if type(iban) ~= "string" or #iban == 0 or #iban > 32 then return end
	local existing = MySQL.Sync.fetchAll('SELECT identifier FROM users WHERE iban = @iban', { ['@iban'] = iban })
	if existing[1] and existing[1].identifier ~= xPlayer.identifier then return end

	if amount <= xPlayer.getAccount('bank').money then
		MySQL.Async.execute('UPDATE users SET iban = @iban WHERE identifier = @identifier', {
			['@iban'] = iban,
			['@identifier'] = xPlayer.identifier,
		}, function(changed)
		end)

		xPlayer.removeAccountMoney('bank', amount)
		TriggerClientEvent('okokBanking:updateMoney', _source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, _source, "bank", "Bank (IBAN)")
		TriggerClientEvent('okokBanking:updateIban', _source, iban)
		TriggerClientEvent('okokBanking:updateIbanPinChange', _source)
		TriggerClientEvent('okokNotify:Alert', _source, _L('iban_changed').title, interp(_L('iban_changed').text, {s1 = iban}), _L('iban_changed').time, _L('iban_changed').type)
	else
		TriggerClientEvent('okokNotify:Alert', _source, _L('iban_no_money').title, interp(_L('iban_no_money').text, {s1 = amount}), _L('iban_no_money').time, _L('iban_no_money').type)
	end
end)

RegisterServerEvent("okokBanking:UpdatePINDB")
AddEventHandler("okokBanking:UpdatePINDB", function(pin, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer then return end
	amount = safeAmount(amount); if not amount then return end

	if amount <= xPlayer.getAccount('bank').money then
		MySQL.Async.execute('UPDATE users SET pincode = @pin WHERE identifier = @identifier', {
			['@pin'] = pin,
			['@identifier'] = xPlayer.identifier,
		}, function(changed)
		end)

		xPlayer.removeAccountMoney('bank', amount)
		TriggerClientEvent('okokBanking:updateMoney', _source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerEvent('okokBanking:AddTransferTransactionToSociety', amount, _source, "bank", "Bank (Change PIN)")
		TriggerClientEvent('okokBanking:updateIbanPinChange', _source)
		TriggerClientEvent('okokNotify:Alert', _source, _L('pin_changed').title, interp(_L('pin_changed').text, {s1 = pin}), _L('pin_changed').time, _L('pin_changed').type)
	else
		TriggerClientEvent('okokNotify:Alert', _source, _L('pin_no_money').title, interp(_L('pin_no_money').text, {s1 = amount}), _L('pin_no_money').time, _L('pin_no_money').type)
	end
end)

Citizen.CreateThread(function()
	if Config.UseAddonAccount then
		while json.encode(ESX.Jobs) == "[]" do
			ESX = exports.cframework:getSharedObject()
			Citizen.Wait(100)
		end
		for k,v in pairs(ESX.Jobs) do

			MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
				['@account_name'] = "society_"..v.name,
			}, function(result)
				if result[1] ~= nil and result[1].owner == nil then
					MySQL.Async.execute('UPDATE addon_account_data SET owner = @iban WHERE account_name = @account_name', {
						['@account_name'] = "society_"..v.name,
						['@iban'] = Config.IBANPrefix..string.gsub(v.label:upper(), " ", ""),
					}, function(changed)
					end)
				end
			end)
		end
	end
end)

RegisterServerEvent("okokBanking:AddNewTransaction")
AddEventHandler("okokBanking:AddNewTransaction", function(receiver_name, receiver_identifier, sender_name, sender_identifier, amount, reason)
	MySQL.Async.insert('INSERT INTO okokbanking_transactions (receiver_identifier, receiver_name, sender_identifier, sender_name, date, value, type) VALUES (@receiver_identifier, @receiver_name, @sender_identifier, @sender_name, CURRENT_TIMESTAMP(), @value, @type)', {
		['@receiver_identifier'] = receiver_identifier,
		['@receiver_name'] = receiver_name.." ("..reason..")",
		['@sender_identifier'] = sender_identifier,
		['@sender_name'] = sender_name.." ("..reason..")",
		['@value'] = tonumber(amount),
		['@type'] = 'transfer'
	}, function (result)
	end)
end)

RegisterServerEvent("okokBanking:GiveCC")
AddEventHandler("okokBanking:GiveCC", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getAccount('bank').money

	if Config.CreditCardPrice <= playerMoney then
		if Config.ESX11 then
			xPlayer.removeMoney(Config.CreditCardPrice)
		else
			xPlayer.removeAccountMoney('bank', Config.CreditCardPrice)
		end
		
		xPlayer.addInventoryItem(Config.CreditCardItem, 1)
		TriggerEvent('okokBanking:AddNewTransaction', 'Bank', 'bank', getName(source), xPlayer.identifier, Config.CreditCardPrice, 'Buy CC')
		TriggerClientEvent('okokBanking:updateTransactions', xPlayer.source, xPlayer.getAccount('bank').money, xPlayer.getMoney())
		TriggerClientEvent('okokNotify:Alert', xPlayer.source, _L('bought_cc').title, interp(_L('bought_cc').text, {s1 = Config.CreditCardPrice}), _L('bought_cc').time, _L('bought_cc').type)
	else
		TriggerClientEvent('okokNotify:Alert', source, _L('no_money_bank').title, _L('no_money_bank').text, _L('no_money_bank').time, _L('no_money_bank').type)
	end
end)

function getName(source)
	local name = nil
	local identifier = nil
	
	if Config.UseSteamNames then
		name = GetPlayerName(source)
	else
		if type(source) ~= "number" then
			identifier = source
		else
			local xPlayer = ESX.GetPlayerFromId(source)
			identifier = xPlayer.identifier
		end
		MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(db_name)
			if db_name[1] ~= nil then
				name = db_name[1].firstname.." "..db_name[1].lastname
			else
				name = ""
			end
		end)
		while name == nil do
			Citizen.Wait(2)
		end
	end
	return name
end

-------------------------- WEBHOOK

--[[function TransferMoneyWebhook(data)
	local information = {
		{
			["color"] = Config.TransferWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Banco Logs',
			},
			["title"] = 'Transferir dinheiro',
			["description"] = '**Sender:** '..data.sender_name..'\n**Receiver:** '..data.receiver_name..'\n**Amount:** '..data.value..'€',

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end

function WithdrawMoneyWebhook(data)
	local information = {
		{
			["color"] = Config.WithdrawWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Banco Logs',
			},
			["title"] = 'Retirar dinheiro',
			["description"] = '**Receiver:** '..data.receiver_name..'\n**Amount:** '..data.value..'€',

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook1, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end

function DepositMoneyWebhook(data)
	local information = {
		{
			["color"] = Config.DepositWebhookColor,
			["author"] = {
				["icon_url"] = Config.IconURL,
				["name"] = Config.ServerName..' - Banco Logs',
			},
			["title"] = 'Depositar dinheiro',
			["description"] = '**Sender:** '..data.sender_name..'\n**Amount:** '..data.value..'€',

			["footer"] = {
				["text"] = os.date(Config.DateFormat),
			}
		}
	}
	PerformHttpRequest(Webhook2, function(err, text, headers) end, 'POST', json.encode({username = Config.BotName, embeds = information}), {['Content-Type'] = 'application/json'})
end--]]