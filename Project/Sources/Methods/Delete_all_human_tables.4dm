//%attributes = {}

// ----------------------------------------------------
// Method: Delete_all_human_tables
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $country; $status : Object
var $nb_tables_deleted : Integer

CONFIRM:C162("Do you really want to delete all human tables? This cannot be reversed.")

If (OK=1)
	
	For each ($country; ds:C1482.Countries.all().orderBy("iso_3 asc"))
		MESSAGE:C88("Deleting humans of country "+$country.iso_3)
		$nb_tables_deleted:=$nb_tables_deleted+Delete_human_tables_by_country($country.iso_3)
	End for each 
	
	MESSAGE:C88(String:C10($nb_tables_deleted; "### ##0")+" tables deleted")
	TRACE:C157
End if 

