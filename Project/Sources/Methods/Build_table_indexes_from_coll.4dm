//%attributes = {}

// ----------------------------------------------------
// Method: Build_table_indexes_from_coll
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($table_id : Integer; $index_col : Collection)
var $i : Integer
var $field_name : Text

For ($i; 1; Get last field number:C255($table_id))
	If (Is field number valid:C1000($table_id; $i))
		$field_name:=Field name:C257($table_id; $i)
		If ($index_col.indexOf($field_name)#-1)
			ARRAY POINTER:C280($field_ptr_array; 1)
			$field_ptr_array{1}:=Field:C253($table_id; $i)
			CREATE INDEX:C966(Table:C252($table_id)->; $field_ptr_array; Standard BTree index:K58:3; $field_name)
		End if 
	End if 
End for 

