resource_type 'gametype' { name = 'Roleplay' }

fx_version 'bodacious'

game 'gta5'
lua54 'yes'

description 'cframework'

version '2.0'

client_script 'client/cl_rpc.lua'
server_script 'server/sv_rpc.lua'

client_scripts {
	'core/events.lua',
    'core/cl_nativefix.lua',
    'core/fivem/fivem_client.lua',
    'core/fivem/vs_client.lua',
    "core/fivem/mapmanager_shared.lua",
    "core/fivem/mapmanager_client.lua",
    'core/fivem/client.lua'
}

server_scripts {
    'core/fivem/vs_server.lua',
    "core/fivem/mapmanager_shared.lua",
    "core/fivem/mapmanager_server.lua"
}

files {
    'core/fivem/html/index.html',
    'core/fivem/html/assets/**/*.*',
    'core/fivem/html/assets/**/**/*.*'
}

loadscreen 'core/fivem/html/index.html'
loadscreen_manual_shutdown 'yes'
loadscreen_cursor 'yes'

server_export "getCurrentGameType"
server_export "getCurrentMap"
server_export "changeGameType"
server_export "changeMap"
server_export "doesMapSupportGameType"
server_export "getMaps"
server_export "roundEnded"

server_scripts {
	'common/lang/sh_*.lua',
	'locale.lua',
	'locales/br.lua',

	'common/modules/async.lua',
	'@oxmysql/lib/MySQL.lua',

	'config.lua',

	'server/sv_util.lua',
	'server/sv_commandapi.lua',
	'server/sv_login.lua',

	'server/classes/inventory.lua',
	'server/classes/groups.lua',

	'server/sv_common.lua',
    'common/jobs/sh_*.lua',
	'common/sh_*.lua',
   -- 'common/items/item_*.lua',

	'server/classes/player.lua',
	'server/sv_functions.lua',
	'server/sv_pfunctions.lua',
	'server/sv_cache.lua',
	'server/sv_main.lua',
	'server/sv_cron.lua',

    'server/commands/sv_*.lua',

	'server/classes/addon.lua',
	'server/sv_addonaccount.lua',
	'server/sv_datastore.lua',

	'server/modules/sv_*.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

client_scripts {
	'common/lang/sh_*.lua',
	'locale.lua',
	'locales/br.lua',

	'client/cl_login.lua',
	'common/modules/async.lua',

	'config.lua',

	'client/cl_common.lua',
    'common/jobs/sh_*.lua',
	'common/sh_*.lua',
   -- 'common/items/item_*.lua',

	'client/cl_entityiter.lua',
	'client/cl_functions.lua',
	'client/cl_wrapper.lua',
	'client/cl_spawnmanager.lua',
	'client/cl_main.lua',
	'client/cl_instance.lua',
	'client/cl_skin.lua',
	'client/cl_basicneeds.lua',
	'client/cl_society.lua',
	'client/cl_statusm.lua',

	'client/classes/status.lua',

	'client/interact/cl_*.lua',
	'client/modules/cl_*.lua',

	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',

	'client/menu/menu_default.lua',
	'client/menu/menu_dialog.lua',
	'client/menu/menu_list.lua',
}

ui_page {
	'html/ui.html'
}

files {
	'locale.js',
	'html/ui.html',

	'html/css/app.css',

    "html/js/*",
    "html/js/models/*",

	'html/fonts/*.*',

    'html/img/*.png',

	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png',

	'html/img/keys/enter.png',
	'html/img/keys/return.png',
	
	'html/img/idcard/*.png',
    'html/img/plates/*.png',

	'html/img/hud/*.png',
	'html/img/hud/*.svg',
	
	'html/sounds/*.ogg'
}

exports {
	'getSharedObject',
	'onServer',
	'emitServer',
	'SendAlert',
	'SendUniqueAlert',
	'PersistentAlert',
}

server_exports {
	'getSharedObject',
	'onClient',
	'emitClient'
}

dependencies {
	--'mysql-async',
	--'essentialmode',
	--'esplugin_mysql',
	--'async'
}
