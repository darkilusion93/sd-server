local pfx = nil
local pfx2 = nil
local pfx3 = nil
local pfx4 = nil

local PlacePressureGun = '[~r~E~w~] Pousar pistola de água'
local PickupPressureGun = '[~g~E~w~] Usar pistola de água'
local WasherModel = `prop_compressor_02`
local HoseAttachOffset = vector3(0.25, 0.05, 0.96)

local RopeLength = 1.2
local RopeMaxLength = 17.0

--x,y,z,rx,ry,rz
local washerLocations = {
    {-2.34,-1396.54,28.26,0.0,0.0,-88.02},
    {164.03,-1717.45,28.29,0.0,0.0,48.0},
    {-70.16,6424.78,30.44,0.0,0.0,227.0},
    {-699.60,-917.1,18.21,0.0,0.0,0.0},
    {1360.77,3595.62,33.91,0.0,0.0,18},
    {846.61,-2109.33,29.58,0.0,0.0,89.20},
}

local State = 'Detached'
local RopeID = 0
local RopeType = 1
local MinLength = 0.5
local MaxLength = 1000.0
local InitLength = 3.5
local IsTargetCurrentPlayer = false

--// Token: 0x0400000B RID: 11
--public uint model = (uint)API.GetHashKey("bkr_prop_weed_plantpot_stack_01c");

local DummyProp = nil
local DummyProp2 = nil
local ConstantReachHeight = 225.0
local MaxLengthBeforeBreak = 1000.0
local ExplodeOnBreak = false
local Position = nil

local isUsingPump = false
local IsWaterPump = true

local PlayerPumps = {}
local propWasherLocations = {}
local PlayerParticles = {}
local PlayerParticleType = {}

local SoapGunHash = `WEAPON_PRESSURE1`

local targetedEntity = nil

Citizen.CreateThread(function()
    RequestNamedPtfxAsset("scr_carwash")
    while not HasNamedPtfxAssetLoaded("scr_carwash") do
         Citizen.Wait(1)
    end
end)

AddEventHandler('pwasher:playWaterParticle', function(entity)
    --print("Play Particle")
	Citizen.CreateThread(function()
		UseParticleFxAssetNextCall("scr_carwash")
		pfx = StartParticleFxLoopedOnEntity('ent_amb_car_wash_jet_soap', entity, 0.5, 0.0, 0.0, 90.0, 0.0, -90.0, 1.0, true, true, true)
		pfx2 = StartParticleFxLoopedOnEntity('ent_amb_car_wash_jet', entity, 0.5, 0.0, 0.0, 90.0, 0.0, -90.0, 1.0, true, true, true)
		pfx3 = StartParticleFxLoopedOnEntity('ent_amb_car_wash', entity, 0.5, 0.0, 0.0, 90.0, 0.0, -90.0, 1.0, true, true, true)
		pfx4 = StartParticleFxLoopedOnEntity('ent_amb_car_wash_steam', entity, 0.5, 0.0, 0.0, 90.0, 0.0, -90.0, 1.0, true, true, true)
    end)
end)

AddEventHandler('pwasher:stopWaterParticle', function()
    --print("Stop Particle")
	StopParticleFxLooped(pfx, 0)
	StopParticleFxLooped(pfx2, 0)
	StopParticleFxLooped(pfx3, 0)
	StopParticleFxLooped(pfx4, 0)
end)

AddEventHandler("np:target:changed", function(pEntity, pEntityType)
	if pEntityType == 2 then
    	targetedEntity = pEntity
	else
		targetedEntity = nil
	end
end)

--cable
function CreateRope(position, washerEntity) --ACable
    Position = position

	if isUsingPump then return end

	isUsingPump = true

    GiveWeaponToPed(PlayerPedId(), SoapGunHash, 1, false, true)

	if not RopeAreTexturesLoaded() then
        RopeLoadTextures()
    end

	if RopeID ~= 0 then
    	DeleteRope(RopeID)
	end

    RopeID = AddRope(Position.x, Position.y, Position.z, 0.0, 0.0, 0.0, RopeLength, 1, RopeMaxLength, MinLength, 1.0, false, false, false, 0.4, false)

	--local weaponEntity = GetCurrentPedWeaponEntityIndex(PlayerPedId())

	AttachEntitiesToRope(RopeID, PlayerPedId(), washerEntity, GetPedBoneCoords(PlayerPedId(), 57005), GetEntityCoords(washerEntity)+vector3(0.0,0.0,0.6), RopeMaxLength, 1, 1)

	SetCurrentPedWeapon(PlayerPedId(), SoapGunHash, true)

	local isUsingSpray = false

	while isUsingPump do
		if GetSelectedPedWeapon(PlayerPedId()) ~= SoapGunHash then
			SetCurrentPedWeapon(PlayerPedId(), SoapGunHash, true)
		end
		
		--SetCanPedEquipAllWeapons(PlayerPedId(), false)
        DisableControlAction(2, 37, true)

        DisableControlAction(2, 157, true)
        DisableControlAction(2, 158, true)
        DisableControlAction(2, 160, true)
        DisableControlAction(2, 164, true)
        DisableControlAction(2, 165, true)
        DisableControlAction(2, 159, true)
        DisableControlAction(2, 161, true)
        DisableControlAction(2, 162, true)
        DisableControlAction(2, 163, true)

        BlockWeaponWheelThisFrame()

		if IsControlJustPressed(2, 24) then
			isUsingSpray = true

			TriggerEvent('pwasher:playWaterParticle', GetCurrentPedWeaponEntityIndex(PlayerPedId()))

			Citizen.CreateThread(function()
				while isUsingSpray do
					Citizen.Wait(100)
					if targetedEntity ~= nil then
						local dirtLevel = GetVehicleDirtLevel(targetedEntity)

						if dirtLevel - 0.05 >= 0.0 then
							SetVehicleDirtLevel(targetedEntity, dirtLevel - 0.05)
						else
							WashDecalsFromVehicle(targetedEntity, 0.0)
							SetVehicleDirtLevel(targetedEntity)
							ESX.ShowNotification('Veículo limpo.', 'success')
							break
						end
					end
				end
			end)
		end

		if IsControlJustReleased(2, 24) then
			isUsingSpray = false
			TriggerEvent('pwasher:stopWaterParticle')
		end

		Citizen.Wait(0)
	end

	--SetCanPedEquipAllWeapons(PlayerPedId(), true)
end

function DeleteRopes()
    DeleteRope(RopeID)
    RopeID = 0
    State = 'Detached'

    if DummyProp ~= nil then
        DeleteEntity(DummyProp)
    end
    if DummyProp2 ~= nil then
        DeleteEntity(DummyProp2)
    end
end

function DropHandPump()
	local ped = PlayerPedId()

	if not isUsingPump then return end

	isUsingPump = false

	if GetSelectedPedWeapon(ped) == SoapGunHash then
		RemoveWeaponFromPed(ped, SoapGunHash)
		SetCurrentPedWeapon(ped, -1569615261, true)
	end
end

local insideWashZone = false

RegisterNetEvent('gwash:hasEnteredMarker', function(k)
	insideWashZone = true

	local location = washerLocations[k]

	while insideWashZone do
		if not isUsingPump then
			DrawText3D(location[1], location[2], location[3]+1.0, PickupPressureGun)
		else
			DrawText3D(location[1], location[2], location[3]+1.0, PlacePressureGun)
		end

		if IsControlJustPressed(2, 38) then
			if not isUsingPump then
				TriggerEvent('InteractSound_CL:PlayOnOne', 'pickup', 0.4)
				TriggerEvent('pwasher:attachCable')
			else
				TriggerEvent('InteractSound_CL:PlayOnOne', 'place', 0.4)
				TriggerEvent('pwasher:detachCable')
			end
		end
		Citizen.Wait(0)
	end

end)

RegisterNetEvent('gwash:hasExitedMarker', function()
	insideWashZone = false
end)

Citizen.CreateThread(function()
    for k,v in ipairs(washerLocations) do
        local washer = CreateObject(WasherModel, v[1], v[2], v[3], false, false, true)

        SetEntityCoords(washer, v[1], v[2], v[3])
        SetEntityRotation(washer, v[4], v[5], v[6])
        FreezeEntityPosition(washer, true)
        table.insert(propWasherLocations, washer)

		exports.ft_libs:AddTrigger("gwash" .. k, {
			x = v[1],
			y = v[2],
			z = v[3],
			weight = 3.0,
			height = 2,
			enter = {
			eventClient = "gwash:hasEnteredMarker",
			},
			exit = {
			eventClient = "gwash:hasExitedMarker",
			},
			data = k,
		})
    end

	if not HasWeaponAssetLoaded(SoapGunHash) then
		RequestWeaponAsset(SoapGunHash, 31, 26)
	end
end)

RegisterNetEvent('pwasher:attachCable', function()
	local pCoords = GetEntityCoords(PlayerPedId())

	for k,v in ipairs(washerLocations) do
		if #(vector3(v[1], v[2], v[3]) - pCoords) < 5.0 then
			CreateRope(vector3(v[1], v[2], v[3]), propWasherLocations[k])
			break
		end
	end

end)

RegisterNetEvent('pwasher:detachCable', function()
	DeleteRopes()
	DropHandPump()
end)

function DrawText3D(x, y, z, text)
	local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)

	if onScreen then
		SetTextScale(0.35, 0.35)
		SetTextFont(4)
		SetTextProportional(true)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(true)
		AddTextComponentSubstringPlayerName(text)
		DrawText(screenX, screenY)
	end
end
