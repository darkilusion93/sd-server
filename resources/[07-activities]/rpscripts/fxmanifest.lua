fx_version 'bodacious'

game 'gta5'
lua54 'yes'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@cframework/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/commands-server.lua',
	'server/render-s.lua',
	'server/entity.lua',
	'server/fuel_server.lua',
	'server/moneywash.lua',
}

client_scripts {
	'@cframework/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/pointfinger-client.lua',
	'client/afkkick-client.lua',
	'client/handsup-client.lua',
	'client/commands-client.lua',
	'client/no_vehicle_rewards-client.lua',
	'client/disable_dispatch-client.lua',
	'client/render-c.lua',
	'client/cl_status.lua',
	'client/cl_takehostage.lua',
	'client/pausemenu.lua',
	'client/entity.lua',
	'client/dice.lua',
	'client/realvehicle.lua',
	'client/fuel_client.lua',
	'client/teleports.lua',
	'client/moneywash.lua',
	'client/prostitutas.lua',
}

server_export 'ShowAlert'
export 'ShowAlert'

ui_page {
    'html/alerts.html',
}

files {
	'html/alerts.html',
	'html/main.js', 
	'html/style.css',
}