fx_version 'bodacious'

games { 'gta5' }
lua54 'yes'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

client_scripts {
	'@cframework/core/events.lua',
	'@cframework/locale.lua',
	'client/cl_*.lua',
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'server/sv_*.lua',
}

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/style.css'
}
