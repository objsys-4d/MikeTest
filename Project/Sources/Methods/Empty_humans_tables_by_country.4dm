//%attributes = {}

// ----------------------------------------------------
// Method: Empty_humans_tables_by_country
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text)
var $0; $nb_records_deleted; $i : Integer
var $ladder; $table_name : Text
var $ladder_col : Collection

If (Count parameters:C259=0)
	$country_code:="USA"
End if 

$ladder:=ds:C1482.Countries.get($country_code).ladder
$ladder_col:=Split string:C1554($ladder; "-")

For ($i; 0; $ladder_col.length-1)
	$table_name:="Humans_"+$country_code+"_"+$ladder_col[$i]
	$nb_records_deleted:=$nb_records_deleted+ds:C1482[$table_name].all().length
	ds:C1482[$table_name].all().drop()
End for 

If (Count parameters:C259=1)
	$0:=$nb_records_deleted
End if 

TRACE:C157
