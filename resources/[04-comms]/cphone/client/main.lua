ESX                             = nil
phoneProp = 0
inCamera = false
HasPhone = false

local PhoneReady = false
local InAirPlaneMode = false

local phoneModel = `prop_npc_phone_02`

local PlayerJob = {}
local PlayerData = {}
local IsHandcuffed = false

local PhoneLoaded = false
local myPhoneNumber = ''

local HasTablet = false

local firstTime = false
local frontCam = false

local messages = {}

function IsPhoneReady()
    return PhoneReady
end

function IsPhoneInAirPlaneMode()
    return InAirPlaneMode
end

RegisterNUICallback('SetAirplaneMode', function(data)
    InAirPlaneMode = data.airplaneMode
end)

Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(0)
        TriggerEvent('cframework:getData', function(obj) ESX = obj end, 1)
	end

    PlayerData = ESX.GetPlayerData()

    if DEVELOPER_MODE then
        Citizen.Wait(1000)
        TriggerServerEvent('forceLoad')

        HasPhone = true
        SendNUIMessage({ action = "SetPhoneHas", HasPhone = true })
    end
end)

RegisterNetEvent('cframework:closePhone', function()
    if PhoneData.isOpen then
        SendNUIMessage({
            action = "ClosePhone",
        })
    end
end)

RegisterNetEvent('cframework:updateBoostCoins', function(boostCoins)
    PhoneData.BoostCoins = boostCoins
    SendNUIMessage({
        action = "UpdateBoostCoins",
        BoostCoins = boostCoins,
    })
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job

    SendNUIMessage({
        action = "UpdateApplications",
        JobData = job,
    })
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  --LoadPhone()
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'bank' then
        PlayerData.bank = account.money
        SendNUIMessage({ action = "UpdateBank", NewBalance = PlayerData.bank })
	end
end)

RegisterNetEvent('esx_addonaccount:setMoney', function(name, money)	
	SendNUIMessage({ action = "UpdateSocietyBank", NewBalance = money })
end)

RegisterNetEvent('esx:setJob', function(job, societyMoney)
	SendNUIMessage({ action = "UpdateSocietyBankDisplay", ShowSociety = job.grade_name == 'boss', AccountName = job.label })
	SendNUIMessage({ action = "UpdateSocietyBank", NewBalance = societyMoney })
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	local job = xPlayer.job

	while not PhoneLoaded do Citizen.Wait(0) end

    SendNUIMessage({ action = "UpdateSocietyBankDisplay", ShowSociety = job.grade_name == 'boss', AccountName = job.label })
    SendNUIMessage({ action = "UpdateSocietyBank", NewBalance = xPlayer.societyMoney })
end)

RegisterNetEvent('phoneRefreshBills', function()
    local bills = RPC.execute('getBills')

    PhoneData.Invoices = bills

    SendNUIMessage({ action = "UpdateInvoices", Invoices = PhoneData.Invoices })
end)

RegisterNetEvent("gbank:UpdateTransactions", function(transactions)
    PhoneData.TransactionData = transactions

    SendNUIMessage({
        action = "UpdateTransactions",
        TransactionData = PhoneData.TransactionData,
    })
end)

RegisterNetEvent('useSimCard', function()
    --LoadPhone()
end)

function SetPhoneState(hasPh)
    if hasPh then
        HasPhone = true
        SendNUIMessage({ action = "SetPhoneHas", HasPhone = true })
    else
        HasPhone = false
        SendNUIMessage({ action = "SetPhoneHas", HasPhone = false })
    end
end

exports("SetPhone", SetPhoneState)

function SetTabletState(hasTb)
    HasTablet = hasTb
end

exports("SetTablet", SetTabletState)

-- Code


PhoneData = {
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    Contacts = {},
    Hashtags = {},
    Chats = {},
    TransactionData = {},
    Invoices = {},
    CallData = {},
    RecentCalls = {},
    Garage = {},
    Mails = {},
    Adverts = {},
    Tinder = {},
    Darkweb = {},
    GarageVehicles = {},
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    SuggestedContacts = {},
    CryptoTransactions = {},
}


RegisterNUICallback('ClearRecentAlerts', function(data, cb)
    TriggerServerEvent('qb-phone:server:SetPhoneAlerts', "phone", 0)

end)

RegisterNUICallback('SetBackground', function(data)
    local background = data.background

    PhoneData.MetaData.background = background
    TriggerServerEvent('cphone:server:SaveMetaData', PhoneData.MetaData)
end)

local isLoggedIn = false

Citizen.CreateThread(function()
    exports.ft_libs:RemoveButton("cphone:open")
    exports.ft_libs:AddButton("cphone:open", {
        key = Config.OpenPhone,
        use = {
          callback = phoneOpen,
        },
    })

    exports.ft_libs:RemoveButton("gtablet:open")
    exports.ft_libs:AddButton("gtablet:open", {
        key = 168,
        use = {
          callback = tabletOpen,
        },
    })
end)

local tabletObject = nil

function tabletOpen()
    if HasTablet then
        local playerPed = PlayerPedId()

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openTablet",
        })

        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
            AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
            TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
    else
        ESX.ShowNotification("Não tens um tablet", "error")   
    end
end

RegisterNUICallback('TabletClose', function(data, cb)
    local playerPed = PlayerPedId()
    SetNuiFocus(false, false)
    DeleteEntity(tabletObject)
    ClearPedTasks(playerPed)
    tabletObject = nil
    cb('ok')
end)

function phoneOpen()
    if not PhoneData.isOpen then
        if not IsHandcuffed then
            OpenPhone()
        else
            ESX.ShowNotification("Estás algemado...", "error")
        end
    end
end

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

RegisterNetEvent('cphone:loaded', function(data)
    LoadPhone(data)
end)

function LoadPhone(pData)
   --Citizen.Wait(20000)
    isLoggedIn = true
    --local pData = RPC.execute('cphone:server:GetPhoneData')

    myPhoneNumber = pData.myPhoneNumber
        
    PlayerJob = PlayerData.job

    PlayerData.bank = pData.bank
    PlayerData.iban = pData.iban

    PhoneData.PlayerData = PlayerData
    --local PhoneMeta = PhoneData.PlayerData.metadata["phone"]
    PhoneData.MetaData = {}--PhoneMeta

    PhoneData.PlayerData.identifier = pData.identifier

    PhoneData.PlayerData.firstName = pData.firstName
    PhoneData.PlayerData.lastName = pData.lastName

    PhoneData.PlayerData.source = pData.source

    PhoneData.BoostCoins = pData.boostCoins

    --if PhoneMeta.profilepicture == nil then
        PhoneData.MetaData.profilepicture = "default"
    --else
    --    PhoneData.MetaData.profilepicture = PhoneMeta.profilepicture
   -- end

    if pData.PlayerContacts ~= nil and next(pData.PlayerContacts) ~= nil then 
        PhoneData.Contacts = pData.PlayerContacts
    end

    if pData.TransactionData ~= nil and next(pData.TransactionData) ~= nil then 
        PhoneData.TransactionData = pData.TransactionData
    end

    if pData.Invoices ~= nil and next(pData.Invoices) ~= nil then
        PhoneData.Invoices = pData.Invoices
    end

    if pData.Hashtags ~= nil and next(pData.Hashtags) ~= nil then
        PhoneData.Hashtags = pData.Hashtags
    end

    if pData.Mails ~= nil and next(pData.Mails) ~= nil then
        PhoneData.Mails = pData.Mails
    end

    if pData.Adverts ~= nil and next(pData.Adverts) ~= nil then
        PhoneData.Adverts = pData.Adverts
    end

    if pData.Darkweb ~= nil and next(pData.Darkweb) ~= nil then
        PhoneData.Darkweb = pData.Darkweb
    end

    if pData.Tinder ~= nil and next(pData.Tinder) ~= nil then
        PhoneData.Tinder = pData.Tinder
    end

    if pData.CryptoTransactions ~= nil and next(pData.CryptoTransactions) ~= nil then
        PhoneData.CryptoTransactions = pData.CryptoTransactions
    end

    if pData.RecentCalls ~= nil and next(pData.RecentCalls) ~= nil then
        local RecentCalls = {}
        for k, v in pairs(pData.RecentCalls) do   
            local callType = ''

            if pData.RecentCalls[k].incoming == 1 then
                if pData.RecentCalls[k].accepts == 1 then
                    callType = 'answered'
                else
                    callType = 'missed'
                end
            else
                if pData.RecentCalls[k].accepts == 1 then
                    callType = 'outgoing'
                else
                    callType = 'notanswered'
                end
            end

            table.insert(RecentCalls, {
                name = IsNumberInContacts(pData.RecentCalls[k].num),
                time = pData.RecentCalls[k].tempo,
                type = callType,
                number = pData.RecentCalls[k].num,
                anonymous = pData.RecentCalls[k].anonymous
            })
        end

        PhoneData.RecentCalls = RecentCalls
    end

    while not PhoneReady do Citizen.Wait(0) end

    SendNUIMessage({ 
        action = "LoadPhoneData", 
        PhoneData = PhoneData, 
        PlayerData = PhoneData.PlayerData,
        PlayerJob = PhoneData.PlayerData.job,
        myPhone = myPhoneNumber
    })

    SendNUIMessage({ action = "SetPhoneHas", HasPhone = HasPhone })

    PhoneLoaded = true
end


RegisterNUICallback("cphoneReady", function(data, cb)
    PhoneReady = true

    cb("ok")
end)

RegisterNUICallback('HasPhone', function(data, cb)
    cb(HasPhone)
end)

function OpenPhone()
    if not PhoneLoaded then
        return
    end

    if not HasPhone then ESX.ShowNotification("Não tens um Telemóvel", 'error')
        return
    end

    if ESX.getPlayerBleeding() >= 5 then
        ESX.ShowNotification("Não podes usar o telemóvel estás -5", 'error')
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        CallData = PhoneData.CallData,
        PlayerData = PhoneData.PlayerData,
    })
    PhoneData.isOpen = true

    Citizen.CreateThread(function()
        while PhoneData.isOpen and not inCamera do
            DisableDisplayControlActions()
            Citizen.Wait(0)
        end
    end)

    Citizen.CreateThread(function()
        while PhoneData.isOpen do
            SendNUIMessage({
                action = "UpdateTime",
                InGameTime = CalculateTimeToDisplay(),
            })
            Citizen.Wait(1000)
        end
    end)

    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_in')
    else
        DoPhoneAnimation('cellphone_call_to_text')
    end

    SetTimeout(250, function()
        newPhoneProp()
    end)

    --QBFunctions.TriggerCallback('cphone:server:GetGarageVehicles', function(vehicles)
        PhoneData.GarageVehicles = nil
    --end)
end

RegisterNUICallback('SetupGarageVehicles', function(data, cb)
    cb(PhoneData.GarageVehicles)
end)

RegisterNUICallback('Close', function()
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetTimeout(500, function()
        PhoneData.isOpen = false
    end)
end)

RegisterNUICallback('RemoveMail', function(data, cb)
    local MailId = data.mailId

    TriggerServerEvent('cphone:server:RemoveMail', MailId)
    cb('ok')
end)

RegisterNetEvent('cphone:client:UpdateMails')
AddEventHandler('cphone:client:UpdateMails', function(NewMails)
    SendNUIMessage({
        action = "UpdateMails",
        Mails = NewMails
    })
    PhoneData.Mails = NewMails
end)

RegisterNUICallback('AcceptMailButton', function(data)
    TriggerEvent(data.buttonEvent, data.buttonData)
    TriggerServerEvent('cphone:server:ClearButtonData', data.mailId)
end)



RegisterNUICallback('GetMails', function(data, cb)
    cb(PhoneData.Mails)
end)

RegisterNUICallback('GetWhatsappChat', function(data, cb)
    if PhoneData.Chats[data.phone] ~= nil then
        cb(PhoneData.Chats[data.phone])
    else
        cb(false)
    end
end)

RegisterNUICallback('GetBankContacts', function(data, cb)
    cb(PhoneData.Contacts)
end)

RegisterNUICallback('GetInvoices', function(data, cb)
    if PhoneData.Invoices ~= nil and next(PhoneData.Invoices) ~= nil then
        cb(PhoneData.Invoices)
    else
        cb(nil)
    end
end)

RegisterNUICallback('GetTransactions', function(data, cb)
    if PhoneData.TransactionData ~= nil and next(PhoneData.TransactionData) ~= nil then
        cb(PhoneData.TransactionData)
    else
        cb(nil)
    end
end)


RegisterNetEvent("cframework:receiveBillPhoneNotify", function(label)
    TriggerEvent("cphone:showPhoneNotification", "Banco", "Fatura recebida de "..label, "fas fa-university", "#BADC58")
end)



RegisterNetEvent("core_dispach:arrivalNotice", function()
    TriggerEvent("cphone:showPhoneNotification", "Serviços", 'A tua mensagem está a ser atendida, aguarda no local!', "fas fa-user-tie", "#3D87FF")
end)

RegisterNetEvent("qb-phone-new:client:BankNotify")
AddEventHandler("qb-phone-new:client:BankNotify", function(text)
    SendNUIMessage({
        action = "Notification",
        NotifyData = {
            title = "Bank", 
            content = text, 
            icon = "fas fa-university", 
            timeout = 3500, 
            color = "#ff002f",
        },
    })
end)

RegisterNUICallback('PostAdvert', function(data)
    TriggerServerEvent('cphone:server:AddAdvert', data.message, data.image, data.type)
end)

RegisterNUICallback('PostDarkweb', function(data)
    TriggerServerEvent('cphone:server:AddDarkweb', data.message)
end)

RegisterNetEvent('cphone:client:UpdateAdverts', function(msg, image, name, number, atype, color, tcolor)
    table.insert(PhoneData.Adverts, {
        message = msg,
        image = image,
        name = name,
        number = number,
        type = atype,
        color = color,
        textcolor = tcolor
    })

    if atype == 'personal' then
        TriggerEvent("cphone:showPhoneNotification", "Anúncios", name..' publicou um anúncio!', "fas fa-ad", "#ff8f1a")
    elseif atype == 'business' then
        TriggerEvent("cphone:showPhoneNotification", "Anúncios", number..' publicou um anúncio!', "fas fa-ad", "#ff8f1a")
    end

    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNUICallback('LoadAdverts', function()
    SendNUIMessage({
        action = "RefreshAdverts",
        Adverts = PhoneData.Adverts
    })
end)

RegisterNetEvent('cphone:client:UpdateDarkweb', function(msg, name, number)
    table.insert(PhoneData.Darkweb, {
        message = msg,
        name = name,
        number = number,
    })

    SendNUIMessage({
        action = "RefreshDarkweb",
        Adverts = PhoneData.Darkweb
    })
end)

RegisterNUICallback('LoadDarkweb', function()
    SendNUIMessage({
        action = "RefreshDarkweb",
        Adverts = PhoneData.Darkweb
    })
end)

local awaingResponseBills = false

RegisterNUICallback('PayInvoice', function(data, cb)
    if awaingResponseBills then return end

    awaingResponseBills = true

    ESX.TriggerServerCallback('esx_billing:payBill', function(payed)
        awaingResponseBills = false
        cb(payed)
    end, data.invoiceId)

    for k, v in ipairs(PhoneData.Invoices) do
        if v.id == data.invoiceId then
            table.remove(PhoneData.Invoices, k)
        end
    end

end)





local function escape_str(s)
	-- local in_char  = {'\\', '"', '/', '\b', '\f', '\n', '\r', '\t'}
	-- local out_char = {'\\', '"', '/',  'b',  'f',  'n',  'r',  't'}
	-- for i, c in ipairs(in_char) do
	--   s = s:gsub(c, '\\' .. out_char[i])
	-- end
	return s
end

RegisterNetEvent('cphone:client:UpdateHashtags')
AddEventHandler('cphone:client:UpdateHashtags', function(Handle, msgData)
    if PhoneData.Hashtags[Handle] ~= nil then
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    else
        PhoneData.Hashtags[Handle] = {
            hashtag = Handle,
            messages = {}
        }
        table.insert(PhoneData.Hashtags[Handle].messages, msgData)
    end

    SendNUIMessage({
        action = "UpdateHashtags",
        Hashtags = PhoneData.Hashtags,
    })
end)

RegisterNUICallback('GetHashtagMessages', function(data, cb)
    if PhoneData.Hashtags[data.hashtag] ~= nil and next(PhoneData.Hashtags[data.hashtag]) ~= nil then
        cb(PhoneData.Hashtags[data.hashtag])
    else
        cb(nil)
    end
end)

RegisterNUICallback('UpdateProfilePicture', function(data)
    local pf = data.profilepicture

    PhoneData.MetaData.profilepicture = pf
    
    TriggerServerEvent('cphone:server:SaveMetaData', PhoneData.MetaData)
end)

RegisterNUICallback('UpdateRingTone', function(data)
    local rt = data.ringtone

    SetResourceKvp('ringtone', rt)
end)





RegisterNetEvent('cphone:client:TransferMoney', function(amount)
    TriggerEvent("cphone:showPhoneNotification", "Banco", "&euro;"..amount.." recebeste uma transferência!", "fas fa-university", "#8c7ae6")
end)

RegisterNUICallback('ClearGeneralAlerts', function(data)

end)

function string:split(delimiter)
    local result = { }
    local from  = 1
    local delim_from, delim_to = string.find( self, delimiter, from  )
    while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from  = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from  )
    end
    table.insert( result, string.sub( self, from  ) )
    return result
end

RegisterNUICallback('CanTransferMoney', function(data, cb)
    local amount = tonumber(data.amountOf)
    local iban = data.sendTo

    --Tem que ir buscar o guito ao server side

    if (PlayerData.bank - amount) >= 0 then
        local Transferd = RPC.execute('mobileMoneyTransfer', iban, amount)
        if Transferd then
            cb({TransferedMoney = true, NewBalance = (PlayerData.bank - amount)})
        else
            cb({TransferedMoney = false})
        end
        
    else
        cb({TransferedMoney = false})
    end
end)





-- AddEventHandler('onResourceStop', function(resource)
--     if resource == GetCurrentResourceName() then
--         -- SetNuiFocus(false, false)
--     end
-- end)

RegisterNUICallback('FetchSearchResults', function(data, cb)
    local result = RPC.execute('cphone:server:FetchResult', data.input)
        
    cb(result)
end)

RegisterNUICallback('FetchVehicleResults', function(data, cb)

    cb(nil)
end)

RegisterNUICallback('FetchVehicleScan', function(data, cb)

    cb(nil)
end)

RegisterNetEvent('qb-phone:client:addPoliceAlert')
AddEventHandler('qb-phone:client:addPoliceAlert', function(alertData)
    if PlayerData.job.name == 'police' then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)

RegisterNUICallback('SetAlertWaypoint', function(data)
    local coords = data.alert.coords

    ESX.ShowNotification('Localização marcada no GPS: '..data.alert.title, 'inform')
    SetNewWaypoint(coords.x, coords.y)
end)





RegisterNUICallback('GetCryptoData', function(data, cb)
    cb(nil)
end)

RegisterNUICallback('BuyCrypto', function(data, cb)
    cb(nil)
end)

RegisterNUICallback('SellCrypto', function(data, cb)
    cb(nil)
end)

RegisterNUICallback('TransferCrypto', function(data, cb)
    cb(nil)
end)

RegisterNUICallback('GetAvailableRaces', function(data, cb) --Para as corridas é preciso o mkr racing
    local Races = RPC.execute('mkr_racing:getActiveRaces')

    cb(Races)
end)

RegisterNUICallback('GetRacesUpdates', function(data, cb)
    TriggerServerEvent('mkr_racing:server:SendRacesUpdate', data.getUpdates)

    cb("ok")
end)

RegisterNUICallback('JoinRace', function(data)
    RPC.execute("mkr_racing:joinRace", data.RaceId)
end)

RegisterNUICallback('LeaveRace', function(data)
    RPC.execute("mkr_racing:quitRace", data.RaceData.id)
end)

RegisterNUICallback('EndRace', function(data)
    RPC.execute("mkr_racing:endRace", data.RaceData.id)
end)

RegisterNUICallback('StartRace', function(data)
    RPC.execute("mkr_racing:startRace", data.RaceData.id, 30000)
end)

RegisterNetEvent('cphone:client:UpdateLapraces')
AddEventHandler('cphone:client:UpdateLapraces', function()
    SendNUIMessage({
        action = "UpdateRacingApp",
    })
end)

RegisterNetEvent("cframework:racePositionUpdate", function(positions)
    SendNUIMessage({
        action = "UpdateRacingPosition",
        positions = positions,
    })
end)

RegisterNUICallback('GetRaces', function(data, cb)
    local Races = RPC.execute("mkr_racing:getRaces")

    cb(Races)
end)

RegisterNUICallback('GetTrackData', function(data, cb)
    --Info da corrida
    cb(nil)

end)

RegisterNUICallback('SetupRace', function(data, cb)
    --TriggerServerEvent('qb-lapraces:server:SetupRace', data.RaceId, tonumber(data.AmountOfLaps))
end)

RegisterNUICallback('HasCreatedRace', function(data, cb)
    local canSetup = RPC.execute('mkr_racing:canRaceSetup')
    
    cb(canSetup)
end)

RegisterNUICallback('IsInRace', function(data, cb)
    local inRace = RPC.execute("mkr_racing:inRace", data.id)
    
    cb(inRace)
end)

RegisterNUICallback('IsAuthorizedToCreateRaces', function(data, cb)
    local permToCreate, isNameAvailable = RPC.execute("mkr_racing:hasPermToCreate", data.TrackName)
    local data = {
        IsAuthorized = permToCreate,
        IsBusy = exports['gracing']:isCreating(),
        IsNameAvailable = isNameAvailable,
    }
    cb(data)
end)

RegisterNUICallback('StartTrackEditor', function(data, cb)
    --TriggerServerEvent('qb-lapraces:server:CreateLapRace', data.TrackName)
    local options = {}
    options.raceName = data.TrackName
    options.raceType = 'Lap'
    options.raceThumbnail = 'empty'
    TriggerEvent("mkr_racing:cmd:racecreate", options)
end)

RegisterNUICallback('EndTrackEditor', function(data, cb)
    TriggerEvent("mkr_racing:cmd:racecreatedone")
end)

RegisterNUICallback('GetRacingLeaderboards', function(data, cb)
    --[[QBCoFunctions.TriggerCallback('qb-lapraces:server:GetRacingLeaderboards', function(Races)
        cb(Races)
    end)]]
    cb(nil)
end)

RegisterNUICallback('RaceDistanceCheck', function(data, cb)
    local canCreate = RPC.execute('mkr_racing:canRaceSetup')

    if not canCreate then return end

    local race = RPC.execute('mkr_racing:getRace', data.RaceId)

    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local checkpointcoords = race.start.pos
    local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)

    if dist <= 115.0 then
        RPC.execute("mkr_racing:makeRaceActive", data.RaceId, data.AmountOfLaps, data.enableNitro)

        --print(dist)

        cb(true)
    else
        TriggerEvent("cphone:showPhoneNotification", "Corridas", "Estás demasiado longe, a corrida foi marcada no GPS", "fas fa-flag-checkered", "#FFFFFF")

        SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
        cb(false)
    end
end)

RegisterNUICallback('RaceDistanceCheckCanJoin', function(data, cb)
    local race = RPC.execute('mkr_racing:getRace', data.RaceId)

    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local checkpointcoords = race.start.pos
    local dist = GetDistanceBetweenCoords(coords, checkpointcoords.x, checkpointcoords.y, checkpointcoords.z, true)

    if dist <= 115.0 then
        print(dist)

        cb(true)
    else
        TriggerEvent("cphone:showPhoneNotification", "Corridas", "Estás demasiado longe, a corrida foi marcada no GPS", "fas fa-flag-checkered", "#FFFFFF")

        SetNewWaypoint(checkpointcoords.x, checkpointcoords.y)
        cb(false)
    end
end)

RegisterNUICallback('IsBusyCheck', function(data, cb)
    --if data.check == "editor" then
    --    cb(exports['qb-lapraces']:IsInEditor())
    --else
    --    cb(exports['qb-lapraces']:IsInRace())
    --end
    cb(exports['gracing']:isCreating())
end)

RegisterNUICallback('CanRaceSetup', function(data, cb)
    local canRaceSetup = RPC.execute('mkr_racing:canRaceSetup')

    cb(canRaceSetup)
end)

RegisterNUICallback('GetPlayerHouses', function(data, cb)
    --QBCo.Functions.TriggerCallback('cphone:server:GetPlayerHouses', function(Houses)
        cb(Houses)
    --end)
end)

RegisterNUICallback('GetPlayerKeys', function(data, cb)
    --QBCo.Functions.TriggerCallback('cphone:server:GetHouseKeys', function(Keys)
        cb(Keys)
    --end)
end)

RegisterNUICallback('SetHouseLocation', function(data, cb)
    SetNewWaypoint(data.HouseData.HouseData.coords.enter.x, data.HouseData.HouseData.coords.enter.y)
    --QBCe.Functions.Notify("GPS has been set on " .. data.HouseData.HouseData.adress .. "!", "success")
end)

RegisterNUICallback('RemoveKeyholder', function(data)
    TriggerServerEvent('qb-houses:server:removeHouseKey', data.HouseData.name, {
        citizenid = data.HolderData.citizenid,
        firstname = data.HolderData.charinfo.firstname,
        lastname = data.HolderData.charinfo.lastname,
    })
end)

RegisterNUICallback('TransferCid', function(data, cb)
    local TransferedCid = data.newBsn

    --QBCorFunctions.TriggerCallback('cphone:server:TransferCid', function(CanTransfer)
        cb(CanTransfer)
    --end, TransferedCid, data.HouseData)
end)

RegisterNUICallback('FetchPlayerHouses', function(data, cb)
    --QBCe.Functions.TriggerCallback('cphone:server:MeosGetPlayerHouses', function(result)
        cb(result)
    --end, data.input)
end)

RegisterNUICallback('SetGPSLocation', function(data, cb)
    local ped = GetPlayerPed(-1)

    SetNewWaypoint(data.coords.x, data.coords.y)
    ESX.ShowNotification('Marcado no GPS!', 'success')
end)

RegisterNUICallback('SetApartmentLocation', function(data, cb)
    local ApartmentData = data.data.appartmentdata
    local TypeData = Apartments.Locations[ApartmentData.type]

    SetNewWaypoint(TypeData.coords.enter.x, TypeData.coords.enter.y)
    ESX.ShowNotification('Marcado no GPS!', 'success')
end)

RegisterNUICallback('GetCurrentLawyers', function(data, cb)
    local services = RPC.execute('cphone:server:GetCurrentServices')
    
    cb(services)
end)

local dispatchCooldown = false

RegisterNUICallback('SendHelpMessage', function(data, cb)
    --print(data.ContactData.number)
    --print(data.ContactData.message)
    --print(GetEntityCoords(PlayerPedId()))

    local cord = GetEntityCoords(PlayerPedId())

    if not dispatchCooldown then
        TriggerEvent("cphone:showPhoneNotification", "Serviços", "Mensagem enviada para os serviços!", "fas fa-user-tie", "#3D87FF")
        dispatchCooldown = true
        SetTimeout(300000, function()
            dispatchCooldown = false
        end)

        TriggerServerEvent("core_dispach:addMessage", data.ContactData.message, {cord.x, cord.y, cord.z}, data.ContactData.number, 5000, 280, 911)

        cb(true)
    else
        TriggerEvent("cphone:showPhoneNotification", "Serviços", "Aguarda um pouco antes de enviar outra mensagem...", "fas fa-user-tie", "#3D87FF")

        cb(false)
    end

    --integrar com o core dispatch
end)



RegisterNUICallback('GetTruckerData', function(data, cb)
    --local TruckerMeta = QBCFunctions.GetPlayerData().metadata["jobrep"]["trucker"]
    --local TierData = exports['qb-trucker']:GetTier(TruckerMeta)
    cb(TierData)
end)

RegisterNUICallback('PostTinder', function(data, cb)
    TriggerServerEvent('cphone:server:AddTinder', data.Description, data.Picture)
end)

RegisterNetEvent('cphone:client:UpdateTinder', function(Tinder, LastPost)
    PhoneData.Tinder = Tinder

    SendNUIMessage({
        action = "RefreshTinder",
        Tinder = PhoneData.Tinder
    })
end)

RegisterNUICallback('LoadTinder', function(data)
    SendNUIMessage({
        action = "RefreshTinder",
        Tinder = PhoneData.Tinder
    })
end)

RegisterNUICallback('CreateCamera', function(data)
    CreateCamera()
end)

RegisterNUICallback('takePhoto', function(data)
    local photo = data.photo

    TriggerServerEvent('cphone:addItemGallery', photo, 'photo')
end)

RegisterNUICallback('recordVideo', function(data)
    local video = data.video

    TriggerServerEvent('cphone:addItemGallery', video, 'video')
end)

RegisterNUICallback('getGalleryPage', function(data, cb)
    local g = RPC.execute('cframework:cphone:getGallery', tonumber(data.page))

    cb(g)
end)

RegisterNUICallback('deleteGalleryElement', function(data, cb)
    local link = data.link

    TriggerServerEvent('cphone:deleteGalleryElement', link)
end)

-- Disables GTA controls when display is active
-- this allows for NUI input with ingame input
function DisableDisplayControlActions()
    DisableControlAction(0, 1, true) -- disable mouse look
    DisableControlAction(0, 2, true) -- disable mouse look
    DisableControlAction(0, 3, true) -- disable mouse look
    DisableControlAction(0, 4, true) -- disable mouse look
    DisableControlAction(0, 5, true) -- disable mouse look
    DisableControlAction(0, 6, true) -- disable mouse look

    DisableControlAction(0, 263, true) -- disable melee
    DisableControlAction(0, 264, true) -- disable melee
    DisableControlAction(0, 257, true) -- disable melee
    DisableControlAction(0, 140, true) -- disable melee
    DisableControlAction(0, 141, true) -- disable melee
    DisableControlAction(0, 142, true) -- disable melee
    DisableControlAction(0, 143, true) -- disable melee

    DisableControlAction(0, 177, true) -- disable escape
    DisableControlAction(0, 200, true) -- disable escape
    DisableControlAction(0, 202, true) -- disable escape
    DisableControlAction(0, 322, true) -- disable escape

    DisableControlAction(0, 245, true) -- disable chat  
end

function InPhone()
    return PhoneData.isOpen
end

function CreateCamera()
    if inCamera then return end

    CreateMobilePhone(1)
	CellCamActivate(true, true)
    SetNuiFocus(false, false)
	inCamera = true
    frontCam = false

	Citizen.CreateThread(function()
		while inCamera do
			Citizen.Wait(0)
	
			if IsControlJustReleased(1, 177) and inCamera then -- CLOSE PHONE
				DestroyMobilePhone()
				inCamera = false
				CellCamActivate(false, false)
                SendNUIMessage({
                    action = "CloseCameraApp"
                })
                SetNuiFocus(true, true)
				if firstTime then firstTime = false
					Citizen.Wait(2500)
				end
			end

			if IsControlJustReleased(1, 27) and inCamera then -- SELFIE MODE
				frontCam = not frontCam
                CellCamActivateSelfieMode(frontCam)
			end

            if IsControlJustReleased(1, 24) and inCamera then -- Click camera button
                SendNUIMessage({
                    action = "CameraTrigger"
                })
			end

            if IsControlJustReleased(1, 175) and inCamera then -- Photo Mode
                SendNUIMessage({
                    action = "ActivatePhoto"
                })
			end

            if IsControlJustReleased(1, 174) and inCamera then -- Video Mode
                SendNUIMessage({
                    action = "ActivateVideo"
                })
			end

            if IsControlJustReleased(1, 153) and inCamera then -- Rotate
                SendNUIMessage({
                    action = "RotatePhone"
                })
			end

			if inCamera then
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
                DisableFrontendThisFrame()
			end

			local renId = GetMobilePhoneRenderId()
			SetTextRenderId(renId)

			-- Everything rendered inside here will appear on your phone.

			SetTextRenderId(1) -- NOTE: 1 is default
		end
	end)
end

