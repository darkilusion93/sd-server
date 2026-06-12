local function OpenPromoteMenu(society, employee)
	local job = RPC.execute("cframework:getJobInfo")
	local elements = {}

	for i=1, #job.grades, 1 do
		local gradeLabel = (job.grades[i].label == "" and job.label or job.grades[i].label)

		table.insert(elements, {
			label = gradeLabel,
			value = job.grades[i].grade,
			selected = (employee.job.grade == job.grades[i].grade)
		})
	end

	TriggerEvent('chud:menu', elements, T("SOCIETY_PROMOTE"), function(value)
		TriggerServerEvent("cframework:bossSetJob", employee.identifier, society, value, "promote")
		OpenEmployeeList(society)
	end)
end

local function OpenRecruitMenu(society)
	ESX.TriggerServerCallback('cframework:societyGetPlayersInArea', function(playersInArea)
		local inviteElements      = {}

		for i=1, #playersInArea, 1 do
			if playersInArea[i] ~= PlayerId() then
				table.insert(inviteElements, {label = playersInArea[i].name, value = playersInArea[i].id})
			end
		end

		TriggerEvent('chud:menu', inviteElements, T("SOCIETY_RECRUIT"), function(value)
			TriggerServerEvent("cframework:bossSetJob", value, society, 0, 'hire')
		end)
	end, GetEntityCoords(PlayerPedId()), 10.0)
end

local function OpenManageGradesMenu(society)

	ESX.TriggerServerCallback('esx_society:getJob', function(job)

		local elements = {}

		for i=1, #job.grades, 1 do
			local gradeLabel = (job.grades[i].label == '' and job.label or job.grades[i].label)

			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(gradeLabel, (T("GENERIC_MONEY")):format(ESX.Math.GroupDigits(job.grades[i].salary))),
				value = job.grades[i].grade
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_grades_' .. society, {
			title    = T("SOCIETY_SALARY_MANAGEMENT"),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society, {
				title = T("SOCIETY_SALARY_AMOUNT")
			}, function(data2, menu2)

				local amount = tonumber(data2.value)

				if amount == nil then
					ESX.ShowNotification(T("GENERIC_INVALID_AMOUNT"), "error")
				elseif amount > 500 then --Config aqui
					ESX.ShowNotification(T("GENERIC_INVALID_AMOUNT_MAX"), "error")
				else
					menu2.close()

					ESX.TriggerServerCallback('esx_society:setJobSalary', function()
						OpenManageGradesMenu(society)
					end, society, data.current.value, amount)
				end

			end, function(data2, menu2)
				menu2.close()
			end)

		end, function(data, menu)
			menu.close()
		end)

	end, society)

end

local function OpenManageEmployeesMenu(society)
	local elements = {
		{label = '📜 ' .. T("SOCIETY_EMPLOYEE_LIST"), value = 'employee_list'},
		{label = '📝 ' .. T("SOCIETY_RECRUIT"), value = 'recruit'}
	}

	TriggerEvent('chud:menu', elements, T("SOCIETY_EMPLOYEE_MANAGEMENT"), function(value)
		if value == 'employee_list' then
			OpenEmployeeList(society)
		end

		if value == 'recruit' then
			OpenRecruitMenu(society)
		end
	end)
end

local function OpenBossMenu(society, close, extraOptions)
	local elements = {}
	local options = {
		withdraw  = true,
		deposit   = true,
		wash      = false,
		employees = true,
		grades    = false
	}

	if options.withdraw then
		table.insert(elements, {label = '💸 ' .. T("SOCIETY_WITHDRAW_MONEY"), value = 'withdraw_society_money'})
	end

	if options.deposit then
		table.insert(elements, {label = '💵 ' .. T("SOCIETY_DEPOSIT_MONEY"), value = 'deposit_money'})
	end

	if options.wash then
		table.insert(elements, {label = '💰 ' .. T("SOCIETY_WASH_MONEY"), value = 'wash_money'})
	end

	if options.employees then
		table.insert(elements, {label = '🙋‍♂️ ' .. T("SOCIETY_EMPLOYEE_MANAGEMENT"), value = 'manage_employees'})
	end

	if options.grades then
		table.insert(elements, {label = '📈 ' .. T("SOCIETY_SALARY_MANAGEMENT"), value = 'manage_grades'})
	end

	TriggerEvent('chud:menu', elements, T("SOCIETY_ADMINISTRATION"), function(value)
		if value == 'withdraw_society_money' then
			TriggerEvent('chud:textmenu', T("SOCIETY_AMOUNT"), T("SOCIETY_WITHDRAW_MONEY"), function(value2)
				if value2 ~= "" and tonumber(value2) ~= nil then
					TriggerServerEvent('esx_society:withdrawMoney', tonumber(value2))
				end

				OpenBossMenu(society, close, extraOptions)
			end)
		end

		if value == 'deposit_money' then
			TriggerEvent('chud:textmenu', T("SOCIETY_AMOUNT"), T("SOCIETY_DEPOSIT_MONEY"), function(value2)
				if value2 ~= "" and tonumber(value2) ~= nil then
					TriggerServerEvent('esx_society:depositMoney', society, tonumber(value2))
				end

				OpenBossMenu(society, close, extraOptions)
			end)
		end

		if value == 'wash_money' then
			TriggerEvent('chud:textmenu', T("SOCIETY_AMOUNT"), T("SOCIETY_WASH_MONEY"), function(value2)
				if value2 ~= "" and tonumber(value2) ~= nil then
					TriggerServerEvent('esx_society:washMoney', society, tonumber(value2))
				end

				OpenBossMenu(society, close, extraOptions)
			end)
		end

		if value == 'manage_employees' then
			OpenManageEmployeesMenu(society)
		end

		if value == 'manage_grades' then
			TriggerEvent('esx_inventoryhud:doClose')
			OpenManageGradesMenu(society)
		end
	end)
end

function OpenEmployeeList(society)
	local employees = RPC.execute("cframework:getEmployees")

	local elements = {
		head = {T("SOCIETY_EMPLOYEE"), T("SOCIETY_GRADE"), T("SOCIETY_ACTION")},
		rows = {}
	}

	for i=1, #employees, 1 do
		local gradeLabel = (employees[i].job.grade_label == '' and employees[i].job.label or employees[i].job.grade_label)

		table.insert(elements.rows, {
			data = employees[i],
			cols = {
				employees[i].name,
				gradeLabel,
				"{{".. T("SOCIETY_PROMOTE") .."|promote}} {{".. T("SOCIETY_FIRE") .."|fire}}"
			}
		})
	end

	TriggerEvent('chud:listmenu', elements, T("SOCIETY_EMPLOYEE_LIST"), function(action)
		local employee = action.data

		if action.value == 'promote' then
			OpenPromoteMenu(society, employee)
		elseif action.value == 'fire' then
			ESX.ShowNotification((T("SOCIETY_FIRED")):format(employee.name), "inform")

			TriggerServerEvent("cframework:bossSetJob", employee.identifier, "unemployed", 0, "fire")

			OpenEmployeeList(society)
		end
	end)
end

AddEventHandler('esx_society:openBossMenu', function(society, close, options)
	OpenBossMenu(society, close, options)
end)
