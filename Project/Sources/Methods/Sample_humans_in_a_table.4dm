//%attributes = {}


// ----------------------------------------------------
// Method: Sample_humans_in_a_table
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $random; $length; $sample_size; $nb_tables_OK; $nb_tables_fixed; $nb_tables_empty; $nb_records_fixed; $i; $lower_limit; $upper_limit; $n : Integer
var $country_code; $last_name; $list_tables_fixed; $list_tables_empty; $ladder; $message : Text
var $record; $records; $status; $country; $selection : Object
var $rungs : Collection
var $table_OK : Boolean
$table_OK:=True:C214
ARRAY TEXT:C222($Tab_faulty_tables; 0)

$country_code:="USA"
$country:=ds:C1482.Countries.get($country_code)
$ladder:=$country.ladder
$sample_size:=10000

$rungs:=Split string:C1554($ladder; "-")
$rungs:=$rungs.insert(0; "A")

Load_all_countries_in_arrays  // ladders, thresholds, etc.
Load_one_country_arrays($country_code)  // impurities, prefixes, suffixes, etc.

For ($i; 1; $rungs.length-1)
	MESSAGE:C88("Table "+$country_code+"_"+$rungs[$i])
	$records:=ds:C1482["Humans_"+$country_code+"_"+$rungs[$i]].all()
	$length:=$records.length
	
	If ($length=0)
		$nb_tables_empty:=$nb_tables_empty+1
		$list_tables_empty:=$list_tables_empty+$rungs[$i]+" - "
	Else 
		$lower_limit:=$rungs[($i-1)]
		$upper_limit:=$rungs[$i]
		$table_OK:=True:C214
		
		// Sample_size = 0 means that we check every record in the table, otherwise we only check a selected number of records
		// We build the selection to test
		
		If ($sample_size=0)
			$selection:=$records
		Else 
			$selection:=ds:C1482["Humans_"+$country_code+"_"+$rungs[$i]].newSelection()
			For ($n; 1; $sample_size)
				$random:=Random_integer(0; ($length-1))
				$selection:=$selection.add($records[$random])
			End for 
		End if 
		
		// Now we test each record in the selection
		
		For each ($record; $selection)
			Case of 
				: ($record.full_name<=$lower_limit)
					$table_OK:=False:C215
					
				: ($record.full_name>$upper_limit)
					$table_OK:=False:C215
			End case 
		End for each 
		
		If ($table_OK=True:C214)
			$nb_tables_OK:=$nb_tables_OK+1
		Else 
			$nb_records_fixed:=$nb_records_fixed+Dispatch_humans_to_tables($country_code; $rungs[$i])
			$nb_tables_fixed:=$nb_tables_fixed+1
			$list_tables_fixed:=$list_tables_fixed+$rungs[$i]+" - "
		End if 
	End if 
End for 

If ($nb_tables_fixed=0)
	MESSAGE:C88("All tables appear to be OK")
Else 
	$message:=String:C10($nb_tables_OK; "##0")+" tables were OK. "+String:C10($nb_tables_fixed; "##0")+" have been fixed: "+$list_tables_fixed+"\n"
	$message:=$message+String:C10($nb_tables_empty; "##0")+" tables were empty: "+$list_tables_empty
	MESSAGE:C88($message)
End if 