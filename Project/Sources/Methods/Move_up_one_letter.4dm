//%attributes = {}


C_TEXT:C284($0; $1; $string)
C_COLLECTION:C1488($col_letters; $col_string)
var $i : Integer

$string:=$1
$col_letters:=New collection:C1472(""; "A"; "B"; "C"; "D"; "E"; "F"; "G"; "H"; "I"; "J"; "K"; "L"; "M"; "N"; "O"; "P"; "Q"; "R"; "S"; "T"; "U"; "V"; "W"; "X"; "Y"; "Z")
$col_string:=Split string:C1554($string; "")

For ($i; (Length:C16($string)-1); 0; -1)
	Case of 
		: ($col_string[$i]<"z")
			$col_string[$i]:=$col_letters[($col_letters.indexOf($col_string[$i])+1)]
			$i:=0
			
		: ($col_string[$i]="z")
			$col_string[$i]:=""
	End case 
End for 

For ($i; 0; ($col_string.length-1))
	$0:=$0+$col_string[$i]
End for 

