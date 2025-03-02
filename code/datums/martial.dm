/**
  *
  * Martial Arts
  *
  * Martial arts change how human unarmed attacks effect other humans, and allow for strings of attacks on the same target to have special effects
  * Martial arts also can block melee or ranged attacks using block_chance and deflect_chance variables
  */

/datum/martial_art
	///the name of the martial art
	var/name = "Martial Art"
	///ID, used by mind/has_martialart
	var/id = ""
	///current streak, successful attacks add to this
	var/streak = ""
	///longest a streak can be before the oldest attack is forgotten
	var/max_streak_length = 6
	///current thing being targetted for combos, switches if the user hits a different opponent
	var/current_target
	var/datum/martial_art/base // The permanent style. This will be null unless the martial art is temporary
	///chance for the martial art to block a melee attack when throw is on
	var/block_chance = 0
	///used for CQC's restrain combo
	var/restraining = 0
	///verb used to get a description of the art
	var/help_verb
	///forbid use of guns if martial art is active
	var/no_guns = FALSE
	///check for if the martial art can be used by pacifists
	var/nonlethal = FALSE
	///if the martial art can be overridden by temporary arts
	var/allow_temp_override = TRUE
	///the message for when you try to use a gun you can't use
	var/no_gun_message = "Use of ranged weaponry would bring dishonor to the clan."
	///used to allow certain guns as exceptions
	var/list/gun_exceptions = list()
	///list of traits given to the martial art user
	var/list/martial_traits = list()
	///the mob that uses this martial art
	var/mob/living/martial_owner

/**
  * martial art specific disarm attacks
  *
  * used to give a martial art a unique attack on disarm, returns FALSE if a basic hit should be done afterwards, TRUE if it should only do the unique stuff
  */
/datum/martial_art/proc/disarm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/**
  * martial art specific harm attacks
  *
  * used to give a martial art a unique attack on harm, returns FALSE if a basic hit should be done afterwards, TRUE if it should only do the unique stuff
  */
/datum/martial_art/proc/harm_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/**
  * martial art specific grab attacks
  *
  * used to give a martial art a unique attack on grab, returns FALSE if a basic hit should be done afterwards, TRUE if it should only do the unique stuff
  */
/datum/martial_art/proc/grab_act(mob/living/carbon/human/A, mob/living/carbon/human/D)
	return FALSE

/**
  * martial art handle counter proc
  *
  * handles unique stuff on a martial art melee counter activating
  */
/datum/martial_art/proc/handle_counter(mob/living/carbon/human/user, mob/living/carbon/human/attacker)
	return

/**
  * martial art can_use proc
  *
  * used to checks specific information regarding whether or not someone can use the martial art, returns TRUE if they can, FALSE if they can't
  */
/datum/martial_art/proc/can_use(mob/living/carbon/human/H)
	return TRUE

/**
  * martial art add to streak proc
  *
  * used to add a character to a streak, up to the maximum streak size. forgets the oldest character in the streak if it would go above the maximum size.
  * streaks are on a per person basis, and streaks will be lost if a new target is hit
  */
/datum/martial_art/proc/add_to_streak(element,mob/living/carbon/human/D)
	if(D != current_target)
		current_target = D
		streak = ""
		restraining = 0
	streak = streak+element
	if(length(streak) > max_streak_length)
		streak = copytext(streak, 1 + length(streak[1]))
	return

/**
  * martial art basic hit
  *
  * used for basic punch attacks
  */
/datum/martial_art/proc/basic_hit(mob/living/carbon/human/A,mob/living/carbon/human/D)
	var/percentile = rand()
	var/damage = LERP(A.get_punchdamagelow(), A.get_punchdamagehigh(), percentile)

	var/atk_verb = pick(A.dna.species.attack_verbs)
	var/atk_effect = A.dna.species.attack_effect
	if(!(D.mobility_flags & MOBILITY_STAND))
		atk_verb = "kick"
		atk_effect = ATTACK_EFFECT_KICK
	A.do_attack_animation(D, atk_effect)
	if(!damage)
		playsound(D.loc, A.dna.species.miss_sound, 25, 1, -1)
		D.visible_message(span_warning("[A] has attempted to [atk_verb] [D]!"), \
			span_userdanger("[A] has attempted to [atk_verb] [D]!"), null, COMBAT_MESSAGE_RANGE)
		log_combat(A, D, "attempted to [atk_verb]")
		return FALSE

	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, MELEE)

	playsound(D.loc, A.dna.species.attack_sound, 25, 1, -1)
	D.visible_message(span_danger("[A] has [atk_verb]ed [D]!"), \
			span_userdanger("[A] has [atk_verb]ed [D]!"), null, COMBAT_MESSAGE_RANGE)

	D.last_damage = "masterful fist"
	D.apply_damage(damage, A.dna.species.attack_type, affecting, armor_block)

	log_combat(A, D, "punched")

	if((D.stat != DEAD) && percentile > (1 - A.get_punchstunchance()) && !HAS_TRAIT(A, TRAIT_NO_PUNCH_STUN))
		D.visible_message(span_danger("[A] has knocked [D] down!!"), \
								span_userdanger("[A] has knocked [D] down!"))
		D.apply_effect(40, EFFECT_KNOCKDOWN, armor_block)
		D.forcesay(GLOB.hit_appends)
	else if(!(D.mobility_flags & MOBILITY_STAND))
		D.forcesay(GLOB.hit_appends)
	return TRUE

/**
  *martial arts handle_throw proc
  *
  *does stuff for hitting people while thrown
  *returns TRUE if the default throw impact shouldn't do anything, FALSE if you still slam into something at mach 20 and eat a stun
  */

/datum/martial_art/proc/handle_throw(atom/hit_atom, mob/living/carbon/human/A, datum/thrownthing/throwingdatum)
	return FALSE

/**
  * martial art learn proc
  *
  * gives the user the martial art, if it's a temporary one  it will only temporarily override an older martial art rather than replacing it
  * unless the current art won't allow a temporary override
  */
/datum/martial_art/proc/teach(mob/living/carbon/human/H, make_temporary=0)
	if(!istype(H) || !H.mind)
		return FALSE
	if(H.mind.martial_art)
		if(make_temporary)
			if(!H.mind.martial_art.allow_temp_override)
				return FALSE
			store(H.mind.martial_art,H)
		else
			H.mind.martial_art.on_remove(H)
	else if(make_temporary)
		base = H.mind.default_martial_art
	if(help_verb)
		add_verb(H, help_verb)
	if(LAZYLEN(martial_traits))
		H.add_traits(martial_traits, id)
	H.mind.martial_art = src
	martial_owner = H
	if(no_guns)
		for(var/mob/living/simple_animal/hostile/guardian/guardian in H.hasparasites())
			guardian.stats.ranged = FALSE
			guardian.ranged = FALSE
			to_chat(H, span_holoparasite("<font color=\"[guardian.namedatum.color]\"><b>[guardian.real_name]</b></font> loses their ranged attacks in accordance with your martial art!"))
	return TRUE

/**
  * martial art store proc
  *
  * used to store the martial art as the basic art if another art would temporarily override it
  */
/datum/martial_art/proc/store(datum/martial_art/M,mob/living/carbon/human/H)
	M.on_remove(H)
	if(M.base) //Checks if M is temporary, if so it will not be stored.
		base = M.base
	else //Otherwise, M is stored.
		base = M

/**
  * martial art removal proc
  *
  * used to remove a martial art, will replace it with the base martial art or default martial art lacking a base
  */
/datum/martial_art/proc/remove(mob/living/carbon/human/H)
	if(!istype(H) || !H.mind || H.mind.martial_art != src)
		return
	on_remove(H)
	martial_owner = null
	H.mind.martial_art = null
	if(base)
		base.teach(H)
	else
		var/datum/martial_art/X = H.mind.default_martial_art
		X.teach(H)
/**
  * martial art on_remove handler proc
  *
  * handles specific things that are to be done on a martial art being removed
  */
/datum/martial_art/proc/on_remove(mob/living/carbon/human/H)
	if(help_verb)
		remove_verb(H, help_verb)
	if(LAZYLEN(martial_traits))
		H.remove_traits(martial_traits, id)
	return
