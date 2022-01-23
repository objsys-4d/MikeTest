//%attributes = {}
C_LONGINT:C283($i; $n)
C_COLLECTION:C1488($ladder_col)

// We load all countries in arrays
//ALL RECORDS()
//SELECTION TO ARRAY([Countries:2]iso_3:4; Tab_country_code; [Countries:2]population:6; Tab_country_population; [Countries:2]ladder:12; Tab_country_ladder)
//SELECTION TO ARRAY([Countries:2]last_value_first_name:10; Tab_country_fn_threshold; [Countries:2]last_value_last_name:11; Tab_country_ln_threshold)
//REDUCE SELECTION(; 0)

// We build a pointer for each ladder
ARRAY POINTER:C280(Pointer_rung_limit; Size of array:C274(Tab_country_code))

var $name_tab_rung_limit : Pointer
For ($i; 1; Size of array:C274(Tab_country_code))
	$ladder_col:=Split string:C1554(Tab_country_ladder{$i}; "-")
	$name_tab_rung_limit:=Get pointer:C304("Tab_rung_limit_"+Tab_country_code{$i})
	
	ARRAY TEXT:C222($name_tab_rung_limit->; 0)
	$name_tab_rung_limit->{0}:="A"
	For ($n; 0; $ladder_col.length-1)
		APPEND TO ARRAY:C911($name_tab_rung_limit->; $ladder_col[$n])
	End for 
	SORT ARRAY:C229($name_tab_rung_limit->; >)
	Pointer_rung_limit{$i}:=$name_tab_rung_limit
End for 

