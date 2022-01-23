//%attributes = {}

// ----------------------------------------------------
// Method: JPR_Transform
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

C_POINTER:C301($fieldPtr)

ARRAY TEXT:C222($atSelected; 0)

var $docPath; $objectMarker; $atrName; $line; $lineBefore; $linebeforeEnd; $lineBeforeStart; $name; $source; $result; $loopDataStore : Text
var $objDataStore; $dcInfo; $dcAttribute; $idx; $dataClass : Object
var $l1; $l2; $pos; $index : Integer
var $colindexList; $colLines : Collection


$docPath:=Select document:C905("/PACKAGE"; "4DCatalog"; "Select the Catalog to modify:"; Use sheet window:K24:11; $atSelected)
If (OK=1)
	$docPath:=$atSelected{1}
	
	$objectMarker:="_OBJ_"
	$colindexList:=New collection:C1472
	
	$objDataStore:=ds:C1482
	For each ($loopDataStore; $objDataStore)  //Getting the list of objects-to-be indexes
		$dataClass:=$objDataStore[$loopDataStore]
		$dcInfo:=$dataClass.getInfo()
		For each ($atrName; $dataClass)
			$dcAttribute:=$dataClass[$atrName]
			$name:=$dcAttribute.name
			If ($name=("@"+$objectMarker))
				If ($dcAttribute.indexed)
					$idx:=New object:C1471("tableNb"; $dcInfo.tableNumber; "fieldNb"; $dcAttribute.fieldNumber)
					$colindexList.push($idx)
				End if 
			End if 
		End for each 
	End for each 
	
	$l1:=Length:C16("\" uuid=\"0089B08FF6BE4AA2BD0FF4894D8A3261\" ")  //To skip before Field Type
	$l2:=Length:C16("uuid=\"6D0DFB2FDDCD457195C4781B051199D7\" type=\"7\">\n\t\t<field_ref uuid=\"3B5E191550B74D8BB8D4A26920288B02\" name=\"bundled_name")  //To skip before Index Type
	
	$source:=Document to text:C1236($docPath; "UTF-8"; Document unchanged:K24:18)
	$colLines:=New collection:C1472
	$colLines:=Split string:C1554($source; $objectMarker)
	$index:=0
	For each ($line; $colLines)
		$pos:=Position:C15("type=\"10\""; $line)
		If ($pos>0)
			If ($pos<($l1+10))  //This is a field definition
				$colLines[$index]:=Replace string:C233($line; "type=\"10\""; "type=\"21\""; 1)
			End if 
		Else 
			If ($index>0)
				$lineBefore:=$colLines[$index-1]
				$lineBeforeStart:=Substring:C12($lineBefore; 1; Length:C16($lineBefore)-$l2)
				$linebeforeEnd:=Substring:C12($lineBefore; Length:C16($lineBefore)-$l2+1)
				$pos:=Position:C15("type=\"7\""; $linebeforeEnd)
				If ($pos>0)
					$linebeforeEnd:=Replace string:C233($linebeforeEnd; "type=\"7\""; "type=\"3\""; 1)
					$colLines[$index-1]:=$lineBeforeStart+$linebeforeEnd
				End if 
				//3
			End if 
		End if 
		$index:=$index+1
	End for each 
	$result:=$colLines.join("")
	TEXT TO DOCUMENT:C1237($docPath+"_1"; $result; "UTF-8")
	
	C_BLOB:C604($blob)
	VARIABLE TO BLOB:C532($colindexList; $blob)
	BLOB TO DOCUMENT:C526($docPath+"_IDX"; $blob)
End if 