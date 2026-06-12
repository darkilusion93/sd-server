fx_version "bodacious"
games {"gta5"}

server_scripts {
    "config.lua",
    "server/utils.lua",
    "server/server.lua",
	'@oxmysql/lib/MySQL.lua'
}
client_scripts {
    "config.lua",
    "client/utils.lua",
    "client/client.lua",
    "client/gui.lua"
}

ui_page('html/ui.html')

files {
  'html/ui.html',
  'html/js/script.js',
  'html/css/style.css',
  'html/img/digital.ttf',
  'html/img/*.svg',
  'html/img/*.png'
}
