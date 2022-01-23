//%attributes = {}
#DECLARE($country_code : Text; $rung : Text)
var $ladder_col : Collection
var $ladder; $0 : Text
var $pos : Integer

$ladder:=ds:C1482.Countries.get($country_code).ladder
$ladder_col:=Split string:C1554($ladder; "-")
$pos:=$ladder_col.indexOf($rung)
If ($pos>0)
	$0:=$ladder_col[($pos-1)]
Else 
	$0:="A"
End if 