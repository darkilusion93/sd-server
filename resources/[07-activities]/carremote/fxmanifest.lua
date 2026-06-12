fx_version 'adamant'

game 'gta5'

description 'Car Remote'

version '1.0.0'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

client_scripts {
    '@cframework/locale.lua',
	'locales/en.lua',
    "config.lua",
	'@rcore_cam/include/anim.lua',
    "client/main.lua"
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@cframework/locale.lua',
	'locales/en.lua',
    "config.lua",
    "server/main.lua"
}

dependencies {
    'cframework'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/css/ui.css',
    'html/scripts/ui.js',
    'html/scripts/sounds.js',
    'html/images/keyfob_viper.png',
    'html/sounds/lock-inside.ogg',
	'html/sounds/lock-outside.ogg',
    'html/sounds/unlock-inside.ogg',
    'html/sounds/unlock-outside.ogg', 
    'html/sounds/unlock-police.ogg',
    'html/sounds/beep.ogg',
    'html/sounds/chime.ogg'
}
