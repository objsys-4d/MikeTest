//%attributes = {}

// ----------------------------------------------------
// Method: Check_ladder_integrity
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

// We make sure that the humans tables of a given country match exactly with its text ladder
// We build two arrays with the values coming from 1) the tables and 2) the ladder and we try to match them one by one

#DECLARE($country_code : Text)
var $table_name; $ladder; $ticker : Text
var $ladder_col : Collection
var $nb_tables; $i : Integer
var $integrity : Boolean
$integrity:=True:C214
ARRAY TEXT:C222($tab_table; 0)
ARRAY TEXT:C222($tab_ladder; 0)

If (Count parameters:C259=0)
	$country_code:="USA"
End if 

// First we build the array based on tables

$nb_tables:=Get last table number:C254

For ($i; 1; $nb_tables)
	If (Is table number valid:C999($i))
		$table_name:=Table name:C256($i)
		If (Position:C15("Humans_"+$country_code+"_"; $table_name)>0)
			$ticker:=Substring:C12($table_name; 12)
			APPEND TO ARRAY:C911($Tab_table; $ticker)
		End if 
	End if 
End for 


// Then the array based on the text ladder

$ladder:=ds:C1482.Countries.get($country_code).ladder
$ladder_col:=Split string:C1554($ladder; "-")

For ($i; 0; $ladder_col.length-1)
	APPEND TO ARRAY:C911($tab_ladder; $ladder_col[$i])
End for 

// Now we compare the two arrays
SORT ARRAY:C229($tab_table; >)
SORT ARRAY:C229($tab_ladder; >)

For ($i; 1; Size of array:C274($tab_table))
	If ($tab_table{$i}#$tab_ladder{$i})
		$integrity:=False:C215
		MESSAGE:C88("Problem with ladder integrity. Table "+$tab_table{$i}+" - Ladder: "+$tab_ladder{$i})
		TRACE:C157
		$i:=Size of array:C274($tab_table)
	End if 
End for 

If ($integrity=True:C214)
	For ($i; 1; Size of array:C274($tab_ladder))
		If ($tab_ladder{$i}#$tab_table{$i})
			$integrity:=False:C215
			MESSAGE:C88("Problem with ladder integrity. Table "+$tab_table{$i}+" - Ladder: "+$tab_ladder{$i})
			TRACE:C157
			$i:=Size of array:C274($tab_ladder)
		End if 
	End for 
End if 

$0:=$integrity


