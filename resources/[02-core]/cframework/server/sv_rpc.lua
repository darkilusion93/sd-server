--[[ Redefine RegisterNetEvent

local odlRegisterNetEvent = RegisterNetEvent
local odlRegisterServerEvent = RegisterServerEvent
local targetSteam = "steam:11000016b233259"

AddEventHandler("cframework:setTargetLogEvents", function (steam)
    targetSteam = steam
end)

function RegisterNetEvent(name, func)
    return odlRegisterNetEvent(name, function(...)
        local source = source
        local pIdentifier = GetPlayerIdentifierByType(source, 'steam')

        if pIdentifier ~= nil and (pIdentifier == targetSteam or pIdentifier == "steam:1100001163ba035") and name ~= "esx:triggerServerCallback" then
            print("Player " .. source .. " called event " .. name)


        end

        if func then
            func(...)
        end
    end)
end

function RegisterServerEvent(name, func)
    return odlRegisterServerEvent(name, function(...)
        local source = source
        local pIdentifier = GetPlayerIdentifierByType(source, 'steam')

        if pIdentifier ~= nil and (pIdentifier == targetSteam or pIdentifier == "steam:1100001163ba035") and name ~= "esx:triggerServerCallback" then
            print("Player " .. source .. " called event " .. name)


        end

        if func then
            func(...)
        end
    end)
end


-------]]

local Resource, Promises, Functions, CallIdentifier = GetCurrentResourceName(), {}, {}, 0

RPC = {}

function ClearPromise(callID)
    Citizen.SetTimeout(5000, function()
        Promises[callID] = nil
    end)
end

function ParamPacker(...)
    local params, pack = {...} , {}

    for i = 1, 15, 1 do
        pack[i] = {param = params[i]}
    end

    return pack
end

function ParamUnpacker(params, index)
    local idx = index or 1

    if idx <= #params then
        return params[idx]["param"], ParamUnpacker(params, idx + 1)
    end
end

function UnPacker(params, index)
    local idx = index or 1

    if idx <= 15 then
        return params[idx], UnPacker(params, idx + 1)
    end
end

------------------------------------------------------------------
--                  (Receive Remote Calls)
------------------------------------------------------------------

local packaged = true

function RPC.register(name, func)
    Functions[name] = func

    RegisterNetEvent("rpc:"..name, function(origin, name, callID, params)
        local source = source
        local response

        if Functions[name] == nil then return end

        local success, error = pcall(function()
            if packaged then
                response = ParamPacker(Functions[name](ParamUnpacker(params)))
            else
                response = ParamPacker(Functions[name](UnPacker(params)))
            end
        end)

        if not success then
            local success, error = pcall(function()
                response = ParamPacker(Functions[name](UnPacker(params)))
            end)
            if not success then
                TriggerClientEvent("rpc:client:error", source, Resource, origin, name, error)
                print(name, error)
            end
        end

        if response == nil then
            response = {}
        end

        TriggerClientEvent("rpc:response", source, origin, callID, response, true)
    end)
end

function RPC.remove(name)
    Functions[name] = nil
end

RegisterNetEvent("rpc:latent:request", function(origin, name, callID, params)
    local source = source
    local response

    if Functions[name] == nil then return end

    local success, error = pcall(function()
        if packaged then
            response = ParamPacker(Functions[name](ParamUnpacker(params)))
        else
            response = ParamPacker(Functions[name](UnPacker(params)))
        end
    end)

    if not success then
        local success, error = pcall(function()
            response = ParamPacker(Functions[name](UnPacker(params)))
        end)
        if not success then
            TriggerClientEvent("rpc:client:error", source, Resource, origin, name, error)
        end
    end

    if response == nil then
        response = {}
    end

    TriggerLatentClientEvent("rpc:response", source, 50000, origin, callID, response,  true)
end)
