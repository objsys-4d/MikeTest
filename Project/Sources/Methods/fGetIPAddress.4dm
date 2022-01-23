//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mike Beatty
// Date and time: 11/19/21, 15:15:09
// ----------------------------------------------------
// Method: fGetIPAddress
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------


#DECLARE($string : Text)->$ipAddress : Text
var $objSystem : Object
var $colinterfaces : Collection
var $i : Integer

$objSystem:=Get system info:C1571

If ($objSystem.networkInterfaces#Null:C1517)
	
	$colinterfaces:=$objSystem.networkInterfaces
	For each ($loopInterface; $colinterfaces)
		ARRAY OBJECT:C1221($aoArray; 0)
		OB GET ARRAY:C1229($loopInterface; "ipAddresses"; $aoArray)
		
		For ($i; 1; Size of array:C274($aoArray))
			
			If ($aoArray{$i}.type="ipv4")
				$ipAddress:=$aoArray{$i}.ip
			End if 
			
		End for 
		
	End for each 
	
End if 