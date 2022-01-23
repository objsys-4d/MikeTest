//%attributes = {}

// ----------------------------------------------------
// Method: Set_up_table_and_ladder
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text; $cutoff : Text; $old_cutoff : Text)
var $t0; $t1; $elapsed; $generic_table_number; $nb_fields; $field_type; $field_length; $position_old_cutoff; $nb_fields_generic; $i : Integer
var $table_name; $country_code; $description; $ladder; $field_name; $status : Text
var $0; $indexed; $unique; $invisible : Boolean
var $ladder_col : Collection
var $country; $stats : Object
$generic_table_number:=-1  //Table(->)  // Modified by: Mike Beatty (10/29/21), was previous [Countries]?
$nb_fields_generic:=Get last field number:C255($generic_table_number)
$table_name:="Humans_"+$country_code+"_"+$cutoff
ARRAY TEXT:C222($Tab_index_name; 0)

// We check for two things:
// - does the table already exist? If not, we create it.
// - is the table included in the country ladder? If not, we insert it


If (Table_does_not_exist($table_name))
	
	// We map out the generic table so we can duplicate it
	
	For ($i; 1; $nb_fields_generic)
		If (Is field number valid:C1000($generic_table_number; $i))
			$field_name:=Field name:C257($generic_table_number; $i)
			GET FIELD PROPERTIES:C258($generic_table_number; $i; $field_type; $field_length; $indexed; $unique; $invisible)
			Case of 
				: ($field_type=0)
					$description:=$description+$field_name+" "+"varchar(255),"
				: ($field_type=8)
					$description:=$description+$field_name+" "+"INT,"
				: ($field_type=9)
					If ($field_name="id")
						$description:=$description+$field_name+" "+"INT32 AUTO_INCREMENT,"
					Else 
						$description:=$description+$field_name+" "+"INT32,"
					End if 
				: ($field_type=25)
					$description:=$description+$field_name+" "+"INT64,"
				: ($field_type=4)
					$description:=$description+$field_name+" "+"date,"
				: ($field_type=1)
					$description:=$description+$field_name+" "+"real,"
				: ($field_type=6)
					$description:=$description+$field_name+" "+"boolean,"
				Else 
					TRACE:C157
			End case 
			If ($indexed)
				APPEND TO ARRAY:C911($Tab_index_name; $field_name)
			End if 
		End if 
	End for 
	$description:=$description+"PRIMARY KEY (id)"
	
	// We create the table
	
	SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
	SQL EXECUTE:C820("CREATE TABLE "+$table_name+" ("+$description+");")
	SQL LOGOUT:C872
	
	// We create the new indexes
	
	Restore_all_human_indexes
	
	If (Table_is_not_present_in_ladder($country_code; $cutoff))
		
		// We update the ladder
		$country:=ds:C1482.Countries.get($country_code)
		$ladder:=$country.ladder
		$position_old_cutoff:=Position:C15("-"+$old_cutoff+"-"; $ladder)
		$country.ladder:=Insert string:C231($ladder; $cutoff+"-"; ($position_old_cutoff+1))
		$status:=$country.save()
		
	End if 
	
	// Last verification: do the ladder and the table structure match exactly?
	
	$0:=Check_ladder_integrity($country_code)
	
End if 