//%attributes = {}

// ----------------------------------------------------
// Method: Return_table_sql_description
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($table_number : Integer)->$description : Object
var $i; $nb_fields; $field_type; $field_length : Integer
var $indexed; $unique; $invisible : Boolean
var $field_name : Text

$description:=New object:C1471
$description.text:=""
$description.index_col:=New collection:C1472()
$nb_fields:=Get last field number:C255($table_number)

For ($i; 1; $nb_fields)
	If (Is field number valid:C1000($table_number; $i))
		$field_name:=Field name:C257($table_number; $i)
		GET FIELD PROPERTIES:C258($table_number; $i; $field_type; $field_length; $indexed; $unique; $invisible)
		Case of 
			: ($field_type=0)
				$description.text:=$description.text+$field_name+" "+"varchar(255), "
			: ($field_type=8)
				$description.text:=$description.text+$field_name+" "+"INT, "
			: ($field_type=9)
				If ($field_name="id")
					$description.text:=$description.text+$field_name+" "+"INT32 AUTO_INCREMENT, "
				Else 
					$description.text:=$description.text+$field_name+" "+"INT32, "
				End if 
			: ($field_type=25)
				$description.text:=$description.text+$field_name+" "+"INT64, "
			: ($field_type=38)
				$description.text:=$description.text+$field_name+" "+"object, "
			: ($field_type=4)
				$description.text:=$description.text+$field_name+" "+"date, "
			: ($field_type=1)
				$description.text:=$description.text+$field_name+" "+"real, "
			: ($field_type=6)
				$description.text:=$description.text+$field_name+" "+"boolean, "
			Else 
				TRACE:C157
		End case 
		If ($indexed)
			$description.index_col.push($field_name)
		End if 
	End if 
End for 
$description.text:=$description.text+"PRIMARY KEY (id)"