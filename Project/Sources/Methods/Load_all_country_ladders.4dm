//%attributes = {}
C_LONGINT:C283($i; $n; $pos; $rung_number)
C_TEXT:C284($ladder; $country_code)
C_COLLECTION:C1488($ladder_col)

ALL RECORDS:C47()
//SELECTION TO ARRAY([Countries:2]iso_3:4; Tab_country_code; [Countries:2]ladder:12; Tab_country_ladder)
//REDUCE SELECTION(; 0)
var $name_tab_rung_limit : Pointer

ARRAY POINTER:C280(Pointer_rung_limit; Size of array:C274(Tab_country_code))

For ($i; 1; Size of array:C274(Tab_country_code))
	$country_code:=Tab_country_code{$i}
	$ladder:=Tab_country_ladder{$i}
	$ladder_col:=Split string:C1554($ladder; "-")
	$name_tab_rung_limit:=Get pointer:C304("Tab_rung_limit_"+Tab_country_code{$i})
	
	ARRAY TEXT:C222($name_tab_rung_limit->; 0)
	$name_tab_rung_limit->{0}:="A"
	For ($n; 0; $ladder_col.length-1)
		APPEND TO ARRAY:C911($name_tab_rung_limit->; $ladder_col[$n])
	End for 
	SORT ARRAY:C229($name_tab_rung_limit->; >)
	Pointer_rung_limit{$i}:=$name_tab_rung_limit
End for 
