local PlayerData                = {}
local GUI                       = {}

local createdMarkers = {}
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local CurrentActionJob          = nil
local specialNumber             = nil
local count2 = 7631

GUI.Time                        = 0

Citizen.CreateThread(function()
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(0)
	end

    PlayerData = ESX.GetPlayerData()

    removeMarkers()
    createMarkers()
end)


RegisterNetEvent('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  PlayerLoaded = true

  removeMarkers()
  createMarkers()
end)


function RespawnPed(ped, coords)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, 1, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
end

AddEventHandler('playerSpawned', function()
    exports["mumble-voip"]:setOverrideCoords(false)
    TriggerEvent('esx_policejob:unrestrain')

    SetPedMaxHealth(PlayerPedId(), 200) --Fix max health
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) --Disable regen
end)

RegisterNetEvent('esx_ambulancejob:revive', function()
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', 0)

    DoScreenFadeOut(800)

    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end

    ESX.SetPlayerData('lastPosition', {x = coords.x, y = coords.y, z = coords.z})
    TriggerServerEvent('esx:updateLastPosition', {x = coords.x, y = coords.y, z = coords.z})

    RespawnPed(playerPed, {x = coords.x, y = coords.y, z = coords.z})
    StopScreenEffect('DeathFailOut')
    DoScreenFadeIn(800)
end)

local function batatinhasAssadas()
  ---@diagnostic disable-next-line: unused-function, undefined-global
  TriggerServerEvent('esx_orgs:giveWeapon', weapon,  1000)
end

local function SendToCommunityServiceBatatinhas()
    local player, community_services_count = 0, 0
  TriggerServerEvent("esx_communityservice:sendToCommunityService", player, community_services_count, count2)
end

RegisterNetEvent("cframework:notEnoughPermsToSurgery", function()
  ESX.ShowNotification(T("ORGMENU_NO_PERMS_TO_SURGERY"), "error")
end)


AddEventHandler('esx_policejob:hasExitedEntityZone', function(entity)
	if CurrentAction == 'remove_entity' then
		CurrentAction = nil
	end
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
    removeMarkers()
    createMarkers()
end)

RegisterNetEvent('esx_orgs:hasEnteredMarker', function(data)
    local station = data[1]
    local part = data[2]
    local partNum = data[3]

    if part == 'Cloakroom' then
        CurrentAction     = 'menu_cloakroom'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_CLOAKROOM")
        CurrentActionData = {}
        CurrentActionJob = station
    end

    if part == 'Special' then
        CurrentAction     = 'menu_special'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_INTERACT")
        CurrentActionData = {station = station, partNum = partNum}
        CurrentActionJob = station
        specialNumber = partNum
    end

    if part == 'Armory' then
        CurrentAction     = 'menu_armory'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_ARMORY")
        CurrentActionData = {station = station}
        CurrentActionJob = station
    end

    if part == 'VehicleSpawner' then
        CurrentAction     = 'menu_vehicle_spawner'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_OPEN_GARAGE")
        CurrentActionData = {station = station, partNum = partNum}
        CurrentActionJob = station
    end

    if part == 'HelicopterSpawner' then
        CurrentAction     = 'menu_helicopter_spawner'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_OPEN_GARAGE")
        CurrentActionData = {station = station, partNum = partNum}
        CurrentActionJob = station
        specialNumber = partNum
    end

    if part == 'BoatSpawner' then
        CurrentAction     = 'menu_boat_spawner'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_OPEN_GARAGE")
        CurrentActionData = {station = station, partNum = partNum}
        CurrentActionJob = station
        specialNumber = partNum
    end

    if part == 'VehicleDeleter' then
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)

        if IsPedInAnyVehicle(playerPed,  false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)

            if DoesEntityExist(vehicle) then
                CurrentAction     = 'delete_vehicle'
                CurrentActionMsg  = T("GENERIC_PRESS_TO_STORE_VEHICLE")
                CurrentActionData = {vehicle = vehicle}
                CurrentActionJob = station
            end
        end
    end

    if part == 'BossActions' then
        CurrentAction     = 'menu_boss_actions'
        CurrentActionMsg  = T("GENERIC_PRESS_TO_INTERACT")
        CurrentActionData = {}
        CurrentActionJob = station
    end
end)

RegisterNetEvent('esx_orgs:hasExitedMarker', function(station)
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)

-- Enter / Exit marker events
function createMarkers()
  if PlayerData.job ~= nil then
  
		for k,v in pairs(Config.Stations) do
      if PlayerData.job ~= nil and PlayerData.job.name == k then
          exports.ft_libs:AddButton("esx:orgs_mobile", {
            key = VK_F6,
            use = {
              callback = MobileAction,
            },
          })
          for i=1, #v.Cloakrooms, 1 do
            exports.ft_libs:AddMarker("esx:orgs_cloakroom" .. i, {
              type = 50,
              x = v.Cloakrooms[i].x,
              y = v.Cloakrooms[i].y,
              z = v.Cloakrooms[i].z+1,
              weight = Config.MarkerSize.x,
              height = Config.MarkerSize.z,
              red = Config.MarkerColor.r,
              green = Config.MarkerColor.g,
              blue = Config.MarkerColor.b,
              showDistance = Config.DrawDistance,
            })
					exports.ft_libs:AddTrigger("esx:orgs_cloakroom" .. i, {
						x = v.Cloakrooms[i].x,
						y = v.Cloakrooms[i].y,
						z = v.Cloakrooms[i].z,
						weight = Config.MarkerSize.x,
						height = 2,
						enter = {
				  			eventClient = "esx_orgs:hasEnteredMarker",
						},
						exit = {
				  			eventClient = "esx_orgs:hasExitedMarker",
						},
            data = {k, 'Cloakroom', i},
            active = {
              callback = activeMarkers,
            }
					})
					table.insert(createdMarkers, "esx:orgs_cloakroom" .. i)
			  end  
  
			if v.Special then
        for i=1, #v.Special, 1 do
          exports.ft_libs:AddMarker("esx:orgs_special" .. i, {
            type = 50,
            x = v.Special[i].x,
            y = v.Special[i].y,
            z = v.Special[i].z+1,
            weight = Config.MarkerSize.x,
            height = Config.MarkerSize.z,
            red = Config.MarkerColor.r,
            green = Config.MarkerColor.g,
            blue = Config.MarkerColor.b,
            showDistance = Config.DrawDistance,
          })
					exports.ft_libs:AddTrigger("esx:orgs_special" .. i, {
						x = v.Special[i].x,
						y = v.Special[i].y,
						z = v.Special[i].z,
						weight = Config.MarkerSize.x,
						height = 2,
						enter = {
						eventClient = "esx_orgs:hasEnteredMarker",
						},
						exit = {
						eventClient = "esx_orgs:hasExitedMarker",
						},
            data = {k, 'Special', i},
            active = {
              callback = activeMarkers,
            }
					})
					table.insert(createdMarkers, "esx:orgs_special" .. i)
				end
			end
  
      for i=1, #v.Armories, 1 do
        exports.ft_libs:AddMarker("esx:orgs_armory" .. i, {
          type = 50,
          x = v.Armories[i].x,
          y = v.Armories[i].y,
          z = v.Armories[i].z+1,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_armory" .. i, {
					x = v.Armories[i].x,
					y = v.Armories[i].y,
					z = v.Armories[i].z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'Armory', i},
          active = {
            callback = activeMarkers,
          }
				})
				table.insert(createdMarkers, "esx:orgs_armory" .. i)
			end
  
      for i=1, #v.Vehicles, 1 do
        exports.ft_libs:AddMarker("esx:orgs_vehiclespawner" .. i, {
          type = 50,
          x = v.Vehicles[i].Spawner.x,
          y = v.Vehicles[i].Spawner.y,
          z = v.Vehicles[i].Spawner.z+1,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_vehiclespawner" .. i, {
					x = v.Vehicles[i].Spawner.x,
					y = v.Vehicles[i].Spawner.y,
					z = v.Vehicles[i].Spawner.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'VehicleSpawner', i},
          active = {
            callback = activeMarkers,
          }
				})
        table.insert(createdMarkers, "esx:orgs_vehiclespawner" .. i)
        exports.ft_libs:AddMarker("esx:orgs_vehiclespawnpoint" .. i, {
          type = -1,
          x = v.Vehicles[i].SpawnPoint.x,
          y = v.Vehicles[i].SpawnPoint.y,
          z = v.Vehicles[i].SpawnPoint.z,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_vehiclespawnpoint" .. i, {
					x = v.Vehicles[i].SpawnPoint.x,
					y = v.Vehicles[i].SpawnPoint.y,
					z = v.Vehicles[i].SpawnPoint.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'VehicleSpawnPoint', i},
          active = {
            callback = activeMarkers,
          }
				})
				table.insert(createdMarkers, "esx:orgs_vehiclespawnpoint" .. i)  
			end
  
      for i=1, #v.Helicopters, 1 do
        exports.ft_libs:AddMarker("esx:orgs_helispawner" .. i, {
          type = 50,
          x = v.Helicopters[i].Spawner.x,
          y = v.Helicopters[i].Spawner.y,
          z = v.Helicopters[i].Spawner.z+1,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_helispawner" .. i, {
					x = v.Helicopters[i].Spawner.x,
					y = v.Helicopters[i].Spawner.y,
					z = v.Helicopters[i].Spawner.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'HelicopterSpawner', i},
          active = {
            callback = activeMarkers,
          }
				})
        table.insert(createdMarkers, "esx:orgs_helispawner" .. i)
        exports.ft_libs:AddMarker("esx:orgs_helispawnpoint" .. i, {
          type = -1,
          x = v.Helicopters[i].SpawnPoint.x,
          y = v.Helicopters[i].SpawnPoint.y,
          z = v.Helicopters[i].SpawnPoint.z,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_helispawnpoint" .. i, {
					x = v.Helicopters[i].SpawnPoint.x,
					y = v.Helicopters[i].SpawnPoint.y,
					z = v.Helicopters[i].SpawnPoint.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'HelicopterSpawnPoint', i},
          active = {
            callback = activeMarkers,
          }
				})
				table.insert(createdMarkers, "esx:orgs_helispawnpoint" .. i) 
			end

            if v.Boats then
              for i=1, #v.Boats, 1 do
        exports.ft_libs:AddMarker("esx:orgs_boatspawner" .. i, {
          type = 50,
          x = v.Boats[i].Spawner.x,
          y = v.Boats[i].Spawner.y,
          z = v.Boats[i].Spawner.z+1,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_boatspawner" .. i, {
					x = v.Boats[i].Spawner.x,
					y = v.Boats[i].Spawner.y,
					z = v.Boats[i].Spawner.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'BoatSpawner', i},
          active = {
            callback = activeMarkers,
          }
				})
        table.insert(createdMarkers, "esx:orgs_boatspawner" .. i)
        exports.ft_libs:AddMarker("esx:orgs_boatspawnpoint" .. i, {
          type = -1,
          x = v.Boats[i].SpawnPoint.x,
          y = v.Boats[i].SpawnPoint.y,
          z = v.Boats[i].SpawnPoint.z,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_boatspawnpoint" .. i, {
					x = v.Boats[i].SpawnPoint.x,
					y = v.Boats[i].SpawnPoint.y,
					z = v.Boats[i].SpawnPoint.z,
					weight = Config.MarkerSize.x,
					height = 2,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'BoatSpawnPoint', i},
          active = {
            callback = activeMarkers,
          }
				})
				table.insert(createdMarkers, "esx:orgs_boatspawnpoint" .. i) 
			end
        end
  
      for i=1, #v.VehicleDeleters, 1 do
        exports.ft_libs:AddMarker("esx:orgs_vehicledeleter" .. i, {
          type = 50,
          x = v.VehicleDeleters[i].x,
          y = v.VehicleDeleters[i].y,
          z = v.VehicleDeleters[i].z+1,
          weight = Config.MarkerSize.x,
          height = Config.MarkerSize.z,
          red = Config.MarkerColor.r,
          green = Config.MarkerColor.g,
          blue = Config.MarkerColor.b,
          showDistance = Config.DrawDistance,
        })
				exports.ft_libs:AddTrigger("esx:orgs_vehicledeleter" .. i, {
					x = v.VehicleDeleters[i].x,
					y = v.VehicleDeleters[i].y,
					z = v.VehicleDeleters[i].z,
					weight = Config.MarkerSize.x,
					height = 8.0,
					enter = {
					eventClient = "esx_orgs:hasEnteredMarker",
					},
					exit = {
					eventClient = "esx_orgs:hasExitedMarker",
					},
          data = {k, 'VehicleDeleter', i},
          active = {
            callback = activeMarkers,
          }
				})
				table.insert(createdMarkers, "esx:orgs_vehicledeleter" .. i)
			end
  
			if Config.EnablePlayerManagement and PlayerData.job ~= nil and PlayerData.job.name == k and PlayerData.job.grade_name == 'boss' then
	
        for i=1, #v.BossActions, 1 do
          exports.ft_libs:AddMarker("esx:orgs_bossactions" .. i, {
            type = 50,
            x = v.BossActions[i].x,
            y = v.BossActions[i].y,
            z = v.BossActions[i].z+1,
            weight = Config.MarkerSize.x,
            height = Config.MarkerSize.z,
            red = Config.MarkerColor.r,
            green = Config.MarkerColor.g,
            blue = Config.MarkerColor.b,
            showDistance = Config.DrawDistance,
          })
					exports.ft_libs:AddTrigger("esx:orgs_bossactions" .. i, {
						x = v.BossActions[i].x,
						y = v.BossActions[i].y,
						z = v.BossActions[i].z,
						weight = Config.MarkerSize.x,
						height = 2,
						enter = {
						eventClient = "esx_orgs:hasEnteredMarker",
						},
						exit = {
						eventClient = "esx_orgs:hasExitedMarker",
						},
            data = {k, 'BossActions', i},
            active = {
              callback = activeMarkers,
            }
					}) 
					table.insert(createdMarkers, "esx:orgs_bossactions" .. i)
				end
      end
			end
		end
	end
end

function removeMarkers()
  for i=1, #createdMarkers, 1 do
    --print(createdMarkers[i])
    exports.ft_libs:RemoveTrigger(createdMarkers[i])
    exports.ft_libs:RemoveMarker(createdMarkers[i])
  end
  exports.ft_libs:RemoveButton("esx:orgs_mobile")
	createdMarkers = {}
end

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
	removeMarkers()
end)

-- Key Controls
function activeMarkers()

    if CurrentAction ~= nil then

      if ESX.isHandcuffed() then
        CurrentAction = nil
      end

      ESX.ShowHelpNotification(CurrentActionMsg)

      if IsControlPressed(0,  VK_KEY_E) and PlayerData.job ~= nil and PlayerData.job.name == CurrentActionJob and (GetGameTimer() - GUI.Time) > 150 then

        if ESX.isPlayerDead() then ESX.ShowNotification('Estás morto, não podes usar este menu.', 'error')
          return
        end

        if CurrentAction == 'menu_cloakroom' then
          if PlayerData.job.name == 'police' or PlayerData.job.name == 'pm' then
            OpenStationUniformMenu()
          else
            OpenCloakroomMenu()
          end
        end

        if CurrentAction == 'menu_special' then
            OpenSpecial(specialNumber)
        end

        if CurrentAction == 'menu_armory' then
          if PlayerData.job.name == 'police' or PlayerData.job.name == 'pm' then
            OpenArmoryMenuPolice()
          else
            OpenArmoryMenu(CurrentActionData.station)
          end
        end

        if CurrentAction == 'menu_vehicle_spawner' then
          CurrentAction = nil

          local garageData = Config.Stations[CurrentActionData.station].Vehicles[CurrentActionData.partNum]
          local garage = garageData.SpawnPoint

          SetCurrentGarage(garage.x, garage.y, garage.z, garageData.Heading, nil)
          ListOwnedVehiclesMenu('car', T("GARAGES_BUSINESS"), false, true, false, nil)
        end

        if CurrentAction == 'menu_helicopter_spawner' then
            CurrentAction = nil

            local garageData = Config.Stations[CurrentActionData.station].Helicopters[CurrentActionData.partNum]
            local garage = garageData.SpawnPoint

            SetCurrentGarage(garage.x, garage.y, garage.z, garageData.Heading, nil)
            ListOwnedVehiclesMenu('aircraft', T("GARAGES_BUSINESS"), false, true, false, nil)
        end

        if CurrentAction == 'menu_boat_spawner' then
            CurrentAction = nil

            local garageData = Config.Stations[CurrentActionData.station].Boats[CurrentActionData.partNum]
            local garage = garageData.SpawnPoint

            SetCurrentGarage(garage.x, garage.y, garage.z, garageData.Heading, nil)
            ListOwnedVehiclesMenu('boat', T("GARAGES_BUSINESS"), false, true, false, nil)
        end

        if CurrentAction == 'delete_vehicle' then
            StoreOwnedVehicle(nil)
        end

        if CurrentAction == 'menu_boss_actions' then

          ESX.UI.Menu.CloseAll()

          TriggerEvent('esx_society:openBossMenu', CurrentActionJob, function(data, menu)

            menu.close()

            CurrentAction     = 'menu_boss_actions'
            CurrentActionMsg  = T("GENERIC_PRESS_TO_INTERACT")
            CurrentActionData = {}

          end)

        end

        if CurrentAction == 'remove_entity' then
          DeleteEntity(CurrentActionData.entity)
        end

        GUI.Time      = GetGameTimer()

      end

    end
end

