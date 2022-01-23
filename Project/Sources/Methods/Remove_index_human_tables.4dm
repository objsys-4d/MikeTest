//%attributes = {}

// ----------------------------------------------------
// Method: Remove_index_human_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

C_TEXT:C284($country_code; $ladder; $field_name; $table_name)
C_LONGINT:C283($i; $nb_tables; $n)
$country_code:="USA"

For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		If (Position:C15("Humans_"+$country_code+"_"; Table name:C256(Table:C252($i)))>0)
			
			For ($n; 1; Get last field number:C255($i))
				If (Is field number valid:C1000($i; $n))
					$field_name:=Field name:C257($i; $n)
					
					Case of 
						: ($field_name="birth_day")
							DELETE INDEX:C967(Field:C253($i; $n))
							
						: ($field_name="birth_month")
							DELETE INDEX:C967(Field:C253($i; $n))
							
						: ($field_name="birth_year")
							DELETE INDEX:C967(Field:C253($i; $n))
					End case 
				End if 
			End for 
		End if 
	End if 
End for 
