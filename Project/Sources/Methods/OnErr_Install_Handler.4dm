//%attributes = {"invisible":true,"preemptive":"capable"}
// OnErr_Install_Handler ({errorHandlerMethodName})
// OnErr_Install_Handler ({text})
//
// DESCRIPTION
//   If a errorHandlerMethodName is specified, then the
//   "ON ERR CALL" method is called with that value.
//
//   If no parms are passed, then the previous handler
//   is restored.
//
var $1; $errorHandlerMethodName : Text  // optional
// ----------------------------------------------------
// HISTORY
//   Created by: Dani Beaubien (11/02/2018)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259<=1)
If (Count parameters:C259=1)
	$errorHandlerMethodName:=$1
End if 

var _OnErr_initd : Boolean
If (Not:C34(_OnErr_initd))
	_OnErr_initd:=True:C214
	ARRAY TEXT:C222(_OnErr_methodStack; 0)
End if 

If ($errorHandlerMethodName#"")  // add new one to the stack
	OnErr_Clear
	APPEND TO ARRAY:C911(_OnErr_methodStack; $errorHandlerMethodName)
	
Else   // remove top item from stack, set the previous one
	
	If (Size of array:C274(_OnErr_methodStack)>0)  // reduce the stack by 1
		DELETE FROM ARRAY:C228(_OnErr_methodStack; Size of array:C274(_OnErr_methodStack); 1)
	End if 
	
	If (Size of array:C274(_OnErr_methodStack)>0)  // get the previous handler if there is one
		$errorHandlerMethodName:=_OnErr_methodStack{Size of array:C274(_OnErr_methodStack)}
	End if 
End if 

ON ERR CALL:C155($errorHandlerMethodName)