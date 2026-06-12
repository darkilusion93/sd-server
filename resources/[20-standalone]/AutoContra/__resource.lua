resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/jquery.js',
	'html/fonts/JustSignature.woff',
	'html/ImagemAuto.png',
	'html/Declaracao.png',
	'html/init.js',
	'html/style.css',
}

client_scripts{
	'client.lua',
	'config.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua',
	'config.lua'
}