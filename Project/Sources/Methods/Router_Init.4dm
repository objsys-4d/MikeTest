//%attributes = {"invisible":true,"preemptive":"capable"}
// Router_Init ({forceRefresh})
//
// DESCRIPTION
//   Initializes the necessary variables for this module.
//
var $1; $forceRefresh : Boolean  // if true, then it forces a reset
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259>=0)
ASSERT:C1129(Count parameters:C259<=1)
If (Count parameters:C259=1)
	$forceRefresh:=$1
End if 

If (Storage:C1525.routes=Null:C1517) | ($forceRefresh)
	Use (Storage:C1525)
		Storage:C1525.routes:=New shared collection:C1527
	End use 
	
	
	// ################################################
	// Defined URL routes
	// ################################################
	Router_AddUrlCallback_GET("/"; "Controller_MainPage")
	Router_AddUrlCallback_POST("/search_results"; "Controller_SearchResults")
End if 