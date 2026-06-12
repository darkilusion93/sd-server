fx_version "bodacious"
game "gta5"
lua54 'yes'

author "Cerealitos"

description "ESX Inventory HUD"

version "1.0.0"

ui_page 'html/ui.html'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

client_scripts {
  "@cframework/locale.lua",
  "config.lua",
  "client/main.lua",
  "client/trunk.lua",
  "client/property.lua",
  "client/tempinv.lua",
  "client/org.lua",
  "client/casa.lua",
  "client/player.lua",
  "client/shops.lua",
  "client/hud.lua",
  "client/craft.lua",
  "client/process.lua",
  "client/menu.lua",
  "client/textmenu.lua",
  "client/itemselector.lua",
  "client/fishing.lua",
  "client/clothing.lua",
  "client/garage.lua",
  "client/dispense.lua",
  "client/clothes.lua",
  "client/actions.lua",
  "client/mobilecraft.lua",
  "client/cl_leaderboard.lua",
  "client/cl_voting.lua",
  "client/list.lua",
  "client/customshop.lua",
  "client/market.lua",
  "client/marketmanagement.lua",
  "client/case.lua",
  "client/vipdelivery.lua",
  "client/idcard.lua",
  "locales/*.lua",
}

server_scripts {
  "@cframework/common/modules/async.lua",
  "@oxmysql/lib/MySQL.lua",
  '@cframework/locale.lua',
  'config.lua',
  'server/main.lua',
  'locales/*.lua',
}

files {
    "html/ui.html",
    "html/css/ui.css",
    "html/css/jquery-ui.css",
    "html/fonts/*.woff",
    "html/js/*.js",
    -- JS LOCALES
    "html/locales/*.js",
    -- IMAGES
    "html/img/*.png",
    "html/img/items/*.png",
    "html/img/idcard/*.png",
}