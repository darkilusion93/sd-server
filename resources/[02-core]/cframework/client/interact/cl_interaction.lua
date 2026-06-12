RegisterNetEvent('UseItem', function(itemid)
	local player = PlayerPedId()
    local playerVeh = GetVehiclePedIsIn(player, false)

	if (itemid == "sandwich" or itemid == "hamburger" or itemid == "donut") then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","changehunger",true,itemid,playerVeh)
    end

    if (itemid == "cola" or itemid == "water") then
        AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drink","changethirst",true,itemid,playerVeh)
    end

    if itemid == "chips" then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,15000,"Eating","food:Fries",true,'fries',playerVeh)
    end

    if itemid == "brownie" then
        AttachPropAndPlayAnimation("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,15000,"Eating","food:Fries",true,'brownie',playerVeh)
        TriggerEvent("fx:run", "weed", 180, -1, false)
    end

    --if itemid == "nome do item" then
       -- AttachPropAndPlayAnimation("amb@world_human_drinking@beer@female@idle_a", "idle_e", 49,6000,"Drink","changethirst", true,nome do item ,playerVeh)
  --  end
    

    if itemid == "suede" then
        TriggerEvent("cframework:cleanVehicle")
    end

    if (itemid == "churro" or itemid == "hotdog" or itemid == "chocolate") then
        TaskItem("mp_player_inteat@burger", "mp_player_int_eat_burger", 49,6000,"Eating","food:Condiment",true,itemid,playerVeh)
    end
end)

function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid,vehicle)
    if DoesEntityExist(vehicle) then -- Don't spawn food inside vehicle to avoid clipping
        TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
        return
    end

    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" or itemid == "moneyshot" or itemid == "torpedo" then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" then
        TriggerEvent("attachItem", "sandwich")
    elseif itemid == "brownie" then
        TriggerEvent("attachItem", "chocbar")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "water" or itemid == "cola" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" or itemid == "bscoffee" or itemid == "softdrink" or itemid == "fries" then
        TriggerEvent("attachItem", itemid)
    elseif itemid == "drink1" or itemid == "drink2" or itemid == "drink3" or itemid == "drink4" or itemid == "drink5" or itemid == "drink6"
        or itemid == "drink7" or itemid == "drink8" or itemid == "drink9" or itemid == "drink10" or itemid == "absinthe" then
        TriggerEvent("attachItem", "whiskeyglass")
    elseif itemid == "shot1" or itemid == "shot2" or itemid == "shot3" or itemid == "shot4" or itemid == "shot5" or itemid == "shot6"
        or itemid == "shot7" or itemid == "shot8" or itemid == "shot9" or itemid == "shot10" then
        TriggerEvent("attachItem", "shotglass")
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" then
        TriggerEvent("attachItem", "cup")

   -- elseif itemid == "slushy" then -- nome da prop
       -- TriggerEvent("attachItem", "cup") -- nome da prop

    --elseif has_value(fruits, itemid) then
    --    TriggerEvent("attachItem", "fruit")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid,vehicle)
    TriggerEvent("destroyProp")
end

-- Animations
function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid,playerVeh,itemreturn,itemreturnid,quality)
    loadAnimDict( dictionary )
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, false, false, false )
    local timer = tonumber(timer)
    if timer > 0 and timer ~= nil then
        Citizen.Wait(timer)
    end
    ClearPedSecondaryTask(PlayerPedId())
end
