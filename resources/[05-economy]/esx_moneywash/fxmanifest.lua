fx_version 'adamant'
games { 'gta5' }


description 'ESX Money Washing'

version '0.1.1'

server_scripts {
	'@cframework/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
	--'version.lua'
}

client_scripts {
	'@cframework/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
}

dependencies {
	'cframework',
}