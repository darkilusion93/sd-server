
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Taxi Job'

version '1.0.1'

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

client_scripts {
  '@cframework/locale.lua',
  'locales/pt.lua',
  'locales/br.lua',
  'config.lua',
  'client/main.lua'
}

server_scripts {
  '@cframework/locale.lua',
  'locales/pt.lua',
  'locales/br.lua',
  'config.lua',
  'server/main.lua'
}
  
  