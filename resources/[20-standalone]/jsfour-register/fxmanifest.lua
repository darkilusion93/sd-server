fx_version 'cerulean'
game 'gta5'
lua54 'yes'

-- Criação de personagem (base limpa Sem Destino RP).
-- Substitui o recurso 'jsfour-register' original, que não existia no backup.
-- Reusa o sistema de skin/menu do cframework — sem NUI nem dependências externas.
-- Disparado por: [02-core]/cframework/client/cl_spawnmanager.lua -> TriggerEvent('jsfour-register:open')
dependency 'cframework'

client_script 'client.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
