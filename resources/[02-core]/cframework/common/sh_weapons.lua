local weapons = {
-- Armas Policia 

["WEAPON_COMBATPISTOL"] = {
	label = T("WEAPON_COMBATPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "combatpistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_01")},
		{name = "combatpistol_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER")}
	}
},


["WEAPON_SMG"] = {
	label = T("WEAPON_SMG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "smg_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SMG_CLIP_01")},
		{name = "smg_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_SMG_CLIP_02")},
		{name = "smg_mag", label = "component_clip_drum", hash = GetHashKey("COMPONENT_SMG_CLIP_03")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope4", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SMG_VARMOD_LUXE")}
	}
},


["WEAPON_SMG_MK2"] = {
	label = T("WEAPON_SMG_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "smg_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SMG_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_SMG_CLIP_02")},
		{name = "clip_drum", label = "component_clip_drum", hash = GetHashKey("COMPONENT_SMG_CLIP_03")},
		{name = "compensator4", label = "component_compensator4", hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
		{name = "compensator5", label = "component_compensator5", hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
		{name = "compensator6", label = "component_compensator6", hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
		{name = "compensator7", label = "component_compensator7", hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
		{name = "compensator8", label = "component_compensator8", hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
		{name = "compensator9", label = "component_compensator9", hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
		{name = "compensator10", label = "component_compensator10", hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope4", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SMG_VARMOD_LUXE")}
	}
},


["WEAPON_PUMPSHOTGUN"] = {
	label = T("WEAPON_PUMPSHOTGUN"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor4", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_SR_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER")}
	}
},

["WEAPON_RUBBERSHOTGUN"] = {
	label = T("WEAPON_RUBBERSHOTGUN"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = false, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip_rubber"},
	components = {}
},


["WEAPON_PUMPSHOTGUN_MK2"] = {
	label = T("WEAPON_PUMPSHOTGUN_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_SR_SUPP_03")},
	}
},


["WEAPON_COMBATSHOTGUN"] = {
	label = T("WEAPON_COMBATSHOTGUN"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
	}
},


["WEAPON_CARBINERIFLE"] = {
	label = T("WEAPON_CARBINERIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "carbinerifle_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_01")},
		{name = "carbinerifle_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_02")},
		{name = "carbinerifle_mag", label = "component_clip_box", hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_03")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope3", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE")}
	}
},


["WEAPON_CARBINERIFLE_MK2"] = {
	label = T("WEAPON_CARBINERIFLE_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_02")},
		{name = "carbinerifle_barrel", label = "component_clip_drum", hash = GetHashKey("COMPONENT_AT_CR_BARREL_02")},
		{name = "compensator4", label = "component_compensator4", hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
		{name = "compensator5", label = "component_compensator5", hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
		{name = "compensator6", label = "component_compensator6", hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
		{name = "compensator7", label = "component_compensator7", hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
		{name = "compensator8", label = "component_compensator8", hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
		{name = "compensator9", label = "component_compensator9", hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
		{name = "compensator10", label = "component_compensator10", hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip2", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
	}
},


["WEAPON_DD16_B"] = {
	label = T("WEAPON_DD16_B"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
	}
},


["WEAPON_DD16_OD"] = {
	label = T("WEAPON_DD16_OD"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
	}
},


["WEAPON_DD16_C"] = {
	label = T("WEAPON_DD16_C"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
	}
},


["WEAPON_TACTICALRIFLE"] = {
	label = T("WEAPON_TACTICALRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "tactical_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_TACTICALRIFLE_CLIP_01")},
		{name = "tactical_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_TACTICALRIFLE_CLIP_02")},
		{name = "flashlight", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH_REH")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
	}
},


["WEAPON_SNIPERRIFLE"] = {
	label = T("WEAPON_SNIPERRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 2, craftable = true, item = "broken_weapon_part"},
	anim = false,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = "clip762"},
	components = {
		{name = "scope", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE")},
		{name = "scope_advanced", label = "component_scope_advanced", hash = GetHashKey("COMPONENT_AT_SCOPE_MAX")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SNIPERRIFLE_VARMOD_LUXE")}
	}
},
----------------------------------------------------------- CRIME

["WEAPON_PISTOLXM3"] = {
	label = T("WEAPON_PISTOLXM3"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = 'ammo_rounds', hash = GetHashKey('AMMO_PISTOL'), type = 'pistol_clip'},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_PISTOLXM3_CLIP_01")},
		{name = "suppressor", label = "component_suppressor", hash = GetHashKey("COMPONENT_PISTOLXM3_SUPP")},
	}
},


["WEAPON_CERAMICPISTOL"] = {
	label = T("WEAPON_CERAMICPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "clip9"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_CERAMICPISTOL_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_CERAMICPISTOL_CLIP_02")},
		{name = "suppressor6", label = "component_suppressor", hash = GetHashKey("COMPONENT_CERAMICPISTOL_SUPP")}
	}
},


["WEAPON_VINTAGEPISTOL"] = {
	label = T("WEAPON_VINTAGEPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "vintage_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_VINTAGEPISTOL_CLIP_01")},
		{name = "vintage_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_VINTAGEPISTOL_CLIP_02")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")}
	}
},


["WEAPON_APPISTOL"] = {
	label = T("WEAPON_APPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 15, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "appistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_APPISTOL_CLIP_01")},
		{name = "appistol_extended", label = "component_appistol_extended", hash = GetHashKey("COMPONENT_APPISTOL_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE")}
	}
},


["WEAPON_PISTOL50"] = {
	label = T("WEAPON_PISTOL50"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 25, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "pistol50_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_PISTOL50_CLIP_01")},
		{name = "pistol50_extended", label = "component_pistol50_extended", hash = GetHashKey("COMPONENT_PISTOL50_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE")}
	}
},


["WEAPON_HEAVYPISTOL"] = {
	label = T("WEAPON_HEAVYPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "heavypistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_01")},
		{name = "heavypistol_extended", label = "component_heavypistol_extended", hash = GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE")}
	}
},


["WEAPON_MACHINEPISTOL"] = {
	label = T("WEAPON_MACHINEPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 5, max = 10, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "tec9_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_01")},
		{name = "tec9_extended", label = "component_tec9_extended", hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_02")},
		{name = "tec9_mag", label = "component_tec9_mag", hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_03")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP")}
	}
},


["WEAPON_TECPISTOL"] = {
	label = T("WEAPON_TECPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 15, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "tecpistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_TECPISTOL_CLIP_01")},
		{name = "tec9_extended", label = "component_tec9_extended", hash = GetHashKey("COMPONENT_TECPISTOL_CLIP_02")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},

	}
},


["WEAPON_ASSAULTSMG"] = {
	label = T("WEAPON_ASSAULTSMG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 20, max = 30, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "assaultsmg_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ASSAULTSMG_CLIP_01")},
		{name = "assaultsmg_extended", label = "component_assaultsmg_extended", hash = GetHashKey("COMPONENT_ASSAULTSMG_CLIP_02")},
		{name = "flashlight3", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER")}
	}
},


["WEAPON_MICROSMG"] = {
	label = T("WEAPON_MICROSMG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 5, max = 10, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "micro_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MICROSMG_CLIP_01")},
		{name = "micro_extended", label = "component_micro_extended", hash = GetHashKey("COMPONENT_MICROSMG_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE")}
	}
},


["WEAPON_MINISMG"] = {
	label = T("WEAPON_MINISMG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "micro_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MINISMG_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MINISMG_CLIP_02")}
	}
},


["WEAPON_COMBATPDW"] = {
	label = T("WEAPON_COMBATPDW"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 25, max = 35, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SMG"), type = "pdw_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_01")},
		{name = "pdw_extended", label = "component_pdw_extended", hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_02")},
		{name = "pdw_mag", label = "component_pdw_mag", hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_03")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")}
	}
},


["WEAPON_DOUBLEACTION"] = {
	label = T("WEAPON_DOUBLEACTION"), 
	type = "weapon", limit = 1, 
	canRemove = true, 
	trade = {min = 35, max = 45, craftable = true, item = "broken_weapon_part"}, 
	anim = false, 
	kill = true, 
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "clip12"},
	components = {
	}
},


["WEAPON_GADGETPISTOL"] = {
	label = T("WEAPON_GADGETPISTOL"), 
	type  = "weapon", 
	limit = 1, 
	canRemove = true, 
	trade = {min = 35, max = 45, craftable = true, item = "broken_weapon_part"}, 
	anim = false, 
	kill = true, 
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "clip12"},
	components = {
	}
},


["WEAPON_ASSAULTRIFLE"] = {
	label = T("WEAPON_ASSAULTRIFLE"),
    type  = "weapon",
    limit = 1,
    canRemove = true,
	trade = {min = 30, max = 40, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "assaultrifle_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_01")},
		{name = "assaultrifle_extended", label = "component_assaultrifle_extended", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_02")},
		{name = "assaultrifle_mag", label = "component_assaultrifle_mag", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_03")},
		{name = "flashlight", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
		{name = "suppressor", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE")}
	}
},

["WEAPON_ASSAULTRIFLE_MK2"] = {
	label = T("WEAPON_ASSAULTRIFLE_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "assaultrifle_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_01")},
		{name = "assaultrifle_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_02")},
		{name = "assaultrifle_mag", label = "component_clip_drum", hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_03")},
		{name = "assaultrifle_barrel", label = "component_clip_default", hash = GetHashKey("COMPONENT_AT_AR_BARREL_02")},
		{name = "compensator4", label = "component_compensator4", hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
		{name = "compensator5", label = "component_compensator5", hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
		{name = "compensator6", label = "component_compensator6", hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
		{name = "compensator7", label = "component_compensator7", hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
		{name = "compensator8", label = "component_compensator8", hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
		{name = "compensator9", label = "component_compensator9", hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
		{name = "compensator10", label = "component_compensator10", hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip2", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
	}
},


["WEAPON_HEAVYRIFLE"] = {
	label = T("WEAPON_HEAVYRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "heavyrifle_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_HEAVYRIFLE_CLIP_01")},
		{name = "heavyrifle_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_HEAVYRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope3", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
	}
},



["WEAPON_ADVANCEDRIFLE"] = {
	label = T("WEAPON_ADVANCEDRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 50, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE")}
	}
},

["WEAPON_RAYCARBINE"] = {
	label = T("WEAPON_RAYCARBINE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 50, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE")}
	}
},


["WEAPON_SPECIALCARBINE"] = {
	label = T("WEAPON_SPECIALCARBINE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 30, max = 40, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "specialcarbine_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_01")},
		{name = "specialcarbine_extended", label = "component_specialcarbine_extended", hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_02")},
		{name = "specialcarbine_mag", label = "component_specialcarbine_mag", hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_03")},
		{name = "flashlight3", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope3", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER")}
	}
},


["WEAPON_SPECIALCARBINE_MK2"] = {
	label = T("WEAPON_SPECIALCARBINE_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "specialcarbine_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_01")},
		{name = "specialcarbine_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_02")},
		{name = "specialcarbine_barrel", label = "component_clip_drum", hash = GetHashKey("COMPONENT_AT_SC_BARREL_02")},
		{name = "compensator4", label = "component_compensator4", hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
		{name = "compensator5", label = "component_compensator5", hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
		{name = "compensator6", label = "component_compensator6", hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
		{name = "compensator7", label = "component_compensator7", hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
		{name = "compensator8", label = "component_compensator8", hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
		{name = "compensator9", label = "component_compensator9", hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
		{name = "compensator10", label = "component_compensator10", hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
		{name = "flashlight3", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope3", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip2", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
	}
},


["WEAPON_BULLPUPRIFLE"] = {
	label = T("WEAPON_BULLPUPRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 30, max = 40, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "bullpup_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_BULLPUPRIFLE_CLIP_01")},
		{name = "bullpup_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_BULLPUPRIFLE_CLIP_02")},
		{name = "flashlight3", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_BULLPUPRIFLE_VARMOD_LOW")}
	}
},


["WEAPON_BULLPUPRIFLE_MK2"] = {
	label = T("WEAPON_BULLPUPRIFLE_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "bullpup_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_01")},
		{name = "bullpup_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_02")},
		{name = "bullpuprifle_barrel", label = "component_clip_drum", hash = GetHashKey("COMPONENT_AT_BP_BARREL_02")},
		{name = "compensator4", label = "component_compensator4", hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
		{name = "compensator5", label = "component_compensator5", hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
		{name = "compensator6", label = "component_compensator6", hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
		{name = "compensator7", label = "component_compensator7", hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
		{name = "compensator8", label = "component_compensator8", hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
		{name = "compensator9", label = "component_compensator9", hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
		{name = "compensator10", label = "component_compensator10", hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
		{name = "flashlight3", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip2", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
	}
},


["WEAPON_COMPACTRIFLE"] = {
	label = T("WEAPON_COMPACTRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 20, max = 30, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RIFLE"), type = "compactrifle_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_01")},
		{name = "compactrifle_extended", label = "component_compactrifle_extended", hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_02")},
		{name = "compatrifle_mag", label = "component_compatrifle_mag", hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_03")}
	}
},


["WEAPON_GUSENBERG"] = {
	label = T("WEAPON_GUSENBERG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 25, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_MG"), type = "gusenberg_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_GUSENBERG_CLIP_01")},
		{name = "gusenberg_extended", label = "component_gusenberg_extended", hash = GetHashKey("COMPONENT_GUSENBERG_CLIP_02")},
	}
},



["WEAPON_MILITARYRIFLE"] = {
	label = T("WEAPON_MILITARYRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 15, max = 45, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = "clip762"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope2", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
	}
},

-------------------------------------------------------------------------------------------------- LEGAL AMMUNATION


["WEAPON_SNSPISTOL"] = {
	label = T("WEAPON_SNSPISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 3, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "sns_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SNSPISTOL_CLIP_01")},
		{name = "sns_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_SNSPISTOL_CLIP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SNSPISTOL_VARMOD_LOWRIDER")}
	}
},


["WEAPON_SNSPISTOL_MK2"] = {
	label = T("WEAPON_SNSPISTOL_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "sns_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_02")},
		{name = "compensator2", label = "component_compensator2", hash = GetHashKey("COMPONENT_AT_PI_COMP_02")},
		{name = "flashlight5", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH_03")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
	}
},


["WEAPON_PISTOL"] = {
	label = T("WEAPON_PISTOL"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 3, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "pistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_PISTOL_CLIP_01")},
		{name = "pistol_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_PISTOL_CLIP_02")},
		{name = "flashlight1", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE")}
	}
},


["WEAPON_PISTOL_MK2"] = {
	label = T("WEAPON_PISTOL_MK2"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 1, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "pistol_clip"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_02")},
		{name = "compensator1", label = "component_compensator1", hash = GetHashKey("COMPONENT_AT_PI_COMP")},
		{name = "flashlight4", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_PI_FLSH_02")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")}
	}
},


["WEAPON_SAWNOFFSHOTGUN"] = {
	label = T("WEAPON_SAWNOFFSHOTGUN"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 2, max = 5, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE")}
	}
},


["WEAPON_BULLPUPSHOTGUN"] = {
	label = T("WEAPON_BULLPUPSHOTGUN"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {min = 10, max = 20, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "bullpup_clip"},
	components = {
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor2", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
	}
},


["WEAPON_REVOLVER"] = {  -- ARMA NÃO UTILIZADA
	label = T("WEAPON_REVOLVER"), 
	type  = "weapon", limit = 1, 
	canRemove = true, trade = {}, 
	anim = false, kill = true, 
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = ""},
	components = {
	}
},


["WEAPON_MARKSMANPISTOL"] = {   -- ARMA PESCA
	label = T("WEAPON_MARKSMANPISTOL"), 
	type = "weapon", limit = 1, 
	canRemove = true, trade = {}, 
	anim = false, kill = true, 
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_PISTOL"), type = "clip12"},
	components = {
	}
},


["WEAPON_ASSAULTSHOTGUN"] = {  -- ARMA NÃO UTILIZADA
	label = T("WEAPON_ASSAULTSHOTGUN"),
    type  = "weapon",
    limit = 1,
    canRemove = true,
	trade = {min = 10, max = 15, craftable = true, item = "broken_weapon_part"},
	anim = true,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_ASSAULTSHOTGUN_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_ASSAULTSHOTGUN_CLIP_02")},
		{name = "flashlight", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
	}
},


["WEAPON_HEAVYSHOTGUN"] = {  -- ARMA NÃO UTILIZADA
	label = T("WEAPON_HEAVYSHOTGUN"),
    type  = "weapon",
    limit = 1,
    canRemove = true,
	trade = {min = 10, max = 15, craftable = true, item = "broken_weapon_part"},
	anim = false,
	kill = true,
	ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_02")},
		{name = "clip_drum", label = "component_clip_drum", hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_03")},
		{name = "flashlight", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "suppressor1", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
		{name = "grip", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
	}
},


["WEAPON_MG"] = {  -- NÂO UTILIZADA
	label = T("WEAPON_MG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {},
	anim = false,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_MG"), type = ""},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MG_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MG_CLIP_02")},
		{name = "scope1", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_02")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_MG_VARMOD_LOWRIDER")}
	}
},


["WEAPON_COMBATMG"] = {  -- NÃO UTILIZADA
	label = T("WEAPON_COMBATMG"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {},
	anim = false,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_MG"), type = ""},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_COMBATMG_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_COMBATMG_CLIP_02")},
		{name = "scope", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
		{name = "grip", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_COMBATMG_VARMOD_LOWRIDER")}
	}
},


["WEAPON_HEAVYSNIPER"] = { -- NÃO UTILIZADA
	label = T("WEAPON_HEAVYSNIPER"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {},
	anim = false,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = ""},
	components = {
		{name = "scope", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE")},
		{name = "scope_advanced", label = "component_scope_advanced", hash = GetHashKey("COMPONENT_AT_SCOPE_MAX")}
	}
},


["WEAPON_MARKSMANRIFLE"] = { -- NÃO UTILIZADA
	label = T("WEAPON_MARKSMANRIFLE"),
	type  = "weapon",
	limit = 1,
	canRemove = true,
	trade = {},
	anim = false,
	kill = true,
	ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SNIPER"), type = ""},
	components = {
		{name = "clip_default", label = "component_clip_default", hash = GetHashKey("COMPONENT_MARKSMANRIFLE_CLIP_01")},
		{name = "clip_extended", label = "component_clip_extended", hash = GetHashKey("COMPONENT_MARKSMANRIFLE_CLIP_02")},
		{name = "flashlight2", label = "component_flashlight", hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
		{name = "scope", label = "component_scope", hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM")},
		{name = "suppressor3", label = "component_suppressor", hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
		{name = "grip1", label = "component_grip", hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
		{name = "luxary_finish", label = "component_luxary_finish", hash = GetHashKey("COMPONENT_MARKSMANRIFLE_VARMOD_LUXE")}
	}
},


    ["WEAPON_DBSHOTGUN"] =        {label = T("WEAPON_DBSHOTGUN"),        type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = ""}},
	["WEAPON_STUNROD"] =          {label = T("WEAPON_STUNROD"),          type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = ""}},
    ["WEAPON_AUTOSHOTGUN"] =      {label = T("WEAPON_AUTOSHOTGUN"),      type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_shells", hash = GetHashKey("AMMO_SHOTGUN"), type = ""}},
    ["WEAPON_MUSKET"] =           {label = T("WEAPON_MUSKET"),           type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = true, item = "broken_weapon_part"}, anim = true, kill = true, components = {}, ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_SHOTGUN"), type = "clip12"}}, 
    ["WEAPON_RAILGUNXM3"] =       {label = T("WEAPON_RAILGUNXM3"),       type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = true, kill = true, ammo = {}, components = {} },
    ["WEAPON_ACIDPACKAGE"] =      {label = T("WEAPON_ACIDPACKAGE"),      type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = true, kill = true, ammo = {}, components = {} },
    ["WEAPON_CANDYCANE"] =        {label = T("WEAPON_CANDYCANE"),        type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = true, kill = true, ammo = {}, components = {} },
	["WEAPON_MINIGUN"] =          {label = T("WEAPON_MINIGUN"),          type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_MINIGUN"), type = ""}},
	["WEAPON_RAILGUN"] =          {label = T("WEAPON_RAILGUN"),          type  = "weapon", limit = 1, canRemove = true,	trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_rounds", hash = GetHashKey("AMMO_RAILGUN"), type = ""}},
	["WEAPON_STUNGUN"] =          {label = T("WEAPON_STUNGUN"),          type  = "weapon", limit = 1, canRemove = true, anim = true, components = {}},
	["WEAPON_RPG"] =              {label = T("WEAPON_RPG"),              type  = "weapon", limit = 1, canRemove = true,	trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_rockets", hash = GetHashKey("AMMO_RPG"), type = ""}},
	["WEAPON_HOMINGLAUNCHER"] =   {label = T("WEAPON_HOMINGLAUNCHER"),   type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_rockets", hash = GetHashKey("AMMO_HOMINGLAUNCHER"), type = ""}},
	["WEAPON_GRENADELAUNCHER"] =  {label = T("WEAPON_GRENADELAUNCHER"),  type  = "weapon", limit = 1, canRemove = true,	trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_grenadelauncher", hash = GetHashKey("AMMO_GRENADELAUNCHER"), type = ""}},
	["WEAPON_COMPACTLAUNCHER"] =  {label = T("WEAPON_COMPACTLAUNCHER"),  type  = "weapon", limit = 1, canRemove = true,	trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_grenadelauncher", hash = GetHashKey("AMMO_GRENADELAUNCHER"), type = ""}},
	["WEAPON_FLAREGUN"] =         {label = T("WEAPON_FLAREGUN"),         type  = "weapon", limit = 1, canRemove = true, trade = {}, components = {}, anim = false, kill = false, ammo = {label = "ammo_flaregun", hash = GetHashKey("AMMO_FLAREGUN"), type = ""}},
	["WEAPON_FIREEXTINGUISHER"] = {label = T("WEAPON_FIREEXTINGUISHER"), type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_charge", hash = GetHashKey("AMMO_FIREEXTINGUISHER"), type = ""}},
	["WEAPON_PETROLCAN"] =        {label = T("WEAPON_PETROLCAN"),        type  = "weapon", limit = 1, canRemove = true,	trade = {}, components = {}, anim = false, kill = false, ammo = {label = "ammo_petrol", hash = GetHashKey("AMMO_PETROLCAN"), type = ""}},
	["WEAPON_FIREWORK"] =         {label = T("WEAPON_FIREWORK"),         type  = "weapon", limit = 1, canRemove = true, trade = {}, components = {}, anim = false, kill = true, ammo = {label = "ammo_firework", hash = GetHashKey("AMMO_FIREWORK"), type = ""}},
	["WEAPON_FLASHLIGHT"] =       {label = T("WEAPON_FLASHLIGHT"),       type  = "weapon", limit = 1, canRemove = true, anim = true, kill = false, components = {}},
	["GADGET_PARACHUTE"] =        {label = T("GADGET_PARACHUTE"),        type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}},
	["WEAPON_KNUCKLE"] =          {label = T("WEAPON_KNUCKLE"),          type  = "weapon", limit = 1, canRemove = true,	trade = {min = 1, max = 1, craftable = true, item = "gold_ingot"}, anim = false, kill = false, components = {}},
	["WEAPON_HATCHET"] =          {label = T("WEAPON_HATCHET"),          type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}},
	["WEAPON_MACHETE"] =          {label = T("WEAPON_MACHETE"),          type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = true, item = "copper"}, anim = true, kill = false, components = {}},
	["WEAPON_SWITCHBLADE"] =      {label = T("WEAPON_SWITCHBLADE"),      type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 5, craftable = true, item = "iron"}, anim = false, kill = false, components = {}},
	["WEAPON_BOTTLE"] =           {label = T("WEAPON_BOTTLE"),           type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = false, item = "recicled_plastic"}, anim = true, kill = false, components = {}},
	["WEAPON_DAGGER"] =           {label = T("WEAPON_DAGGER"),           type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 5, craftable = false, item = "copper"}, anim = true, kill = false, components = {}},
	["WEAPON_POOLCUE"] =          {label = T("WEAPON_POOLCUE"),          type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = false, item = "wood_plank_cherry"}, anim = true, kill = false, components = {}},
	["WEAPON_WRENCH"] =           {label = T("WEAPON_WRENCH"),           type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = false, item = "copper"}, anim = true, kill = false, components = {}},
	["WEAPON_BATTLEAXE"] =        {label = T("WEAPON_BATTLEAXE"),        type  = "weapon", limit = 1, canRemove = true,	trade = {min = 1, max = 3, craftable = false, item = "wood_plank_pine"}, anim = true, kill = false, components = {}}, 
	["WEAPON_KNIFE"] =            {label = T("WEAPON_KNIFE"),            type  = "weapon", limit = 1, canRemove = true, anim = true, kill = false, components = {}},
	["WEAPON_NIGHTSTICK"] =       {label = T("WEAPON_NIGHTSTICK"),       type  = "weapon", limit = 1, canRemove = true, anim = true, kill = false, components = {}},
	["WEAPON_HAMMER"] =           {label = T("WEAPON_HAMMER"),           type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = false, item = "iron"}, anim = true, kill = false, components = {}},
	["WEAPON_BAT"] =              {label = T("WEAPON_BAT"),              type  = "weapon", limit = 1, canRemove = true,	trade = {min = 1, max = 3, craftable = true, item = "iron"}, anim = true, kill = false, components = {}},
	["WEAPON_GOLFCLUB"] =         {label = T("WEAPON_GOLFCLUB"),         type  = "weapon", limit = 1, canRemove = true, trade = {min = 1, max = 3, craftable = false, item = "iron"}, anim = true, kill = false, components = {}},
	["WEAPON_CROWBAR"] =          {label = T("WEAPON_CROWBAR"),          type  = "weapon", limit = 1, canRemove = true,	trade = {min = 1, max = 3, craftable = false, item = "scrap"}, anim = true, kill = false, components = {}},
	["WEAPON_PRESSURE1"] =        {label = T("WEAPON_PRESSURE1"),        type  = "weapon", limit = 1, canRemove = true, anim = false, kill = true, components = {}},
	["WEAPON_GRENADE"] =          {label = T("WEAPON_GRENADE"),          type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_grenade", hash = GetHashKey("AMMO_GRENADE"), type = ""}},
	["WEAPON_SMOKEGRENADE"] =     {label = T("WEAPON_SMOKEGRENADE"),     type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_smokebomb", hash = GetHashKey("AMMO_SMOKEGRENADE"), type = ""}},
	["WEAPON_STICKYBOMB"] =       {label = T("WEAPON_STICKYBOMB"),       type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_stickybomb", hash = GetHashKey("AMMO_STICKYBOMB"), type = ""}},
	["WEAPON_PIPEBOMB"] =         {label = T("WEAPON_PIPEBOMB"),         type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_pipebomb", hash = GetHashKey("AMMO_PIPEBOMB"), type = ""}},
	["WEAPON_BZGAS"] =            {label = T("WEAPON_BZGAS"),            type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_bzgas", hash = GetHashKey("AMMO_BZGAS"), type = ""}},
	["WEAPON_MOLOTOV"] =          {label = T("WEAPON_MOLOTOV"),          type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_molotov", hash = GetHashKey("AMMO_MOLOTOV"), type = ""}},
	["WEAPON_PROXMINE"] =         {label = T("WEAPON_PROXMINE"),         type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = true, components = {}, ammo = {label = "ammo_proxmine", hash = GetHashKey("AMMO_PROXMINE"), type = ""}},
	["WEAPON_SNOWBALL"] =         {label = T("WEAPON_SNOWBALL"),         type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_snowball", hash = GetHashKey("AMMO_SNOWBALL"), type = ""}},
	["WEAPON_BALL"] =             {label = T("WEAPON_BALL"),             type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_ball", hash = GetHashKey("AMMO_BALL"), type = ""}},
	["WEAPON_FLARE"] =            {label = T("WEAPON_FLARE"),            type  = "weapon", limit = 1, canRemove = true, trade = {}, anim = false, kill = false, components = {}, ammo = {label = "ammo_flare", hash = GetHashKey("AMMO_FLARE"), type = ""}}
}          


for k, weapon in pairs(weapons) do
    ESX.Items[k] = weapon
end