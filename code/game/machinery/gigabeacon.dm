/obj/machinery/bluespace_beacon
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	name = "bluespace gigabeacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	layer = LOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usage = 0
	var/obj/item/beacon/Beacon

/obj/machinery/bluespace_beacon/Initialize(mapload)
	. = ..()
	var/turf/T = loc
	Beacon = new(T)
	Beacon.SetInvisibility(INVISIBILITY_MAXIMUM)

	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)

/obj/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(Beacon)
	return ..()

// update the icon_state
/obj/machinery/bluespace_beacon/proc/updateicon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"

	else
		icon_state = "[state]"

/obj/machinery/bluespace_beacon/process()
	if(!Beacon)
		var/turf/T = loc
		Beacon = new(T)
		Beacon.SetInvisibility(INVISIBILITY_MAXIMUM)
	else if (Beacon.loc != loc)
		Beacon.forceMove(loc)

	updateicon()
