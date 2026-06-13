fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Recurso é apenas um pacote de armas/props (Airsoft M4 + meta). Os scripts
-- 'server.lua'/'rappel_server.lua'/'config.lua' nunca existiram (nem no backup);
-- referenciá-los só gera erros de load. Removidos.
client_scripts {
	'cl_weaponNames.lua'
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