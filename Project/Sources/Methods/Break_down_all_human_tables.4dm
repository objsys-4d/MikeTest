//%attributes = {}


// ----------------------------------------------------
// Method: Break_down_all_human_tables
// Modified by: Mike Beatty (11/5/21)
// Description - designed to organize persons by name into country tables, setting a range of preferred records in each table
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $nb_tables_broken_down; $nb_tables_not_broken_down; $nb_tables_untouched; $nb_records_table; $records_multiple; $i; $target : Integer
var $country_code; $message; $ladder; $summary; $list_not_broken_down; $table_name : Text
var $records_table; $countries; $country; $result; $cache : Object
var $distance_broken_down; $distance_not_broken_down : Real
var $ladder_col : Collection
$result:=New object:C1471()
$records_multiple:=125000

$country_code:="USA"

If ($country_code="")
	$countries:=ds:C1482.Countries.query("iso_3#:1"; "INT").orderBy("name asc")
Else 
	$countries:=ds:C1482.Countries.query("iso_3=:1"; $country_code)
End if 

For each ($country; $countries)
	
	$ladder:=$country.ladder
	$ladder_col:=Split string:C1554($ladder; "-")
	For ($i; 0; $ladder_col.length-1)
		$table_name:="Humans_"+$country.iso_3+"_"+$ladder_col[$i]
		$cache:=Cache info:C1402
		MESSAGE:C88($table_name+"\nCache: "+String:C10(($cache.usedMem/1000000); "### ##0 Mb"))
		$records_table:=ds:C1482[$table_name].all()
		$nb_records_table:=$records_table.length
		$records_table:=$records_table.slice(0; 1)
		
		Case of 
			: ($nb_records_table<(2*$records_multiple))
				$target:=0
				
			: ($nb_records_table<(3*$records_multiple))
				$target:=1/2
				
			: ($nb_records_table<(4*$records_multiple))
				$target:=1/3
				
			: ($nb_records_table<(5*$records_multiple))
				$target:=1/4
		End case 
		
		If ($target>0)
			$result:=Break_down_one_human_table($country.iso_3; $ladder_col[$i]; $target)
			If ($result.success=True:C214)
				$nb_tables_broken_down:=$nb_tables_broken_down+1
				$distance_broken_down:=$distance_broken_down+$result.distance
			Else 
				$nb_tables_not_broken_down:=$nb_tables_not_broken_down+1
				$list_not_broken_down:=$list_not_broken_down+$ladder_col[$i]+" - "
				$distance_not_broken_down:=$distance_not_broken_down+$result.distance
			End if 
		Else 
			$nb_tables_untouched:=$nb_tables_untouched+1
		End if 
	End for 
End for each 

$summary:=String:C10($nb_tables_untouched; "##0")+" tables untouched\n"
$summary:=$summary+String:C10($nb_tables_broken_down; "##0")+" tables broken down - "
$summary:=$summary+"Average distance: "+String:C10(($distance_broken_down/$nb_tables_broken_down); "##0.00")+"\n"
If ($nb_tables_not_broken_down=0)
	$summary:=$summary+"No table couldn't be broken down"
Else 
	$summary:=$summary+String:C10($nb_tables_not_broken_down; "##0")+" table(s) couldn't be broken down - "
	$summary:=$summary+"Average distance: "+String:C10(($distance_not_broken_down/$nb_tables_not_broken_down); "##0.00")+"\n"
	$summary:=$summary+Substring:C12($list_not_broken_down; 1; Length:C16($list_not_broken_down)-1)
End if 

MESSAGE:C88($summary)
FLUSH CACHE:C297(*)

TRACE:C157
