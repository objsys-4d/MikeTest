//%attributes = {}

// ----------------------------------------------------
// Method: Clean_name
// Description - not called direclty
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($name : Text)  // We receive the last name and clean if of all impurities like JR., PhD, Mrs, etc.
var $0; $namebefore; $lastletters; $lastcharacter : Text
var $i; $line : Integer

// We get rid of the unnecessary first and last spaces, points, commas and semi-columns

$0:=$name

If (Substring:C12($0; 1; 1)="")
	$0:=Substring:C12($0; 2)
End if 
If (Substring:C12($0; Length:C16($0); 1)=" ")
	$0:=Substring:C12($0; 1; Length:C16($0)-1)
End if 
If (Position:C15(Char:C90(34); $0)>0)
	$0:=Replace string:C233($0; Char:C90(34); "")
End if 
If (Position:C15("."; $0)>0)
	$0:=Replace string:C233($0; "."; "")
End if 
If (Position:C15(","; $0)>0)
	$0:=Replace string:C233($0; ","; "")
End if 
If (Position:C15(":"; $0)>0)
	$0:=Replace string:C233($0; ":"; "")
End if 
If (Position:C15(";"; $0)>0)
	$0:=Replace string:C233($0; ";"; "")
End if 


