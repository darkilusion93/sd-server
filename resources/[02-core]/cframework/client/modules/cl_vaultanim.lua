


function OpenCloseVault(vaultProp, open)
    local sParam1, sParam2 = "safe_close", "safe_close_safedoor"

    if open then
        sParam1, sParam2 = "safe_open", "safe_open_safedoor"
    end

    if not NetworkHasControlOfEntity(vaultProp) then NetworkRequestControlOfEntity(vaultProp) end

	if not DoesEntityExist(vaultProp) then return false end
	if not DoesEntityHaveDrawable(vaultProp) then return false end

	if IsPedDeadOrDying(GetPlayerPed(PlayerId()), true) then return false end

	local anims = "anim_heist@arcade_property@arcade_safe_open@male@"

	if GetEntityModel(GetPlayerPed(PlayerId())) == GetHashKey("mp_f_freemode_01") then anims = "anim_heist@arcade_property@arcade_safe_open@female@" end

	local s_coord = GetEntityCoords(vaultProp) - vector3(-1.206, 6.153, 2.369)
	local s_rot = vector3(0.0, 0.0, 0.0)

	--local initPos = GetAnimInitialOffsetPosition(anims, sParam1, s_coord, s_rot, 0.01, 2)
	--local initRot = GetAnimInitialOffsetRotation(anims, sParam1, s_coord, s_rot, 0.01, 2)

	--TaskGoStraightToCoord(PlayerPedId(), initPos, 1.0, 5000, initRot.z, 0.01)
	--repeat Wait(0) until GetScriptTaskStatus(PlayerPedId(), 2106541073) == 7
	--Wait(50)

	RequestAnimDict(anims)
    while not HasAnimDictLoaded(anims) do Citizen.Wait(0) end

	local scene = NetworkCreateSynchronisedScene(s_coord.x, s_coord.y, s_coord.z, s_rot.x, s_rot.y, s_rot.z, 2, false, false, 1065353216, 0, 1065353216)
	NetworkAddPedToSynchronisedScene(GetPlayerPed(PlayerId()), scene, anims, sParam1, 1.5, -1.5, 13, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(vaultProp, scene, anims, sParam2, 1.5, -1.5, 13)
	NetworkStartSynchronisedScene(scene)

	Citizen.Wait(5000)

	return true
end
