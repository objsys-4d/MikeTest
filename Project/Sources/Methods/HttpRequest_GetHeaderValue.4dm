//%attributes = {"invisible":true,"preemptive":"capable"}
// HttpRequest_GetHeaderValue (httpRequest;requestedHeader) : value
//
// DESCRIPTION
//   returns the value for the named header.
//
#DECLARE($httpRequest : Object; $header_name : Text)->$value : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/26/2021)
// ----------------------------------------------------
$value:=""

Case of 
	: ($httpRequest=Null:C1517)
	: ($httpRequest.headers=Null:C1517)
	: ($httpRequest.headers.length=0)
	Else 
		var $matching_values_list : Collection
		$matching_values_list:=$httpRequest.headers.query("name=:1"; $header_name)
		If ($matching_values_list.length>0)
			$value:=$matching_values_list[0].value
		End if 
End case 