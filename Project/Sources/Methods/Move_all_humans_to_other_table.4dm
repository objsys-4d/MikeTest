//%attributes = {}

// ----------------------------------------------------
// Method: Move_all_humans_to_other_table
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

C_OBJECT:C1216($records; $record; $new_record; $status)
C_LONGINT:C283($nb_records_from; $nb_records_to)
C_TEXT:C284($table_from; $table_to)

$table_from:="Humans_USA_HEQ"
$table_to:="Humans_USA_HEP"

$nb_records_from:=ds:C1482[$table_from].all().length
$nb_records_to:=ds:C1482[$table_to].all().length

$records:=ds:C1482[$table_from].all()

For each ($record; $records)
	
	$new_record:=ds:C1482[$table_to].new()
	
	// We copy all data
	$new_record:=Copy_human($record; $new_record)
	
	// We save the new record and delete the old one
	$status:=$new_record.save()
	$status:=$record.drop()
	
End for each 

$nb_records_from:=ds:C1482[$table_from].all().length
$nb_records_to:=ds:C1482[$table_to].all().length

TRACE:C157
