fx_version 'cerulean'
game 'gta5'

author 'Sem Destino'
description 'Sistema de Reciclagem'
version '1.0.0'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'


shared_scripts {
    '@ox_lib/init.lua'
}

client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'config.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.css',
    'html/index.js'
}

dependencies {
    'cframework',
    'ox_lib',
    'okokTextUI'
}


