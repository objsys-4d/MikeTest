//%attributes = {}

// ----------------------------------------------------
// Method: Return_table_number_from_name
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($table_name : Text)->$table_id : Integer
var $i : Integer

For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		If (Table name:C256($i)=$table_name)
			$table_id:=$i
			$i:=Get last table number:C254
		End if 
	End if 
End for 

