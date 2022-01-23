//%attributes = {"invisible":true,"preemptive":"capable"}
// HttpResponse_SetHeaderValue (httpRequest; header_name; value)
//
// DESCRIPTION
//   Sets the HTTP header to the specified value.
//
#DECLARE($httpRequest : Object; $header_name : Text; $value : Text)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=3)

var $header : Object
Case of 
	: ($httpRequest=Null:C1517)
	: ($httpRequest.response=Null:C1517)
	: ($httpRequest.response.headers=Null:C1517)
	: ($httpRequest.response.headers.query("name=:1"; $header_name).length=1)
		$header:=$httpRequest.response.headers.query("name=:1"; $header_name)[0]
		$header.value:=$value
		
	Else 
		$header:=New object:C1471
		$header.name:=$header_name
		$header.value:=$value
		$httpRequest.response.headers.push($header)
End case 