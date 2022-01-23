//%attributes = {}

// ----------------------------------------------------
// Method: Return_indexes
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------



#DECLARE($human : Object; $job : Object)->$index : Object
var $nbhomonyms; $incidence : Real
var $country_population; $line; $pos_space : Integer
//var $found; $connect_to; $background_ds; $index : Object
var $middle_name : Text

$country_population:=Tab_country_population{Find in array:C230(Tab_country_code; $human.country)}
$index:=New object:C1471("basic"; 100; "full"; 100; "completion"; 10)

If ($human.country#$job.country)  // If the human comes from a different country than the job, we will need to query the background datastore
	$connect_to:=New object:C1471("type"; "4D Server"; "hostname"; Storage:C1525.background.ip_address)
	$background_ds:=Open datastore:C1452($connect_to; "Background")
End if 



///////////////////////////////////////  Basic index ////////////////////////////////////////////////////////////

// We start with the last name
$nbhomonyms:=5000  // We assume - very conservatively - that a name we don't know cannot have more 5,000 bearers in any country

If ($human.country=$job.country)  // We can use arrays
	$line:=Find in array:C230(Tab_country_ln; $human.name.last)
	If ($line>0)
		$nbhomonyms:=Tab_country_ln_number{$line}
	End if 
Else   // We query the background datastore
	$found:=$background_ds["Last_name_"+$human.country].query("lastname=:1"; $human.name.last)
	If ($found.length>0)
		$nbhomonyms:=$found.first().number
	End if 
End if 

// Same method for the first name.
$incidence:=0.001  // We assume that a first name we don't know cannot be born by more than 0.1% of a country's population

If ($human.country=$job.country)  // We can use arrays
	$line:=Find in array:C230(Tab_country_fn; $human.name.first)
	If ($line>0)
		$incidence:=Tab_country_fn_number{$line}/$country_population
	End if 
Else   // We query the background datastore
	$found:=$background_ds["First_name_sex_"+$human.country].query("firstname=:1"; $human.name.first)
	If ($found.length>0)
		$incidence:=$found.first().number/$country_population
	End if 
	
End if 

$nbhomonyms:=$nbhomonyms*$incidence
$index.basic:=Return_logarithmic_index($nbhomonyms)


///////////////////////////////////////////////////  Full index ////////////////////////////////////////////////////////////


If ($index.basic=1)  // If the basic index is already at the lowest possible level, no need to calculate the full index
	$index.full:=1
	
Else 
	
	// Middle name, if there is one
	If ($human.name.middle#Null:C1517)
		$middle_name:=$human.name.middle
		$pos_space:=Position:C15(" "; $middle_name)  // If the middle name contains more than one word, we take only the first one
		If ($pos_space>0)
			$middle_name:=Substring:C12($middle_name; 1; ($pos_space-1))
		End if 
		If (Length:C16($middle_name)=1)  // If the middle name is an initial, we apply a flat 15% factor
			$nbhomonyms:=$nbhomonyms*0.15
		Else 
			$incidence:=0.0001
			If ($human.country=$job.country)  // We can use arrays
				$line:=Find in array:C230(Tab_country_fn; $middle_name)
				If ($line>0)
					$incidence:=Tab_country_fn_number{$line}/$country_population
				End if 
			Else   // We query the background datastore
				$found:=$background_ds["First_name_sex_"+$human.country].query("firstname=:1"; $middle_name)
				If ($found.length>0)
					$incidence:=$found.first().number/$country_population
				End if 
			End if 
			$nbhomonyms:=$nbhomonyms*$incidence
		End if 
	End if 
	
	If ($human.birth#Null:C1517)
		If ($human.birth.year#Null:C1517)  // Year of birth, if there is one. 
			$nbhomonyms:=($nbhomonyms/60)*((2*$human.birth.year_confidence_margin)+1)  // The bigger the confidence margin, the less accurate the reading
		End if 
		If ($human.birth.month#Null:C1517)  // Month of birth
			$nbhomonyms:=$nbhomonyms/12
		End if 
		If ($human.birth.day#Null:C1517)  // Day of birth
			$nbhomonyms:=$nbhomonyms/30
		End if 
		If ($human.birth.city#Null:C1517) | ($human.birth.region#Null:C1517)  // Place of birth
			$nbhomonyms:=$nbhomonyms/10  // he 10-factor is arbitrary as we lack quantitative data
		End if 
	End if 
	
	$index.full:=Return_logarithmic_index($nbhomonyms)
End if 


///////////////////////////////////////////////////  Completion ////////////////////////////////////////////////////////////

// The minimum level of completion is 10 (first name + last name). Each additional information is worth extra points. Max value: 100 

If ($human.name.middle#Null:C1517)
	$index.completion:=$index.completion+15
End if 
If ($human.name.maiden#Null:C1517)  // If we have a maiden name, we know the human is a woman. We only assign the 10 points once.
	$index.completion:=$index.completion+10
Else 
	If ($human.sex.sex#Null:C1517)
		$index.completion:=$index.completion+10
	End if 
End if 
If ($human.birth.year#Null:C1517)
	$index.completion:=$index.completion+20-(2*($human.birth.year_confidence_margin))
End if 
If ($human.birth.month#Null:C1517)
	$index.completion:=$index.completion+10
End if 
If ($human.birth.day#Null:C1517)
	$index.completion:=$index.completion+10
End if 
If ($human.birth.city#Null:C1517)
	$index.completion:=$index.completion+15
End if 
If ($human.birth.region#Null:C1517)
	$index.completion:=$index.completion+5
End if 
If ($human.birth.country#Null:C1517)
	$index.completion:=$index.completion+5
End if 


// We might want to save the last names that weren't found to run them through forebears
