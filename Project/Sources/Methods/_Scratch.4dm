//%attributes = {}



$limit:=100000

ALL RECORDS:C47([Humans_USA:237])
FIRST RECORD:C50([Humans_USA:237])
REDUCE SELECTION:C351([Humans_USA:237]; $limit)
$start1:=Current time:C178
For ($i; 1; Records in selection:C76([Humans_USA:237]))
	
	$vtName:=[Humans_USA:237]last_name:2
	
	$esName:=ds:C1482.Humans_USA.query("last_name = :1"; $vtName)
	
	NEXT RECORD:C51([Humans_USA:237])
End for 

$start2:=Current time:C178

$limit:=100000

ALL RECORDS:C47([Humans_USA:237])
FIRST RECORD:C50([Humans_USA:237])
REDUCE SELECTION:C351([Humans_USA:237]; $limit)
$start3:=Current time:C178
For ($i; 1; Records in selection:C76([Humans_USA:237]))
	
	$vtName:=[Humans_USA:237]hash_last_name:4
	
	$esName:=ds:C1482.Humans_USA.query("hash_last_name = :1"; $vtName)
	
	NEXT RECORD:C51([Humans_USA:237])
End for 

$start4:=Current time:C178

