//%attributes = {}

// ----------------------------------------------------
// Method: Break_down_one_human_table
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text; $old_cutoff : Text; $target : Real)

var $nb_records_table; $nb_records_from; $nb_records_to; $attempt_number; $max_number_attempts; $nb_tables_broken_down; $nb_tables_not_broken_down : Integer
var $nb_to_transfer : Integer
var $table_from; $table_to; $ladder; $new_ladder; $cutoff; $attempt_cutoff; $acceptable_cutoff; $summary : Text
var $next_target; $margin_1; $margin_2; $attempt_distance; $acceptable_distance; $distance : Real
var $0; $records_to_transfer; $record; $new_record; $status; $country; $cache : Object
var $ladder_col : Collection
ARRAY TEXT:C222($tab_attempts; 0)
$0:=New object:C1471
$0.success:=False:C215
$0.distance:=0

$margin_1:=0.025
$margin_2:=0.23
$max_number_attempts:=500

var $records_all : Object
var $previous_rung; $message : Text
var $attempt_ratio : Real
var $nb_before : Integer


$table_from:="Humans_"+$country_code+"_"+$old_cutoff
$records_all:=ds:C1482[$table_from].all()
$nb_records_table:=$records_all.length

$previous_rung:=Return_previous_rung_in_ladder($country_code; $old_cutoff)
$attempt_cutoff:=$previous_rung
$cutoff:=$attempt_cutoff
$distance:=$target
$acceptable_distance:=$target

Repeat 
	$nb_before:=$records_all.query("full_name<=:1"; $attempt_cutoff).length
	$attempt_ratio:=$nb_before/$nb_records_table
	$attempt_distance:=Abs:C99($target-$attempt_ratio)
	$attempt_number:=$attempt_number+1
	
	Case of 
		: (Find in array:C230($tab_attempts; $attempt_cutoff)>0)
			$attempt_cutoff:=$attempt_cutoff+"A"
			
		: ($attempt_ratio<=$target)  // We haven't reached the target yet
			If ($attempt_distance<$distance)  // The gap is closing
				$distance:=$attempt_distance
				$cutoff:=$attempt_cutoff
			End if 
			
		: ($attempt_ratio>$target)  // We are past the target.
			
			Case of 
				: (($attempt_ratio<=($target+$margin_1)) & ($attempt_distance<=$distance))  // This is the closest we've been and this result will be good enough
					$distance:=$attempt_distance
					$cutoff:=$attempt_cutoff
					
				: (($attempt_ratio<=($target+$margin_2)) & ($attempt_distance<=$distance))
					If ($attempt_distance<$acceptable_distance)  // The gap is closing
						$acceptable_distance:=$attempt_distance
						$acceptable_cutoff:=$attempt_cutoff
					End if 
				Else 
					$attempt_cutoff:=$cutoff+"A"  // The gap is getting bigger. We need to go back
			End case 
	End case 
	
	
	APPEND TO ARRAY:C911($tab_attempts; $attempt_cutoff)
	$attempt_cutoff:=Move_up_one_letter($attempt_cutoff)
	
	Case of 
		: ($attempt_ratio>$target)
			$attempt_cutoff:=$cutoff+"A"
			
		: ($attempt_cutoff>=$old_cutoff)
			$attempt_cutoff:=$cutoff+"A"  // We add a letter
			
			If ($attempt_cutoff<$previous_rung)
				$attempt_cutoff:=Substring:C12($previous_rung; 1; Length:C16($attempt_cutoff))
			End if 
	End case 
Until (($distance<$margin_1) | ($attempt_number=$max_number_attempts))

TRACE:C157

If ($distance>$acceptable_distance)
	$distance:=$acceptable_distance
	$cutoff:=$acceptable_cutoff
End if 

If ($distance<$margin_2)  /// We can now move some records to the new table
	
	// We create the new table (and update the ladder at the same time)
	If (Set_up_table_and_ladder($country_code; $cutoff; $old_cutoff))
		
		$table_to:="Humans_"+$country_code+"_"+$cutoff
		$records_to_transfer:=ds:C1482[$table_from].all().query("full_name<=:1"; $cutoff)
		$nb_to_transfer:=$records_to_transfer.length
		
		For each ($record; $records_to_transfer)
			
			$new_record:=ds:C1482[$table_to].new()
			
			// We copy all data
			$new_record:=Copy_human($record; $new_record)
			
			// We save the new record and delete the old one
			$status:=$new_record.save()
			$status:=$record.drop()
			
			If (Mod:C98($record.indexOf(); 10000)=0)
				$cache:=Cache info:C1402
				$message:="Table "+$country_code+"_"+$old_cutoff+" is being broken down\n"
				$message:=$message+String:C10($record.indexOf(); "### ##0")+" out of "+String:C10($nb_to_transfer; "### ##0")+"\n"
				$message:=$message+"Cache: "+String:C10(($cache.usedMem/1000000); "### ##0 Mb")
				MESSAGE:C88($message)
			End if 
		End for each 
		
		$0.success:=True:C214
		$0.distance:=$distance
		
	Else   // The distance is too far from our goal
		
		$0.success:=False:C215
		$0.distance:=$distance
		
	End if 
End if 