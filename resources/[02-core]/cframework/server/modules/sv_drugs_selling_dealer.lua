

local drugData = LoadDrugs()

local dealerSelling <const> = drugData.dealerSelling

local copCount = 0

AddEventHandler('esx:onlineCops', function(count)
    copCount = count
end)

local cooldownList = {}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    local identifier = xPlayer.getIdentifier()

    if cooldownList[identifier] == nil then
        cooldownList[identifier] = {}
    end

    for k, v in pairs(cooldownList[identifier]) do
        if os.time() - v.time < dealerSelling[k].cooldown then
            TriggerClientEvent("cframework:enableDealer", playerId, k, v.selectedDealer, dealerSelling[k].cooldown - (os.time() - v.time))
        end
    end
end)


local function isJobValid(jobName, jobList)
    for i=1, #jobList do
        if jobName == jobList[i] then
            return true
        end
    end

    return false
end

RegisterServerEvent('cphone:sendMessage', function(message, number)
    local source = source
	local now = os.time()
	local identifier = ESX.getIdentifier(source)
    local jobName = ESX.getJob(source).name

	if number ~= '666-6969' then
		return
	end

    for k, v in pairs(dealerSelling) do
        if message == v.msg then
            if cooldownList[identifier] == nil then
                cooldownList[identifier] = {}
            end

            if cooldownList[identifier][k] and (now - cooldownList[identifier][k].time < v.cooldown) then
                return
            end

            if not isJobValid(jobName, v.jobs) then
                return
            end

            if copCount < v.minCops then
                Citizen.Wait(2000)
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_NOT_AVAILABLE"))
                return
            end

            local selectedLocation <const> = math.random(#v.locations)

            cooldownList[identifier][k] = {time = now, selectedDealer = selectedLocation}

            Citizen.Wait(2000)

            TriggerClientEvent("cframework:enableDealer", source, k, selectedLocation, v.cooldown)
            TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_MESSAGE"))
            return
        end

        if v.influenceMsg and message == v.influenceMsg then
            if not isJobValid(jobName, v.jobs) then
                return
            end

            Citizen.Wait(2000)

            if v.enableInfluence == nil or not v.enableInfluence then
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_SPOTS_NO_INFLUENCER"))
                return
            end

            if cooldownList[identifier] == nil then
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_DOESNT_KNOW_INFLUENCER"))
                return
            end

            if cooldownList[identifier][k] == nil then
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_DOESNT_KNOW_INFLUENCER"))
                return
            end

            if cooldownList[identifier][k] and (now - cooldownList[identifier][k].time >= v.cooldown) then
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_DOESNT_KNOW_INFLUENCER"))
                return
            end

            local influence <const> = ESX.getInfluence(k .. cooldownList[identifier][k].selectedDealer)

            if influence.level == nil or influence.level == 0 then
                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_SPOTS_WITHOUT_INFLUENCER"))
                return
            end

            if influence.identifier ~= jobName then
                local label <const> = ESX.GetJobLabel(influence.identifier):gsub("^[^%s]+%s", "")
                local percentage <const> = math.tointeger(influence.level/10)

                if influence.level < 1000 then
                    TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), (T("DRUGS_DEALER_INFLUENCER_MESSAGE")):format(label, percentage))
                else
                    TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), (T("DRUGS_DEALER_FULL_INFLUENCER_MESSAGE")):format(label, percentage))
                end
                return
            end

            if influence.level < 1000 then
                local percentage <const> = math.tointeger(influence.level/10)

                TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), (T("DRUGS_DEALER_IM_INFLUENCER")):format(percentage))
                return
            end

            TriggerEvent('cphone:addMessagePhoneArtificial', source, number, ESX.getPhoneNumber(source), T("DRUGS_DEALER_IM_FULL_INFLUENCER"))
            return
        end
    end
end)

RegisterNetEvent("cframework:sellDealerDrug", function(type)
    local source <const> = source
    local inventory <const> = ESX.getInvContainer(source)
    local identifier <const> = ESX.getIdentifier(source)
    local jobName <const> = ESX.getJob(source).name
    local dealerData <const> = dealerSelling[type]

    if dealerData == nil then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    if cooldownList[identifier] == nil or cooldownList[identifier][type] == nil then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    if os.time() - cooldownList[identifier][type].time >= dealerData.cooldown then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    if not isJobValid(jobName, dealerData.jobs) then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    local selectedDealer <const> = cooldownList[identifier][type].selectedDealer

    if not ESX.playerInsideLocation(source, { vector3(dealerData.locations[selectedDealer].x, dealerData.locations[selectedDealer].y, dealerData.locations[selectedDealer].z) }, 10.0) then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    if copCount < dealerData.minCops then
        TriggerClientEvent('esx:showNotification', source, T("DRUGS_NOT_ENOUGH_COPS"), 'error')
        TriggerClientEvent("cframework:sellDrugFail", source)
		return
	end

    local influencePerks, useInfluence = false, false

    if dealerData.enableInfluence ~= nil and dealerData.enableInfluence then
        local influence <const> = ESX.getInfluence(type .. selectedDealer)

        if influence.level ~= nil and influence.identifier == jobName and influence.level >= 1000 then
            influencePerks = true
        end

        useInfluence = true
    end

    local selectedDrug = nil

    for k, v in ipairs(dealerData.items) do
        if influencePerks and v.influenceCount then
            if inventory.canRemoveItem(v.name, v.influenceCount) and isJobValid(jobName, v.jobs) then
                selectedDrug = k
                break
            end
        else
            if inventory.canRemoveItem(v.name, v.count) and isJobValid(jobName, v.jobs) then
                selectedDrug = k
                break
            end
        end
    end

    if selectedDrug == nil then
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    local selectedDrugInfo = dealerData.items[selectedDrug]
    local drugPrice = selectedDrugInfo.price
    local drugCount = selectedDrugInfo.count

    if influencePerks and selectedDrugInfo.influencePrice then
        drugPrice = selectedDrugInfo.influencePrice
    end

    if influencePerks and selectedDrugInfo.influenceCount then
        drugCount = selectedDrugInfo.influenceCount
    end

    if not inventory.canAddItem(selectedDrugInfo.cash, drugPrice * drugCount) then
        TriggerClientEvent('esx:showNotification', source, (T("INVENTORY_CANT_CARRY_MORE")):format(ESX.GetItemLabel(selectedDrugInfo.cash)), 'error')
        TriggerClientEvent("cframework:sellDrugFail", source)
        return
    end

    inventory.removeItem(selectedDrugInfo.name, drugCount)
    inventory.addItem(selectedDrugInfo.cash, drugPrice * drugCount)

    if useInfluence then
        local hasInfluence = ESX.proccessInfluence(jobName, type .. selectedDealer, dealerData.influenceVariation)

        if hasInfluence and not influencePerks then
            for player, _ in pairs(ESX.getJobSourceList(jobName)) do
                if ESX.playerInsideLocation(player, { vector3(dealerData.locations[selectedDealer].x, dealerData.locations[selectedDealer].y, dealerData.locations[selectedDealer].z) }, 10.0) then
                    TriggerEvent('cphone:addMessagePhoneArtificial', player, '666-6969', ESX.getPhoneNumber(player), T("DRUGS_DEALER_IS_INFLUENCER"))
                end
            end
        end
    end
end)

local Triggers = {
	'esx_drugs:startHarvestCoke',
	'esx_drugs:startTransformCoke',
	'esx_drugs:startSellCoke',

	'esx_drugs:startHarvestMeth',
	'esx_drugs:startTransformMeth',
	'esx_drugs:startSellMeth',

	'esx_drugs:startHarvestWeed',
	'esx_drugs:startTransformWeed',
	'esx_drugs:startSellWeed',

	'esx_drugs:startHarvestOpium',
	'esx_drugs:startTransformOpium',
	'esx_drugs:startSellOpium',
}

for k,v in ipairs(Triggers) do
    RegisterServerEvent(v, function()
		local source = source
		TriggerEvent("el_bwh:ban", ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(source), 'Sem Destino Anti-Cheat : Só te damos a mais o que queremos, neste caso levas um ban. (Da próxima chama o dealer)', nil, false)
	end)
end