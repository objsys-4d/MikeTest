//%attributes = {}


// ----------------------------------------------------
// Method: Random_integer
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------


// $1 is the minimum, $2 the maximum

C_LONGINT:C283($1; $2; $0)  // Modified by: Mike Beatty (10/29/21)

$0:=(Random:C100%($2-$1+1))+$1