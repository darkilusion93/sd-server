resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
description 'ESX Trucker Job'
version '1.0.0'
server_scripts {
    '@cframework/locale.lua',
	'config.lua',
	'server/main.lua'
}
client_scripts {
	'@cframework/locale.lua',
	'config.lua',
	'client/main.lua'
}
