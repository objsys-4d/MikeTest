//%attributes = {}

// ----------------------------------------------------
// Method: Sample_names
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($table_name : Text; $field_name : Text; $country_code : Text; $sample_size : Integer)
var $records; $record : Object
var $nb_tested; $nb_valid : Integer
var $0 : Object

$0:=New object:C1471()
$0.ratio:=0
$0.size:=0

$records:=ds:C1482[$table_name].all().slice(0; $sample_size)

Case of 
	: ($field_name="first_name")
		$table_name:="First_name_sex_"+$country_code
		$nb_tested:=0
		$nb_valid:=0
		
		For each ($record; $records)
			$nb_tested:=$nb_tested+1
			If (ds:C1482[$table_name].query("firstname=:1"; $record.first_name).length>0)
				$nb_valid:=$nb_valid+1
			End if 
		End for each 
		
	: ($field_name="last_name")
		$table_name:="Last_name_"+$country_code
		$nb_tested:=0
		$nb_valid:=0
		
		For each ($record; $records)
			$nb_tested:=$nb_tested+1
			If (ds:C1482[$table_name].query("lastname=:1"; $record.last_name).length>0)
				$nb_valid:=$nb_valid+1
			End if 
		End for each 
End case 

If ($nb_tested>0)
	$0.size:=$nb_tested
	$0.ratio:=$nb_valid/$nb_tested
End if 
