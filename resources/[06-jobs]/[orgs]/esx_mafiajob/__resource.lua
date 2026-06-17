resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Police Job'

version '1.3.0'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@cframework/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'mobconfig.lua',
	'golfconfig.lua',
	'gangconfig.lua',
	'partyconfig.lua',
	'docksconfig.lua',
	'coastconfig.lua',
	'vagosconfig.lua',
	'groveconfig.lua',
	'blackconfig.lua',
	'mafiaconfig.lua',
	'purpleconfig.lua',
	'cartelconfig.lua',
	'ballasconfig.lua',
	'mungikiconfig.lua',
	'galaxyconfig.lua',
	'yakuzaconfig.lua',
	'snakeconfig.lua',
	'tequillaconfig.lua',
	'usadosconfig.lua',
	'casinoconfig.lua',
	'revisaoconfig.lua',
	'ammunationconfig.lua',
	'vigneconfig.lua',
	'sataconfig.lua',
	'unicornconfig.lua',
	'offroadconfig.lua',
	'server/main.lua'
}

client_scripts {
	'@cframework/locale.lua',
	'locales/br.lua',
	'locales/en.lua',
	'config.lua',
	'mobconfig.lua',
	'golfconfig.lua',
	'gangconfig.lua',
	'partyconfig.lua',
	'docksconfig.lua',
	'coastconfig.lua',
	'vagosconfig.lua',
	'groveconfig.lua',
	'blackconfig.lua',
	'mafiaconfig.lua',
	'purpleconfig.lua',
	'cartelconfig.lua',
	'ballasconfig.lua',
	'mungikiconfig.lua',
	'galaxyconfig.lua',
	'yakuzaconfig.lua',
	'snakeconfig.lua',
	'tequillaconfig.lua',
	'usadosconfig.lua',
	'casinoconfig.lua',
	'revisaoconfig.lua',
	'ammunationconfig.lua',
	'vigneconfig.lua',
	'sataconfig.lua',
	'unicornconfig.lua',
	'offroadconfig.lua',
	'client/main.lua'
}

dependencies {
	'cframework'
	-- 'esx_billing' removido: recurso inexistente nesta base e no backup;
	-- os TriggerServerEvent('esx_billing:sendBill', ...) ficam no-op (nunca houve handler).
}

