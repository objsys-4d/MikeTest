//%attributes = {}


// ----------------------------------------------------
// Method: Table_does_not_exist
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($table_name : Text)
var $nb_tables; $i : Integer
var $0 : Boolean
$0:=True:C214

$nb_tables:=Get last table number:C254

For ($i; 1; $nb_tables)
	If (Is table number valid:C999($i))
		If (Table name:C256($i)=$table_name)
			$0:=False:C215
			$i:=$nb_tables
		End if 
	End if 
End for 
