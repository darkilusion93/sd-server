Config = {}

Config.Locale = 'br'

Config.serverLogo = 'img/logo.png'

Config.font = {
	name 	= 'Montserrat',
	url 	= 'https://fonts.googleapis.com/css?family=Montserrat:300,400,700,900&display=swap'
}

Config.date = {
	format	 	= 'withHours',
	AmPm		= true
}

Config.voice = {

	levels = {
		default = 6.0,
		shout = 15.0,
		whisper = 1.5,
		current = 0
	},
	
	keys = {
		distance 	= 'L',
	}
}


Config.vehicle = {
	speedUnit = 'KMH',
	maxSpeed = 1000,

	seatbelt = {
		playBuckleSound 	= true,
		playUnbuckleSound 	= true,
		playUnsafeSound 	= false
	},

	keys = {
		seatbelt 	= 29,
		cruiser		= 246,
		signalLeft	= 174,
		signalRight	= 175,
		signalBoth	= 173,
	}
}

Config.ui = {
	showServerLogo		= true,

	showJob		 		= false,

	showWalletMoney 	= false,
	showBankMoney 		= false,
	showBlackMoney 		= false,
	showSocietyMoney	= false,

	showDate 			= true,
	showLocation 		= true,
	showVoice	 		= true,

	showHealth			= true,
	showArmor	 		= true,
	showStamina	 		= true,
	showHunger 			= true,
	showThirst	 		= true,

	showMinimap			= true,

	showWeapons			= true,	
}