//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mike Beatty
// Date and time: 11/19/21, 16:10:07
// ----------------------------------------------------
// Method: ds_ConnectTest
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------


//C_OBJECT()

var dsBackground; dsImport; dsRepository : Object

$currentBasePath:=Get 4D folder:C485(Database folder:K5:14)



Case of 
	: ($currentBasePath="@import@")
		
		dsBackground:=ds_Connect("background")
		dsRepository:=ds_Connect("repository")
		
	: ($currentBasePath="@background@")
		
		dsImport:=ds_Connect("import")
		dsRepository:=ds_Connect("repository")
		
	: ($currentBasePath="@repository@")
		
		dsBackground:=ds_Connect("background")
		dsImport:=ds_Connect("import")
		
	Else 
		
End case 









