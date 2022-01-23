//%attributes = {}

// ----------------------------------------------------
// Method: Count_humans_in_all_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $t0; $elapsed; $line; $line_int; $i; $nb_humans : Integer
var $table_name; $text; $country : Text
var $esCountries : Object
var $colCountries : Collection
$t0:=Milliseconds:C459

$esCountries:=ds:C1482.Countries.all()
$colCountries:=$esCountries.toCollection("name")
ARRAY TEXT:C222($atCountry; 0)
COLLECTION TO ARRAY:C1562($colCountries; $atCountry)
//ALL RECORDS()
//SELECTION TO ARRAY([Countries:2]iso_3:4; $atCountry)
$line_int:=Find in array:C230($atCountry; "INT")
ARRAY LONGINT:C221($tab_nb_humans; Size of array:C274($atCountry))
ARRAY TEXT:C222($tab_table_name; 0)
ARRAY LONGINT:C221($tab_table_population; 0)

For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		$table_name:=Table name:C256(Table:C252($i))
		$table_name:=Replace string:C233($table_name; "("; "")
		$table_name:=Replace string:C233($table_name; ")"; "")
		If ($table_name="Humans_@")
			$country:=Substring:C12($table_name; 8; 3)
			$line:=Find in array:C230($atCountry; $country)
			If ($line>0)
				$nb_humans:=ds:C1482[$table_name].all().length
				$tab_nb_humans{$line}:=$tab_nb_humans{$line}+$nb_humans
				$tab_nb_humans{$line_int}:=$tab_nb_humans{$line_int}+$nb_humans
				If ($nb_humans>0)
					APPEND TO ARRAY:C911($tab_table_name; $table_name)
					APPEND TO ARRAY:C911($tab_table_population; $nb_humans)
				End if 
			Else 
				TRACE:C157
			End if 
		End if 
	End if 
End for 

MULTI SORT ARRAY:C718($tab_nb_humans; <; $atCountry)
MULTI SORT ARRAY:C718($tab_table_population; <; $tab_table_name)
$elapsed:=Milliseconds:C459-$t0

For ($i; 1; Size of array:C274($tab_table_name))
	$text:=$text+$tab_table_name{$i}+" - "+String:C10($tab_table_population{$i}; "###,##0")+"     \n"
End for 

