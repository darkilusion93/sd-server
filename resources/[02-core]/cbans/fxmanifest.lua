--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/ft_libs
--

fx_version "bodacious"
game "gta5"
lua54 'yes'
dependency 'cframework'   -- garante que o ESX (esx:getSharedObject) existe antes deste recurso carregar
client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

ui_page 'html/index.html'

client_scripts {
    'config.lua',
    'client.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/jquery.datetimepicker.min.css',
    'html/jquery.datetimepicker.full.min.js',
    'html/date.format.js'
}