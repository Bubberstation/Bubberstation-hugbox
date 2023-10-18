/datum/atmosphere/icemoon
	id = ICEMOON_DEFAULT_ATMOS

	base_gases = list(
		/datum/gas/oxygen=3,
		/datum/gas/nitrogen=7,
	)
	normal_gases = list(
		/datum/gas/oxygen=3,
		/datum/gas/nitrogen=7,
	)

	minimum_pressure = HAZARD_LOW_PRESSURE + 50
	maximum_pressure = HAZARD_LOW_PRESSURE + 50

	minimum_temp = FIRE_SUIT_MIN_TEMP_PROTECT + 1
	maximum_temp = FIRE_SUIT_MIN_TEMP_PROTECT + 1
