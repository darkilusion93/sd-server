--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --
AddEventHandler('chatMessage', function(source, n, message)
	if(settings.defaultSettings.disableCommandHandler ~= 'false')then
		return
	end

	if(startswith(message, settings.defaultSettings.commandDelimeter))then
		local command_args = stringsplit(message, " ")

		command_args[1] = string.gsub(command_args[1], settings.defaultSettings.commandDelimeter, "")

		local commandName = command_args[1]
		local command = commands[commandName]

		if(command)then
			local Source = source
			CancelEvent()
			if(command.perm > 0)then
				if(IsPlayerAceAllowed(Source, "command." .. command_args[1]) or ESX.Players[source].getPermissions() >= command.perm or groups[ESX.Players[source].getGroup()]:canTarget(command.group))then
					table.remove(command_args, 1)
					if (not (command.arguments == #command_args - 1) and command.arguments > -1) then
						--TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, 0, ESX.Players[source])
					else
						command.cmd(source, command_args, ESX.Players[source])
						TriggerEvent("es:adminCommandRan", source, command_args, ESX.Players[source])
						log('User (' .. GetPlayerName(Source) .. ') ran admin command ' .. commandName .. ', with parameters: ' .. table.concat(command_args, ' '))
					end
				else
					command.callbackfailed(source, command_args, ESX.Players[source])

					if(settings.defaultSettings.permissionDenied ~= "false" and not WasEventCanceled())then
						TriggerClientEvent('chatMessage', source, "", {0,0,0}, settings.defaultSettings.permissionDenied)
					end

					log('User (' .. GetPlayerName(Source) .. ') tried to execute command without having permission: ' .. command_args[1])
					debugMsg("Non admin (" .. GetPlayerName(Source) .. ") attempted to run admin command: " .. commandName)
				end
			else
				table.remove(command_args, 1)
				if (not (command.arguments <= (#command_args - 1)) and command.arguments > -1) then
					--TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, 0, ESX.Players[source])
				else
					command.cmd(source, command_args, ESX.Players[source])
				end
			end
		else
			if WasEventCanceled() then
				CancelEvent()
			end
		end
	else
		if WasEventCanceled() then
			CancelEvent()
		end
	end
end)

local function addCommand(command, callback, suggestion, arguments)
	commands[command] = {}
	commands[command].perm = 0
	commands[command].group = "user"
	commands[command].cmd = callback
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	if(settings.defaultSettings.disableCommandHandler ~= 'false')then
		RegisterCommand(command, function(source, args)
			if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
				callback(source, args, ESX.Players[source])
			else
				TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, ESX.Players[source])
			end
		end, false)
	end

	debugMsg("Command added: " .. command)
end

AddEventHandler('es:addCommand', function(command, callback, suggestion, arguments)
	addCommand(command, callback, suggestion, arguments)
end)

local function addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
	commands[command] = {}
	commands[command].perm = perm
	commands[command].group = "superadmin"
	commands[command].cmd = callback
	commands[command].callbackfailed = callbackfailed
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	ExecuteCommand('add_ace group.superadmin command.' .. command .. ' allow')

	if(settings.defaultSettings.disableCommandHandler ~= 'false')then
		RegisterCommand(command, function(source, args)
			local Source = source

			-- Console check
			if(source ~= 0)then
				if IsPlayerAceAllowed(Source, "command." .. command) or ESX.Players[source].getPermissions() >= perm then
					if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
						callback(source, args, ESX.Players[source])
					else
						TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, ESX.Players[source])
					end
				else
					callbackfailed(source, args, ESX.Players[source])
				end
			else
				if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
					callback(source, args, ESX.Players[source])
				else
					TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, ESX.Players[source])
				end
			end
		end, true)
	end

	debugMsg("Admin command added: " .. command .. ", requires permission level: " .. perm)
end

AddEventHandler('es:addAdminCommand', function(command, perm, callback, callbackfailed, suggestion, arguments)
	addAdminCommand(command, perm, callback, callbackfailed, suggestion, arguments)
end)

local function addGroupCommand(command, group, callback, callbackfailed, suggestion, arguments)
	commands[command] = {}
	commands[command].perm = math.maxinteger
	commands[command].group = group
	commands[command].cmd = callback
	commands[command].callbackfailed = callbackfailed
	commands[command].arguments = arguments or -1

	if suggestion then
		if not suggestion.params or not type(suggestion.params) == "table" then suggestion.params = {} end
		if not suggestion.help or not type(suggestion.help) == "string" then suggestion.help = "" end

		commandSuggestions[command] = suggestion
	end

	ExecuteCommand('add_ace group.' .. group .. ' command.' .. command .. ' allow')

	if(settings.defaultSettings.disableCommandHandler ~= 'false')then
		RegisterCommand(command, function(source, args)
			local Source = source

			-- Console check
			if(source ~= 0)then
				if IsPlayerAceAllowed(Source, "command." .. command) or groups[ESX.Players[source].getGroup()]:canTarget(group) then
					if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
						callback(source, args, ESX.Players[source])
					else
						TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, ESX.Players[source])
					end
				else
					callbackfailed(source, args, ESX.Players[source])
				end
			else
				if((#args <= commands[command].arguments and #args == commands[command].arguments) or commands[command].arguments == -1)then
					callback(source, args, ESX.Players[source])
				else
					TriggerEvent("es:incorrectAmountOfArguments", source, commands[command].arguments, #args, ESX.Players[source])
				end
			end
		end, true)
	end

	debugMsg("Group command added: " .. command .. ", requires group: " .. group)
end

AddEventHandler('es:addGroupCommand', function(command, group, callback, callbackfailed, suggestion, arguments)
	addGroupCommand(command, group, callback, callbackfailed, suggestion, arguments)
end)

