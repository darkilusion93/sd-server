Config, Locales = {}, {}

Config.Locale = 'pt' -- en / pt / gr / fr / de

Config.ESX11 = true -- set it to true if you are using ESX 1.1

Config.okokTextUI = true -- true = okokTextUI (I recommend you using this since it is way more optimized than the default ShowHelpNotification) | false = ShowHelpNotification

Config.UseOkOkBankingSounds = true -- true = Uses Sounds | false = No sounds

Config.UseTargetOnAtm = false -- Using ox_target or q-target and not TextUI to access to the atms

Config.UseTargetOnBank = false -- Using ox_target or q-target and not TextUI to access to the bank

Config.TargetBankDistance = 1.5 -- Distance to target a bank from ox_target or q-target ( To change the distance to ATM check line 66)

Config.DebugTargetZones = false -- Set to true only if you need to check the position of a zone

Config.IBANPrefix = "PT" -- IBAN prefix

Config.IBANNumbers = 6 -- How many characters the IBAN has by default

Config.CustomIBANMaxChars = 10 -- How many characters the IBAN can have when changing it to a custom one (on Settings tab)

Config.CustomIBANAllowLetters = false -- If the custom IBAN can have letters or only numbers (on Settings tab)

Config.IBANChangeCost = 10000 -- How much it costs to change the IBAN to a custom one (on Settings tab)

Config.PINChangeCost = 5000 -- How much it costs to change the PIN (on Settings tab)

Config.AnimTime = 2 -- Seconds (ATM animation)

Config.UseAddonAccount = true -- If true it will use the addon_account_data table | If false the okokbanking_societies table

Config.RequireCreditCardForATM = false -- Set to true if you would like players to access the ATM with a card item | If false there is no item requirement

Config.CreditCardItem = "cartaoDebito" -- Required item to access the ATM

Config.CreditCardPrice = 500 -- How much it costs to purchase a credit card

Config.UseSteamNames = false -- If true it will use steam name | If false, the character name

Config.Locale = 'pt'

Config.Societies = { -- Which societies have bank accounts
	"unicorn",
	"snake",
	"yakuza",
	"galaxy",
	"vigne",
	"vagos",
	"usados",
	"offroad",
	"tequilla",
	"state",
	"sheriff",
	"sata",
	"revisao",
	"reporter",
	"ranger",
	"purple",
	"police",
	"pj",
	"party",
	"navy",
	"municipal",
	"mungiki",
	"mob",
	"mechanic",
	"mafia",
	"grove",
	"golf",
	"gang",
	"docks",
	"coast",
	"casino",
	"cartel",
	"black",
	"ballas",
	"ammunation",
	"ambulance"
}

Config.SocietyAccessRanks = { -- Which ranks of the society have access to it
	"boss",
}

Config.ShowBankBlips = true

Config.BankLocations = { -- To get blips and colors check this: https://wiki.gtanet.work/index.php?title=Blips
	{blip = 108, blipColor = 2, blipScale = 0.6, x = 150.266, y = -1040.203, z = 29.374, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(149.07, -1041.02, 29.55), size = vec3(2.85, 0.30, 1.30), rotation = 70, maxZ = 30.9}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = -1212.980, y = -330.841, z = 37.787, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(-1212.98, -331.53, 38.0), size = vec3(2.85, 0.40, 1.30), rotation = 117, maxZ = 39.25}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = -2962.582, y = 482.627, z = 15.703, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(-2962.00, 482.20, 15.92), size = vec3(2.85, 0.40, 1.30), rotation = 178, maxZ = 17.1}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = -112.202, y = 6469.295, z = 31.626, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(-111.69, 6469.5, 31.83), size = vec3(4.2, 0.40, 1.25), rotation = 45, maxZ = 33.15}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = 314.187, y = -278.621, z = 54.170, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(313.26, -279.38, 54.35), size = vec3(2.85, 0.40, 1.30), rotation = 250, maxZ = 55.7}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = -351.534, y = -49.529, z = 49.042, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(-351.81, -50.2, 49.24), size = vec3(2.85, 0.30, 1.30), rotation = 250, maxZ = 50.5}},
	{blip = 108, blipColor = 3, blipScale = 0.6, x = 253.38, y = 220.79, z = 106.29, blipText = "Banco Principal", BankDistance = 3, boxZone = {pos = vec3(252.8, 221.9, 106.20), size = vec3(3.6, 0.20, 1.70), rotation = 250, maxZ = 107.6}},
	{blip = 108, blipColor = 2, blipScale = 0.6, x = 1175.064, y = 2706.643, z = 38.094, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(1175.72, 2707.36, 38.30), size = vec3(2.85, 0.40, 1.30), rotation = 270, maxZ = 39.5}},
	{blip = 108, blipColor = 2, blipScale = 0.6,x = -1040.51, y = -2845.72, z = 27.717, blipText = "Banco", BankDistance = 3, boxZone = {pos = vec3(-1040.51, -2845.72, 27.717), size = vec3(2.85, 0.40, 1.30), rotation = 270, maxZ = 39.5}},

}

Config.ATMDistance = 1.5 -- How close you need to be in order to access the ATM

Config.ATM = { -- ATM models, do not remove any
	{model = -870868698}, 
	{model = -1126237515}, 
	{model = -1364697528}, 
	{model = 506770882}
}



function _L(id)
    if Locales[Config.Locale][id] then
        return Locales[Config.Locale][id]
    else
        print("Locale '"..id.."' doesn't exist")
    end
end