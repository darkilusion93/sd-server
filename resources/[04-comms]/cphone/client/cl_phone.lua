local fixedPhones = {
    ['800'] = {coords = vector3(247.93, 225.04, 105.29), ringing = false, inCall = false},
    ['801'] = {coords = vector3(-630.99, -229.65, 37.06), ringing = false, inCall = false},
    ['112'] = {coords = vector3(-813.76, -1236.91, 6.34), ringing = false, inCall = false},
}

RegisterNUICallback('EditContact', function(data, cb)
    local NewName, NewNumber, NewIban = data.CurrentContactName, data.CurrentContactNumber, data.CurrentContactIban
    local OldName, OldNumber, OldIban = data.OldContactName, data.OldContactNumber, data.OldContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == OldName and v.number == OldNumber then
            v.name = NewName
            v.number = NewNumber
            v.iban = NewIban
        end
    end
    if PhoneData.Chats[NewNumber] ~= nil and next(PhoneData.Chats[NewNumber]) ~= nil then
        PhoneData.Chats[NewNumber].name = NewName
    end

    TriggerServerEvent('cframework:cphone:EditContact', NewName, NewNumber, NewIban, OldName, OldNumber, OldIban)

    cb(PhoneData.Contacts)
end)

RegisterNUICallback('AddNewContact', function(data, cb)
    table.insert(PhoneData.Contacts, {
        name = data.ContactName,
        number = data.ContactNumber,
        iban = data.ContactIban
    })

    if PhoneData.Chats[data.ContactNumber] ~= nil and next(PhoneData.Chats[data.ContactNumber]) ~= nil then
        PhoneData.Chats[data.ContactNumber].name = data.ContactName
    end

    TriggerServerEvent('cframework:cphone:AddNewContact', data.ContactName, data.ContactNumber, data.ContactIban)

    if PhoneData.RecentCalls ~= nil and next(PhoneData.RecentCalls) ~= nil then
        local RecentCalls = {}
        for k, v in pairs(PhoneData.RecentCalls) do
            table.insert(RecentCalls, {
                name = IsNumberInContacts(PhoneData.RecentCalls[k].number),
                time = PhoneData.RecentCalls[k].time,
                type = PhoneData.RecentCalls[k].type,
                number = PhoneData.RecentCalls[k].number,
                anonymous = PhoneData.RecentCalls[k].anonymous
            })
        end

        PhoneData.RecentCalls = RecentCalls
    end

    cb(PhoneData.Contacts)
end)

RegisterNUICallback('DeleteContact', function(data, cb)
    local Name, Number, Account = data.CurrentContactName, data.CurrentContactNumber, data.CurrentContactIban

    for k, v in pairs(PhoneData.Contacts) do
        if v.name == Name and v.number == Number then
            table.remove(PhoneData.Contacts, k)
            break
        end
    end

    if PhoneData.Chats[Number] ~= nil and next(PhoneData.Chats[Number]) ~= nil then
        PhoneData.Chats[Number].name = Number
    end

    TriggerServerEvent('cframework:cphone:RemoveContact', Name, Number)

    cb(PhoneData.Contacts)
end)

RegisterNUICallback('CallContact', function(data, cb)
    local CanCall, IsOnline, IsFixed = RPC.execute('cframework:cphone:GetCallState', data.ContactData)

    local status = { 
        CanCall = CanCall, 
        IsOnline = IsOnline,
        InCall = PhoneData.CallData.InCall,
        isVideo = isVideo,
    }

    cb(status)

    if CanCall and not status.InCall and (data.ContactData.number ~= myPhoneNumber) then
        CallContact(data.ContactData, data.Anonymous, IsFixed, data.isVideo)
    end
end)

function CallContact(CallData, AnonymousCall, IsFixed, isVideo)
    local RepeatCount = 0
    PhoneData.CallData.CallType = "outgoing"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.isVideo = isVideo
    PhoneData.CallData.CallId = RPC.execute('generateCallId')

    local numberImCalling = PhoneData.CallData.TargetData.number

    if not IsFixed then
        TriggerServerEvent('cphone:server:CallContact', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall, isVideo)
        TriggerServerEvent('cphone:server:SetCallState', true)
    else
        TriggerServerEvent('cphone:server:SetCallState', true)
        TriggerServerEvent('cphone:server:SetCallStateFixed', PhoneData.CallData.TargetData.number, true)
        TriggerServerEvent('cphone:server:CallContactFixed', PhoneData.CallData.TargetData, PhoneData.CallData.CallId, AnonymousCall)
    end
    
    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    RepeatCount = RepeatCount + 1
                    TriggerEvent("InteractSound_CL:PlayOnOne", "callsound", 0.2)
                else
                    TriggerServerEvent('cframework:cphone:AddRecentCall', false, numberImCalling, AnonymousCall)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                TriggerServerEvent('cframework:cphone:AddRecentCall', false, numberImCalling, AnonymousCall)
                CancelCall()
                break
            end
        else
            TriggerServerEvent('cframework:cphone:AddRecentCall', true, numberImCalling, AnonymousCall)
            break
        end
    end
end

RegisterNetEvent('cframework:cphone:notifyNewRecentCall', function(num, incoming, accepted, anonymous, timestamp)
    local callType = ''

    if incoming == 1 then
        if accepted then
            callType = 'answered'
        else
            callType = 'missed'
        end
    else
        if accepted then
            callType = 'outgoing'
        else
            callType = 'notanswered'
        end
    end
    
    table.insert(PhoneData.RecentCalls, {
        name = IsNumberInContacts(num),
        time = timestamp,
        type = callType,
        number = num,
        anonymous = anonymous
    })
end)

RegisterNUICallback('GetMissedCalls', function(data, cb)
    cb(PhoneData.RecentCalls)
end)

function IsNumberInContacts(num)
    local retval = num
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = v.name
        end
    end
    return retval
end

function IsNumberInContactsBool(num)
    local retval = false
    for _, v in pairs(PhoneData.Contacts) do
        if num == v.number then
            retval = true
        end
    end
    return retval
end

RegisterNUICallback('IsNumberInContacts', function(data, cb)
    local PhoneNumber = data.Number

    cb(IsNumberInContactsBool(PhoneNumber))
end)

CancelCall = function()
    TriggerServerEvent('cphone:server:CancelCall', PhoneData.CallData)
    if PhoneData.CallData.CallType == "ongoing" then
        exports["mumble-voip"]:SetCallChannel(0)
        --exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
    end

    if PhoneData.CallData.TargetData.number then
        TriggerServerEvent('cphone:server:SetCallStateFixed', PhoneData.CallData.TargetData.number, nil)
    end

    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}
    PhoneData.CallData.CallId = nil

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('cphone:server:SetCallState', false)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end

RegisterNetEvent('cphone:client:CancelCallFixed', function(number)
    if fixedPhones[number] then
        fixedPhones[number].ringing = false
        fixedPhones[number].inCall = false

        --print(fixedPhones[number].ringing)
    end
end)

RegisterNetEvent('cphone:client:CancelCall', function()
    if PhoneData.CallData.CallType == "ongoing" then
        SendNUIMessage({
            action = "CancelOngoingCall"
        })
        exports["mumble-voip"]:SetCallChannel(0)
        --exports.tokovoip_script:removePlayerFromRadio(PhoneData.CallData.CallId)
    end

    if PhoneData.CallData.TargetData.number then
        TriggerServerEvent('cphone:server:SetCallStateFixed', PhoneData.CallData.TargetData.number, nil)
    end

    PhoneData.CallData.CallType = nil
    PhoneData.CallData.InCall = false
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = {}

    if not PhoneData.isOpen then
        StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
        deletePhone()
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
    end

    TriggerServerEvent('cphone:server:SetCallState', false)

    if PhoneData.isOpen then
        SendNUIMessage({
            action = "SetupHomeCall",
            CallData = PhoneData.CallData,
        })

        SendNUIMessage({
            action = "CancelOutgoingCall",
        })
    end
end)

RegisterNetEvent('cphone:client:GetCalled', function(CallerNumber, CallId, AnonymousCall, isVideo)
    local RepeatCount = 0
    local notifyShown = false
    local ringtone = getLocalValue('ringtone', 'tusa')
    local CallData = {
        number = CallerNumber,
        name = IsNumberInContacts(CallerNumber),
        anonymous = AnonymousCall,
        isVideo = isVideo
    }

    if AnonymousCall then
        CallData.name = "###-####"
    end

    if IsPhoneInAirPlaneMode() then return end

    PhoneData.CallData.isVideo = isVideo
    PhoneData.CallData.CallType = "incoming"
    PhoneData.CallData.InCall = true
    PhoneData.CallData.AnsweredCall = false
    PhoneData.CallData.TargetData = CallData
    PhoneData.CallData.CallId = CallId

    TriggerServerEvent('cphone:server:SetCallState', true)

    SendNUIMessage({
        action = "SetupHomeCall",
        CallData = PhoneData.CallData,
    })

    Citizen.Wait(500)

    for i = 1, Config.CallRepeats + 1, 1 do
        if not PhoneData.CallData.AnsweredCall then
            if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                if PhoneData.CallData.InCall then
                    if HasPhone then
                        RepeatCount = RepeatCount + 1
                        if not notifyShown then
                            TriggerEvent("InteractSound_CL:PlayOnOne", ringtone, 0.4)
                        end

                        notifyShown = true
                    end
                else
                    TriggerEvent("InteractSound_CL:PlayOnOne", "demo", 0.0)
                    break
                end
                Citizen.Wait(Config.RepeatTimeout)
            else
                TriggerEvent("InteractSound_CL:PlayOnOne", "demo", 0.0)
                break
            end
        else
            TriggerEvent("InteractSound_CL:PlayOnOne", "demo", 0.0)
            break
        end
    end
end)

RegisterNetEvent('cphone:client:GetCalledFixed', function(fixedNumber, CallerNumber, CallId, AnonymousCall)
    local fPhone = fixedPhones[fixedNumber]

    if fPhone == nil then return end

    local coords = fPhone.coords
    local endCall = false
    local RepeatCount = 0

    fixedPhones[fixedNumber].ringing = true

    Citizen.CreateThread(function()
        for i = 1, Config.CallRepeats + 1, 1 do
            if not PhoneData.CallData.AnsweredCall then
                if RepeatCount + 1 ~= Config.CallRepeats + 1 then
                    RepeatCount = RepeatCount + 1
                    local playerCoords = GetEntityCoords(PlayerPedId())

                    if #(playerCoords - coords) < 10 then
                        TriggerEvent("InteractSound_CL:PlayOnOne", "fixedphone", 0.4)
                    end
                    
                    Citizen.Wait(Config.RepeatTimeout)
                    if fixedPhones[fixedNumber].inCall then
                        break
                    end

                    if not fixedPhones[fixedNumber].ringing then
                        break
                    end
                end
            end
        end

        if not fixedPhones[fixedNumber].inCall then
            endCall = true
        end
    end)

    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        if #(playerCoords - coords) < 10 then
            DrawMarker(1, coords.x, coords.y, coords.z,0,0,0, 0,0,0, 0.1,0.1,0.1, 0,255,0,255, 0,0,0,0,0,0,0)
        end

        if #(playerCoords - coords) < 2 then
            SetTextComponentFormat("STRING")
            AddTextComponentSubstringPlayerName('Pressiona ~INPUT_CONTEXT~ para atender a chamada.')
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustPressed(1, 51) then
                fixedPhones[fixedNumber].inCall = true

                TriggerServerEvent('cphone:server:AnswerCallFixed', CallerNumber)

                print(CallId)
                exports["mumble-voip"]:SetCallChannel(CallId)

                FreezeEntityPosition(PlayerPedId(), true)

                Citizen.Wait(500)

                while true do
                    SetTextComponentFormat("STRING")
                    AddTextComponentSubstringPlayerName('Pressiona ~INPUT_CONTEXT~ para terminar a chamada.')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1, 51) then
                        fixedPhones[fixedNumber].inCall = false
                        TriggerServerEvent('cphone:server:FixedCancelCall', fixedNumber)
                        
                        --TriggerServerEvent('cphone:server:AnswerCallFixed', CallerNumber)
                    end

                    if not fixedPhones[fixedNumber].inCall then
                        FreezeEntityPosition(PlayerPedId(), false)
                        exports["mumble-voip"]:SetCallChannel(0)
                        return
                    end

                    Citizen.Wait(0)
                end
            end
        end

        if fixedPhones[fixedNumber].inCall then
            break
        end

        --print(cancelFixedCall)

        if not fixedPhones[fixedNumber].ringing then
            return
        end

        if endCall then
            return
        end
        Citizen.Wait(0)
    end
end)


RegisterNUICallback('CancelOutgoingCall', function()
    CancelCall()
end)

RegisterNUICallback('DenyIncomingCall', function()
    CancelCall()
end)

RegisterNUICallback('CancelOngoingCall', function()
    CancelCall()
end)

RegisterNUICallback('AnswerCall', function()
    AnswerCall()
end)

function AnswerCall()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        if PhoneData.CallData.isVideo then
            SendNUIMessage({
                action = "startwatching",
                id = PhoneData.CallData.TargetData.number,
                serverid = GetPlayerServerId(PlayerId()),
            })
        end

        TriggerEvent("InteractSound_CL:PlayOnOne", "demo", 0.0)

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('cphone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        TriggerServerEvent('cphone:server:AnswerCall', PhoneData.CallData)

        print(PhoneData.CallData.CallId)
        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        TriggerEvent("cphone:showPhoneNotification", "Phone", "Não tens chamadas pendentes...", "fas fa-phone", "#E84118")
    end
end

RegisterNetEvent('cphone:client:AnswerCall', function()
    if (PhoneData.CallData.CallType == "incoming" or PhoneData.CallData.CallType == "outgoing") and PhoneData.CallData.InCall and not PhoneData.CallData.AnsweredCall then
        PhoneData.CallData.CallType = "ongoing"
        PhoneData.CallData.AnsweredCall = true
        PhoneData.CallData.CallTime = 0

        if PhoneData.CallData.isVideo then
            SendNUIMessage({
                action = "startwatching",
                id = PhoneData.CallData.TargetData.number,
                serverid = GetPlayerServerId(PlayerId()),
            })
        end

        SendNUIMessage({ action = "AnswerCall", CallData = PhoneData.CallData})
        SendNUIMessage({ action = "SetupHomeCall", CallData = PhoneData.CallData})

        TriggerServerEvent('cphone:server:SetCallState', true)

        if PhoneData.isOpen then
            DoPhoneAnimation('cellphone_text_to_call')
        else
            DoPhoneAnimation('cellphone_call_listen_base')
        end

        Citizen.CreateThread(function()
            while true do
                if PhoneData.CallData.AnsweredCall then
                    PhoneData.CallData.CallTime = PhoneData.CallData.CallTime + 1
                    SendNUIMessage({
                        action = "UpdateCallTime",
                        Time = PhoneData.CallData.CallTime,
                        Name = PhoneData.CallData.TargetData.name,
                    })
                else
                    break
                end

                Citizen.Wait(1000)
            end
        end)

        exports["mumble-voip"]:SetCallChannel(PhoneData.CallData.CallId)
    else
        PhoneData.CallData.InCall = false
        PhoneData.CallData.CallType = nil
        PhoneData.CallData.AnsweredCall = false

        TriggerEvent("cphone:showPhoneNotification", "Phone", "Não tens chamadas pendentes...", "fas fa-phone", "#E84118")
    end
end)

RegisterNUICallback('CreateFacetimeCamera', function(data)
    CreateFacetimeCamera()
end)

RegisterNUICallback('destroyFacetimeCamera', function(data)
    DestroyMobilePhone()
    inCamera = false
    CellCamActivate(false, false)
    SetNuiFocus(true, true)
end)

local frontCam = false

function CreateFacetimeCamera()
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
                    action = "EndFacetimeCall"
                })
                SetNuiFocus(true, true)
				if firstTime then firstTime = false 
					Citizen.Wait(2500)
				end
			end

            if IsControlJustReleased(1, 24) and inCamera and PhoneData.CallData.CallType == "incoming" then -- Answer call
                SendNUIMessage({
                    action = "AnswerFacetimeCall"
                })
			end
			
			if IsControlJustReleased(1, 27) and inCamera then -- SELFIE MODE
				frontCam = not frontCam
                _invokeM(0x2491A93618B7D838, frontCam)
			end
				
			if inCamera then
				HideHudComponentThisFrame(7)
				HideHudComponentThisFrame(8)
				HideHudComponentThisFrame(9)
				HideHudComponentThisFrame(6)
				HideHudComponentThisFrame(19)
				HideHudAndRadarThisFrame()
			end
				
			local renId = GetMobilePhoneRenderId()
			SetTextRenderId(renId)
			
			-- Everything rendered inside here will appear on your phone.
			
			SetTextRenderId(1) -- NOTE: 1 is default
		end
	end)
end