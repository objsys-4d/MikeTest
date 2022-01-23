//%attributes = {}

// ----------------------------------------------------
// Method: Create_all_human_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------
// Modified by: Mike Beatty (11/12/21)
var $country; $stats_country; $stats_total : Object
var $Delete_first : Boolean
$stats_total:=New object:C1471()
$stats_total.nb_tables_created:=0
$stats_total.nb_tables_deleted:=0
$stats_country:=New object:C1471()
$stats_country.nb_tables_created:=0
$stats_country.nb_tables_deleted:=0

C_COLLECTION:C1488($countries)

$countries:=BackgroundApi_GetAllCountries()  //ds.country.all()
$Delete_first:=True:C214  // false means we have already deleted the tables
//SQL LOGIN(SQL_INTERNAL; ""; "")` moved into the create method
//SQL EXECUTE($Statement)
//SQL LOGOUT

For each ($country; $countries)
	$bContinue:=True:C214
	Case of 
		: ($country.name_structure="Western")
			$template_number:=2  //table number for western template
			$bContinue:=False:C215
		: ($country.name_structure="Hispanic")
			$template_number:=18  //table number for hispanic template
		Else 
			$bContinue:=False:C215
	End case 
	
	If ($bContinue)
		
		$stats_country:=Create_human_tables_by_country($country.iso_3; $Delete_first; $template_number)
		
		$stats_total.nb_tables_created:=$stats_total.nb_tables_created+$stats_country.nb_tables_created
		$stats_total.nb_tables_deleted:=$stats_total.nb_tables_deleted+$stats_country.nb_tables_deleted
	End if 
End for each 

//SQL LOGIN(SQL_INTERNAL; ""; "")
//SQL EXECUTE($Statement)
//SQL LOGOUT

TRACE:C157