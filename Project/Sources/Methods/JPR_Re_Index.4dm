//%attributes = {}


// ----------------------------------------------------
// Method: JPR_Re_Index
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

var $docPath : Text
var $indexList : Collection
var $offset; $tableNum; $fieldNum : Integer
var $fieldPtr : Pointer
var $idx : Object

C_BLOB:C604($blob)
ARRAY TEXT:C222($arSelected; 0)
$docPath:=Select document:C905("/PACKAGE"; "4DCatalog_IDX"; "Select the catalog.4DCatalog_IDX to import:"; Use sheet window:K24:11; $arSelected)
If (OK=1)
	$docPath:=$arSelected{1}
	
	$indexList:=New collection:C1472
	DOCUMENT TO BLOB:C525($docPath; $blob)
	$offset:=0
	BLOB TO VARIABLE:C533($blob; $indexList; $offset)
	If ($indexList.length>0)
		For each ($idx; $indexList)
			$tableNum:=$idx.tableNb
			$fieldNum:=$idx.fieldNb
			$fieldPtr:=Field:C253($tableNum; $fieldNum)
			SET INDEX:C344($fieldPtr->; True:C214)
		End for each 
	End if 
End if 