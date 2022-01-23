//%attributes = {}


// ----------------------------------------------------
// Method: Delete_human_tables_by_country
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text)
var $statement; $table_name_to_compare : Text
var $0; $nb_tables_deleted; $i : Integer

If (Count parameters:C259=0)
	$country_code:="USA"
End if 

$table_name_to_compare:="Humans_"+$country_code  //+"_@"

For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		If (Table name:C256(Table:C252($i))=$table_name_to_compare)
			$Statement:="DROP TABLE "+Table name:C256(Table:C252($i))+";"
			SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
			SQL EXECUTE:C820($Statement)
			SQL LOGOUT:C872
			$nb_tables_deleted:=$nb_tables_deleted+1
		End if 
	End if 
End for 

If (Count parameters:C259=1)
	$0:=$nb_tables_deleted
End if 
