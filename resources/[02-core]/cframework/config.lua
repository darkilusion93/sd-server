--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

Config                      = {}
Config.Locale               = 'br'

Config.Accounts             = { 'black_money' }
Config.AccountLabels        = { black_money = T("CURRENCY_BLACK_MONEY") }
Config.IVA                  = 0.15

Config.EnableSocietyPayouts = true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.DisableWantedLevel   = false
Config.EnableHud            = false -- enable the default hud? Display current job and accounts (black, bank & cash)

Config.PaycheckInterval     = 40 * 60000

Config.EnableDebug          = false






--Centro de emprego
Config.DrawDistancejob = 50.0
Config.MarkerSizejob     = {x = 2.0, y = 2.0, z = 0.4}
Config.MarkerColorjob  = {r = 0, g = 100, b = 255}
Config.MarkerTypejob   = 1

Config.Joblisting = {
  vector3(-265.0, -963.6, 30.2),
  --vector3(-114.81, 6470.81, 30.63),
  vector3(1767.85, 3652.83, 33.89),
}

--Prisão
Config.JailPositions = {
	["Cell"] = { ["x"] = 1693.14, ["y"] = 2449.23, ["z"] = 45.65, ["h"] = 356.67 }
}

Config.Cutscene = {
	["PhotoPosition"] = { ["x"] = 402.91567993164, ["y"] = -996.75970458984, ["z"] = -99.000259399414, ["h"] = 186.22499084473 },

	["CameraPos"] = { ["x"] = 402.88830566406, ["y"] = -1003.8851318359, ["z"] = -97.419647216797, ["rotationX"] = -15.433070763946, ["rotationY"] = 0.0, ["rotationZ"] = -0.31496068835258, ["cameraId"] = 0 },

	["PolicePosition"] = { ["x"] = 402.91702270508, ["y"] = -1000.6376953125, ["z"] = -99.004028320313, ["h"] = 356.88052368164 }
}

Config.PrisonWork = {
	["DeliverPackage"] = { ["x"] = 1027.2347412109, ["y"] = -3101.419921875, ["z"] = -38.999870300293, ["h"] = 267.89135742188 },

	["Packages"] = {
		[1] = { ["x"] = 1003.6661987305, ["y"] = -3108.4221191406, ["z"] = -38.999866485596, ["state"] = true },
		[2] = { ["x"] = 1006.0420532227, ["y"] = -3103.0024414063, ["z"] = -38.999866485596, ["state"] = true },
		[3] = { ["x"] = 1015.7958374023, ["y"] = -3102.8337402344, ["z"] = -38.99991607666,  ["state"] = true },
		[4] = { ["x"] = 1012.8907470703, ["y"] = -3108.2907714844, ["z"] = -38.999912261963, ["state"] = true },
		[5] = { ["x"] = 1018.2017822266, ["y"] = -3109.1982421875, ["z"] = -38.999897003174, ["state"] = true },
		[6] = { ["x"] = 1018.0194091797, ["y"] = -3096.5700683594, ["z"] = -38.999897003174, ["state"] = true },
		[7] = { ["x"] = 1015.6422119141, ["y"] = -3091.7392578125, ["z"] = -38.999897003174, ["state"] = true },
		[8] = { ["x"] = 1010.7862548828, ["y"] = -3096.6135253906, ["z"] = -38.999897003174, ["state"] = true },
		[9] = { ["x"] = 1005.7819824219, ["y"] = -3096.8415527344, ["z"] = -38.999897003174, ["state"] = true },
		[10] = { ["x"] = 1003.4543457031, ["y"] = -3096.7048339844, ["z"] = -38.999897003174, ["state"] = true }
	}
}

Config.Teleports = {
	["Prison Work"] = { 
		["x"] = 992.51770019531, 
		["y"] = -3097.8413085938, 
		["z"] = -38.995861053467, 
		["h"] = 81.15771484375, 
		["goal"] = { 
			"Prisão" 
		} 
	},

	["Boiling Broke"] = { 
		["x"] = 1845.6022949219, 
		["y"] = 2585.8029785156, 
		["z"] = 45.672061920166, 
		["h"] = 92.469093322754, 
		["goal"] = { 
			"Segurança" 
		} 
	},

	["Jail"] = { 
		["x"] = 1800.6979980469, 
		["y"] = 2483.0979003906, 
		["z"] = -122.68814849854, 
		["h"] = 271.75274658203, 
		["goal"] = { 
			"Trabalho da prisão", 
			"Segurança", 
			"Visitas" 
		} 
	},

	["Security"] = { 
		["x"] = 1706.7625732422,
		["y"] = 2581.0793457031, 
		["z"] = -69.407371520996, 
		["h"] = 267.72802734375, 
		["goal"] = { 
			"Prisão",
			"Prisão"
		} 
	},

	["Visitor"] = {
		["x"] = 1699.7196044922, 
		["y"] = 2574.5314941406, 
		["z"] = -69.403930664063, 
		["h"] = 169.65020751953, 
		["goal"] = { 
			"Prisão" 
		} 
	} 
}


Config.Properties               = {} -- Create a empty table for properties around the map

----------------------------------------------------
-------- Intervalles en secondes -------------------
----------------------------------------------------

-- Temps d'attente Antispam / Waiting time for antispam
Config.AntiSpamTimer = 6

-- Vérification et attribution d'une place libre / Verification and allocation of a free place
Config.TimerCheckPlaces = 1

-- Mise à jour du message (emojis) et accès à la place libérée pour l'heureux élu / Update of the message (emojis) and access to the free place for the lucky one
Config.TimerRefreshClient = 3

-- Mise à jour du nombre de points / Number of points updating
Config.TimerUpdatePoints = 6

----------------------------------------------------
------------ Nombres de points ---------------------
----------------------------------------------------

-- Nombre de points gagnés pour ceux qui attendent / Number of points earned for those who are waiting
Config.AddPoints = 1

-- Nombre de points perdus pour ceux qui sont entrés dans le serveur / Number of points lost for those who entered the server
Config.RemovePoints = 1

-- Nombre de points gagnés pour ceux qui ont 3 emojis identiques (loterie) / Number of points earned for those who have 3 identical emojis (lottery)
Config.LoterieBonusPoints = 250

-- Accès prioritaires / Priority access
Config.Points = {}

----------------------------------------------------
------------- Textes des messages ------------------
----------------------------------------------------

-- Si steam n'est pas détecté / If steam is not detected
 Config.NoSteam = "Inicia a Steam antes de entrar na cidade."

-- Message d'attente / Waiting text
 Config.EnRoute = "Estás na fila de espera. Já percorreste"

-- "points" traduits en langage RP / "points" for RP purpose
 Config.PointsRP = "Kilometros"

-- Position dans la file / position in the queue
 Config.Position = "Estás na posição "

-- Texte avant les emojis / Text before emojis
 Config.EmojiMsg = "Se os emojis pararem, reinicia o teu jogo: "

-- Quand le type gagne à la loterie / When the player win the lottery
 Config.EmojiBoost = "!!! Parabéns, " .. Config.LoterieBonusPoints .. " " .. Config.PointsRP .. " ganhaste !!!"

-- Anti-spam message / anti-spam text
 Config.PleaseWait_1 = "A Entrar"
 Config.PleaseWait = {
	 '.........................',
	 '..........................',
	 '...........................',
	 '............................',
	 '.............................',
	 '..............................',
	 '...............................',
	 '................................',
 }

-- Me devrait jamais s'afficher / Should never be displayed
 Config.Accident = " ERRO : REINICIA E CONTACTA O SUPORTE! "

-- En cas de points négatifs / In case of negative points
 Config.Error = " ERRO : REINICIA E CONTACTA O SUPORTE! Pontos Negativos"


Config.EmojiList = {
	'🐌', 
	'🐍',
	'🐎', 
	'🐑', 
	'🐒',
	'🐘', 
	'🐙', 
	'🐛',
	'🐜',
	'🐝',
	'🐞',
	'🐟',
	'🐠',
	'🐡',
	'🐢',
	'🐤',
	'🐦',
	'🐧',
	'🐩',
	'🐫',
	'🐬',
	'🐲',
	'🐳',
	'🐴',
	'🐅',
	'🐈',
	'🐉',
	'🐋',
	'🐀',
	'🐇',
	'🐏',
	'🐐',
	'🐓',
	'🐕',
	'🐖',
	'🐪',
	'🐆',
	'🐄',
	'🐃',
	'🐂',
	'🐁',
	'🔥'
}


Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = { x = 1.3, y = 1.3, z = 0.3}
Config.MarkerColor                = { r = 255, g = 255, b = 255 }
Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- only turn this on if you are using esx_identity
Config.EnableNonFreemodePeds      = false -- turn this on if you want custom peds
Config.EnableSocietyOwnedVehicles = true
--Config.EnableMoneyWash            = true
Config.EnableLicenses             = false
Config.MaxInService               = -1

Config.ReviveReward               = 150  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?

Config.modifierkey = 21 -- Left Shift
Config.code1key = 157 -- 1
Config.code2key = 158 -- 2
Config.code3key = 160 --  3
Config.code99key = 164 --  4

local second = 1000
local minute = 60 * second

-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 30 * minute

-- How much time before a menu opens to ask the player if he wants to respawn at hospital now
-- The player is not obliged to select YES, but he will be auto respawn
-- at the end of RespawnDelayAfterRPDeath just above.
Config.RespawnToHospitalMenuTimer   = true
Config.MenuRespawnToHospitalDelay   = 10 * minute

Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true

-- Will display a timer that shows RespawnDelayAfterRPDeath time remaining
Config.ShowDeathTimer               = true

-- The player can have a fine (on bank account)
Config.RespawnFine                  = true
Config.RespawnFineAmount            = 500

-------------------------------------------------------------------------------------------FACÇÕES---------------------------------------------------------------------------------------------------

Config.Stations = {}

