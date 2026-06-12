


TriggerEvent('es:addGroupCommand', 'clearorginventory', 'superadmin', function(source, args, user)
	if not ESX.inAdmin(source) then TriggerClientEvent('esx:showNotification', source, 'Comando desativado.', 'error') return end
    local jobName <const> = args[1]

    if jobName == nil then TriggerClientEvent('chat:addMessage', source, { args = { "^1SYSTEM", "Job doesn't exist." } }) return end

    local doesJobExist = ESX.DoesJobExist(jobName, 0)

    if not doesJobExist then TriggerClientEvent('chat:addMessage', source, { args = { "^1SYSTEM", "Job doesn't exist." } }) return end

    local mainInventory = GetSharedInventory(string.format("society_%s", jobName))
    local bossInventory = GetSharedInventory(string.format("society_%s_chefe", jobName))

    mainInventory.clear()
    bossInventory.clear()

    ESX.clearJobMetadata(jobName)

    TriggerClientEvent('chat:addMessage', source, { args = { "^1SYSTEM", string.format("Inventário e XP limpo. (%s)", jobName) } })
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = _U('giveitem'), params = {{name = "id", help = _U('id_param')}, {name = "item", help = _U('item')}, {name = "amount", help = _U('amount')}}})
