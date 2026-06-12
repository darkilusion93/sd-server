UserSkin    = {}

RegisterNetEvent('esx:getVipSkin')
AddEventHandler('esx:getVipSkin', function(skins)
	--print('recebeu as skins')
	UserSkin = skins
end)
--[[
Citizen.CreateThread(function()
	Citizen.Wait(20000)
	
	TriggerServerEvent('esx:getVipSkin')
	while true do
        local ped = PlayerPedId()
        local currentWeaponHash = GetSelectedPedWeapon(ped)
			if currentWeaponHash == GetHashKey("WEAPON_PISTOL") and UserSkin['weapon_pistol'] == 1 then
		  		 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE"))
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
		  	--	 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE"))  
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_APPISTOL") then
		  	--	 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE"))
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
		  	--	 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE"))
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
		  	--	 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_SMG_VARMOD_LUXE"))
		  	elseif currentWeaponHash == GetHashKey("WEAPON_MICROSMG") and UserSkin['weapon_microsmg'] == 1 then
		  		 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_MICROSMG"), GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE"))
		  	elseif currentWeaponHash == GetHashKey("WEAPON_ASSAULTRIFLE") and UserSkin['weapon_assaultrifle'] == 1 then
		  		 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ASSAULTRIFLE"), GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE"))  
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
		  	--	 GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE"))
		  	--elseif currentWeaponHash == GetHashKey("WEAPON_ADVANCEDRIFLE") then
            --       GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_ADVANCEDRIFLE"), GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE"))
            elseif currentWeaponHash == GetHashKey("WEAPON_SWITCHBLADE") and UserSkin['weapon_switchblade'] == 1 then
                GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey("WEAPON_SWITCHBLADE"), GetHashKey("COMPONENT_SWITCHBLADE_VARMOD_VAR2"))
			end
		Citizen.Wait(1000)
    end
end)]]

RegisterNetEvent('esx:setplayerped')
AddEventHandler('esx:setplayerped', function(skin)
    Citizen.CreateThread(function()
        local model = GetHashKey(skin)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedComponentVariation(GetPlayerPed(-1), 0, 0, 0, 2)
    end)
end)

