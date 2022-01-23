//%attributes = {}


// ----------------------------------------------------
// Method: Alter_all_humans_tables
// Description -- not currently in use, needed
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $country; $countries; $status : Object
var $i; $n : Integer
var $table_name; $Statement : Text

For ($i; 1; Get last table number:C254)
	
	$table_name:=Table name:C256(Table:C252($i))
	
	If ($table_name="Humans_@")
		
		For ($n; 1; Get last field number:C255($i))
			
			If (Field name:C257($i; $n)="note")
				$Statement:="ALTER TABLE "+$table_name+" DROP note"
				SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
				SQL EXECUTE:C820($Statement)
				SQL LOGOUT:C872
			End if 
		End for 
	End if 
End for 