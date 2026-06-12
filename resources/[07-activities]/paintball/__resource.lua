resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'
 
files {
	'data/weapon_gadgetpistol.meta',
	'audio/sfx/dlc_hei4/weapon_gadget_pistol.awc',
	'water.xml',
	'heightmap.dat'
	}

data_file 'WEAPONINFO_FILE_PATCH' 'data/weapon_gadgetpistol.meta'

data_file 'AUDIO_WAVEPACK' 'audio/sfx/dlc_hei4'
data_file 'WATER_DATA' 'water.xml'
data_file 'WATER_DATA' 'heightmap.dat'

client_scripts {
    'scripts/config.lua',
    'scripts/client.lua'
}

server_scripts {
    'scripts/config.lua',
    'scripts/server.lua'
}

