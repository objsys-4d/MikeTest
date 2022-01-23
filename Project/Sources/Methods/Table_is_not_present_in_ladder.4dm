//%attributes = {}

// ----------------------------------------------------
// Method: Table_is_not_present_in_ladder
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($country_code : Text; $cutoff : Text)
var $position : Integer
var $ladder : Text
var $0 : Boolean

$ladder:=ds:C1482.Countries.get($country_code).ladder

$0:=(Position:C15("-"+$cutoff+"-"; $ladder)=0)
If ($0=True:C214)
	$0:=(Position:C15($cutoff+"-"; $ladder)#1)
End if 



