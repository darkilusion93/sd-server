

local animations <const> = {
    {
        name  = 'party',
        label = T("ANIMATIONS_PARTY"),
        items = {
            {label = T("ANIMATIONS_PLAYDRUMS"), type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
            {label = T("ANIMATIONS_DJ"), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
            {label = T("ANIMATIONS_PLAYGUITAR"), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
            {label = T("ANIMATIONS_GIVE_FUCK"), type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
            {label = T("ANIMATIONS_ROCKNROLL"), type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
            {label = T("ANIMATIONS_DRUNK"), type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
            {label = T("ANIMATIONS_PUKEINCAR"), type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}},
        }
    },
    {
        name  = 'greet',
        label = T("ANIMATIONS_GREET"),
        items = {
            {label = T("ANIMATIONS_HI"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
            {label = T("ANIMATIONS_HANDSHAKE"), type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
            {label = T("ANIMATIONS_FISTBUMP"), type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
            {label = T("ANIMATIONS_COOL_HANDSHAKE"), type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
            {label = T("ANIMATIONS_MILITARY_CONTINENCE"), type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
        }
    },
    {
        name  = 'work',
        label = T("ANIMATIONS_WORK"),
        items = {
            {label = T("ANIMATIONS_SURRENDER"), type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
            {label = T("ANIMATIONS_FISHING"), type = "scenario", data = {anim = "world_human_stand_fishing"}},
            {label = T("ANIMATIONS_SEARCH_FLOOR"), type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
            {label = T("ANIMATIONS_TALK_ON_RADIO"), type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
            {label = T("ANIMATIONS_CONTROL_AIR_TRAFIC"), type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
            {label = T("ANIMATIONS_MINE_FLOOR"), type = "scenario", data = {anim = "world_human_gardener_plant"}},
            {label = T("ANIMATIONS_WORK_ON_FLOOR"), type = "scenario", data = {anim = "world_human_vehicle_mechanic"}},
            {label = T("ANIMATIONS_REPAIR_MOTOR"), type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
            {label = T("ANIMATIONS_EXAMINE"), type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
            {label = T("ANIMATIONS_TALK_WITH"), type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
            {label = T("ANIMATIONS_GIVE_MONEY"), type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
            {label = T("ANIMATIONS_CARRY_SOMETHING"), type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
            {label = T("ANIMATIONS_SERVE_DRINK"), type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
            {label = T("ANIMATIONS_TAKE_PICTURE"), type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
            {label = T("ANIMATIONS_CARRY_PLANK"), type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
            {label = T("ANIMATIONS_HAMMER_WALL"), type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
            {label = T("ANIMATIONS_CARRY_PLATE"), type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
            {label = T("ANIMATIONS_HUMAN_STATUE"), type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
        }
    },
    {
        name  = 'action',
        label = T("ANIMATIONS_ACTION"),
        items = {
            {label = T("ANIMATIONS_CLAP_HANDS"), type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
            {label = T("ANIMATIONS_CHILL"), type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
            {label = T("ANIMATIONS_POINT"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
            {label = T("ANIMATIONS_CALL"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}},
            {label = T("ANIMATIONS_WHAT_IS_THIS"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
            {label = T("ANIMATIONS_ME"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
            {label = T("ANIMATIONS_ROB"), type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
            {label = T("ANIMATIONS_DISAPPOINTED"), type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
            {label = T("ANIMATIONS_HOLD_UP"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
            {label = T("ANIMATIONS_SCARED"), type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
            {label = T("ANIMATIONS_FEAR"), type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
            {label = T("ANIMATIONS_FIGHT"), type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
            {label = T("ANIMATIONS_WHAT_A_SHIT"), type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
            {label = T("ANIMATIONS_KISS"), type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
            {label = T("ANIMATIONS_FUCK"), type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
            {label = T("ANIMATIONS_HANDJOB"), type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
            {label = T("ANIMATIONS_SUICIDE"), type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
        }
    },
    {
        name  = 'sports',
        label = T("ANIMATIONS_SPORTS"),
        items = {
            {label = T("ANIMATIONS_STRECH"), type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
            {label = T("ANIMATIONS_LIFT_WEIGHT"), type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
            {label = T("ANIMATIONS_PUSH_UP"), type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
            {label = T("ANIMATIONS_ABDOMINAL"), type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
            {label = T("ANIMATIONS_YOGA"), type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
        }
    },
    {
        name  = 'other',
        label = T("ANIMATIONS_OTHER"),
        items = {
            {label = T("ANIMATIONS_DRINK_COFFEE"), type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
            {label = T("ANIMATIONS_PLAY_ON_PHONE"), type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
            {label = T("ANIMATIONS_SIT_ON_FLOOR"), type = "scenario", data = {anim = "WORLD_HUMAN_PICNIC"}},
            {label = T("ANIMATIONS_LEAN_ON"), type = "scenario", data = {anim = "world_human_leaning"}},
            {label = T("ANIMATIONS_LAY_ON_BACK"), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
            {label = T("ANIMATIONS_LAY_ON_FRONT"), type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
            {label = T("ANIMATIONS_CLEAN_GLASS"), type = "scenario", data = {anim = "world_human_maid_clean"}},
            {label = T("ANIMATIONS_GRILL"), type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
            {label = T("ANIMATIONS_TITANIC"), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
            {label = T("ANIMATIONS_TAKE_SELFIE"), type = "scenario", data = {anim = "world_human_tourist_mobile"}},
            {label = T("ANIMATIONS_LISTEN"), type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}},
        }
    },
	{
		name  = 'attitude',
		label = T("ANIMATIONS_ATTITUDE"),
		items = {
            {label = T("ANIMATIONS_WALK_NORMAL_M"), type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
            {label = T("ANIMATIONS_WALK_NORMAL_F"), type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
            {label = T("ANIMATIONS_WALK_DEPRESSIVE_M"), type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
            {label = T("ANIMATIONS_WALK_DEPRESSIVE_F"), type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
            {label = T("ANIMATIONS_WALK_BUSINESSMAN"), type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
            {label = T("ANIMATIONS_WALK_DETERMINED"), type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
            {label = T("ANIMATIONS_WALK_CASUAL"), type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
            {label = T("ANIMATIONS_WALK_ARMS_WIDE"), type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
            {label = T("ANIMATIONS_WALK_HIPSTER"), type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
            {label = T("ANIMATIONS_WALK_LIMPING"), type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
            {label = T("ANIMATIONS_WALK_INTIMIDATED"), type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
            {label = T("ANIMATIONS_WALK_INJURED"), type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
            {label = T("ANIMATIONS_WALK_SAD"), type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
            {label = T("ANIMATIONS_WALK_MUSCLED"), type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
            {label = T("ANIMATIONS_WALK_SHOCKED"), type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
            {label = T("ANIMATIONS_WALK_SHADY"), type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
            {label = T("ANIMATIONS_WALK_TIRED"), type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
            {label = T("ANIMATIONS_WALK_HURRY"), type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
            {label = T("ANIMATIONS_WALK_PARADE"), type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
            {label = T("ANIMATIONS_WALK_FAST"), type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
            {label = T("ANIMATIONS_WALK_MANEATER"), type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
            {label = T("ANIMATIONS_WALK_SASSY"), type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
            {label = T("ANIMATIONS_WALK_DELICATE"), type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	},
    --[[{
        name  = '+18',
        label = T("ANIMATIONS_PLUS18"),
        items = {
            {label = T("ANIMATIONS_CAR_RECEIVE_BLOWJOB"), type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
            {label = T("ANIMATIONS_CAR_GIVE_BLOWJOB"), type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
            {label = T("ANIMATIONS_CAR_SEX_M"), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
            {label = T("ANIMATIONS_CAR_SEX_F"), type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
            {label = T("ANIMATIONS_SCRATH_BALLS"), type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
            {label = T("ANIMATIONS_INSINUATE"), type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
            {label = T("ANIMATIONS_HAND_ON_WAIST"), type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
            {label = T("ANIMATIONS_SHAKE_BREASTS"), type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
            {label = T("ANIMATIONS_STRIP_1"), type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
            {label = T("ANIMATIONS_STRIP_2"), type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
            {label = T("ANIMATIONS_STRIP_3"), type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
        }
    },]]
}

local function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, 1.0)
	end)
end

local function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

local function startScenario(anim)
	TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

local function openAnimationsSubMenu(menu)
	local title    = nil
	local elements = {}

	for i=1, #animations, 1 do
		if animations[i].name == menu then
			title = animations[i].label

			for j=1, #animations[i].items, 1 do
				table.insert(elements, {
					label = animations[i].items[j].label,
					type  = animations[i].items[j].type,
					value = animations[i].items[j].data
				})
			end

			break

		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations_sub',
	{
		title    = title,
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		local type = data.current.type
		local lib  = data.current.value.lib
		local anim = data.current.value.anim

		if type == 'scenario' then
			startScenario(anim)
		elseif type == 'attitude' then
			startAttitude(lib, anim)
		elseif type == 'anim' then
			startAnim(lib, anim)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function OpenAnimationsMenu()
	local elements = {}

	for i=1, #animations, 1 do
		table.insert(elements, {label = animations[i].label, value = animations[i].name})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'animations',
	{
		title    = T("ANIMATIONS_TITLE"),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		openAnimationsSubMenu(data.current.value)
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("esx_animations:menu", function()
    if not IsPedInAnyVehicle(PlayerPedId(), false) and GetLastInputMethod(2) and not ESX.isPlayerDead() then
        OpenAnimationsMenu()
        ClearPedTasks(PlayerPedId())
    end
end)
