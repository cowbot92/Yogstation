/datum/eldritch_knowledge/base_moon
	name = "A Locksmith's Secret"
	desc = "Opens up the Path of Knock to you. \
		Allows you to transmute a knife and a crowbar into a Key Blade. Additionally, your grasp will open up numerous locked things when used upon them."
	gain_text = "The Knock permits no seal and no isolation. It thrusts us gleefully out of the safety of ignorance."
	unlocked_transmutations = list(/datum/eldritch_transmutation/knock_knife)
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

/datum/eldritch_knowledge/moon_grasp/proc/on_mansus_grasp(mob/living/source, mob/living/target)
	SIGNAL_HANDLER
	source.apply_status_effect(/datum/status_effect/moon_grasp_hide)

	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	to_chat(carbon_target, span_danger("You hear echoing laughter from above"))
