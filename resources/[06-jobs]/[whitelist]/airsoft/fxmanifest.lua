fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
	'cl_weaponNames.lua'
}

server_scripts {
	'server.lua',
	'rappel_server.lua'
}

shared_scripts {
    'config.lua'
}

dependencies {
}
files {
	'weaponhominglauncher.meta',
	'stream/*.ytyp',
	'meta/weaponcomponents.meta',
	'meta/weaponarchetypes.meta',
	'meta/weaponanimations.meta',
	'meta/pedpersonality.meta',
	'meta/weapons.meta',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'

data_file 'WEAPONINFO_FILE_PATCH' 'weaponhominglauncher.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'