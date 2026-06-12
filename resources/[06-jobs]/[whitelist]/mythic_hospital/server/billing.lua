--[[
    ADD YOUR FRAMEWORK BILLING HERE

    If the player is bill successfully, return true. If they're not, return false
]]
ESX             = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function BillPlayer(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= amount then
        TriggerEvent('esx_addonaccount:getSharedAccount', "society_ambulance", function(account)
            xPlayer.removeMoney(amount)
            account.addMoney(amount)
        end)
        return true
    else
        return false
    end
end