/datum/eldritch_knowledge/base_moon
	name = "Moonlight Troupe"
	desc = "Opens up the Path of Moon to you. \
		Allows you to transmute 2 sheets of iron and a knife into an Lunar Blade."
	gain_text = "Under the light of the moon the laughter echoes."
	unlocked_transmutations = list(/datum/eldritch_transmutation/moon_knife)
	cost = 1
	route = PATH_MOON
	tier = TIER_PATH

/datum/eldritch_knowledge/base_moon/on_gain(mob/user)
	. = ..()

	var/datum/action/cooldown/spell/touch/mansus_grasp/moon_grasp = locate() in user.actions
	moon_grasp?.cooldown_time = 20 SECONDS
	var/obj/realknife = new /obj/item/melee/sickly_blade/moon
	user.put_in_hands(realknife)
	
	var/datum/action/cooldown/spell/basic_jaunt = locate(/datum/action/cooldown/spell/jaunt/ethereal_jaunt/basic) in user.actions
	if(basic_jaunt)
		basic_jaunt.Remove(user)
	var/datum/action/cooldown/spell/jaunt/ethereal_jaunt/moon/moon_jaunt = new(user)
	moon_jaunt.Grant(user)

	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/eldritch_knowledge/base_moon/on_lose(mob/user)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/eldritch_knowledge/base_moon/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	target.adjust_confusion(10 SECONDS)
	to_chat(carbon_target, span_danger("You hear echoing laughter from above"))

/datum/eldritch_knowledge/spell/moon_smile
	name = "T1 - Smile of the Moon"
	gain_text = "The moon shines bright upon all who surround it, though many scorn it's rays and are sundered for it."
	desc = "Confuse, Blind, Deafen, and Mute a single target temporarily."
	cost = 1
	spell_to_add = /datum/action/cooldown/spell/pointed/moon_smile
	route = PATH_MOON
	tier = TIER_1

/datum/eldritch_knowledge/moon_mark
	name = "Grasp Mark - Mark of Moon"
	gain_text = "The troupe on the moon would dance all day long \
		and in that dance the moon would smile upon us \
		but when the night came its smile would dull forced to gaze on the earth."
		
	desc = "Your Mansus Grasp now applies the Mark of Moon, pacifying the victim until attacked. \
		The mark can also be triggered from an attack with your Moon Blade, leaving the victim confused."
	cost = 2
	route = PATH_MOON
	tier = TIER_MARK

/datum/eldritch_knowledge/moon_mark/on_gain(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK, PROC_REF(on_mansus_grasp))

/datum/eldritch_knowledge/moon_mark/on_lose(mob/user, datum/antagonist/heretic/our_heretic)
	UnregisterSignal(user, COMSIG_HERETIC_MANSUS_GRASP_ATTACK)

/datum/eldritch_knowledge/moon_mark/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER

	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/eldritch/moon)
