ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)


-- Modify if you want, btw the _admin_ needs to be able to target the group and it will work
local groupsRequired = {
	slay = "superadmin",
	noclip = "mod",
	crash = "superadmin",
	freeze = "mod",
	bring = "mod",
	["goto"] = "mod",
	slap = "superadmin",
	kick = "mod",
	ban = "mod"
}

local banned = ""
local bannedTable = {}

function loadBans()

end

function isBanned(id)
	return bannedTable[id]
end

function banUser(id)
	banned = banned .. id .. "\n"
	--SaveResourceFile("es_admin2", "data/bans.txt", banned, -1)
	--bannedTable[id] = true
end

AddEventHandler('playerConnecting', function(user, set)
	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if isBanned(v) then
			set(GetConvar("es_admin_banreason", "Você está banido deste servidor"))
			CancelEvent()
			break
		end
	end
end)

AddEventHandler('es:incorrectAmountOfArguments', function(source, wantedArguments, passedArguments, user, command)
	if(source == 0)then
		print("Argument count mismatch (passed " .. passedArguments .. ", wanted " .. wantedArguments .. ")")
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , 'Número errado de argumentos'}
		})
	end
end)


RegisterServerEvent('afkkick:kickplayer', function()
    local source <const> = source
    local playerRoutingBucket <const> = GetPlayerRoutingBucket(source)

    if playerRoutingBucket ~= 0 then --Prevent kicking players in instances
        return
    end

	DropPlayer(source, 'Foste kickado por inatividade!')
end)

RegisterServerEvent('es_admin:all')
AddEventHandler('es_admin:all', function(type)
	local Source = source
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available or user.getGroup() == "superadmin" then

			else
				TriggerClientEvent('chat:addMessage', source,{
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
					args = { '^*^1Servidor^0^*' , 'Não tens permissão para fazer isso'}
				})
			end
		end)
	end)
end)

RegisterServerEvent('es_admin:quick')
AddEventHandler('es_admin:quick', function(id, type)
	local Source = source
	if not ESX.inAdmin(Source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:getPlayerFromId', id, function(target)
			TriggerEvent('es:canGroupTarget', user.getGroup(), groupsRequired[type], function(available)
				TriggerEvent('es:canGroupTarget', user.getGroup(), target.getGroup(), function(canTarget)
					if canTarget and available then
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "noclip" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "freeze" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "crash" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "bring" then TriggerEvent("es:getPlayerFromId", source, function(target)
							if(target)then TriggerClientEvent('es_admin:teleportUser', id, target.getCoords().x, target.getCoords().y, target.getCoords().z)end end) end
						if type == "goto" then TriggerEvent("es:getPlayerFromId", id, function(target)
							if(target)then TriggerClientEvent('es_admin:teleportUser', source, target.getCoords().x, target.getCoords().y, target.getCoords().z)end end) end
						if type == "slap" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "slay" then TriggerClientEvent('es_admin:quick', id, type) end
						if type == "kick" then DropPlayer(id, 'Kicked by es_admin GUI') end

						if type == "ban" then
							for k,v in ipairs(GetPlayerIdentifiers(id))do
								banUser(v)
							end
							DropPlayer(id, GetConvar("es_admin_banreason", "Você foi banido deste servidor"))
						end
					else
						if not available then
							TriggerClientEvent('chat:addMessage', source,{
								template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
								args = { '^*^1Servidor^0^*' , 'Não tens permissão para fazer isso'}
							})
						else
							TriggerClientEvent('chat:addMessage', source,{
								template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
								args = { '^*^1Servidor^0^*' , 'Não tens permissão para fazer isso'}
							})
						end
					end
				end)
			end)
		end)
	end)
end)

RegisterServerEvent('es_admin:set')
AddEventHandler('es_admin:set', function(t, USER, GROUP)
	local Source = source
	if not ESX.inAdmin(Source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
			if t == "group" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', source,{
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
						args = { '^*^1Servidor^0^*' , 'Jogador não encontrado'}
					})
					--TriggerClientEvent('chatMessage', source, 'Servidor', {255, 0, 0}, "Jogador não encontrado")
				else
					TriggerEvent("es:getAllGroups", function(groups)
						if(groups[GROUP])then
							TriggerEvent("es:setPlayerData", USER, "group", GROUP, function(response, success)
								TriggerClientEvent('es_admin:setGroup', USER, GROUP)
								TriggerClientEvent('chat:addMessage', -1, {
									template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
									args = {"^*^1Servidor^0^*", "Group of ^2^*" .. GetPlayerName(tonumber(USER)) .. "^r^0 has been set to ^2^*" .. GROUP}
								})
							end)
						else
							TriggerClientEvent('chat:addMessage', source,{
								template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
								args = { '^*^1Servidor^0^*' , 'Grupo não encontrado'}
							})
						end
					end)
				end
			elseif t == "level" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', source,{
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
						args = { '^*^1Servidor^0^*' , 'Jogador não encontrado'}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						TriggerEvent("es:setPlayerData", USER, "permission_level", GROUP, function(response, success)
							if(true)then
								TriggerClientEvent('chat:addMessage', -1,{
									template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
									args = { "^*^1Servidor^0^*" , "Nivel de permissões de ^2" .. GetPlayerName(tonumber(USER)) .. "^0 foi definido para ^2 " .. tostring(GROUP)}
								})
								--TriggerClientEvent('chatMessage', -1, "CONSOLE", {0, 0, 0}, "Permission level of ^2" .. GetPlayerName(tonumber(USER)) .. "^0 has been set to ^2 " .. tostring(GROUP))
							end
						end)
						TriggerClientEvent('chat:addMessage', source,{
							template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
							args = { '^*^1Servidor^0^*' , "Permission level of ^2" .. GetPlayerName(tonumber(USER)) .. "^0 has been set to ^2 " .. tostring(GROUP)}
						})
					else
						TriggerClientEvent('chat:addMessage', source,{
							template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
							args = { '^*^1Servidor^0^*' , 'Inválido inserido'}
						})
					end
				end
			elseif t == "money" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', source,{
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
						args = { '^*^1Servidor^0^*' , 'Jogador não encontrado'}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						local target = ESX.GetPlayerFromId(USER)
						--TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setMoney(GROUP)
							ESX.LogAdminItems(Source, "SET MONEY", USER, "money", "money", GROUP)
						--end)
					else
						TriggerClientEvent('chat:addMessage', source,{
							template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
							args = { '^*^1Servidor^0^*' , 'Inválido inserido'}
						})
					end
				end
			elseif t == "bank" then
				if(GetPlayerName(USER) == nil)then
					TriggerClientEvent('chat:addMessage', source,{
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
						args = { '^*^1Servidor^0^*' , 'Jogador não encontrado'}
					})
				else
					GROUP = tonumber(GROUP)
					if(GROUP ~= nil and GROUP > -1)then
						local target = ESX.GetPlayerFromId(USER)
						--TriggerEvent('es:getPlayerFromId', USER, function(target)
							target.setBankBalance(GROUP)
							ESX.LogAdminItems(Source, "SET MONEY", USER, "bank", "bank", GROUP)
						--end)
					else
						TriggerClientEvent('chat:addMessage', source,{
							template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
							args = { '^*^1Servidor^0^*' , 'Inválido inserido'}
						})
					end
				end
			end
			else
				TriggerClientEvent('chat:addMessage', source,{
					template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
					args = { '^*^1Servidor^0^*' , 'Não tens permissões para isso'}
				})
			end
		end)
	end)
end)

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	local source = source

	if commandName == 'setadmin' then
		if #args ~= 2 then
			RconPrint("Usage: setadmin [user-id] [permission-level]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
			TriggerClientEvent('chat:addMessage', -1,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Permission level of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2 " .. args[2]}
			})
		end)

		CancelEvent()
	elseif commandName == 'setgroupdis' then
		if #args ~= 2 then
			RconPrint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)

					TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
					TriggerClientEvent('chat:addMessage', -1,{
						template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
						args = { '^*^1Servidor^0^*' , "Group of ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 has been set to ^2^*" .. args[2]}
					})
				end)
			else
				RconPrint("This group does not exist.\n")
			end
		end)

		CancelEvent()
	end
end)

-- Default commands
TriggerEvent('es:addGroupCommand', 'setmoney', 'admin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	if #args ~= 2 then
		TriggerClientEvent('esx:showNotification', source, 'Uso inválido.', 'error')
		return
	end

	local user = ESX.GetPlayerFromId(tonumber(args[1]))
	if user then
		user.setMoney(tonumber(args[2]))
		ESX.LogAdminItems(source, "SET MONEY", tonumber(args[1]), "money", "money", tonumber(args[2]))

		TriggerClientEvent('chat:addMessage', tonumber(args[1]),{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Dinheiro alterado para: ^2^*€" .. tonumber(args[2])}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = "setmoney"})

TriggerEvent('es:addCommand', 'mod', function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { "^*^1Servidor^*^0" , user.getGroup() .. ", " .. tostring(user.get('permission_level'))}
	})
end, {help = "Shows what admin level you are and what group you're in"})

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Ligar ou Desligar noclip"})


-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			local reason = args
			table.remove(reason, 1)
			if(#reason == 0)then
				reason = "Kicked: Foste kickado do servidor"
			else
				reason = "Kicked: " .. table.concat(reason, " ")
			end

			ESX.LogAdminActions(source, "KICK", player)
			--TriggerClientEvent('chat:addMessage', -1,{
			--	template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			--	args = { "Servidor" , "Jogador ^2" .. GetPlayerName(player) .. "^0 Foi kickado(^2" .. reason .. "^0)"}
			--})
			--TriggerClientEvent('chatMessage', -1, "Servidor", {255, 0, 0}, "Jogador ^2" .. GetPlayerName(player) .. "^0 Foi kickado(^2" .. reason .. "^0)")
			DropPlayer(player, reason)
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Kick a user with the specified reason or no reason", params = {{name = "userid", help = "The ID of the player"}, {name = "reason", help = "The reason as to why you kick this player"}}})

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	TriggerClientEvent('chatMessage', -1, "ANÚNCIO: ", {255, 0, 0}, "" .. table.concat(args, " "))
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Announce a message to the entire server", params = {{name = "announcement", help = "The message to announce"}}})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			if(frozen[player])then
				frozen[player] = false
			else
				frozen[player] = true
			end

			TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

			local state = "descongelado"
			if(frozen[player])then
				state = "congelado"
			end
			TriggerClientEvent('chat:addMessage', player,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Foste " .. state .. " por ^2" .. GetPlayerName(source)}
			})
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "O jogador ^2" .. GetPlayerName(player) .. "^0 foi " .. state}
			})
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Freeze or unfreeze a user", params = {{name = "userid", help = "The ID of the player"}}})

-- Bring
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			
			local coords = GetEntityCoords(GetPlayerPed(source))
			local localPed = GetPlayerPed(player)
		
			SetEntityCoords(localPed, coords.x, coords.y, coords.z, true, false, false, true)

			--TriggerClientEvent('es_admin:teleportUser', target.get('source'), user.getCoords().x, user.getCoords().y, user.getCoords().z)
			TriggerClientEvent('chat:addMessage', player,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Foi puxado por ^2" .. GetPlayerName(source)}
			})
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador ^2" .. GetPlayerName(player) .. "^0 foi puxado"}
			})
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Teleport a user to you", params = {{name = "userid", help = "The ID of the player"}}})

-- Slap
TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			TriggerClientEvent('es_admin:slap', player)

			TriggerClientEvent('chat:addMessage', player,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Levaste uma chapada de ^2" .. GetPlayerName(source)}
			})
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Deste uma chapada a ^2" .. GetPlayerName(player)}
			})
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Slap a user", params = {{name = "userid", help = "The ID of the player"}}})

-- Goto
TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			
			local coords = GetEntityCoords(GetPlayerPed(player))
			local localPed = GetPlayerPed(source)
		
			SetEntityCoords(localPed, coords.x, coords.y, coords.z, true, false, false, true)

			TriggerClientEvent('chat:addMessage', player,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "^2" .. GetPlayerName(source) .. "^0 deu tp para ti"}
			})
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Deste tp para ^2" .. GetPlayerName(player)}
			})
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Teleport to a user", params = {{name = "userid", help = "The ID of the player"}}})

--[[Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
	TriggerClientEvent('es_admin:kill', source)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Suicidaste-te"}
	})
end, {help = "Suicide"})]]

-- Slay a player
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
	if args[1] then
		if(tonumber(args[1]) and GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])

			-- User permission check
			TriggerClientEvent('es_admin:kill', player)
			TriggerClientEvent('chat:addMessage', player,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Foste morto por ^2" .. GetPlayerName(source)}
			})
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador ^2" .. GetPlayerName(player) .. "^0 foi morto."}
			})
		else
			TriggerClientEvent('chat:addMessage', source,{
				template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
				args = { '^*^1Servidor^0^*' , "Jogador não existe"}
			})
		end
	else
		TriggerClientEvent('chat:addMessage', source,{
			template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
			args = { '^*^1Servidor^0^*' , "Jogador não existe"}
		})
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Slay a user", params = {{name = "userid", help = "The ID of the player"}}})

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

loadBans()

RegisterServerEvent('es_admin:getPlayers')
AddEventHandler('es_admin:getPlayers', function()
	-- FIX C22 (2026-06-12): faltava o gate de admin que todos os outros
	-- handlers têm. Sem isto, qualquer cliente abria o menu admin + roster.
	if not ESX.inAdmin(source) then return end
	local players = {}
	for _, playerId in ipairs(GetPlayers()) do
		local name = GetPlayerName(playerId)
		table.insert(players, {id = playerId, name = name})
	  end
	TriggerClientEvent('es_admin:openAdmin', source, players)
end)

TriggerEvent('es:addGroupCommand', 'reparar', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	TriggerClientEvent('es_admin:reparar', source)
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source,{
		template = '<div style="padding: 0.4vw; margin: 0.5vw; background-color: rgba(117, 117, 117, 0.6); border-radius: 20px;">{0}: {1}</div>',
		args = { '^*^1Servidor^0^*' , "Permissões insuficientes"}
	})
end, {help = "Reparar um veiculo", params = {{name = "userid", help = "The ID of the player"}}})

TriggerEvent('es:addGroupCommand', 'mapper', "mod", function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end

	TriggerClientEvent('es_mapper:toggle', source)
	ESX.LogAdminActions(source, "MAPPER", source)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end, {help = 'Edit Map'})
