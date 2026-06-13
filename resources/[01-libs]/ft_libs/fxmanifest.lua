--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

fx_version "bodacious"
game "gta5"
lua54 'yes'
client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'


--client_script 'dist/client.js'
--server_script 'dist/server.js'

--files {
--    'dist/ui.html'
--}

--ui_page 'dist/ui.html'

files {
    "module/*.js",
    "module/animation/tracks/*.js",
    "module/animation/*.js",
    "module/audio/*js",
    "module/cameras/*.js",
    "module/core/*.js",
    "module/extras/core/*.js",
    "module/extras/curves/*.js",
    "module/extras/objects/*.js",
    "module/extras/*.js",
    "module/geometries/*.js",
    "module/helpers/*.js",
    "module/lights/*.js",
    "module/loaders/*.js",
    "module/materials/*.js",
    "module/math/interpolants/*.js",
    "module/math/*.js",
    "module/objects/*.js",
    "module/renderers/shaders/*.js",
    "module/renderers/shaders/ShaderChunk/*.js",
    "module/renderers/shaders/ShaderLib/*.js",
    "module/renderers/webgl/*.js",
    "module/renderers/webvr/*.js",
    "module/renderers/*.js",
    "module/scenes/*.js",
    "module/textures/*.js",
    "script.js"
}

client_scripts {

    -- Utils
    "src/utils/utils.common.lua",
    "src/utils/utils.client.lua",

    -- Ui
    "src/ui/ui.client.lua",
    "src/ui/instructionalButtons.client.lua",

    -- Menu
    "src/menu/menu.client.lua",
    "src/menu/menus.client.lua",

    -- Blip
    "src/blip/blip.client.lua",
    "src/blip/blips.client.lua",

    -- Trigger
    "src/trigger/trigger.client.lua",
    "src/trigger/triggers.client.lua",

    -- Marker
    "src/marker/marker.client.lua",
    "src/marker/markers.client.lua",

    -- Area
    "src/area/area.client.lua",
    "src/area/areas.client.lua",

    -- Button
    "src/button/button.client.lua",
    "src/button/buttons.client.lua",

    -- Ped
    "src/ped/ped.client.lua",
    "src/ped/peds.client.lua",

    -- Event 100% load
    "src/load.client.lua",

    -- Entity
    "src/entity/entity.client.lua",
    "src/entity/object.client.lua",
    "src/entity/ped.client.lua",
    "src/entity/pickup.client.lua",
    "src/entity/player.client.lua",
    "src/entity/vehicle.client.lua",

}

exports {

    -- Utils
    "TableLength",
    "Round",
    "CommaValue",
    "SetDebug",
    "Print",
    "PrintTable",
    "TableContainsValue",
    "GetLastContentValue",
    "GetRandomString",
    "GetDistanceBetween3DCoords",
    "PrintTable",
    "Copy",
    "Clone",

    -- Ui
    "HelpPromt",
    "LoadingPromt",
    "Message",
    "Notification",
    "AdvancedNotification",
    "Text",
    "OpenTextInput",
    "TextNotification",
    "Show3DText",

    -- Instructional Buttons
    "AddInstructionalButtons",
    "RemoveInstructionalButtons",
    "DisplayInstructionalButtons",
    "GetCurrentInstructionalButtons",

    -- Menu
    "AddMenu",
    "RemoveMenu",
    "MenuIsOpen",
    "CurrentMenu",
    "PrimaryMenu",
    "GetCurrentMenu",
    "GetPrimaryMenu",
    "FreezeMenu",
    "OpenMenu",
    "CloseMenu",
    "NextMenu",
    "BackMenu",
    "CleanMenuButtons",
    "SetMenuButtons",
    "SetMenuValue",
    "AddMenuButton",
    "RemoveMenuButton",
    "SelecteButton",

    -- Blip
    "AddBlip",
    "RemoveBlip",
    "ShowBlip",
    "HideBlip",

    -- Trigger
    "AddTrigger",
    "RemoveTrigger",
    "SwitchTrigger",
    "EnableTrigger",
    "DisableTrigger",
    "CurrentTrigger",

    -- Button
    "AddButton",
    "RemoveButton",
    "EnableButton",
    "DisableButton",

    -- Marker
    "AddMarker",
    "RemoveMarker",
    "EnableMarker",
    "DisableMarker",
    "SwitchMarker",
    "CurrentMarker",

    -- Peds
    "AddPed",
    "RemovePed",
    "EnablePed",
    "DisablePed",
    "GetPedHandle",
    "GetPedName",

    -- Areas
    "AddArea",
    "RemoveArea",
    "EnableArea",
    "DisableArea",
    "SwitchArea",

    -- Debug
    "SetDebug",
    "DebugPrint",

    -- Entity
    "GetEntitiesInArea",
    "GetEntityInDirection",
    "GetEntityObjectInDirection",
    "GetEntitiesInAround",

    -- Objects
    "GetObjects",
    "GetObjectsInArea",
    "GetObjectsInAround",
    "GetObjectInDirection",

    -- Peds
    "GetPeds",
    "GetPedsInArea",
    "GetPedsInAround",
    "GetPedInDirection",

    -- Vehicules
    "GetVehicles",
    "GetVehiclesInArea",
    "GetVehiclesInAround",
    "GetVehicleInDirection",

    -- Vehicules
    "GetPickups",
    "GetPickupsInArea",
    "GetPickupsInAround",

    -- Player
    "GetPlayerPed",
    "GetPlayersId",
    "GetPlayersPed",
    "GetPlayerCoords",
    "GetPlayersPedOrderById",
    "GetPlayerPedInDirection",
    "GetPlayerServerIdInDirection",

}

server_scripts {

    -- Utils
    "src/utils/utils.common.lua",
    "src/utils/utils.server.lua",

}

server_exports {

    -- Utils
    "TableLength",
    "PrintTable",
    "Round",
    "GetSteamIDFormSource",
    "GetIpFormSource",
    "TableContainsValue",
    "GetLastContentValue",
    "DebugPrint",
    "SetDebug",
    "GetRandomString",
    "Copy",
    "Clone",

}
