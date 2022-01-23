//%attributes = {}


// ----------------------------------------------------
// Method: Dispatch_humans_to_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text; $letters : Text)
var $record; $records; $records_not_dropped; $new_record; $status : Object
var $table_name; $destination_table_name; $ladder; $previous_letters; $message : Text
var $nb_total; $nb_reassigned; $nb_confirmed; $rung_position : Integer
var $rungs : Collection

Load_all_country_ladders

$ladder:=ds:C1482.Countries.get($country_code).ladder
$rungs:=Split string:C1554($ladder; "-")
$rungs:=$rungs.insert(0; "A")
$rung_position:=$rungs.indexOf($letters)
$previous_letters:=$rungs[($rung_position-1)]

$table_name:="Humans_"+$country_code+"_"+$letters
$records:=ds:C1482[$table_name].all()
$nb_total:=$records.length

For each ($record; $records)
	If (($record.full_name>$previous_letters) & ($record.full_name<=$letters))
		$nb_confirmed:=$nb_confirmed+1
	Else 
		$destination_table_name:=Return_human_table_name($country_code; $record.full_name)
		If ($destination_table_name#"")
			$new_record:=ds:C1482[$destination_table_name].new()
			$new_record:=Copy_human($record; $new_record)
			$status:=$new_record.save()
			$status:=$record.drop()
			$nb_reassigned:=$nb_reassigned+1
		End if 
	End if 
	If (Mod:C98($record.indexOf(); 10000)=0)
		$message:=$table_name+"\n"
		$message:=$message+String:C10(($record.indexOf()+1); "### ##0")+" records processed out of "+String:C10($nb_total; "### ##0")+"\n"
		$message:=$message+String:C10($nb_confirmed; "### ##0 records confirmed")+"\n"
		$message:=$message+String:C10($nb_reassigned; "### ##0 records reassigned")
		MESSAGE:C88($message)
	End if 
End for each 

CLEAR VARIABLE:C89($message)
$records_not_dropped:=$records.drop()

$0:=$nb_reassigned
