//%attributes = {}

// ----------------------------------------------------
// Method: Merge_adjacent_human_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------


var $absorber; $absorbee; $ladder; $country_code; $table_name_absorber; $table_name_absorbee; $confirm_text; $letters_1; $letters_2; $problem_message : Text
var $nb_records_absorber; $nb_records_absorbee; $nb_records_combined; $position_absorber; $position_absorbee; $i : Integer
var $record; $records; $new_record; $status; $country : Object
var $proceed : Boolean

$country_code:="USA"
$letters_1:="NEI"
$letters_2:="NEM"

// The absorber is always the second of the two tables

If ($letters_1<$letters_2)
	$absorbee:=$letters_1
	$absorber:=$letters_2
Else 
	$absorbee:=$letters_2
	$absorber:=$letters_1
End if 

$country:=ds:C1482.Countries.get($country_code)
$ladder:=$country.ladder
$table_name_absorber:="Humans_"+$country_code+"_"+$absorber
$table_name_absorbee:="Humans_"+$country_code+"_"+$absorbee
$proceed:=True:C214

// We check that both the absorber and absorbee exist and that they are next to each other in the ladder

$position_absorber:=Position:C15("-"+$absorber+"-"; $ladder)
$position_absorbee:=Position:C15("-"+$absorbee+"-"; $ladder)

Case of 
	: ($position_absorber=0)
		$proceed:=False:C215
		$problem_message:="The table "+$table_name_absorber+" doesn't exist"
		
	: ($position_absorbee=0)
		$proceed:=False:C215
		$problem_message:="The table "+$table_name_absorbee+" doesn't exist"
		
	: ($position_absorber#($position_absorbee+Length:C16($absorbee)+1))
		$proceed:=False:C215
		$problem_message:="The table "+$table_name_absorber+" doesn't follow immediately the table "+$table_name_absorbee
End case 

If ($proceed)
	$nb_records_absorber:=ds:C1482[$table_name_absorber].all().length
	$nb_records_absorbee:=ds:C1482[$table_name_absorbee].all().length
	$nb_records_combined:=0
	If (($nb_records_absorber=0) | ($nb_records_absorbee=0))
		$proceed:=False:C215
	End if 
End if 

If ($proceed)
	
	$confirm_text:="Do you really want to merge the table "+$table_name_absorbee
	$confirm_text:=$confirm_text+" ("+String:C10($nb_records_absorbee; "### ##0")+" records)"
	$confirm_text:=$confirm_text+" into "+$table_name_absorber+" ("+String:C10($nb_records_absorber; "### ##0")+" records)?"
	CONFIRM:C162($confirm_text)
	
	If (OK=1)
		$records:=ds:C1482[$table_name_absorbee].all()
		
		For each ($record; $records)
			
			// We copy all data
			$new_record:=ds:C1482[$table_name_absorber].new()
			$new_record:=Copy_human($record; $new_record)
			
			// We save the new record and delete the old one
			$status:=$new_record.save()
			$status:=$record.drop()
			
			If (Mod:C98($record.indexOf(); 10000)=0)
				MESSAGE:C88(String:C10($record.indexOf(); "### ##0")+" records out of "+String:C10($nb_records_absorbee; "### ##0"))
			End if 
		End for each 
		
		// We check that all records have been copied
		$nb_records_combined:=ds:C1482[$table_name_absorber].all().length
		
		If ($nb_records_absorbee+$nb_records_absorber=$nb_records_combined)
			
			// We delete the old table
			For ($i; 1; Get last table number:C254)
				If (Is table number valid:C999($i))
					If (Table name:C256(Table:C252($i))=$table_name_absorbee)
						SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
						SQL EXECUTE:C820("DROP TABLE "+$table_name_absorbee+";")
						SQL LOGOUT:C872
						$i:=Get last table number:C254
					End if 
				End if 
			End for 
			
			// We update the ladder
			$ladder:=Replace string:C233($ladder; $absorbee+"-"; "")
			$country.ladder:=$ladder
			$status:=$country.save()
			
		End if 
	End if 
	
Else 
	MESSAGE:C88($problem_message)
End if 
