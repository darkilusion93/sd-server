

local policeStationLocation = {}

Citizen.CreateThread(function()
	for _,v in ipairs(Config.Stations["police"].Armories) do
		table.insert(policeStationLocation, vector3(v.x, v.y, v.z))
	end
end)

RegisterNetEvent("cframework:sellPolice", function(items)
    local source <const> = source
    local jobName <const> = ESX.getJob(source).name
    local inventory <const> = ESX.getInvContainer(source)
	local finalPrice = 0

    if not ESX.playerInsideLocation(source, policeStationLocation, 10.0) then
        return
    end

    if jobName ~= "police" then
        return
    end

    for _,item in ipairs(items) do
        if PoliceAllowedItems[item.name] == nil then
            goto jump_loop
        end

        local price <const> = PoliceAllowedItems[item.name].price

        if not inventory.canRemoveItem(item.name, item.count) then
            goto jump_loop
        end

        inventory.removeItem(item.name, item.count)
        GetSharedAccount("society_police").addMoney(price*item.count)
        finalPrice += price*item.count

        ::jump_loop::
    end

	TriggerClientEvent("esx:showNotification", source, (T("SOCIETY_ADDED_MONEY")):format(finalPrice), "success")
end)