fx_version 'cerulean'
game 'gta5'

author 'hudserver'
description 'huding'
version '1.0.0'
lua54 'yes'
dependency 'ox_lib'
shared_script '@ox_lib/init.lua'
client_script "nui.lua"
server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    "nui-s.lua",
}

ui_page "html/index.html"
files {
    'html/fonts/pdown.ttf',

    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
    'html/img/id.png',
    'html/img/wallet.png',
    'html/img/money.png',
    'html/img/credit.png',
    'html/img/society.png',
}