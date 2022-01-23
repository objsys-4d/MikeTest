//%attributes = {}
//ds_Connect()
//Created by: Kirk as Designer, Created: 10/29/21, 07:43:20
//------------------
//Purpose: at the moment we only seem to ever connect to one external ds.
//This may change
//see: On Startup


#DECLARE($connect_to : Text)->$ds : Object
var $params : Object
var $ds_name_t; $storage_attr_t : Text
If (Count parameters:C259>0)
	$ds_name_t:=$connect_to
Else 
	$ds_name_t:="Background"
End if 
$storage_attr_t:=Lowercase:C14($ds_name_t)

// --------------------------------------------------------
$params:=New object:C1471("type"; "4D Server"; "hostname"; Storage:C1525[$storage_attr_t].ip_address+":"+Storage:C1525[$storage_attr_t].port)
$ds:=Open datastore:C1452($params; $ds_name_t)