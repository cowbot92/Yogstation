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

/datum/action/cooldown/spell/pointed/moon_smile
	name = "Smile of the moon"
	desc = "Lets you turn the gaze of the moon on someone \
			temporarily confusing, blinding, muting, and deafening a single target."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "moon_smile"
	ranged_mousepointer = 'icons/effects/mouse_pointers/moon_target.dmi'

	sound = 'sound/magic/blind.ogg'
	school = SCHOOL_FORBIDDEN
	cooldown_time = 20 SECONDS

	invocation = "Mo'N S'M'LE"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_CASTABLE_WITHOUT_INVOCATION | SPELL_REQUIRES_NO_ANTIMAGIC
	cast_range = 6

	active_msg = "You prepare to let them see the true face..."

/datum/action/cooldown/spell/pointed/moon_smile/can_cast_spell(feedback = TRUE)
	return ..() && isliving(owner)

/datum/action/cooldown/spell/pointed/moon_smile/is_valid_target(atom/cast_on)
	return ..() && ishuman(cast_on)

/datum/action/cooldown/spell/pointed/moon_smile/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_notice("The moon turns, its smile no longer set on you."))
		to_chat(owner, span_warning("The moon does not smile upon them."))
		return FALSE

	playsound(cast_on, 'sound/hallucinations/i_see_you1.ogg', 50, 1)
	to_chat(cast_on, span_warning("Your eyes cry out in pain, your ears bleed and your lips seal! THE MOON SMILES UPON YOU!"))
	cast_on.adjust_blindness(3 SECONDS)
	cast_on.set_eye_blur_if_lower(3 SECONDS)
	cast_on.adjustEarDamage(100)
	cast_on.adjust_silence(5 SECONDS)
	cast_on.adjust_confusion(10 SECONDS)

	return TRUE

