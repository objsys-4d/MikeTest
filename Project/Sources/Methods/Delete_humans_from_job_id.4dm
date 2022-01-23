//%attributes = {}

// ----------------------------------------------------
// Method: Delete_humans_from_job_id
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $job_id; $nb_tables; $nb_records_deleted; $i : Integer
var $status; $records_to_delete; $job : Object
var $table_name; $message : Text

$job_id:=504
$job:=ds:C1482.Jobs.get($job_id)

If ($job=Null:C1517)  // We check that the job exists
	
	MESSAGE:C88("There is no job # "+String:C10($job_id))
	TRACE:C157
	
Else   // If it does, we set aside all the "Humans_" tables
	
	$nb_tables:=Get last table number:C254
	ARRAY TEXT:C222($tab_table_names; 0)
	For ($i; 1; $nb_tables)
		If (Is table number valid:C999($i))
			$table_name:=Table name:C256(Table:C252($i))
			If ($table_name="Humans_@")
				APPEND TO ARRAY:C911($tab_table_names; $table_name)
			End if 
		End if 
	End for 
	
	// We take the tables one by one and delete the humans stemming from the job id
	For ($i; 1; Size of array:C274($tab_table_names))
		$records_to_delete:=ds:C1482[$tab_table_names{$i}].query("job_id=:1"; $job_id)
		$nb_records_deleted:=$nb_records_deleted+$records_to_delete.length
		$records_to_delete.drop()
		$message:="Table "+String:C10($i)+" out of "+String:C10(Size of array:C274($tab_table_names); "### ##0")+"\n"
		$message:=$message+String:C10($nb_records_deleted; "### ### ##0")+" humans deleted"
		MESSAGE:C88($message)
	End for 
	
	// Then we can delete the job itself
	$status:=$job.drop()
	
	$message:="Job "+String:C10($job_id; "### ##0")+" deleted\n"
	$message:=$message+String:C10($nb_records_deleted; "### ### ##0")+" humans deleted"
	MESSAGE:C88($message)
	
End if 

TRACE:C157

