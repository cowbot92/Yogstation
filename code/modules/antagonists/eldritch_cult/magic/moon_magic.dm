/datum/action/cooldown/spell/jaunt/ethereal_jaunt/moon
	name = "Expedited Passage"
	desc = "A short range spell that allows you to pass unimpeded through walls."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "phaseout"
	sound = null

	school = SCHOOL_FORBIDDEN
	cooldown_time = 15 SECONDS

	spell_requirements = SPELL_CASTABLE_WITHOUT_INVOCATION | SPELL_REQUIRES_NO_ANTIMAGIC

	exit_jaunt_sound = null
	jaunt_duration = 1.5 SECONDS
	jaunt_in_time = 0.5 SECONDS
	jaunt_out_time = 0.5 SECONDS
	jaunt_in_type = /obj/effect/temp_visual/dir_setting/knock_shift
	jaunt_out_type = /obj/effect/temp_visual/dir_setting/knock_shift/out

/datum/action/cooldown/spell/jaunt/ethereal_jaunt/moon/do_steam_effects()
	return

/obj/effect/temp_visual/dir_setting/moon_shift
	name = "knock_shift"
	icon = 'icons/mob/mob.dmi'
	icon_state = "phasein"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/dir_setting/moon_shift/out
	icon_state = "phaseout"
