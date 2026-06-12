fx_version "bodacious"
game "gta5"

lua54 'yes'

description 'ESX DMV School'

version '1.0.4'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

server_scripts {
	'@cframework/locale.lua',
	'locales/br.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@cframework/locale.lua',
	'locales/br.lua',
	'config.lua',
	'client/main.lua'
}

ui_page {
    'html/ui.html'
}	

files {
	'html/ui.html',
	'html/dmv.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

dependencies {
	'cframework',
	--'esx_license'
}
