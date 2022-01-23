//%attributes = {}
//%attributes = {}


// ----------------------------------------------------
// Method: Create_human_tables_by_country
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------
// Modified by: Mike Beatty (11/12/21)

#DECLARE($country_code : Text; $delete_first : Boolean; $template_number : Integer)->$stats : Object
var $t0; $t1; $elapsed; $generic_table_number; $nb_fields; $nb_fields_generic; $field_type; $field_length; $n; $new_table_ID : Integer
var $indexed; $unique; $invisible; $Delete_first : Boolean

var $country; $description : Object
var $table_name; $country_code; $Statement; $ladder : Text

var $ladder_col : Collection
ARRAY TEXT:C222($Tab_index_name; 0)
$generic_table_number:=$template_number  //250  //Table(->)  // Modified by: Mike Beatty (10/29/21), was previous [Countries]?
$nb_fields_generic:=Get last field number:C255($generic_table_number)
If (Count parameters:C259=0)
	$country_code:="FRA"
	$delete_first:=True:C214
End if 
//$country:=ds.country.get($country_code)
$stats:=New object:C1471()
$stats.nb_tables_created:=0
$stats.nb_tables_deleted:=0
$t0:=Milliseconds:C459

//// First, we delete all the existing tables with the country name

If ($Delete_first)
	$stats.nb_tables_deleted:=$stats.nb_tables_deleted+Delete_human_tables_by_country($country_code)
End if 

// We map out the generic table so we can duplicate it
$description:=Return_table_sql_description($generic_table_number)

// We determine how many tables we're going to need by using the country's ladder field
//$ladder:=$country.ladder
//$ladder_col:=Split string($ladder; "-")

//For ($n; 0; $ladder_col.length-1)
//MESSAGE($country_code+" - "+String($n+1)+"/"+String($ladder_col.length))
$table_name:="Humans_"+$country_code  //+"_"+$ladder_col[$n]
$Statement:="CREATE TABLE "+$table_name+" ("+$description.text+");"
$stats.nb_tables_created:=$stats.nb_tables_created+1

ARRAY TEXT:C222($atTables; 0)
ARRAY LONGINT:C221($alTableNum; 0)
GET TABLE TITLES:C803($atTables; $alTableNum)

If (Find in array:C230($atTables; $table_name)=-1)
	SQL LOGIN:C817(SQL_INTERNAL:K49:11; ""; "")
	SQL EXECUTE:C820($Statement)
	
	SQL CANCEL LOAD:C824
	SQL LOGOUT:C872
End if 
// We retrieve the number of the newly created table
$new_table_ID:=Return_table_number_from_name($table_name)

// We build the indexes of the new table (based on those of the generic table)
Build_table_indexes_from_coll($new_table_ID; $description.index_col)
//End for 

$t1:=Milliseconds:C459
$elapsed:=$t1-$t0
