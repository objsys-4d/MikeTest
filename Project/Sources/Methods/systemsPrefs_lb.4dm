//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mike Beatty
// Date and time: 11/19/21, 13:49:21
// ----------------------------------------------------
// Method: systemsPrefs_lb
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

C_TEXT:C284($1; $lb_Name)
C_OBJECT:C1216($obj)

$lb_Name:=Current method name:C684

Case of 
		
	: ($1="init")
		
		$obj:=New object:C1471("Name"; $lb_Name)
		$obj.data:=Null:C1517
		$obj.data:=Form:C1466.data_list
		$obj.currentItem:=Null:C1517
		$obj.position:=Null:C1517
		$obj.selected:=Null:C1517
		$obj.meta:=New object:C1471
		
		Form:C1466[$lb_Name]:=$obj
		
		
	Else 
		
End case 