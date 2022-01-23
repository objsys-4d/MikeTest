//%attributes = {}


// ----------------------------------------------------
// Method: Enrich_old_human_with_new
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------
// Modified by: Mike Beatty (11/12/21)

#DECLARE($old : Object; $new : Object; $country_code : Object; $birth_info_boolean : Boolean; $death_info_boolean : Boolean)->$enriched : Boolean


/////////////////////////////////////////// Names /////////////////////////////////////

// Middle name
Case of 
	: ($new.name.middle=Null:C1517)  // no new information
	: ($old.name.middle=Null:C1517)  // new information
		$old.name.middle:=$new.name.middle
		$old.name.middle_certainty:=$new.name.middle_certainty
		$enriched:=True:C214
	: ($old.name.middle=$new.name.middle)  // confirmation
		$old.name.middle_certainty:=Increase_certainty($old.name.middle_certainty; $new.name.middle_certainty)
End case 

// Maiden name
Case of 
	: ($new.name.maiden=Null:C1517)  // no new information
	: ($old.name.maiden=Null:C1517)  // new information
		$old.name.maiden:=$new.name.maiden
		$old.name.maiden_certainty:=$new.name.maiden_certainty
		$enriched:=True:C214
	: ($old.name.maiden=$new.name.maiden)  // confirmation
		$old.name.maiden_certainty:=Increase_certainty($old.name.maiden_certainty; $new.name.maiden_certainty)
End case 

/////////////////////////////////////////// Birth info /////////////////////////////////////

If ($birth_info_boolean=True:C214)  // No need to go through that extensive process if we know the last import didn't contain any birth-related info
	// Birth_year
	Case of 
		: ($new.birth.year=Null:C1517)  // no new information
		: ($old.birth.year=Null:C1517)  // new information
			$old.birth.year:=$new.birth.year
			$old.birth.year_certainty:=$new.birth.year_certainty
			$enriched:=True:C214
		: ($old.birth.year=$new.birth.year)  // confirmation
			$old.birth.year_certainty:=Increase_certainty($old.birth.year_certainty; $new.birth.year_certainty)
	End case 
	
	// Birth_month
	Case of 
		: ($new.birth.month=Null:C1517)  // no new information
		: ($old.birth.month=Null:C1517)  // new information
			$old.birth.month:=$new.birth.month
			$old.birth.month_certainty:=$new.birth.month_certainty
			$enriched:=True:C214
		: ($old.birth.month=$new.birth.month)  // confirmation
			$old.birth.month_certainty:=Increase_certainty($old.birth.month_certainty; $new.birth.month_certainty)
	End case 
	
	// Birth_day
	Case of 
		: ($new.birth.day=Null:C1517)  // no new information
		: ($old.birth.day=Null:C1517)  // new information
			$old.birth.day:=$new.birth.day
			$old.birth.day_certainty:=$new.birth.day_certainty
			$enriched:=True:C214
		: ($old.birth.day=$new.birth.day)  // confirmation
			$old.birth.day_certainty:=Increase_certainty($old.birth.day_certainty; $new.birth.day_certainty)
	End case 
	
	// Birth_city
	Case of 
		: ($new.birth.city=Null:C1517)  // no new information
		: ($old.birth.city=Null:C1517)  // new information
			$old.birth.city:=$new.birth.city
			$old.birth.city_certainty:=birth.city_certainty
			$enriched:=True:C214
		: ($old.birth.city=$new.birth.city)  // confirmation
			$old.birth.city_certainty:=Increase_certainty($old.birth.city_certainty; $new.birth.city_certainty)
	End case 
	
	// Birth_region
	Case of 
		: ($new.birth.region=Null:C1517)  // no new information
		: ($old.birth.region=Null:C1517)  // new information
			$old.birth.region:=$new.birth.region
			$old.birth.region_certainty:=birth.region_certainty
			$enriched:=True:C214
		: ($old.birth.region=$new.birth.region)  // confirmation
			$old.birth.region_certainty:=Increase_certainty($old.birth.region_certainty; $new.birth.region_certainty)
	End case 
	
	// Birth_country
	Case of 
		: ($new.birth.country=Null:C1517)  // no new information
		: ($old.birth.country=Null:C1517)  // new information
			$old.birth.country:=$new.birth.country
			$old.birth.country_certainty:=birth.country_certainty
			$enriched:=True:C214
		: ($old.birth.country=$new.birth.country)  // confirmation
			$old.birth.country_certainty:=Increase_certainty($old.birth.country_certainty; $new.birth.country_certainty)
	End case 
End if 


/////////////////////////////////////////// Death info /////////////////////////////////////


If ($death_info_boolean=True:C214)  // No need to go through that extensive process if we know the last import didn't contain any death-related info
	// death_year
	Case of 
		: ($new.death.year=Null:C1517)  // no new information
		: ($old.death.year=Null:C1517)  // new information
			$old.death.year:=$new.death.year
			$old.death.year_certainty:=$new.death.year_certainty
			$enriched:=True:C214
		: ($old.death.year=$new.death.year)  // confirmation
			$old.death.year_certainty:=Increase_certainty($old.death.year_certainty; $new.death.year_certainty)
	End case 
	
	// death_month
	Case of 
		: ($new.death.month=Null:C1517)  // no new information
		: ($old.death.month=Null:C1517)  // new information
			$old.death.month:=$new.death.month
			$old.death.month_certainty:=$new.death.month_certainty
			$enriched:=True:C214
		: ($old.death.month=$new.death.month)  // confirmation
			$old.death.month_certainty:=Increase_certainty($old.death.month_certainty; $new.death.month_certainty)
	End case 
	
	// death_day
	Case of 
		: ($new.death.day=Null:C1517)  // no new information
		: ($old.death.day=Null:C1517)  // new information
			$old.death.day:=$new.death.day
			$old.death.day_certainty:=$new.death.day_certainty
			$enriched:=True:C214
		: ($old.death.day=$new.death.day)  // confirmation
			$old.death.day_certainty:=Increase_certainty($old.death.day_certainty; $new.death.day_certainty)
	End case 
	
	// death_city
	Case of 
		: ($new.death.city=Null:C1517)  // no new information
		: ($old.death.city=Null:C1517)  // new information
			$old.death.city:=$new.death.city
			$old.death.city_certainty:=death.city_certainty
			$enriched:=True:C214
		: ($old.death.city=$new.death.city)  // confirmation
			$old.death.city_certainty:=Increase_certainty($old.death.city_certainty; $new.death.city_certainty)
	End case 
	
	// death_region
	Case of 
		: ($new.death.region=Null:C1517)  // no new information
		: ($old.death.region=Null:C1517)  // new information
			$old.death.region:=$new.death.region
			$old.death.region_certainty:=death.region_certainty
			$enriched:=True:C214
		: ($old.death.region=$new.death.region)  // confirmation
			$old.death.region_certainty:=Increase_certainty($old.death.region_certainty; $new.death.region_certainty)
	End case 
	
	// death_country
	Case of 
		: ($new.death.country=Null:C1517)  // no new information
		: ($old.death.country=Null:C1517)  // new information
			$old.death.country:=$new.death.country
			$old.death.country_certainty:=death.country_certainty
			$enriched:=True:C214
		: ($old.death.country=$new.death.country)  // confirmation
			$old.death.country_certainty:=Increase_certainty($old.death.country_certainty; $new.death.country_certainty)
	End case 
End if 


/////////////////////////////////////////// Index /////////////////////////////////////


// We recalculate the index of the enriched record. The basic index have stayed the same and the full index must have come down.
$old.index:=Return_indexes($old; $country_code)
$old.save()