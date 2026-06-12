local IsAnimated = false

AddEventHandler('esx_basicneeds:isEating', function(cb)
	cb(IsAnimated)
end)

RegisterNetEvent('esx_basicneeds:onEat', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_burger_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatChocolate', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_choc_ego'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.035, 0.009, -30.0, -240.0, -120.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatCupCake', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'ng_proc_food_ornge1a'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.045, 0.06, 45.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatChips', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'v_ret_ml_chips4'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onEatSandwich', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_sandwich_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.03, -240.0, -180.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
				TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrink', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_flow_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.028, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkCocaCola', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ecola_can' --ng_proc_sodacan_01a
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkIceTea', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_ld_can_01' --ng_proc_sodacan_01b
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkCoffe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_fib_coffee'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.01, -0.03, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Bar drinks
RegisterNetEvent('esx_basicneeds:onDrinkBeer', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_amb_beer_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkWine', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_bot_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkVodka', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_vodka_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkWhisky')
AddEventHandler('esx_basicneeds:onDrinkWhisky', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_whiskey_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.2, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkTequila')
AddEventHandler('esx_basicneeds:onDrinkTequila', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_tequila_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkMilk')
AddEventHandler('esx_basicneeds:onDrinkMilk', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_cs_milk_01'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 18905)
			AttachEntityToEntity(prop, playerPed, boneIndex, -0.009, -0.03, -0.1, -90.0, 270.0, -90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
				TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Disco
RegisterNetEvent('esx_basicneeds:onDrinkGin')
AddEventHandler('esx_basicneeds:onDrinkGin', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_rum_bottle'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkAbsinthe')
AddEventHandler('esx_basicneeds:onDrinkAbsinthe', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_bottle_cognac'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'mamb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

RegisterNetEvent('esx_basicneeds:onDrinkChampagne')
AddEventHandler('esx_basicneeds:onDrinkChampagne', function(prop_name)
	if not IsAnimated then
		prop_name = prop_name or 'prop_wine_white'
		IsAnimated = true

		Citizen.CreateThread(function()
			local playerPed = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(playerPed))
			local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
			local boneIndex = GetPedBoneIndex(playerPed, 28422)
			AttachEntityToEntity(prop, playerPed, boneIndex, 0.008, -0.02, -0.3, 90.0, 270.0, 90.0, true, true, false, true, 1, true)

			ESX.Streaming.RequestAnimDict('amb@code_human_wander_drinking@beer@male@base', function()
				TaskPlayAnim(playerPed, 'amb@code_human_wander_drinking@beer@male@base', 'static', 1.0, -1.0, 2000, 0, 1, true, true, true)

				Citizen.Wait(3000)
				IsAnimated = false
				ClearPedSecondaryTask(playerPed)
				DeleteObject(prop)
			end)
		end)

	end
end)

-- Cigarett 
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)



RegisterNetEvent('useCondom', function()
	local players = ESX.Game.GetPlayersInArea(GetEntityCoords(GetPlayerPed(-1)), 50)
	local serverSources = {}

	for _, playerId in ipairs(players) do
		serverSources[GetPlayerServerId(playerId)] = true
	end

	local args = {}

	args[1] = T("GENERIC_PUT_CONDOM")
	args[2] = T("GENERIC_CONDOM")

	TriggerServerEvent('3dme:shareDisplay', args, serverSources)
end)

RegisterNetEvent('startSmoke', function()
	SmokeAnimation("WORLD_HUMAN_SMOKING")
end)

RegisterNetEvent('startEnrolar', function()
	SmokeAnimation("PROP_HUMAN_PARKING_METER")
	Citizen.Wait(2500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('startSmokeWeed', function()
	SmokeAnimation("WORLD_HUMAN_SMOKING_POT")
end)

RegisterNetEvent('startSmokeCigar', function()
	TriggerEvent('playEmote', {"amb@world_human_smoking@male@male_a@enter", "enter", "Charuto", AnimationOptions =
	{
		Prop = 'prop_cigar_02',
		PropBone = 47419,
		PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
		EmoteMoving = true,
		EmoteDuration = 2600
	}})
end)

--[[
["charuto2"] = {"amb@world_human_smoking@male@male_a@enter", "enter", "Charuto 2", AnimationOptions =
{
	Prop = 'prop_cigar_01',
	PropBone = 47419,
	PropPlacement = {0.010, 0.0, 0.0, 50.0, 0.0, -80.0},
	EmoteMoving = true,
	EmoteDuration = 2600
}},]]

function SmokeAnimation(anim)
	local playerPed = GetPlayerPed(-1)
	Citizen.CreateThread(function()
        TaskStartScenarioInPlace(playerPed, anim, 0, true)               
	end)
end



 RegisterNetEvent('esx_optionalneeds:onDrink')
AddEventHandler('esx_optionalneeds:onDrink', function()
  
  local playerPed = GetPlayerPed(-1)
  
  TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRINKING", 0, 1)
  Citizen.Wait(1000)
  ClearPedTasksImmediately(playerPed)
 end) 

 
--Adrenalin
RegisterNetEvent("esx_optionalneeds:onAdrenaline")
AddEventHandler("esx_optionalneeds:onAdrenaline", function()

    local lib, anim = 'mp_player_intdrink', 'loop_bottle'  -- usage animation (I fucked this up and don't bother to add working animation)
    local playerPed = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(playerPed))
    local prop_name = 'prop_cs_pills'
    local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetPedBoneIndex(playerPed, 18905)
    AttachEntityToEntity(prop, playerPed, boneIndex, 0.15, 0.01, 0.025, -90.0, 00.0, 0.0, true, true, false, true, 1, true)
    

    ESX.ShowNotification(T("GENERIC_USED_ADRELANINE"), "inform") -- usage notification // English: "Everything is crystal clear now."
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, 8.0, -1, 0, 0, false, false, false)
        Citizen.Wait(500)
        while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
            Citizen.Wait(0)
            DisableAllControlActions(0)
        end
        DeleteObject(prop)
        TriggerEvent('esx_optionalneeds:adrenaline') -- below effect
    end)
end)

-------------EFEKTLER---------------
local hizliKos = false -- hızlı koşma var // this is for fast run
local yavasKos = false -- yavaş koşma var // this is for slow run

--Agresif ve Sınırsız Stamina
RegisterNetEvent("esx_optionalneeds:adrenaline")
AddEventHandler("esx_optionalneeds:adrenaline", function()
    local count = 0

    SetPedMotionBlur(GetPlayerPed(-1), true) -- Adds very little blur effect
    --DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetTimecycleModifier("underwater_deep")  -- Display filter to make it funnier and realistic
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.15)   -- This ratio is for sprinting speed not movement speed so it will only effective when your character sprints, max is 1.49 / aboe 1.49 won't effect speed
	hizliKos = true  -- activites fast movement (not sprinting speed but overall speed)
	Citizen.CreateThread(function()           -- yavaş koşma için call // check if slow run activated
		while hizliKos do
			  Citizen.Wait(16)
			SetPedMoveRateOverride(PlayerPedId(), 1.050) -- you can edit this ratio : values above 1.0 make charater move faster / values belowe 1.0 make charater slower / 1.0 is default speed - This makes characters movement faster, which means even your walking speed
		end
	end)

    DoScreenFadeIn(1000)
	repeat  -- Start of the cycle
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)   -- Shaking cam effect
    RestorePlayerStamina(PlayerId(), 1.0)   -- This is for resetting stamina
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    Citizen.Wait(2000)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    Citizen.Wait(2000)
		count = count  + 1
	until count == 2  -- One cycle takes 10 seconds, if you put 15 in this value adrenaline effect will take 150 seconds
    hizliKos = false  -- deactivates speed
    --DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier() -- clears display filter
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0) -- sets sprint speed to defualt
    SetPedMotionBlur(GetPlayerPed(-1), false) -- removes blur
    count = 0  -- sets cylce count to 0 for next usage
    --ESX.ShowNotification('Yavaşlıyorsun ve yorgun düşüyorsun...') -- sends notification when effect is over // English : "You are exhausted, slowing down..."
    yavasKos = true  -- sets speed to very slow to animiate exhausting effect
    Citizen.Wait(10000)  -- this values determines how long the exhausting effect // value is in miliseconds
    yavasKos = false -- removes slow speed
    --ESX.ShowNotification('Tekrar eski haline döndün.') -- show notification that you are now feeling okay // English : "You are feeling okay."
end)

local syringeProp = "prop_syringe_01"
local syringeDict = "missfbi3_syringe"
local syringeAnim = "syringe_use_player"
local syringeBone = 28422
local syringeOffset = vector3(0, 0, 0)
local syringeRot = vector3(0, 0, 0)

RegisterNetEvent('esx_optionalneeds:syringetrigger')
AddEventHandler('esx_optionalneeds:syringetrigger', function(playerheading, playercoords, playerlocation)

    local target, distance = ESX.Game.GetClosestPlayer()

    if distance ~= -1 and distance <= 4.0 then

        playerheading = GetEntityHeading(GetPlayerPed(-1))
        playerlocation = GetEntityForwardVector(PlayerPedId())
        playerCoords = GetEntityCoords(GetPlayerPed(-1))
        local target_id = GetPlayerServerId(target)
        
		TriggerServerEvent('esx_optionalneeds:syringe', target_id, playerheading, playerCoords, playerlocation)

        RequestAnimDict(syringeDict)

        while not HasAnimDictLoaded(syringeDict) do
            Citizen.Wait(10)
        end

        RequestModel(syringeProp)

        while not HasModelLoaded(syringeProp) do
            Citizen.Wait(10)
        end

        local playerPed = PlayerPedId()
    
        local syringeObj = CreateObject(syringeProp, 0.0, 0.0, 0.0, true, true, false)
        local syringeBoneIndex = GetPedBoneIndex(playerPed, syringeBone)

        SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
        AttachEntityToEntity(syringeObj, playerPed, syringeBoneIndex, syringeOffset.x, syringeOffset.y, syringeOffset.z, syringeRot.x, syringeRot.y, syringeRot.z, false, false, false, false, 2, true)
        SetModelAsNoLongerNeeded(syringeProp)

        TaskPlayAnim(playerPed, syringeDict, syringeAnim, 8.0, -8.0, -1, 1, 0, 0, 0, 0)

        RemoveAnimDict(syringeDict)
        Citizen.Wait(1500)
        ClearPedTasks(playerPed)
        DeleteObject(syringeObj)
    end
end)

RegisterNetEvent('esx_optionalneeds:syringe')
AddEventHandler('esx_optionalneeds:syringe', function(playerheading, playercoords, playerlocation)
	playerPed = GetPlayerPed(-1)
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)

    Citizen.Wait(1200)
    local inconsciente = true

    DoScreenFadeOut(250)

    Citizen.Wait(250)

    DoScreenFadeIn(100)
    Citizen.Wait(250)

    Citizen.CreateThread(function()
        DoScreenFadeOut(250)
        while inconsciente do
            Citizen.Wait(0)
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, true, true, false)
        end
        DoScreenFadeIn(1000)
    end)

    Citizen.Wait(20000)
    inconsciente = false
end)

RegisterNetEvent('cframework:gumsEffect', function()
	TriggerEvent("fx:run", "lsd", 60, 0.0, true, false)
end)

RegisterNetEvent('cframework:candyEffect', function()
	TriggerEvent("fx:run", "lsd", 60, 0.0, true, false)
end)