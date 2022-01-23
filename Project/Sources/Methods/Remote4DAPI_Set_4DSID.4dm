//%attributes = {"invisible":true,"preemptive":"capable"}
// Remote4DAPI_Set_4DSID ($headerNamesArrPtr; $headerValuesArrPtr)
//
// DESCRIPTION
//   If a 4DSID cookie has been detected previously, then
//   it is added to the header arrays.
//
#DECLARE($headerNamesArrPtr : Pointer; $headerValuesArrPtr : Pointer)
// ----------------------------------------------------
// HISTORY
//   Created by: DB (01/09/2022)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=2)

// Deliberately a process var. An interprocess var should not be used.
var _4DSID_Cookie : Text

If (_4DSID_Cookie#"")
	APPEND TO ARRAY:C911($headerNamesArrPtr->; "Cookie")
	APPEND TO ARRAY:C911($headerValuesArrPtr->; _4DSID_Cookie)
End if 
