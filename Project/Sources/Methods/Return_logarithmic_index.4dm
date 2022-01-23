//%attributes = {}



// ----------------------------------------------------
// Method: Return_logarithmic_index
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------
// Modified by: Mike Beatty (11/12/21)

#DECLARE($value : Integer)
C_LONGINT:C283($0)
var $i; $value : Integer
$0:=0

For ($i; 1; 100)
	If ($value<Tab_Log_Value{$i})
		$0:=$i
		$i:=100
	End if 
End for 

If ($0=0)
	$0:=1
End if 