
attachedPropPerm = 0
function removeAttachedPropPerm()
	if DoesEntityExist(attachedPropPerm) then
		DeleteEntity(attachedPropPerm)
		attachedPropPerm = 0
	end
end

RegisterNetEvent('destroyPropPerm')
AddEventHandler('destroyPropPerm', function()
	removeAttachedPropPerm()
end)

local APPbone = 0
local APPx = 0.0
local APPy = 0.0
local APPz = 0.0
local APPxR = 0.0
local APPyR = 0.0
local APPzR = 0.0

local holdingPackage = false

RegisterNetEvent('attachPropPerm')
AddEventHandler('attachPropPerm', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)

	if attachedPropPerm ~= 0 then
		removeAttachedPropPerm()
		return
	end
	TriggerEvent("DoLonchudText","Press 7 to drop or pickup the object.",37)
	
	holdingPackage = true
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedPropPerm = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedPropPerm, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)

	APPbone = bone
	APPx = x
	APPy = y
	APPz = z
	APPxR = xR
	APPyR = yR
	APPzR = zR

end)
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function randPickupAnim()
  	local randAnim = math.random(7)

    loadAnimDict('random@domestic')
    TaskPlayAnim(PlayerPedId(),'random@domestic', 'pickup_low',5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
end

function propAttachDrop()
	if attachedPropPerm ~= 0 then

		if (`WEAPON_UNARMED` ~= GetSelectedPedWeapon(PlayerPedId()) and holdingPackage) then

			if not holdingPackage then

				local dst = #(GetEntityCoords(attachedPropPerm) - GetEntityCoords(PlayerPedId()))

				if dst < 2 then
				--	TaskTurnPedToFaceEntity(PlayerPedId(), attachedPropPerm, 1.0)
					holdingPackage = not holdingPackage
					randPickupAnim()
					Citizen.Wait(1000)
					PropCarryAnim()
					ClearPedTasks(PlayerPedId())
					ClearPedSecondaryTask(PlayerPedId())
					AttachEntityToEntity(attachedPropPerm, PlayerPedId(), APPbone, APPx, APPy, APPz, APPxR, APPyR, APPzR, 1, 1, 0, 0, 2, 1)
				end

			else
				holdingPackage = not holdingPackage
				ClearPedTasks(PlayerPedId())
				ClearPedSecondaryTask(PlayerPedId())
				randPickupAnim()
				Citizen.Wait(500)
				DetachEntity(attachedPropPerm)
			end

		end
	end
end

function PropCarryAnim()
	-- anims for specific carrying props.
end

attachedProp = 0
function removeAttachedProp()
	if DoesEntityExist(attachedProp) then
		DeleteEntity(attachedProp)
		attachedProp = 0
	end
end

RegisterNetEvent('destroyProp', function()
	TriggerServerEvent("cframework:destroyAttachedProp")
end)

RegisterNetEvent('attachProp', function(attachedProp,boneNumberSent,x,y,z,xR,yR,zR, pVertexIndex)
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)

	AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, true, true, false, false, pVertexIndex and pVertexIndex or 2, true)
end)

-- Phone
attachedPropPhone = 0
function removeAttachedPropPhone()
	if DoesEntityExist(attachedPropPhone) then
		DeleteEntity(attachedPropPhone)
		attachedPropPhone = 0
	end
end

RegisterNetEvent('destroyPropPhone')
AddEventHandler('destroyPropPhone', function()
	removeAttachedPropPhone()
end)

RegisterNetEvent('attachPropPhone')
AddEventHandler('attachPropPhone', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedPropPhone()
	attachModelPhone = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModelPhone)
	while not HasModelLoaded(attachModelPhone) do
		Citizen.Wait(100)
	end
	attachedPropPhone = CreateObject(attachModelPhone, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedPropPhone, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

RegisterNetEvent('attachPropPoliceIdBoard')
AddEventHandler('attachPropPoliceIdBoard', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
		removeAttachedProp()
    RequestAnimDict("mp_character_creation@lineup@male_a")
    while not HasAnimDictLoaded("mp_character_creation@lineup@male_a") do
        Citizen.Wait(0)
    end
    if not IsEntityPlayingAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "loop_raised", 3) then
        local animLength = GetAnimDuration("mp_character_creation@lineup@male_a", "loop_raised")
        TaskPlayAnim(PlayerPedId(), "mp_character_creation@lineup@male_a", "loop_raised", 1.0, 1.0, animLength, 1, 0, 0,0, 0)
    end
    attachModel = GetHashKey(attachModelSent)
    boneNumber = boneNumberSent
    SetCurrentPedWeapon(PlayerPedId(), 0xA2719263) 
    local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Citizen.Wait(100)
    end
    attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
    AttachEntityToEntity(attachedProp, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end)

-- Radio
attachedPropRadio = 0
function removeAttachedPropRadio()
	if DoesEntityExist(attachedPropRadio) then
		DeleteEntity(attachedPropRadio)
		attachedPropRadio = 0
	end
end

RegisterNetEvent('destroyPropRadio')
AddEventHandler('destroyPropRadio', function()
	removeAttachedPropRadio()
end)

RegisterNetEvent('attachPropRadio')
AddEventHandler('attachPropRadio', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedPropRadio()
	attachModelRadio = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModelRadio)
	while not HasModelLoaded(attachModelRadio) do
		Citizen.Wait(100)
	end
	attachedPropRadio = CreateObject(attachModelRadio, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedPropRadio, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)


attachedProp69 = 0
function removeAttachedProp69()
	if DoesEntityExist(attachedProp69) then
		DeleteEntity(attachedProp69)
		attachedProp69 = 0
	end
end


RegisterNetEvent('destroyProp69')
AddEventHandler('destroyProp69', function()
	removeAttachedProp69()
end)
RegisterNetEvent('attachProp69')
AddEventHandler('attachProp69', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp69()
	attachModel69 = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel69)
	while not HasModelLoaded(attachModel69) do
		Citizen.Wait(100)
	end
	attachedProp69 = CreateObject(attachModel69, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(attachedProp69, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 0, 0, 0, 2, 1)
end)

RegisterNetEvent('attachPropTest')
AddEventHandler('attachPropTest', function()
	--attachModelSent,boneNumberSent,x,y,z,xR,yR,zR
	--TriggerEvent("attachProp","prop_golf_iron_01", 57005, 0.085, 0.0, 0.0, 90.0, -118.0, 44.0)
	--TriggerEvent("attachProp","w_ar_advancedrifle", 57005, 0.14, 0.00, 0.0, 160.0, -60.0, 10.0)

	TriggerEvent("attachItemPerm","briefcase01")
	--prop_golf_putter_01
	--TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GOLF_PLAYER", 0, false);
end)
RegisterNetEvent('attachItem69')
AddEventHandler('attachItem69', function(item)
	TriggerEvent("attachProp69",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('attachItemPhone')
AddEventHandler('attachItemPhone', function(item)
	TriggerEvent("attachPropPhone",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('attachItemRadio')
AddEventHandler('attachItemRadio', function(item)
	TriggerEvent("attachPropRadio",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('attachItemClipboard')
AddEventHandler('attachItemClipboard', function(item)
	TriggerEvent("attachPropClipboard",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('attachItem', function(item)
	TriggerServerEvent("cframework:createPropToAttach", item)
end)

RegisterNetEvent('attachItem2', function(item)
	TriggerServerEvent("cframework:createSecondPropToAttach", item)
end)

RegisterNetEvent("cframework:attachProp", function(netId, item)
	while netId ~= 0 and not NetworkDoesNetworkIdExist(netId) do
        Citizen.Wait(0)
    end

	local entity = NetworkGetEntityFromNetworkId(netId)

	TriggerEvent("attachProp", entity, attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"], attachPropList[item]["vertexIndex"])
end)


RegisterNetEvent('attachItemPerm')
AddEventHandler('attachItemPerm', function(item)
	TriggerEvent("attachPropPerm",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
end)

RegisterNetEvent('np-propattach:attach')
AddEventHandler('np-propattach:attach', function(pPropItem, pTargetFunction)
	local targetFunction = pTargetFunction or 'attachProp'
	TriggerEvent(targetFunction, attachPropList[pPropItem]["model"], attachPropList[pPropItem]["bone"], attachPropList[pPropItem]["x"], attachPropList[pPropItem]["y"], attachPropList[pPropItem]["z"], attachPropList[pPropItem]["xR"], attachPropList[pPropItem]["yR"], attachPropList[pPropItem]["zR"])
end)

RegisterNetEvent('attach:cigar')
AddEventHandler('attach:cigar', function()
	TriggerEvent("attachItemPerm","cigar01")
end)

RegisterNetEvent('attach:suitcase')
AddEventHandler('attach:suitcase', function()
	TriggerEvent("attachItemPerm","briefcase01")
end)

RegisterNetEvent('attach:boombox')
AddEventHandler('attach:boombox', function()
	TriggerEvent("attachItemPerm","boombox01")
end)

RegisterNetEvent('attach:box')
AddEventHandler('attach:box', function(doNone)
	TriggerEvent("animation:carry", doNone and "none" or "box01")
end)

RegisterNetEvent('attach:blackDuffelBag')
AddEventHandler('attach:blackDuffelBag', function()
	TriggerEvent("attachItemPerm","blackduffelbag")
end)

RegisterNetEvent('attach:medicalBag')
AddEventHandler('attach:medicalBag', function()
	TriggerEvent("attachItemPerm","medicalBag")
end)

RegisterNetEvent('attach:securityCase')
AddEventHandler('attach:securityCase', function()
	TriggerEvent("attachItemPerm","securityCase")
end)

RegisterNetEvent('attach:toolbox')
AddEventHandler('attach:toolbox', function()
	TriggerEvent("attachItemPerm","toolbox")
end)

RegisterNetEvent('attach:test')
AddEventHandler('attach:test', function()
	TriggerEvent("attachItemPerm","test")
end)

RegisterNetEvent('attach:healthpack01')
AddEventHandler('attach:healthpack01', function()
	TriggerEvent("attachItemPerm","healthpack01")
end)

RegisterNetEvent('attach:removeall')
AddEventHandler('attach:removeall', function()
	TriggerEvent("disabledWeapons",false)
	TriggerEvent("destroyPropPerm")
	if(carryingObject) then
		TriggerEvent("attach:box")
	end
end)

function removeAttachedcarryObject()
	if DoesEntityExist(carryObject) then
		DeleteEntity(carryObject)
		carryObject = 0
	end
end

RegisterNetEvent('destroycarryObject')
AddEventHandler('destroycarryObject', function()
	removeAttachedcarryObject()
end)

RegisterNetEvent('attachcarryObject')
AddEventHandler('attachcarryObject', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedcarryObject()
	attachModel = GetHashKey(attachModelSent)
	boneNumber = boneNumberSent
	SetCurrentPedWeapon(PlayerPedId(), 0xA2719263)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumberSent)
	--local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	carryObject = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	AttachEntityToEntity(carryObject, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, true, 0, 2, 1)
end)

carryingObject = false
carryObject = 0
objectType = 0

carryAnimType = 49

RegisterNetEvent('animation:carryshort');
AddEventHandler('animation:carryshort', function()
	carryAnimType = 16
	carryingObject = true
	Citizen.Wait(5000)
	carryingObject = false
	carryAnimType = 49
end)

RegisterNetEvent('animation:carryt');
AddEventHandler('animation:carryt', function()
	TriggerEvent("animation:carry","drugtest01")
end)

local holding = "none"
RegisterNetEvent('animation:carry');
AddEventHandler('animation:carry', function(item,isInventory)
	
	local inventoryNone = true


	if carryingObject and item == "none" then 
		if attachPropList[holding].inventoryBased and isInventory then
			inventoryNone = true
		else
			inventoryNone = false
		end

		if not isInventory then
			inventoryNone = true
		end
	end


	if item == "none" then
		if not inventoryNone then return end
		holding = "none"
		removeAttachedcarryObject()
		carryingObject = false
		carryObject = 0
		objectType = 0
		carryAnimType = 49
		lastObjectHealth = 0
		return
	end
	if holding ~= "none" and item == holding then return end
	if not carryingObject then
		if(item["model"] ~= nil) then
			RequestModel(item["model"])
			while not HasModelLoaded(item["model"]) do
				Citizen.Wait(1)
			end
		end
		holding = item
		carryAnimType = 49
		carryingObject = true
		objectType = objectPassed
		lastObjectHealth = 0
		TriggerEvent("attachcarryObject",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
	else
		holding = "none"
		removeAttachedcarryObject()
		carryingObject = false
		carryObject = 0
		objectType = 0
		carryAnimType = 49
		lastObjectHealth = 0
	end
end)

RegisterNetEvent('propattach:destroyCurrent');
AddEventHandler('propattach:destroyCurrent', function()
	local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ObjectFound = FindFirstObject()
    local success
    repeat
        local pos = GetEntityCoords(ObjectFound)
        local distance = #(playerCoords - pos)
		if distance < 1.0 then
			if IsEntityTouchingEntity(PlayerPedId(), ObjectFound) then
				DetachEntity(ObjectFound,false,false)
				DeleteObject(ObjectFound)
				DeleteEntity(ObjectFound)
			end

        end

        success, ObjectFound = FindNextObject(handle)
    until not success
	EndFindObject(handle)
	TriggerEvent("animation:carry","none")
end)

--[[local canceled = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if carryingObject then
			RequestAnimDict('anim@heists@box_carry@')
			while not HasAnimDictLoaded("anim@heists@box_carry@") do
				Citizen.Wait(0)
				ClearPedTasksImmediately(PlayerPedId())
			end
			if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) then
				TaskPlayAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 8.0, -8, -1, carryAnimType, 0, 0, 0, 0)
				canceled = false
			end
		else
			if IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3) and not canceled then
				if holding == "none" then
					ClearPedTasksImmediately(PlayerPedId())
					canceled = true
				else
					ClearPedSecondaryTask(PlayerPedId())
				end
			end
			Wait(1000)
		end
	end
end)

local invehicle = false
local lastObjectHealth = 0
local radollTimer = 0
local destroyByRagdoll = false
Citizen.CreateThread(function()
    while true do
        Wait(300)
		if holding ~= "none" then
			if invehicle == nil then
				invehicle = false
			end

			if IsPedGettingIntoAVehicle(PlayerPedId()) and attachPropList[holding].blockCar then
				TriggerEvent("DoLonchudText","Cannot get in the car holding this.",2)
				ClearPedTasksImmediately(PlayerPedId())
			end

			if not invehicle and IsPedInAnyVehicle(PlayerPedId(), true) then
				invehicle = true
				if attachPropList[holding] ~= nil and attachPropList[holding].blockCar then
					TriggerEvent("DoLonchudText","Cannot get in the car holding this.",2)
					ClearPedTasksImmediately(PlayerPedId())
				else
					hideObjectTillNeeded(invehicle)
				end
			end

			if invehicle and not IsPedInAnyVehicle(PlayerPedId(), true) then
				invehicle = false
				hideObjectTillNeeded(invehicle)
			end
			
			if attachPropList[holding] ~= nil and attachPropList[holding].blockRunning then 
				if IsPedRunning(PlayerPedId()) or IsPedSprinting(PlayerPedId()) then
					SetPlayerControl(PlayerId(), 0, 0)
					Citizen.Wait(1000)
					SetPlayerControl(PlayerId(), 1, 1)
				end
			end

			if attachPropList[holding] ~= nil and attachPropList[holding].destroyOnDamage then
				if lastObjectHealth == 0 then lastObjectHealth = GetEntityHealth(carryObject) end

				if GetEntityHealth(carryObject) ~= lastObjectHealth and GetEntityHealth(carryObject) <= 940 then
					destroyObject()
				end

				if IsPedRagdoll(PlayerPedId()) then
					if (GetGameTimer() - radollTimer) >= 1200 and (GetGameTimer() - radollTimer) <= 1450 then 
						destroyByRagdoll = true
					end
					if (GetGameTimer() - radollTimer) >= 1500 or (GetGameTimer() - radollTimer) <= 300 then
						radollTimer = GetGameTimer();
					end
					
				end

				if destroyByRagdoll and not IsPedFalling(PlayerPedId()) then
					destroyObject()
					radollTimer = 0
					destroyByRagdoll = false
				end
				

			end

		end

    end
end)]]

function destroyObject()

	lastObjectHealth = 0
	if attachPropList[holding].stolen then
		TriggerEvent("inventory:removeItem",holding, 1)
		TriggerEvent( "player:receiveItem", "stolenBrokenGoods", 1 )     
	else
		holding = "none"
		removeAttachedcarryObject()
		carryingObject = false
		carryObject = 0
		objectType = 0
		carryAnimType = 49
		lastObjectHealth = 0
	end

end

function hideObjectTillNeeded(hide)
	if hide and holding ~= "none" then
		removeAttachedcarryObject()
		carryingObject = false
		carryObject = 0
		objectType = 0
		carryAnimType = 49
	end

	if not hide and holding ~= "none" then
		local item = holding
		carryAnimType = 49
		carryingObject = true
		objectType = objectPassed
		TriggerEvent("attachcarryObject",attachPropList[item]["model"], attachPropList[item]["bone"], attachPropList[item]["x"], attachPropList[item]["y"], attachPropList[item]["z"], attachPropList[item]["xR"], attachPropList[item]["yR"], attachPropList[item]["zR"])
	end
end



function canPullWeaponHoldingEntity()
	if attachPropList[holding] ~= nil and attachPropList[holding].blockGuns and (attachPropList[holding].blockCar and invehicle == false) then 
		return false
	end
	return true
end




InjuryIndexList = {
	{ "Pelvis","4103","11816" },
	{ "Left Thigh","4103","58271" },
	{ "Left Calf","4103","63931" },
	{ "Left Foot","4103","14201" },
	{ "Left Knee","119","46078" },
	{ "Right Thigh","4103","51826" },
	{ "Right Calf","4103","36864" },
	{ "Right Foot","4103","52301" },
	{ "Right Knee","119","16335" },
	{ "Spine Lower","4103","23553" },
	{ "Spine Mid Lower","4103","24816" },
	{ "Spine Mid","4103","24817" },
	{ "Spine High","4103","24818" },
	{ "Left Clavicle","4103","64729" },
	{ "Left UpperArm","4103","45509" },
	{ "Left Forearm","4215","61163" },
	{ "Left Hand","4215","18905" },
	{ "Left Finger Pinky","4103","26610" },
	{ "Left Finger Index","4103","26611" },
	{ "Left Finger Middle","4103","26612" },
	{ "Left Finger Ring","4103","26613" },
	{ "Left Finger Thumb","4103","26614" },
	{ "Left Hand","119","60309" },
	{ "Left ForeArmRoll","7","61007" },
	{ "Left ArmRoll","7","5232" },
	{ "Left Elbow","119","22711" },
	{ "Right Clavicle","4103","10706" },
	{ "Right UpperArm","4103","40269" },
	{ "Right Forearm","4215","28252" },
	{ "Right Hand","4215","57005" },
	{ "Right Finger Pinky","4103","58866" },
	{ "Right Finger Index","4103","58867" },
	{ "Right Finger Middle","4103","58868" },
	{ "Right Finger Ring","4103","58869" },
	{ "Right Finger Thumb","4103","58870" },
	{ "Right Hand","119","28422" },
	{ "Right Hand","119","6286" },
	{ "Right ForeArmRoll","7","43810" },
	{ "Right ArmRoll","7","37119" },
	{ "Right Elbow","119","2992" },
	{ "Neck","4103","39317" },
	{ "Head","4103","31086" },
	{ "Head","119","12844" },
	{ "Face Left Brow_Out","1799","58331" },
	{ "Face Left Lid_Upper","1911","45750" },
	{ "Face Left Eye","1799","25260" },
	{ "Face Left CheekBone","1799","21550" },
	{ "Face Left Lip_Corner","1911","29868" },
	{ "Face Right Lid_Upper","1911","43536" },
	{ "Face Right Eye","1799","27474" },
	{ "Face Right CheekBone","1799","19336" },
	{ "Face Right Brow_Out","1799","1356" },
	{ "Face Right Lip_Corner","1911","11174" },
	{ "Face Brow_Centre","1799","37193" },
	{ "Face UpperLipRoot","5895","20178" },
	{ "Face UpperLip","6007","61839" },
	{ "Face Left Lip_Top","1911","20279" },
	{ "Face Right Lip_Top","1911","17719" },
	{ "Face Jaw","5895","46240" },
	{ "Face LowerLipRoot","5895","17188" },
	{ "Face LowerLip","6007","20623" },
	{ "Face Left Lip_Bot","1911","47419" },
	{ "Face Right Lip_Bot","1911","49979" },
	{ "Face Tongue","1911","47495" },
	{ "Neck","7","35731" }
}
