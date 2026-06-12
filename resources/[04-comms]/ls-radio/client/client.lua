-- ESX

ESX              = nil
local PlayerData = {}
local phoneProp  = 0

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local radioMenu = false

function newPhoneProp()
  deletePhone()
  RequestModel("prop_cs_walkie_talkie")
  while not HasModelLoaded("prop_cs_walkie_talkie") do
    Citizen.Wait(1)
  end

  phoneProp = CreateObject("prop_cs_walkie_talkie", 1.0, 1.0, 1.0, 1, 1, 0)
  local bone = GetPedBoneIndex(PlayerPedId(), 28422)
  AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
end

function deletePhone()
  if phoneProp ~= 0 then
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(phoneProp))
    phoneProp = 0
  end
end

function enableRadio(enable)
  if enable then
    local dict = "cellphone@"
    if IsPedInAnyVehicle(PlayerPedId(), false) then
      dict = "anim@cellphone@in_car@ps"
    end

    loadAnimDict(dict)

    local anim = "cellphone_call_to_text"
    TaskPlayAnim(PlayerPedId(), dict, anim, 3.0, -1, -1, 50, 0, false, false, false)
    newPhoneProp()
  else
    ClearPedSecondaryTask(PlayerPedId())
    deletePhone()
  end

  SetNuiFocus(true, true)
  radioMenu = enable
  SendNUIMessage({
    type = "enableui",
    enable = enable
  })
end

function loadAnimDict(dict)
  RequestAnimDict(dict)
  while not HasAnimDictLoaded(dict) do
    Citizen.Wait(1)
  end
end

RegisterCommand('radio', function(source, args)
  ESX.TriggerServerCallback('ls-radio:verificaitem', function(data)
    if data then
      exports['mythic_notify']:SendAlert('error', 'Necessitas de comprar uma radio!')
    else
      enableRadio(true)
    end
  end)
end, false)

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local playerName = GetPlayerName(PlayerId())
  PlayerData = ESX.GetPlayerData()
  if tonumber(data.channel) == nil then
    exports['mythic_notify']:SendAlert('error', Config.messages['you_leave'] .. canalantigo .. '.00 MHz </b>')
    exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
    canalantigo = 0
  elseif tonumber(data.channel) ~= canalantigo then
    if tonumber(data.channel) <= Config.RestrictedChannels then
      if tonumber(data.channel) >= 1 and tonumber(data.channel) <= 2 and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'state' or (PlayerData.job.name == 'municipal' and PlayerData.job.grade > 0) or (PlayerData.job.name == 'ranger' and PlayerData.job.grade > 0) or PlayerData.job.name == 'navy' or PlayerData.job.name == 'test') then
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        if data.channel == 1 or data.channel == "1" then
          exports['mythic_notify']:SendAlert('inform', 'Frequência Central das Forças de Segurança', 2000,
            { ['background-color'] = '#239ED2', ['color'] = '#ffffff' })
          exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        else
          exports['mythic_notify']:SendAlert('inform', 'Frequência Central das Forças de Socorro', 2000,
            { ['background-color'] = '#239ED2', ['color'] = '#ffffff' })
          exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        end
        canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 3 and tonumber(data.channel) <= 9 and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ranger' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'municipal' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 10 and tonumber(data.channel) <= 49 and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 50 and tonumber(data.channel) <= 69 and (PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) == 69 and (PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --   canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) == 70 and (PlayerData.job.name == 'municipal' or PlayerData.job.name == 'police' or PlayerData.job.name == 'ranger' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'state' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --    canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 71 and tonumber(data.channel) <= 74 and (PlayerData.job.name == 'state' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --    canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 75 and tonumber(data.channel) <= 79 and (PlayerData.job.name == 'pj' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --   canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 80 and tonumber(data.channel) <= 89 and (PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 90 and tonumber(data.channel) <= 98 and (PlayerData.job.name == 'reporter' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --    canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) == 99 then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        exports['okokNotify']:Alert("INFO",
          "Atenção nesta rádio só pode estar os respetivos assaltantes e o negociador. Caso Algum Jogador entrar na rádio que não esteja envolvido com a situtação terá as suas consequências!",
          7000, 'info')
        exports['mythic_notify']:SendAlert('inform', 'Frequência Central Assaltos', 2000,
          { ['background-color'] = '#239ED2', ['color'] = '#ffffff' })
      elseif tonumber(data.channel) >= 100 and tonumber(data.channel) <= 109 and (PlayerData.job.name == 'usados' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 110 and tonumber(data.channel) <= 119 and (PlayerData.job.name == 'casino' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 120 and tonumber(data.channel) <= 129 and (PlayerData.job.name == 'tequilla' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 130 and tonumber(data.channel) <= 139 and (PlayerData.job.name == 'mungiki' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 140 and tonumber(data.channel) <= 149 and (PlayerData.job.name == 'ballas' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 150 and tonumber(data.channel) <= 159 and (PlayerData.job.name == 'cartel' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 160 and tonumber(data.channel) <= 169 and (PlayerData.job.name == 'mafia' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 170 and tonumber(data.channel) <= 179 and (PlayerData.job.name == 'grove' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 180 and tonumber(data.channel) <= 189 and (PlayerData.job.name == 'vagos' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 190 and tonumber(data.channel) <= 198 and (PlayerData.job.name == 'coast' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) == 199 and (PlayerData.job.name == 'coast' or PlayerData.job.name == 'municipal' or PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 200 and tonumber(data.channel) <= 209 and (PlayerData.job.name == 'docks' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        --  canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 210 and tonumber(data.channel) <= 219 and (PlayerData.job.name == 'party' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 220 and tonumber(data.channel) <= 229 and (PlayerData.job.name == 'gang' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 230 and tonumber(data.channel) <= 239 and (PlayerData.job.name == 'golf' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 240 and tonumber(data.channel) <= 249 and (PlayerData.job.name == 'black' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 250 and tonumber(data.channel) <= 259 and (PlayerData.job.name == 'mob' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 260 and tonumber(data.channel) <= 269 and (PlayerData.job.name == 'revisao' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) == 270 and (PlayerData.job.name == 'municipal' or PlayerData.job.name == 'police' or PlayerData.job.name == 'ranger' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'state' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 271 and tonumber(data.channel) <= 279 and (PlayerData.job.name == 'municipal' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 280 and tonumber(data.channel) <= 289 and (PlayerData.job.name == 'vigne' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 290 and tonumber(data.channel) <= 299 and (PlayerData.job.name == 'sata' or PlayerData.job.name == 'test' or PPL == true) then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 300 and tonumber(data.channel) <= 309 and (PlayerData.job.name == 'purple' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
      elseif tonumber(data.channel) == 310 then --CANAL DA MARINA
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 311 and tonumber(data.channel) <= 319 and (PlayerData.job.name == 'ranger' or PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'pj' or PlayerData.job.name == 'municipal' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      elseif tonumber(data.channel) >= 320 and tonumber(data.channel) <= 329 and (PlayerData.job.name == 'ammunation' or PlayerData.job.name == 'test') then
        exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
        exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
        -- canalantigo = math.floor(tonumber(data.channel))
      else
        exports['mythic_notify']:SendAlert('error', Config.messages['restricted_channel_error'])
      end
    end
    if tonumber(data.channel) > Config.RestrictedChannels then
      exports["mumble-voip"]:SetRadioChannel(tonumber(data.channel))
      exports['mythic_notify']:SendAlert('inform', Config.messages['joined_to_radio'] .. data.channel .. '.00 MHz </b>')
      -- canalantigo = math.floor(tonumber(data.channel))
    end
  else
    exports['mythic_notify']:SendAlert('error', Config.messages['you_on_radio'] .. data.channel .. '.00 MHz </b>')
  end
  cb('ok')
end)

RegisterNUICallback('leaveRadio', function(data, cb)
  exports["mumble-voip"]:SetRadioChannel(0)
  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
  enableRadio(false)
  SetNuiFocus(false, false)


  cb('ok')
end)

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  ESX.TriggerServerCallback('ls-radio:verificaitem', function(data)
    if data then
      exports['mythic_notify']:SendAlert('error', 'Necessitas de comprar uma radio!')
    else
      enableRadio(true)
    end
  end)
end)





RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function()
  local playerName = GetPlayerName(PlayerId())
  exports["mumble-voip"]:SetRadioChannel(0)

end)

Citizen.CreateThread(function()
  while true do
    if radioMenu then
      DisableControlAction(0, 1, guiEnabled)              -- LookLeftRight
      DisableControlAction(0, 2, guiEnabled)              -- LookUpDown
      DisableControlAction(0, 142, guiEnabled)            -- MeleeAttackAlternate
      DisableControlAction(0, 106, guiEnabled)            -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then       -- MeleeAttackAlternate
        SendNUIMessage({
          type = "click"
        })
      end
    else
      Citizen.Wait(1500)
    end
    Citizen.Wait(10)
  end
end)
