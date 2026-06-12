
local entityEnumerator = {
	__gc = function(enum)
	  if enum.destructor and enum.handle then
		enum.destructor(enum.handle)
	  end
	  enum.destructor = nil
	  enum.handle = nil
	end
  }
  
  local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
	  local iter, id = initFunc()
	  if not id or id == 0 then
		disposeFunc(iter)
		return
	  end
	  
	  local enum = {handle = iter, destructor = disposeFunc}
	  setmetatable(enum, entityEnumerator)
	  
	  local next = true
	  repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
	  until not next
	  
	  enum.destructor, enum.handle = nil, nil
	  disposeFunc(iter)
	end)
  end
  
  function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
  end
  
  function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
  end
  
  function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
  end
  
  function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
  end
  
  RegisterNetEvent("wld:delallveh")
  AddEventHandler("wld:delallveh", function ()
	  for vehicle in EnumerateVehicles() do
		  if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
			  SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
			  SetEntityAsMissionEntity(vehicle, false, false) 
			  DeleteVehicle(vehicle)
			  if (DoesEntityExist(vehicle)) then 
				  DeleteVehicle(vehicle) 
			  end
		  end
	  end
  end)

local MeeleWeapons = {
	[GetHashKey("WEAPON_UNARMED")] = 0.28,
	[GetHashKey("WEAPON_KNIFE")] = 0.5,
	[GetHashKey("WEAPON_NIGHTSTICK")] = 0.15,
	[GetHashKey("WEAPON_BOTTLE")] = 0.30,
	[GetHashKey("WEAPON_BAT")] = 0.50,
	[GetHashKey("WEAPON_KNUCKLE")] = 0.20,
	[GetHashKey("WEAPON_MACHETE")] = 0.70,
	[GetHashKey("WEAPON_SWITCHBLADE")] = 0.50,
	[GetHashKey("WEAPON_POOLCUE")] = 0.50,
	[GetHashKey("WEAPON_POOLCUE")] = 0.50,
}

local trustedResources = {
	['carcontrol'] = true,
	['chat'] = true,
	['chud'] = true,
	['dpclothing'] = true,
	['dpemotes'] = true,
	['el_bwh'] = true,
	['esx_dmvschool'] = true,
	['esx_jb_dj'] = true,
	['esx_lscustom'] = true,
	['esx_vehicleshop'] = true,
	['ft_libs'] = true,
	['gadmin'] = true,
	['gcasino'] = true,
	['gcphone'] = true,
	['cframework'] = true,
	['chud'] = true,
	['grobbery'] = true,
	['jsfour-register'] = true,
	['mdt'] = true,
	['mumble-voip'] = true,
	['mysql-async'] = true,
	['new_banking'] = true,
	['packcarros'] = true,
	['packmapas'] = true,
	['qb-storerobbery'] = true,
	['rpscripts'] = true,
	['pun_idgun'] = true,
	['screenshot-basic'] = true,
}

AddEventHandler('onClientResourceStart', function (resourceName)
	if trustedResources[resourceName] then
		return
	end
end)

AddEventHandler('onClientResourceStop', function (resourceName)
	TriggerServerEvent('3dme:showDisplay')
end)
