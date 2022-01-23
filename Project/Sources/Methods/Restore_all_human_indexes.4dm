//%attributes = {}

// ----------------------------------------------------
// Method: Restore_all_human_indexes
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------


var $country_code; $prefix; $field_name : Text
var $i; $n; $nb_fields; $nb_tables : Integer

$country_code:="USA"
$prefix:="Humans_"+$country_code+"_@"

ARRAY TEXT:C222($tab_index_name; 0)
APPEND TO ARRAY:C911($tab_index_name; "full_name")
APPEND TO ARRAY:C911($tab_index_name; "middle_name")
APPEND TO ARRAY:C911($tab_index_name; "birth_day")
APPEND TO ARRAY:C911($tab_index_name; "birth_month")
APPEND TO ARRAY:C911($tab_index_name; "birth_year")
APPEND TO ARRAY:C911($tab_index_name; "job_id")

$nb_tables:=Get last table number:C254
For ($i; 1; $nb_tables)
	If (Is table number valid:C999($i))
		If (Table name:C256(Table:C252($i))=$prefix)
			MESSAGE:C88(Table name:C256(Table:C252($i))+"\n"+String:C10($i)+" out of "+String:C10($nb_tables))
			$nb_fields:=Get last field number:C255($i)
			For ($n; 1; $nb_fields)
				If (Is field number valid:C1000($i; $n))
					$field_name:=Field name:C257($i; $n)
					If (Find in array:C230($Tab_index_name; $field_name)>0)
						ARRAY POINTER:C280($field_ptr_array; 1)
						$field_ptr_array{1}:=Field:C253($i; $n)
						CREATE INDEX:C966(Table:C252($i)->; $field_ptr_array; Standard BTree index:K58:3; $field_name)
					End if 
				End if 
			End for 
		End if 
	End if 
End for 