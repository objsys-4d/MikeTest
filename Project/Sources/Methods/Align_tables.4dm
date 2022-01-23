//%attributes = {}

// ----------------------------------------------------
// Method: Align_tables
// Description -- not currently in use, needed
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------



var $initial_left; $initial_top; $width_column; $width_table; $height_row; $height_table; $nb_tables_per_row : Integer
var $i; $beg_table; $beg_coor; $end_coor : Integer
var $fieldPtr : Pointer

var $text_catalog; $table_name; $marker; $old_string; $new_string; $docPath : Text
$initial_left:=20
$initial_top:=1200
$width_column:=170
$width_table:=140
$height_row:=180
$height_table:=150
$nb_tables_per_row:=8


ARRAY TEXT:C222($arSelected; 0)
$docPath:=Select document:C905("/PACKAGE"; "4DCatalog"; "Select the Catalog to modify:"; Use sheet window:K24:11; $arSelected)

If (OK=1)
	$docPath:=$arSelected{1}
	$text_catalog:=Document to text:C1236($docPath; "UTF-8"; Document unchanged:K24:18)
	
	// Modified by: Mike Beatty (10/29/21)
	//removed code referencing other tables, used in other base
	// Human tables
	
	ARRAY TEXT:C222($Tab_table_names; 0)
	
	For ($i; 1; Get last table number:C254)
		If (Is table number valid:C999($i))
			$table_name:=Table name:C256(Table:C252($i))  // Modified by: Mike Beatty (10/29/21)
			If ($table_name="Humans_@")
				APPEND TO ARRAY:C911($Tab_table_names; $table_name)
			End if 
		End if 
	End for 
	
	SORT ARRAY:C229($Tab_table_names; >)
	
	For ($i; 1; Size of array:C274($Tab_table_names))
		
		MESSAGE:C88("Humans tables\n"+$Tab_table_names{$i})
		
		$beg_table:=Position:C15("table name=\""+$Tab_table_names{$i}+"\""; $text_catalog)  // We locate the table in the code
		
		// Left coordinate
		$marker:="left=\""
		$beg_coor:=Position:C15($marker; $text_catalog; $beg_table)+Length:C16($marker)
		$end_coor:=Position:C15("\""; $text_catalog; $beg_coor)
		$old_string:=Substring:C12($text_catalog; $beg_coor; $end_coor-$beg_coor)
		$new_string:=String:C10($initial_left+(2*$width_column)+(Mod:C98(($i-1); ($nb_tables_per_row-2))*$width_column))  // 40 for the first column, 220 for the second one, 400 for the third one, etc.
		$text_catalog:=Delete string:C232($text_catalog; $beg_coor; Length:C16($old_string))
		$text_catalog:=Insert string:C231($text_catalog; $new_string; $beg_coor)
		
		// Top coordinate
		$marker:="top=\""
		$beg_coor:=Position:C15($marker; $text_catalog; $beg_table)+Length:C16($marker)
		$end_coor:=Position:C15("\""; $text_catalog; $beg_coor)
		$old_string:=Substring:C12($text_catalog; $beg_coor; $end_coor-$beg_coor)
		$new_string:=String:C10($initial_top+(Int:C8(($i/($nb_tables_per_row-2)))*$height_row))  // 12 700 for the first 8 tables, 12 920 for the next 8 ones, etc.
		$text_catalog:=Delete string:C232($text_catalog; $beg_coor; Length:C16($old_string))
		$text_catalog:=Insert string:C231($text_catalog; $new_string; $beg_coor)
		
		// Width
		$marker:="width=\""
		$beg_coor:=Position:C15($marker; $text_catalog; $beg_table)+Length:C16($marker)
		$end_coor:=Position:C15("\""; $text_catalog; $beg_coor)
		$old_string:=Substring:C12($text_catalog; $beg_coor; $end_coor-$beg_coor)
		$new_string:=String:C10($width_table)  // same width for all tables
		$text_catalog:=Delete string:C232($text_catalog; $beg_coor; Length:C16($old_string))
		$text_catalog:=Insert string:C231($text_catalog; $new_string; $beg_coor)
		
		// Height
		$marker:="height=\""
		$beg_coor:=Position:C15($marker; $text_catalog; $beg_table)+Length:C16($marker)
		$end_coor:=Position:C15("\""; $text_catalog; $beg_coor)
		$old_string:=Substring:C12($text_catalog; $beg_coor; $end_coor-$beg_coor)
		$new_string:=String:C10($height_table)  // same height for all tables
		$text_catalog:=Delete string:C232($text_catalog; $beg_coor; Length:C16($old_string))
		$text_catalog:=Insert string:C231($text_catalog; $new_string; $beg_coor)
	End for 
	
	
	TEXT TO DOCUMENT:C1237($docPath+"_1"; $text_catalog; "UTF-8")
End if 