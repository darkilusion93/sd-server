Config = {}

-- To enable discord logs go to line 2 of the server.lua and paste your discord webhook between the quotes.
Config.admin_groups = {"admin","superadmin", "mod"} -- groups that can use admin commands
Config.banformat = "BANNED!\nReason: %s\nExpires: %s\nBanned by: %s (Ban ID: #%s)" -- message shown when banned (1st %s = reason, 2nd %s = expire, 3rd %s = banner, 4th %s = ban id)
Config.popassistformat = "Jogador %s está a pedir ajuda\nEscreve <span class='text-success'>/aceitar %s</span> para aceitar ou <span class='text-danger'>/negar</span> para negar" -- popup assist message format
Config.chatassistformat = "ID %s ^4Razão^7: %s" -- chat assist message format
Config.assist_keys = {enable=true,accept=82,decline=81} -- keys for accepting/declining assist messages (default = page up, page down) - https://docs.fivem.net/game-references/controls/
Config.warning_screentime = 7.5 -- warning display length (in seconds)
Config.backup_kick_method = false -- set this to true if banned players don't get kicked when banned or they can re-connect after being banned.
Config.kick_without_steam = true -- prevent a player from joining your server without a steam identifier.
Config.page_element_limit = 250
