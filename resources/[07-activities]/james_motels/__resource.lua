description "james created this."

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_script '@cframework/core/events.lua'
client_script '@cframework/client/cl_rpc.lua'
server_script '@cframework/server/sv_rpc.lua'

client_scripts {
	"client/furnishing.lua",
	"client/furnishingFunctions.lua",
	"client/functions.lua",
	"client/keys.lua",
	"client/decors.lua",
	"client/instance.lua",
	"client/storage.lua",
	"client/main.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/main.lua",
	"server/keys.lua",
	"server/functions.lua",
	"server/database.lua"
}

shared_scripts {
	"config.lua",
	"configFurnishing.lua"
}

exports {
	"AddKey",
	"RemoveKey",
	"HasKey",
	"OpenStorage",
	"EnterInstance",
	"ExitInstance"
}
