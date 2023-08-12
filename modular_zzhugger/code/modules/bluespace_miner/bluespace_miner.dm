/obj/machinery/bluespace_miner/examine(mob/user)
	if(obj_flags & EMAGGED)
		. += span_warning("The safeties are turned off!")
	var/turf/src_turf = get_turf(src)
	var/datum/gas_mixture/environment = src_turf.return_air()
	if(environment.temperature >= T20C)
		. += span_warning("[src] is in a suboptimal environment: " + span_boldwarning("TEMPERATURE TOO HIGH!"))
	if(environment.return_pressure() <= ONE_ATMOSPHERE * 0.5)
		. += span_warning("[src] is in a suboptimal environment: " + span_boldwarning("PRESSURE TOO LOW!"))
	if(environment.return_pressure() >= (ONE_ATMOSPHERE * 3))
		. += span_warning("[src] is in a suboptimal environment: " + span_boldwarning("PRESSURE TOO HIGH!"))
	for(var/obj/machinery/bluespace_miner/bs_miner in range(1, src))
		if(bs_miner != src)
			. += span_warning("[src] is in a suboptimal environment: TOO CLOSE TO ANOTHER BLUESPACE MINER")

/obj/machinery/bluespace_miner/check_factors()
	if(!COOLDOWN_FINISHED(src, process_speed))
		return FALSE
	COOLDOWN_START(src, process_speed, processing_speed)
	// cant be broken or unpowered
	if(machine_stat & (NOPOWER|BROKEN))
		return FALSE
	// cant be unanchored or open panel
	if(!anchored || panel_open)
		return FALSE
	for(var/obj/machinery/bluespace_miner/bs_miner in range(1, src))
		if(bs_miner != src)
			return FALSE
	var/turf/src_turf = get_turf(src)
	var/datum/gas_mixture/environment = src_turf.return_air()
	// if its hotter than (or equal to) room temp, don't work
	if(environment.temperature >= T20C)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return FALSE
	// if its lesser than(or equal to) normal pressure, don't work
	if(environment.return_pressure() <= ONE_ATMOSPHERE * 0.5)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return FALSE
	// overpressurizing will cause nuclear particles...
	if(environment.return_pressure() >= (ONE_ATMOSPHERE * 3))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, FALSE)
		return FALSE
	//add amount_produced degrees to the temperature
	var/datum/gas_mixture/merger = new
	merger.assert_gas(/datum/gas/carbon_dioxide)
	merger.gases[/datum/gas/carbon_dioxide][MOLES] = MOLES_CELLSTANDARD
	if(obj_flags & EMAGGED)
		merger.assert_gas(/datum/gas/tritium)
		merger.gases[/datum/gas/tritium][MOLES] = MOLES_CELLSTANDARD
	merger.temperature = (T20C + gas_temp)
	src_turf.assume_air(merger)
	return TRUE
