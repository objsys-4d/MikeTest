//%attributes = {}

// ----------------------------------------------------
// Method: Count_humans_in_one_country
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text)
var $ladder; $table_name : Text
var $ladder_col : Collection
var $nb_humans; $i : Integer

If (Count parameters:C259=0)
	$country_code:="USA"
End if 

$ladder:=ds:C1482.Countries.get($country_code).ladder
$ladder_col:=Split string:C1554($ladder; "-")


For ($i; 0; $ladder_col.length-1)
	$table_name:="Humans_"+$country_code+"_"+Uppercase:C13($ladder_col[$i])
	$nb_humans:=$nb_humans+ds:C1482[$table_name].all().length
End for 

If (Count parameters:C259=1)
	$0:=$nb_humans
End if 

