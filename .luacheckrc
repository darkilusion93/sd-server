-- Sem Destino RP — config luacheck
-- Objetivo: apanhar erros de sintaxe e variáveis indefinidas, não estilo.

std = "lua54"
max_line_length = false
codes = true

-- Não lintar bibliotecas vendidas (têm o seu próprio estilo / são geradas)
exclude_files = {
  "resources/[[]01-libs[]]/oxmysql/**",
  "resources/[[]01-libs[]]/ox_lib/**",
  "resources/[[]01-libs[]]/ft_libs/**",
  "**/web/**",
  "**/html/**",
  "**/node_modules/**",
}

ignore = {
  "212", -- argumento não usado
  "213", -- variável de loop não usada
  "311", -- valor atribuído nunca lido (reatribuído)
  "411", -- variável redefinida
  "421", -- shadowing de variável local
  "431", -- shadowing de upvalue
  "542", -- ramo if vazio
  "611", "612", "613", "614", -- whitespace
  "631", -- linha muito longa
}

-- Globais que os nossos scripts criam/mutam
globals = {
  "ESX", "Config", "Framework", "RPC", "lib", "Async", "Citizen",
  "RegisteredSprays", "cachedData", "vRPC",
}

-- Natives FiveM + ESX/cframework + oxmysql (só leitura)
read_globals = {
  "exports", "source", "json", "MySQL", "vector2", "vector3", "vector4", "quat",
  "TriggerEvent", "AddEventHandler", "RegisterServerEvent", "RegisterNetEvent",
  "TriggerClientEvent", "TriggerServerEvent", "RegisterCommand", "RemoveEventHandler",
  "GetPlayerName", "GetPlayerIdentifiers", "GetPlayerIdentifier", "GetNumPlayerIdentifiers",
  "GetPlayers", "GetCurrentResourceName", "GetInvokingResource", "GetGameTimer",
  "GetEntityCoords", "GetPlayerPed", "CreateThread", "SetTimeout", "Wait", "Citizen",
  "GetHashKey", "CreateVehicle", "DeleteEntity", "NetworkGetEntityFromNetworkId",
  "SetPlayerRoutingBucket", "GetPlayerRoutingBucket", "SetEntityRoutingBucket",
  "SaveResourceFile", "LoadResourceFile", "GetConvar", "GetConvarInt", "SetConvar",
  "IsDuplicityVersion", "IsPlayerAceAllowed", "ExecuteCommand", "CancelEvent",
  "SetVehicleNumberPlateText", "TaskWarpPedIntoVehicle", "InvokeNative", "PerformHttpRequest",
  "DropPlayer", "GetPlayerEndpoint", "GetPlayerPing", "math", "os", "string", "table",
}
