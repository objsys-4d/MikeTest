//%attributes = {"invisible":true,"preemptive":"capable"}
// OnErr_GetLastErrorMessages () : errorMessages
//
// DESCRIPTION
//   Returns the text of the last error encountered.
//
var $0 : Text
// ----------------------------------------------------

$0:=""

C_LONGINT:C283($i)
For ($i; 1; Size of array:C274(gErrorTextArr))
	If ($i#1)
		$0:=$0+Char:C90(Carriage return:K15:38)
	End if 
	$0:=$0+gErrorTextArr{$i}
End for 
