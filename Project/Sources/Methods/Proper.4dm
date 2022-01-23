//%attributes = {}

// ----------------------------------------------------
// Method: Proper
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($string : Text)->$proper_string : Text
var $i; $starting_point; $pos : Integer
var $character_to_find : Text

// We initialize the first letter of each word (first character of the string, or every character coming after a space or an hyphen

If (Length:C16($string)>1)
	$string:=Lowercase:C14($string)
	$string[[1]]:=Uppercase:C13($string[[1]])
	$starting_point:=1
	$character_to_find:=" "
	Repeat 
		$pos:=Position:C15($character_to_find; $string; $starting_point)
		If ($pos>0)
			$string[[$pos+1]]:=Uppercase:C13($string[[$pos+1]])
			$starting_point:=$pos+1
		End if 
	Until ($pos=0)
	
	$starting_point:=1
	$character_to_find:="-"
	Repeat 
		$pos:=Position:C15($character_to_find; $string; $starting_point)
		If ($pos>0)
			If ($pos#Length:C16($string))
				$string[[$pos+1]]:=Uppercase:C13($string[[$pos+1]])
			End if 
			$starting_point:=$pos+1
		End if 
	Until ($pos=0)
End if 

$proper_string:=$string