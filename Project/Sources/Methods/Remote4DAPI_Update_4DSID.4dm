//%attributes = {"invisible":true,"preemptive":"capable"}
// Remote4DAPI_Update_4DSID ($headerNamesArrPtr; $headerValuesArrPtr)
//
// DESCRIPTION
//   Checks the header arrays to see if a 4DSID cookie has been
//   returned, it updated the previously defined one if different.
//
#DECLARE($headerNamesArrPtr : Pointer; $headerValuesArrPtr : Pointer)
// ----------------------------------------------------
// HISTORY
//   Created by: DB (01/09/2022)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=2)

// Deliberately a process var. An interprocess var should not be used.
var _4DSID_Cookie : Text

var $new_4DSID_Cookie : Text
If (Find in array:C230($headerValuesArrPtr->; "@4DSID_@")>0)
	$new_4DSID_Cookie:=$headerValuesArrPtr->{Find in array:C230($headerValuesArrPtr->; "@4DSID_@")}
	$new_4DSID_Cookie:=Split string:C1554($new_4DSID_Cookie; ";")[0]
End if 

// update if different
If (_4DSID_Cookie#$new_4DSID_Cookie)
	_4DSID_Cookie:=$new_4DSID_Cookie
End if 